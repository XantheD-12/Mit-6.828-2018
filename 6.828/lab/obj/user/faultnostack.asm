
obj/user/faultnostack.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 27 00 00 00       	call   800058 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003d:	68 a1 03 80 00       	push   $0x8003a1
  800042:	6a 00                	push   $0x0
  800044:	e8 a6 02 00 00       	call   8002ef <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800049:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800050:	00 00 00 
}
  800053:	83 c4 10             	add    $0x10,%esp
  800056:	c9                   	leave  
  800057:	c3                   	ret    

00800058 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800058:	f3 0f 1e fb          	endbr32 
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	56                   	push   %esi
  800060:	53                   	push   %ebx
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800067:	e8 de 00 00 00       	call   80014a <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 db                	test   %ebx,%ebx
  800080:	7e 07                	jle    800089 <libmain+0x31>
		binaryname = argv[0];
  800082:	8b 06                	mov    (%esi),%eax
  800084:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	56                   	push   %esi
  80008d:	53                   	push   %ebx
  80008e:	e8 a0 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800093:	e8 0a 00 00 00       	call   8000a2 <exit>
}
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5e                   	pop    %esi
  8000a0:	5d                   	pop    %ebp
  8000a1:	c3                   	ret    

008000a2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a2:	f3 0f 1e fb          	endbr32 
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 03 05 00 00       	call   8005b4 <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 4a 00 00 00       	call   800105 <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c0:	f3 0f 1e fb          	endbr32 
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d5:	89 c3                	mov    %eax,%ebx
  8000d7:	89 c7                	mov    %eax,%edi
  8000d9:	89 c6                	mov    %eax,%esi
  8000db:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    

008000e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e2:	f3 0f 1e fb          	endbr32 
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	57                   	push   %edi
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f6:	89 d1                	mov    %edx,%ecx
  8000f8:	89 d3                	mov    %edx,%ebx
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	89 d6                	mov    %edx,%esi
  8000fe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    

00800105 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800105:	f3 0f 1e fb          	endbr32 
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	57                   	push   %edi
  80010d:	56                   	push   %esi
  80010e:	53                   	push   %ebx
  80010f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800112:	b9 00 00 00 00       	mov    $0x0,%ecx
  800117:	8b 55 08             	mov    0x8(%ebp),%edx
  80011a:	b8 03 00 00 00       	mov    $0x3,%eax
  80011f:	89 cb                	mov    %ecx,%ebx
  800121:	89 cf                	mov    %ecx,%edi
  800123:	89 ce                	mov    %ecx,%esi
  800125:	cd 30                	int    $0x30
	if(check && ret > 0)
  800127:	85 c0                	test   %eax,%eax
  800129:	7f 08                	jg     800133 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	6a 03                	push   $0x3
  800139:	68 aa 1f 80 00       	push   $0x801faa
  80013e:	6a 23                	push   $0x23
  800140:	68 c7 1f 80 00       	push   $0x801fc7
  800145:	e8 c0 0f 00 00       	call   80110a <_panic>

