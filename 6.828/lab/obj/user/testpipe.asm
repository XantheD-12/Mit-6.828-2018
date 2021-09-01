
obj/user/testpipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003f:	c7 05 04 30 80 00 80 	movl   $0x802580,0x803004
  800046:	25 80 00 

	if ((i = pipe(p)) < 0)
  800049:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	e8 7b 1d 00 00       	call   801dcd <pipe>
  800052:	89 c6                	mov    %eax,%esi
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 1b 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005f:	e8 01 11 00 00       	call   801165 <fork>
  800064:	89 c3                	mov    %eax,%ebx
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 88 1e 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006e:	0f 85 56 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800074:	a1 04 40 80 00       	mov    0x804004,%eax
  800079:	8b 40 48             	mov    0x48(%eax),%eax
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	ff 75 90             	pushl  -0x70(%ebp)
  800082:	50                   	push   %eax
  800083:	68 ae 25 80 00       	push   $0x8025ae
  800088:	e8 98 03 00 00       	call   800425 <cprintf>
		close(p[1]);
  80008d:	83 c4 04             	add    $0x4,%esp
  800090:	ff 75 90             	pushl  -0x70(%ebp)
  800093:	e8 c8 14 00 00       	call   801560 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800098:	a1 04 40 80 00       	mov    0x804004,%eax
  80009d:	8b 40 48             	mov    0x48(%eax),%eax
  8000a0:	83 c4 0c             	add    $0xc,%esp
  8000a3:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a6:	50                   	push   %eax
  8000a7:	68 cb 25 80 00       	push   $0x8025cb
  8000ac:	e8 74 03 00 00       	call   800425 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	6a 63                	push   $0x63
  8000b6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b9:	50                   	push   %eax
  8000ba:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bd:	e8 73 16 00 00       	call   801735 <readn>
  8000c2:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	0f 88 cf 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cf:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d4:	83 ec 08             	sub    $0x8,%esp
  8000d7:	ff 35 00 30 80 00    	pushl  0x803000
  8000dd:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 08 0a 00 00       	call   800aee <strcmp>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	0f 85 bf 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 f1 25 80 00       	push   $0x8025f1
  8000f9:	e8 27 03 00 00       	call   800425 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  800101:	e8 1a 02 00 00       	call   800320 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	53                   	push   %ebx
  80010a:	e8 43 1e 00 00       	call   801f52 <wait>

	binaryname = "pipewriteeof";
  80010f:	c7 05 04 30 80 00 47 	movl   $0x802647,0x803004
  800116:	26 80 00 
	if ((i = pipe(p)) < 0)
  800119:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 a9 1c 00 00       	call   801dcd <pipe>
  800124:	89 c6                	mov    %eax,%esi
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	85 c0                	test   %eax,%eax
  80012b:	0f 88 32 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  800131:	e8 2f 10 00 00       	call   801165 <fork>
  800136:	89 c3                	mov    %eax,%ebx
  800138:	85 c0                	test   %eax,%eax
  80013a:	0f 88 35 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 0f 14 00 00       	call   801560 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 04 14 00 00       	call   801560 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 ee 1d 00 00       	call   801f52 <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 75 26 80 00 	movl   $0x802675,(%esp)
  80016b:	e8 b5 02 00 00       	call   800425 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 8c 25 80 00       	push   $0x80258c
  800180:	6a 0e                	push   $0xe
  800182:	68 95 25 80 00       	push   $0x802595
  800187:	e8 b2 01 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 a5 25 80 00       	push   $0x8025a5
  800192:	6a 11                	push   $0x11
  800194:	68 95 25 80 00       	push   $0x802595
  800199:	e8 a0 01 00 00       	call   80033e <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 e8 25 80 00       	push   $0x8025e8
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 95 25 80 00       	push   $0x802595
  8001ab:	e8 8e 01 00 00       	call   80033e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 0d 26 80 00       	push   $0x80260d
  8001bd:	e8 63 02 00 00       	call   800425 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 37 ff ff ff       	jmp    800101 <umain+0xce>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 ae 25 80 00       	push   $0x8025ae
  8001de:	e8 42 02 00 00       	call   800425 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 72 13 00 00       	call   801560 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 20 26 80 00       	push   $0x802620
  800202:	e8 1e 02 00 00       	call   800425 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 d7 07 00 00       	call   8009ec <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 59 15 00 00       	call   801780 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 b5 07 00 00       	call   8009ec <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 17 13 00 00       	call   801560 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b5 fe ff ff       	jmp    800106 <umain+0xd3>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 3d 26 80 00       	push   $0x80263d
  800257:	6a 25                	push   $0x25
  800259:	68 95 25 80 00       	push   $0x802595
  80025e:	e8 db 00 00 00       	call   80033e <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 8c 25 80 00       	push   $0x80258c
  800269:	6a 2c                	push   $0x2c
  80026b:	68 95 25 80 00       	push   $0x802595
  800270:	e8 c9 00 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 a5 25 80 00       	push   $0x8025a5
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 95 25 80 00       	push   $0x802595
  800282:	e8 b7 00 00 00       	call   80033e <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 ce 12 00 00       	call   801560 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 54 26 80 00       	push   $0x802654
  80029d:	e8 83 01 00 00       	call   800425 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 56 26 80 00       	push   $0x802656
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 cc 14 00 00       	call   801780 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 58 26 80 00       	push   $0x802658
  8002c4:	e8 5c 01 00 00       	call   800425 <cprintf>
		exit();
  8002c9:	e8 52 00 00 00       	call   800320 <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e5:	e8 41 0b 00 00       	call   800e2b <sys_getenvid>
  8002ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f7:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fc:	85 db                	test   %ebx,%ebx
  8002fe:	7e 07                	jle    800307 <libmain+0x31>
		binaryname = argv[0];
  800300:	8b 06                	mov    (%esi),%eax
  800302:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	e8 22 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800311:	e8 0a 00 00 00       	call   800320 <exit>
}
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80031c:	5b                   	pop    %ebx
  80031d:	5e                   	pop    %esi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800320:	f3 0f 1e fb          	endbr32 
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80032a:	e8 62 12 00 00       	call   801591 <close_all>
	sys_env_destroy(0);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	6a 00                	push   $0x0
  800334:	e8 ad 0a 00 00       	call   800de6 <sys_env_destroy>
}
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033e:	f3 0f 1e fb          	endbr32 
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	56                   	push   %esi
  800346:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800347:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034a:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800350:	e8 d6 0a 00 00       	call   800e2b <sys_getenvid>
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	56                   	push   %esi
  80035f:	50                   	push   %eax
  800360:	68 d8 26 80 00       	push   $0x8026d8
  800365:	e8 bb 00 00 00       	call   800425 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036a:	83 c4 18             	add    $0x18,%esp
  80036d:	53                   	push   %ebx
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	e8 5a 00 00 00       	call   8003d0 <vcprintf>
	cprintf("\n");
  800376:	c7 04 24 c9 25 80 00 	movl   $0x8025c9,(%esp)
  80037d:	e8 a3 00 00 00       	call   800425 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x47>

00800388 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	53                   	push   %ebx
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800396:	8b 13                	mov    (%ebx),%edx
  800398:	8d 42 01             	lea    0x1(%edx),%eax
  80039b:	89 03                	mov    %eax,(%ebx)
  80039d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a9:	74 09                	je     8003b4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	68 ff 00 00 00       	push   $0xff
  8003bc:	8d 43 08             	lea    0x8(%ebx),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 dc 09 00 00       	call   800da1 <sys_cputs>
		b->idx = 0;
  8003c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb db                	jmp    8003ab <putch+0x23>

008003d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d0:	f3 0f 1e fb          	endbr32 
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e4:	00 00 00 
	b.cnt = 0;
  8003e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f1:	ff 75 0c             	pushl  0xc(%ebp)
  8003f4:	ff 75 08             	pushl  0x8(%ebp)
  8003f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	68 88 03 80 00       	push   $0x800388
  800403:	e8 20 01 00 00       	call   800528 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800408:	83 c4 08             	add    $0x8,%esp
  80040b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800411:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800417:	50                   	push   %eax
  800418:	e8 84 09 00 00       	call   800da1 <sys_cputs>

	return b.cnt;
}
  80041d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800425:	f3 0f 1e fb          	endbr32 
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800432:	50                   	push   %eax
  800433:	ff 75 08             	pushl  0x8(%ebp)
  800436:	e8 95 ff ff ff       	call   8003d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	57                   	push   %edi
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 1c             	sub    $0x1c,%esp
  800446:	89 c7                	mov    %eax,%edi
  800448:	89 d6                	mov    %edx,%esi
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	89 c2                	mov    %eax,%edx
  800454:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800457:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800463:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046a:	39 c2                	cmp    %eax,%edx
  80046c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80046f:	72 3e                	jb     8004af <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	ff 75 18             	pushl  0x18(%ebp)
  800477:	83 eb 01             	sub    $0x1,%ebx
  80047a:	53                   	push   %ebx
  80047b:	50                   	push   %eax
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff 75 dc             	pushl  -0x24(%ebp)
  800488:	ff 75 d8             	pushl  -0x28(%ebp)
  80048b:	e8 90 1e 00 00       	call   802320 <__udivdi3>
  800490:	83 c4 18             	add    $0x18,%esp
  800493:	52                   	push   %edx
  800494:	50                   	push   %eax
  800495:	89 f2                	mov    %esi,%edx
  800497:	89 f8                	mov    %edi,%eax
  800499:	e8 9f ff ff ff       	call   80043d <printnum>
  80049e:	83 c4 20             	add    $0x20,%esp
  8004a1:	eb 13                	jmp    8004b6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	56                   	push   %esi
  8004a7:	ff 75 18             	pushl  0x18(%ebp)
  8004aa:	ff d7                	call   *%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004af:	83 eb 01             	sub    $0x1,%ebx
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7f ed                	jg     8004a3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c9:	e8 62 1f 00 00       	call   802430 <__umoddi3>
  8004ce:	83 c4 14             	add    $0x14,%esp
  8004d1:	0f be 80 fb 26 80 00 	movsbl 0x8026fb(%eax),%eax
  8004d8:	50                   	push   %eax
  8004d9:	ff d7                	call   *%edi
}
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e1:	5b                   	pop    %ebx
  8004e2:	5e                   	pop    %esi
  8004e3:	5f                   	pop    %edi
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e6:	f3 0f 1e fb          	endbr32 
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f9:	73 0a                	jae    800505 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fe:	89 08                	mov    %ecx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	88 02                	mov    %al,(%edx)
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <printfmt>:
{
  800507:	f3 0f 1e fb          	endbr32 
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800511:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800514:	50                   	push   %eax
  800515:	ff 75 10             	pushl  0x10(%ebp)
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	e8 05 00 00 00       	call   800528 <vprintfmt>
}
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	c9                   	leave  
  800527:	c3                   	ret    

