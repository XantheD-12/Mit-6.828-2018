
obj/user/testpiperace.debug：     文件格式 elf32-i386


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
  80002c:	e8 c1 01 00 00       	call   8001f2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003f:	68 60 24 80 00       	push   $0x802460
  800044:	e8 f8 02 00 00       	call   800341 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 d9 1d 00 00       	call   801e2d <pipe>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	78 59                	js     8000b4 <umain+0x81>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 21 10 00 00       	call   801081 <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	78 60                	js     8000c6 <umain+0x93>
		panic("fork: %e", r);
	if (r == 0) {
  800066:	74 70                	je     8000d8 <umain+0xa5>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	56                   	push   %esi
  80006c:	68 ba 24 80 00       	push   $0x8024ba
  800071:	e8 cb 02 00 00       	call   800341 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800076:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007c:	83 c4 08             	add    $0x8,%esp
  80007f:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800082:	c1 f8 02             	sar    $0x2,%eax
  800085:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  80008b:	50                   	push   %eax
  80008c:	68 c5 24 80 00       	push   $0x8024c5
  800091:	e8 ab 02 00 00       	call   800341 <cprintf>
	dup(p[0], 10);
  800096:	83 c4 08             	add    $0x8,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	ff 75 f0             	pushl  -0x10(%ebp)
  80009e:	e8 37 15 00 00       	call   8015da <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	e9 92 00 00 00       	jmp    800146 <umain+0x113>
		panic("pipe: %e", r);
  8000b4:	50                   	push   %eax
  8000b5:	68 79 24 80 00       	push   $0x802479
  8000ba:	6a 0d                	push   $0xd
  8000bc:	68 82 24 80 00       	push   $0x802482
  8000c1:	e8 94 01 00 00       	call   80025a <_panic>
		panic("fork: %e", r);
  8000c6:	50                   	push   %eax
  8000c7:	68 96 24 80 00       	push   $0x802496
  8000cc:	6a 10                	push   $0x10
  8000ce:	68 82 24 80 00       	push   $0x802482
  8000d3:	e8 82 01 00 00       	call   80025a <_panic>
		close(p[1]);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 f4             	pushl  -0xc(%ebp)
  8000de:	e8 9d 14 00 00       	call   801580 <close>
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000eb:	eb 1f                	jmp    80010c <umain+0xd9>
				cprintf("RACE: pipe appears closed\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 9f 24 80 00       	push   $0x80249f
  8000f5:	e8 47 02 00 00       	call   800341 <cprintf>
				exit();
  8000fa:	e8 3d 01 00 00       	call   80023c <exit>
  8000ff:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800102:	e8 63 0c 00 00       	call   800d6a <sys_yield>
		for (i=0; i<max; i++) {
  800107:	83 eb 01             	sub    $0x1,%ebx
  80010a:	74 14                	je     800120 <umain+0xed>
			if(pipeisclosed(p[0])){
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	e8 64 1e 00 00       	call   801f7b <pipeisclosed>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	85 c0                	test   %eax,%eax
  80011c:	74 e4                	je     800102 <umain+0xcf>
  80011e:	eb cd                	jmp    8000ed <umain+0xba>
		ipc_recv(0,0,0);
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	e8 90 11 00 00       	call   8012be <ipc_recv>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	e9 32 ff ff ff       	jmp    800068 <umain+0x35>
		dup(p[0], 10);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	6a 0a                	push   $0xa
  80013b:	ff 75 f0             	pushl  -0x10(%ebp)
  80013e:	e8 97 14 00 00       	call   8015da <dup>
  800143:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800146:	8b 43 54             	mov    0x54(%ebx),%eax
  800149:	83 f8 02             	cmp    $0x2,%eax
  80014c:	74 e8                	je     800136 <umain+0x103>

	cprintf("child done with loop\n");
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	68 d0 24 80 00       	push   $0x8024d0
  800156:	e8 e6 01 00 00       	call   800341 <cprintf>
	if (pipeisclosed(p[0]))
  80015b:	83 c4 04             	add    $0x4,%esp
  80015e:	ff 75 f0             	pushl  -0x10(%ebp)
  800161:	e8 15 1e 00 00       	call   801f7b <pipeisclosed>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	75 48                	jne    8001b5 <umain+0x182>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	ff 75 f0             	pushl  -0x10(%ebp)
  800177:	e8 cb 12 00 00       	call   801447 <fd_lookup>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	85 c0                	test   %eax,%eax
  800181:	78 46                	js     8001c9 <umain+0x196>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	e8 48 12 00 00       	call   8013d6 <fd2data>
	if (pageref(va) != 3+1)
  80018e:	89 04 24             	mov    %eax,(%esp)
  800191:	e8 76 1a 00 00       	call   801c0c <pageref>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	83 f8 04             	cmp    $0x4,%eax
  80019c:	74 3d                	je     8001db <umain+0x1a8>
		cprintf("\nchild detected race\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 fe 24 80 00       	push   $0x8024fe
  8001a6:	e8 96 01 00 00       	call   800341 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 2c 25 80 00       	push   $0x80252c
  8001bd:	6a 3a                	push   $0x3a
  8001bf:	68 82 24 80 00       	push   $0x802482
  8001c4:	e8 91 00 00 00       	call   80025a <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c9:	50                   	push   %eax
  8001ca:	68 e6 24 80 00       	push   $0x8024e6
  8001cf:	6a 3c                	push   $0x3c
  8001d1:	68 82 24 80 00       	push   $0x802482
  8001d6:	e8 7f 00 00 00       	call   80025a <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	68 c8 00 00 00       	push   $0xc8
  8001e3:	68 14 25 80 00       	push   $0x802514
  8001e8:	e8 54 01 00 00       	call   800341 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	eb bc                	jmp    8001ae <umain+0x17b>

008001f2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800201:	e8 41 0b 00 00       	call   800d47 <sys_getenvid>
  800206:	25 ff 03 00 00       	and    $0x3ff,%eax
  80020b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800213:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800218:	85 db                	test   %ebx,%ebx
  80021a:	7e 07                	jle    800223 <libmain+0x31>
		binaryname = argv[0];
  80021c:	8b 06                	mov    (%esi),%eax
  80021e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	e8 06 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80022d:	e8 0a 00 00 00       	call   80023c <exit>
}
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800246:	e8 66 13 00 00       	call   8015b1 <close_all>
	sys_env_destroy(0);
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	6a 00                	push   $0x0
  800250:	e8 ad 0a 00 00       	call   800d02 <sys_env_destroy>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800263:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800266:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80026c:	e8 d6 0a 00 00       	call   800d47 <sys_getenvid>
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	56                   	push   %esi
  80027b:	50                   	push   %eax
  80027c:	68 60 25 80 00       	push   $0x802560
  800281:	e8 bb 00 00 00       	call   800341 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	53                   	push   %ebx
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	e8 5a 00 00 00       	call   8002ec <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 77 24 80 00 	movl   $0x802477,(%esp)
  800299:	e8 a3 00 00 00       	call   800341 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a1:	cc                   	int3   
  8002a2:	eb fd                	jmp    8002a1 <_panic+0x47>

008002a4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a4:	f3 0f 1e fb          	endbr32 
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b2:	8b 13                	mov    (%ebx),%edx
  8002b4:	8d 42 01             	lea    0x1(%edx),%eax
  8002b7:	89 03                	mov    %eax,(%ebx)
  8002b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c5:	74 09                	je     8002d0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	68 ff 00 00 00       	push   $0xff
  8002d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002db:	50                   	push   %eax
  8002dc:	e8 dc 09 00 00       	call   800cbd <sys_cputs>
		b->idx = 0;
  8002e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	eb db                	jmp    8002c7 <putch+0x23>

008002ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ec:	f3 0f 1e fb          	endbr32 
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800300:	00 00 00 
	b.cnt = 0;
  800303:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800319:	50                   	push   %eax
  80031a:	68 a4 02 80 00       	push   $0x8002a4
  80031f:	e8 20 01 00 00       	call   800444 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800324:	83 c4 08             	add    $0x8,%esp
  800327:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80032d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800333:	50                   	push   %eax
  800334:	e8 84 09 00 00       	call   800cbd <sys_cputs>

	return b.cnt;
}
  800339:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800341:	f3 0f 1e fb          	endbr32 
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034e:	50                   	push   %eax
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 95 ff ff ff       	call   8002ec <vcprintf>
	va_end(ap);

	return cnt;
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 1c             	sub    $0x1c,%esp
  800362:	89 c7                	mov    %eax,%edi
  800364:	89 d6                	mov    %edx,%esi
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036c:	89 d1                	mov    %edx,%ecx
  80036e:	89 c2                	mov    %eax,%edx
  800370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800373:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800376:	8b 45 10             	mov    0x10(%ebp),%eax
  800379:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800386:	39 c2                	cmp    %eax,%edx
  800388:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80038b:	72 3e                	jb     8003cb <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	ff 75 18             	pushl  0x18(%ebp)
  800393:	83 eb 01             	sub    $0x1,%ebx
  800396:	53                   	push   %ebx
  800397:	50                   	push   %eax
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039e:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a7:	e8 44 1e 00 00       	call   8021f0 <__udivdi3>
  8003ac:	83 c4 18             	add    $0x18,%esp
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	89 f2                	mov    %esi,%edx
  8003b3:	89 f8                	mov    %edi,%eax
  8003b5:	e8 9f ff ff ff       	call   800359 <printnum>
  8003ba:	83 c4 20             	add    $0x20,%esp
  8003bd:	eb 13                	jmp    8003d2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	56                   	push   %esi
  8003c3:	ff 75 18             	pushl  0x18(%ebp)
  8003c6:	ff d7                	call   *%edi
  8003c8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003cb:	83 eb 01             	sub    $0x1,%ebx
  8003ce:	85 db                	test   %ebx,%ebx
  8003d0:	7f ed                	jg     8003bf <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	56                   	push   %esi
  8003d6:	83 ec 04             	sub    $0x4,%esp
  8003d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003df:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e5:	e8 16 1f 00 00       	call   802300 <__umoddi3>
  8003ea:	83 c4 14             	add    $0x14,%esp
  8003ed:	0f be 80 83 25 80 00 	movsbl 0x802583(%eax),%eax
  8003f4:	50                   	push   %eax
  8003f5:	ff d7                	call   *%edi
}
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fd:	5b                   	pop    %ebx
  8003fe:	5e                   	pop    %esi
  8003ff:	5f                   	pop    %edi
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800402:	f3 0f 1e fb          	endbr32 
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800410:	8b 10                	mov    (%eax),%edx
  800412:	3b 50 04             	cmp    0x4(%eax),%edx
  800415:	73 0a                	jae    800421 <sprintputch+0x1f>
		*b->buf++ = ch;
  800417:	8d 4a 01             	lea    0x1(%edx),%ecx
  80041a:	89 08                	mov    %ecx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	88 02                	mov    %al,(%edx)
}
  800421:	5d                   	pop    %ebp
  800422:	c3                   	ret    

00800423 <printfmt>:
{
  800423:	f3 0f 1e fb          	endbr32 
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80042d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800430:	50                   	push   %eax
  800431:	ff 75 10             	pushl  0x10(%ebp)
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 05 00 00 00       	call   800444 <vprintfmt>
}
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <vprintfmt>:
{
  800444:	f3 0f 1e fb          	endbr32 
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	53                   	push   %ebx
  80044e:	83 ec 3c             	sub    $0x3c,%esp
  800451:	8b 75 08             	mov    0x8(%ebp),%esi
  800454:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800457:	8b 7d 10             	mov    0x10(%ebp),%edi
  80045a:	e9 8e 03 00 00       	jmp    8007ed <vprintfmt+0x3a9>
		padc = ' ';
  80045f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800463:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80046a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800471:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800478:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8d 47 01             	lea    0x1(%edi),%eax
  800480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800483:	0f b6 17             	movzbl (%edi),%edx
  800486:	8d 42 dd             	lea    -0x23(%edx),%eax
  800489:	3c 55                	cmp    $0x55,%al
  80048b:	0f 87 df 03 00 00    	ja     800870 <vprintfmt+0x42c>
  800491:	0f b6 c0             	movzbl %al,%eax
  800494:	3e ff 24 85 c0 26 80 	notrack jmp *0x8026c0(,%eax,4)
  80049b:	00 
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004a3:	eb d8                	jmp    80047d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004ac:	eb cf                	jmp    80047d <vprintfmt+0x39>
  8004ae:	0f b6 d2             	movzbl %dl,%edx
  8004b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c9:	83 f9 09             	cmp    $0x9,%ecx
  8004cc:	77 55                	ja     800523 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004ce:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004d1:	eb e9                	jmp    8004bc <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 04             	lea    0x4(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004eb:	79 90                	jns    80047d <vprintfmt+0x39>
				width = precision, precision = -1;
  8004ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fa:	eb 81                	jmp    80047d <vprintfmt+0x39>
  8004fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ff:	85 c0                	test   %eax,%eax
  800501:	ba 00 00 00 00       	mov    $0x0,%edx
  800506:	0f 49 d0             	cmovns %eax,%edx
  800509:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050f:	e9 69 ff ff ff       	jmp    80047d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800517:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80051e:	e9 5a ff ff ff       	jmp    80047d <vprintfmt+0x39>
  800523:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	eb bc                	jmp    8004e7 <vprintfmt+0xa3>
			lflag++;
  80052b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800531:	e9 47 ff ff ff       	jmp    80047d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 78 04             	lea    0x4(%eax),%edi
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 30                	pushl  (%eax)
  800542:	ff d6                	call   *%esi
			break;
  800544:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800547:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80054a:	e9 9b 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 78 04             	lea    0x4(%eax),%edi
  800555:	8b 00                	mov    (%eax),%eax
  800557:	99                   	cltd   
  800558:	31 d0                	xor    %edx,%eax
  80055a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055c:	83 f8 0f             	cmp    $0xf,%eax
  80055f:	7f 23                	jg     800584 <vprintfmt+0x140>
  800561:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  800568:	85 d2                	test   %edx,%edx
  80056a:	74 18                	je     800584 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80056c:	52                   	push   %edx
  80056d:	68 f1 2a 80 00       	push   $0x802af1
  800572:	53                   	push   %ebx
  800573:	56                   	push   %esi
  800574:	e8 aa fe ff ff       	call   800423 <printfmt>
  800579:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057f:	e9 66 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800584:	50                   	push   %eax
  800585:	68 9b 25 80 00       	push   $0x80259b
  80058a:	53                   	push   %ebx
  80058b:	56                   	push   %esi
  80058c:	e8 92 fe ff ff       	call   800423 <printfmt>
  800591:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800594:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800597:	e9 4e 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 c0 04             	add    $0x4,%eax
  8005a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	b8 94 25 80 00       	mov    $0x802594,%eax
  8005b1:	0f 45 c2             	cmovne %edx,%eax
  8005b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bb:	7e 06                	jle    8005c3 <vprintfmt+0x17f>
  8005bd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005c1:	75 0d                	jne    8005d0 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c6:	89 c7                	mov    %eax,%edi
  8005c8:	03 45 e0             	add    -0x20(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	eb 55                	jmp    800625 <vprintfmt+0x1e1>
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d6:	ff 75 cc             	pushl  -0x34(%ebp)
  8005d9:	e8 46 03 00 00       	call   800924 <strnlen>
  8005de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e1:	29 c2                	sub    %eax,%edx
  8005e3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005eb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f2:	85 ff                	test   %edi,%edi
  8005f4:	7e 11                	jle    800607 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	53                   	push   %ebx
  8005fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005fd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ff:	83 ef 01             	sub    $0x1,%edi
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	eb eb                	jmp    8005f2 <vprintfmt+0x1ae>
  800607:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80060a:	85 d2                	test   %edx,%edx
  80060c:	b8 00 00 00 00       	mov    $0x0,%eax
  800611:	0f 49 c2             	cmovns %edx,%eax
  800614:	29 c2                	sub    %eax,%edx
  800616:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800619:	eb a8                	jmp    8005c3 <vprintfmt+0x17f>
					putch(ch, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	52                   	push   %edx
  800620:	ff d6                	call   *%esi
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800628:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062a:	83 c7 01             	add    $0x1,%edi
  80062d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800631:	0f be d0             	movsbl %al,%edx
  800634:	85 d2                	test   %edx,%edx
  800636:	74 4b                	je     800683 <vprintfmt+0x23f>
  800638:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80063c:	78 06                	js     800644 <vprintfmt+0x200>
  80063e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800642:	78 1e                	js     800662 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800644:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800648:	74 d1                	je     80061b <vprintfmt+0x1d7>
  80064a:	0f be c0             	movsbl %al,%eax
  80064d:	83 e8 20             	sub    $0x20,%eax
  800650:	83 f8 5e             	cmp    $0x5e,%eax
  800653:	76 c6                	jbe    80061b <vprintfmt+0x1d7>
					putch('?', putdat);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	53                   	push   %ebx
  800659:	6a 3f                	push   $0x3f
  80065b:	ff d6                	call   *%esi
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	eb c3                	jmp    800625 <vprintfmt+0x1e1>
  800662:	89 cf                	mov    %ecx,%edi
  800664:	eb 0e                	jmp    800674 <vprintfmt+0x230>
				putch(' ', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 20                	push   $0x20
  80066c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066e:	83 ef 01             	sub    $0x1,%edi
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	85 ff                	test   %edi,%edi
  800676:	7f ee                	jg     800666 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800678:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
  80067e:	e9 67 01 00 00       	jmp    8007ea <vprintfmt+0x3a6>
  800683:	89 cf                	mov    %ecx,%edi
  800685:	eb ed                	jmp    800674 <vprintfmt+0x230>
	if (lflag >= 2)
  800687:	83 f9 01             	cmp    $0x1,%ecx
  80068a:	7f 1b                	jg     8006a7 <vprintfmt+0x263>
	else if (lflag)
  80068c:	85 c9                	test   %ecx,%ecx
  80068e:	74 63                	je     8006f3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	99                   	cltd   
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	eb 17                	jmp    8006be <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 50 04             	mov    0x4(%eax),%edx
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	0f 89 ff 00 00 00    	jns    8007d0 <vprintfmt+0x38c>
				putch('-', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 2d                	push   $0x2d
  8006d7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006df:	f7 da                	neg    %edx
  8006e1:	83 d1 00             	adc    $0x0,%ecx
  8006e4:	f7 d9                	neg    %ecx
  8006e6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ee:	e9 dd 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	99                   	cltd   
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
  800708:	eb b4                	jmp    8006be <vprintfmt+0x27a>
	if (lflag >= 2)
  80070a:	83 f9 01             	cmp    $0x1,%ecx
  80070d:	7f 1e                	jg     80072d <vprintfmt+0x2e9>
	else if (lflag)
  80070f:	85 c9                	test   %ecx,%ecx
  800711:	74 32                	je     800745 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 10                	mov    (%eax),%edx
  800718:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800723:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800728:	e9 a3 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	8b 48 04             	mov    0x4(%eax),%ecx
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800740:	e9 8b 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 10                	mov    (%eax),%edx
  80074a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800755:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80075a:	eb 74                	jmp    8007d0 <vprintfmt+0x38c>
	if (lflag >= 2)
  80075c:	83 f9 01             	cmp    $0x1,%ecx
  80075f:	7f 1b                	jg     80077c <vprintfmt+0x338>
	else if (lflag)
  800761:	85 c9                	test   %ecx,%ecx
  800763:	74 2c                	je     800791 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800775:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80077a:	eb 54                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 10                	mov    (%eax),%edx
  800781:	8b 48 04             	mov    0x4(%eax),%ecx
  800784:	8d 40 08             	lea    0x8(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80078a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80078f:	eb 3f                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 10                	mov    (%eax),%edx
  800796:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8007a1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8007a6:	eb 28                	jmp    8007d0 <vprintfmt+0x38c>
			putch('0', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 30                	push   $0x30
  8007ae:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b0:	83 c4 08             	add    $0x8,%esp
  8007b3:	53                   	push   %ebx
  8007b4:	6a 78                	push   $0x78
  8007b6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 10                	mov    (%eax),%edx
  8007bd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007c2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c5:	8d 40 04             	lea    0x4(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007d7:	57                   	push   %edi
  8007d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	51                   	push   %ecx
  8007dd:	52                   	push   %edx
  8007de:	89 da                	mov    %ebx,%edx
  8007e0:	89 f0                	mov    %esi,%eax
  8007e2:	e8 72 fb ff ff       	call   800359 <printnum>
			break;
  8007e7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ed:	83 c7 01             	add    $0x1,%edi
  8007f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f4:	83 f8 25             	cmp    $0x25,%eax
  8007f7:	0f 84 62 fc ff ff    	je     80045f <vprintfmt+0x1b>
			if (ch == '\0')
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	0f 84 8b 00 00 00    	je     800890 <vprintfmt+0x44c>
			putch(ch, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	50                   	push   %eax
  80080a:	ff d6                	call   *%esi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	eb dc                	jmp    8007ed <vprintfmt+0x3a9>
	if (lflag >= 2)
  800811:	83 f9 01             	cmp    $0x1,%ecx
  800814:	7f 1b                	jg     800831 <vprintfmt+0x3ed>
	else if (lflag)
  800816:	85 c9                	test   %ecx,%ecx
  800818:	74 2c                	je     800846 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 10                	mov    (%eax),%edx
  80081f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80082f:	eb 9f                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 10                	mov    (%eax),%edx
  800836:	8b 48 04             	mov    0x4(%eax),%ecx
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800844:	eb 8a                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80085b:	e9 70 ff ff ff       	jmp    8007d0 <vprintfmt+0x38c>
			putch(ch, putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	53                   	push   %ebx
  800864:	6a 25                	push   $0x25
  800866:	ff d6                	call   *%esi
			break;
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	e9 7a ff ff ff       	jmp    8007ea <vprintfmt+0x3a6>
			putch('%', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	53                   	push   %ebx
  800874:	6a 25                	push   $0x25
  800876:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800881:	74 05                	je     800888 <vprintfmt+0x444>
  800883:	83 e8 01             	sub    $0x1,%eax
  800886:	eb f5                	jmp    80087d <vprintfmt+0x439>
  800888:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088b:	e9 5a ff ff ff       	jmp    8007ea <vprintfmt+0x3a6>
}
  800890:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5f                   	pop    %edi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800898:	f3 0f 1e fb          	endbr32 
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ab:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008af:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	74 26                	je     8008e3 <vsnprintf+0x4b>
  8008bd:	85 d2                	test   %edx,%edx
  8008bf:	7e 22                	jle    8008e3 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c1:	ff 75 14             	pushl  0x14(%ebp)
  8008c4:	ff 75 10             	pushl  0x10(%ebp)
  8008c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ca:	50                   	push   %eax
  8008cb:	68 02 04 80 00       	push   $0x800402
  8008d0:	e8 6f fb ff ff       	call   800444 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008de:	83 c4 10             	add    $0x10,%esp
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    
		return -E_INVAL;
  8008e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e8:	eb f7                	jmp    8008e1 <vsnprintf+0x49>

008008ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 10             	pushl  0x10(%ebp)
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	ff 75 08             	pushl  0x8(%ebp)
  800901:	e8 92 ff ff ff       	call   800898 <vsnprintf>
	va_end(ap);

	return rc;
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800908:	f3 0f 1e fb          	endbr32 
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80091b:	74 05                	je     800922 <strlen+0x1a>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
  800920:	eb f5                	jmp    800917 <strlen+0xf>
	return n;
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800924:	f3 0f 1e fb          	endbr32 
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
  800936:	39 d0                	cmp    %edx,%eax
  800938:	74 0d                	je     800947 <strnlen+0x23>
  80093a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80093e:	74 05                	je     800945 <strnlen+0x21>
		n++;
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	eb f1                	jmp    800936 <strnlen+0x12>
  800945:	89 c2                	mov    %eax,%edx
	return n;
}
  800947:	89 d0                	mov    %edx,%eax
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	f3 0f 1e fb          	endbr32 
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800956:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800962:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800965:	83 c0 01             	add    $0x1,%eax
  800968:	84 d2                	test   %dl,%dl
  80096a:	75 f2                	jne    80095e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80096c:	89 c8                	mov    %ecx,%eax
  80096e:	5b                   	pop    %ebx
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800971:	f3 0f 1e fb          	endbr32 
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	53                   	push   %ebx
  800979:	83 ec 10             	sub    $0x10,%esp
  80097c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097f:	53                   	push   %ebx
  800980:	e8 83 ff ff ff       	call   800908 <strlen>
  800985:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	01 d8                	add    %ebx,%eax
  80098d:	50                   	push   %eax
  80098e:	e8 b8 ff ff ff       	call   80094b <strcpy>
	return dst;
}
  800993:	89 d8                	mov    %ebx,%eax
  800995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099a:	f3 0f 1e fb          	endbr32 
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	56                   	push   %esi
  8009a2:	53                   	push   %ebx
  8009a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	89 f3                	mov    %esi,%ebx
  8009ab:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	39 d8                	cmp    %ebx,%eax
  8009b2:	74 11                	je     8009c5 <strncpy+0x2b>
		*dst++ = *src;
  8009b4:	83 c0 01             	add    $0x1,%eax
  8009b7:	0f b6 0a             	movzbl (%edx),%ecx
  8009ba:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bd:	80 f9 01             	cmp    $0x1,%cl
  8009c0:	83 da ff             	sbb    $0xffffffff,%edx
  8009c3:	eb eb                	jmp    8009b0 <strncpy+0x16>
	}
	return ret;
}
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009da:	8b 55 10             	mov    0x10(%ebp),%edx
  8009dd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009df:	85 d2                	test   %edx,%edx
  8009e1:	74 21                	je     800a04 <strlcpy+0x39>
  8009e3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 14                	je     800a01 <strlcpy+0x36>
  8009ed:	0f b6 19             	movzbl (%ecx),%ebx
  8009f0:	84 db                	test   %bl,%bl
  8009f2:	74 0b                	je     8009ff <strlcpy+0x34>
			*dst++ = *src++;
  8009f4:	83 c1 01             	add    $0x1,%ecx
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009fd:	eb ea                	jmp    8009e9 <strlcpy+0x1e>
  8009ff:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a04:	29 f0                	sub    %esi,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a17:	0f b6 01             	movzbl (%ecx),%eax
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0c                	je     800a2a <strcmp+0x20>
  800a1e:	3a 02                	cmp    (%edx),%al
  800a20:	75 08                	jne    800a2a <strcmp+0x20>
		p++, q++;
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb ed                	jmp    800a17 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	53                   	push   %ebx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	89 c3                	mov    %eax,%ebx
  800a44:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a47:	eb 06                	jmp    800a4f <strncmp+0x1b>
		n--, p++, q++;
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4f:	39 d8                	cmp    %ebx,%eax
  800a51:	74 16                	je     800a69 <strncmp+0x35>
  800a53:	0f b6 08             	movzbl (%eax),%ecx
  800a56:	84 c9                	test   %cl,%cl
  800a58:	74 04                	je     800a5e <strncmp+0x2a>
  800a5a:	3a 0a                	cmp    (%edx),%cl
  800a5c:	74 eb                	je     800a49 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5e:	0f b6 00             	movzbl (%eax),%eax
  800a61:	0f b6 12             	movzbl (%edx),%edx
  800a64:	29 d0                	sub    %edx,%eax
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    
		return 0;
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6e:	eb f6                	jmp    800a66 <strncmp+0x32>

00800a70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a70:	f3 0f 1e fb          	endbr32 
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	74 09                	je     800a8e <strchr+0x1e>
		if (*s == c)
  800a85:	38 ca                	cmp    %cl,%dl
  800a87:	74 0a                	je     800a93 <strchr+0x23>
	for (; *s; s++)
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	eb f0                	jmp    800a7e <strchr+0xe>
			return (char *) s;
	return 0;
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a95:	f3 0f 1e fb          	endbr32 
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa6:	38 ca                	cmp    %cl,%dl
  800aa8:	74 09                	je     800ab3 <strfind+0x1e>
  800aaa:	84 d2                	test   %dl,%dl
  800aac:	74 05                	je     800ab3 <strfind+0x1e>
	for (; *s; s++)
  800aae:	83 c0 01             	add    $0x1,%eax
  800ab1:	eb f0                	jmp    800aa3 <strfind+0xe>
			break;
	return (char *) s;
}
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab5:	f3 0f 1e fb          	endbr32 
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 31                	je     800afa <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	89 f8                	mov    %edi,%eax
  800acb:	09 c8                	or     %ecx,%eax
  800acd:	a8 03                	test   $0x3,%al
  800acf:	75 23                	jne    800af4 <memset+0x3f>
		c &= 0xFF;
  800ad1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad5:	89 d3                	mov    %edx,%ebx
  800ad7:	c1 e3 08             	shl    $0x8,%ebx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	c1 e0 18             	shl    $0x18,%eax
  800adf:	89 d6                	mov    %edx,%esi
  800ae1:	c1 e6 10             	shl    $0x10,%esi
  800ae4:	09 f0                	or     %esi,%eax
  800ae6:	09 c2                	or     %eax,%edx
  800ae8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aea:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	fc                   	cld    
  800af0:	f3 ab                	rep stos %eax,%es:(%edi)
  800af2:	eb 06                	jmp    800afa <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	fc                   	cld    
  800af8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800afa:	89 f8                	mov    %edi,%eax
  800afc:	5b                   	pop    %ebx
  800afd:	5e                   	pop    %esi
  800afe:	5f                   	pop    %edi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b13:	39 c6                	cmp    %eax,%esi
  800b15:	73 32                	jae    800b49 <memmove+0x48>
  800b17:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	76 2b                	jbe    800b49 <memmove+0x48>
		s += n;
		d += n;
  800b1e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	89 fe                	mov    %edi,%esi
  800b23:	09 ce                	or     %ecx,%esi
  800b25:	09 d6                	or     %edx,%esi
  800b27:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2d:	75 0e                	jne    800b3d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b2f:	83 ef 04             	sub    $0x4,%edi
  800b32:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b38:	fd                   	std    
  800b39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3b:	eb 09                	jmp    800b46 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3d:	83 ef 01             	sub    $0x1,%edi
  800b40:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b43:	fd                   	std    
  800b44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b46:	fc                   	cld    
  800b47:	eb 1a                	jmp    800b63 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	09 ca                	or     %ecx,%edx
  800b4d:	09 f2                	or     %esi,%edx
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 0a                	jne    800b5e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b57:	89 c7                	mov    %eax,%edi
  800b59:	fc                   	cld    
  800b5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5c:	eb 05                	jmp    800b63 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b67:	f3 0f 1e fb          	endbr32 
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 82 ff ff ff       	call   800b01 <memmove>
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b81:	f3 0f 1e fb          	endbr32 
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b90:	89 c6                	mov    %eax,%esi
  800b92:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b95:	39 f0                	cmp    %esi,%eax
  800b97:	74 1c                	je     800bb5 <memcmp+0x34>
		if (*s1 != *s2)
  800b99:	0f b6 08             	movzbl (%eax),%ecx
  800b9c:	0f b6 1a             	movzbl (%edx),%ebx
  800b9f:	38 d9                	cmp    %bl,%cl
  800ba1:	75 08                	jne    800bab <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ba3:	83 c0 01             	add    $0x1,%eax
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	eb ea                	jmp    800b95 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bab:	0f b6 c1             	movzbl %cl,%eax
  800bae:	0f b6 db             	movzbl %bl,%ebx
  800bb1:	29 d8                	sub    %ebx,%eax
  800bb3:	eb 05                	jmp    800bba <memcmp+0x39>
	}

	return 0;
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bbe:	f3 0f 1e fb          	endbr32 
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bcb:	89 c2                	mov    %eax,%edx
  800bcd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd0:	39 d0                	cmp    %edx,%eax
  800bd2:	73 09                	jae    800bdd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd4:	38 08                	cmp    %cl,(%eax)
  800bd6:	74 05                	je     800bdd <memfind+0x1f>
	for (; s < ends; s++)
  800bd8:	83 c0 01             	add    $0x1,%eax
  800bdb:	eb f3                	jmp    800bd0 <memfind+0x12>
			break;
	return (void *) s;
}
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bdf:	f3 0f 1e fb          	endbr32 
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bef:	eb 03                	jmp    800bf4 <strtol+0x15>
		s++;
  800bf1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf4:	0f b6 01             	movzbl (%ecx),%eax
  800bf7:	3c 20                	cmp    $0x20,%al
  800bf9:	74 f6                	je     800bf1 <strtol+0x12>
  800bfb:	3c 09                	cmp    $0x9,%al
  800bfd:	74 f2                	je     800bf1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bff:	3c 2b                	cmp    $0x2b,%al
  800c01:	74 2a                	je     800c2d <strtol+0x4e>
	int neg = 0;
  800c03:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c08:	3c 2d                	cmp    $0x2d,%al
  800c0a:	74 2b                	je     800c37 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c12:	75 0f                	jne    800c23 <strtol+0x44>
  800c14:	80 39 30             	cmpb   $0x30,(%ecx)
  800c17:	74 28                	je     800c41 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c19:	85 db                	test   %ebx,%ebx
  800c1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c20:	0f 44 d8             	cmove  %eax,%ebx
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c2b:	eb 46                	jmp    800c73 <strtol+0x94>
		s++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c30:	bf 00 00 00 00       	mov    $0x0,%edi
  800c35:	eb d5                	jmp    800c0c <strtol+0x2d>
		s++, neg = 1;
  800c37:	83 c1 01             	add    $0x1,%ecx
  800c3a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3f:	eb cb                	jmp    800c0c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c41:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c45:	74 0e                	je     800c55 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c47:	85 db                	test   %ebx,%ebx
  800c49:	75 d8                	jne    800c23 <strtol+0x44>
		s++, base = 8;
  800c4b:	83 c1 01             	add    $0x1,%ecx
  800c4e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c53:	eb ce                	jmp    800c23 <strtol+0x44>
		s += 2, base = 16;
  800c55:	83 c1 02             	add    $0x2,%ecx
  800c58:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c5d:	eb c4                	jmp    800c23 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c5f:	0f be d2             	movsbl %dl,%edx
  800c62:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c65:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c68:	7d 3a                	jge    800ca4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c6a:	83 c1 01             	add    $0x1,%ecx
  800c6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c71:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c73:	0f b6 11             	movzbl (%ecx),%edx
  800c76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c79:	89 f3                	mov    %esi,%ebx
  800c7b:	80 fb 09             	cmp    $0x9,%bl
  800c7e:	76 df                	jbe    800c5f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c80:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c83:	89 f3                	mov    %esi,%ebx
  800c85:	80 fb 19             	cmp    $0x19,%bl
  800c88:	77 08                	ja     800c92 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c8a:	0f be d2             	movsbl %dl,%edx
  800c8d:	83 ea 57             	sub    $0x57,%edx
  800c90:	eb d3                	jmp    800c65 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c92:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c95:	89 f3                	mov    %esi,%ebx
  800c97:	80 fb 19             	cmp    $0x19,%bl
  800c9a:	77 08                	ja     800ca4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c9c:	0f be d2             	movsbl %dl,%edx
  800c9f:	83 ea 37             	sub    $0x37,%edx
  800ca2:	eb c1                	jmp    800c65 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca8:	74 05                	je     800caf <strtol+0xd0>
		*endptr = (char *) s;
  800caa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cad:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	f7 da                	neg    %edx
  800cb3:	85 ff                	test   %edi,%edi
  800cb5:	0f 45 c2             	cmovne %edx,%eax
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbd:	f3 0f 1e fb          	endbr32 
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	89 c3                	mov    %eax,%ebx
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	89 c6                	mov    %eax,%esi
  800cd8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <sys_cgetc>:

int
sys_cgetc(void)
{
  800cdf:	f3 0f 1e fb          	endbr32 
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d02:	f3 0f 1e fb          	endbr32 
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1c:	89 cb                	mov    %ecx,%ebx
  800d1e:	89 cf                	mov    %ecx,%edi
  800d20:	89 ce                	mov    %ecx,%esi
  800d22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	7f 08                	jg     800d30 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 03                	push   $0x3
  800d36:	68 7f 28 80 00       	push   $0x80287f
  800d3b:	6a 23                	push   $0x23
  800d3d:	68 9c 28 80 00       	push   $0x80289c
  800d42:	e8 13 f5 ff ff       	call   80025a <_panic>

00800d47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d47:	f3 0f 1e fb          	endbr32 
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5b:	89 d1                	mov    %edx,%ecx
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	89 d7                	mov    %edx,%edi
  800d61:	89 d6                	mov    %edx,%esi
  800d63:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_yield>:

void
sys_yield(void)
{
  800d6a:	f3 0f 1e fb          	endbr32 
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7e:	89 d1                	mov    %edx,%ecx
  800d80:	89 d3                	mov    %edx,%ebx
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	89 d6                	mov    %edx,%esi
  800d86:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8d:	f3 0f 1e fb          	endbr32 
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9a:	be 00 00 00 00       	mov    $0x0,%esi
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 04 00 00 00       	mov    $0x4,%eax
  800daa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dad:	89 f7                	mov    %esi,%edi
  800daf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db1:	85 c0                	test   %eax,%eax
  800db3:	7f 08                	jg     800dbd <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	50                   	push   %eax
  800dc1:	6a 04                	push   $0x4
  800dc3:	68 7f 28 80 00       	push   $0x80287f
  800dc8:	6a 23                	push   $0x23
  800dca:	68 9c 28 80 00       	push   $0x80289c
  800dcf:	e8 86 f4 ff ff       	call   80025a <_panic>

00800dd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	8b 75 18             	mov    0x18(%ebp),%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 05                	push   $0x5
  800e09:	68 7f 28 80 00       	push   $0x80287f
  800e0e:	6a 23                	push   $0x23
  800e10:	68 9c 28 80 00       	push   $0x80289c
  800e15:	e8 40 f4 ff ff       	call   80025a <_panic>

00800e1a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e1a:	f3 0f 1e fb          	endbr32 
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 06 00 00 00       	mov    $0x6,%eax
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	89 de                	mov    %ebx,%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 06                	push   $0x6
  800e4f:	68 7f 28 80 00       	push   $0x80287f
  800e54:	6a 23                	push   $0x23
  800e56:	68 9c 28 80 00       	push   $0x80289c
  800e5b:	e8 fa f3 ff ff       	call   80025a <_panic>

00800e60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e60:	f3 0f 1e fb          	endbr32 
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	b8 08 00 00 00       	mov    $0x8,%eax
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 08                	push   $0x8
  800e95:	68 7f 28 80 00       	push   $0x80287f
  800e9a:	6a 23                	push   $0x23
  800e9c:	68 9c 28 80 00       	push   $0x80289c
  800ea1:	e8 b4 f3 ff ff       	call   80025a <_panic>

00800ea6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea6:	f3 0f 1e fb          	endbr32 
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec3:	89 df                	mov    %ebx,%edi
  800ec5:	89 de                	mov    %ebx,%esi
  800ec7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7f 08                	jg     800ed5 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed5:	83 ec 0c             	sub    $0xc,%esp
  800ed8:	50                   	push   %eax
  800ed9:	6a 09                	push   $0x9
  800edb:	68 7f 28 80 00       	push   $0x80287f
  800ee0:	6a 23                	push   $0x23
  800ee2:	68 9c 28 80 00       	push   $0x80289c
  800ee7:	e8 6e f3 ff ff       	call   80025a <_panic>

00800eec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eec:	f3 0f 1e fb          	endbr32 
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 0a                	push   $0xa
  800f21:	68 7f 28 80 00       	push   $0x80287f
  800f26:	6a 23                	push   $0x23
  800f28:	68 9c 28 80 00       	push   $0x80289c
  800f2d:	e8 28 f3 ff ff       	call   80025a <_panic>

00800f32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f47:	be 00 00 00 00       	mov    $0x0,%esi
  800f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f52:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f59:	f3 0f 1e fb          	endbr32 
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f73:	89 cb                	mov    %ecx,%ebx
  800f75:	89 cf                	mov    %ecx,%edi
  800f77:	89 ce                	mov    %ecx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 0d                	push   $0xd
  800f8d:	68 7f 28 80 00       	push   $0x80287f
  800f92:	6a 23                	push   $0x23
  800f94:	68 9c 28 80 00       	push   $0x80289c
  800f99:	e8 bc f2 ff ff       	call   80025a <_panic>

00800f9e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800f9e:	f3 0f 1e fb          	endbr32 
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800faa:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800fac:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fb0:	74 7f                	je     801031 <pgfault+0x93>
  800fb2:	89 f0                	mov    %esi,%eax
  800fb4:	c1 e8 0c             	shr    $0xc,%eax
  800fb7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fbe:	f6 c4 08             	test   $0x8,%ah
  800fc1:	74 6e                	je     801031 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800fc3:	e8 7f fd ff ff       	call   800d47 <sys_getenvid>
  800fc8:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800fca:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800fd0:	83 ec 04             	sub    $0x4,%esp
  800fd3:	6a 07                	push   $0x7
  800fd5:	68 00 f0 7f 00       	push   $0x7ff000
  800fda:	50                   	push   %eax
  800fdb:	e8 ad fd ff ff       	call   800d8d <sys_page_alloc>
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	78 5e                	js     801045 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800fe7:	83 ec 04             	sub    $0x4,%esp
  800fea:	68 00 10 00 00       	push   $0x1000
  800fef:	56                   	push   %esi
  800ff0:	68 00 f0 7f 00       	push   $0x7ff000
  800ff5:	e8 6d fb ff ff       	call   800b67 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800ffa:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
  801003:	68 00 f0 7f 00       	push   $0x7ff000
  801008:	53                   	push   %ebx
  801009:	e8 c6 fd ff ff       	call   800dd4 <sys_page_map>
  80100e:	83 c4 20             	add    $0x20,%esp
  801011:	85 c0                	test   %eax,%eax
  801013:	78 44                	js     801059 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  801015:	83 ec 08             	sub    $0x8,%esp
  801018:	68 00 f0 7f 00       	push   $0x7ff000
  80101d:	53                   	push   %ebx
  80101e:	e8 f7 fd ff ff       	call   800e1a <sys_page_unmap>
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	78 43                	js     80106d <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  80102a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	68 aa 28 80 00       	push   $0x8028aa
  801039:	6a 1e                	push   $0x1e
  80103b:	68 c7 28 80 00       	push   $0x8028c7
  801040:	e8 15 f2 ff ff       	call   80025a <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	68 58 29 80 00       	push   $0x802958
  80104d:	6a 2b                	push   $0x2b
  80104f:	68 c7 28 80 00       	push   $0x8028c7
  801054:	e8 01 f2 ff ff       	call   80025a <_panic>
		panic("pgfault: sys_page_map Failed!");
  801059:	83 ec 04             	sub    $0x4,%esp
  80105c:	68 d2 28 80 00       	push   $0x8028d2
  801061:	6a 2f                	push   $0x2f
  801063:	68 c7 28 80 00       	push   $0x8028c7
  801068:	e8 ed f1 ff ff       	call   80025a <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  80106d:	83 ec 04             	sub    $0x4,%esp
  801070:	68 78 29 80 00       	push   $0x802978
  801075:	6a 32                	push   $0x32
  801077:	68 c7 28 80 00       	push   $0x8028c7
  80107c:	e8 d9 f1 ff ff       	call   80025a <_panic>

00801081 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801081:	f3 0f 1e fb          	endbr32 
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80108e:	68 9e 0f 80 00       	push   $0x800f9e
  801093:	e8 af 10 00 00       	call   802147 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801098:	b8 07 00 00 00       	mov    $0x7,%eax
  80109d:	cd 30                	int    $0x30
  80109f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  8010a5:	83 c4 10             	add    $0x10,%esp
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	78 2b                	js     8010d7 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  8010ac:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  8010b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010b5:	0f 85 ba 00 00 00    	jne    801175 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  8010bb:	e8 87 fc ff ff       	call   800d47 <sys_getenvid>
  8010c0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010c5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010cd:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010d2:	e9 90 01 00 00       	jmp    801267 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  8010d7:	83 ec 04             	sub    $0x4,%esp
  8010da:	68 f0 28 80 00       	push   $0x8028f0
  8010df:	6a 76                	push   $0x76
  8010e1:	68 c7 28 80 00       	push   $0x8028c7
  8010e6:	e8 6f f1 ff ff       	call   80025a <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  8010eb:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  8010f2:	e8 50 fc ff ff       	call   800d47 <sys_getenvid>
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  801100:	56                   	push   %esi
  801101:	57                   	push   %edi
  801102:	ff 75 e0             	pushl  -0x20(%ebp)
  801105:	57                   	push   %edi
  801106:	50                   	push   %eax
  801107:	e8 c8 fc ff ff       	call   800dd4 <sys_page_map>
  80110c:	83 c4 20             	add    $0x20,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	79 50                	jns    801163 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  801113:	83 ec 04             	sub    $0x4,%esp
  801116:	68 09 29 80 00       	push   $0x802909
  80111b:	6a 4b                	push   $0x4b
  80111d:	68 c7 28 80 00       	push   $0x8028c7
  801122:	e8 33 f1 ff ff       	call   80025a <_panic>
			panic("duppage:child sys_page_map Failed!");
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	68 98 29 80 00       	push   $0x802998
  80112f:	6a 50                	push   $0x50
  801131:	68 c7 28 80 00       	push   $0x8028c7
  801136:	e8 1f f1 ff ff       	call   80025a <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  80113b:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	25 07 0e 00 00       	and    $0xe07,%eax
  80114a:	50                   	push   %eax
  80114b:	57                   	push   %edi
  80114c:	ff 75 e0             	pushl  -0x20(%ebp)
  80114f:	57                   	push   %edi
  801150:	ff 75 e4             	pushl  -0x1c(%ebp)
  801153:	e8 7c fc ff ff       	call   800dd4 <sys_page_map>
  801158:	83 c4 20             	add    $0x20,%esp
  80115b:	85 c0                	test   %eax,%eax
  80115d:	0f 88 b4 00 00 00    	js     801217 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801163:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801169:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80116f:	0f 84 b6 00 00 00    	je     80122b <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801175:	89 d8                	mov    %ebx,%eax
  801177:	c1 e8 16             	shr    $0x16,%eax
  80117a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801181:	a8 01                	test   $0x1,%al
  801183:	74 de                	je     801163 <fork+0xe2>
  801185:	89 de                	mov    %ebx,%esi
  801187:	c1 ee 0c             	shr    $0xc,%esi
  80118a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801191:	a8 01                	test   $0x1,%al
  801193:	74 ce                	je     801163 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801195:	e8 ad fb ff ff       	call   800d47 <sys_getenvid>
  80119a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  80119d:	89 f7                	mov    %esi,%edi
  80119f:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  8011a2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011a9:	f6 c4 04             	test   $0x4,%ah
  8011ac:	0f 85 39 ff ff ff    	jne    8010eb <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  8011b2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011b9:	a9 02 08 00 00       	test   $0x802,%eax
  8011be:	0f 84 77 ff ff ff    	je     80113b <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  8011c4:	83 ec 0c             	sub    $0xc,%esp
  8011c7:	68 05 08 00 00       	push   $0x805
  8011cc:	57                   	push   %edi
  8011cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8011d0:	57                   	push   %edi
  8011d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d4:	e8 fb fb ff ff       	call   800dd4 <sys_page_map>
  8011d9:	83 c4 20             	add    $0x20,%esp
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	0f 88 43 ff ff ff    	js     801127 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 05 08 00 00       	push   $0x805
  8011ec:	57                   	push   %edi
  8011ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f0:	50                   	push   %eax
  8011f1:	57                   	push   %edi
  8011f2:	50                   	push   %eax
  8011f3:	e8 dc fb ff ff       	call   800dd4 <sys_page_map>
  8011f8:	83 c4 20             	add    $0x20,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	0f 89 60 ff ff ff    	jns    801163 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  801203:	83 ec 04             	sub    $0x4,%esp
  801206:	68 bc 29 80 00       	push   $0x8029bc
  80120b:	6a 52                	push   $0x52
  80120d:	68 c7 28 80 00       	push   $0x8028c7
  801212:	e8 43 f0 ff ff       	call   80025a <_panic>
			panic("duppage: single sys_page_map Failed!");
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	68 e0 29 80 00       	push   $0x8029e0
  80121f:	6a 56                	push   $0x56
  801221:	68 c7 28 80 00       	push   $0x8028c7
  801226:	e8 2f f0 ff ff       	call   80025a <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	6a 07                	push   $0x7
  801230:	68 00 f0 bf ee       	push   $0xeebff000
  801235:	ff 75 dc             	pushl  -0x24(%ebp)
  801238:	e8 50 fb ff ff       	call   800d8d <sys_page_alloc>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	85 c0                	test   %eax,%eax
  801242:	78 2e                	js     801272 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	68 c3 21 80 00       	push   $0x8021c3
  80124c:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80124f:	57                   	push   %edi
  801250:	e8 97 fc ff ff       	call   800eec <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801255:	83 c4 08             	add    $0x8,%esp
  801258:	6a 02                	push   $0x2
  80125a:	57                   	push   %edi
  80125b:	e8 00 fc ff ff       	call   800e60 <sys_env_set_status>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 22                	js     801289 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801267:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126d:	5b                   	pop    %ebx
  80126e:	5e                   	pop    %esi
  80126f:	5f                   	pop    %edi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  801272:	83 ec 04             	sub    $0x4,%esp
  801275:	68 26 29 80 00       	push   $0x802926
  80127a:	68 83 00 00 00       	push   $0x83
  80127f:	68 c7 28 80 00       	push   $0x8028c7
  801284:	e8 d1 ef ff ff       	call   80025a <_panic>
		panic("fork: sys_env_set_status Failed!");
  801289:	83 ec 04             	sub    $0x4,%esp
  80128c:	68 08 2a 80 00       	push   $0x802a08
  801291:	68 89 00 00 00       	push   $0x89
  801296:	68 c7 28 80 00       	push   $0x8028c7
  80129b:	e8 ba ef ff ff       	call   80025a <_panic>

008012a0 <sfork>:

// Challenge!
int
sfork(void)
{
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012aa:	68 42 29 80 00       	push   $0x802942
  8012af:	68 93 00 00 00       	push   $0x93
  8012b4:	68 c7 28 80 00       	push   $0x8028c7
  8012b9:	e8 9c ef ff ff       	call   80025a <_panic>

008012be <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012be:	f3 0f 1e fb          	endbr32 
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8012d7:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8012da:	83 ec 0c             	sub    $0xc,%esp
  8012dd:	50                   	push   %eax
  8012de:	e8 76 fc ff ff       	call   800f59 <sys_ipc_recv>
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 2b                	js     801315 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8012ea:	85 f6                	test   %esi,%esi
  8012ec:	74 0a                	je     8012f8 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  8012ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8012f3:	8b 40 74             	mov    0x74(%eax),%eax
  8012f6:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  8012f8:	85 db                	test   %ebx,%ebx
  8012fa:	74 0a                	je     801306 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  8012fc:	a1 04 40 80 00       	mov    0x804004,%eax
  801301:	8b 40 78             	mov    0x78(%eax),%eax
  801304:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801306:	a1 04 40 80 00       	mov    0x804004,%eax
  80130b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80130e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
		if(from_env_store)
  801315:	85 f6                	test   %esi,%esi
  801317:	74 06                	je     80131f <ipc_recv+0x61>
			*from_env_store=0;
  801319:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80131f:	85 db                	test   %ebx,%ebx
  801321:	74 eb                	je     80130e <ipc_recv+0x50>
			*perm_store=0;
  801323:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801329:	eb e3                	jmp    80130e <ipc_recv+0x50>

0080132b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80132b:	f3 0f 1e fb          	endbr32 
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	57                   	push   %edi
  801333:	56                   	push   %esi
  801334:	53                   	push   %ebx
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80133e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801341:	85 db                	test   %ebx,%ebx
  801343:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801348:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  80134b:	ff 75 14             	pushl  0x14(%ebp)
  80134e:	53                   	push   %ebx
  80134f:	56                   	push   %esi
  801350:	57                   	push   %edi
  801351:	e8 dc fb ff ff       	call   800f32 <sys_ipc_try_send>
		if(!res)
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	85 c0                	test   %eax,%eax
  80135b:	74 20                	je     80137d <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  80135d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801360:	75 07                	jne    801369 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  801362:	e8 03 fa ff ff       	call   800d6a <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801367:	eb e2                	jmp    80134b <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	68 29 2a 80 00       	push   $0x802a29
  801371:	6a 3f                	push   $0x3f
  801373:	68 41 2a 80 00       	push   $0x802a41
  801378:	e8 dd ee ff ff       	call   80025a <_panic>
	}
}
  80137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801380:	5b                   	pop    %ebx
  801381:	5e                   	pop    %esi
  801382:	5f                   	pop    %edi
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    

00801385 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801385:	f3 0f 1e fb          	endbr32 
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80138f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801394:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801397:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80139d:	8b 52 50             	mov    0x50(%edx),%edx
  8013a0:	39 ca                	cmp    %ecx,%edx
  8013a2:	74 11                	je     8013b5 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8013a4:	83 c0 01             	add    $0x1,%eax
  8013a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013ac:	75 e6                	jne    801394 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8013ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b3:	eb 0b                	jmp    8013c0 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8013b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    

008013c2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013c2:	f3 0f 1e fb          	endbr32 
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	05 00 00 00 30       	add    $0x30000000,%eax
  8013d1:	c1 e8 0c             	shr    $0xc,%eax
}
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    

008013d6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013d6:	f3 0f 1e fb          	endbr32 
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013f1:	f3 0f 1e fb          	endbr32 
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013fd:	89 c2                	mov    %eax,%edx
  8013ff:	c1 ea 16             	shr    $0x16,%edx
  801402:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801409:	f6 c2 01             	test   $0x1,%dl
  80140c:	74 2d                	je     80143b <fd_alloc+0x4a>
  80140e:	89 c2                	mov    %eax,%edx
  801410:	c1 ea 0c             	shr    $0xc,%edx
  801413:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141a:	f6 c2 01             	test   $0x1,%dl
  80141d:	74 1c                	je     80143b <fd_alloc+0x4a>
  80141f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801424:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801429:	75 d2                	jne    8013fd <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801434:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801439:	eb 0a                	jmp    801445 <fd_alloc+0x54>
			*fd_store = fd;
  80143b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801447:	f3 0f 1e fb          	endbr32 
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801451:	83 f8 1f             	cmp    $0x1f,%eax
  801454:	77 30                	ja     801486 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801456:	c1 e0 0c             	shl    $0xc,%eax
  801459:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80145e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801464:	f6 c2 01             	test   $0x1,%dl
  801467:	74 24                	je     80148d <fd_lookup+0x46>
  801469:	89 c2                	mov    %eax,%edx
  80146b:	c1 ea 0c             	shr    $0xc,%edx
  80146e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801475:	f6 c2 01             	test   $0x1,%dl
  801478:	74 1a                	je     801494 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80147a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147d:	89 02                	mov    %eax,(%edx)
	return 0;
  80147f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801484:	5d                   	pop    %ebp
  801485:	c3                   	ret    
		return -E_INVAL;
  801486:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148b:	eb f7                	jmp    801484 <fd_lookup+0x3d>
		return -E_INVAL;
  80148d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801492:	eb f0                	jmp    801484 <fd_lookup+0x3d>
  801494:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801499:	eb e9                	jmp    801484 <fd_lookup+0x3d>

0080149b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80149b:	f3 0f 1e fb          	endbr32 
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a8:	ba c8 2a 80 00       	mov    $0x802ac8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014ad:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014b2:	39 08                	cmp    %ecx,(%eax)
  8014b4:	74 33                	je     8014e9 <dev_lookup+0x4e>
  8014b6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014b9:	8b 02                	mov    (%edx),%eax
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	75 f3                	jne    8014b2 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c4:	8b 40 48             	mov    0x48(%eax),%eax
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	51                   	push   %ecx
  8014cb:	50                   	push   %eax
  8014cc:	68 4c 2a 80 00       	push   $0x802a4c
  8014d1:	e8 6b ee ff ff       	call   800341 <cprintf>
	*dev = 0;
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    
			*dev = devtab[i];
  8014e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ec:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f3:	eb f2                	jmp    8014e7 <dev_lookup+0x4c>

008014f5 <fd_close>:
{
  8014f5:	f3 0f 1e fb          	endbr32 
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	57                   	push   %edi
  8014fd:	56                   	push   %esi
  8014fe:	53                   	push   %ebx
  8014ff:	83 ec 24             	sub    $0x24,%esp
  801502:	8b 75 08             	mov    0x8(%ebp),%esi
  801505:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801508:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80150b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801512:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801515:	50                   	push   %eax
  801516:	e8 2c ff ff ff       	call   801447 <fd_lookup>
  80151b:	89 c3                	mov    %eax,%ebx
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 05                	js     801529 <fd_close+0x34>
	    || fd != fd2)
  801524:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801527:	74 16                	je     80153f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801529:	89 f8                	mov    %edi,%eax
  80152b:	84 c0                	test   %al,%al
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	0f 44 d8             	cmove  %eax,%ebx
}
  801535:	89 d8                	mov    %ebx,%eax
  801537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5f                   	pop    %edi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	ff 36                	pushl  (%esi)
  801548:	e8 4e ff ff ff       	call   80149b <dev_lookup>
  80154d:	89 c3                	mov    %eax,%ebx
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	78 1a                	js     801570 <fd_close+0x7b>
		if (dev->dev_close)
  801556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801559:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80155c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801561:	85 c0                	test   %eax,%eax
  801563:	74 0b                	je     801570 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	56                   	push   %esi
  801569:	ff d0                	call   *%eax
  80156b:	89 c3                	mov    %eax,%ebx
  80156d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	56                   	push   %esi
  801574:	6a 00                	push   $0x0
  801576:	e8 9f f8 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	eb b5                	jmp    801535 <fd_close+0x40>

00801580 <close>:

int
close(int fdnum)
{
  801580:	f3 0f 1e fb          	endbr32 
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158d:	50                   	push   %eax
  80158e:	ff 75 08             	pushl  0x8(%ebp)
  801591:	e8 b1 fe ff ff       	call   801447 <fd_lookup>
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	79 02                	jns    80159f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    
		return fd_close(fd, 1);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	6a 01                	push   $0x1
  8015a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a7:	e8 49 ff ff ff       	call   8014f5 <fd_close>
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	eb ec                	jmp    80159d <close+0x1d>

008015b1 <close_all>:

void
close_all(void)
{
  8015b1:	f3 0f 1e fb          	endbr32 
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015bc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	53                   	push   %ebx
  8015c5:	e8 b6 ff ff ff       	call   801580 <close>
	for (i = 0; i < MAXFD; i++)
  8015ca:	83 c3 01             	add    $0x1,%ebx
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	83 fb 20             	cmp    $0x20,%ebx
  8015d3:	75 ec                	jne    8015c1 <close_all+0x10>
}
  8015d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015da:	f3 0f 1e fb          	endbr32 
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	57                   	push   %edi
  8015e2:	56                   	push   %esi
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 54 fe ff ff       	call   801447 <fd_lookup>
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	0f 88 81 00 00 00    	js     801681 <dup+0xa7>
		return r;
	close(newfdnum);
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	e8 75 ff ff ff       	call   801580 <close>

	newfd = INDEX2FD(newfdnum);
  80160b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80160e:	c1 e6 0c             	shl    $0xc,%esi
  801611:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801617:	83 c4 04             	add    $0x4,%esp
  80161a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80161d:	e8 b4 fd ff ff       	call   8013d6 <fd2data>
  801622:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801624:	89 34 24             	mov    %esi,(%esp)
  801627:	e8 aa fd ff ff       	call   8013d6 <fd2data>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801631:	89 d8                	mov    %ebx,%eax
  801633:	c1 e8 16             	shr    $0x16,%eax
  801636:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80163d:	a8 01                	test   $0x1,%al
  80163f:	74 11                	je     801652 <dup+0x78>
  801641:	89 d8                	mov    %ebx,%eax
  801643:	c1 e8 0c             	shr    $0xc,%eax
  801646:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80164d:	f6 c2 01             	test   $0x1,%dl
  801650:	75 39                	jne    80168b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801655:	89 d0                	mov    %edx,%eax
  801657:	c1 e8 0c             	shr    $0xc,%eax
  80165a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	25 07 0e 00 00       	and    $0xe07,%eax
  801669:	50                   	push   %eax
  80166a:	56                   	push   %esi
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	6a 00                	push   $0x0
  801670:	e8 5f f7 ff ff       	call   800dd4 <sys_page_map>
  801675:	89 c3                	mov    %eax,%ebx
  801677:	83 c4 20             	add    $0x20,%esp
  80167a:	85 c0                	test   %eax,%eax
  80167c:	78 31                	js     8016af <dup+0xd5>
		goto err;

	return newfdnum;
  80167e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801681:	89 d8                	mov    %ebx,%eax
  801683:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5f                   	pop    %edi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80168b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	25 07 0e 00 00       	and    $0xe07,%eax
  80169a:	50                   	push   %eax
  80169b:	57                   	push   %edi
  80169c:	6a 00                	push   $0x0
  80169e:	53                   	push   %ebx
  80169f:	6a 00                	push   $0x0
  8016a1:	e8 2e f7 ff ff       	call   800dd4 <sys_page_map>
  8016a6:	89 c3                	mov    %eax,%ebx
  8016a8:	83 c4 20             	add    $0x20,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	79 a3                	jns    801652 <dup+0x78>
	sys_page_unmap(0, newfd);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	56                   	push   %esi
  8016b3:	6a 00                	push   $0x0
  8016b5:	e8 60 f7 ff ff       	call   800e1a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016ba:	83 c4 08             	add    $0x8,%esp
  8016bd:	57                   	push   %edi
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 55 f7 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	eb b7                	jmp    801681 <dup+0xa7>

008016ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ca:	f3 0f 1e fb          	endbr32 
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 1c             	sub    $0x1c,%esp
  8016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016db:	50                   	push   %eax
  8016dc:	53                   	push   %ebx
  8016dd:	e8 65 fd ff ff       	call   801447 <fd_lookup>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 3f                	js     801728 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	ff 30                	pushl  (%eax)
  8016f5:	e8 a1 fd ff ff       	call   80149b <dev_lookup>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 27                	js     801728 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801701:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801704:	8b 42 08             	mov    0x8(%edx),%eax
  801707:	83 e0 03             	and    $0x3,%eax
  80170a:	83 f8 01             	cmp    $0x1,%eax
  80170d:	74 1e                	je     80172d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	8b 40 08             	mov    0x8(%eax),%eax
  801715:	85 c0                	test   %eax,%eax
  801717:	74 35                	je     80174e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	ff 75 10             	pushl  0x10(%ebp)
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	52                   	push   %edx
  801723:	ff d0                	call   *%eax
  801725:	83 c4 10             	add    $0x10,%esp
}
  801728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80172d:	a1 04 40 80 00       	mov    0x804004,%eax
  801732:	8b 40 48             	mov    0x48(%eax),%eax
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	53                   	push   %ebx
  801739:	50                   	push   %eax
  80173a:	68 8d 2a 80 00       	push   $0x802a8d
  80173f:	e8 fd eb ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174c:	eb da                	jmp    801728 <read+0x5e>
		return -E_NOT_SUPP;
  80174e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801753:	eb d3                	jmp    801728 <read+0x5e>

00801755 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801755:	f3 0f 1e fb          	endbr32 
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	57                   	push   %edi
  80175d:	56                   	push   %esi
  80175e:	53                   	push   %ebx
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	8b 7d 08             	mov    0x8(%ebp),%edi
  801765:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801768:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176d:	eb 02                	jmp    801771 <readn+0x1c>
  80176f:	01 c3                	add    %eax,%ebx
  801771:	39 f3                	cmp    %esi,%ebx
  801773:	73 21                	jae    801796 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	89 f0                	mov    %esi,%eax
  80177a:	29 d8                	sub    %ebx,%eax
  80177c:	50                   	push   %eax
  80177d:	89 d8                	mov    %ebx,%eax
  80177f:	03 45 0c             	add    0xc(%ebp),%eax
  801782:	50                   	push   %eax
  801783:	57                   	push   %edi
  801784:	e8 41 ff ff ff       	call   8016ca <read>
		if (m < 0)
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 04                	js     801794 <readn+0x3f>
			return m;
		if (m == 0)
  801790:	75 dd                	jne    80176f <readn+0x1a>
  801792:	eb 02                	jmp    801796 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801794:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801796:	89 d8                	mov    %ebx,%eax
  801798:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017a0:	f3 0f 1e fb          	endbr32 
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 1c             	sub    $0x1c,%esp
  8017ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	53                   	push   %ebx
  8017b3:	e8 8f fc ff ff       	call   801447 <fd_lookup>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 3a                	js     8017f9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	ff 30                	pushl  (%eax)
  8017cb:	e8 cb fc ff ff       	call   80149b <dev_lookup>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 22                	js     8017f9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017de:	74 1e                	je     8017fe <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e3:	8b 52 0c             	mov    0xc(%edx),%edx
  8017e6:	85 d2                	test   %edx,%edx
  8017e8:	74 35                	je     80181f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	ff 75 10             	pushl  0x10(%ebp)
  8017f0:	ff 75 0c             	pushl  0xc(%ebp)
  8017f3:	50                   	push   %eax
  8017f4:	ff d2                	call   *%edx
  8017f6:	83 c4 10             	add    $0x10,%esp
}
  8017f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017fe:	a1 04 40 80 00       	mov    0x804004,%eax
  801803:	8b 40 48             	mov    0x48(%eax),%eax
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	53                   	push   %ebx
  80180a:	50                   	push   %eax
  80180b:	68 a9 2a 80 00       	push   $0x802aa9
  801810:	e8 2c eb ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181d:	eb da                	jmp    8017f9 <write+0x59>
		return -E_NOT_SUPP;
  80181f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801824:	eb d3                	jmp    8017f9 <write+0x59>

00801826 <seek>:

int
seek(int fdnum, off_t offset)
{
  801826:	f3 0f 1e fb          	endbr32 
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801830:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801833:	50                   	push   %eax
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	e8 0b fc ff ff       	call   801447 <fd_lookup>
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 0e                	js     801851 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801853:	f3 0f 1e fb          	endbr32 
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	53                   	push   %ebx
  80185b:	83 ec 1c             	sub    $0x1c,%esp
  80185e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801861:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801864:	50                   	push   %eax
  801865:	53                   	push   %ebx
  801866:	e8 dc fb ff ff       	call   801447 <fd_lookup>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 37                	js     8018a9 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801878:	50                   	push   %eax
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	ff 30                	pushl  (%eax)
  80187e:	e8 18 fc ff ff       	call   80149b <dev_lookup>
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	85 c0                	test   %eax,%eax
  801888:	78 1f                	js     8018a9 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801891:	74 1b                	je     8018ae <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	8b 52 18             	mov    0x18(%edx),%edx
  801899:	85 d2                	test   %edx,%edx
  80189b:	74 32                	je     8018cf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	50                   	push   %eax
  8018a4:	ff d2                	call   *%edx
  8018a6:	83 c4 10             	add    $0x10,%esp
}
  8018a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018ae:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b3:	8b 40 48             	mov    0x48(%eax),%eax
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	53                   	push   %ebx
  8018ba:	50                   	push   %eax
  8018bb:	68 6c 2a 80 00       	push   $0x802a6c
  8018c0:	e8 7c ea ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cd:	eb da                	jmp    8018a9 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8018cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d4:	eb d3                	jmp    8018a9 <ftruncate+0x56>

008018d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018d6:	f3 0f 1e fb          	endbr32 
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 1c             	sub    $0x1c,%esp
  8018e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 57 fb ff ff       	call   801447 <fd_lookup>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 4b                	js     801942 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801901:	ff 30                	pushl  (%eax)
  801903:	e8 93 fb ff ff       	call   80149b <dev_lookup>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 33                	js     801942 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801916:	74 2f                	je     801947 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801918:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80191b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801922:	00 00 00 
	stat->st_isdir = 0;
  801925:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192c:	00 00 00 
	stat->st_dev = dev;
  80192f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	53                   	push   %ebx
  801939:	ff 75 f0             	pushl  -0x10(%ebp)
  80193c:	ff 50 14             	call   *0x14(%eax)
  80193f:	83 c4 10             	add    $0x10,%esp
}
  801942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801945:	c9                   	leave  
  801946:	c3                   	ret    
		return -E_NOT_SUPP;
  801947:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194c:	eb f4                	jmp    801942 <fstat+0x6c>

0080194e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80194e:	f3 0f 1e fb          	endbr32 
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	56                   	push   %esi
  801956:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801957:	83 ec 08             	sub    $0x8,%esp
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	e8 fb 01 00 00       	call   801b5f <open>
  801964:	89 c3                	mov    %eax,%ebx
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 1b                	js     801988 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	50                   	push   %eax
  801974:	e8 5d ff ff ff       	call   8018d6 <fstat>
  801979:	89 c6                	mov    %eax,%esi
	close(fd);
  80197b:	89 1c 24             	mov    %ebx,(%esp)
  80197e:	e8 fd fb ff ff       	call   801580 <close>
	return r;
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	89 f3                	mov    %esi,%ebx
}
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    

00801991 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	56                   	push   %esi
  801995:	53                   	push   %ebx
  801996:	89 c6                	mov    %eax,%esi
  801998:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80199a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019a1:	74 27                	je     8019ca <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019a3:	6a 07                	push   $0x7
  8019a5:	68 00 50 80 00       	push   $0x805000
  8019aa:	56                   	push   %esi
  8019ab:	ff 35 00 40 80 00    	pushl  0x804000
  8019b1:	e8 75 f9 ff ff       	call   80132b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019b6:	83 c4 0c             	add    $0xc,%esp
  8019b9:	6a 00                	push   $0x0
  8019bb:	53                   	push   %ebx
  8019bc:	6a 00                	push   $0x0
  8019be:	e8 fb f8 ff ff       	call   8012be <ipc_recv>
}
  8019c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c6:	5b                   	pop    %ebx
  8019c7:	5e                   	pop    %esi
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019ca:	83 ec 0c             	sub    $0xc,%esp
  8019cd:	6a 01                	push   $0x1
  8019cf:	e8 b1 f9 ff ff       	call   801385 <ipc_find_env>
  8019d4:	a3 00 40 80 00       	mov    %eax,0x804000
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	eb c5                	jmp    8019a3 <fsipc+0x12>