0080014a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80014a:	f3 0f 1e fb          	endbr32 
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	57                   	push   %edi
  800152:	56                   	push   %esi
  800153:	53                   	push   %ebx
	asm volatile("int %1\n"
  800154:	ba 00 00 00 00       	mov    $0x0,%edx
  800159:	b8 02 00 00 00       	mov    $0x2,%eax
  80015e:	89 d1                	mov    %edx,%ecx
  800160:	89 d3                	mov    %edx,%ebx
  800162:	89 d7                	mov    %edx,%edi
  800164:	89 d6                	mov    %edx,%esi
  800166:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5f                   	pop    %edi
  80016b:	5d                   	pop    %ebp
  80016c:	c3                   	ret    

0080016d <sys_yield>:

void
sys_yield(void)
{
  80016d:	f3 0f 1e fb          	endbr32 
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	57                   	push   %edi
  800175:	56                   	push   %esi
  800176:	53                   	push   %ebx
	asm volatile("int %1\n"
  800177:	ba 00 00 00 00       	mov    $0x0,%edx
  80017c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800181:	89 d1                	mov    %edx,%ecx
  800183:	89 d3                	mov    %edx,%ebx
  800185:	89 d7                	mov    %edx,%edi
  800187:	89 d6                	mov    %edx,%esi
  800189:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5f                   	pop    %edi
  80018e:	5d                   	pop    %ebp
  80018f:	c3                   	ret    

00800190 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800190:	f3 0f 1e fb          	endbr32 
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	be 00 00 00 00       	mov    $0x0,%esi
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	89 f7                	mov    %esi,%edi
  8001b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 04                	push   $0x4
  8001c6:	68 aa 1f 80 00       	push   $0x801faa
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 c7 1f 80 00       	push   $0x801fc7
  8001d2:	e8 33 0f 00 00       	call   80110a <_panic>

008001d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d7:	f3 0f 1e fb          	endbr32 
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 05                	push   $0x5
  80020c:	68 aa 1f 80 00       	push   $0x801faa
  800211:	6a 23                	push   $0x23
  800213:	68 c7 1f 80 00       	push   $0x801fc7
  800218:	e8 ed 0e 00 00       	call   80110a <_panic>

0080021d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021d:	f3 0f 1e fb          	endbr32 
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 06 00 00 00       	mov    $0x6,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 06                	push   $0x6
  800252:	68 aa 1f 80 00       	push   $0x801faa
  800257:	6a 23                	push   $0x23
  800259:	68 c7 1f 80 00       	push   $0x801fc7
  80025e:	e8 a7 0e 00 00       	call   80110a <_panic>

00800263 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800263:	f3 0f 1e fb          	endbr32 
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 08 00 00 00       	mov    $0x8,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 08                	push   $0x8
  800298:	68 aa 1f 80 00       	push   $0x801faa
  80029d:	6a 23                	push   $0x23
  80029f:	68 c7 1f 80 00       	push   $0x801fc7
  8002a4:	e8 61 0e 00 00       	call   80110a <_panic>

008002a9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a9:	f3 0f 1e fb          	endbr32 
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	57                   	push   %edi
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
  8002b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c6:	89 df                	mov    %ebx,%edi
  8002c8:	89 de                	mov    %ebx,%esi
  8002ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	7f 08                	jg     8002d8 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d3:	5b                   	pop    %ebx
  8002d4:	5e                   	pop    %esi
  8002d5:	5f                   	pop    %edi
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	6a 09                	push   $0x9
  8002de:	68 aa 1f 80 00       	push   $0x801faa
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 c7 1f 80 00       	push   $0x801fc7
  8002ea:	e8 1b 0e 00 00       	call   80110a <_panic>

008002ef <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800301:	8b 55 08             	mov    0x8(%ebp),%edx
  800304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800307:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030c:	89 df                	mov    %ebx,%edi
  80030e:	89 de                	mov    %ebx,%esi
  800310:	cd 30                	int    $0x30
	if(check && ret > 0)
  800312:	85 c0                	test   %eax,%eax
  800314:	7f 08                	jg     80031e <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800316:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800319:	5b                   	pop    %ebx
  80031a:	5e                   	pop    %esi
  80031b:	5f                   	pop    %edi
  80031c:	5d                   	pop    %ebp
  80031d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	50                   	push   %eax
  800322:	6a 0a                	push   $0xa
  800324:	68 aa 1f 80 00       	push   $0x801faa
  800329:	6a 23                	push   $0x23
  80032b:	68 c7 1f 80 00       	push   $0x801fc7
  800330:	e8 d5 0d 00 00       	call   80110a <_panic>

00800335 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800335:	f3 0f 1e fb          	endbr32 
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	57                   	push   %edi
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800345:	b8 0c 00 00 00       	mov    $0xc,%eax
  80034a:	be 00 00 00 00       	mov    $0x0,%esi
  80034f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800352:	8b 7d 14             	mov    0x14(%ebp),%edi
  800355:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800357:	5b                   	pop    %ebx
  800358:	5e                   	pop    %esi
  800359:	5f                   	pop    %edi
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035c:	f3 0f 1e fb          	endbr32 
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800369:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036e:	8b 55 08             	mov    0x8(%ebp),%edx
  800371:	b8 0d 00 00 00       	mov    $0xd,%eax
  800376:	89 cb                	mov    %ecx,%ebx
  800378:	89 cf                	mov    %ecx,%edi
  80037a:	89 ce                	mov    %ecx,%esi
  80037c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037e:	85 c0                	test   %eax,%eax
  800380:	7f 08                	jg     80038a <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800385:	5b                   	pop    %ebx
  800386:	5e                   	pop    %esi
  800387:	5f                   	pop    %edi
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80038a:	83 ec 0c             	sub    $0xc,%esp
  80038d:	50                   	push   %eax
  80038e:	6a 0d                	push   $0xd
  800390:	68 aa 1f 80 00       	push   $0x801faa
  800395:	6a 23                	push   $0x23
  800397:	68 c7 1f 80 00       	push   $0x801fc7
  80039c:	e8 69 0d 00 00       	call   80110a <_panic>

008003a1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8003a1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8003a2:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8003a7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8003a9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8003ac:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8003af:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8003b3:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8003b8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8003bc:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8003be:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8003bf:	83 c4 04             	add    $0x4,%esp
	popfl
  8003c2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8003c3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8003c4:	c3                   	ret    

008003c5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003c5:	f3 0f 1e fb          	endbr32 
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	05 00 00 00 30       	add    $0x30000000,%eax
  8003d4:	c1 e8 0c             	shr    $0xc,%eax
}
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    

008003d9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003d9:	f3 0f 1e fb          	endbr32 
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ed:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003f2:	5d                   	pop    %ebp
  8003f3:	c3                   	ret    

008003f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003f4:	f3 0f 1e fb          	endbr32 
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800400:	89 c2                	mov    %eax,%edx
  800402:	c1 ea 16             	shr    $0x16,%edx
  800405:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80040c:	f6 c2 01             	test   $0x1,%dl
  80040f:	74 2d                	je     80043e <fd_alloc+0x4a>
  800411:	89 c2                	mov    %eax,%edx
  800413:	c1 ea 0c             	shr    $0xc,%edx
  800416:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80041d:	f6 c2 01             	test   $0x1,%dl
  800420:	74 1c                	je     80043e <fd_alloc+0x4a>
  800422:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800427:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80042c:	75 d2                	jne    800400 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800437:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80043c:	eb 0a                	jmp    800448 <fd_alloc+0x54>
			*fd_store = fd;
  80043e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800441:	89 01                	mov    %eax,(%ecx)
			return 0;
  800443:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800448:	5d                   	pop    %ebp
  800449:	c3                   	ret    

0080044a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80044a:	f3 0f 1e fb          	endbr32 
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800454:	83 f8 1f             	cmp    $0x1f,%eax
  800457:	77 30                	ja     800489 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800459:	c1 e0 0c             	shl    $0xc,%eax
  80045c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800461:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800467:	f6 c2 01             	test   $0x1,%dl
  80046a:	74 24                	je     800490 <fd_lookup+0x46>
  80046c:	89 c2                	mov    %eax,%edx
  80046e:	c1 ea 0c             	shr    $0xc,%edx
  800471:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800478:	f6 c2 01             	test   $0x1,%dl
  80047b:	74 1a                	je     800497 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	89 02                	mov    %eax,(%edx)
	return 0;
  800482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800487:	5d                   	pop    %ebp
  800488:	c3                   	ret    
		return -E_INVAL;
  800489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80048e:	eb f7                	jmp    800487 <fd_lookup+0x3d>
		return -E_INVAL;
  800490:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800495:	eb f0                	jmp    800487 <fd_lookup+0x3d>
  800497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80049c:	eb e9                	jmp    800487 <fd_lookup+0x3d>

0080049e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80049e:	f3 0f 1e fb          	endbr32 
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ab:	ba 54 20 80 00       	mov    $0x802054,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004b0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004b5:	39 08                	cmp    %ecx,(%eax)
  8004b7:	74 33                	je     8004ec <dev_lookup+0x4e>
  8004b9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004bc:	8b 02                	mov    (%edx),%eax
  8004be:	85 c0                	test   %eax,%eax
  8004c0:	75 f3                	jne    8004b5 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8004c7:	8b 40 48             	mov    0x48(%eax),%eax
  8004ca:	83 ec 04             	sub    $0x4,%esp
  8004cd:	51                   	push   %ecx
  8004ce:	50                   	push   %eax
  8004cf:	68 d8 1f 80 00       	push   $0x801fd8
  8004d4:	e8 18 0d 00 00       	call   8011f1 <cprintf>
	*dev = 0;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004ea:	c9                   	leave  
  8004eb:	c3                   	ret    
			*dev = devtab[i];
  8004ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ef:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	eb f2                	jmp    8004ea <dev_lookup+0x4c>

008004f8 <fd_close>:
{
  8004f8:	f3 0f 1e fb          	endbr32 
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	57                   	push   %edi
  800500:	56                   	push   %esi
  800501:	53                   	push   %ebx
  800502:	83 ec 24             	sub    $0x24,%esp
  800505:	8b 75 08             	mov    0x8(%ebp),%esi
  800508:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80050b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80050e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80050f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800515:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800518:	50                   	push   %eax
  800519:	e8 2c ff ff ff       	call   80044a <fd_lookup>
  80051e:	89 c3                	mov    %eax,%ebx
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	85 c0                	test   %eax,%eax
  800525:	78 05                	js     80052c <fd_close+0x34>
	    || fd != fd2)
  800527:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80052a:	74 16                	je     800542 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80052c:	89 f8                	mov    %edi,%eax
  80052e:	84 c0                	test   %al,%al
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 44 d8             	cmove  %eax,%ebx
}
  800538:	89 d8                	mov    %ebx,%eax
  80053a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80053d:	5b                   	pop    %ebx
  80053e:	5e                   	pop    %esi
  80053f:	5f                   	pop    %edi
  800540:	5d                   	pop    %ebp
  800541:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800548:	50                   	push   %eax
  800549:	ff 36                	pushl  (%esi)
  80054b:	e8 4e ff ff ff       	call   80049e <dev_lookup>
  800550:	89 c3                	mov    %eax,%ebx
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	85 c0                	test   %eax,%eax
  800557:	78 1a                	js     800573 <fd_close+0x7b>
		if (dev->dev_close)
  800559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80055f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800564:	85 c0                	test   %eax,%eax
  800566:	74 0b                	je     800573 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	56                   	push   %esi
  80056c:	ff d0                	call   *%eax
  80056e:	89 c3                	mov    %eax,%ebx
  800570:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	56                   	push   %esi
  800577:	6a 00                	push   $0x0
  800579:	e8 9f fc ff ff       	call   80021d <sys_page_unmap>
	return r;
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	eb b5                	jmp    800538 <fd_close+0x40>

00800583 <close>:

int
close(int fdnum)
{
  800583:	f3 0f 1e fb          	endbr32 
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80058d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800590:	50                   	push   %eax
  800591:	ff 75 08             	pushl  0x8(%ebp)
  800594:	e8 b1 fe ff ff       	call   80044a <fd_lookup>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	85 c0                	test   %eax,%eax
  80059e:	79 02                	jns    8005a2 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    
		return fd_close(fd, 1);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	6a 01                	push   $0x1
  8005a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005aa:	e8 49 ff ff ff       	call   8004f8 <fd_close>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	eb ec                	jmp    8005a0 <close+0x1d>

008005b4 <close_all>:

void
close_all(void)
{
  8005b4:	f3 0f 1e fb          	endbr32 
  8005b8:	55                   	push   %ebp
  8005b9:	89 e5                	mov    %esp,%ebp
  8005bb:	53                   	push   %ebx
  8005bc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005bf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005c4:	83 ec 0c             	sub    $0xc,%esp
  8005c7:	53                   	push   %ebx
  8005c8:	e8 b6 ff ff ff       	call   800583 <close>
	for (i = 0; i < MAXFD; i++)
  8005cd:	83 c3 01             	add    $0x1,%ebx
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	83 fb 20             	cmp    $0x20,%ebx
  8005d6:	75 ec                	jne    8005c4 <close_all+0x10>
}
  8005d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005db:	c9                   	leave  
  8005dc:	c3                   	ret    

008005dd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005dd:	f3 0f 1e fb          	endbr32 
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	57                   	push   %edi
  8005e5:	56                   	push   %esi
  8005e6:	53                   	push   %ebx
  8005e7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005ed:	50                   	push   %eax
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 54 fe ff ff       	call   80044a <fd_lookup>
  8005f6:	89 c3                	mov    %eax,%ebx
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	85 c0                	test   %eax,%eax
  8005fd:	0f 88 81 00 00 00    	js     800684 <dup+0xa7>
		return r;
	close(newfdnum);
  800603:	83 ec 0c             	sub    $0xc,%esp
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	e8 75 ff ff ff       	call   800583 <close>

	newfd = INDEX2FD(newfdnum);
  80060e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800611:	c1 e6 0c             	shl    $0xc,%esi
  800614:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80061a:	83 c4 04             	add    $0x4,%esp
  80061d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800620:	e8 b4 fd ff ff       	call   8003d9 <fd2data>
  800625:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800627:	89 34 24             	mov    %esi,(%esp)
  80062a:	e8 aa fd ff ff       	call   8003d9 <fd2data>
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800634:	89 d8                	mov    %ebx,%eax
  800636:	c1 e8 16             	shr    $0x16,%eax
  800639:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800640:	a8 01                	test   $0x1,%al
  800642:	74 11                	je     800655 <dup+0x78>
  800644:	89 d8                	mov    %ebx,%eax
  800646:	c1 e8 0c             	shr    $0xc,%eax
  800649:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800650:	f6 c2 01             	test   $0x1,%dl
  800653:	75 39                	jne    80068e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800655:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800658:	89 d0                	mov    %edx,%eax
  80065a:	c1 e8 0c             	shr    $0xc,%eax
  80065d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800664:	83 ec 0c             	sub    $0xc,%esp
  800667:	25 07 0e 00 00       	and    $0xe07,%eax
  80066c:	50                   	push   %eax
  80066d:	56                   	push   %esi
  80066e:	6a 00                	push   $0x0
  800670:	52                   	push   %edx
  800671:	6a 00                	push   $0x0
  800673:	e8 5f fb ff ff       	call   8001d7 <sys_page_map>
  800678:	89 c3                	mov    %eax,%ebx
  80067a:	83 c4 20             	add    $0x20,%esp
  80067d:	85 c0                	test   %eax,%eax
  80067f:	78 31                	js     8006b2 <dup+0xd5>
		goto err;

	return newfdnum;
  800681:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800684:	89 d8                	mov    %ebx,%eax
  800686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800689:	5b                   	pop    %ebx
  80068a:	5e                   	pop    %esi
  80068b:	5f                   	pop    %edi
  80068c:	5d                   	pop    %ebp
  80068d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80068e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	25 07 0e 00 00       	and    $0xe07,%eax
  80069d:	50                   	push   %eax
  80069e:	57                   	push   %edi
  80069f:	6a 00                	push   $0x0
  8006a1:	53                   	push   %ebx
  8006a2:	6a 00                	push   $0x0
  8006a4:	e8 2e fb ff ff       	call   8001d7 <sys_page_map>
  8006a9:	89 c3                	mov    %eax,%ebx
  8006ab:	83 c4 20             	add    $0x20,%esp
  8006ae:	85 c0                	test   %eax,%eax
  8006b0:	79 a3                	jns    800655 <dup+0x78>
	sys_page_unmap(0, newfd);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	6a 00                	push   $0x0
  8006b8:	e8 60 fb ff ff       	call   80021d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006bd:	83 c4 08             	add    $0x8,%esp
  8006c0:	57                   	push   %edi
  8006c1:	6a 00                	push   $0x0
  8006c3:	e8 55 fb ff ff       	call   80021d <sys_page_unmap>
	return r;
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb b7                	jmp    800684 <dup+0xa7>

008006cd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006cd:	f3 0f 1e fb          	endbr32 
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	53                   	push   %ebx
  8006d5:	83 ec 1c             	sub    $0x1c,%esp
  8006d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006de:	50                   	push   %eax
  8006df:	53                   	push   %ebx
  8006e0:	e8 65 fd ff ff       	call   80044a <fd_lookup>
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	85 c0                	test   %eax,%eax
  8006ea:	78 3f                	js     80072b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f6:	ff 30                	pushl  (%eax)
  8006f8:	e8 a1 fd ff ff       	call   80049e <dev_lookup>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	85 c0                	test   %eax,%eax
  800702:	78 27                	js     80072b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800704:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800707:	8b 42 08             	mov    0x8(%edx),%eax
  80070a:	83 e0 03             	and    $0x3,%eax
  80070d:	83 f8 01             	cmp    $0x1,%eax
  800710:	74 1e                	je     800730 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800715:	8b 40 08             	mov    0x8(%eax),%eax
  800718:	85 c0                	test   %eax,%eax
  80071a:	74 35                	je     800751 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	ff 75 10             	pushl  0x10(%ebp)
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	52                   	push   %edx
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
}
  80072b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800730:	a1 04 40 80 00       	mov    0x804004,%eax
  800735:	8b 40 48             	mov    0x48(%eax),%eax
  800738:	83 ec 04             	sub    $0x4,%esp
  80073b:	53                   	push   %ebx
  80073c:	50                   	push   %eax
  80073d:	68 19 20 80 00       	push   $0x802019
  800742:	e8 aa 0a 00 00       	call   8011f1 <cprintf>
		return -E_INVAL;
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074f:	eb da                	jmp    80072b <read+0x5e>
		return -E_NOT_SUPP;
  800751:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800756:	eb d3                	jmp    80072b <read+0x5e>

00800758 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800758:	f3 0f 1e fb          	endbr32 
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	57                   	push   %edi
  800760:	56                   	push   %esi
  800761:	53                   	push   %ebx
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	8b 7d 08             	mov    0x8(%ebp),%edi
  800768:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80076b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800770:	eb 02                	jmp    800774 <readn+0x1c>
  800772:	01 c3                	add    %eax,%ebx
  800774:	39 f3                	cmp    %esi,%ebx
  800776:	73 21                	jae    800799 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	89 f0                	mov    %esi,%eax
  80077d:	29 d8                	sub    %ebx,%eax
  80077f:	50                   	push   %eax
  800780:	89 d8                	mov    %ebx,%eax
  800782:	03 45 0c             	add    0xc(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	57                   	push   %edi
  800787:	e8 41 ff ff ff       	call   8006cd <read>
		if (m < 0)
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	85 c0                	test   %eax,%eax
  800791:	78 04                	js     800797 <readn+0x3f>
			return m;
		if (m == 0)
  800793:	75 dd                	jne    800772 <readn+0x1a>
  800795:	eb 02                	jmp    800799 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800797:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800799:	89 d8                	mov    %ebx,%eax
  80079b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079e:	5b                   	pop    %ebx
  80079f:	5e                   	pop    %esi
  8007a0:	5f                   	pop    %edi
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007a3:	f3 0f 1e fb          	endbr32 
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	53                   	push   %ebx
  8007ab:	83 ec 1c             	sub    $0x1c,%esp
  8007ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	53                   	push   %ebx
  8007b6:	e8 8f fc ff ff       	call   80044a <fd_lookup>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	85 c0                	test   %eax,%eax
  8007c0:	78 3a                	js     8007fc <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c8:	50                   	push   %eax
  8007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cc:	ff 30                	pushl  (%eax)
  8007ce:	e8 cb fc ff ff       	call   80049e <dev_lookup>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	85 c0                	test   %eax,%eax
  8007d8:	78 22                	js     8007fc <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e1:	74 1e                	je     800801 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e9:	85 d2                	test   %edx,%edx
  8007eb:	74 35                	je     800822 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007ed:	83 ec 04             	sub    $0x4,%esp
  8007f0:	ff 75 10             	pushl  0x10(%ebp)
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	50                   	push   %eax
  8007f7:	ff d2                	call   *%edx
  8007f9:	83 c4 10             	add    $0x10,%esp
}
  8007fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800801:	a1 04 40 80 00       	mov    0x804004,%eax
  800806:	8b 40 48             	mov    0x48(%eax),%eax
  800809:	83 ec 04             	sub    $0x4,%esp
  80080c:	53                   	push   %ebx
  80080d:	50                   	push   %eax
  80080e:	68 35 20 80 00       	push   $0x802035
  800813:	e8 d9 09 00 00       	call   8011f1 <cprintf>
		return -E_INVAL;
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800820:	eb da                	jmp    8007fc <write+0x59>
		return -E_NOT_SUPP;
  800822:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800827:	eb d3                	jmp    8007fc <write+0x59>

00800829 <seek>:

int
seek(int fdnum, off_t offset)
{
  800829:	f3 0f 1e fb          	endbr32 
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800833:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	ff 75 08             	pushl  0x8(%ebp)
  80083a:	e8 0b fc ff ff       	call   80044a <fd_lookup>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 c0                	test   %eax,%eax
  800844:	78 0e                	js     800854 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800846:	8b 55 0c             	mov    0xc(%ebp),%edx
  800849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	53                   	push   %ebx
  80085e:	83 ec 1c             	sub    $0x1c,%esp
  800861:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800864:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800867:	50                   	push   %eax
  800868:	53                   	push   %ebx
  800869:	e8 dc fb ff ff       	call   80044a <fd_lookup>
  80086e:	83 c4 10             	add    $0x10,%esp
  800871:	85 c0                	test   %eax,%eax
  800873:	78 37                	js     8008ac <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087b:	50                   	push   %eax
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	ff 30                	pushl  (%eax)
  800881:	e8 18 fc ff ff       	call   80049e <dev_lookup>
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	85 c0                	test   %eax,%eax
  80088b:	78 1f                	js     8008ac <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80088d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800890:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800894:	74 1b                	je     8008b1 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800899:	8b 52 18             	mov    0x18(%edx),%edx
  80089c:	85 d2                	test   %edx,%edx
  80089e:	74 32                	je     8008d2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	ff d2                	call   *%edx
  8008a9:	83 c4 10             	add    $0x10,%esp
}
  8008ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008b1:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008b6:	8b 40 48             	mov    0x48(%eax),%eax
  8008b9:	83 ec 04             	sub    $0x4,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	50                   	push   %eax
  8008be:	68 f8 1f 80 00       	push   $0x801ff8
  8008c3:	e8 29 09 00 00       	call   8011f1 <cprintf>
		return -E_INVAL;
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d0:	eb da                	jmp    8008ac <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d7:	eb d3                	jmp    8008ac <ftruncate+0x56>

008008d9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	53                   	push   %ebx
  8008e1:	83 ec 1c             	sub    $0x1c,%esp
  8008e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 57 fb ff ff       	call   80044a <fd_lookup>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	78 4b                	js     800945 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800900:	50                   	push   %eax
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	ff 30                	pushl  (%eax)
  800906:	e8 93 fb ff ff       	call   80049e <dev_lookup>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	85 c0                	test   %eax,%eax
  800910:	78 33                	js     800945 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800919:	74 2f                	je     80094a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80091b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80091e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800925:	00 00 00 
	stat->st_isdir = 0;
  800928:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80092f:	00 00 00 
	stat->st_dev = dev;
  800932:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	53                   	push   %ebx
  80093c:	ff 75 f0             	pushl  -0x10(%ebp)
  80093f:	ff 50 14             	call   *0x14(%eax)
  800942:	83 c4 10             	add    $0x10,%esp
}
  800945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800948:	c9                   	leave  
  800949:	c3                   	ret    
		return -E_NOT_SUPP;
  80094a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80094f:	eb f4                	jmp    800945 <fstat+0x6c>

