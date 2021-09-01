// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display the backtrace of stacks.", mon_backtrace},
	{ "showmappings", "Display mapping information", mon_showmappings}
};

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;
		
	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
    	int ebp,eip;    	
    	struct Eipdebuginfo info;
    	
    	cprintf("Stack backtrace:\n");
    	
    	//get ebp
	ebp=read_ebp();
    	
    	while(ebp!=0){
    		eip=*((int *)ebp+1);
    		cprintf("ebp %08x eip %08x args %08x %08x %08x %08x %08x\n",
    			 ebp,eip,*((int *)ebp+2),*((int *)ebp+3),*((int *)ebp+4),*((int *)ebp+5),*((int *)ebp+6));
    		int result=debuginfo_eip(eip,&info);
    		if(result!=0){//-1
    			cprintf("failed to get debuginfo for eip\n");
    		}
    		else{
    			cprintf("%s:%d: %.*s+%d\n",info.eip_file,info.eip_line,info.eip_fn_namelen,info.eip_fn_name,eip-info.eip_fn_addr);
    		}
    		ebp=*((int *)ebp);
    	}    
	return 0;
}


int
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
	//check paramter
	if(argc<3){
		cprintf("Require 2 virtual address!\n");
		return -1;
	}
	//long int strtol(const char *nptr,char **endptr,int base);
	//string to int
	char *err_char;
	uint32_t begin=strtol(argv[1],&err_char,16);
	if(*err_char){
		cprintf("Invalid begin address: %s\n",argv[1]);
		return -1;
	}
	uint32_t end=strtol(argv[2],&err_char,16);
	if(*err_char){
		cprintf("Invalid end address: %s\n",argv[2]);
		return -1;
	}
	
	if(begin>end){
		cprintf("Params Error: begin address > end address!\n");
		return -1;
	}	
	
	//alian as PGSIZE
	begin=ROUNDDOWN(begin,PGSIZE);
	end=ROUNDUP(end,PGSIZE);
	
	for(;begin<=end;begin+=PGSIZE){
		pte_t *pte=pgdir_walk(kern_pgdir,(void *)begin,0);
		if(!pte||!(*pte&PTE_P)){
			cprintf("Virtual Address: %08x-not mapped\n",begin);
		}
		else{
			cprintf("Virtual Address: %08x, Physical Address: %08x, ",
				begin,PTE_ADDR(*pte));
			char perm_ps=(*pte&PTE_PS)?'S':'-';
			char perm_w=(*pte&PTE_W)?'W':'-';
			char perm_u=(*pte&PTE_U)?'U':'-';
			cprintf("permission: -%c----%c%cP\n", perm_ps,perm_u,perm_w);
			
		}
	}
	
	return 0;
}


/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);
	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