008019de <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019de:	f3 0f 1e fb          	endbr32 
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ee:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	b8 02 00 00 00       	mov    $0x2,%eax
  801a05:	e8 87 ff ff ff       	call   801991 <fsipc>
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <devfile_flush>:
{
  801a0c:	f3 0f 1e fb          	endbr32 
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a21:	ba 00 00 00 00       	mov    $0x0,%edx
  801a26:	b8 06 00 00 00       	mov    $0x6,%eax
  801a2b:	e8 61 ff ff ff       	call   801991 <fsipc>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <devfile_stat>:
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8b 40 0c             	mov    0xc(%eax),%eax
  801a46:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	b8 05 00 00 00       	mov    $0x5,%eax
  801a55:	e8 37 ff ff ff       	call   801991 <fsipc>
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 2c                	js     801a8a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	68 00 50 80 00       	push   $0x805000
  801a66:	53                   	push   %ebx
  801a67:	e8 df ee ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a6c:	a1 80 50 80 00       	mov    0x805080,%eax
  801a71:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a77:	a1 84 50 80 00       	mov    0x805084,%eax
  801a7c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <devfile_write>:
{
  801a8f:	f3 0f 1e fb          	endbr32 
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 0c             	sub    $0xc,%esp
  801a99:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801aa1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801aa6:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  801aac:	8b 52 0c             	mov    0xc(%edx),%edx
  801aaf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801ab5:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801aba:	50                   	push   %eax
  801abb:	ff 75 0c             	pushl  0xc(%ebp)
  801abe:	68 08 50 80 00       	push   $0x805008
  801ac3:	e8 39 f0 ff ff       	call   800b01 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  801acd:	b8 04 00 00 00       	mov    $0x4,%eax
  801ad2:	e8 ba fe ff ff       	call   801991 <fsipc>
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <devfile_read>:
{
  801ad9:	f3 0f 1e fb          	endbr32 
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	56                   	push   %esi
  801ae1:	53                   	push   %ebx
  801ae2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	8b 40 0c             	mov    0xc(%eax),%eax
  801aeb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801af0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801af6:	ba 00 00 00 00       	mov    $0x0,%edx
  801afb:	b8 03 00 00 00       	mov    $0x3,%eax
  801b00:	e8 8c fe ff ff       	call   801991 <fsipc>
  801b05:	89 c3                	mov    %eax,%ebx
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 1f                	js     801b2a <devfile_read+0x51>
	assert(r <= n);
  801b0b:	39 f0                	cmp    %esi,%eax
  801b0d:	77 24                	ja     801b33 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b0f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b14:	7f 33                	jg     801b49 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	50                   	push   %eax
  801b1a:	68 00 50 80 00       	push   $0x805000
  801b1f:	ff 75 0c             	pushl  0xc(%ebp)
  801b22:	e8 da ef ff ff       	call   800b01 <memmove>
	return r;
  801b27:	83 c4 10             	add    $0x10,%esp
}
  801b2a:	89 d8                	mov    %ebx,%eax
  801b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    
	assert(r <= n);
  801b33:	68 d8 2a 80 00       	push   $0x802ad8
  801b38:	68 df 2a 80 00       	push   $0x802adf
  801b3d:	6a 7d                	push   $0x7d
  801b3f:	68 f4 2a 80 00       	push   $0x802af4
  801b44:	e8 11 e7 ff ff       	call   80025a <_panic>
	assert(r <= PGSIZE);
  801b49:	68 ff 2a 80 00       	push   $0x802aff
  801b4e:	68 df 2a 80 00       	push   $0x802adf
  801b53:	6a 7e                	push   $0x7e
  801b55:	68 f4 2a 80 00       	push   $0x802af4
  801b5a:	e8 fb e6 ff ff       	call   80025a <_panic>

00801b5f <open>:
{
  801b5f:	f3 0f 1e fb          	endbr32 
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	83 ec 1c             	sub    $0x1c,%esp
  801b6b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b6e:	56                   	push   %esi
  801b6f:	e8 94 ed ff ff       	call   800908 <strlen>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b7c:	7f 6c                	jg     801bea <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b84:	50                   	push   %eax
  801b85:	e8 67 f8 ff ff       	call   8013f1 <fd_alloc>
  801b8a:	89 c3                	mov    %eax,%ebx
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 3c                	js     801bcf <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b93:	83 ec 08             	sub    $0x8,%esp
  801b96:	56                   	push   %esi
  801b97:	68 00 50 80 00       	push   $0x805000
  801b9c:	e8 aa ed ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bac:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb1:	e8 db fd ff ff       	call   801991 <fsipc>
  801bb6:	89 c3                	mov    %eax,%ebx
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 19                	js     801bd8 <open+0x79>
	return fd2num(fd);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc5:	e8 f8 f7 ff ff       	call   8013c2 <fd2num>
  801bca:	89 c3                	mov    %eax,%ebx
  801bcc:	83 c4 10             	add    $0x10,%esp
}
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
		fd_close(fd, 0);
  801bd8:	83 ec 08             	sub    $0x8,%esp
  801bdb:	6a 00                	push   $0x0
  801bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801be0:	e8 10 f9 ff ff       	call   8014f5 <fd_close>
		return r;
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	eb e5                	jmp    801bcf <open+0x70>
		return -E_BAD_PATH;
  801bea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bef:	eb de                	jmp    801bcf <open+0x70>

00801bf1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bf1:	f3 0f 1e fb          	endbr32 
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801c00:	b8 08 00 00 00       	mov    $0x8,%eax
  801c05:	e8 87 fd ff ff       	call   801991 <fsipc>
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c0c:	f3 0f 1e fb          	endbr32 
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c16:	89 c2                	mov    %eax,%edx
  801c18:	c1 ea 16             	shr    $0x16,%edx
  801c1b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c22:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c27:	f6 c1 01             	test   $0x1,%cl
  801c2a:	74 1c                	je     801c48 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c2c:	c1 e8 0c             	shr    $0xc,%eax
  801c2f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c36:	a8 01                	test   $0x1,%al
  801c38:	74 0e                	je     801c48 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c3a:	c1 e8 0c             	shr    $0xc,%eax
  801c3d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c44:	ef 
  801c45:	0f b7 d2             	movzwl %dx,%edx
}
  801c48:	89 d0                	mov    %edx,%eax
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c4c:	f3 0f 1e fb          	endbr32 
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	e8 73 f7 ff ff       	call   8013d6 <fd2data>
  801c63:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c65:	83 c4 08             	add    $0x8,%esp
  801c68:	68 0b 2b 80 00       	push   $0x802b0b
  801c6d:	53                   	push   %ebx
  801c6e:	e8 d8 ec ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c73:	8b 46 04             	mov    0x4(%esi),%eax
  801c76:	2b 06                	sub    (%esi),%eax
  801c78:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c7e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c85:	00 00 00 
	stat->st_dev = &devpipe;
  801c88:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c8f:	30 80 00 
	return 0;
}
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5e                   	pop    %esi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c9e:	f3 0f 1e fb          	endbr32 
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cac:	53                   	push   %ebx
  801cad:	6a 00                	push   $0x0
  801caf:	e8 66 f1 ff ff       	call   800e1a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb4:	89 1c 24             	mov    %ebx,(%esp)
  801cb7:	e8 1a f7 ff ff       	call   8013d6 <fd2data>
  801cbc:	83 c4 08             	add    $0x8,%esp
  801cbf:	50                   	push   %eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	e8 53 f1 ff ff       	call   800e1a <sys_page_unmap>
}
  801cc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <_pipeisclosed>:
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	57                   	push   %edi
  801cd0:	56                   	push   %esi
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 1c             	sub    $0x1c,%esp
  801cd5:	89 c7                	mov    %eax,%edi
  801cd7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd9:	a1 04 40 80 00       	mov    0x804004,%eax
  801cde:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	57                   	push   %edi
  801ce5:	e8 22 ff ff ff       	call   801c0c <pageref>
  801cea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ced:	89 34 24             	mov    %esi,(%esp)
  801cf0:	e8 17 ff ff ff       	call   801c0c <pageref>
		nn = thisenv->env_runs;
  801cf5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cfb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cfe:	83 c4 10             	add    $0x10,%esp
  801d01:	39 cb                	cmp    %ecx,%ebx
  801d03:	74 1b                	je     801d20 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d05:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d08:	75 cf                	jne    801cd9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d0a:	8b 42 58             	mov    0x58(%edx),%eax
  801d0d:	6a 01                	push   $0x1
  801d0f:	50                   	push   %eax
  801d10:	53                   	push   %ebx
  801d11:	68 12 2b 80 00       	push   $0x802b12
  801d16:	e8 26 e6 ff ff       	call   800341 <cprintf>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	eb b9                	jmp    801cd9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d20:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d23:	0f 94 c0             	sete   %al
  801d26:	0f b6 c0             	movzbl %al,%eax
}
  801d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5f                   	pop    %edi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    