00800951 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800951:	f3 0f 1e fb          	endbr32 
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	56                   	push   %esi
  800959:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 fb 01 00 00       	call   800b62 <open>
  800967:	89 c3                	mov    %eax,%ebx
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	85 c0                	test   %eax,%eax
  80096e:	78 1b                	js     80098b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	50                   	push   %eax
  800977:	e8 5d ff ff ff       	call   8008d9 <fstat>
  80097c:	89 c6                	mov    %eax,%esi
	close(fd);
  80097e:	89 1c 24             	mov    %ebx,(%esp)
  800981:	e8 fd fb ff ff       	call   800583 <close>
	return r;
  800986:	83 c4 10             	add    $0x10,%esp
  800989:	89 f3                	mov    %esi,%ebx
}
  80098b:	89 d8                	mov    %ebx,%eax
  80098d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800990:	5b                   	pop    %ebx
  800991:	5e                   	pop    %esi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	89 c6                	mov    %eax,%esi
  80099b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80099d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009a4:	74 27                	je     8009cd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009a6:	6a 07                	push   $0x7
  8009a8:	68 00 50 80 00       	push   $0x805000
  8009ad:	56                   	push   %esi
  8009ae:	ff 35 00 40 80 00    	pushl  0x804000
  8009b4:	e8 9d 12 00 00       	call   801c56 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b9:	83 c4 0c             	add    $0xc,%esp
  8009bc:	6a 00                	push   $0x0
  8009be:	53                   	push   %ebx
  8009bf:	6a 00                	push   $0x0
  8009c1:	e8 23 12 00 00       	call   801be9 <ipc_recv>
}
  8009c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c9:	5b                   	pop    %ebx
  8009ca:	5e                   	pop    %esi
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009cd:	83 ec 0c             	sub    $0xc,%esp
  8009d0:	6a 01                	push   $0x1
  8009d2:	e8 d9 12 00 00       	call   801cb0 <ipc_find_env>
  8009d7:	a3 00 40 80 00       	mov    %eax,0x804000
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	eb c5                	jmp    8009a6 <fsipc+0x12>