00800528 <vprintfmt>:
{
  800528:	f3 0f 1e fb          	endbr32 
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	57                   	push   %edi
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 3c             	sub    $0x3c,%esp
  800535:	8b 75 08             	mov    0x8(%ebp),%esi
  800538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053e:	e9 8e 03 00 00       	jmp    8008d1 <vprintfmt+0x3a9>
		padc = ' ';
  800543:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800547:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80054e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800555:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8d 47 01             	lea    0x1(%edi),%eax
  800564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800567:	0f b6 17             	movzbl (%edi),%edx
  80056a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056d:	3c 55                	cmp    $0x55,%al
  80056f:	0f 87 df 03 00 00    	ja     800954 <vprintfmt+0x42c>
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	3e ff 24 85 40 28 80 	notrack jmp *0x802840(,%eax,4)
  80057f:	00 
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800583:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800587:	eb d8                	jmp    800561 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800589:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800590:	eb cf                	jmp    800561 <vprintfmt+0x39>
  800592:	0f b6 d2             	movzbl %dl,%edx
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005aa:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ad:	83 f9 09             	cmp    $0x9,%ecx
  8005b0:	77 55                	ja     800607 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b5:	eb e9                	jmp    8005a0 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 04             	lea    0x4(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cf:	79 90                	jns    800561 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005de:	eb 81                	jmp    800561 <vprintfmt+0x39>
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	85 c0                	test   %eax,%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	0f 49 d0             	cmovns %eax,%edx
  8005ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f3:	e9 69 ff ff ff       	jmp    800561 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005fb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800602:	e9 5a ff ff ff       	jmp    800561 <vprintfmt+0x39>
  800607:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	eb bc                	jmp    8005cb <vprintfmt+0xa3>
			lflag++;
  80060f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800615:	e9 47 ff ff ff       	jmp    800561 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 78 04             	lea    0x4(%eax),%edi
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	53                   	push   %ebx
  800624:	ff 30                	pushl  (%eax)
  800626:	ff d6                	call   *%esi
			break;
  800628:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062e:	e9 9b 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 78 04             	lea    0x4(%eax),%edi
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	99                   	cltd   
  80063c:	31 d0                	xor    %edx,%eax
  80063e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800640:	83 f8 0f             	cmp    $0xf,%eax
  800643:	7f 23                	jg     800668 <vprintfmt+0x140>
  800645:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80064c:	85 d2                	test   %edx,%edx
  80064e:	74 18                	je     800668 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800650:	52                   	push   %edx
  800651:	68 51 2c 80 00       	push   $0x802c51
  800656:	53                   	push   %ebx
  800657:	56                   	push   %esi
  800658:	e8 aa fe ff ff       	call   800507 <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800660:	89 7d 14             	mov    %edi,0x14(%ebp)
  800663:	e9 66 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800668:	50                   	push   %eax
  800669:	68 13 27 80 00       	push   $0x802713
  80066e:	53                   	push   %ebx
  80066f:	56                   	push   %esi
  800670:	e8 92 fe ff ff       	call   800507 <printfmt>
  800675:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800678:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067b:	e9 4e 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	83 c0 04             	add    $0x4,%eax
  800686:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 0c 27 80 00       	mov    $0x80270c,%eax
  800695:	0f 45 c2             	cmovne %edx,%eax
  800698:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069f:	7e 06                	jle    8006a7 <vprintfmt+0x17f>
  8006a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a5:	75 0d                	jne    8006b4 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006aa:	89 c7                	mov    %eax,%edi
  8006ac:	03 45 e0             	add    -0x20(%ebp),%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b2:	eb 55                	jmp    800709 <vprintfmt+0x1e1>
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ba:	ff 75 cc             	pushl  -0x34(%ebp)
  8006bd:	e8 46 03 00 00       	call   800a08 <strnlen>
  8006c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c5:	29 c2                	sub    %eax,%edx
  8006c7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006cf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	85 ff                	test   %edi,%edi
  8006d8:	7e 11                	jle    8006eb <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e3:	83 ef 01             	sub    $0x1,%edi
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	eb eb                	jmp    8006d6 <vprintfmt+0x1ae>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006fd:	eb a8                	jmp    8006a7 <vprintfmt+0x17f>
					putch(ch, putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	52                   	push   %edx
  800704:	ff d6                	call   *%esi
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80070c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	83 c7 01             	add    $0x1,%edi
  800711:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800715:	0f be d0             	movsbl %al,%edx
  800718:	85 d2                	test   %edx,%edx
  80071a:	74 4b                	je     800767 <vprintfmt+0x23f>
  80071c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800720:	78 06                	js     800728 <vprintfmt+0x200>
  800722:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800726:	78 1e                	js     800746 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800728:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80072c:	74 d1                	je     8006ff <vprintfmt+0x1d7>
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 e8 20             	sub    $0x20,%eax
  800734:	83 f8 5e             	cmp    $0x5e,%eax
  800737:	76 c6                	jbe    8006ff <vprintfmt+0x1d7>
					putch('?', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	6a 3f                	push   $0x3f
  80073f:	ff d6                	call   *%esi
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb c3                	jmp    800709 <vprintfmt+0x1e1>
  800746:	89 cf                	mov    %ecx,%edi
  800748:	eb 0e                	jmp    800758 <vprintfmt+0x230>
				putch(' ', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 20                	push   $0x20
  800750:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800752:	83 ef 01             	sub    $0x1,%edi
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	85 ff                	test   %edi,%edi
  80075a:	7f ee                	jg     80074a <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80075c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	e9 67 01 00 00       	jmp    8008ce <vprintfmt+0x3a6>
  800767:	89 cf                	mov    %ecx,%edi
  800769:	eb ed                	jmp    800758 <vprintfmt+0x230>
	if (lflag >= 2)
  80076b:	83 f9 01             	cmp    $0x1,%ecx
  80076e:	7f 1b                	jg     80078b <vprintfmt+0x263>
	else if (lflag)
  800770:	85 c9                	test   %ecx,%ecx
  800772:	74 63                	je     8007d7 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	99                   	cltd   
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
  800789:	eb 17                	jmp    8007a2 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 50 04             	mov    0x4(%eax),%edx
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 40 08             	lea    0x8(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007a8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	0f 89 ff 00 00 00    	jns    8008b4 <vprintfmt+0x38c>
				putch('-', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	6a 2d                	push   $0x2d
  8007bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8007bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c3:	f7 da                	neg    %edx
  8007c5:	83 d1 00             	adc    $0x0,%ecx
  8007c8:	f7 d9                	neg    %ecx
  8007ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d2:	e9 dd 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	99                   	cltd   
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	eb b4                	jmp    8007a2 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007ee:	83 f9 01             	cmp    $0x1,%ecx
  8007f1:	7f 1e                	jg     800811 <vprintfmt+0x2e9>
	else if (lflag)
  8007f3:	85 c9                	test   %ecx,%ecx
  8007f5:	74 32                	je     800829 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800807:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80080c:	e9 a3 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8b 10                	mov    (%eax),%edx
  800816:	8b 48 04             	mov    0x4(%eax),%ecx
  800819:	8d 40 08             	lea    0x8(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800824:	e9 8b 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8b 10                	mov    (%eax),%edx
  80082e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800833:	8d 40 04             	lea    0x4(%eax),%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800839:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80083e:	eb 74                	jmp    8008b4 <vprintfmt+0x38c>
	if (lflag >= 2)
  800840:	83 f9 01             	cmp    $0x1,%ecx
  800843:	7f 1b                	jg     800860 <vprintfmt+0x338>
	else if (lflag)
  800845:	85 c9                	test   %ecx,%ecx
  800847:	74 2c                	je     800875 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 10                	mov    (%eax),%edx
  80084e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800859:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80085e:	eb 54                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 10                	mov    (%eax),%edx
  800865:	8b 48 04             	mov    0x4(%eax),%ecx
  800868:	8d 40 08             	lea    0x8(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80086e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800873:	eb 3f                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 10                	mov    (%eax),%edx
  80087a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800885:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80088a:	eb 28                	jmp    8008b4 <vprintfmt+0x38c>
			putch('0', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 30                	push   $0x30
  800892:	ff d6                	call   *%esi
			putch('x', putdat);
  800894:	83 c4 08             	add    $0x8,%esp
  800897:	53                   	push   %ebx
  800898:	6a 78                	push   $0x78
  80089a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 10                	mov    (%eax),%edx
  8008a1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008af:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008bb:	57                   	push   %edi
  8008bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	51                   	push   %ecx
  8008c1:	52                   	push   %edx
  8008c2:	89 da                	mov    %ebx,%edx
  8008c4:	89 f0                	mov    %esi,%eax
  8008c6:	e8 72 fb ff ff       	call   80043d <printnum>
			break;
  8008cb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d1:	83 c7 01             	add    $0x1,%edi
  8008d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d8:	83 f8 25             	cmp    $0x25,%eax
  8008db:	0f 84 62 fc ff ff    	je     800543 <vprintfmt+0x1b>
			if (ch == '\0')
  8008e1:	85 c0                	test   %eax,%eax
  8008e3:	0f 84 8b 00 00 00    	je     800974 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	53                   	push   %ebx
  8008ed:	50                   	push   %eax
  8008ee:	ff d6                	call   *%esi
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb dc                	jmp    8008d1 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f5:	83 f9 01             	cmp    $0x1,%ecx
  8008f8:	7f 1b                	jg     800915 <vprintfmt+0x3ed>
	else if (lflag)
  8008fa:	85 c9                	test   %ecx,%ecx
  8008fc:	74 2c                	je     80092a <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8b 10                	mov    (%eax),%edx
  800903:	b9 00 00 00 00       	mov    $0x0,%ecx
  800908:	8d 40 04             	lea    0x4(%eax),%eax
  80090b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800913:	eb 9f                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 10                	mov    (%eax),%edx
  80091a:	8b 48 04             	mov    0x4(%eax),%ecx
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800923:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800928:	eb 8a                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 10                	mov    (%eax),%edx
  80092f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800934:	8d 40 04             	lea    0x4(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80093f:	e9 70 ff ff ff       	jmp    8008b4 <vprintfmt+0x38c>
			putch(ch, putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	53                   	push   %ebx
  800948:	6a 25                	push   $0x25
  80094a:	ff d6                	call   *%esi
			break;
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	e9 7a ff ff ff       	jmp    8008ce <vprintfmt+0x3a6>
			putch('%', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	53                   	push   %ebx
  800958:	6a 25                	push   $0x25
  80095a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095c:	83 c4 10             	add    $0x10,%esp
  80095f:	89 f8                	mov    %edi,%eax
  800961:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800965:	74 05                	je     80096c <vprintfmt+0x444>
  800967:	83 e8 01             	sub    $0x1,%eax
  80096a:	eb f5                	jmp    800961 <vprintfmt+0x439>
  80096c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096f:	e9 5a ff ff ff       	jmp    8008ce <vprintfmt+0x3a6>
}
  800974:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5f                   	pop    %edi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 18             	sub    $0x18,%esp
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80098f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800993:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	85 c0                	test   %eax,%eax
  80099f:	74 26                	je     8009c7 <vsnprintf+0x4b>
  8009a1:	85 d2                	test   %edx,%edx
  8009a3:	7e 22                	jle    8009c7 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a5:	ff 75 14             	pushl  0x14(%ebp)
  8009a8:	ff 75 10             	pushl  0x10(%ebp)
  8009ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	68 e6 04 80 00       	push   $0x8004e6
  8009b4:	e8 6f fb ff ff       	call   800528 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    
		return -E_INVAL;
  8009c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cc:	eb f7                	jmp    8009c5 <vsnprintf+0x49>

008009ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ce:	f3 0f 1e fb          	endbr32 
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009db:	50                   	push   %eax
  8009dc:	ff 75 10             	pushl  0x10(%ebp)
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 92 ff ff ff       	call   80097c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ec:	f3 0f 1e fb          	endbr32 
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ff:	74 05                	je     800a06 <strlen+0x1a>
		n++;
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	eb f5                	jmp    8009fb <strlen+0xf>
	return n;
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a08:	f3 0f 1e fb          	endbr32 
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	39 d0                	cmp    %edx,%eax
  800a1c:	74 0d                	je     800a2b <strnlen+0x23>
  800a1e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a22:	74 05                	je     800a29 <strnlen+0x21>
		n++;
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f1                	jmp    800a1a <strnlen+0x12>
  800a29:	89 c2                	mov    %eax,%edx
	return n;
}
  800a2b:	89 d0                	mov    %edx,%eax
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2f:	f3 0f 1e fb          	endbr32 
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	53                   	push   %ebx
  800a37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a42:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a46:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	75 f2                	jne    800a42 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a50:	89 c8                	mov    %ecx,%eax
  800a52:	5b                   	pop    %ebx
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	83 ec 10             	sub    $0x10,%esp
  800a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a63:	53                   	push   %ebx
  800a64:	e8 83 ff ff ff       	call   8009ec <strlen>
  800a69:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	01 d8                	add    %ebx,%eax
  800a71:	50                   	push   %eax
  800a72:	e8 b8 ff ff ff       	call   800a2f <strcpy>
	return dst;
}
  800a77:	89 d8                	mov    %ebx,%eax
  800a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7e:	f3 0f 1e fb          	endbr32 
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	89 f3                	mov    %esi,%ebx
  800a8f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a92:	89 f0                	mov    %esi,%eax
  800a94:	39 d8                	cmp    %ebx,%eax
  800a96:	74 11                	je     800aa9 <strncpy+0x2b>
		*dst++ = *src;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	0f b6 0a             	movzbl (%edx),%ecx
  800a9e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa1:	80 f9 01             	cmp    $0x1,%cl
  800aa4:	83 da ff             	sbb    $0xffffffff,%edx
  800aa7:	eb eb                	jmp    800a94 <strncpy+0x16>
	}
	return ret;
}
  800aa9:	89 f0                	mov    %esi,%eax
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aaf:	f3 0f 1e fb          	endbr32 
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	8b 75 08             	mov    0x8(%ebp),%esi
  800abb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abe:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac3:	85 d2                	test   %edx,%edx
  800ac5:	74 21                	je     800ae8 <strlcpy+0x39>
  800ac7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 14                	je     800ae5 <strlcpy+0x36>
  800ad1:	0f b6 19             	movzbl (%ecx),%ebx
  800ad4:	84 db                	test   %bl,%bl
  800ad6:	74 0b                	je     800ae3 <strlcpy+0x34>
			*dst++ = *src++;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae1:	eb ea                	jmp    800acd <strlcpy+0x1e>
  800ae3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae8:	29 f0                	sub    %esi,%eax
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aee:	f3 0f 1e fb          	endbr32 
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afb:	0f b6 01             	movzbl (%ecx),%eax
  800afe:	84 c0                	test   %al,%al
  800b00:	74 0c                	je     800b0e <strcmp+0x20>
  800b02:	3a 02                	cmp    (%edx),%al
  800b04:	75 08                	jne    800b0e <strcmp+0x20>
		p++, q++;
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	eb ed                	jmp    800afb <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0e:	0f b6 c0             	movzbl %al,%eax
  800b11:	0f b6 12             	movzbl (%edx),%edx
  800b14:	29 d0                	sub    %edx,%eax
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	53                   	push   %ebx
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b26:	89 c3                	mov    %eax,%ebx
  800b28:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2b:	eb 06                	jmp    800b33 <strncmp+0x1b>
		n--, p++, q++;
  800b2d:	83 c0 01             	add    $0x1,%eax
  800b30:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b33:	39 d8                	cmp    %ebx,%eax
  800b35:	74 16                	je     800b4d <strncmp+0x35>
  800b37:	0f b6 08             	movzbl (%eax),%ecx
  800b3a:	84 c9                	test   %cl,%cl
  800b3c:	74 04                	je     800b42 <strncmp+0x2a>
  800b3e:	3a 0a                	cmp    (%edx),%cl
  800b40:	74 eb                	je     800b2d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b42:	0f b6 00             	movzbl (%eax),%eax
  800b45:	0f b6 12             	movzbl (%edx),%edx
  800b48:	29 d0                	sub    %edx,%eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    
		return 0;
  800b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b52:	eb f6                	jmp    800b4a <strncmp+0x32>

00800b54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b62:	0f b6 10             	movzbl (%eax),%edx
  800b65:	84 d2                	test   %dl,%dl
  800b67:	74 09                	je     800b72 <strchr+0x1e>
		if (*s == c)
  800b69:	38 ca                	cmp    %cl,%dl
  800b6b:	74 0a                	je     800b77 <strchr+0x23>
	for (; *s; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f0                	jmp    800b62 <strchr+0xe>
			return (char *) s;
	return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b79:	f3 0f 1e fb          	endbr32 
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b87:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8a:	38 ca                	cmp    %cl,%dl
  800b8c:	74 09                	je     800b97 <strfind+0x1e>
  800b8e:	84 d2                	test   %dl,%dl
  800b90:	74 05                	je     800b97 <strfind+0x1e>
	for (; *s; s++)
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f0                	jmp    800b87 <strfind+0xe>
			break;
	return (char *) s;
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b99:	f3 0f 1e fb          	endbr32 
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba9:	85 c9                	test   %ecx,%ecx
  800bab:	74 31                	je     800bde <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bad:	89 f8                	mov    %edi,%eax
  800baf:	09 c8                	or     %ecx,%eax
  800bb1:	a8 03                	test   $0x3,%al
  800bb3:	75 23                	jne    800bd8 <memset+0x3f>
		c &= 0xFF;
  800bb5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	c1 e3 08             	shl    $0x8,%ebx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	c1 e0 18             	shl    $0x18,%eax
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	c1 e6 10             	shl    $0x10,%esi
  800bc8:	09 f0                	or     %esi,%eax
  800bca:	09 c2                	or     %eax,%edx
  800bcc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bce:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd1:	89 d0                	mov    %edx,%eax
  800bd3:	fc                   	cld    
  800bd4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd6:	eb 06                	jmp    800bde <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	fc                   	cld    
  800bdc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bde:	89 f8                	mov    %edi,%eax
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be5:	f3 0f 1e fb          	endbr32 
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf7:	39 c6                	cmp    %eax,%esi
  800bf9:	73 32                	jae    800c2d <memmove+0x48>
  800bfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	76 2b                	jbe    800c2d <memmove+0x48>
		s += n;
		d += n;
  800c02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c05:	89 fe                	mov    %edi,%esi
  800c07:	09 ce                	or     %ecx,%esi
  800c09:	09 d6                	or     %edx,%esi
  800c0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c11:	75 0e                	jne    800c21 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c13:	83 ef 04             	sub    $0x4,%edi
  800c16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1c:	fd                   	std    
  800c1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1f:	eb 09                	jmp    800c2a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c21:	83 ef 01             	sub    $0x1,%edi
  800c24:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c27:	fd                   	std    
  800c28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c2a:	fc                   	cld    
  800c2b:	eb 1a                	jmp    800c47 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	09 ca                	or     %ecx,%edx
  800c31:	09 f2                	or     %esi,%edx
  800c33:	f6 c2 03             	test   $0x3,%dl
  800c36:	75 0a                	jne    800c42 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3b:	89 c7                	mov    %eax,%edi
  800c3d:	fc                   	cld    
  800c3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c40:	eb 05                	jmp    800c47 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	fc                   	cld    
  800c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 82 ff ff ff       	call   800be5 <memmove>
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c74:	89 c6                	mov    %eax,%esi
  800c76:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c79:	39 f0                	cmp    %esi,%eax
  800c7b:	74 1c                	je     800c99 <memcmp+0x34>
		if (*s1 != *s2)
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	0f b6 1a             	movzbl (%edx),%ebx
  800c83:	38 d9                	cmp    %bl,%cl
  800c85:	75 08                	jne    800c8f <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c87:	83 c0 01             	add    $0x1,%eax
  800c8a:	83 c2 01             	add    $0x1,%edx
  800c8d:	eb ea                	jmp    800c79 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c8f:	0f b6 c1             	movzbl %cl,%eax
  800c92:	0f b6 db             	movzbl %bl,%ebx
  800c95:	29 d8                	sub    %ebx,%eax
  800c97:	eb 05                	jmp    800c9e <memcmp+0x39>
	}

	return 0;
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 09                	jae    800cc1 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb8:	38 08                	cmp    %cl,(%eax)
  800cba:	74 05                	je     800cc1 <memfind+0x1f>
	for (; s < ends; s++)
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	eb f3                	jmp    800cb4 <memfind+0x12>
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	f3 0f 1e fb          	endbr32 
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd3:	eb 03                	jmp    800cd8 <strtol+0x15>
		s++;
  800cd5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd8:	0f b6 01             	movzbl (%ecx),%eax
  800cdb:	3c 20                	cmp    $0x20,%al
  800cdd:	74 f6                	je     800cd5 <strtol+0x12>
  800cdf:	3c 09                	cmp    $0x9,%al
  800ce1:	74 f2                	je     800cd5 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ce3:	3c 2b                	cmp    $0x2b,%al
  800ce5:	74 2a                	je     800d11 <strtol+0x4e>
	int neg = 0;
  800ce7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cec:	3c 2d                	cmp    $0x2d,%al
  800cee:	74 2b                	je     800d1b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf6:	75 0f                	jne    800d07 <strtol+0x44>
  800cf8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cfb:	74 28                	je     800d25 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfd:	85 db                	test   %ebx,%ebx
  800cff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d04:	0f 44 d8             	cmove  %eax,%ebx
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0f:	eb 46                	jmp    800d57 <strtol+0x94>
		s++;
  800d11:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d14:	bf 00 00 00 00       	mov    $0x0,%edi
  800d19:	eb d5                	jmp    800cf0 <strtol+0x2d>
		s++, neg = 1;
  800d1b:	83 c1 01             	add    $0x1,%ecx
  800d1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d23:	eb cb                	jmp    800cf0 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d29:	74 0e                	je     800d39 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	75 d8                	jne    800d07 <strtol+0x44>
		s++, base = 8;
  800d2f:	83 c1 01             	add    $0x1,%ecx
  800d32:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d37:	eb ce                	jmp    800d07 <strtol+0x44>
		s += 2, base = 16;
  800d39:	83 c1 02             	add    $0x2,%ecx
  800d3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d41:	eb c4                	jmp    800d07 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d49:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d4c:	7d 3a                	jge    800d88 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d4e:	83 c1 01             	add    $0x1,%ecx
  800d51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d55:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d57:	0f b6 11             	movzbl (%ecx),%edx
  800d5a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d5d:	89 f3                	mov    %esi,%ebx
  800d5f:	80 fb 09             	cmp    $0x9,%bl
  800d62:	76 df                	jbe    800d43 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d64:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d67:	89 f3                	mov    %esi,%ebx
  800d69:	80 fb 19             	cmp    $0x19,%bl
  800d6c:	77 08                	ja     800d76 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d6e:	0f be d2             	movsbl %dl,%edx
  800d71:	83 ea 57             	sub    $0x57,%edx
  800d74:	eb d3                	jmp    800d49 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d79:	89 f3                	mov    %esi,%ebx
  800d7b:	80 fb 19             	cmp    $0x19,%bl
  800d7e:	77 08                	ja     800d88 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d80:	0f be d2             	movsbl %dl,%edx
  800d83:	83 ea 37             	sub    $0x37,%edx
  800d86:	eb c1                	jmp    800d49 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8c:	74 05                	je     800d93 <strtol+0xd0>
		*endptr = (char *) s;
  800d8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d93:	89 c2                	mov    %eax,%edx
  800d95:	f7 da                	neg    %edx
  800d97:	85 ff                	test   %edi,%edi
  800d99:	0f 45 c2             	cmovne %edx,%eax
}
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da1:	f3 0f 1e fb          	endbr32 
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	89 c3                	mov    %eax,%ebx
  800db8:	89 c7                	mov    %eax,%edi
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc3:	f3 0f 1e fb          	endbr32 
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd7:	89 d1                	mov    %edx,%ecx
  800dd9:	89 d3                	mov    %edx,%ebx
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800e00:	89 cb                	mov    %ecx,%ebx
  800e02:	89 cf                	mov    %ecx,%edi
  800e04:	89 ce                	mov    %ecx,%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 03                	push   $0x3
  800e1a:	68 ff 29 80 00       	push   $0x8029ff
  800e1f:	6a 23                	push   $0x23
  800e21:	68 1c 2a 80 00       	push   $0x802a1c
  800e26:	e8 13 f5 ff ff       	call   80033e <_panic>

00800e2b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e3f:	89 d1                	mov    %edx,%ecx
  800e41:	89 d3                	mov    %edx,%ebx
  800e43:	89 d7                	mov    %edx,%edi
  800e45:	89 d6                	mov    %edx,%esi
  800e47:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_yield>:

void
sys_yield(void)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e58:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e62:	89 d1                	mov    %edx,%ecx
  800e64:	89 d3                	mov    %edx,%ebx
  800e66:	89 d7                	mov    %edx,%edi
  800e68:	89 d6                	mov    %edx,%esi
  800e6a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e71:	f3 0f 1e fb          	endbr32 
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 04 00 00 00       	mov    $0x4,%eax
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	89 f7                	mov    %esi,%edi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 04                	push   $0x4
  800ea7:	68 ff 29 80 00       	push   $0x8029ff
  800eac:	6a 23                	push   $0x23
  800eae:	68 1c 2a 80 00       	push   $0x802a1c
  800eb3:	e8 86 f4 ff ff       	call   80033e <_panic>

00800eb8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb8:	f3 0f 1e fb          	endbr32 
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7f 08                	jg     800ee7 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	50                   	push   %eax
  800eeb:	6a 05                	push   $0x5
  800eed:	68 ff 29 80 00       	push   $0x8029ff
  800ef2:	6a 23                	push   $0x23
  800ef4:	68 1c 2a 80 00       	push   $0x802a1c
  800ef9:	e8 40 f4 ff ff       	call   80033e <_panic>

00800efe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800efe:	f3 0f 1e fb          	endbr32 
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1b:	89 df                	mov    %ebx,%edi
  800f1d:	89 de                	mov    %ebx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 06                	push   $0x6
  800f33:	68 ff 29 80 00       	push   $0x8029ff
  800f38:	6a 23                	push   $0x23
  800f3a:	68 1c 2a 80 00       	push   $0x802a1c
  800f3f:	e8 fa f3 ff ff       	call   80033e <_panic>

00800f44 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f44:	f3 0f 1e fb          	endbr32 
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f61:	89 df                	mov    %ebx,%edi
  800f63:	89 de                	mov    %ebx,%esi
  800f65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7f 08                	jg     800f73 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	6a 08                	push   $0x8
  800f79:	68 ff 29 80 00       	push   $0x8029ff
  800f7e:	6a 23                	push   $0x23
  800f80:	68 1c 2a 80 00       	push   $0x802a1c
  800f85:	e8 b4 f3 ff ff       	call   80033e <_panic>

00800f8a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	89 de                	mov    %ebx,%esi
  800fab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	7f 08                	jg     800fb9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	83 ec 0c             	sub    $0xc,%esp
  800fbc:	50                   	push   %eax
  800fbd:	6a 09                	push   $0x9
  800fbf:	68 ff 29 80 00       	push   $0x8029ff
  800fc4:	6a 23                	push   $0x23
  800fc6:	68 1c 2a 80 00       	push   $0x802a1c
  800fcb:	e8 6e f3 ff ff       	call   80033e <_panic>

00800fd0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd0:	f3 0f 1e fb          	endbr32 
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fed:	89 df                	mov    %ebx,%edi
  800fef:	89 de                	mov    %ebx,%esi
  800ff1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	7f 08                	jg     800fff <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	50                   	push   %eax
  801003:	6a 0a                	push   $0xa
  801005:	68 ff 29 80 00       	push   $0x8029ff
  80100a:	6a 23                	push   $0x23
  80100c:	68 1c 2a 80 00       	push   $0x802a1c
  801011:	e8 28 f3 ff ff       	call   80033e <_panic>

00801016 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801016:	f3 0f 1e fb          	endbr32 
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102b:	be 00 00 00 00       	mov    $0x0,%esi
  801030:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801033:	8b 7d 14             	mov    0x14(%ebp),%edi
  801036:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103d:	f3 0f 1e fb          	endbr32 
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	b8 0d 00 00 00       	mov    $0xd,%eax
  801057:	89 cb                	mov    %ecx,%ebx
  801059:	89 cf                	mov    %ecx,%edi
  80105b:	89 ce                	mov    %ecx,%esi
  80105d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7f 08                	jg     80106b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106b:	83 ec 0c             	sub    $0xc,%esp
  80106e:	50                   	push   %eax
  80106f:	6a 0d                	push   $0xd
  801071:	68 ff 29 80 00       	push   $0x8029ff
  801076:	6a 23                	push   $0x23
  801078:	68 1c 2a 80 00       	push   $0x802a1c
  80107d:	e8 bc f2 ff ff       	call   80033e <_panic>

00801082 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80108e:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  801090:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801094:	74 7f                	je     801115 <pgfault+0x93>
  801096:	89 f0                	mov    %esi,%eax
  801098:	c1 e8 0c             	shr    $0xc,%eax
  80109b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a2:	f6 c4 08             	test   $0x8,%ah
  8010a5:	74 6e                	je     801115 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  8010a7:	e8 7f fd ff ff       	call   800e2b <sys_getenvid>
  8010ac:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  8010ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  8010b4:	83 ec 04             	sub    $0x4,%esp
  8010b7:	6a 07                	push   $0x7
  8010b9:	68 00 f0 7f 00       	push   $0x7ff000
  8010be:	50                   	push   %eax
  8010bf:	e8 ad fd ff ff       	call   800e71 <sys_page_alloc>
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 5e                	js     801129 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  8010cb:	83 ec 04             	sub    $0x4,%esp
  8010ce:	68 00 10 00 00       	push   $0x1000
  8010d3:	56                   	push   %esi
  8010d4:	68 00 f0 7f 00       	push   $0x7ff000
  8010d9:	e8 6d fb ff ff       	call   800c4b <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  8010de:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	68 00 f0 7f 00       	push   $0x7ff000
  8010ec:	53                   	push   %ebx
  8010ed:	e8 c6 fd ff ff       	call   800eb8 <sys_page_map>
  8010f2:	83 c4 20             	add    $0x20,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 44                	js     80113d <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	68 00 f0 7f 00       	push   $0x7ff000
  801101:	53                   	push   %ebx
  801102:	e8 f7 fd ff ff       	call   800efe <sys_page_unmap>
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	78 43                	js     801151 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  80110e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  801115:	83 ec 04             	sub    $0x4,%esp
  801118:	68 2a 2a 80 00       	push   $0x802a2a
  80111d:	6a 1e                	push   $0x1e
  80111f:	68 47 2a 80 00       	push   $0x802a47
  801124:	e8 15 f2 ff ff       	call   80033e <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	68 d8 2a 80 00       	push   $0x802ad8
  801131:	6a 2b                	push   $0x2b
  801133:	68 47 2a 80 00       	push   $0x802a47
  801138:	e8 01 f2 ff ff       	call   80033e <_panic>
		panic("pgfault: sys_page_map Failed!");
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	68 52 2a 80 00       	push   $0x802a52
  801145:	6a 2f                	push   $0x2f
  801147:	68 47 2a 80 00       	push   $0x802a47
  80114c:	e8 ed f1 ff ff       	call   80033e <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  801151:	83 ec 04             	sub    $0x4,%esp
  801154:	68 f8 2a 80 00       	push   $0x802af8
  801159:	6a 32                	push   $0x32
  80115b:	68 47 2a 80 00       	push   $0x802a47
  801160:	e8 d9 f1 ff ff       	call   80033e <_panic>

00801165 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801165:	f3 0f 1e fb          	endbr32 
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801172:	68 82 10 80 00       	push   $0x801082
  801177:	e8 be 0f 00 00       	call   80213a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80117c:	b8 07 00 00 00       	mov    $0x7,%eax
  801181:	cd 30                	int    $0x30
  801183:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801186:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  801189:	83 c4 10             	add    $0x10,%esp
  80118c:	85 c0                	test   %eax,%eax
  80118e:	78 2b                	js     8011bb <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801190:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  801195:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801199:	0f 85 ba 00 00 00    	jne    801259 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  80119f:	e8 87 fc ff ff       	call   800e2b <sys_getenvid>
  8011a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011a9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011ac:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011b1:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8011b6:	e9 90 01 00 00       	jmp    80134b <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	68 70 2a 80 00       	push   $0x802a70
  8011c3:	6a 76                	push   $0x76
  8011c5:	68 47 2a 80 00       	push   $0x802a47
  8011ca:	e8 6f f1 ff ff       	call   80033e <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  8011cf:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  8011d6:	e8 50 fc ff ff       	call   800e2b <sys_getenvid>
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  8011e4:	56                   	push   %esi
  8011e5:	57                   	push   %edi
  8011e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8011e9:	57                   	push   %edi
  8011ea:	50                   	push   %eax
  8011eb:	e8 c8 fc ff ff       	call   800eb8 <sys_page_map>
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	79 50                	jns    801247 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	68 89 2a 80 00       	push   $0x802a89
  8011ff:	6a 4b                	push   $0x4b
  801201:	68 47 2a 80 00       	push   $0x802a47
  801206:	e8 33 f1 ff ff       	call   80033e <_panic>
			panic("duppage:child sys_page_map Failed!");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 18 2b 80 00       	push   $0x802b18
  801213:	6a 50                	push   $0x50
  801215:	68 47 2a 80 00       	push   $0x802a47
  80121a:	e8 1f f1 ff ff       	call   80033e <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  80121f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801226:	83 ec 0c             	sub    $0xc,%esp
  801229:	25 07 0e 00 00       	and    $0xe07,%eax
  80122e:	50                   	push   %eax
  80122f:	57                   	push   %edi
  801230:	ff 75 e0             	pushl  -0x20(%ebp)
  801233:	57                   	push   %edi
  801234:	ff 75 e4             	pushl  -0x1c(%ebp)
  801237:	e8 7c fc ff ff       	call   800eb8 <sys_page_map>
  80123c:	83 c4 20             	add    $0x20,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	0f 88 b4 00 00 00    	js     8012fb <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801247:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80124d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801253:	0f 84 b6 00 00 00    	je     80130f <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	c1 e8 16             	shr    $0x16,%eax
  80125e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801265:	a8 01                	test   $0x1,%al
  801267:	74 de                	je     801247 <fork+0xe2>
  801269:	89 de                	mov    %ebx,%esi
  80126b:	c1 ee 0c             	shr    $0xc,%esi
  80126e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801275:	a8 01                	test   $0x1,%al
  801277:	74 ce                	je     801247 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801279:	e8 ad fb ff ff       	call   800e2b <sys_getenvid>
  80127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801281:	89 f7                	mov    %esi,%edi
  801283:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  801286:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80128d:	f6 c4 04             	test   $0x4,%ah
  801290:	0f 85 39 ff ff ff    	jne    8011cf <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  801296:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80129d:	a9 02 08 00 00       	test   $0x802,%eax
  8012a2:	0f 84 77 ff ff ff    	je     80121f <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	68 05 08 00 00       	push   $0x805
  8012b0:	57                   	push   %edi
  8012b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8012b4:	57                   	push   %edi
  8012b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b8:	e8 fb fb ff ff       	call   800eb8 <sys_page_map>
  8012bd:	83 c4 20             	add    $0x20,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	0f 88 43 ff ff ff    	js     80120b <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8012c8:	83 ec 0c             	sub    $0xc,%esp
  8012cb:	68 05 08 00 00       	push   $0x805
  8012d0:	57                   	push   %edi
  8012d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d4:	50                   	push   %eax
  8012d5:	57                   	push   %edi
  8012d6:	50                   	push   %eax
  8012d7:	e8 dc fb ff ff       	call   800eb8 <sys_page_map>
  8012dc:	83 c4 20             	add    $0x20,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	0f 89 60 ff ff ff    	jns    801247 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	68 3c 2b 80 00       	push   $0x802b3c
  8012ef:	6a 52                	push   $0x52
  8012f1:	68 47 2a 80 00       	push   $0x802a47
  8012f6:	e8 43 f0 ff ff       	call   80033e <_panic>
			panic("duppage: single sys_page_map Failed!");
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	68 60 2b 80 00       	push   $0x802b60
  801303:	6a 56                	push   $0x56
  801305:	68 47 2a 80 00       	push   $0x802a47
  80130a:	e8 2f f0 ff ff       	call   80033e <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	6a 07                	push   $0x7
  801314:	68 00 f0 bf ee       	push   $0xeebff000
  801319:	ff 75 dc             	pushl  -0x24(%ebp)
  80131c:	e8 50 fb ff ff       	call   800e71 <sys_page_alloc>
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 2e                	js     801356 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	68 b6 21 80 00       	push   $0x8021b6
  801330:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801333:	57                   	push   %edi
  801334:	e8 97 fc ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	6a 02                	push   $0x2
  80133e:	57                   	push   %edi
  80133f:	e8 00 fc ff ff       	call   800f44 <sys_env_set_status>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 22                	js     80136d <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  80134b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80134e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	68 a6 2a 80 00       	push   $0x802aa6
  80135e:	68 83 00 00 00       	push   $0x83
  801363:	68 47 2a 80 00       	push   $0x802a47
  801368:	e8 d1 ef ff ff       	call   80033e <_panic>
		panic("fork: sys_env_set_status Failed!");
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 88 2b 80 00       	push   $0x802b88
  801375:	68 89 00 00 00       	push   $0x89
  80137a:	68 47 2a 80 00       	push   $0x802a47
  80137f:	e8 ba ef ff ff       	call   80033e <_panic>

00801384 <sfork>:

// Challenge!
int
sfork(void)
{
  801384:	f3 0f 1e fb          	endbr32 
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80138e:	68 c2 2a 80 00       	push   $0x802ac2
  801393:	68 93 00 00 00       	push   $0x93
  801398:	68 47 2a 80 00       	push   $0x802a47
  80139d:	e8 9c ef ff ff       	call   80033e <_panic>

008013a2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a2:	f3 0f 1e fb          	endbr32 
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	05 00 00 00 30       	add    $0x30000000,%eax
  8013b1:	c1 e8 0c             	shr    $0xc,%eax
}
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    

008013b6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b6:	f3 0f 1e fb          	endbr32 
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ca:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013cf:	5d                   	pop    %ebp
  8013d0:	c3                   	ret    

008013d1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013d1:	f3 0f 1e fb          	endbr32 
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	c1 ea 16             	shr    $0x16,%edx
  8013e2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e9:	f6 c2 01             	test   $0x1,%dl
  8013ec:	74 2d                	je     80141b <fd_alloc+0x4a>
  8013ee:	89 c2                	mov    %eax,%edx
  8013f0:	c1 ea 0c             	shr    $0xc,%edx
  8013f3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013fa:	f6 c2 01             	test   $0x1,%dl
  8013fd:	74 1c                	je     80141b <fd_alloc+0x4a>
  8013ff:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801404:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801409:	75 d2                	jne    8013dd <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801414:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801419:	eb 0a                	jmp    801425 <fd_alloc+0x54>
			*fd_store = fd;
  80141b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801427:	f3 0f 1e fb          	endbr32 
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801431:	83 f8 1f             	cmp    $0x1f,%eax
  801434:	77 30                	ja     801466 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801436:	c1 e0 0c             	shl    $0xc,%eax
  801439:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80143e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801444:	f6 c2 01             	test   $0x1,%dl
  801447:	74 24                	je     80146d <fd_lookup+0x46>
  801449:	89 c2                	mov    %eax,%edx
  80144b:	c1 ea 0c             	shr    $0xc,%edx
  80144e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801455:	f6 c2 01             	test   $0x1,%dl
  801458:	74 1a                	je     801474 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	89 02                	mov    %eax,(%edx)
	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    
		return -E_INVAL;
  801466:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146b:	eb f7                	jmp    801464 <fd_lookup+0x3d>
		return -E_INVAL;
  80146d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801472:	eb f0                	jmp    801464 <fd_lookup+0x3d>
  801474:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801479:	eb e9                	jmp    801464 <fd_lookup+0x3d>

0080147b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80147b:	f3 0f 1e fb          	endbr32 
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801488:	ba 28 2c 80 00       	mov    $0x802c28,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80148d:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801492:	39 08                	cmp    %ecx,(%eax)
  801494:	74 33                	je     8014c9 <dev_lookup+0x4e>
  801496:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801499:	8b 02                	mov    (%edx),%eax
  80149b:	85 c0                	test   %eax,%eax
  80149d:	75 f3                	jne    801492 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80149f:	a1 04 40 80 00       	mov    0x804004,%eax
  8014a4:	8b 40 48             	mov    0x48(%eax),%eax
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	51                   	push   %ecx
  8014ab:	50                   	push   %eax
  8014ac:	68 ac 2b 80 00       	push   $0x802bac
  8014b1:	e8 6f ef ff ff       	call   800425 <cprintf>
	*dev = 0;
  8014b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    
			*dev = devtab[i];
  8014c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014cc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	eb f2                	jmp    8014c7 <dev_lookup+0x4c>

008014d5 <fd_close>:
{
  8014d5:	f3 0f 1e fb          	endbr32 
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	57                   	push   %edi
  8014dd:	56                   	push   %esi
  8014de:	53                   	push   %ebx
  8014df:	83 ec 24             	sub    $0x24,%esp
  8014e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8014e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014eb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ec:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014f2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f5:	50                   	push   %eax
  8014f6:	e8 2c ff ff ff       	call   801427 <fd_lookup>
  8014fb:	89 c3                	mov    %eax,%ebx
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	78 05                	js     801509 <fd_close+0x34>
	    || fd != fd2)
  801504:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801507:	74 16                	je     80151f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801509:	89 f8                	mov    %edi,%eax
  80150b:	84 c0                	test   %al,%al
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
  801512:	0f 44 d8             	cmove  %eax,%ebx
}
  801515:	89 d8                	mov    %ebx,%eax
  801517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5f                   	pop    %edi
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801525:	50                   	push   %eax
  801526:	ff 36                	pushl  (%esi)
  801528:	e8 4e ff ff ff       	call   80147b <dev_lookup>
  80152d:	89 c3                	mov    %eax,%ebx
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	78 1a                	js     801550 <fd_close+0x7b>
		if (dev->dev_close)
  801536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801539:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80153c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801541:	85 c0                	test   %eax,%eax
  801543:	74 0b                	je     801550 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801545:	83 ec 0c             	sub    $0xc,%esp
  801548:	56                   	push   %esi
  801549:	ff d0                	call   *%eax
  80154b:	89 c3                	mov    %eax,%ebx
  80154d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	56                   	push   %esi
  801554:	6a 00                	push   $0x0
  801556:	e8 a3 f9 ff ff       	call   800efe <sys_page_unmap>
	return r;
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	eb b5                	jmp    801515 <fd_close+0x40>

00801560 <close>:

int
close(int fdnum)
{
  801560:	f3 0f 1e fb          	endbr32 
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80156a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156d:	50                   	push   %eax
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	e8 b1 fe ff ff       	call   801427 <fd_lookup>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	79 02                	jns    80157f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    
		return fd_close(fd, 1);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	6a 01                	push   $0x1
  801584:	ff 75 f4             	pushl  -0xc(%ebp)
  801587:	e8 49 ff ff ff       	call   8014d5 <fd_close>
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	eb ec                	jmp    80157d <close+0x1d>

00801591 <close_all>:

void
close_all(void)
{
  801591:	f3 0f 1e fb          	endbr32 
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80159c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	53                   	push   %ebx
  8015a5:	e8 b6 ff ff ff       	call   801560 <close>
	for (i = 0; i < MAXFD; i++)
  8015aa:	83 c3 01             	add    $0x1,%ebx
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	83 fb 20             	cmp    $0x20,%ebx
  8015b3:	75 ec                	jne    8015a1 <close_all+0x10>
}
  8015b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015ba:	f3 0f 1e fb          	endbr32 
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	57                   	push   %edi
  8015c2:	56                   	push   %esi
  8015c3:	53                   	push   %ebx
  8015c4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ca:	50                   	push   %eax
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	e8 54 fe ff ff       	call   801427 <fd_lookup>
  8015d3:	89 c3                	mov    %eax,%ebx
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	0f 88 81 00 00 00    	js     801661 <dup+0xa7>
		return r;
	close(newfdnum);
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	ff 75 0c             	pushl  0xc(%ebp)
  8015e6:	e8 75 ff ff ff       	call   801560 <close>

	newfd = INDEX2FD(newfdnum);
  8015eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ee:	c1 e6 0c             	shl    $0xc,%esi
  8015f1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015f7:	83 c4 04             	add    $0x4,%esp
  8015fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015fd:	e8 b4 fd ff ff       	call   8013b6 <fd2data>
  801602:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801604:	89 34 24             	mov    %esi,(%esp)
  801607:	e8 aa fd ff ff       	call   8013b6 <fd2data>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801611:	89 d8                	mov    %ebx,%eax
  801613:	c1 e8 16             	shr    $0x16,%eax
  801616:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80161d:	a8 01                	test   $0x1,%al
  80161f:	74 11                	je     801632 <dup+0x78>
  801621:	89 d8                	mov    %ebx,%eax
  801623:	c1 e8 0c             	shr    $0xc,%eax
  801626:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80162d:	f6 c2 01             	test   $0x1,%dl
  801630:	75 39                	jne    80166b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801635:	89 d0                	mov    %edx,%eax
  801637:	c1 e8 0c             	shr    $0xc,%eax
  80163a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	25 07 0e 00 00       	and    $0xe07,%eax
  801649:	50                   	push   %eax
  80164a:	56                   	push   %esi
  80164b:	6a 00                	push   $0x0
  80164d:	52                   	push   %edx
  80164e:	6a 00                	push   $0x0
  801650:	e8 63 f8 ff ff       	call   800eb8 <sys_page_map>
  801655:	89 c3                	mov    %eax,%ebx
  801657:	83 c4 20             	add    $0x20,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 31                	js     80168f <dup+0xd5>
		goto err;

	return newfdnum;
  80165e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801661:	89 d8                	mov    %ebx,%eax
  801663:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801666:	5b                   	pop    %ebx
  801667:	5e                   	pop    %esi
  801668:	5f                   	pop    %edi
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80166b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801672:	83 ec 0c             	sub    $0xc,%esp
  801675:	25 07 0e 00 00       	and    $0xe07,%eax
  80167a:	50                   	push   %eax
  80167b:	57                   	push   %edi
  80167c:	6a 00                	push   $0x0
  80167e:	53                   	push   %ebx
  80167f:	6a 00                	push   $0x0
  801681:	e8 32 f8 ff ff       	call   800eb8 <sys_page_map>
  801686:	89 c3                	mov    %eax,%ebx
  801688:	83 c4 20             	add    $0x20,%esp
  80168b:	85 c0                	test   %eax,%eax
  80168d:	79 a3                	jns    801632 <dup+0x78>
	sys_page_unmap(0, newfd);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	56                   	push   %esi
  801693:	6a 00                	push   $0x0
  801695:	e8 64 f8 ff ff       	call   800efe <sys_page_unmap>
	sys_page_unmap(0, nva);
  80169a:	83 c4 08             	add    $0x8,%esp
  80169d:	57                   	push   %edi
  80169e:	6a 00                	push   $0x0
  8016a0:	e8 59 f8 ff ff       	call   800efe <sys_page_unmap>
	return r;
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	eb b7                	jmp    801661 <dup+0xa7>

008016aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016aa:	f3 0f 1e fb          	endbr32 
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 1c             	sub    $0x1c,%esp
  8016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	53                   	push   %ebx
  8016bd:	e8 65 fd ff ff       	call   801427 <fd_lookup>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 3f                	js     801708 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	ff 30                	pushl  (%eax)
  8016d5:	e8 a1 fd ff ff       	call   80147b <dev_lookup>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 27                	js     801708 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e4:	8b 42 08             	mov    0x8(%edx),%eax
  8016e7:	83 e0 03             	and    $0x3,%eax
  8016ea:	83 f8 01             	cmp    $0x1,%eax
  8016ed:	74 1e                	je     80170d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f2:	8b 40 08             	mov    0x8(%eax),%eax
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	74 35                	je     80172e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	ff 75 10             	pushl  0x10(%ebp)
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	52                   	push   %edx
  801703:	ff d0                	call   *%eax
  801705:	83 c4 10             	add    $0x10,%esp
}
  801708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80170d:	a1 04 40 80 00       	mov    0x804004,%eax
  801712:	8b 40 48             	mov    0x48(%eax),%eax
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	53                   	push   %ebx
  801719:	50                   	push   %eax
  80171a:	68 ed 2b 80 00       	push   $0x802bed
  80171f:	e8 01 ed ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172c:	eb da                	jmp    801708 <read+0x5e>
		return -E_NOT_SUPP;
  80172e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801733:	eb d3                	jmp    801708 <read+0x5e>

00801735 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801735:	f3 0f 1e fb          	endbr32 
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	57                   	push   %edi
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	8b 7d 08             	mov    0x8(%ebp),%edi
  801745:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801748:	bb 00 00 00 00       	mov    $0x0,%ebx
  80174d:	eb 02                	jmp    801751 <readn+0x1c>
  80174f:	01 c3                	add    %eax,%ebx
  801751:	39 f3                	cmp    %esi,%ebx
  801753:	73 21                	jae    801776 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	89 f0                	mov    %esi,%eax
  80175a:	29 d8                	sub    %ebx,%eax
  80175c:	50                   	push   %eax
  80175d:	89 d8                	mov    %ebx,%eax
  80175f:	03 45 0c             	add    0xc(%ebp),%eax
  801762:	50                   	push   %eax
  801763:	57                   	push   %edi
  801764:	e8 41 ff ff ff       	call   8016aa <read>
		if (m < 0)
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 04                	js     801774 <readn+0x3f>
			return m;
		if (m == 0)
  801770:	75 dd                	jne    80174f <readn+0x1a>
  801772:	eb 02                	jmp    801776 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801774:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801776:	89 d8                	mov    %ebx,%eax
  801778:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5f                   	pop    %edi
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801780:	f3 0f 1e fb          	endbr32 
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	53                   	push   %ebx
  801788:	83 ec 1c             	sub    $0x1c,%esp
  80178b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801791:	50                   	push   %eax
  801792:	53                   	push   %ebx
  801793:	e8 8f fc ff ff       	call   801427 <fd_lookup>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 3a                	js     8017d9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a5:	50                   	push   %eax
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	ff 30                	pushl  (%eax)
  8017ab:	e8 cb fc ff ff       	call   80147b <dev_lookup>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 22                	js     8017d9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017be:	74 1e                	je     8017de <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c3:	8b 52 0c             	mov    0xc(%edx),%edx
  8017c6:	85 d2                	test   %edx,%edx
  8017c8:	74 35                	je     8017ff <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	ff 75 10             	pushl  0x10(%ebp)
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	ff d2                	call   *%edx
  8017d6:	83 c4 10             	add    $0x10,%esp
}
  8017d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017de:	a1 04 40 80 00       	mov    0x804004,%eax
  8017e3:	8b 40 48             	mov    0x48(%eax),%eax
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	53                   	push   %ebx
  8017ea:	50                   	push   %eax
  8017eb:	68 09 2c 80 00       	push   $0x802c09
  8017f0:	e8 30 ec ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fd:	eb da                	jmp    8017d9 <write+0x59>
		return -E_NOT_SUPP;
  8017ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801804:	eb d3                	jmp    8017d9 <write+0x59>

00801806 <seek>:

int
seek(int fdnum, off_t offset)
{
  801806:	f3 0f 1e fb          	endbr32 
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801810:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801813:	50                   	push   %eax
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 0b fc ff ff       	call   801427 <fd_lookup>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 0e                	js     801831 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801829:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801833:	f3 0f 1e fb          	endbr32 
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	53                   	push   %ebx
  80183b:	83 ec 1c             	sub    $0x1c,%esp
  80183e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801841:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801844:	50                   	push   %eax
  801845:	53                   	push   %ebx
  801846:	e8 dc fb ff ff       	call   801427 <fd_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 37                	js     801889 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801858:	50                   	push   %eax
  801859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185c:	ff 30                	pushl  (%eax)
  80185e:	e8 18 fc ff ff       	call   80147b <dev_lookup>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	78 1f                	js     801889 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801871:	74 1b                	je     80188e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801876:	8b 52 18             	mov    0x18(%edx),%edx
  801879:	85 d2                	test   %edx,%edx
  80187b:	74 32                	je     8018af <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	50                   	push   %eax
  801884:	ff d2                	call   *%edx
  801886:	83 c4 10             	add    $0x10,%esp
}
  801889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80188e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801893:	8b 40 48             	mov    0x48(%eax),%eax
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	53                   	push   %ebx
  80189a:	50                   	push   %eax
  80189b:	68 cc 2b 80 00       	push   $0x802bcc
  8018a0:	e8 80 eb ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ad:	eb da                	jmp    801889 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8018af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b4:	eb d3                	jmp    801889 <ftruncate+0x56>

008018b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018b6:	f3 0f 1e fb          	endbr32 
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 1c             	sub    $0x1c,%esp
  8018c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c7:	50                   	push   %eax
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	e8 57 fb ff ff       	call   801427 <fd_lookup>
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 4b                	js     801922 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018dd:	50                   	push   %eax
  8018de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e1:	ff 30                	pushl  (%eax)
  8018e3:	e8 93 fb ff ff       	call   80147b <dev_lookup>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 33                	js     801922 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018f6:	74 2f                	je     801927 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018f8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018fb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801902:	00 00 00 
	stat->st_isdir = 0;
  801905:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190c:	00 00 00 
	stat->st_dev = dev;
  80190f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	53                   	push   %ebx
  801919:	ff 75 f0             	pushl  -0x10(%ebp)
  80191c:	ff 50 14             	call   *0x14(%eax)
  80191f:	83 c4 10             	add    $0x10,%esp
}
  801922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801925:	c9                   	leave  
  801926:	c3                   	ret    
		return -E_NOT_SUPP;
  801927:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192c:	eb f4                	jmp    801922 <fstat+0x6c>

0080192e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80192e:	f3 0f 1e fb          	endbr32 
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	56                   	push   %esi
  801936:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	6a 00                	push   $0x0
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	e8 fb 01 00 00       	call   801b3f <open>
  801944:	89 c3                	mov    %eax,%ebx
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 1b                	js     801968 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	50                   	push   %eax
  801954:	e8 5d ff ff ff       	call   8018b6 <fstat>
  801959:	89 c6                	mov    %eax,%esi
	close(fd);
  80195b:	89 1c 24             	mov    %ebx,(%esp)
  80195e:	e8 fd fb ff ff       	call   801560 <close>
	return r;
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 f3                	mov    %esi,%ebx
}
  801968:	89 d8                	mov    %ebx,%eax
  80196a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5e                   	pop    %esi
  80196f:	5d                   	pop    %ebp
  801970:	c3                   	ret    

00801971 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	56                   	push   %esi
  801975:	53                   	push   %ebx
  801976:	89 c6                	mov    %eax,%esi
  801978:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80197a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801981:	74 27                	je     8019aa <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801983:	6a 07                	push   $0x7
  801985:	68 00 50 80 00       	push   $0x805000
  80198a:	56                   	push   %esi
  80198b:	ff 35 00 40 80 00    	pushl  0x804000
  801991:	e8 b1 08 00 00       	call   802247 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801996:	83 c4 0c             	add    $0xc,%esp
  801999:	6a 00                	push   $0x0
  80199b:	53                   	push   %ebx
  80199c:	6a 00                	push   $0x0
  80199e:	e8 37 08 00 00       	call   8021da <ipc_recv>
}
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019aa:	83 ec 0c             	sub    $0xc,%esp
  8019ad:	6a 01                	push   $0x1
  8019af:	e8 ed 08 00 00       	call   8022a1 <ipc_find_env>
  8019b4:	a3 00 40 80 00       	mov    %eax,0x804000
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	eb c5                	jmp    801983 <fsipc+0x12>

008019be <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019be:	f3 0f 1e fb          	endbr32 
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ce:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019db:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8019e5:	e8 87 ff ff ff       	call   801971 <fsipc>
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <devfile_flush>:
{
  8019ec:	f3 0f 1e fb          	endbr32 
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	b8 06 00 00 00       	mov    $0x6,%eax
  801a0b:	e8 61 ff ff ff       	call   801971 <fsipc>
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <devfile_stat>:
{
  801a12:	f3 0f 1e fb          	endbr32 
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8b 40 0c             	mov    0xc(%eax),%eax
  801a26:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a30:	b8 05 00 00 00       	mov    $0x5,%eax
  801a35:	e8 37 ff ff ff       	call   801971 <fsipc>
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 2c                	js     801a6a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a3e:	83 ec 08             	sub    $0x8,%esp
  801a41:	68 00 50 80 00       	push   $0x805000
  801a46:	53                   	push   %ebx
  801a47:	e8 e3 ef ff ff       	call   800a2f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a4c:	a1 80 50 80 00       	mov    0x805080,%eax
  801a51:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a57:	a1 84 50 80 00       	mov    0x805084,%eax
  801a5c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <devfile_write>:
{
  801a6f:	f3 0f 1e fb          	endbr32 
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 0c             	sub    $0xc,%esp
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a81:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a86:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a89:	8b 55 08             	mov    0x8(%ebp),%edx
  801a8c:	8b 52 0c             	mov    0xc(%edx),%edx
  801a8f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801a95:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801a9a:	50                   	push   %eax
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	68 08 50 80 00       	push   $0x805008
  801aa3:	e8 3d f1 ff ff       	call   800be5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  801aad:	b8 04 00 00 00       	mov    $0x4,%eax
  801ab2:	e8 ba fe ff ff       	call   801971 <fsipc>
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <devfile_read>:
{
  801ab9:	f3 0f 1e fb          	endbr32 
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	56                   	push   %esi
  801ac1:	53                   	push   %ebx
  801ac2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  801acb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ad0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  801adb:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae0:	e8 8c fe ff ff       	call   801971 <fsipc>
  801ae5:	89 c3                	mov    %eax,%ebx
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	78 1f                	js     801b0a <devfile_read+0x51>
	assert(r <= n);
  801aeb:	39 f0                	cmp    %esi,%eax
  801aed:	77 24                	ja     801b13 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801aef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801af4:	7f 33                	jg     801b29 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	50                   	push   %eax
  801afa:	68 00 50 80 00       	push   $0x805000
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	e8 de f0 ff ff       	call   800be5 <memmove>
	return r;
  801b07:	83 c4 10             	add    $0x10,%esp
}
  801b0a:	89 d8                	mov    %ebx,%eax
  801b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
	assert(r <= n);
  801b13:	68 38 2c 80 00       	push   $0x802c38
  801b18:	68 3f 2c 80 00       	push   $0x802c3f
  801b1d:	6a 7d                	push   $0x7d
  801b1f:	68 54 2c 80 00       	push   $0x802c54
  801b24:	e8 15 e8 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801b29:	68 5f 2c 80 00       	push   $0x802c5f
  801b2e:	68 3f 2c 80 00       	push   $0x802c3f
  801b33:	6a 7e                	push   $0x7e
  801b35:	68 54 2c 80 00       	push   $0x802c54
  801b3a:	e8 ff e7 ff ff       	call   80033e <_panic>

00801b3f <open>:
{
  801b3f:	f3 0f 1e fb          	endbr32 
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
  801b4b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b4e:	56                   	push   %esi
  801b4f:	e8 98 ee ff ff       	call   8009ec <strlen>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b5c:	7f 6c                	jg     801bca <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b5e:	83 ec 0c             	sub    $0xc,%esp
  801b61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b64:	50                   	push   %eax
  801b65:	e8 67 f8 ff ff       	call   8013d1 <fd_alloc>
  801b6a:	89 c3                	mov    %eax,%ebx
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 3c                	js     801baf <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	56                   	push   %esi
  801b77:	68 00 50 80 00       	push   $0x805000
  801b7c:	e8 ae ee ff ff       	call   800a2f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b91:	e8 db fd ff ff       	call   801971 <fsipc>
  801b96:	89 c3                	mov    %eax,%ebx
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 19                	js     801bb8 <open+0x79>
	return fd2num(fd);
  801b9f:	83 ec 0c             	sub    $0xc,%esp
  801ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba5:	e8 f8 f7 ff ff       	call   8013a2 <fd2num>
  801baa:	89 c3                	mov    %eax,%ebx
  801bac:	83 c4 10             	add    $0x10,%esp
}
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
		fd_close(fd, 0);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc0:	e8 10 f9 ff ff       	call   8014d5 <fd_close>
		return r;
  801bc5:	83 c4 10             	add    $0x10,%esp
  801bc8:	eb e5                	jmp    801baf <open+0x70>
		return -E_BAD_PATH;
  801bca:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bcf:	eb de                	jmp    801baf <open+0x70>

00801bd1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bd1:	f3 0f 1e fb          	endbr32 
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801be0:	b8 08 00 00 00       	mov    $0x8,%eax
  801be5:	e8 87 fd ff ff       	call   801971 <fsipc>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bec:	f3 0f 1e fb          	endbr32 
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	56                   	push   %esi
  801bf4:	53                   	push   %ebx
  801bf5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 b3 f7 ff ff       	call   8013b6 <fd2data>
  801c03:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c05:	83 c4 08             	add    $0x8,%esp
  801c08:	68 6b 2c 80 00       	push   $0x802c6b
  801c0d:	53                   	push   %ebx
  801c0e:	e8 1c ee ff ff       	call   800a2f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c13:	8b 46 04             	mov    0x4(%esi),%eax
  801c16:	2b 06                	sub    (%esi),%eax
  801c18:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c1e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c25:	00 00 00 
	stat->st_dev = &devpipe;
  801c28:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801c2f:	30 80 00 
	return 0;
}
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5e                   	pop    %esi
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    

00801c3e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c3e:	f3 0f 1e fb          	endbr32 
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	53                   	push   %ebx
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c4c:	53                   	push   %ebx
  801c4d:	6a 00                	push   $0x0
  801c4f:	e8 aa f2 ff ff       	call   800efe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c54:	89 1c 24             	mov    %ebx,(%esp)
  801c57:	e8 5a f7 ff ff       	call   8013b6 <fd2data>
  801c5c:	83 c4 08             	add    $0x8,%esp
  801c5f:	50                   	push   %eax
  801c60:	6a 00                	push   $0x0
  801c62:	e8 97 f2 ff ff       	call   800efe <sys_page_unmap>
}
  801c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <_pipeisclosed>:
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	57                   	push   %edi
  801c70:	56                   	push   %esi
  801c71:	53                   	push   %ebx
  801c72:	83 ec 1c             	sub    $0x1c,%esp
  801c75:	89 c7                	mov    %eax,%edi
  801c77:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c79:	a1 04 40 80 00       	mov    0x804004,%eax
  801c7e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	57                   	push   %edi
  801c85:	e8 54 06 00 00       	call   8022de <pageref>
  801c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c8d:	89 34 24             	mov    %esi,(%esp)
  801c90:	e8 49 06 00 00       	call   8022de <pageref>
		nn = thisenv->env_runs;
  801c95:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c9b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	39 cb                	cmp    %ecx,%ebx
  801ca3:	74 1b                	je     801cc0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ca5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ca8:	75 cf                	jne    801c79 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801caa:	8b 42 58             	mov    0x58(%edx),%eax
  801cad:	6a 01                	push   $0x1
  801caf:	50                   	push   %eax
  801cb0:	53                   	push   %ebx
  801cb1:	68 72 2c 80 00       	push   $0x802c72
  801cb6:	e8 6a e7 ff ff       	call   800425 <cprintf>
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	eb b9                	jmp    801c79 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cc0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cc3:	0f 94 c0             	sete   %al
  801cc6:	0f b6 c0             	movzbl %al,%eax
}
  801cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccc:	5b                   	pop    %ebx
  801ccd:	5e                   	pop    %esi
  801cce:	5f                   	pop    %edi
  801ccf:	5d                   	pop    %ebp
  801cd0:	c3                   	ret    

00801cd1 <devpipe_write>:
{
  801cd1:	f3 0f 1e fb          	endbr32 
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	57                   	push   %edi
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 28             	sub    $0x28,%esp
  801cde:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ce1:	56                   	push   %esi
  801ce2:	e8 cf f6 ff ff       	call   8013b6 <fd2data>
  801ce7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cf4:	74 4f                	je     801d45 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cf6:	8b 43 04             	mov    0x4(%ebx),%eax
  801cf9:	8b 0b                	mov    (%ebx),%ecx
  801cfb:	8d 51 20             	lea    0x20(%ecx),%edx
  801cfe:	39 d0                	cmp    %edx,%eax
  801d00:	72 14                	jb     801d16 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d02:	89 da                	mov    %ebx,%edx
  801d04:	89 f0                	mov    %esi,%eax
  801d06:	e8 61 ff ff ff       	call   801c6c <_pipeisclosed>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	75 3b                	jne    801d4a <devpipe_write+0x79>
			sys_yield();
  801d0f:	e8 3a f1 ff ff       	call   800e4e <sys_yield>
  801d14:	eb e0                	jmp    801cf6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d19:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d1d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d20:	89 c2                	mov    %eax,%edx
  801d22:	c1 fa 1f             	sar    $0x1f,%edx
  801d25:	89 d1                	mov    %edx,%ecx
  801d27:	c1 e9 1b             	shr    $0x1b,%ecx
  801d2a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d2d:	83 e2 1f             	and    $0x1f,%edx
  801d30:	29 ca                	sub    %ecx,%edx
  801d32:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d36:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d3a:	83 c0 01             	add    $0x1,%eax
  801d3d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d40:	83 c7 01             	add    $0x1,%edi
  801d43:	eb ac                	jmp    801cf1 <devpipe_write+0x20>
	return i;
  801d45:	8b 45 10             	mov    0x10(%ebp),%eax
  801d48:	eb 05                	jmp    801d4f <devpipe_write+0x7e>
				return 0;
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5f                   	pop    %edi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    

00801d57 <devpipe_read>:
{
  801d57:	f3 0f 1e fb          	endbr32 
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	57                   	push   %edi
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	83 ec 18             	sub    $0x18,%esp
  801d64:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d67:	57                   	push   %edi
  801d68:	e8 49 f6 ff ff       	call   8013b6 <fd2data>
  801d6d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d6f:	83 c4 10             	add    $0x10,%esp
  801d72:	be 00 00 00 00       	mov    $0x0,%esi
  801d77:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d7a:	75 14                	jne    801d90 <devpipe_read+0x39>
	return i;
  801d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7f:	eb 02                	jmp    801d83 <devpipe_read+0x2c>
				return i;
  801d81:	89 f0                	mov    %esi,%eax
}
  801d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5e                   	pop    %esi
  801d88:	5f                   	pop    %edi
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    
			sys_yield();
  801d8b:	e8 be f0 ff ff       	call   800e4e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d90:	8b 03                	mov    (%ebx),%eax
  801d92:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d95:	75 18                	jne    801daf <devpipe_read+0x58>
			if (i > 0)
  801d97:	85 f6                	test   %esi,%esi
  801d99:	75 e6                	jne    801d81 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d9b:	89 da                	mov    %ebx,%edx
  801d9d:	89 f8                	mov    %edi,%eax
  801d9f:	e8 c8 fe ff ff       	call   801c6c <_pipeisclosed>
  801da4:	85 c0                	test   %eax,%eax
  801da6:	74 e3                	je     801d8b <devpipe_read+0x34>
				return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dad:	eb d4                	jmp    801d83 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801daf:	99                   	cltd   
  801db0:	c1 ea 1b             	shr    $0x1b,%edx
  801db3:	01 d0                	add    %edx,%eax
  801db5:	83 e0 1f             	and    $0x1f,%eax
  801db8:	29 d0                	sub    %edx,%eax
  801dba:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dc5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dc8:	83 c6 01             	add    $0x1,%esi
  801dcb:	eb aa                	jmp    801d77 <devpipe_read+0x20>

00801dcd <pipe>:
{
  801dcd:	f3 0f 1e fb          	endbr32 
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	56                   	push   %esi
  801dd5:	53                   	push   %ebx
  801dd6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ddc:	50                   	push   %eax
  801ddd:	e8 ef f5 ff ff       	call   8013d1 <fd_alloc>
  801de2:	89 c3                	mov    %eax,%ebx
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	85 c0                	test   %eax,%eax
  801de9:	0f 88 23 01 00 00    	js     801f12 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	68 07 04 00 00       	push   $0x407
  801df7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfa:	6a 00                	push   $0x0
  801dfc:	e8 70 f0 ff ff       	call   800e71 <sys_page_alloc>
  801e01:	89 c3                	mov    %eax,%ebx
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	85 c0                	test   %eax,%eax
  801e08:	0f 88 04 01 00 00    	js     801f12 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e14:	50                   	push   %eax
  801e15:	e8 b7 f5 ff ff       	call   8013d1 <fd_alloc>
  801e1a:	89 c3                	mov    %eax,%ebx
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	0f 88 db 00 00 00    	js     801f02 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	68 07 04 00 00       	push   $0x407
  801e2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e32:	6a 00                	push   $0x0
  801e34:	e8 38 f0 ff ff       	call   800e71 <sys_page_alloc>
  801e39:	89 c3                	mov    %eax,%ebx
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	0f 88 bc 00 00 00    	js     801f02 <pipe+0x135>
	va = fd2data(fd0);
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4c:	e8 65 f5 ff ff       	call   8013b6 <fd2data>
  801e51:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e53:	83 c4 0c             	add    $0xc,%esp
  801e56:	68 07 04 00 00       	push   $0x407
  801e5b:	50                   	push   %eax
  801e5c:	6a 00                	push   $0x0
  801e5e:	e8 0e f0 ff ff       	call   800e71 <sys_page_alloc>
  801e63:	89 c3                	mov    %eax,%ebx
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	0f 88 82 00 00 00    	js     801ef2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	ff 75 f0             	pushl  -0x10(%ebp)
  801e76:	e8 3b f5 ff ff       	call   8013b6 <fd2data>
  801e7b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e82:	50                   	push   %eax
  801e83:	6a 00                	push   $0x0
  801e85:	56                   	push   %esi
  801e86:	6a 00                	push   $0x0
  801e88:	e8 2b f0 ff ff       	call   800eb8 <sys_page_map>
  801e8d:	89 c3                	mov    %eax,%ebx
  801e8f:	83 c4 20             	add    $0x20,%esp
  801e92:	85 c0                	test   %eax,%eax
  801e94:	78 4e                	js     801ee4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e96:	a1 24 30 80 00       	mov    0x803024,%eax
  801e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801eaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ead:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebf:	e8 de f4 ff ff       	call   8013a2 <fd2num>
  801ec4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ec7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ec9:	83 c4 04             	add    $0x4,%esp
  801ecc:	ff 75 f0             	pushl  -0x10(%ebp)
  801ecf:	e8 ce f4 ff ff       	call   8013a2 <fd2num>
  801ed4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ed7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ee2:	eb 2e                	jmp    801f12 <pipe+0x145>
	sys_page_unmap(0, va);
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	56                   	push   %esi
  801ee8:	6a 00                	push   $0x0
  801eea:	e8 0f f0 ff ff       	call   800efe <sys_page_unmap>
  801eef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ef2:	83 ec 08             	sub    $0x8,%esp
  801ef5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 ff ef ff ff       	call   800efe <sys_page_unmap>
  801eff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f02:	83 ec 08             	sub    $0x8,%esp
  801f05:	ff 75 f4             	pushl  -0xc(%ebp)
  801f08:	6a 00                	push   $0x0
  801f0a:	e8 ef ef ff ff       	call   800efe <sys_page_unmap>
  801f0f:	83 c4 10             	add    $0x10,%esp
}
  801f12:	89 d8                	mov    %ebx,%eax
  801f14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    

00801f1b <pipeisclosed>:
{
  801f1b:	f3 0f 1e fb          	endbr32 
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f28:	50                   	push   %eax
  801f29:	ff 75 08             	pushl  0x8(%ebp)
  801f2c:	e8 f6 f4 ff ff       	call   801427 <fd_lookup>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	78 18                	js     801f50 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3e:	e8 73 f4 ff ff       	call   8013b6 <fd2data>
  801f43:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	e8 1f fd ff ff       	call   801c6c <_pipeisclosed>
  801f4d:	83 c4 10             	add    $0x10,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f52:	f3 0f 1e fb          	endbr32 
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	56                   	push   %esi
  801f5a:	53                   	push   %ebx
  801f5b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f5e:	85 f6                	test   %esi,%esi
  801f60:	74 13                	je     801f75 <wait+0x23>
	e = &envs[ENVX(envid)];
  801f62:	89 f3                	mov    %esi,%ebx
  801f64:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f6a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801f6d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f73:	eb 1b                	jmp    801f90 <wait+0x3e>
	assert(envid != 0);
  801f75:	68 8a 2c 80 00       	push   $0x802c8a
  801f7a:	68 3f 2c 80 00       	push   $0x802c3f
  801f7f:	6a 09                	push   $0x9
  801f81:	68 95 2c 80 00       	push   $0x802c95
  801f86:	e8 b3 e3 ff ff       	call   80033e <_panic>
		sys_yield();
  801f8b:	e8 be ee ff ff       	call   800e4e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f90:	8b 43 48             	mov    0x48(%ebx),%eax
  801f93:	39 f0                	cmp    %esi,%eax
  801f95:	75 07                	jne    801f9e <wait+0x4c>
  801f97:	8b 43 54             	mov    0x54(%ebx),%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	75 ed                	jne    801f8b <wait+0x39>
}
  801f9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    

00801fa5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fa5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	c3                   	ret    

00801faf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801faf:	f3 0f 1e fb          	endbr32 
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fb9:	68 a0 2c 80 00       	push   $0x802ca0
  801fbe:	ff 75 0c             	pushl  0xc(%ebp)
  801fc1:	e8 69 ea ff ff       	call   800a2f <strcpy>
	return 0;
}
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <devcons_write>:
{
  801fcd:	f3 0f 1e fb          	endbr32 
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	57                   	push   %edi
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fdd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fe2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fe8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801feb:	73 31                	jae    80201e <devcons_write+0x51>
		m = n - tot;
  801fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ff0:	29 f3                	sub    %esi,%ebx
  801ff2:	83 fb 7f             	cmp    $0x7f,%ebx
  801ff5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ffa:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	53                   	push   %ebx
  802001:	89 f0                	mov    %esi,%eax
  802003:	03 45 0c             	add    0xc(%ebp),%eax
  802006:	50                   	push   %eax
  802007:	57                   	push   %edi
  802008:	e8 d8 eb ff ff       	call   800be5 <memmove>
		sys_cputs(buf, m);
  80200d:	83 c4 08             	add    $0x8,%esp
  802010:	53                   	push   %ebx
  802011:	57                   	push   %edi
  802012:	e8 8a ed ff ff       	call   800da1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802017:	01 de                	add    %ebx,%esi
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	eb ca                	jmp    801fe8 <devcons_write+0x1b>
}
  80201e:	89 f0                	mov    %esi,%eax
  802020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802023:	5b                   	pop    %ebx
  802024:	5e                   	pop    %esi
  802025:	5f                   	pop    %edi
  802026:	5d                   	pop    %ebp
  802027:	c3                   	ret    

00802028 <devcons_read>:
{
  802028:	f3 0f 1e fb          	endbr32 
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 08             	sub    $0x8,%esp
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80203b:	74 21                	je     80205e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80203d:	e8 81 ed ff ff       	call   800dc3 <sys_cgetc>
  802042:	85 c0                	test   %eax,%eax
  802044:	75 07                	jne    80204d <devcons_read+0x25>
		sys_yield();
  802046:	e8 03 ee ff ff       	call   800e4e <sys_yield>
  80204b:	eb f0                	jmp    80203d <devcons_read+0x15>
	if (c < 0)
  80204d:	78 0f                	js     80205e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80204f:	83 f8 04             	cmp    $0x4,%eax
  802052:	74 0c                	je     802060 <devcons_read+0x38>
	*(char*)vbuf = c;
  802054:	8b 55 0c             	mov    0xc(%ebp),%edx
  802057:	88 02                	mov    %al,(%edx)
	return 1;
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    
		return 0;
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
  802065:	eb f7                	jmp    80205e <devcons_read+0x36>

00802067 <cputchar>:
{
  802067:	f3 0f 1e fb          	endbr32 
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802077:	6a 01                	push   $0x1
  802079:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207c:	50                   	push   %eax
  80207d:	e8 1f ed ff ff       	call   800da1 <sys_cputs>
}
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <getchar>:
{
  802087:	f3 0f 1e fb          	endbr32 
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802091:	6a 01                	push   $0x1
  802093:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802096:	50                   	push   %eax
  802097:	6a 00                	push   $0x0
  802099:	e8 0c f6 ff ff       	call   8016aa <read>
	if (r < 0)
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	78 06                	js     8020ab <getchar+0x24>
	if (r < 1)
  8020a5:	74 06                	je     8020ad <getchar+0x26>
	return c;
  8020a7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    
		return -E_EOF;
  8020ad:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020b2:	eb f7                	jmp    8020ab <getchar+0x24>

008020b4 <iscons>:
{
  8020b4:	f3 0f 1e fb          	endbr32 
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c1:	50                   	push   %eax
  8020c2:	ff 75 08             	pushl  0x8(%ebp)
  8020c5:	e8 5d f3 ff ff       	call   801427 <fd_lookup>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 11                	js     8020e2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8020da:	39 10                	cmp    %edx,(%eax)
  8020dc:	0f 94 c0             	sete   %al
  8020df:	0f b6 c0             	movzbl %al,%eax
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <opencons>:
{
  8020e4:	f3 0f 1e fb          	endbr32 
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f1:	50                   	push   %eax
  8020f2:	e8 da f2 ff ff       	call   8013d1 <fd_alloc>
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 3a                	js     802138 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	68 07 04 00 00       	push   $0x407
  802106:	ff 75 f4             	pushl  -0xc(%ebp)
  802109:	6a 00                	push   $0x0
  80210b:	e8 61 ed ff ff       	call   800e71 <sys_page_alloc>
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	85 c0                	test   %eax,%eax
  802115:	78 21                	js     802138 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802120:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	50                   	push   %eax
  802130:	e8 6d f2 ff ff       	call   8013a2 <fd2num>
  802135:	83 c4 10             	add    $0x10,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80213a:	f3 0f 1e fb          	endbr32 
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	53                   	push   %ebx
  802142:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802145:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80214c:	74 0d                	je     80215b <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802156:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802159:	c9                   	leave  
  80215a:	c3                   	ret    
		envid_t envid=sys_getenvid();
  80215b:	e8 cb ec ff ff       	call   800e2b <sys_getenvid>
  802160:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  802162:	83 ec 04             	sub    $0x4,%esp
  802165:	6a 07                	push   $0x7
  802167:	68 00 f0 bf ee       	push   $0xeebff000
  80216c:	50                   	push   %eax
  80216d:	e8 ff ec ff ff       	call   800e71 <sys_page_alloc>
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	85 c0                	test   %eax,%eax
  802177:	78 29                	js     8021a2 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802179:	83 ec 08             	sub    $0x8,%esp
  80217c:	68 b6 21 80 00       	push   $0x8021b6
  802181:	53                   	push   %ebx
  802182:	e8 49 ee ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
  802187:	83 c4 10             	add    $0x10,%esp
  80218a:	85 c0                	test   %eax,%eax
  80218c:	79 c0                	jns    80214e <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	68 d8 2c 80 00       	push   $0x802cd8
  802196:	6a 24                	push   $0x24
  802198:	68 0f 2d 80 00       	push   $0x802d0f
  80219d:	e8 9c e1 ff ff       	call   80033e <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 ac 2c 80 00       	push   $0x802cac
  8021aa:	6a 22                	push   $0x22
  8021ac:	68 0f 2d 80 00       	push   $0x802d0f
  8021b1:	e8 88 e1 ff ff       	call   80033e <_panic>

008021b6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8021b6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8021b7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8021bc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8021be:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8021c1:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8021c4:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8021c8:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8021cd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8021d1:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8021d3:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8021d4:	83 c4 04             	add    $0x4,%esp
	popfl
  8021d7:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021d8:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8021d9:	c3                   	ret    

008021da <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021da:	f3 0f 1e fb          	endbr32 
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f3:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8021f6:	83 ec 0c             	sub    $0xc,%esp
  8021f9:	50                   	push   %eax
  8021fa:	e8 3e ee ff ff       	call   80103d <sys_ipc_recv>
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	85 c0                	test   %eax,%eax
  802204:	78 2b                	js     802231 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  802206:	85 f6                	test   %esi,%esi
  802208:	74 0a                	je     802214 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  80220a:	a1 04 40 80 00       	mov    0x804004,%eax
  80220f:	8b 40 74             	mov    0x74(%eax),%eax
  802212:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  802214:	85 db                	test   %ebx,%ebx
  802216:	74 0a                	je     802222 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  802218:	a1 04 40 80 00       	mov    0x804004,%eax
  80221d:	8b 40 78             	mov    0x78(%eax),%eax
  802220:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802222:	a1 04 40 80 00       	mov    0x804004,%eax
  802227:	8b 40 70             	mov    0x70(%eax),%eax
}
  80222a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    
		if(from_env_store)
  802231:	85 f6                	test   %esi,%esi
  802233:	74 06                	je     80223b <ipc_recv+0x61>
			*from_env_store=0;
  802235:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80223b:	85 db                	test   %ebx,%ebx
  80223d:	74 eb                	je     80222a <ipc_recv+0x50>
			*perm_store=0;
  80223f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802245:	eb e3                	jmp    80222a <ipc_recv+0x50>

00802247 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802247:	f3 0f 1e fb          	endbr32 
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	57                   	push   %edi
  80224f:	56                   	push   %esi
  802250:	53                   	push   %ebx
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	8b 7d 08             	mov    0x8(%ebp),%edi
  802257:	8b 75 0c             	mov    0xc(%ebp),%esi
  80225a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80225d:	85 db                	test   %ebx,%ebx
  80225f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802264:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802267:	ff 75 14             	pushl  0x14(%ebp)
  80226a:	53                   	push   %ebx
  80226b:	56                   	push   %esi
  80226c:	57                   	push   %edi
  80226d:	e8 a4 ed ff ff       	call   801016 <sys_ipc_try_send>
		if(!res)
  802272:	83 c4 10             	add    $0x10,%esp
  802275:	85 c0                	test   %eax,%eax
  802277:	74 20                	je     802299 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802279:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80227c:	75 07                	jne    802285 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80227e:	e8 cb eb ff ff       	call   800e4e <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802283:	eb e2                	jmp    802267 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	68 1d 2d 80 00       	push   $0x802d1d
  80228d:	6a 3f                	push   $0x3f
  80228f:	68 35 2d 80 00       	push   $0x802d35
  802294:	e8 a5 e0 ff ff       	call   80033e <_panic>
	}
}
  802299:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80229c:	5b                   	pop    %ebx
  80229d:	5e                   	pop    %esi
  80229e:	5f                   	pop    %edi
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    

008022a1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a1:	f3 0f 1e fb          	endbr32 
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022b3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022b9:	8b 52 50             	mov    0x50(%edx),%edx
  8022bc:	39 ca                	cmp    %ecx,%edx
  8022be:	74 11                	je     8022d1 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8022c0:	83 c0 01             	add    $0x1,%eax
  8022c3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022c8:	75 e6                	jne    8022b0 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	eb 0b                	jmp    8022dc <ipc_find_env+0x3b>
			return envs[i].env_id;
  8022d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022d9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022de:	f3 0f 1e fb          	endbr32 
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022e8:	89 c2                	mov    %eax,%edx
  8022ea:	c1 ea 16             	shr    $0x16,%edx
  8022ed:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022f4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022f9:	f6 c1 01             	test   $0x1,%cl
  8022fc:	74 1c                	je     80231a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022fe:	c1 e8 0c             	shr    $0xc,%eax
  802301:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802308:	a8 01                	test   $0x1,%al
  80230a:	74 0e                	je     80231a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80230c:	c1 e8 0c             	shr    $0xc,%eax
  80230f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802316:	ef 
  802317:	0f b7 d2             	movzwl %dx,%edx
}
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__udivdi3>:
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80232f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802333:	8b 74 24 34          	mov    0x34(%esp),%esi
  802337:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80233b:	85 d2                	test   %edx,%edx
  80233d:	75 19                	jne    802358 <__udivdi3+0x38>
  80233f:	39 f3                	cmp    %esi,%ebx
  802341:	76 4d                	jbe    802390 <__udivdi3+0x70>
  802343:	31 ff                	xor    %edi,%edi
  802345:	89 e8                	mov    %ebp,%eax
  802347:	89 f2                	mov    %esi,%edx
  802349:	f7 f3                	div    %ebx
  80234b:	89 fa                	mov    %edi,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	76 14                	jbe    802370 <__udivdi3+0x50>
  80235c:	31 ff                	xor    %edi,%edi
  80235e:	31 c0                	xor    %eax,%eax
  802360:	89 fa                	mov    %edi,%edx
  802362:	83 c4 1c             	add    $0x1c,%esp
  802365:	5b                   	pop    %ebx
  802366:	5e                   	pop    %esi
  802367:	5f                   	pop    %edi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
  80236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802370:	0f bd fa             	bsr    %edx,%edi
  802373:	83 f7 1f             	xor    $0x1f,%edi
  802376:	75 48                	jne    8023c0 <__udivdi3+0xa0>
  802378:	39 f2                	cmp    %esi,%edx
  80237a:	72 06                	jb     802382 <__udivdi3+0x62>
  80237c:	31 c0                	xor    %eax,%eax
  80237e:	39 eb                	cmp    %ebp,%ebx
  802380:	77 de                	ja     802360 <__udivdi3+0x40>
  802382:	b8 01 00 00 00       	mov    $0x1,%eax
  802387:	eb d7                	jmp    802360 <__udivdi3+0x40>
  802389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	85 db                	test   %ebx,%ebx
  802394:	75 0b                	jne    8023a1 <__udivdi3+0x81>
  802396:	b8 01 00 00 00       	mov    $0x1,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f3                	div    %ebx
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	31 d2                	xor    %edx,%edx
  8023a3:	89 f0                	mov    %esi,%eax
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 c6                	mov    %eax,%esi
  8023a9:	89 e8                	mov    %ebp,%eax
  8023ab:	89 f7                	mov    %esi,%edi
  8023ad:	f7 f1                	div    %ecx
  8023af:	89 fa                	mov    %edi,%edx
  8023b1:	83 c4 1c             	add    $0x1c,%esp
  8023b4:	5b                   	pop    %ebx
  8023b5:	5e                   	pop    %esi
  8023b6:	5f                   	pop    %edi
  8023b7:	5d                   	pop    %ebp
  8023b8:	c3                   	ret    
  8023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c7:	29 f8                	sub    %edi,%eax
  8023c9:	d3 e2                	shl    %cl,%edx
  8023cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 da                	mov    %ebx,%edx
  8023d3:	d3 ea                	shr    %cl,%edx
  8023d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d9:	09 d1                	or     %edx,%ecx
  8023db:	89 f2                	mov    %esi,%edx
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e3                	shl    %cl,%ebx
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	89 f9                	mov    %edi,%ecx
  8023eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ef:	89 eb                	mov    %ebp,%ebx
  8023f1:	d3 e6                	shl    %cl,%esi
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	d3 eb                	shr    %cl,%ebx
  8023f7:	09 de                	or     %ebx,%esi
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	f7 74 24 08          	divl   0x8(%esp)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	89 c3                	mov    %eax,%ebx
  802403:	f7 64 24 0c          	mull   0xc(%esp)
  802407:	39 d6                	cmp    %edx,%esi
  802409:	72 15                	jb     802420 <__udivdi3+0x100>
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e5                	shl    %cl,%ebp
  80240f:	39 c5                	cmp    %eax,%ebp
  802411:	73 04                	jae    802417 <__udivdi3+0xf7>
  802413:	39 d6                	cmp    %edx,%esi
  802415:	74 09                	je     802420 <__udivdi3+0x100>
  802417:	89 d8                	mov    %ebx,%eax
  802419:	31 ff                	xor    %edi,%edi
  80241b:	e9 40 ff ff ff       	jmp    802360 <__udivdi3+0x40>
  802420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802423:	31 ff                	xor    %edi,%edi
  802425:	e9 36 ff ff ff       	jmp    802360 <__udivdi3+0x40>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <__umoddi3>:
  802430:	f3 0f 1e fb          	endbr32 
  802434:	55                   	push   %ebp
  802435:	57                   	push   %edi
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	83 ec 1c             	sub    $0x1c,%esp
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802443:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802447:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80244b:	85 c0                	test   %eax,%eax
  80244d:	75 19                	jne    802468 <__umoddi3+0x38>
  80244f:	39 df                	cmp    %ebx,%edi
  802451:	76 5d                	jbe    8024b0 <__umoddi3+0x80>
  802453:	89 f0                	mov    %esi,%eax
  802455:	89 da                	mov    %ebx,%edx
  802457:	f7 f7                	div    %edi
  802459:	89 d0                	mov    %edx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	83 c4 1c             	add    $0x1c,%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	89 f2                	mov    %esi,%edx
  80246a:	39 d8                	cmp    %ebx,%eax
  80246c:	76 12                	jbe    802480 <__umoddi3+0x50>
  80246e:	89 f0                	mov    %esi,%eax
  802470:	89 da                	mov    %ebx,%edx
  802472:	83 c4 1c             	add    $0x1c,%esp
  802475:	5b                   	pop    %ebx
  802476:	5e                   	pop    %esi
  802477:	5f                   	pop    %edi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    
  80247a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802480:	0f bd e8             	bsr    %eax,%ebp
  802483:	83 f5 1f             	xor    $0x1f,%ebp
  802486:	75 50                	jne    8024d8 <__umoddi3+0xa8>
  802488:	39 d8                	cmp    %ebx,%eax
  80248a:	0f 82 e0 00 00 00    	jb     802570 <__umoddi3+0x140>
  802490:	89 d9                	mov    %ebx,%ecx
  802492:	39 f7                	cmp    %esi,%edi
  802494:	0f 86 d6 00 00 00    	jbe    802570 <__umoddi3+0x140>
  80249a:	89 d0                	mov    %edx,%eax
  80249c:	89 ca                	mov    %ecx,%edx
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	89 fd                	mov    %edi,%ebp
  8024b2:	85 ff                	test   %edi,%edi
  8024b4:	75 0b                	jne    8024c1 <__umoddi3+0x91>
  8024b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	f7 f7                	div    %edi
  8024bf:	89 c5                	mov    %eax,%ebp
  8024c1:	89 d8                	mov    %ebx,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f5                	div    %ebp
  8024c7:	89 f0                	mov    %esi,%eax
  8024c9:	f7 f5                	div    %ebp
  8024cb:	89 d0                	mov    %edx,%eax
  8024cd:	31 d2                	xor    %edx,%edx
  8024cf:	eb 8c                	jmp    80245d <__umoddi3+0x2d>
  8024d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	ba 20 00 00 00       	mov    $0x20,%edx
  8024df:	29 ea                	sub    %ebp,%edx
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	d3 e8                	shr    %cl,%eax
  8024ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f9:	09 c1                	or     %eax,%ecx
  8024fb:	89 d8                	mov    %ebx,%eax
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 e9                	mov    %ebp,%ecx
  802503:	d3 e7                	shl    %cl,%edi
  802505:	89 d1                	mov    %edx,%ecx
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 c7                	mov    %eax,%edi
  802513:	89 d1                	mov    %edx,%ecx
  802515:	89 f0                	mov    %esi,%eax
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 fa                	mov    %edi,%edx
  80251d:	d3 e6                	shl    %cl,%esi
  80251f:	09 d8                	or     %ebx,%eax
  802521:	f7 74 24 08          	divl   0x8(%esp)
  802525:	89 d1                	mov    %edx,%ecx
  802527:	89 f3                	mov    %esi,%ebx
  802529:	f7 64 24 0c          	mull   0xc(%esp)
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	89 d7                	mov    %edx,%edi
  802531:	39 d1                	cmp    %edx,%ecx
  802533:	72 06                	jb     80253b <__umoddi3+0x10b>
  802535:	75 10                	jne    802547 <__umoddi3+0x117>
  802537:	39 c3                	cmp    %eax,%ebx
  802539:	73 0c                	jae    802547 <__umoddi3+0x117>
  80253b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80253f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802543:	89 d7                	mov    %edx,%edi
  802545:	89 c6                	mov    %eax,%esi
  802547:	89 ca                	mov    %ecx,%edx
  802549:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254e:	29 f3                	sub    %esi,%ebx
  802550:	19 fa                	sbb    %edi,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	d3 e0                	shl    %cl,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 eb                	shr    %cl,%ebx
  80255a:	d3 ea                	shr    %cl,%edx
  80255c:	09 d8                	or     %ebx,%eax
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	29 fe                	sub    %edi,%esi
  802572:	19 c3                	sbb    %eax,%ebx
  802574:	89 f2                	mov    %esi,%edx
  802576:	89 d9                	mov    %ebx,%ecx
  802578:	e9 1d ff ff ff       	jmp    80249a <__umoddi3+0x6a>