00801d31 <devpipe_write>:
{
  801d31:	f3 0f 1e fb          	endbr32 
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	57                   	push   %edi
  801d39:	56                   	push   %esi
  801d3a:	53                   	push   %ebx
  801d3b:	83 ec 28             	sub    $0x28,%esp
  801d3e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d41:	56                   	push   %esi
  801d42:	e8 8f f6 ff ff       	call   8013d6 <fd2data>
  801d47:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d51:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d54:	74 4f                	je     801da5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d56:	8b 43 04             	mov    0x4(%ebx),%eax
  801d59:	8b 0b                	mov    (%ebx),%ecx
  801d5b:	8d 51 20             	lea    0x20(%ecx),%edx
  801d5e:	39 d0                	cmp    %edx,%eax
  801d60:	72 14                	jb     801d76 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d62:	89 da                	mov    %ebx,%edx
  801d64:	89 f0                	mov    %esi,%eax
  801d66:	e8 61 ff ff ff       	call   801ccc <_pipeisclosed>
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	75 3b                	jne    801daa <devpipe_write+0x79>
			sys_yield();
  801d6f:	e8 f6 ef ff ff       	call   800d6a <sys_yield>
  801d74:	eb e0                	jmp    801d56 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d79:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d7d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	c1 fa 1f             	sar    $0x1f,%edx
  801d85:	89 d1                	mov    %edx,%ecx
  801d87:	c1 e9 1b             	shr    $0x1b,%ecx
  801d8a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d8d:	83 e2 1f             	and    $0x1f,%edx
  801d90:	29 ca                	sub    %ecx,%edx
  801d92:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d96:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d9a:	83 c0 01             	add    $0x1,%eax
  801d9d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801da0:	83 c7 01             	add    $0x1,%edi
  801da3:	eb ac                	jmp    801d51 <devpipe_write+0x20>
	return i;
  801da5:	8b 45 10             	mov    0x10(%ebp),%eax
  801da8:	eb 05                	jmp    801daf <devpipe_write+0x7e>
				return 0;
  801daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5f                   	pop    %edi
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    

00801db7 <devpipe_read>:
{
  801db7:	f3 0f 1e fb          	endbr32 
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	57                   	push   %edi
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
  801dc1:	83 ec 18             	sub    $0x18,%esp
  801dc4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dc7:	57                   	push   %edi
  801dc8:	e8 09 f6 ff ff       	call   8013d6 <fd2data>
  801dcd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dcf:	83 c4 10             	add    $0x10,%esp
  801dd2:	be 00 00 00 00       	mov    $0x0,%esi
  801dd7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dda:	75 14                	jne    801df0 <devpipe_read+0x39>
	return i;
  801ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddf:	eb 02                	jmp    801de3 <devpipe_read+0x2c>
				return i;
  801de1:	89 f0                	mov    %esi,%eax
}
  801de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5f                   	pop    %edi
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    
			sys_yield();
  801deb:	e8 7a ef ff ff       	call   800d6a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801df0:	8b 03                	mov    (%ebx),%eax
  801df2:	3b 43 04             	cmp    0x4(%ebx),%eax
  801df5:	75 18                	jne    801e0f <devpipe_read+0x58>
			if (i > 0)
  801df7:	85 f6                	test   %esi,%esi
  801df9:	75 e6                	jne    801de1 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801dfb:	89 da                	mov    %ebx,%edx
  801dfd:	89 f8                	mov    %edi,%eax
  801dff:	e8 c8 fe ff ff       	call   801ccc <_pipeisclosed>
  801e04:	85 c0                	test   %eax,%eax
  801e06:	74 e3                	je     801deb <devpipe_read+0x34>
				return 0;
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0d:	eb d4                	jmp    801de3 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e0f:	99                   	cltd   
  801e10:	c1 ea 1b             	shr    $0x1b,%edx
  801e13:	01 d0                	add    %edx,%eax
  801e15:	83 e0 1f             	and    $0x1f,%eax
  801e18:	29 d0                	sub    %edx,%eax
  801e1a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e22:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e25:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e28:	83 c6 01             	add    $0x1,%esi
  801e2b:	eb aa                	jmp    801dd7 <devpipe_read+0x20>

00801e2d <pipe>:
{
  801e2d:	f3 0f 1e fb          	endbr32 
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	56                   	push   %esi
  801e35:	53                   	push   %ebx
  801e36:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3c:	50                   	push   %eax
  801e3d:	e8 af f5 ff ff       	call   8013f1 <fd_alloc>
  801e42:	89 c3                	mov    %eax,%ebx
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	85 c0                	test   %eax,%eax
  801e49:	0f 88 23 01 00 00    	js     801f72 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	68 07 04 00 00       	push   $0x407
  801e57:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5a:	6a 00                	push   $0x0
  801e5c:	e8 2c ef ff ff       	call   800d8d <sys_page_alloc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	85 c0                	test   %eax,%eax
  801e68:	0f 88 04 01 00 00    	js     801f72 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e74:	50                   	push   %eax
  801e75:	e8 77 f5 ff ff       	call   8013f1 <fd_alloc>
  801e7a:	89 c3                	mov    %eax,%ebx
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	0f 88 db 00 00 00    	js     801f62 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	68 07 04 00 00       	push   $0x407
  801e8f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e92:	6a 00                	push   $0x0
  801e94:	e8 f4 ee ff ff       	call   800d8d <sys_page_alloc>
  801e99:	89 c3                	mov    %eax,%ebx
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	0f 88 bc 00 00 00    	js     801f62 <pipe+0x135>
	va = fd2data(fd0);
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	ff 75 f4             	pushl  -0xc(%ebp)
  801eac:	e8 25 f5 ff ff       	call   8013d6 <fd2data>
  801eb1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb3:	83 c4 0c             	add    $0xc,%esp
  801eb6:	68 07 04 00 00       	push   $0x407
  801ebb:	50                   	push   %eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	e8 ca ee ff ff       	call   800d8d <sys_page_alloc>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 88 82 00 00 00    	js     801f52 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed6:	e8 fb f4 ff ff       	call   8013d6 <fd2data>
  801edb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ee2:	50                   	push   %eax
  801ee3:	6a 00                	push   $0x0
  801ee5:	56                   	push   %esi
  801ee6:	6a 00                	push   $0x0
  801ee8:	e8 e7 ee ff ff       	call   800dd4 <sys_page_map>
  801eed:	89 c3                	mov    %eax,%ebx
  801eef:	83 c4 20             	add    $0x20,%esp
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	78 4e                	js     801f44 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ef6:	a1 20 30 80 00       	mov    0x803020,%eax
  801efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efe:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f03:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f0d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f12:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1f:	e8 9e f4 ff ff       	call   8013c2 <fd2num>
  801f24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f27:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f29:	83 c4 04             	add    $0x4,%esp
  801f2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2f:	e8 8e f4 ff ff       	call   8013c2 <fd2num>
  801f34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f37:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f42:	eb 2e                	jmp    801f72 <pipe+0x145>
	sys_page_unmap(0, va);
  801f44:	83 ec 08             	sub    $0x8,%esp
  801f47:	56                   	push   %esi
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 cb ee ff ff       	call   800e1a <sys_page_unmap>
  801f4f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f52:	83 ec 08             	sub    $0x8,%esp
  801f55:	ff 75 f0             	pushl  -0x10(%ebp)
  801f58:	6a 00                	push   $0x0
  801f5a:	e8 bb ee ff ff       	call   800e1a <sys_page_unmap>
  801f5f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f62:	83 ec 08             	sub    $0x8,%esp
  801f65:	ff 75 f4             	pushl  -0xc(%ebp)
  801f68:	6a 00                	push   $0x0
  801f6a:	e8 ab ee ff ff       	call   800e1a <sys_page_unmap>
  801f6f:	83 c4 10             	add    $0x10,%esp
}
  801f72:	89 d8                	mov    %ebx,%eax
  801f74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5d                   	pop    %ebp
  801f7a:	c3                   	ret    

00801f7b <pipeisclosed>:
{
  801f7b:	f3 0f 1e fb          	endbr32 
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f88:	50                   	push   %eax
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	e8 b6 f4 ff ff       	call   801447 <fd_lookup>
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 18                	js     801fb0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9e:	e8 33 f4 ff ff       	call   8013d6 <fd2data>
  801fa3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	e8 1f fd ff ff       	call   801ccc <_pipeisclosed>
  801fad:	83 c4 10             	add    $0x10,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fb2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	c3                   	ret    

00801fbc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fbc:	f3 0f 1e fb          	endbr32 
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc6:	68 2a 2b 80 00       	push   $0x802b2a
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	e8 78 e9 ff ff       	call   80094b <strcpy>
	return 0;
}
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <devcons_write>:
{
  801fda:	f3 0f 1e fb          	endbr32 
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	57                   	push   %edi
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fea:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fef:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ff5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff8:	73 31                	jae    80202b <devcons_write+0x51>
		m = n - tot;
  801ffa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ffd:	29 f3                	sub    %esi,%ebx
  801fff:	83 fb 7f             	cmp    $0x7f,%ebx
  802002:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802007:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	53                   	push   %ebx
  80200e:	89 f0                	mov    %esi,%eax
  802010:	03 45 0c             	add    0xc(%ebp),%eax
  802013:	50                   	push   %eax
  802014:	57                   	push   %edi
  802015:	e8 e7 ea ff ff       	call   800b01 <memmove>
		sys_cputs(buf, m);
  80201a:	83 c4 08             	add    $0x8,%esp
  80201d:	53                   	push   %ebx
  80201e:	57                   	push   %edi
  80201f:	e8 99 ec ff ff       	call   800cbd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802024:	01 de                	add    %ebx,%esi
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	eb ca                	jmp    801ff5 <devcons_write+0x1b>
}
  80202b:	89 f0                	mov    %esi,%eax
  80202d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5f                   	pop    %edi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    

00802035 <devcons_read>:
{
  802035:	f3 0f 1e fb          	endbr32 
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 08             	sub    $0x8,%esp
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802044:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802048:	74 21                	je     80206b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80204a:	e8 90 ec ff ff       	call   800cdf <sys_cgetc>
  80204f:	85 c0                	test   %eax,%eax
  802051:	75 07                	jne    80205a <devcons_read+0x25>
		sys_yield();
  802053:	e8 12 ed ff ff       	call   800d6a <sys_yield>
  802058:	eb f0                	jmp    80204a <devcons_read+0x15>
	if (c < 0)
  80205a:	78 0f                	js     80206b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80205c:	83 f8 04             	cmp    $0x4,%eax
  80205f:	74 0c                	je     80206d <devcons_read+0x38>
	*(char*)vbuf = c;
  802061:	8b 55 0c             	mov    0xc(%ebp),%edx
  802064:	88 02                	mov    %al,(%edx)
	return 1;
  802066:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    
		return 0;
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	eb f7                	jmp    80206b <devcons_read+0x36>

00802074 <cputchar>:
{
  802074:	f3 0f 1e fb          	endbr32 
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802084:	6a 01                	push   $0x1
  802086:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802089:	50                   	push   %eax
  80208a:	e8 2e ec ff ff       	call   800cbd <sys_cputs>
}
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <getchar>:
{
  802094:	f3 0f 1e fb          	endbr32 
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80209e:	6a 01                	push   $0x1
  8020a0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a3:	50                   	push   %eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	e8 1f f6 ff ff       	call   8016ca <read>
	if (r < 0)
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 06                	js     8020b8 <getchar+0x24>
	if (r < 1)
  8020b2:	74 06                	je     8020ba <getchar+0x26>
	return c;
  8020b4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    
		return -E_EOF;
  8020ba:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020bf:	eb f7                	jmp    8020b8 <getchar+0x24>

008020c1 <iscons>:
{
  8020c1:	f3 0f 1e fb          	endbr32 
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ce:	50                   	push   %eax
  8020cf:	ff 75 08             	pushl  0x8(%ebp)
  8020d2:	e8 70 f3 ff ff       	call   801447 <fd_lookup>
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 11                	js     8020ef <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020e7:	39 10                	cmp    %edx,(%eax)
  8020e9:	0f 94 c0             	sete   %al
  8020ec:	0f b6 c0             	movzbl %al,%eax
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <opencons>:
{
  8020f1:	f3 0f 1e fb          	endbr32 
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fe:	50                   	push   %eax
  8020ff:	e8 ed f2 ff ff       	call   8013f1 <fd_alloc>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	85 c0                	test   %eax,%eax
  802109:	78 3a                	js     802145 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	68 07 04 00 00       	push   $0x407
  802113:	ff 75 f4             	pushl  -0xc(%ebp)
  802116:	6a 00                	push   $0x0
  802118:	e8 70 ec ff ff       	call   800d8d <sys_page_alloc>
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	78 21                	js     802145 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80212d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	50                   	push   %eax
  80213d:	e8 80 f2 ff ff       	call   8013c2 <fd2num>
  802142:	83 c4 10             	add    $0x10,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802147:	f3 0f 1e fb          	endbr32 
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	53                   	push   %ebx
  80214f:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802152:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802159:	74 0d                	je     802168 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802166:	c9                   	leave  
  802167:	c3                   	ret    
		envid_t envid=sys_getenvid();
  802168:	e8 da eb ff ff       	call   800d47 <sys_getenvid>
  80216d:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	6a 07                	push   $0x7
  802174:	68 00 f0 bf ee       	push   $0xeebff000
  802179:	50                   	push   %eax
  80217a:	e8 0e ec ff ff       	call   800d8d <sys_page_alloc>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	85 c0                	test   %eax,%eax
  802184:	78 29                	js     8021af <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802186:	83 ec 08             	sub    $0x8,%esp
  802189:	68 c3 21 80 00       	push   $0x8021c3
  80218e:	53                   	push   %ebx
  80218f:	e8 58 ed ff ff       	call   800eec <sys_env_set_pgfault_upcall>
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	85 c0                	test   %eax,%eax
  802199:	79 c0                	jns    80215b <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	68 64 2b 80 00       	push   $0x802b64
  8021a3:	6a 24                	push   $0x24
  8021a5:	68 9b 2b 80 00       	push   $0x802b9b
  8021aa:	e8 ab e0 ff ff       	call   80025a <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 38 2b 80 00       	push   $0x802b38
  8021b7:	6a 22                	push   $0x22
  8021b9:	68 9b 2b 80 00       	push   $0x802b9b
  8021be:	e8 97 e0 ff ff       	call   80025a <_panic>

008021c3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8021c3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8021c4:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8021c9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8021cb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8021ce:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8021d1:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8021d5:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8021da:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8021de:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8021e0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8021e1:	83 c4 04             	add    $0x4,%esp
	popfl
  8021e4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021e5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8021e6:	c3                   	ret    
  8021e7:	66 90                	xchg   %ax,%ax
  8021e9:	66 90                	xchg   %ax,%ax
  8021eb:	66 90                	xchg   %ax,%ax
  8021ed:	66 90                	xchg   %ax,%ax
  8021ef:	90                   	nop

008021f0 <__udivdi3>:
  8021f0:	f3 0f 1e fb          	endbr32 
  8021f4:	55                   	push   %ebp
  8021f5:	57                   	push   %edi
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 1c             	sub    $0x1c,%esp
  8021fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802203:	8b 74 24 34          	mov    0x34(%esp),%esi
  802207:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80220b:	85 d2                	test   %edx,%edx
  80220d:	75 19                	jne    802228 <__udivdi3+0x38>
  80220f:	39 f3                	cmp    %esi,%ebx
  802211:	76 4d                	jbe    802260 <__udivdi3+0x70>
  802213:	31 ff                	xor    %edi,%edi
  802215:	89 e8                	mov    %ebp,%eax
  802217:	89 f2                	mov    %esi,%edx
  802219:	f7 f3                	div    %ebx
  80221b:	89 fa                	mov    %edi,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	39 f2                	cmp    %esi,%edx
  80222a:	76 14                	jbe    802240 <__udivdi3+0x50>
  80222c:	31 ff                	xor    %edi,%edi
  80222e:	31 c0                	xor    %eax,%eax
  802230:	89 fa                	mov    %edi,%edx
  802232:	83 c4 1c             	add    $0x1c,%esp
  802235:	5b                   	pop    %ebx
  802236:	5e                   	pop    %esi
  802237:	5f                   	pop    %edi
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    
  80223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802240:	0f bd fa             	bsr    %edx,%edi
  802243:	83 f7 1f             	xor    $0x1f,%edi
  802246:	75 48                	jne    802290 <__udivdi3+0xa0>
  802248:	39 f2                	cmp    %esi,%edx
  80224a:	72 06                	jb     802252 <__udivdi3+0x62>
  80224c:	31 c0                	xor    %eax,%eax
  80224e:	39 eb                	cmp    %ebp,%ebx
  802250:	77 de                	ja     802230 <__udivdi3+0x40>
  802252:	b8 01 00 00 00       	mov    $0x1,%eax
  802257:	eb d7                	jmp    802230 <__udivdi3+0x40>
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	89 d9                	mov    %ebx,%ecx
  802262:	85 db                	test   %ebx,%ebx
  802264:	75 0b                	jne    802271 <__udivdi3+0x81>
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	f7 f3                	div    %ebx
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	31 d2                	xor    %edx,%edx
  802273:	89 f0                	mov    %esi,%eax
  802275:	f7 f1                	div    %ecx
  802277:	89 c6                	mov    %eax,%esi
  802279:	89 e8                	mov    %ebp,%eax
  80227b:	89 f7                	mov    %esi,%edi
  80227d:	f7 f1                	div    %ecx
  80227f:	89 fa                	mov    %edi,%edx
  802281:	83 c4 1c             	add    $0x1c,%esp
  802284:	5b                   	pop    %ebx
  802285:	5e                   	pop    %esi
  802286:	5f                   	pop    %edi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 f9                	mov    %edi,%ecx
  802292:	b8 20 00 00 00       	mov    $0x20,%eax
  802297:	29 f8                	sub    %edi,%eax
  802299:	d3 e2                	shl    %cl,%edx
  80229b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	89 da                	mov    %ebx,%edx
  8022a3:	d3 ea                	shr    %cl,%edx
  8022a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022a9:	09 d1                	or     %edx,%ecx
  8022ab:	89 f2                	mov    %esi,%edx
  8022ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022b1:	89 f9                	mov    %edi,%ecx
  8022b3:	d3 e3                	shl    %cl,%ebx
  8022b5:	89 c1                	mov    %eax,%ecx
  8022b7:	d3 ea                	shr    %cl,%edx
  8022b9:	89 f9                	mov    %edi,%ecx
  8022bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022bf:	89 eb                	mov    %ebp,%ebx
  8022c1:	d3 e6                	shl    %cl,%esi
  8022c3:	89 c1                	mov    %eax,%ecx
  8022c5:	d3 eb                	shr    %cl,%ebx
  8022c7:	09 de                	or     %ebx,%esi
  8022c9:	89 f0                	mov    %esi,%eax
  8022cb:	f7 74 24 08          	divl   0x8(%esp)
  8022cf:	89 d6                	mov    %edx,%esi
  8022d1:	89 c3                	mov    %eax,%ebx
  8022d3:	f7 64 24 0c          	mull   0xc(%esp)
  8022d7:	39 d6                	cmp    %edx,%esi
  8022d9:	72 15                	jb     8022f0 <__udivdi3+0x100>
  8022db:	89 f9                	mov    %edi,%ecx
  8022dd:	d3 e5                	shl    %cl,%ebp
  8022df:	39 c5                	cmp    %eax,%ebp
  8022e1:	73 04                	jae    8022e7 <__udivdi3+0xf7>
  8022e3:	39 d6                	cmp    %edx,%esi
  8022e5:	74 09                	je     8022f0 <__udivdi3+0x100>
  8022e7:	89 d8                	mov    %ebx,%eax
  8022e9:	31 ff                	xor    %edi,%edi
  8022eb:	e9 40 ff ff ff       	jmp    802230 <__udivdi3+0x40>
  8022f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022f3:	31 ff                	xor    %edi,%edi
  8022f5:	e9 36 ff ff ff       	jmp    802230 <__udivdi3+0x40>
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__umoddi3>:
  802300:	f3 0f 1e fb          	endbr32 
  802304:	55                   	push   %ebp
  802305:	57                   	push   %edi
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	83 ec 1c             	sub    $0x1c,%esp
  80230b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80230f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802313:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80231b:	85 c0                	test   %eax,%eax
  80231d:	75 19                	jne    802338 <__umoddi3+0x38>
  80231f:	39 df                	cmp    %ebx,%edi
  802321:	76 5d                	jbe    802380 <__umoddi3+0x80>
  802323:	89 f0                	mov    %esi,%eax
  802325:	89 da                	mov    %ebx,%edx
  802327:	f7 f7                	div    %edi
  802329:	89 d0                	mov    %edx,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	83 c4 1c             	add    $0x1c,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	89 f2                	mov    %esi,%edx
  80233a:	39 d8                	cmp    %ebx,%eax
  80233c:	76 12                	jbe    802350 <__umoddi3+0x50>
  80233e:	89 f0                	mov    %esi,%eax
  802340:	89 da                	mov    %ebx,%edx
  802342:	83 c4 1c             	add    $0x1c,%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    
  80234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802350:	0f bd e8             	bsr    %eax,%ebp
  802353:	83 f5 1f             	xor    $0x1f,%ebp
  802356:	75 50                	jne    8023a8 <__umoddi3+0xa8>
  802358:	39 d8                	cmp    %ebx,%eax
  80235a:	0f 82 e0 00 00 00    	jb     802440 <__umoddi3+0x140>
  802360:	89 d9                	mov    %ebx,%ecx
  802362:	39 f7                	cmp    %esi,%edi
  802364:	0f 86 d6 00 00 00    	jbe    802440 <__umoddi3+0x140>
  80236a:	89 d0                	mov    %edx,%eax
  80236c:	89 ca                	mov    %ecx,%edx
  80236e:	83 c4 1c             	add    $0x1c,%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5f                   	pop    %edi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
  802376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	89 fd                	mov    %edi,%ebp
  802382:	85 ff                	test   %edi,%edi
  802384:	75 0b                	jne    802391 <__umoddi3+0x91>
  802386:	b8 01 00 00 00       	mov    $0x1,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	f7 f7                	div    %edi
  80238f:	89 c5                	mov    %eax,%ebp
  802391:	89 d8                	mov    %ebx,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f5                	div    %ebp
  802397:	89 f0                	mov    %esi,%eax
  802399:	f7 f5                	div    %ebp
  80239b:	89 d0                	mov    %edx,%eax
  80239d:	31 d2                	xor    %edx,%edx
  80239f:	eb 8c                	jmp    80232d <__umoddi3+0x2d>
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 e9                	mov    %ebp,%ecx
  8023aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8023af:	29 ea                	sub    %ebp,%edx
  8023b1:	d3 e0                	shl    %cl,%eax
  8023b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b7:	89 d1                	mov    %edx,%ecx
  8023b9:	89 f8                	mov    %edi,%eax
  8023bb:	d3 e8                	shr    %cl,%eax
  8023bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023c9:	09 c1                	or     %eax,%ecx
  8023cb:	89 d8                	mov    %ebx,%eax
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 e9                	mov    %ebp,%ecx
  8023d3:	d3 e7                	shl    %cl,%edi
  8023d5:	89 d1                	mov    %edx,%ecx
  8023d7:	d3 e8                	shr    %cl,%eax
  8023d9:	89 e9                	mov    %ebp,%ecx
  8023db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023df:	d3 e3                	shl    %cl,%ebx
  8023e1:	89 c7                	mov    %eax,%edi
  8023e3:	89 d1                	mov    %edx,%ecx
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 fa                	mov    %edi,%edx
  8023ed:	d3 e6                	shl    %cl,%esi
  8023ef:	09 d8                	or     %ebx,%eax
  8023f1:	f7 74 24 08          	divl   0x8(%esp)
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	89 f3                	mov    %esi,%ebx
  8023f9:	f7 64 24 0c          	mull   0xc(%esp)
  8023fd:	89 c6                	mov    %eax,%esi
  8023ff:	89 d7                	mov    %edx,%edi
  802401:	39 d1                	cmp    %edx,%ecx
  802403:	72 06                	jb     80240b <__umoddi3+0x10b>
  802405:	75 10                	jne    802417 <__umoddi3+0x117>
  802407:	39 c3                	cmp    %eax,%ebx
  802409:	73 0c                	jae    802417 <__umoddi3+0x117>
  80240b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80240f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802413:	89 d7                	mov    %edx,%edi
  802415:	89 c6                	mov    %eax,%esi
  802417:	89 ca                	mov    %ecx,%edx
  802419:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80241e:	29 f3                	sub    %esi,%ebx
  802420:	19 fa                	sbb    %edi,%edx
  802422:	89 d0                	mov    %edx,%eax
  802424:	d3 e0                	shl    %cl,%eax
  802426:	89 e9                	mov    %ebp,%ecx
  802428:	d3 eb                	shr    %cl,%ebx
  80242a:	d3 ea                	shr    %cl,%edx
  80242c:	09 d8                	or     %ebx,%eax
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	29 fe                	sub    %edi,%esi
  802442:	19 c3                	sbb    %eax,%ebx
  802444:	89 f2                	mov    %esi,%edx
  802446:	89 d9                	mov    %ebx,%ecx
  802448:	e9 1d ff ff ff       	jmp    80236a <__umoddi3+0x6a>