008009e1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8009f1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800a03:	b8 02 00 00 00       	mov    $0x2,%eax
  800a08:	e8 87 ff ff ff       	call   800994 <fsipc>
}
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <devfile_flush>:
{
  800a0f:	f3 0f 1e fb          	endbr32 
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 40 0c             	mov    0xc(%eax),%eax
  800a1f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a24:	ba 00 00 00 00       	mov    $0x0,%edx
  800a29:	b8 06 00 00 00       	mov    $0x6,%eax
  800a2e:	e8 61 ff ff ff       	call   800994 <fsipc>
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <devfile_stat>:
{
  800a35:	f3 0f 1e fb          	endbr32 
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	53                   	push   %ebx
  800a3d:	83 ec 04             	sub    $0x4,%esp
  800a40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 40 0c             	mov    0xc(%eax),%eax
  800a49:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a53:	b8 05 00 00 00       	mov    $0x5,%eax
  800a58:	e8 37 ff ff ff       	call   800994 <fsipc>
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	78 2c                	js     800a8d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	68 00 50 80 00       	push   $0x805000
  800a69:	53                   	push   %ebx
  800a6a:	e8 8c 0d 00 00       	call   8017fb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a6f:	a1 80 50 80 00       	mov    0x805080,%eax
  800a74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a7a:	a1 84 50 80 00       	mov    0x805084,%eax
  800a7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <devfile_write>:
{
  800a92:	f3 0f 1e fb          	endbr32 
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	83 ec 0c             	sub    $0xc,%esp
  800a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800aa4:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800aa9:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800aac:	8b 55 08             	mov    0x8(%ebp),%edx
  800aaf:	8b 52 0c             	mov    0xc(%edx),%edx
  800ab2:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800ab8:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	68 08 50 80 00       	push   $0x805008
  800ac6:	e8 e6 0e 00 00       	call   8019b1 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	b8 04 00 00 00       	mov    $0x4,%eax
  800ad5:	e8 ba fe ff ff       	call   800994 <fsipc>
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <devfile_read>:
{
  800adc:	f3 0f 1e fb          	endbr32 
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	56                   	push   %esi
  800ae4:	53                   	push   %ebx
  800ae5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 40 0c             	mov    0xc(%eax),%eax
  800aee:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800af3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800af9:	ba 00 00 00 00       	mov    $0x0,%edx
  800afe:	b8 03 00 00 00       	mov    $0x3,%eax
  800b03:	e8 8c fe ff ff       	call   800994 <fsipc>
  800b08:	89 c3                	mov    %eax,%ebx
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	78 1f                	js     800b2d <devfile_read+0x51>
	assert(r <= n);
  800b0e:	39 f0                	cmp    %esi,%eax
  800b10:	77 24                	ja     800b36 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b12:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b17:	7f 33                	jg     800b4c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	50                   	push   %eax
  800b1d:	68 00 50 80 00       	push   $0x805000
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	e8 87 0e 00 00       	call   8019b1 <memmove>
	return r;
  800b2a:	83 c4 10             	add    $0x10,%esp
}
  800b2d:	89 d8                	mov    %ebx,%eax
  800b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    
	assert(r <= n);
  800b36:	68 64 20 80 00       	push   $0x802064
  800b3b:	68 6b 20 80 00       	push   $0x80206b
  800b40:	6a 7d                	push   $0x7d
  800b42:	68 80 20 80 00       	push   $0x802080
  800b47:	e8 be 05 00 00       	call   80110a <_panic>
	assert(r <= PGSIZE);
  800b4c:	68 8b 20 80 00       	push   $0x80208b
  800b51:	68 6b 20 80 00       	push   $0x80206b
  800b56:	6a 7e                	push   $0x7e
  800b58:	68 80 20 80 00       	push   $0x802080
  800b5d:	e8 a8 05 00 00       	call   80110a <_panic>

00800b62 <open>:
{
  800b62:	f3 0f 1e fb          	endbr32 
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
  800b6b:	83 ec 1c             	sub    $0x1c,%esp
  800b6e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b71:	56                   	push   %esi
  800b72:	e8 41 0c 00 00       	call   8017b8 <strlen>
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b7f:	7f 6c                	jg     800bed <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b81:	83 ec 0c             	sub    $0xc,%esp
  800b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b87:	50                   	push   %eax
  800b88:	e8 67 f8 ff ff       	call   8003f4 <fd_alloc>
  800b8d:	89 c3                	mov    %eax,%ebx
  800b8f:	83 c4 10             	add    $0x10,%esp
  800b92:	85 c0                	test   %eax,%eax
  800b94:	78 3c                	js     800bd2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	56                   	push   %esi
  800b9a:	68 00 50 80 00       	push   $0x805000
  800b9f:	e8 57 0c 00 00       	call   8017fb <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800baf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb4:	e8 db fd ff ff       	call   800994 <fsipc>
  800bb9:	89 c3                	mov    %eax,%ebx
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	85 c0                	test   %eax,%eax
  800bc0:	78 19                	js     800bdb <open+0x79>
	return fd2num(fd);
  800bc2:	83 ec 0c             	sub    $0xc,%esp
  800bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc8:	e8 f8 f7 ff ff       	call   8003c5 <fd2num>
  800bcd:	89 c3                	mov    %eax,%ebx
  800bcf:	83 c4 10             	add    $0x10,%esp
}
  800bd2:	89 d8                	mov    %ebx,%eax
  800bd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    
		fd_close(fd, 0);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	6a 00                	push   $0x0
  800be0:	ff 75 f4             	pushl  -0xc(%ebp)
  800be3:	e8 10 f9 ff ff       	call   8004f8 <fd_close>
		return r;
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	eb e5                	jmp    800bd2 <open+0x70>
		return -E_BAD_PATH;
  800bed:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bf2:	eb de                	jmp    800bd2 <open+0x70>

00800bf4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bf4:	f3 0f 1e fb          	endbr32 
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	b8 08 00 00 00       	mov    $0x8,%eax
  800c08:	e8 87 fd ff ff       	call   800994 <fsipc>
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c0f:	f3 0f 1e fb          	endbr32 
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c1b:	83 ec 0c             	sub    $0xc,%esp
  800c1e:	ff 75 08             	pushl  0x8(%ebp)
  800c21:	e8 b3 f7 ff ff       	call   8003d9 <fd2data>
  800c26:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c28:	83 c4 08             	add    $0x8,%esp
  800c2b:	68 97 20 80 00       	push   $0x802097
  800c30:	53                   	push   %ebx
  800c31:	e8 c5 0b 00 00       	call   8017fb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c36:	8b 46 04             	mov    0x4(%esi),%eax
  800c39:	2b 06                	sub    (%esi),%eax
  800c3b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c41:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c48:	00 00 00 
	stat->st_dev = &devpipe;
  800c4b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c52:	30 80 00 
	return 0;
}
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c61:	f3 0f 1e fb          	endbr32 
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	53                   	push   %ebx
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c6f:	53                   	push   %ebx
  800c70:	6a 00                	push   $0x0
  800c72:	e8 a6 f5 ff ff       	call   80021d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c77:	89 1c 24             	mov    %ebx,(%esp)
  800c7a:	e8 5a f7 ff ff       	call   8003d9 <fd2data>
  800c7f:	83 c4 08             	add    $0x8,%esp
  800c82:	50                   	push   %eax
  800c83:	6a 00                	push   $0x0
  800c85:	e8 93 f5 ff ff       	call   80021d <sys_page_unmap>
}
  800c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <_pipeisclosed>:
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 1c             	sub    $0x1c,%esp
  800c98:	89 c7                	mov    %eax,%edi
  800c9a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c9c:	a1 04 40 80 00       	mov    0x804004,%eax
  800ca1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800ca4:	83 ec 0c             	sub    $0xc,%esp
  800ca7:	57                   	push   %edi
  800ca8:	e8 40 10 00 00       	call   801ced <pageref>
  800cad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb0:	89 34 24             	mov    %esi,(%esp)
  800cb3:	e8 35 10 00 00       	call   801ced <pageref>
		nn = thisenv->env_runs;
  800cb8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cbe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cc1:	83 c4 10             	add    $0x10,%esp
  800cc4:	39 cb                	cmp    %ecx,%ebx
  800cc6:	74 1b                	je     800ce3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cc8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ccb:	75 cf                	jne    800c9c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ccd:	8b 42 58             	mov    0x58(%edx),%eax
  800cd0:	6a 01                	push   $0x1
  800cd2:	50                   	push   %eax
  800cd3:	53                   	push   %ebx
  800cd4:	68 9e 20 80 00       	push   $0x80209e
  800cd9:	e8 13 05 00 00       	call   8011f1 <cprintf>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	eb b9                	jmp    800c9c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800ce3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ce6:	0f 94 c0             	sete   %al
  800ce9:	0f b6 c0             	movzbl %al,%eax
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <devpipe_write>:
{
  800cf4:	f3 0f 1e fb          	endbr32 
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	57                   	push   %edi
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
  800cfe:	83 ec 28             	sub    $0x28,%esp
  800d01:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d04:	56                   	push   %esi
  800d05:	e8 cf f6 ff ff       	call   8003d9 <fd2data>
  800d0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d14:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d17:	74 4f                	je     800d68 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d19:	8b 43 04             	mov    0x4(%ebx),%eax
  800d1c:	8b 0b                	mov    (%ebx),%ecx
  800d1e:	8d 51 20             	lea    0x20(%ecx),%edx
  800d21:	39 d0                	cmp    %edx,%eax
  800d23:	72 14                	jb     800d39 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  800d25:	89 da                	mov    %ebx,%edx
  800d27:	89 f0                	mov    %esi,%eax
  800d29:	e8 61 ff ff ff       	call   800c8f <_pipeisclosed>
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	75 3b                	jne    800d6d <devpipe_write+0x79>
			sys_yield();
  800d32:	e8 36 f4 ff ff       	call   80016d <sys_yield>
  800d37:	eb e0                	jmp    800d19 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d40:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d43:	89 c2                	mov    %eax,%edx
  800d45:	c1 fa 1f             	sar    $0x1f,%edx
  800d48:	89 d1                	mov    %edx,%ecx
  800d4a:	c1 e9 1b             	shr    $0x1b,%ecx
  800d4d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800d50:	83 e2 1f             	and    $0x1f,%edx
  800d53:	29 ca                	sub    %ecx,%edx
  800d55:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800d59:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800d5d:	83 c0 01             	add    $0x1,%eax
  800d60:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d63:	83 c7 01             	add    $0x1,%edi
  800d66:	eb ac                	jmp    800d14 <devpipe_write+0x20>
	return i;
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	eb 05                	jmp    800d72 <devpipe_write+0x7e>
				return 0;
  800d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <devpipe_read>:
{
  800d7a:	f3 0f 1e fb          	endbr32 
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 18             	sub    $0x18,%esp
  800d87:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d8a:	57                   	push   %edi
  800d8b:	e8 49 f6 ff ff       	call   8003d9 <fd2data>
  800d90:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d92:	83 c4 10             	add    $0x10,%esp
  800d95:	be 00 00 00 00       	mov    $0x0,%esi
  800d9a:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d9d:	75 14                	jne    800db3 <devpipe_read+0x39>
	return i;
  800d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800da2:	eb 02                	jmp    800da6 <devpipe_read+0x2c>
				return i;
  800da4:	89 f0                	mov    %esi,%eax
}
  800da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
			sys_yield();
  800dae:	e8 ba f3 ff ff       	call   80016d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800db3:	8b 03                	mov    (%ebx),%eax
  800db5:	3b 43 04             	cmp    0x4(%ebx),%eax
  800db8:	75 18                	jne    800dd2 <devpipe_read+0x58>
			if (i > 0)
  800dba:	85 f6                	test   %esi,%esi
  800dbc:	75 e6                	jne    800da4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  800dbe:	89 da                	mov    %ebx,%edx
  800dc0:	89 f8                	mov    %edi,%eax
  800dc2:	e8 c8 fe ff ff       	call   800c8f <_pipeisclosed>
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	74 e3                	je     800dae <devpipe_read+0x34>
				return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd0:	eb d4                	jmp    800da6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dd2:	99                   	cltd   
  800dd3:	c1 ea 1b             	shr    $0x1b,%edx
  800dd6:	01 d0                	add    %edx,%eax
  800dd8:	83 e0 1f             	and    $0x1f,%eax
  800ddb:	29 d0                	sub    %edx,%eax
  800ddd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800de8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800deb:	83 c6 01             	add    $0x1,%esi
  800dee:	eb aa                	jmp    800d9a <devpipe_read+0x20>

00800df0 <pipe>:
{
  800df0:	f3 0f 1e fb          	endbr32 
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dff:	50                   	push   %eax
  800e00:	e8 ef f5 ff ff       	call   8003f4 <fd_alloc>
  800e05:	89 c3                	mov    %eax,%ebx
  800e07:	83 c4 10             	add    $0x10,%esp
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	0f 88 23 01 00 00    	js     800f35 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	68 07 04 00 00       	push   $0x407
  800e1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1d:	6a 00                	push   $0x0
  800e1f:	e8 6c f3 ff ff       	call   800190 <sys_page_alloc>
  800e24:	89 c3                	mov    %eax,%ebx
  800e26:	83 c4 10             	add    $0x10,%esp
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	0f 88 04 01 00 00    	js     800f35 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  800e31:	83 ec 0c             	sub    $0xc,%esp
  800e34:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e37:	50                   	push   %eax
  800e38:	e8 b7 f5 ff ff       	call   8003f4 <fd_alloc>
  800e3d:	89 c3                	mov    %eax,%ebx
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	85 c0                	test   %eax,%eax
  800e44:	0f 88 db 00 00 00    	js     800f25 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4a:	83 ec 04             	sub    $0x4,%esp
  800e4d:	68 07 04 00 00       	push   $0x407
  800e52:	ff 75 f0             	pushl  -0x10(%ebp)
  800e55:	6a 00                	push   $0x0
  800e57:	e8 34 f3 ff ff       	call   800190 <sys_page_alloc>
  800e5c:	89 c3                	mov    %eax,%ebx
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	85 c0                	test   %eax,%eax
  800e63:	0f 88 bc 00 00 00    	js     800f25 <pipe+0x135>
	va = fd2data(fd0);
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6f:	e8 65 f5 ff ff       	call   8003d9 <fd2data>
  800e74:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e76:	83 c4 0c             	add    $0xc,%esp
  800e79:	68 07 04 00 00       	push   $0x407
  800e7e:	50                   	push   %eax
  800e7f:	6a 00                	push   $0x0
  800e81:	e8 0a f3 ff ff       	call   800190 <sys_page_alloc>
  800e86:	89 c3                	mov    %eax,%ebx
  800e88:	83 c4 10             	add    $0x10,%esp
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	0f 88 82 00 00 00    	js     800f15 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	ff 75 f0             	pushl  -0x10(%ebp)
  800e99:	e8 3b f5 ff ff       	call   8003d9 <fd2data>
  800e9e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800ea5:	50                   	push   %eax
  800ea6:	6a 00                	push   $0x0
  800ea8:	56                   	push   %esi
  800ea9:	6a 00                	push   $0x0
  800eab:	e8 27 f3 ff ff       	call   8001d7 <sys_page_map>
  800eb0:	89 c3                	mov    %eax,%ebx
  800eb2:	83 c4 20             	add    $0x20,%esp
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	78 4e                	js     800f07 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  800eb9:	a1 20 30 80 00       	mov    0x803020,%eax
  800ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800ecd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ed0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee2:	e8 de f4 ff ff       	call   8003c5 <fd2num>
  800ee7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eea:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eec:	83 c4 04             	add    $0x4,%esp
  800eef:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef2:	e8 ce f4 ff ff       	call   8003c5 <fd2num>
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800efd:	83 c4 10             	add    $0x10,%esp
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	eb 2e                	jmp    800f35 <pipe+0x145>
	sys_page_unmap(0, va);
  800f07:	83 ec 08             	sub    $0x8,%esp
  800f0a:	56                   	push   %esi
  800f0b:	6a 00                	push   $0x0
  800f0d:	e8 0b f3 ff ff       	call   80021d <sys_page_unmap>
  800f12:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 f0             	pushl  -0x10(%ebp)
  800f1b:	6a 00                	push   $0x0
  800f1d:	e8 fb f2 ff ff       	call   80021d <sys_page_unmap>
  800f22:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2b:	6a 00                	push   $0x0
  800f2d:	e8 eb f2 ff ff       	call   80021d <sys_page_unmap>
  800f32:	83 c4 10             	add    $0x10,%esp
}
  800f35:	89 d8                	mov    %ebx,%eax
  800f37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <pipeisclosed>:
{
  800f3e:	f3 0f 1e fb          	endbr32 
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 08             	pushl  0x8(%ebp)
  800f4f:	e8 f6 f4 ff ff       	call   80044a <fd_lookup>
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	85 c0                	test   %eax,%eax
  800f59:	78 18                	js     800f73 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f61:	e8 73 f4 ff ff       	call   8003d9 <fd2data>
  800f66:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  800f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6b:	e8 1f fd ff ff       	call   800c8f <_pipeisclosed>
  800f70:	83 c4 10             	add    $0x10,%esp
}
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f75:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7e:	c3                   	ret    

00800f7f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f7f:	f3 0f 1e fb          	endbr32 
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800f89:	68 b6 20 80 00       	push   $0x8020b6
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	e8 65 08 00 00       	call   8017fb <strcpy>
	return 0;
}
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	c9                   	leave  
  800f9c:	c3                   	ret    

00800f9d <devcons_write>:
{
  800f9d:	f3 0f 1e fb          	endbr32 
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fad:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fb2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fb8:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fbb:	73 31                	jae    800fee <devcons_write+0x51>
		m = n - tot;
  800fbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc0:	29 f3                	sub    %esi,%ebx
  800fc2:	83 fb 7f             	cmp    $0x7f,%ebx
  800fc5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800fca:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	53                   	push   %ebx
  800fd1:	89 f0                	mov    %esi,%eax
  800fd3:	03 45 0c             	add    0xc(%ebp),%eax
  800fd6:	50                   	push   %eax
  800fd7:	57                   	push   %edi
  800fd8:	e8 d4 09 00 00       	call   8019b1 <memmove>
		sys_cputs(buf, m);
  800fdd:	83 c4 08             	add    $0x8,%esp
  800fe0:	53                   	push   %ebx
  800fe1:	57                   	push   %edi
  800fe2:	e8 d9 f0 ff ff       	call   8000c0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fe7:	01 de                	add    %ebx,%esi
  800fe9:	83 c4 10             	add    $0x10,%esp
  800fec:	eb ca                	jmp    800fb8 <devcons_write+0x1b>
}
  800fee:	89 f0                	mov    %esi,%eax
  800ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <devcons_read>:
{
  800ff8:	f3 0f 1e fb          	endbr32 
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801007:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100b:	74 21                	je     80102e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80100d:	e8 d0 f0 ff ff       	call   8000e2 <sys_cgetc>
  801012:	85 c0                	test   %eax,%eax
  801014:	75 07                	jne    80101d <devcons_read+0x25>
		sys_yield();
  801016:	e8 52 f1 ff ff       	call   80016d <sys_yield>
  80101b:	eb f0                	jmp    80100d <devcons_read+0x15>
	if (c < 0)
  80101d:	78 0f                	js     80102e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80101f:	83 f8 04             	cmp    $0x4,%eax
  801022:	74 0c                	je     801030 <devcons_read+0x38>
	*(char*)vbuf = c;
  801024:	8b 55 0c             	mov    0xc(%ebp),%edx
  801027:	88 02                	mov    %al,(%edx)
	return 1;
  801029:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    
		return 0;
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
  801035:	eb f7                	jmp    80102e <devcons_read+0x36>

00801037 <cputchar>:
{
  801037:	f3 0f 1e fb          	endbr32 
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801047:	6a 01                	push   $0x1
  801049:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80104c:	50                   	push   %eax
  80104d:	e8 6e f0 ff ff       	call   8000c0 <sys_cputs>
}
  801052:	83 c4 10             	add    $0x10,%esp
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <getchar>:
{
  801057:	f3 0f 1e fb          	endbr32 
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801061:	6a 01                	push   $0x1
  801063:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801066:	50                   	push   %eax
  801067:	6a 00                	push   $0x0
  801069:	e8 5f f6 ff ff       	call   8006cd <read>
	if (r < 0)
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	78 06                	js     80107b <getchar+0x24>
	if (r < 1)
  801075:	74 06                	je     80107d <getchar+0x26>
	return c;
  801077:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    
		return -E_EOF;
  80107d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801082:	eb f7                	jmp    80107b <getchar+0x24>

00801084 <iscons>:
{
  801084:	f3 0f 1e fb          	endbr32 
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80108e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801091:	50                   	push   %eax
  801092:	ff 75 08             	pushl  0x8(%ebp)
  801095:	e8 b0 f3 ff ff       	call   80044a <fd_lookup>
  80109a:	83 c4 10             	add    $0x10,%esp
  80109d:	85 c0                	test   %eax,%eax
  80109f:	78 11                	js     8010b2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8010a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010aa:	39 10                	cmp    %edx,(%eax)
  8010ac:	0f 94 c0             	sete   %al
  8010af:	0f b6 c0             	movzbl %al,%eax
}
  8010b2:	c9                   	leave  
  8010b3:	c3                   	ret    

008010b4 <opencons>:
{
  8010b4:	f3 0f 1e fb          	endbr32 
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c1:	50                   	push   %eax
  8010c2:	e8 2d f3 ff ff       	call   8003f4 <fd_alloc>
  8010c7:	83 c4 10             	add    $0x10,%esp
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	78 3a                	js     801108 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	68 07 04 00 00       	push   $0x407
  8010d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d9:	6a 00                	push   $0x0
  8010db:	e8 b0 f0 ff ff       	call   800190 <sys_page_alloc>
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 21                	js     801108 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8010e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ea:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	50                   	push   %eax
  801100:	e8 c0 f2 ff ff       	call   8003c5 <fd2num>
  801105:	83 c4 10             	add    $0x10,%esp
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80110a:	f3 0f 1e fb          	endbr32 
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	56                   	push   %esi
  801112:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801113:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801116:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80111c:	e8 29 f0 ff ff       	call   80014a <sys_getenvid>
  801121:	83 ec 0c             	sub    $0xc,%esp
  801124:	ff 75 0c             	pushl  0xc(%ebp)
  801127:	ff 75 08             	pushl  0x8(%ebp)
  80112a:	56                   	push   %esi
  80112b:	50                   	push   %eax
  80112c:	68 c4 20 80 00       	push   $0x8020c4
  801131:	e8 bb 00 00 00       	call   8011f1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801136:	83 c4 18             	add    $0x18,%esp
  801139:	53                   	push   %ebx
  80113a:	ff 75 10             	pushl  0x10(%ebp)
  80113d:	e8 5a 00 00 00       	call   80119c <vcprintf>
	cprintf("\n");
  801142:	c7 04 24 af 20 80 00 	movl   $0x8020af,(%esp)
  801149:	e8 a3 00 00 00       	call   8011f1 <cprintf>
  80114e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801151:	cc                   	int3   
  801152:	eb fd                	jmp    801151 <_panic+0x47>

00801154 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801154:	f3 0f 1e fb          	endbr32 
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	53                   	push   %ebx
  80115c:	83 ec 04             	sub    $0x4,%esp
  80115f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801162:	8b 13                	mov    (%ebx),%edx
  801164:	8d 42 01             	lea    0x1(%edx),%eax
  801167:	89 03                	mov    %eax,(%ebx)
  801169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801170:	3d ff 00 00 00       	cmp    $0xff,%eax
  801175:	74 09                	je     801180 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801177:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80117b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	68 ff 00 00 00       	push   $0xff
  801188:	8d 43 08             	lea    0x8(%ebx),%eax
  80118b:	50                   	push   %eax
  80118c:	e8 2f ef ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  801191:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	eb db                	jmp    801177 <putch+0x23>

0080119c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80119c:	f3 0f 1e fb          	endbr32 
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011b0:	00 00 00 
	b.cnt = 0;
  8011b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011c9:	50                   	push   %eax
  8011ca:	68 54 11 80 00       	push   $0x801154
  8011cf:	e8 20 01 00 00       	call   8012f4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011d4:	83 c4 08             	add    $0x8,%esp
  8011d7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011dd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8011e3:	50                   	push   %eax
  8011e4:	e8 d7 ee ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  8011e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8011f1:	f3 0f 1e fb          	endbr32 
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8011fe:	50                   	push   %eax
  8011ff:	ff 75 08             	pushl  0x8(%ebp)
  801202:	e8 95 ff ff ff       	call   80119c <vcprintf>
	va_end(ap);

	return cnt;
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	57                   	push   %edi
  80120d:	56                   	push   %esi
  80120e:	53                   	push   %ebx
  80120f:	83 ec 1c             	sub    $0x1c,%esp
  801212:	89 c7                	mov    %eax,%edi
  801214:	89 d6                	mov    %edx,%esi
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121c:	89 d1                	mov    %edx,%ecx
  80121e:	89 c2                	mov    %eax,%edx
  801220:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801223:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80122c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80122f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801236:	39 c2                	cmp    %eax,%edx
  801238:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80123b:	72 3e                	jb     80127b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	ff 75 18             	pushl  0x18(%ebp)
  801243:	83 eb 01             	sub    $0x1,%ebx
  801246:	53                   	push   %ebx
  801247:	50                   	push   %eax
  801248:	83 ec 08             	sub    $0x8,%esp
  80124b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124e:	ff 75 e0             	pushl  -0x20(%ebp)
  801251:	ff 75 dc             	pushl  -0x24(%ebp)
  801254:	ff 75 d8             	pushl  -0x28(%ebp)
  801257:	e8 d4 0a 00 00       	call   801d30 <__udivdi3>
  80125c:	83 c4 18             	add    $0x18,%esp
  80125f:	52                   	push   %edx
  801260:	50                   	push   %eax
  801261:	89 f2                	mov    %esi,%edx
  801263:	89 f8                	mov    %edi,%eax
  801265:	e8 9f ff ff ff       	call   801209 <printnum>
  80126a:	83 c4 20             	add    $0x20,%esp
  80126d:	eb 13                	jmp    801282 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	56                   	push   %esi
  801273:	ff 75 18             	pushl  0x18(%ebp)
  801276:	ff d7                	call   *%edi
  801278:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80127b:	83 eb 01             	sub    $0x1,%ebx
  80127e:	85 db                	test   %ebx,%ebx
  801280:	7f ed                	jg     80126f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	56                   	push   %esi
  801286:	83 ec 04             	sub    $0x4,%esp
  801289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80128c:	ff 75 e0             	pushl  -0x20(%ebp)
  80128f:	ff 75 dc             	pushl  -0x24(%ebp)
  801292:	ff 75 d8             	pushl  -0x28(%ebp)
  801295:	e8 a6 0b 00 00       	call   801e40 <__umoddi3>
  80129a:	83 c4 14             	add    $0x14,%esp
  80129d:	0f be 80 e7 20 80 00 	movsbl 0x8020e7(%eax),%eax
  8012a4:	50                   	push   %eax
  8012a5:	ff d7                	call   *%edi
}
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012b2:	f3 0f 1e fb          	endbr32 
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012bc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8012c0:	8b 10                	mov    (%eax),%edx
  8012c2:	3b 50 04             	cmp    0x4(%eax),%edx
  8012c5:	73 0a                	jae    8012d1 <sprintputch+0x1f>
		*b->buf++ = ch;
  8012c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ca:	89 08                	mov    %ecx,(%eax)
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	88 02                	mov    %al,(%edx)
}
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <printfmt>:
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012dd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012e0:	50                   	push   %eax
  8012e1:	ff 75 10             	pushl  0x10(%ebp)
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	e8 05 00 00 00       	call   8012f4 <vprintfmt>
}
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <vprintfmt>:
{
  8012f4:	f3 0f 1e fb          	endbr32 
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	57                   	push   %edi
  8012fc:	56                   	push   %esi
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 3c             	sub    $0x3c,%esp
  801301:	8b 75 08             	mov    0x8(%ebp),%esi
  801304:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801307:	8b 7d 10             	mov    0x10(%ebp),%edi
  80130a:	e9 8e 03 00 00       	jmp    80169d <vprintfmt+0x3a9>
		padc = ' ';
  80130f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801313:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80131a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801321:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801328:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80132d:	8d 47 01             	lea    0x1(%edi),%eax
  801330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801333:	0f b6 17             	movzbl (%edi),%edx
  801336:	8d 42 dd             	lea    -0x23(%edx),%eax
  801339:	3c 55                	cmp    $0x55,%al
  80133b:	0f 87 df 03 00 00    	ja     801720 <vprintfmt+0x42c>
  801341:	0f b6 c0             	movzbl %al,%eax
  801344:	3e ff 24 85 20 22 80 	notrack jmp *0x802220(,%eax,4)
  80134b:	00 
  80134c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80134f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801353:	eb d8                	jmp    80132d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801358:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80135c:	eb cf                	jmp    80132d <vprintfmt+0x39>
  80135e:	0f b6 d2             	movzbl %dl,%edx
  801361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80136c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80136f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801373:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801379:	83 f9 09             	cmp    $0x9,%ecx
  80137c:	77 55                	ja     8013d3 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80137e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801381:	eb e9                	jmp    80136c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801383:	8b 45 14             	mov    0x14(%ebp),%eax
  801386:	8b 00                	mov    (%eax),%eax
  801388:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80138b:	8b 45 14             	mov    0x14(%ebp),%eax
  80138e:	8d 40 04             	lea    0x4(%eax),%eax
  801391:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801397:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80139b:	79 90                	jns    80132d <vprintfmt+0x39>
				width = precision, precision = -1;
  80139d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013a3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8013aa:	eb 81                	jmp    80132d <vprintfmt+0x39>
  8013ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b6:	0f 49 d0             	cmovns %eax,%edx
  8013b9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013bf:	e9 69 ff ff ff       	jmp    80132d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8013c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013c7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8013ce:	e9 5a ff ff ff       	jmp    80132d <vprintfmt+0x39>
  8013d3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013d9:	eb bc                	jmp    801397 <vprintfmt+0xa3>
			lflag++;
  8013db:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013e1:	e9 47 ff ff ff       	jmp    80132d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8013e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e9:	8d 78 04             	lea    0x4(%eax),%edi
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	ff 30                	pushl  (%eax)
  8013f2:	ff d6                	call   *%esi
			break;
  8013f4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8013f7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8013fa:	e9 9b 02 00 00       	jmp    80169a <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8d 78 04             	lea    0x4(%eax),%edi
  801405:	8b 00                	mov    (%eax),%eax
  801407:	99                   	cltd   
  801408:	31 d0                	xor    %edx,%eax
  80140a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80140c:	83 f8 0f             	cmp    $0xf,%eax
  80140f:	7f 23                	jg     801434 <vprintfmt+0x140>
  801411:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	74 18                	je     801434 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80141c:	52                   	push   %edx
  80141d:	68 7d 20 80 00       	push   $0x80207d
  801422:	53                   	push   %ebx
  801423:	56                   	push   %esi
  801424:	e8 aa fe ff ff       	call   8012d3 <printfmt>
  801429:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80142c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80142f:	e9 66 02 00 00       	jmp    80169a <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801434:	50                   	push   %eax
  801435:	68 ff 20 80 00       	push   $0x8020ff
  80143a:	53                   	push   %ebx
  80143b:	56                   	push   %esi
  80143c:	e8 92 fe ff ff       	call   8012d3 <printfmt>
  801441:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801444:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801447:	e9 4e 02 00 00       	jmp    80169a <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	83 c0 04             	add    $0x4,%eax
  801452:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801455:	8b 45 14             	mov    0x14(%ebp),%eax
  801458:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80145a:	85 d2                	test   %edx,%edx
  80145c:	b8 f8 20 80 00       	mov    $0x8020f8,%eax
  801461:	0f 45 c2             	cmovne %edx,%eax
  801464:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801467:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80146b:	7e 06                	jle    801473 <vprintfmt+0x17f>
  80146d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801471:	75 0d                	jne    801480 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801473:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801476:	89 c7                	mov    %eax,%edi
  801478:	03 45 e0             	add    -0x20(%ebp),%eax
  80147b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80147e:	eb 55                	jmp    8014d5 <vprintfmt+0x1e1>
  801480:	83 ec 08             	sub    $0x8,%esp
  801483:	ff 75 d8             	pushl  -0x28(%ebp)
  801486:	ff 75 cc             	pushl  -0x34(%ebp)
  801489:	e8 46 03 00 00       	call   8017d4 <strnlen>
  80148e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801491:	29 c2                	sub    %eax,%edx
  801493:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80149b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80149f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8014a2:	85 ff                	test   %edi,%edi
  8014a4:	7e 11                	jle    8014b7 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8014a6:	83 ec 08             	sub    $0x8,%esp
  8014a9:	53                   	push   %ebx
  8014aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8014ad:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014af:	83 ef 01             	sub    $0x1,%edi
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	eb eb                	jmp    8014a2 <vprintfmt+0x1ae>
  8014b7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8014ba:	85 d2                	test   %edx,%edx
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	0f 49 c2             	cmovns %edx,%eax
  8014c4:	29 c2                	sub    %eax,%edx
  8014c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8014c9:	eb a8                	jmp    801473 <vprintfmt+0x17f>
					putch(ch, putdat);
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	53                   	push   %ebx
  8014cf:	52                   	push   %edx
  8014d0:	ff d6                	call   *%esi
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014d8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014da:	83 c7 01             	add    $0x1,%edi
  8014dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8014e1:	0f be d0             	movsbl %al,%edx
  8014e4:	85 d2                	test   %edx,%edx
  8014e6:	74 4b                	je     801533 <vprintfmt+0x23f>
  8014e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014ec:	78 06                	js     8014f4 <vprintfmt+0x200>
  8014ee:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8014f2:	78 1e                	js     801512 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8014f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8014f8:	74 d1                	je     8014cb <vprintfmt+0x1d7>
  8014fa:	0f be c0             	movsbl %al,%eax
  8014fd:	83 e8 20             	sub    $0x20,%eax
  801500:	83 f8 5e             	cmp    $0x5e,%eax
  801503:	76 c6                	jbe    8014cb <vprintfmt+0x1d7>
					putch('?', putdat);
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	53                   	push   %ebx
  801509:	6a 3f                	push   $0x3f
  80150b:	ff d6                	call   *%esi
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	eb c3                	jmp    8014d5 <vprintfmt+0x1e1>
  801512:	89 cf                	mov    %ecx,%edi
  801514:	eb 0e                	jmp    801524 <vprintfmt+0x230>
				putch(' ', putdat);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	53                   	push   %ebx
  80151a:	6a 20                	push   $0x20
  80151c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80151e:	83 ef 01             	sub    $0x1,%edi
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	85 ff                	test   %edi,%edi
  801526:	7f ee                	jg     801516 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801528:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80152b:	89 45 14             	mov    %eax,0x14(%ebp)
  80152e:	e9 67 01 00 00       	jmp    80169a <vprintfmt+0x3a6>
  801533:	89 cf                	mov    %ecx,%edi
  801535:	eb ed                	jmp    801524 <vprintfmt+0x230>
	if (lflag >= 2)
  801537:	83 f9 01             	cmp    $0x1,%ecx
  80153a:	7f 1b                	jg     801557 <vprintfmt+0x263>
	else if (lflag)
  80153c:	85 c9                	test   %ecx,%ecx
  80153e:	74 63                	je     8015a3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801540:	8b 45 14             	mov    0x14(%ebp),%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801548:	99                   	cltd   
  801549:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80154c:	8b 45 14             	mov    0x14(%ebp),%eax
  80154f:	8d 40 04             	lea    0x4(%eax),%eax
  801552:	89 45 14             	mov    %eax,0x14(%ebp)
  801555:	eb 17                	jmp    80156e <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801557:	8b 45 14             	mov    0x14(%ebp),%eax
  80155a:	8b 50 04             	mov    0x4(%eax),%edx
  80155d:	8b 00                	mov    (%eax),%eax
  80155f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801562:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	8d 40 08             	lea    0x8(%eax),%eax
  80156b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80156e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801571:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801574:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801579:	85 c9                	test   %ecx,%ecx
  80157b:	0f 89 ff 00 00 00    	jns    801680 <vprintfmt+0x38c>
				putch('-', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	53                   	push   %ebx
  801585:	6a 2d                	push   $0x2d
  801587:	ff d6                	call   *%esi
				num = -(long long) num;
  801589:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80158c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80158f:	f7 da                	neg    %edx
  801591:	83 d1 00             	adc    $0x0,%ecx
  801594:	f7 d9                	neg    %ecx
  801596:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801599:	b8 0a 00 00 00       	mov    $0xa,%eax
  80159e:	e9 dd 00 00 00       	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8015a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ab:	99                   	cltd   
  8015ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8015af:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b2:	8d 40 04             	lea    0x4(%eax),%eax
  8015b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8015b8:	eb b4                	jmp    80156e <vprintfmt+0x27a>
	if (lflag >= 2)
  8015ba:	83 f9 01             	cmp    $0x1,%ecx
  8015bd:	7f 1e                	jg     8015dd <vprintfmt+0x2e9>
	else if (lflag)
  8015bf:	85 c9                	test   %ecx,%ecx
  8015c1:	74 32                	je     8015f5 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	8b 10                	mov    (%eax),%edx
  8015c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015cd:	8d 40 04             	lea    0x4(%eax),%eax
  8015d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015d3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8015d8:	e9 a3 00 00 00       	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8015dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e0:	8b 10                	mov    (%eax),%edx
  8015e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8015e5:	8d 40 08             	lea    0x8(%eax),%eax
  8015e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8015eb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8015f0:	e9 8b 00 00 00       	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8015f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f8:	8b 10                	mov    (%eax),%edx
  8015fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015ff:	8d 40 04             	lea    0x4(%eax),%eax
  801602:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801605:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80160a:	eb 74                	jmp    801680 <vprintfmt+0x38c>
	if (lflag >= 2)
  80160c:	83 f9 01             	cmp    $0x1,%ecx
  80160f:	7f 1b                	jg     80162c <vprintfmt+0x338>
	else if (lflag)
  801611:	85 c9                	test   %ecx,%ecx
  801613:	74 2c                	je     801641 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801615:	8b 45 14             	mov    0x14(%ebp),%eax
  801618:	8b 10                	mov    (%eax),%edx
  80161a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80161f:	8d 40 04             	lea    0x4(%eax),%eax
  801622:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  801625:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80162a:	eb 54                	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80162c:	8b 45 14             	mov    0x14(%ebp),%eax
  80162f:	8b 10                	mov    (%eax),%edx
  801631:	8b 48 04             	mov    0x4(%eax),%ecx
  801634:	8d 40 08             	lea    0x8(%eax),%eax
  801637:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80163a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80163f:	eb 3f                	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801641:	8b 45 14             	mov    0x14(%ebp),%eax
  801644:	8b 10                	mov    (%eax),%edx
  801646:	b9 00 00 00 00       	mov    $0x0,%ecx
  80164b:	8d 40 04             	lea    0x4(%eax),%eax
  80164e:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  801651:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801656:	eb 28                	jmp    801680 <vprintfmt+0x38c>
			putch('0', putdat);
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	53                   	push   %ebx
  80165c:	6a 30                	push   $0x30
  80165e:	ff d6                	call   *%esi
			putch('x', putdat);
  801660:	83 c4 08             	add    $0x8,%esp
  801663:	53                   	push   %ebx
  801664:	6a 78                	push   $0x78
  801666:	ff d6                	call   *%esi
			num = (unsigned long long)
  801668:	8b 45 14             	mov    0x14(%ebp),%eax
  80166b:	8b 10                	mov    (%eax),%edx
  80166d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801672:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801675:	8d 40 04             	lea    0x4(%eax),%eax
  801678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80167b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801687:	57                   	push   %edi
  801688:	ff 75 e0             	pushl  -0x20(%ebp)
  80168b:	50                   	push   %eax
  80168c:	51                   	push   %ecx
  80168d:	52                   	push   %edx
  80168e:	89 da                	mov    %ebx,%edx
  801690:	89 f0                	mov    %esi,%eax
  801692:	e8 72 fb ff ff       	call   801209 <printnum>
			break;
  801697:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80169a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80169d:	83 c7 01             	add    $0x1,%edi
  8016a0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016a4:	83 f8 25             	cmp    $0x25,%eax
  8016a7:	0f 84 62 fc ff ff    	je     80130f <vprintfmt+0x1b>
			if (ch == '\0')
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	0f 84 8b 00 00 00    	je     801740 <vprintfmt+0x44c>
			putch(ch, putdat);
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	53                   	push   %ebx
  8016b9:	50                   	push   %eax
  8016ba:	ff d6                	call   *%esi
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	eb dc                	jmp    80169d <vprintfmt+0x3a9>
	if (lflag >= 2)
  8016c1:	83 f9 01             	cmp    $0x1,%ecx
  8016c4:	7f 1b                	jg     8016e1 <vprintfmt+0x3ed>
	else if (lflag)
  8016c6:	85 c9                	test   %ecx,%ecx
  8016c8:	74 2c                	je     8016f6 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8016ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cd:	8b 10                	mov    (%eax),%edx
  8016cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016d4:	8d 40 04             	lea    0x4(%eax),%eax
  8016d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016da:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8016df:	eb 9f                	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8016e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e4:	8b 10                	mov    (%eax),%edx
  8016e6:	8b 48 04             	mov    0x4(%eax),%ecx
  8016e9:	8d 40 08             	lea    0x8(%eax),%eax
  8016ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ef:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8016f4:	eb 8a                	jmp    801680 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8016f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f9:	8b 10                	mov    (%eax),%edx
  8016fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801700:	8d 40 04             	lea    0x4(%eax),%eax
  801703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801706:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80170b:	e9 70 ff ff ff       	jmp    801680 <vprintfmt+0x38c>
			putch(ch, putdat);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	53                   	push   %ebx
  801714:	6a 25                	push   $0x25
  801716:	ff d6                	call   *%esi
			break;
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	e9 7a ff ff ff       	jmp    80169a <vprintfmt+0x3a6>
			putch('%', putdat);
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	53                   	push   %ebx
  801724:	6a 25                	push   $0x25
  801726:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	89 f8                	mov    %edi,%eax
  80172d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801731:	74 05                	je     801738 <vprintfmt+0x444>
  801733:	83 e8 01             	sub    $0x1,%eax
  801736:	eb f5                	jmp    80172d <vprintfmt+0x439>
  801738:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80173b:	e9 5a ff ff ff       	jmp    80169a <vprintfmt+0x3a6>
}
  801740:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5f                   	pop    %edi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801748:	f3 0f 1e fb          	endbr32 
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 18             	sub    $0x18,%esp
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801758:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80175f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801762:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801769:	85 c0                	test   %eax,%eax
  80176b:	74 26                	je     801793 <vsnprintf+0x4b>
  80176d:	85 d2                	test   %edx,%edx
  80176f:	7e 22                	jle    801793 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801771:	ff 75 14             	pushl  0x14(%ebp)
  801774:	ff 75 10             	pushl  0x10(%ebp)
  801777:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80177a:	50                   	push   %eax
  80177b:	68 b2 12 80 00       	push   $0x8012b2
  801780:	e8 6f fb ff ff       	call   8012f4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801788:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	83 c4 10             	add    $0x10,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    
		return -E_INVAL;
  801793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801798:	eb f7                	jmp    801791 <vsnprintf+0x49>

0080179a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80179a:	f3 0f 1e fb          	endbr32 
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017a4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017a7:	50                   	push   %eax
  8017a8:	ff 75 10             	pushl  0x10(%ebp)
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	ff 75 08             	pushl  0x8(%ebp)
  8017b1:	e8 92 ff ff ff       	call   801748 <vsnprintf>
	va_end(ap);

	return rc;
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017b8:	f3 0f 1e fb          	endbr32 
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017cb:	74 05                	je     8017d2 <strlen+0x1a>
		n++;
  8017cd:	83 c0 01             	add    $0x1,%eax
  8017d0:	eb f5                	jmp    8017c7 <strlen+0xf>
	return n;
}
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017d4:	f3 0f 1e fb          	endbr32 
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	39 d0                	cmp    %edx,%eax
  8017e8:	74 0d                	je     8017f7 <strnlen+0x23>
  8017ea:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8017ee:	74 05                	je     8017f5 <strnlen+0x21>
		n++;
  8017f0:	83 c0 01             	add    $0x1,%eax
  8017f3:	eb f1                	jmp    8017e6 <strnlen+0x12>
  8017f5:	89 c2                	mov    %eax,%edx
	return n;
}
  8017f7:	89 d0                	mov    %edx,%eax
  8017f9:	5d                   	pop    %ebp
  8017fa:	c3                   	ret    

008017fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8017fb:	f3 0f 1e fb          	endbr32 
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	53                   	push   %ebx
  801803:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801806:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
  80180e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801812:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801815:	83 c0 01             	add    $0x1,%eax
  801818:	84 d2                	test   %dl,%dl
  80181a:	75 f2                	jne    80180e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80181c:	89 c8                	mov    %ecx,%eax
  80181e:	5b                   	pop    %ebx
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    

00801821 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801821:	f3 0f 1e fb          	endbr32 
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	53                   	push   %ebx
  801829:	83 ec 10             	sub    $0x10,%esp
  80182c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80182f:	53                   	push   %ebx
  801830:	e8 83 ff ff ff       	call   8017b8 <strlen>
  801835:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	01 d8                	add    %ebx,%eax
  80183d:	50                   	push   %eax
  80183e:	e8 b8 ff ff ff       	call   8017fb <strcpy>
	return dst;
}
  801843:	89 d8                	mov    %ebx,%eax
  801845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80184a:	f3 0f 1e fb          	endbr32 
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	8b 75 08             	mov    0x8(%ebp),%esi
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	89 f3                	mov    %esi,%ebx
  80185b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80185e:	89 f0                	mov    %esi,%eax
  801860:	39 d8                	cmp    %ebx,%eax
  801862:	74 11                	je     801875 <strncpy+0x2b>
		*dst++ = *src;
  801864:	83 c0 01             	add    $0x1,%eax
  801867:	0f b6 0a             	movzbl (%edx),%ecx
  80186a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80186d:	80 f9 01             	cmp    $0x1,%cl
  801870:	83 da ff             	sbb    $0xffffffff,%edx
  801873:	eb eb                	jmp    801860 <strncpy+0x16>
	}
	return ret;
}
  801875:	89 f0                	mov    %esi,%eax
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5d                   	pop    %ebp
  80187a:	c3                   	ret    

0080187b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80187b:	f3 0f 1e fb          	endbr32 
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	8b 75 08             	mov    0x8(%ebp),%esi
  801887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188a:	8b 55 10             	mov    0x10(%ebp),%edx
  80188d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80188f:	85 d2                	test   %edx,%edx
  801891:	74 21                	je     8018b4 <strlcpy+0x39>
  801893:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801897:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801899:	39 c2                	cmp    %eax,%edx
  80189b:	74 14                	je     8018b1 <strlcpy+0x36>
  80189d:	0f b6 19             	movzbl (%ecx),%ebx
  8018a0:	84 db                	test   %bl,%bl
  8018a2:	74 0b                	je     8018af <strlcpy+0x34>
			*dst++ = *src++;
  8018a4:	83 c1 01             	add    $0x1,%ecx
  8018a7:	83 c2 01             	add    $0x1,%edx
  8018aa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8018ad:	eb ea                	jmp    801899 <strlcpy+0x1e>
  8018af:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8018b1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018b4:	29 f0                	sub    %esi,%eax
}
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018c7:	0f b6 01             	movzbl (%ecx),%eax
  8018ca:	84 c0                	test   %al,%al
  8018cc:	74 0c                	je     8018da <strcmp+0x20>
  8018ce:	3a 02                	cmp    (%edx),%al
  8018d0:	75 08                	jne    8018da <strcmp+0x20>
		p++, q++;
  8018d2:	83 c1 01             	add    $0x1,%ecx
  8018d5:	83 c2 01             	add    $0x1,%edx
  8018d8:	eb ed                	jmp    8018c7 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018da:	0f b6 c0             	movzbl %al,%eax
  8018dd:	0f b6 12             	movzbl (%edx),%edx
  8018e0:	29 d0                	sub    %edx,%eax
}
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    

008018e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018e4:	f3 0f 1e fb          	endbr32 
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	53                   	push   %ebx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018f7:	eb 06                	jmp    8018ff <strncmp+0x1b>
		n--, p++, q++;
  8018f9:	83 c0 01             	add    $0x1,%eax
  8018fc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8018ff:	39 d8                	cmp    %ebx,%eax
  801901:	74 16                	je     801919 <strncmp+0x35>
  801903:	0f b6 08             	movzbl (%eax),%ecx
  801906:	84 c9                	test   %cl,%cl
  801908:	74 04                	je     80190e <strncmp+0x2a>
  80190a:	3a 0a                	cmp    (%edx),%cl
  80190c:	74 eb                	je     8018f9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80190e:	0f b6 00             	movzbl (%eax),%eax
  801911:	0f b6 12             	movzbl (%edx),%edx
  801914:	29 d0                	sub    %edx,%eax
}
  801916:	5b                   	pop    %ebx
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    
		return 0;
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
  80191e:	eb f6                	jmp    801916 <strncmp+0x32>

00801920 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801920:	f3 0f 1e fb          	endbr32 
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80192e:	0f b6 10             	movzbl (%eax),%edx
  801931:	84 d2                	test   %dl,%dl
  801933:	74 09                	je     80193e <strchr+0x1e>
		if (*s == c)
  801935:	38 ca                	cmp    %cl,%dl
  801937:	74 0a                	je     801943 <strchr+0x23>
	for (; *s; s++)
  801939:	83 c0 01             	add    $0x1,%eax
  80193c:	eb f0                	jmp    80192e <strchr+0xe>
			return (char *) s;
	return 0;
  80193e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    

00801945 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801945:	f3 0f 1e fb          	endbr32 
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801953:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801956:	38 ca                	cmp    %cl,%dl
  801958:	74 09                	je     801963 <strfind+0x1e>
  80195a:	84 d2                	test   %dl,%dl
  80195c:	74 05                	je     801963 <strfind+0x1e>
	for (; *s; s++)
  80195e:	83 c0 01             	add    $0x1,%eax
  801961:	eb f0                	jmp    801953 <strfind+0xe>
			break;
	return (char *) s;
}
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801965:	f3 0f 1e fb          	endbr32 
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	57                   	push   %edi
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801972:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801975:	85 c9                	test   %ecx,%ecx
  801977:	74 31                	je     8019aa <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801979:	89 f8                	mov    %edi,%eax
  80197b:	09 c8                	or     %ecx,%eax
  80197d:	a8 03                	test   $0x3,%al
  80197f:	75 23                	jne    8019a4 <memset+0x3f>
		c &= 0xFF;
  801981:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801985:	89 d3                	mov    %edx,%ebx
  801987:	c1 e3 08             	shl    $0x8,%ebx
  80198a:	89 d0                	mov    %edx,%eax
  80198c:	c1 e0 18             	shl    $0x18,%eax
  80198f:	89 d6                	mov    %edx,%esi
  801991:	c1 e6 10             	shl    $0x10,%esi
  801994:	09 f0                	or     %esi,%eax
  801996:	09 c2                	or     %eax,%edx
  801998:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80199a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80199d:	89 d0                	mov    %edx,%eax
  80199f:	fc                   	cld    
  8019a0:	f3 ab                	rep stos %eax,%es:(%edi)
  8019a2:	eb 06                	jmp    8019aa <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8019a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a7:	fc                   	cld    
  8019a8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8019aa:	89 f8                	mov    %edi,%eax
  8019ac:	5b                   	pop    %ebx
  8019ad:	5e                   	pop    %esi
  8019ae:	5f                   	pop    %edi
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    

008019b1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019b1:	f3 0f 1e fb          	endbr32 
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	57                   	push   %edi
  8019b9:	56                   	push   %esi
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019c3:	39 c6                	cmp    %eax,%esi
  8019c5:	73 32                	jae    8019f9 <memmove+0x48>
  8019c7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019ca:	39 c2                	cmp    %eax,%edx
  8019cc:	76 2b                	jbe    8019f9 <memmove+0x48>
		s += n;
		d += n;
  8019ce:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019d1:	89 fe                	mov    %edi,%esi
  8019d3:	09 ce                	or     %ecx,%esi
  8019d5:	09 d6                	or     %edx,%esi
  8019d7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019dd:	75 0e                	jne    8019ed <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019df:	83 ef 04             	sub    $0x4,%edi
  8019e2:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019e5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019e8:	fd                   	std    
  8019e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019eb:	eb 09                	jmp    8019f6 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019ed:	83 ef 01             	sub    $0x1,%edi
  8019f0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019f3:	fd                   	std    
  8019f4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019f6:	fc                   	cld    
  8019f7:	eb 1a                	jmp    801a13 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019f9:	89 c2                	mov    %eax,%edx
  8019fb:	09 ca                	or     %ecx,%edx
  8019fd:	09 f2                	or     %esi,%edx
  8019ff:	f6 c2 03             	test   $0x3,%dl
  801a02:	75 0a                	jne    801a0e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801a04:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801a07:	89 c7                	mov    %eax,%edi
  801a09:	fc                   	cld    
  801a0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801a0c:	eb 05                	jmp    801a13 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801a0e:	89 c7                	mov    %eax,%edi
  801a10:	fc                   	cld    
  801a11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801a13:	5e                   	pop    %esi
  801a14:	5f                   	pop    %edi
  801a15:	5d                   	pop    %ebp
  801a16:	c3                   	ret    

00801a17 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a17:	f3 0f 1e fb          	endbr32 
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801a21:	ff 75 10             	pushl  0x10(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	e8 82 ff ff ff       	call   8019b1 <memmove>
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a31:	f3 0f 1e fb          	endbr32 
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a40:	89 c6                	mov    %eax,%esi
  801a42:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a45:	39 f0                	cmp    %esi,%eax
  801a47:	74 1c                	je     801a65 <memcmp+0x34>
		if (*s1 != *s2)
  801a49:	0f b6 08             	movzbl (%eax),%ecx
  801a4c:	0f b6 1a             	movzbl (%edx),%ebx
  801a4f:	38 d9                	cmp    %bl,%cl
  801a51:	75 08                	jne    801a5b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a53:	83 c0 01             	add    $0x1,%eax
  801a56:	83 c2 01             	add    $0x1,%edx
  801a59:	eb ea                	jmp    801a45 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801a5b:	0f b6 c1             	movzbl %cl,%eax
  801a5e:	0f b6 db             	movzbl %bl,%ebx
  801a61:	29 d8                	sub    %ebx,%eax
  801a63:	eb 05                	jmp    801a6a <memcmp+0x39>
	}

	return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    

00801a6e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a6e:	f3 0f 1e fb          	endbr32 
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a7b:	89 c2                	mov    %eax,%edx
  801a7d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a80:	39 d0                	cmp    %edx,%eax
  801a82:	73 09                	jae    801a8d <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a84:	38 08                	cmp    %cl,(%eax)
  801a86:	74 05                	je     801a8d <memfind+0x1f>
	for (; s < ends; s++)
  801a88:	83 c0 01             	add    $0x1,%eax
  801a8b:	eb f3                	jmp    801a80 <memfind+0x12>
			break;
	return (void *) s;
}
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a8f:	f3 0f 1e fb          	endbr32 
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	57                   	push   %edi
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9f:	eb 03                	jmp    801aa4 <strtol+0x15>
		s++;
  801aa1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801aa4:	0f b6 01             	movzbl (%ecx),%eax
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f6                	je     801aa1 <strtol+0x12>
  801aab:	3c 09                	cmp    $0x9,%al
  801aad:	74 f2                	je     801aa1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801aaf:	3c 2b                	cmp    $0x2b,%al
  801ab1:	74 2a                	je     801add <strtol+0x4e>
	int neg = 0;
  801ab3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801ab8:	3c 2d                	cmp    $0x2d,%al
  801aba:	74 2b                	je     801ae7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801abc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801ac2:	75 0f                	jne    801ad3 <strtol+0x44>
  801ac4:	80 39 30             	cmpb   $0x30,(%ecx)
  801ac7:	74 28                	je     801af1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ac9:	85 db                	test   %ebx,%ebx
  801acb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ad0:	0f 44 d8             	cmove  %eax,%ebx
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801adb:	eb 46                	jmp    801b23 <strtol+0x94>
		s++;
  801add:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ae0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ae5:	eb d5                	jmp    801abc <strtol+0x2d>
		s++, neg = 1;
  801ae7:	83 c1 01             	add    $0x1,%ecx
  801aea:	bf 01 00 00 00       	mov    $0x1,%edi
  801aef:	eb cb                	jmp    801abc <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801af1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801af5:	74 0e                	je     801b05 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801af7:	85 db                	test   %ebx,%ebx
  801af9:	75 d8                	jne    801ad3 <strtol+0x44>
		s++, base = 8;
  801afb:	83 c1 01             	add    $0x1,%ecx
  801afe:	bb 08 00 00 00       	mov    $0x8,%ebx
  801b03:	eb ce                	jmp    801ad3 <strtol+0x44>
		s += 2, base = 16;
  801b05:	83 c1 02             	add    $0x2,%ecx
  801b08:	bb 10 00 00 00       	mov    $0x10,%ebx
  801b0d:	eb c4                	jmp    801ad3 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801b0f:	0f be d2             	movsbl %dl,%edx
  801b12:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801b15:	3b 55 10             	cmp    0x10(%ebp),%edx
  801b18:	7d 3a                	jge    801b54 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801b1a:	83 c1 01             	add    $0x1,%ecx
  801b1d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b21:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801b23:	0f b6 11             	movzbl (%ecx),%edx
  801b26:	8d 72 d0             	lea    -0x30(%edx),%esi
  801b29:	89 f3                	mov    %esi,%ebx
  801b2b:	80 fb 09             	cmp    $0x9,%bl
  801b2e:	76 df                	jbe    801b0f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801b30:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b33:	89 f3                	mov    %esi,%ebx
  801b35:	80 fb 19             	cmp    $0x19,%bl
  801b38:	77 08                	ja     801b42 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801b3a:	0f be d2             	movsbl %dl,%edx
  801b3d:	83 ea 57             	sub    $0x57,%edx
  801b40:	eb d3                	jmp    801b15 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801b42:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b45:	89 f3                	mov    %esi,%ebx
  801b47:	80 fb 19             	cmp    $0x19,%bl
  801b4a:	77 08                	ja     801b54 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801b4c:	0f be d2             	movsbl %dl,%edx
  801b4f:	83 ea 37             	sub    $0x37,%edx
  801b52:	eb c1                	jmp    801b15 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b58:	74 05                	je     801b5f <strtol+0xd0>
		*endptr = (char *) s;
  801b5a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b5d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b5f:	89 c2                	mov    %eax,%edx
  801b61:	f7 da                	neg    %edx
  801b63:	85 ff                	test   %edi,%edi
  801b65:	0f 45 c2             	cmovne %edx,%eax
}
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5f                   	pop    %edi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b6d:	f3 0f 1e fb          	endbr32 
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	53                   	push   %ebx
  801b75:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801b78:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801b7f:	74 0d                	je     801b8e <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    
		envid_t envid=sys_getenvid();
  801b8e:	e8 b7 e5 ff ff       	call   80014a <sys_getenvid>
  801b93:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	6a 07                	push   $0x7
  801b9a:	68 00 f0 bf ee       	push   $0xeebff000
  801b9f:	50                   	push   %eax
  801ba0:	e8 eb e5 ff ff       	call   800190 <sys_page_alloc>
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 29                	js     801bd5 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	68 a1 03 80 00       	push   $0x8003a1
  801bb4:	53                   	push   %ebx
  801bb5:	e8 35 e7 ff ff       	call   8002ef <sys_env_set_pgfault_upcall>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	79 c0                	jns    801b81 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	68 0c 24 80 00       	push   $0x80240c
  801bc9:	6a 24                	push   $0x24
  801bcb:	68 43 24 80 00       	push   $0x802443
  801bd0:	e8 35 f5 ff ff       	call   80110a <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	68 e0 23 80 00       	push   $0x8023e0
  801bdd:	6a 22                	push   $0x22
  801bdf:	68 43 24 80 00       	push   $0x802443
  801be4:	e8 21 f5 ff ff       	call   80110a <_panic>

00801be9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801be9:	f3 0f 1e fb          	endbr32 
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	56                   	push   %esi
  801bf1:	53                   	push   %ebx
  801bf2:	8b 75 08             	mov    0x8(%ebp),%esi
  801bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c02:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	50                   	push   %eax
  801c09:	e8 4e e7 ff ff       	call   80035c <sys_ipc_recv>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 2b                	js     801c40 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801c15:	85 f6                	test   %esi,%esi
  801c17:	74 0a                	je     801c23 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801c19:	a1 04 40 80 00       	mov    0x804004,%eax
  801c1e:	8b 40 74             	mov    0x74(%eax),%eax
  801c21:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801c23:	85 db                	test   %ebx,%ebx
  801c25:	74 0a                	je     801c31 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801c27:	a1 04 40 80 00       	mov    0x804004,%eax
  801c2c:	8b 40 78             	mov    0x78(%eax),%eax
  801c2f:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801c31:	a1 04 40 80 00       	mov    0x804004,%eax
  801c36:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
		if(from_env_store)
  801c40:	85 f6                	test   %esi,%esi
  801c42:	74 06                	je     801c4a <ipc_recv+0x61>
			*from_env_store=0;
  801c44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801c4a:	85 db                	test   %ebx,%ebx
  801c4c:	74 eb                	je     801c39 <ipc_recv+0x50>
			*perm_store=0;
  801c4e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c54:	eb e3                	jmp    801c39 <ipc_recv+0x50>

00801c56 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c56:	f3 0f 1e fb          	endbr32 
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c66:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801c6c:	85 db                	test   %ebx,%ebx
  801c6e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c73:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801c76:	ff 75 14             	pushl  0x14(%ebp)
  801c79:	53                   	push   %ebx
  801c7a:	56                   	push   %esi
  801c7b:	57                   	push   %edi
  801c7c:	e8 b4 e6 ff ff       	call   800335 <sys_ipc_try_send>
		if(!res)
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	85 c0                	test   %eax,%eax
  801c86:	74 20                	je     801ca8 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  801c88:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c8b:	75 07                	jne    801c94 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  801c8d:	e8 db e4 ff ff       	call   80016d <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801c92:	eb e2                	jmp    801c76 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	68 51 24 80 00       	push   $0x802451
  801c9c:	6a 3f                	push   $0x3f
  801c9e:	68 69 24 80 00       	push   $0x802469
  801ca3:	e8 62 f4 ff ff       	call   80110a <_panic>
	}
}
  801ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5f                   	pop    %edi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cb0:	f3 0f 1e fb          	endbr32 
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cbf:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cc2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cc8:	8b 52 50             	mov    0x50(%edx),%edx
  801ccb:	39 ca                	cmp    %ecx,%edx
  801ccd:	74 11                	je     801ce0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801ccf:	83 c0 01             	add    $0x1,%eax
  801cd2:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cd7:	75 e6                	jne    801cbf <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	eb 0b                	jmp    801ceb <ipc_find_env+0x3b>
			return envs[i].env_id;
  801ce0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ce3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ce8:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    

00801ced <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ced:	f3 0f 1e fb          	endbr32 
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cf7:	89 c2                	mov    %eax,%edx
  801cf9:	c1 ea 16             	shr    $0x16,%edx
  801cfc:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d03:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d08:	f6 c1 01             	test   $0x1,%cl
  801d0b:	74 1c                	je     801d29 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d0d:	c1 e8 0c             	shr    $0xc,%eax
  801d10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d17:	a8 01                	test   $0x1,%al
  801d19:	74 0e                	je     801d29 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d1b:	c1 e8 0c             	shr    $0xc,%eax
  801d1e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d25:	ef 
  801d26:	0f b7 d2             	movzwl %dx,%edx
}
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    
  801d2d:	66 90                	xchg   %ax,%ax
  801d2f:	90                   	nop

00801d30 <__udivdi3>:
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
  801d3b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d3f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d47:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d4b:	85 d2                	test   %edx,%edx
  801d4d:	75 19                	jne    801d68 <__udivdi3+0x38>
  801d4f:	39 f3                	cmp    %esi,%ebx
  801d51:	76 4d                	jbe    801da0 <__udivdi3+0x70>
  801d53:	31 ff                	xor    %edi,%edi
  801d55:	89 e8                	mov    %ebp,%eax
  801d57:	89 f2                	mov    %esi,%edx
  801d59:	f7 f3                	div    %ebx
  801d5b:	89 fa                	mov    %edi,%edx
  801d5d:	83 c4 1c             	add    $0x1c,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5f                   	pop    %edi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
  801d65:	8d 76 00             	lea    0x0(%esi),%esi
  801d68:	39 f2                	cmp    %esi,%edx
  801d6a:	76 14                	jbe    801d80 <__udivdi3+0x50>
  801d6c:	31 ff                	xor    %edi,%edi
  801d6e:	31 c0                	xor    %eax,%eax
  801d70:	89 fa                	mov    %edi,%edx
  801d72:	83 c4 1c             	add    $0x1c,%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5f                   	pop    %edi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    
  801d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d80:	0f bd fa             	bsr    %edx,%edi
  801d83:	83 f7 1f             	xor    $0x1f,%edi
  801d86:	75 48                	jne    801dd0 <__udivdi3+0xa0>
  801d88:	39 f2                	cmp    %esi,%edx
  801d8a:	72 06                	jb     801d92 <__udivdi3+0x62>
  801d8c:	31 c0                	xor    %eax,%eax
  801d8e:	39 eb                	cmp    %ebp,%ebx
  801d90:	77 de                	ja     801d70 <__udivdi3+0x40>
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	eb d7                	jmp    801d70 <__udivdi3+0x40>
  801d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801da0:	89 d9                	mov    %ebx,%ecx
  801da2:	85 db                	test   %ebx,%ebx
  801da4:	75 0b                	jne    801db1 <__udivdi3+0x81>
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	31 d2                	xor    %edx,%edx
  801dad:	f7 f3                	div    %ebx
  801daf:	89 c1                	mov    %eax,%ecx
  801db1:	31 d2                	xor    %edx,%edx
  801db3:	89 f0                	mov    %esi,%eax
  801db5:	f7 f1                	div    %ecx
  801db7:	89 c6                	mov    %eax,%esi
  801db9:	89 e8                	mov    %ebp,%eax
  801dbb:	89 f7                	mov    %esi,%edi
  801dbd:	f7 f1                	div    %ecx
  801dbf:	89 fa                	mov    %edi,%edx
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
  801dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd0:	89 f9                	mov    %edi,%ecx
  801dd2:	b8 20 00 00 00       	mov    $0x20,%eax
  801dd7:	29 f8                	sub    %edi,%eax
  801dd9:	d3 e2                	shl    %cl,%edx
  801ddb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ddf:	89 c1                	mov    %eax,%ecx
  801de1:	89 da                	mov    %ebx,%edx
  801de3:	d3 ea                	shr    %cl,%edx
  801de5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801de9:	09 d1                	or     %edx,%ecx
  801deb:	89 f2                	mov    %esi,%edx
  801ded:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df1:	89 f9                	mov    %edi,%ecx
  801df3:	d3 e3                	shl    %cl,%ebx
  801df5:	89 c1                	mov    %eax,%ecx
  801df7:	d3 ea                	shr    %cl,%edx
  801df9:	89 f9                	mov    %edi,%ecx
  801dfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801dff:	89 eb                	mov    %ebp,%ebx
  801e01:	d3 e6                	shl    %cl,%esi
  801e03:	89 c1                	mov    %eax,%ecx
  801e05:	d3 eb                	shr    %cl,%ebx
  801e07:	09 de                	or     %ebx,%esi
  801e09:	89 f0                	mov    %esi,%eax
  801e0b:	f7 74 24 08          	divl   0x8(%esp)
  801e0f:	89 d6                	mov    %edx,%esi
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	f7 64 24 0c          	mull   0xc(%esp)
  801e17:	39 d6                	cmp    %edx,%esi
  801e19:	72 15                	jb     801e30 <__udivdi3+0x100>
  801e1b:	89 f9                	mov    %edi,%ecx
  801e1d:	d3 e5                	shl    %cl,%ebp
  801e1f:	39 c5                	cmp    %eax,%ebp
  801e21:	73 04                	jae    801e27 <__udivdi3+0xf7>
  801e23:	39 d6                	cmp    %edx,%esi
  801e25:	74 09                	je     801e30 <__udivdi3+0x100>
  801e27:	89 d8                	mov    %ebx,%eax
  801e29:	31 ff                	xor    %edi,%edi
  801e2b:	e9 40 ff ff ff       	jmp    801d70 <__udivdi3+0x40>
  801e30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e33:	31 ff                	xor    %edi,%edi
  801e35:	e9 36 ff ff ff       	jmp    801d70 <__udivdi3+0x40>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	66 90                	xchg   %ax,%ax
  801e3e:	66 90                	xchg   %ax,%ax

00801e40 <__umoddi3>:
  801e40:	f3 0f 1e fb          	endbr32 
  801e44:	55                   	push   %ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e53:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	75 19                	jne    801e78 <__umoddi3+0x38>
  801e5f:	39 df                	cmp    %ebx,%edi
  801e61:	76 5d                	jbe    801ec0 <__umoddi3+0x80>
  801e63:	89 f0                	mov    %esi,%eax
  801e65:	89 da                	mov    %ebx,%edx
  801e67:	f7 f7                	div    %edi
  801e69:	89 d0                	mov    %edx,%eax
  801e6b:	31 d2                	xor    %edx,%edx
  801e6d:	83 c4 1c             	add    $0x1c,%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5e                   	pop    %esi
  801e72:	5f                   	pop    %edi
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    
  801e75:	8d 76 00             	lea    0x0(%esi),%esi
  801e78:	89 f2                	mov    %esi,%edx
  801e7a:	39 d8                	cmp    %ebx,%eax
  801e7c:	76 12                	jbe    801e90 <__umoddi3+0x50>
  801e7e:	89 f0                	mov    %esi,%eax
  801e80:	89 da                	mov    %ebx,%edx
  801e82:	83 c4 1c             	add    $0x1c,%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5f                   	pop    %edi
  801e88:	5d                   	pop    %ebp
  801e89:	c3                   	ret    
  801e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e90:	0f bd e8             	bsr    %eax,%ebp
  801e93:	83 f5 1f             	xor    $0x1f,%ebp
  801e96:	75 50                	jne    801ee8 <__umoddi3+0xa8>
  801e98:	39 d8                	cmp    %ebx,%eax
  801e9a:	0f 82 e0 00 00 00    	jb     801f80 <__umoddi3+0x140>
  801ea0:	89 d9                	mov    %ebx,%ecx
  801ea2:	39 f7                	cmp    %esi,%edi
  801ea4:	0f 86 d6 00 00 00    	jbe    801f80 <__umoddi3+0x140>
  801eaa:	89 d0                	mov    %edx,%eax
  801eac:	89 ca                	mov    %ecx,%edx
  801eae:	83 c4 1c             	add    $0x1c,%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    
  801eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ebd:	8d 76 00             	lea    0x0(%esi),%esi
  801ec0:	89 fd                	mov    %edi,%ebp
  801ec2:	85 ff                	test   %edi,%edi
  801ec4:	75 0b                	jne    801ed1 <__umoddi3+0x91>
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	31 d2                	xor    %edx,%edx
  801ecd:	f7 f7                	div    %edi
  801ecf:	89 c5                	mov    %eax,%ebp
  801ed1:	89 d8                	mov    %ebx,%eax
  801ed3:	31 d2                	xor    %edx,%edx
  801ed5:	f7 f5                	div    %ebp
  801ed7:	89 f0                	mov    %esi,%eax
  801ed9:	f7 f5                	div    %ebp
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	31 d2                	xor    %edx,%edx
  801edf:	eb 8c                	jmp    801e6d <__umoddi3+0x2d>
  801ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ee8:	89 e9                	mov    %ebp,%ecx
  801eea:	ba 20 00 00 00       	mov    $0x20,%edx
  801eef:	29 ea                	sub    %ebp,%edx
  801ef1:	d3 e0                	shl    %cl,%eax
  801ef3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	89 f8                	mov    %edi,%eax
  801efb:	d3 e8                	shr    %cl,%eax
  801efd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f01:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f05:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f09:	09 c1                	or     %eax,%ecx
  801f0b:	89 d8                	mov    %ebx,%eax
  801f0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f11:	89 e9                	mov    %ebp,%ecx
  801f13:	d3 e7                	shl    %cl,%edi
  801f15:	89 d1                	mov    %edx,%ecx
  801f17:	d3 e8                	shr    %cl,%eax
  801f19:	89 e9                	mov    %ebp,%ecx
  801f1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f1f:	d3 e3                	shl    %cl,%ebx
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	89 d1                	mov    %edx,%ecx
  801f25:	89 f0                	mov    %esi,%eax
  801f27:	d3 e8                	shr    %cl,%eax
  801f29:	89 e9                	mov    %ebp,%ecx
  801f2b:	89 fa                	mov    %edi,%edx
  801f2d:	d3 e6                	shl    %cl,%esi
  801f2f:	09 d8                	or     %ebx,%eax
  801f31:	f7 74 24 08          	divl   0x8(%esp)
  801f35:	89 d1                	mov    %edx,%ecx
  801f37:	89 f3                	mov    %esi,%ebx
  801f39:	f7 64 24 0c          	mull   0xc(%esp)
  801f3d:	89 c6                	mov    %eax,%esi
  801f3f:	89 d7                	mov    %edx,%edi
  801f41:	39 d1                	cmp    %edx,%ecx
  801f43:	72 06                	jb     801f4b <__umoddi3+0x10b>
  801f45:	75 10                	jne    801f57 <__umoddi3+0x117>
  801f47:	39 c3                	cmp    %eax,%ebx
  801f49:	73 0c                	jae    801f57 <__umoddi3+0x117>
  801f4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f53:	89 d7                	mov    %edx,%edi
  801f55:	89 c6                	mov    %eax,%esi
  801f57:	89 ca                	mov    %ecx,%edx
  801f59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f5e:	29 f3                	sub    %esi,%ebx
  801f60:	19 fa                	sbb    %edi,%edx
  801f62:	89 d0                	mov    %edx,%eax
  801f64:	d3 e0                	shl    %cl,%eax
  801f66:	89 e9                	mov    %ebp,%ecx
  801f68:	d3 eb                	shr    %cl,%ebx
  801f6a:	d3 ea                	shr    %cl,%edx
  801f6c:	09 d8                	or     %ebx,%eax
  801f6e:	83 c4 1c             	add    $0x1c,%esp
  801f71:	5b                   	pop    %ebx
  801f72:	5e                   	pop    %esi
  801f73:	5f                   	pop    %edi
  801f74:	5d                   	pop    %ebp
  801f75:	c3                   	ret    
  801f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f7d:	8d 76 00             	lea    0x0(%esi),%esi
  801f80:	29 fe                	sub    %edi,%esi
  801f82:	19 c3                	sbb    %eax,%ebx
  801f84:	89 f2                	mov    %esi,%edx
  801f86:	89 d9                	mov    %ebx,%ecx
  801f88:	e9 1d ff ff ff       	jmp    801eaa <__umoddi3+0x6a>
