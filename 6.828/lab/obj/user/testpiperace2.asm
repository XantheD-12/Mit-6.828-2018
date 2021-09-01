
obj/user/testpiperace2.debug：     文件格式 elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
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
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800040:	68 40 24 80 00       	push   $0x802440
  800045:	e8 d9 02 00 00       	call   800323 <cprintf>
	if ((r = pipe(p)) < 0)
  80004a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004d:	89 04 24             	mov    %eax,(%esp)
  800050:	e8 76 1c 00 00       	call   801ccb <pipe>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	85 c0                	test   %eax,%eax
  80005a:	78 5b                	js     8000b7 <umain+0x84>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  80005c:	e8 02 10 00 00       	call   801063 <fork>
  800061:	89 c7                	mov    %eax,%edi
  800063:	85 c0                	test   %eax,%eax
  800065:	78 62                	js     8000c9 <umain+0x96>
		panic("fork: %e", r);
	if (r == 0) {
  800067:	74 72                	je     8000db <umain+0xa8>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800069:	89 fb                	mov    %edi,%ebx
  80006b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  800071:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800074:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80007a:	8b 43 54             	mov    0x54(%ebx),%eax
  80007d:	83 f8 02             	cmp    $0x2,%eax
  800080:	0f 85 d1 00 00 00    	jne    800157 <umain+0x124>
		if (pipeisclosed(p[0]) != 0) {
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	ff 75 e0             	pushl  -0x20(%ebp)
  80008c:	e8 88 1d 00 00       	call   801e19 <pipeisclosed>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	74 e2                	je     80007a <umain+0x47>
			cprintf("\nRACE: pipe appears closed\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 b9 24 80 00       	push   $0x8024b9
  8000a0:	e8 7e 02 00 00       	call   800323 <cprintf>
			sys_env_destroy(r);
  8000a5:	89 3c 24             	mov    %edi,(%esp)
  8000a8:	e8 37 0c 00 00       	call   800ce4 <sys_env_destroy>
			exit();
  8000ad:	e8 6c 01 00 00       	call   80021e <exit>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	eb c3                	jmp    80007a <umain+0x47>
		panic("pipe: %e", r);
  8000b7:	50                   	push   %eax
  8000b8:	68 8e 24 80 00       	push   $0x80248e
  8000bd:	6a 0d                	push   $0xd
  8000bf:	68 97 24 80 00       	push   $0x802497
  8000c4:	e8 73 01 00 00       	call   80023c <_panic>
		panic("fork: %e", r);
  8000c9:	50                   	push   %eax
  8000ca:	68 ac 24 80 00       	push   $0x8024ac
  8000cf:	6a 0f                	push   $0xf
  8000d1:	68 97 24 80 00       	push   $0x802497
  8000d6:	e8 61 01 00 00       	call   80023c <_panic>
		close(p[1]);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e1:	e8 78 13 00 00       	call   80145e <close>
  8000e6:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e9:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000eb:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000f0:	eb 42                	jmp    800134 <umain+0x101>
				cprintf("%d.", i);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	53                   	push   %ebx
  8000f6:	68 b5 24 80 00       	push   $0x8024b5
  8000fb:	e8 23 02 00 00       	call   800323 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	6a 0a                	push   $0xa
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	e8 a8 13 00 00       	call   8014b8 <dup>
			sys_yield();
  800110:	e8 37 0c 00 00       	call   800d4c <sys_yield>
			close(10);
  800115:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80011c:	e8 3d 13 00 00       	call   80145e <close>
			sys_yield();
  800121:	e8 26 0c 00 00       	call   800d4c <sys_yield>
		for (i = 0; i < 200; i++) {
  800126:	83 c3 01             	add    $0x1,%ebx
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800132:	74 19                	je     80014d <umain+0x11a>
			if (i % 10 == 0)
  800134:	89 d8                	mov    %ebx,%eax
  800136:	f7 ee                	imul   %esi
  800138:	c1 fa 02             	sar    $0x2,%edx
  80013b:	89 d8                	mov    %ebx,%eax
  80013d:	c1 f8 1f             	sar    $0x1f,%eax
  800140:	29 c2                	sub    %eax,%edx
  800142:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800145:	01 c0                	add    %eax,%eax
  800147:	39 c3                	cmp    %eax,%ebx
  800149:	75 b8                	jne    800103 <umain+0xd0>
  80014b:	eb a5                	jmp    8000f2 <umain+0xbf>
		exit();
  80014d:	e8 cc 00 00 00       	call   80021e <exit>
  800152:	e9 12 ff ff ff       	jmp    800069 <umain+0x36>
		}
	cprintf("child done with loop\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 d5 24 80 00       	push   $0x8024d5
  80015f:	e8 bf 01 00 00       	call   800323 <cprintf>
	if (pipeisclosed(p[0]))
  800164:	83 c4 04             	add    $0x4,%esp
  800167:	ff 75 e0             	pushl  -0x20(%ebp)
  80016a:	e8 aa 1c 00 00       	call   801e19 <pipeisclosed>
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	85 c0                	test   %eax,%eax
  800174:	75 38                	jne    8001ae <umain+0x17b>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	ff 75 e0             	pushl  -0x20(%ebp)
  800180:	e8 a0 11 00 00       	call   801325 <fd_lookup>
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	85 c0                	test   %eax,%eax
  80018a:	78 36                	js     8001c2 <umain+0x18f>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	ff 75 dc             	pushl  -0x24(%ebp)
  800192:	e8 1d 11 00 00       	call   8012b4 <fd2data>
	cprintf("race didn't happen\n");
  800197:	c7 04 24 03 25 80 00 	movl   $0x802503,(%esp)
  80019e:	e8 80 01 00 00       	call   800323 <cprintf>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a9:	5b                   	pop    %ebx
  8001aa:	5e                   	pop    %esi
  8001ab:	5f                   	pop    %edi
  8001ac:	5d                   	pop    %ebp
  8001ad:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 64 24 80 00       	push   $0x802464
  8001b6:	6a 40                	push   $0x40
  8001b8:	68 97 24 80 00       	push   $0x802497
  8001bd:	e8 7a 00 00 00       	call   80023c <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c2:	50                   	push   %eax
  8001c3:	68 eb 24 80 00       	push   $0x8024eb
  8001c8:	6a 42                	push   $0x42
  8001ca:	68 97 24 80 00       	push   $0x802497
  8001cf:	e8 68 00 00 00       	call   80023c <_panic>

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	f3 0f 1e fb          	endbr32 
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e3:	e8 41 0b 00 00       	call   800d29 <sys_getenvid>
  8001e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ed:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f5:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	7e 07                	jle    800205 <libmain+0x31>
		binaryname = argv[0];
  8001fe:	8b 06                	mov    (%esi),%eax
  800200:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	e8 24 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020f:	e8 0a 00 00 00       	call   80021e <exit>
}
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021e:	f3 0f 1e fb          	endbr32 
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800228:	e8 62 12 00 00       	call   80148f <close_all>
	sys_env_destroy(0);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 00                	push   $0x0
  800232:	e8 ad 0a 00 00       	call   800ce4 <sys_env_destroy>
}
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800245:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800248:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80024e:	e8 d6 0a 00 00       	call   800d29 <sys_getenvid>
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	56                   	push   %esi
  80025d:	50                   	push   %eax
  80025e:	68 24 25 80 00       	push   $0x802524
  800263:	e8 bb 00 00 00       	call   800323 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800268:	83 c4 18             	add    $0x18,%esp
  80026b:	53                   	push   %ebx
  80026c:	ff 75 10             	pushl  0x10(%ebp)
  80026f:	e8 5a 00 00 00       	call   8002ce <vcprintf>
	cprintf("\n");
  800274:	c7 04 24 c3 2a 80 00 	movl   $0x802ac3,(%esp)
  80027b:	e8 a3 00 00 00       	call   800323 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800283:	cc                   	int3   
  800284:	eb fd                	jmp    800283 <_panic+0x47>

00800286 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800286:	f3 0f 1e fb          	endbr32 
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	53                   	push   %ebx
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800294:	8b 13                	mov    (%ebx),%edx
  800296:	8d 42 01             	lea    0x1(%edx),%eax
  800299:	89 03                	mov    %eax,(%ebx)
  80029b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a7:	74 09                	je     8002b2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	68 ff 00 00 00       	push   $0xff
  8002ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8002bd:	50                   	push   %eax
  8002be:	e8 dc 09 00 00       	call   800c9f <sys_cputs>
		b->idx = 0;
  8002c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	eb db                	jmp    8002a9 <putch+0x23>

008002ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ce:	f3 0f 1e fb          	endbr32 
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e2:	00 00 00 
	b.cnt = 0;
  8002e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fb:	50                   	push   %eax
  8002fc:	68 86 02 80 00       	push   $0x800286
  800301:	e8 20 01 00 00       	call   800426 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800306:	83 c4 08             	add    $0x8,%esp
  800309:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80030f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	e8 84 09 00 00       	call   800c9f <sys_cputs>

	return b.cnt;
}
  80031b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800330:	50                   	push   %eax
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	e8 95 ff ff ff       	call   8002ce <vcprintf>
	va_end(ap);

	return cnt;
}
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	57                   	push   %edi
  80033f:	56                   	push   %esi
  800340:	53                   	push   %ebx
  800341:	83 ec 1c             	sub    $0x1c,%esp
  800344:	89 c7                	mov    %eax,%edi
  800346:	89 d6                	mov    %edx,%esi
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034e:	89 d1                	mov    %edx,%ecx
  800350:	89 c2                	mov    %eax,%edx
  800352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800355:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800361:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80036d:	72 3e                	jb     8003ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	ff 75 18             	pushl  0x18(%ebp)
  800375:	83 eb 01             	sub    $0x1,%ebx
  800378:	53                   	push   %ebx
  800379:	50                   	push   %eax
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800380:	ff 75 e0             	pushl  -0x20(%ebp)
  800383:	ff 75 dc             	pushl  -0x24(%ebp)
  800386:	ff 75 d8             	pushl  -0x28(%ebp)
  800389:	e8 42 1e 00 00       	call   8021d0 <__udivdi3>
  80038e:	83 c4 18             	add    $0x18,%esp
  800391:	52                   	push   %edx
  800392:	50                   	push   %eax
  800393:	89 f2                	mov    %esi,%edx
  800395:	89 f8                	mov    %edi,%eax
  800397:	e8 9f ff ff ff       	call   80033b <printnum>
  80039c:	83 c4 20             	add    $0x20,%esp
  80039f:	eb 13                	jmp    8003b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	56                   	push   %esi
  8003a5:	ff 75 18             	pushl  0x18(%ebp)
  8003a8:	ff d7                	call   *%edi
  8003aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003ad:	83 eb 01             	sub    $0x1,%ebx
  8003b0:	85 db                	test   %ebx,%ebx
  8003b2:	7f ed                	jg     8003a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	56                   	push   %esi
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003be:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c7:	e8 14 1f 00 00       	call   8022e0 <__umoddi3>
  8003cc:	83 c4 14             	add    $0x14,%esp
  8003cf:	0f be 80 47 25 80 00 	movsbl 0x802547(%eax),%eax
  8003d6:	50                   	push   %eax
  8003d7:	ff d7                	call   *%edi
}
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003df:	5b                   	pop    %ebx
  8003e0:	5e                   	pop    %esi
  8003e1:	5f                   	pop    %edi
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e4:	f3 0f 1e fb          	endbr32 
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f7:	73 0a                	jae    800403 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fc:	89 08                	mov    %ecx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	88 02                	mov    %al,(%edx)
}
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <printfmt>:
{
  800405:	f3 0f 1e fb          	endbr32 
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80040f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800412:	50                   	push   %eax
  800413:	ff 75 10             	pushl  0x10(%ebp)
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	e8 05 00 00 00       	call   800426 <vprintfmt>
}
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <vprintfmt>:
{
  800426:	f3 0f 1e fb          	endbr32 
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	53                   	push   %ebx
  800430:	83 ec 3c             	sub    $0x3c,%esp
  800433:	8b 75 08             	mov    0x8(%ebp),%esi
  800436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800439:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043c:	e9 8e 03 00 00       	jmp    8007cf <vprintfmt+0x3a9>
		padc = ' ';
  800441:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800445:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80044c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800453:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80045a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045f:	8d 47 01             	lea    0x1(%edi),%eax
  800462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800465:	0f b6 17             	movzbl (%edi),%edx
  800468:	8d 42 dd             	lea    -0x23(%edx),%eax
  80046b:	3c 55                	cmp    $0x55,%al
  80046d:	0f 87 df 03 00 00    	ja     800852 <vprintfmt+0x42c>
  800473:	0f b6 c0             	movzbl %al,%eax
  800476:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
  80047d:	00 
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800481:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800485:	eb d8                	jmp    80045f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80048e:	eb cf                	jmp    80045f <vprintfmt+0x39>
  800490:	0f b6 d2             	movzbl %dl,%edx
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ab:	83 f9 09             	cmp    $0x9,%ecx
  8004ae:	77 55                	ja     800505 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b3:	eb e9                	jmp    80049e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8d 40 04             	lea    0x4(%eax),%eax
  8004c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cd:	79 90                	jns    80045f <vprintfmt+0x39>
				width = precision, precision = -1;
  8004cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004dc:	eb 81                	jmp    80045f <vprintfmt+0x39>
  8004de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e8:	0f 49 d0             	cmovns %eax,%edx
  8004eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f1:	e9 69 ff ff ff       	jmp    80045f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800500:	e9 5a ff ff ff       	jmp    80045f <vprintfmt+0x39>
  800505:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800508:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050b:	eb bc                	jmp    8004c9 <vprintfmt+0xa3>
			lflag++;
  80050d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800513:	e9 47 ff ff ff       	jmp    80045f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 78 04             	lea    0x4(%eax),%edi
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	ff 30                	pushl  (%eax)
  800524:	ff d6                	call   *%esi
			break;
  800526:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800529:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80052c:	e9 9b 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 78 04             	lea    0x4(%eax),%edi
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	31 d0                	xor    %edx,%eax
  80053c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053e:	83 f8 0f             	cmp    $0xf,%eax
  800541:	7f 23                	jg     800566 <vprintfmt+0x140>
  800543:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 18                	je     800566 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80054e:	52                   	push   %edx
  80054f:	68 91 2a 80 00       	push   $0x802a91
  800554:	53                   	push   %ebx
  800555:	56                   	push   %esi
  800556:	e8 aa fe ff ff       	call   800405 <printfmt>
  80055b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800561:	e9 66 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800566:	50                   	push   %eax
  800567:	68 5f 25 80 00       	push   $0x80255f
  80056c:	53                   	push   %ebx
  80056d:	56                   	push   %esi
  80056e:	e8 92 fe ff ff       	call   800405 <printfmt>
  800573:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800576:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800579:	e9 4e 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	83 c0 04             	add    $0x4,%eax
  800584:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80058c:	85 d2                	test   %edx,%edx
  80058e:	b8 58 25 80 00       	mov    $0x802558,%eax
  800593:	0f 45 c2             	cmovne %edx,%eax
  800596:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800599:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059d:	7e 06                	jle    8005a5 <vprintfmt+0x17f>
  80059f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005a3:	75 0d                	jne    8005b2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a8:	89 c7                	mov    %eax,%edi
  8005aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b0:	eb 55                	jmp    800607 <vprintfmt+0x1e1>
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b8:	ff 75 cc             	pushl  -0x34(%ebp)
  8005bb:	e8 46 03 00 00       	call   800906 <strnlen>
  8005c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c3:	29 c2                	sub    %eax,%edx
  8005c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	85 ff                	test   %edi,%edi
  8005d6:	7e 11                	jle    8005e9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e1:	83 ef 01             	sub    $0x1,%edi
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	eb eb                	jmp    8005d4 <vprintfmt+0x1ae>
  8005e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005ec:	85 d2                	test   %edx,%edx
  8005ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f3:	0f 49 c2             	cmovns %edx,%eax
  8005f6:	29 c2                	sub    %eax,%edx
  8005f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005fb:	eb a8                	jmp    8005a5 <vprintfmt+0x17f>
					putch(ch, putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	52                   	push   %edx
  800602:	ff d6                	call   *%esi
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060c:	83 c7 01             	add    $0x1,%edi
  80060f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800613:	0f be d0             	movsbl %al,%edx
  800616:	85 d2                	test   %edx,%edx
  800618:	74 4b                	je     800665 <vprintfmt+0x23f>
  80061a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061e:	78 06                	js     800626 <vprintfmt+0x200>
  800620:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800624:	78 1e                	js     800644 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800626:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80062a:	74 d1                	je     8005fd <vprintfmt+0x1d7>
  80062c:	0f be c0             	movsbl %al,%eax
  80062f:	83 e8 20             	sub    $0x20,%eax
  800632:	83 f8 5e             	cmp    $0x5e,%eax
  800635:	76 c6                	jbe    8005fd <vprintfmt+0x1d7>
					putch('?', putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	6a 3f                	push   $0x3f
  80063d:	ff d6                	call   *%esi
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	eb c3                	jmp    800607 <vprintfmt+0x1e1>
  800644:	89 cf                	mov    %ecx,%edi
  800646:	eb 0e                	jmp    800656 <vprintfmt+0x230>
				putch(' ', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	6a 20                	push   $0x20
  80064e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800650:	83 ef 01             	sub    $0x1,%edi
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	85 ff                	test   %edi,%edi
  800658:	7f ee                	jg     800648 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	e9 67 01 00 00       	jmp    8007cc <vprintfmt+0x3a6>
  800665:	89 cf                	mov    %ecx,%edi
  800667:	eb ed                	jmp    800656 <vprintfmt+0x230>
	if (lflag >= 2)
  800669:	83 f9 01             	cmp    $0x1,%ecx
  80066c:	7f 1b                	jg     800689 <vprintfmt+0x263>
	else if (lflag)
  80066e:	85 c9                	test   %ecx,%ecx
  800670:	74 63                	je     8006d5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	99                   	cltd   
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
  800687:	eb 17                	jmp    8006a0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 50 04             	mov    0x4(%eax),%edx
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800694:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 08             	lea    0x8(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006ab:	85 c9                	test   %ecx,%ecx
  8006ad:	0f 89 ff 00 00 00    	jns    8007b2 <vprintfmt+0x38c>
				putch('-', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 2d                	push   $0x2d
  8006b9:	ff d6                	call   *%esi
				num = -(long long) num;
  8006bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006be:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006c1:	f7 da                	neg    %edx
  8006c3:	83 d1 00             	adc    $0x0,%ecx
  8006c6:	f7 d9                	neg    %ecx
  8006c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d0:	e9 dd 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	99                   	cltd   
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	eb b4                	jmp    8006a0 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006ec:	83 f9 01             	cmp    $0x1,%ecx
  8006ef:	7f 1e                	jg     80070f <vprintfmt+0x2e9>
	else if (lflag)
  8006f1:	85 c9                	test   %ecx,%ecx
  8006f3:	74 32                	je     800727 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 10                	mov    (%eax),%edx
  8006fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ff:	8d 40 04             	lea    0x4(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800705:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80070a:	e9 a3 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	8b 48 04             	mov    0x4(%eax),%ecx
  800717:	8d 40 08             	lea    0x8(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800722:	e9 8b 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8b 10                	mov    (%eax),%edx
  80072c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80073c:	eb 74                	jmp    8007b2 <vprintfmt+0x38c>
	if (lflag >= 2)
  80073e:	83 f9 01             	cmp    $0x1,%ecx
  800741:	7f 1b                	jg     80075e <vprintfmt+0x338>
	else if (lflag)
  800743:	85 c9                	test   %ecx,%ecx
  800745:	74 2c                	je     800773 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 10                	mov    (%eax),%edx
  80074c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800757:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80075c:	eb 54                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 10                	mov    (%eax),%edx
  800763:	8b 48 04             	mov    0x4(%eax),%ecx
  800766:	8d 40 08             	lea    0x8(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80076c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800771:	eb 3f                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
  800778:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077d:	8d 40 04             	lea    0x4(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800783:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800788:	eb 28                	jmp    8007b2 <vprintfmt+0x38c>
			putch('0', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	6a 30                	push   $0x30
  800790:	ff d6                	call   *%esi
			putch('x', putdat);
  800792:	83 c4 08             	add    $0x8,%esp
  800795:	53                   	push   %ebx
  800796:	6a 78                	push   $0x78
  800798:	ff d6                	call   *%esi
			num = (unsigned long long)
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 10                	mov    (%eax),%edx
  80079f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b9:	57                   	push   %edi
  8007ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bd:	50                   	push   %eax
  8007be:	51                   	push   %ecx
  8007bf:	52                   	push   %edx
  8007c0:	89 da                	mov    %ebx,%edx
  8007c2:	89 f0                	mov    %esi,%eax
  8007c4:	e8 72 fb ff ff       	call   80033b <printnum>
			break;
  8007c9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cf:	83 c7 01             	add    $0x1,%edi
  8007d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d6:	83 f8 25             	cmp    $0x25,%eax
  8007d9:	0f 84 62 fc ff ff    	je     800441 <vprintfmt+0x1b>
			if (ch == '\0')
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	0f 84 8b 00 00 00    	je     800872 <vprintfmt+0x44c>
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	50                   	push   %eax
  8007ec:	ff d6                	call   *%esi
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	eb dc                	jmp    8007cf <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007f3:	83 f9 01             	cmp    $0x1,%ecx
  8007f6:	7f 1b                	jg     800813 <vprintfmt+0x3ed>
	else if (lflag)
  8007f8:	85 c9                	test   %ecx,%ecx
  8007fa:	74 2c                	je     800828 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	b9 00 00 00 00       	mov    $0x0,%ecx
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800811:	eb 9f                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 10                	mov    (%eax),%edx
  800818:	8b 48 04             	mov    0x4(%eax),%ecx
  80081b:	8d 40 08             	lea    0x8(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800826:	eb 8a                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 10                	mov    (%eax),%edx
  80082d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800838:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80083d:	e9 70 ff ff ff       	jmp    8007b2 <vprintfmt+0x38c>
			putch(ch, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 25                	push   $0x25
  800848:	ff d6                	call   *%esi
			break;
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	e9 7a ff ff ff       	jmp    8007cc <vprintfmt+0x3a6>
			putch('%', putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	6a 25                	push   $0x25
  800858:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085a:	83 c4 10             	add    $0x10,%esp
  80085d:	89 f8                	mov    %edi,%eax
  80085f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800863:	74 05                	je     80086a <vprintfmt+0x444>
  800865:	83 e8 01             	sub    $0x1,%eax
  800868:	eb f5                	jmp    80085f <vprintfmt+0x439>
  80086a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086d:	e9 5a ff ff ff       	jmp    8007cc <vprintfmt+0x3a6>
}
  800872:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800875:	5b                   	pop    %ebx
  800876:	5e                   	pop    %esi
  800877:	5f                   	pop    %edi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 18             	sub    $0x18,%esp
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800891:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089b:	85 c0                	test   %eax,%eax
  80089d:	74 26                	je     8008c5 <vsnprintf+0x4b>
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	7e 22                	jle    8008c5 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a3:	ff 75 14             	pushl  0x14(%ebp)
  8008a6:	ff 75 10             	pushl  0x10(%ebp)
  8008a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	68 e4 03 80 00       	push   $0x8003e4
  8008b2:	e8 6f fb ff ff       	call   800426 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    
		return -E_INVAL;
  8008c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ca:	eb f7                	jmp    8008c3 <vsnprintf+0x49>

008008cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d9:	50                   	push   %eax
  8008da:	ff 75 10             	pushl  0x10(%ebp)
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	ff 75 08             	pushl  0x8(%ebp)
  8008e3:	e8 92 ff ff ff       	call   80087a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fd:	74 05                	je     800904 <strlen+0x1a>
		n++;
  8008ff:	83 c0 01             	add    $0x1,%eax
  800902:	eb f5                	jmp    8008f9 <strlen+0xf>
	return n;
}
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800906:	f3 0f 1e fb          	endbr32 
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800910:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
  800918:	39 d0                	cmp    %edx,%eax
  80091a:	74 0d                	je     800929 <strnlen+0x23>
  80091c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800920:	74 05                	je     800927 <strnlen+0x21>
		n++;
  800922:	83 c0 01             	add    $0x1,%eax
  800925:	eb f1                	jmp    800918 <strnlen+0x12>
  800927:	89 c2                	mov    %eax,%edx
	return n;
}
  800929:	89 d0                	mov    %edx,%eax
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092d:	f3 0f 1e fb          	endbr32 
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800938:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
  800940:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800944:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800947:	83 c0 01             	add    $0x1,%eax
  80094a:	84 d2                	test   %dl,%dl
  80094c:	75 f2                	jne    800940 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80094e:	89 c8                	mov    %ecx,%eax
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800953:	f3 0f 1e fb          	endbr32 
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 10             	sub    $0x10,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	53                   	push   %ebx
  800962:	e8 83 ff ff ff       	call   8008ea <strlen>
  800967:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	01 d8                	add    %ebx,%eax
  80096f:	50                   	push   %eax
  800970:	e8 b8 ff ff ff       	call   80092d <strcpy>
	return dst;
}
  800975:	89 d8                	mov    %ebx,%eax
  800977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 75 08             	mov    0x8(%ebp),%esi
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098b:	89 f3                	mov    %esi,%ebx
  80098d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800990:	89 f0                	mov    %esi,%eax
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 11                	je     8009a7 <strncpy+0x2b>
		*dst++ = *src;
  800996:	83 c0 01             	add    $0x1,%eax
  800999:	0f b6 0a             	movzbl (%edx),%ecx
  80099c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 f9 01             	cmp    $0x1,%cl
  8009a2:	83 da ff             	sbb    $0xffffffff,%edx
  8009a5:	eb eb                	jmp    800992 <strncpy+0x16>
	}
	return ret;
}
  8009a7:	89 f0                	mov    %esi,%eax
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ad:	f3 0f 1e fb          	endbr32 
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c1:	85 d2                	test   %edx,%edx
  8009c3:	74 21                	je     8009e6 <strlcpy+0x39>
  8009c5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009cb:	39 c2                	cmp    %eax,%edx
  8009cd:	74 14                	je     8009e3 <strlcpy+0x36>
  8009cf:	0f b6 19             	movzbl (%ecx),%ebx
  8009d2:	84 db                	test   %bl,%bl
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x34>
			*dst++ = *src++;
  8009d6:	83 c1 01             	add    $0x1,%ecx
  8009d9:	83 c2 01             	add    $0x1,%edx
  8009dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009df:	eb ea                	jmp    8009cb <strlcpy+0x1e>
  8009e1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	f3 0f 1e fb          	endbr32 
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	84 c0                	test   %al,%al
  8009fe:	74 0c                	je     800a0c <strcmp+0x20>
  800a00:	3a 02                	cmp    (%edx),%al
  800a02:	75 08                	jne    800a0c <strcmp+0x20>
		p++, q++;
  800a04:	83 c1 01             	add    $0x1,%ecx
  800a07:	83 c2 01             	add    $0x1,%edx
  800a0a:	eb ed                	jmp    8009f9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 c0             	movzbl %al,%eax
  800a0f:	0f b6 12             	movzbl (%edx),%edx
  800a12:	29 d0                	sub    %edx,%eax
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a16:	f3 0f 1e fb          	endbr32 
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	53                   	push   %ebx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	89 c3                	mov    %eax,%ebx
  800a26:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a29:	eb 06                	jmp    800a31 <strncmp+0x1b>
		n--, p++, q++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a31:	39 d8                	cmp    %ebx,%eax
  800a33:	74 16                	je     800a4b <strncmp+0x35>
  800a35:	0f b6 08             	movzbl (%eax),%ecx
  800a38:	84 c9                	test   %cl,%cl
  800a3a:	74 04                	je     800a40 <strncmp+0x2a>
  800a3c:	3a 0a                	cmp    (%edx),%cl
  800a3e:	74 eb                	je     800a2b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a40:	0f b6 00             	movzbl (%eax),%eax
  800a43:	0f b6 12             	movzbl (%edx),%edx
  800a46:	29 d0                	sub    %edx,%eax
}
  800a48:	5b                   	pop    %ebx
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    
		return 0;
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	eb f6                	jmp    800a48 <strncmp+0x32>

00800a52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a52:	f3 0f 1e fb          	endbr32 
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	0f b6 10             	movzbl (%eax),%edx
  800a63:	84 d2                	test   %dl,%dl
  800a65:	74 09                	je     800a70 <strchr+0x1e>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strchr+0x23>
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	eb f0                	jmp    800a60 <strchr+0xe>
			return (char *) s;
	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a77:	f3 0f 1e fb          	endbr32 
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a88:	38 ca                	cmp    %cl,%dl
  800a8a:	74 09                	je     800a95 <strfind+0x1e>
  800a8c:	84 d2                	test   %dl,%dl
  800a8e:	74 05                	je     800a95 <strfind+0x1e>
	for (; *s; s++)
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	eb f0                	jmp    800a85 <strfind+0xe>
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	f3 0f 1e fb          	endbr32 
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	57                   	push   %edi
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa7:	85 c9                	test   %ecx,%ecx
  800aa9:	74 31                	je     800adc <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aab:	89 f8                	mov    %edi,%eax
  800aad:	09 c8                	or     %ecx,%eax
  800aaf:	a8 03                	test   $0x3,%al
  800ab1:	75 23                	jne    800ad6 <memset+0x3f>
		c &= 0xFF;
  800ab3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab7:	89 d3                	mov    %edx,%ebx
  800ab9:	c1 e3 08             	shl    $0x8,%ebx
  800abc:	89 d0                	mov    %edx,%eax
  800abe:	c1 e0 18             	shl    $0x18,%eax
  800ac1:	89 d6                	mov    %edx,%esi
  800ac3:	c1 e6 10             	shl    $0x10,%esi
  800ac6:	09 f0                	or     %esi,%eax
  800ac8:	09 c2                	or     %eax,%edx
  800aca:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	fc                   	cld    
  800ad2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad4:	eb 06                	jmp    800adc <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	fc                   	cld    
  800ada:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae3:	f3 0f 1e fb          	endbr32 
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af5:	39 c6                	cmp    %eax,%esi
  800af7:	73 32                	jae    800b2b <memmove+0x48>
  800af9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afc:	39 c2                	cmp    %eax,%edx
  800afe:	76 2b                	jbe    800b2b <memmove+0x48>
		s += n;
		d += n;
  800b00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b03:	89 fe                	mov    %edi,%esi
  800b05:	09 ce                	or     %ecx,%esi
  800b07:	09 d6                	or     %edx,%esi
  800b09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0f:	75 0e                	jne    800b1f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 1a                	jmp    800b45 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2b:	89 c2                	mov    %eax,%edx
  800b2d:	09 ca                	or     %ecx,%edx
  800b2f:	09 f2                	or     %esi,%edx
  800b31:	f6 c2 03             	test   $0x3,%dl
  800b34:	75 0a                	jne    800b40 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3e:	eb 05                	jmp    800b45 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	fc                   	cld    
  800b43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b45:	5e                   	pop    %esi
  800b46:	5f                   	pop    %edi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b49:	f3 0f 1e fb          	endbr32 
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b53:	ff 75 10             	pushl  0x10(%ebp)
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 82 ff ff ff       	call   800ae3 <memmove>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b63:	f3 0f 1e fb          	endbr32 
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b77:	39 f0                	cmp    %esi,%eax
  800b79:	74 1c                	je     800b97 <memcmp+0x34>
		if (*s1 != *s2)
  800b7b:	0f b6 08             	movzbl (%eax),%ecx
  800b7e:	0f b6 1a             	movzbl (%edx),%ebx
  800b81:	38 d9                	cmp    %bl,%cl
  800b83:	75 08                	jne    800b8d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	eb ea                	jmp    800b77 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b8d:	0f b6 c1             	movzbl %cl,%eax
  800b90:	0f b6 db             	movzbl %bl,%ebx
  800b93:	29 d8                	sub    %ebx,%eax
  800b95:	eb 05                	jmp    800b9c <memcmp+0x39>
	}

	return 0;
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba0:	f3 0f 1e fb          	endbr32 
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb2:	39 d0                	cmp    %edx,%eax
  800bb4:	73 09                	jae    800bbf <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 05                	je     800bbf <memfind+0x1f>
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	eb f3                	jmp    800bb2 <memfind+0x12>
			break;
	return (void *) s;
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc1:	f3 0f 1e fb          	endbr32 
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
  800bcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd1:	eb 03                	jmp    800bd6 <strtol+0x15>
		s++;
  800bd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd6:	0f b6 01             	movzbl (%ecx),%eax
  800bd9:	3c 20                	cmp    $0x20,%al
  800bdb:	74 f6                	je     800bd3 <strtol+0x12>
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	74 f2                	je     800bd3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800be1:	3c 2b                	cmp    $0x2b,%al
  800be3:	74 2a                	je     800c0f <strtol+0x4e>
	int neg = 0;
  800be5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bea:	3c 2d                	cmp    $0x2d,%al
  800bec:	74 2b                	je     800c19 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf4:	75 0f                	jne    800c05 <strtol+0x44>
  800bf6:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf9:	74 28                	je     800c23 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c02:	0f 44 d8             	cmove  %eax,%ebx
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c0d:	eb 46                	jmp    800c55 <strtol+0x94>
		s++;
  800c0f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c12:	bf 00 00 00 00       	mov    $0x0,%edi
  800c17:	eb d5                	jmp    800bee <strtol+0x2d>
		s++, neg = 1;
  800c19:	83 c1 01             	add    $0x1,%ecx
  800c1c:	bf 01 00 00 00       	mov    $0x1,%edi
  800c21:	eb cb                	jmp    800bee <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c23:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c27:	74 0e                	je     800c37 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	75 d8                	jne    800c05 <strtol+0x44>
		s++, base = 8;
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c35:	eb ce                	jmp    800c05 <strtol+0x44>
		s += 2, base = 16;
  800c37:	83 c1 02             	add    $0x2,%ecx
  800c3a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c3f:	eb c4                	jmp    800c05 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c41:	0f be d2             	movsbl %dl,%edx
  800c44:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c47:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4a:	7d 3a                	jge    800c86 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c4c:	83 c1 01             	add    $0x1,%ecx
  800c4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c53:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c55:	0f b6 11             	movzbl (%ecx),%edx
  800c58:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5b:	89 f3                	mov    %esi,%ebx
  800c5d:	80 fb 09             	cmp    $0x9,%bl
  800c60:	76 df                	jbe    800c41 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c62:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	80 fb 19             	cmp    $0x19,%bl
  800c6a:	77 08                	ja     800c74 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c6c:	0f be d2             	movsbl %dl,%edx
  800c6f:	83 ea 57             	sub    $0x57,%edx
  800c72:	eb d3                	jmp    800c47 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c74:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c77:	89 f3                	mov    %esi,%ebx
  800c79:	80 fb 19             	cmp    $0x19,%bl
  800c7c:	77 08                	ja     800c86 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c7e:	0f be d2             	movsbl %dl,%edx
  800c81:	83 ea 37             	sub    $0x37,%edx
  800c84:	eb c1                	jmp    800c47 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 05                	je     800c91 <strtol+0xd0>
		*endptr = (char *) s;
  800c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	f7 da                	neg    %edx
  800c95:	85 ff                	test   %edi,%edi
  800c97:	0f 45 c2             	cmovne %edx,%eax
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	89 c3                	mov    %eax,%ebx
  800cb6:	89 c7                	mov    %eax,%edi
  800cb8:	89 c6                	mov    %eax,%esi
  800cba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce4:	f3 0f 1e fb          	endbr32 
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfe:	89 cb                	mov    %ecx,%ebx
  800d00:	89 cf                	mov    %ecx,%edi
  800d02:	89 ce                	mov    %ecx,%esi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 03                	push   $0x3
  800d18:	68 3f 28 80 00       	push   $0x80283f
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 5c 28 80 00       	push   $0x80285c
  800d24:	e8 13 f5 ff ff       	call   80023c <_panic>

00800d29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d29:	f3 0f 1e fb          	endbr32 
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d33:	ba 00 00 00 00       	mov    $0x0,%edx
  800d38:	b8 02 00 00 00       	mov    $0x2,%eax
  800d3d:	89 d1                	mov    %edx,%ecx
  800d3f:	89 d3                	mov    %edx,%ebx
  800d41:	89 d7                	mov    %edx,%edi
  800d43:	89 d6                	mov    %edx,%esi
  800d45:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_yield>:

void
sys_yield(void)
{
  800d4c:	f3 0f 1e fb          	endbr32 
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d60:	89 d1                	mov    %edx,%ecx
  800d62:	89 d3                	mov    %edx,%ebx
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	89 d6                	mov    %edx,%esi
  800d68:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6f:	f3 0f 1e fb          	endbr32 
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	be 00 00 00 00       	mov    $0x0,%esi
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d87:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8f:	89 f7                	mov    %esi,%edi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 04                	push   $0x4
  800da5:	68 3f 28 80 00       	push   $0x80283f
  800daa:	6a 23                	push   $0x23
  800dac:	68 5c 28 80 00       	push   $0x80285c
  800db1:	e8 86 f4 ff ff       	call   80023c <_panic>

00800db6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db6:	f3 0f 1e fb          	endbr32 
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 05                	push   $0x5
  800deb:	68 3f 28 80 00       	push   $0x80283f
  800df0:	6a 23                	push   $0x23
  800df2:	68 5c 28 80 00       	push   $0x80285c
  800df7:	e8 40 f4 ff ff       	call   80023c <_panic>

00800dfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfc:	f3 0f 1e fb          	endbr32 
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	b8 06 00 00 00       	mov    $0x6,%eax
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7f 08                	jg     800e2b <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	50                   	push   %eax
  800e2f:	6a 06                	push   $0x6
  800e31:	68 3f 28 80 00       	push   $0x80283f
  800e36:	6a 23                	push   $0x23
  800e38:	68 5c 28 80 00       	push   $0x80285c
  800e3d:	e8 fa f3 ff ff       	call   80023c <_panic>

00800e42 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e42:	f3 0f 1e fb          	endbr32 
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 08                	push   $0x8
  800e77:	68 3f 28 80 00       	push   $0x80283f
  800e7c:	6a 23                	push   $0x23
  800e7e:	68 5c 28 80 00       	push   $0x80285c
  800e83:	e8 b4 f3 ff ff       	call   80023c <_panic>

00800e88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e88:	f3 0f 1e fb          	endbr32 
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea5:	89 df                	mov    %ebx,%edi
  800ea7:	89 de                	mov    %ebx,%esi
  800ea9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	7f 08                	jg     800eb7 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	50                   	push   %eax
  800ebb:	6a 09                	push   $0x9
  800ebd:	68 3f 28 80 00       	push   $0x80283f
  800ec2:	6a 23                	push   $0x23
  800ec4:	68 5c 28 80 00       	push   $0x80285c
  800ec9:	e8 6e f3 ff ff       	call   80023c <_panic>

00800ece <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eeb:	89 df                	mov    %ebx,%edi
  800eed:	89 de                	mov    %ebx,%esi
  800eef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7f 08                	jg     800efd <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	50                   	push   %eax
  800f01:	6a 0a                	push   $0xa
  800f03:	68 3f 28 80 00       	push   $0x80283f
  800f08:	6a 23                	push   $0x23
  800f0a:	68 5c 28 80 00       	push   $0x80285c
  800f0f:	e8 28 f3 ff ff       	call   80023c <_panic>

00800f14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f14:	f3 0f 1e fb          	endbr32 
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
  800f2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f34:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3b:	f3 0f 1e fb          	endbr32 
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f55:	89 cb                	mov    %ecx,%ebx
  800f57:	89 cf                	mov    %ecx,%edi
  800f59:	89 ce                	mov    %ecx,%esi
  800f5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7f 08                	jg     800f69 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	50                   	push   %eax
  800f6d:	6a 0d                	push   $0xd
  800f6f:	68 3f 28 80 00       	push   $0x80283f
  800f74:	6a 23                	push   $0x23
  800f76:	68 5c 28 80 00       	push   $0x80285c
  800f7b:	e8 bc f2 ff ff       	call   80023c <_panic>

00800f80 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	56                   	push   %esi
  800f88:	53                   	push   %ebx
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f8c:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f8e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f92:	74 7f                	je     801013 <pgfault+0x93>
  800f94:	89 f0                	mov    %esi,%eax
  800f96:	c1 e8 0c             	shr    $0xc,%eax
  800f99:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa0:	f6 c4 08             	test   $0x8,%ah
  800fa3:	74 6e                	je     801013 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800fa5:	e8 7f fd ff ff       	call   800d29 <sys_getenvid>
  800faa:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800fac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800fb2:	83 ec 04             	sub    $0x4,%esp
  800fb5:	6a 07                	push   $0x7
  800fb7:	68 00 f0 7f 00       	push   $0x7ff000
  800fbc:	50                   	push   %eax
  800fbd:	e8 ad fd ff ff       	call   800d6f <sys_page_alloc>
  800fc2:	83 c4 10             	add    $0x10,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	78 5e                	js     801027 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	68 00 10 00 00       	push   $0x1000
  800fd1:	56                   	push   %esi
  800fd2:	68 00 f0 7f 00       	push   $0x7ff000
  800fd7:	e8 6d fb ff ff       	call   800b49 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800fdc:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	68 00 f0 7f 00       	push   $0x7ff000
  800fea:	53                   	push   %ebx
  800feb:	e8 c6 fd ff ff       	call   800db6 <sys_page_map>
  800ff0:	83 c4 20             	add    $0x20,%esp
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	78 44                	js     80103b <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	68 00 f0 7f 00       	push   $0x7ff000
  800fff:	53                   	push   %ebx
  801000:	e8 f7 fd ff ff       	call   800dfc <sys_page_unmap>
  801005:	83 c4 10             	add    $0x10,%esp
  801008:	85 c0                	test   %eax,%eax
  80100a:	78 43                	js     80104f <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	68 6a 28 80 00       	push   $0x80286a
  80101b:	6a 1e                	push   $0x1e
  80101d:	68 87 28 80 00       	push   $0x802887
  801022:	e8 15 f2 ff ff       	call   80023c <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  801027:	83 ec 04             	sub    $0x4,%esp
  80102a:	68 18 29 80 00       	push   $0x802918
  80102f:	6a 2b                	push   $0x2b
  801031:	68 87 28 80 00       	push   $0x802887
  801036:	e8 01 f2 ff ff       	call   80023c <_panic>
		panic("pgfault: sys_page_map Failed!");
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	68 92 28 80 00       	push   $0x802892
  801043:	6a 2f                	push   $0x2f
  801045:	68 87 28 80 00       	push   $0x802887
  80104a:	e8 ed f1 ff ff       	call   80023c <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 38 29 80 00       	push   $0x802938
  801057:	6a 32                	push   $0x32
  801059:	68 87 28 80 00       	push   $0x802887
  80105e:	e8 d9 f1 ff ff       	call   80023c <_panic>

00801063 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801063:	f3 0f 1e fb          	endbr32 
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	57                   	push   %edi
  80106b:	56                   	push   %esi
  80106c:	53                   	push   %ebx
  80106d:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801070:	68 80 0f 80 00       	push   $0x800f80
  801075:	e8 6b 0f 00 00       	call   801fe5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80107a:	b8 07 00 00 00       	mov    $0x7,%eax
  80107f:	cd 30                	int    $0x30
  801081:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801084:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 2b                	js     8010b9 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  801093:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801097:	0f 85 ba 00 00 00    	jne    801157 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  80109d:	e8 87 fc ff ff       	call   800d29 <sys_getenvid>
  8010a2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010aa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010af:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010b4:	e9 90 01 00 00       	jmp    801249 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	68 b0 28 80 00       	push   $0x8028b0
  8010c1:	6a 76                	push   $0x76
  8010c3:	68 87 28 80 00       	push   $0x802887
  8010c8:	e8 6f f1 ff ff       	call   80023c <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  8010cd:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  8010d4:	e8 50 fc ff ff       	call   800d29 <sys_getenvid>
  8010d9:	83 ec 0c             	sub    $0xc,%esp
  8010dc:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  8010e2:	56                   	push   %esi
  8010e3:	57                   	push   %edi
  8010e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8010e7:	57                   	push   %edi
  8010e8:	50                   	push   %eax
  8010e9:	e8 c8 fc ff ff       	call   800db6 <sys_page_map>
  8010ee:	83 c4 20             	add    $0x20,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	79 50                	jns    801145 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	68 c9 28 80 00       	push   $0x8028c9
  8010fd:	6a 4b                	push   $0x4b
  8010ff:	68 87 28 80 00       	push   $0x802887
  801104:	e8 33 f1 ff ff       	call   80023c <_panic>
			panic("duppage:child sys_page_map Failed!");
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	68 58 29 80 00       	push   $0x802958
  801111:	6a 50                	push   $0x50
  801113:	68 87 28 80 00       	push   $0x802887
  801118:	e8 1f f1 ff ff       	call   80023c <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  80111d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	25 07 0e 00 00       	and    $0xe07,%eax
  80112c:	50                   	push   %eax
  80112d:	57                   	push   %edi
  80112e:	ff 75 e0             	pushl  -0x20(%ebp)
  801131:	57                   	push   %edi
  801132:	ff 75 e4             	pushl  -0x1c(%ebp)
  801135:	e8 7c fc ff ff       	call   800db6 <sys_page_map>
  80113a:	83 c4 20             	add    $0x20,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	0f 88 b4 00 00 00    	js     8011f9 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801145:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80114b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801151:	0f 84 b6 00 00 00    	je     80120d <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801157:	89 d8                	mov    %ebx,%eax
  801159:	c1 e8 16             	shr    $0x16,%eax
  80115c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801163:	a8 01                	test   $0x1,%al
  801165:	74 de                	je     801145 <fork+0xe2>
  801167:	89 de                	mov    %ebx,%esi
  801169:	c1 ee 0c             	shr    $0xc,%esi
  80116c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801173:	a8 01                	test   $0x1,%al
  801175:	74 ce                	je     801145 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801177:	e8 ad fb ff ff       	call   800d29 <sys_getenvid>
  80117c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  80117f:	89 f7                	mov    %esi,%edi
  801181:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  801184:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80118b:	f6 c4 04             	test   $0x4,%ah
  80118e:	0f 85 39 ff ff ff    	jne    8010cd <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  801194:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80119b:	a9 02 08 00 00       	test   $0x802,%eax
  8011a0:	0f 84 77 ff ff ff    	je     80111d <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  8011a6:	83 ec 0c             	sub    $0xc,%esp
  8011a9:	68 05 08 00 00       	push   $0x805
  8011ae:	57                   	push   %edi
  8011af:	ff 75 e0             	pushl  -0x20(%ebp)
  8011b2:	57                   	push   %edi
  8011b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b6:	e8 fb fb ff ff       	call   800db6 <sys_page_map>
  8011bb:	83 c4 20             	add    $0x20,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	0f 88 43 ff ff ff    	js     801109 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	68 05 08 00 00       	push   $0x805
  8011ce:	57                   	push   %edi
  8011cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d2:	50                   	push   %eax
  8011d3:	57                   	push   %edi
  8011d4:	50                   	push   %eax
  8011d5:	e8 dc fb ff ff       	call   800db6 <sys_page_map>
  8011da:	83 c4 20             	add    $0x20,%esp
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	0f 89 60 ff ff ff    	jns    801145 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	68 7c 29 80 00       	push   $0x80297c
  8011ed:	6a 52                	push   $0x52
  8011ef:	68 87 28 80 00       	push   $0x802887
  8011f4:	e8 43 f0 ff ff       	call   80023c <_panic>
			panic("duppage: single sys_page_map Failed!");
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	68 a0 29 80 00       	push   $0x8029a0
  801201:	6a 56                	push   $0x56
  801203:	68 87 28 80 00       	push   $0x802887
  801208:	e8 2f f0 ff ff       	call   80023c <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	6a 07                	push   $0x7
  801212:	68 00 f0 bf ee       	push   $0xeebff000
  801217:	ff 75 dc             	pushl  -0x24(%ebp)
  80121a:	e8 50 fb ff ff       	call   800d6f <sys_page_alloc>
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	78 2e                	js     801254 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	68 61 20 80 00       	push   $0x802061
  80122e:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801231:	57                   	push   %edi
  801232:	e8 97 fc ff ff       	call   800ece <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	6a 02                	push   $0x2
  80123c:	57                   	push   %edi
  80123d:	e8 00 fc ff ff       	call   800e42 <sys_env_set_status>
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	78 22                	js     80126b <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801249:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	68 e6 28 80 00       	push   $0x8028e6
  80125c:	68 83 00 00 00       	push   $0x83
  801261:	68 87 28 80 00       	push   $0x802887
  801266:	e8 d1 ef ff ff       	call   80023c <_panic>
		panic("fork: sys_env_set_status Failed!");
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 c8 29 80 00       	push   $0x8029c8
  801273:	68 89 00 00 00       	push   $0x89
  801278:	68 87 28 80 00       	push   $0x802887
  80127d:	e8 ba ef ff ff       	call   80023c <_panic>

00801282 <sfork>:

// Challenge!
int
sfork(void)
{
  801282:	f3 0f 1e fb          	endbr32 
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80128c:	68 02 29 80 00       	push   $0x802902
  801291:	68 93 00 00 00       	push   $0x93
  801296:	68 87 28 80 00       	push   $0x802887
  80129b:	e8 9c ef ff ff       	call   80023c <_panic>

008012a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a0:	f3 0f 1e fb          	endbr32 
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8012af:	c1 e8 0c             	shr    $0xc,%eax
}
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b4:	f3 0f 1e fb          	endbr32 
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012cf:	f3 0f 1e fb          	endbr32 
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	c1 ea 16             	shr    $0x16,%edx
  8012e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e7:	f6 c2 01             	test   $0x1,%dl
  8012ea:	74 2d                	je     801319 <fd_alloc+0x4a>
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	c1 ea 0c             	shr    $0xc,%edx
  8012f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f8:	f6 c2 01             	test   $0x1,%dl
  8012fb:	74 1c                	je     801319 <fd_alloc+0x4a>
  8012fd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801302:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801307:	75 d2                	jne    8012db <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801312:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801317:	eb 0a                	jmp    801323 <fd_alloc+0x54>
			*fd_store = fd;
  801319:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    

00801325 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801325:	f3 0f 1e fb          	endbr32 
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80132f:	83 f8 1f             	cmp    $0x1f,%eax
  801332:	77 30                	ja     801364 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801334:	c1 e0 0c             	shl    $0xc,%eax
  801337:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80133c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801342:	f6 c2 01             	test   $0x1,%dl
  801345:	74 24                	je     80136b <fd_lookup+0x46>
  801347:	89 c2                	mov    %eax,%edx
  801349:	c1 ea 0c             	shr    $0xc,%edx
  80134c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801353:	f6 c2 01             	test   $0x1,%dl
  801356:	74 1a                	je     801372 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135b:	89 02                	mov    %eax,(%edx)
	return 0;
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801362:	5d                   	pop    %ebp
  801363:	c3                   	ret    
		return -E_INVAL;
  801364:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801369:	eb f7                	jmp    801362 <fd_lookup+0x3d>
		return -E_INVAL;
  80136b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801370:	eb f0                	jmp    801362 <fd_lookup+0x3d>
  801372:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801377:	eb e9                	jmp    801362 <fd_lookup+0x3d>

00801379 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801379:	f3 0f 1e fb          	endbr32 
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 08             	sub    $0x8,%esp
  801383:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801386:	ba 68 2a 80 00       	mov    $0x802a68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80138b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801390:	39 08                	cmp    %ecx,(%eax)
  801392:	74 33                	je     8013c7 <dev_lookup+0x4e>
  801394:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801397:	8b 02                	mov    (%edx),%eax
  801399:	85 c0                	test   %eax,%eax
  80139b:	75 f3                	jne    801390 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80139d:	a1 04 40 80 00       	mov    0x804004,%eax
  8013a2:	8b 40 48             	mov    0x48(%eax),%eax
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	51                   	push   %ecx
  8013a9:	50                   	push   %eax
  8013aa:	68 ec 29 80 00       	push   $0x8029ec
  8013af:	e8 6f ef ff ff       	call   800323 <cprintf>
	*dev = 0;
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013bd:	83 c4 10             	add    $0x10,%esp
  8013c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    
			*dev = devtab[i];
  8013c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ca:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d1:	eb f2                	jmp    8013c5 <dev_lookup+0x4c>

008013d3 <fd_close>:
{
  8013d3:	f3 0f 1e fb          	endbr32 
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	57                   	push   %edi
  8013db:	56                   	push   %esi
  8013dc:	53                   	push   %ebx
  8013dd:	83 ec 24             	sub    $0x24,%esp
  8013e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ea:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013f0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013f3:	50                   	push   %eax
  8013f4:	e8 2c ff ff ff       	call   801325 <fd_lookup>
  8013f9:	89 c3                	mov    %eax,%ebx
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 05                	js     801407 <fd_close+0x34>
	    || fd != fd2)
  801402:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801405:	74 16                	je     80141d <fd_close+0x4a>
		return (must_exist ? r : 0);
  801407:	89 f8                	mov    %edi,%eax
  801409:	84 c0                	test   %al,%al
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	0f 44 d8             	cmove  %eax,%ebx
}
  801413:	89 d8                	mov    %ebx,%eax
  801415:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5f                   	pop    %edi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	ff 36                	pushl  (%esi)
  801426:	e8 4e ff ff ff       	call   801379 <dev_lookup>
  80142b:	89 c3                	mov    %eax,%ebx
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 1a                	js     80144e <fd_close+0x7b>
		if (dev->dev_close)
  801434:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801437:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80143a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80143f:	85 c0                	test   %eax,%eax
  801441:	74 0b                	je     80144e <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801443:	83 ec 0c             	sub    $0xc,%esp
  801446:	56                   	push   %esi
  801447:	ff d0                	call   *%eax
  801449:	89 c3                	mov    %eax,%ebx
  80144b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80144e:	83 ec 08             	sub    $0x8,%esp
  801451:	56                   	push   %esi
  801452:	6a 00                	push   $0x0
  801454:	e8 a3 f9 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  801459:	83 c4 10             	add    $0x10,%esp
  80145c:	eb b5                	jmp    801413 <fd_close+0x40>

0080145e <close>:

int
close(int fdnum)
{
  80145e:	f3 0f 1e fb          	endbr32 
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146b:	50                   	push   %eax
  80146c:	ff 75 08             	pushl  0x8(%ebp)
  80146f:	e8 b1 fe ff ff       	call   801325 <fd_lookup>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	79 02                	jns    80147d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    
		return fd_close(fd, 1);
  80147d:	83 ec 08             	sub    $0x8,%esp
  801480:	6a 01                	push   $0x1
  801482:	ff 75 f4             	pushl  -0xc(%ebp)
  801485:	e8 49 ff ff ff       	call   8013d3 <fd_close>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	eb ec                	jmp    80147b <close+0x1d>

0080148f <close_all>:

void
close_all(void)
{
  80148f:	f3 0f 1e fb          	endbr32 
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80149a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	53                   	push   %ebx
  8014a3:	e8 b6 ff ff ff       	call   80145e <close>
	for (i = 0; i < MAXFD; i++)
  8014a8:	83 c3 01             	add    $0x1,%ebx
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	83 fb 20             	cmp    $0x20,%ebx
  8014b1:	75 ec                	jne    80149f <close_all+0x10>
}
  8014b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014b8:	f3 0f 1e fb          	endbr32 
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	57                   	push   %edi
  8014c0:	56                   	push   %esi
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c8:	50                   	push   %eax
  8014c9:	ff 75 08             	pushl  0x8(%ebp)
  8014cc:	e8 54 fe ff ff       	call   801325 <fd_lookup>
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	0f 88 81 00 00 00    	js     80155f <dup+0xa7>
		return r;
	close(newfdnum);
  8014de:	83 ec 0c             	sub    $0xc,%esp
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 75 ff ff ff       	call   80145e <close>

	newfd = INDEX2FD(newfdnum);
  8014e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014ec:	c1 e6 0c             	shl    $0xc,%esi
  8014ef:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014f5:	83 c4 04             	add    $0x4,%esp
  8014f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014fb:	e8 b4 fd ff ff       	call   8012b4 <fd2data>
  801500:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801502:	89 34 24             	mov    %esi,(%esp)
  801505:	e8 aa fd ff ff       	call   8012b4 <fd2data>
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80150f:	89 d8                	mov    %ebx,%eax
  801511:	c1 e8 16             	shr    $0x16,%eax
  801514:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80151b:	a8 01                	test   $0x1,%al
  80151d:	74 11                	je     801530 <dup+0x78>
  80151f:	89 d8                	mov    %ebx,%eax
  801521:	c1 e8 0c             	shr    $0xc,%eax
  801524:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80152b:	f6 c2 01             	test   $0x1,%dl
  80152e:	75 39                	jne    801569 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801530:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	c1 e8 0c             	shr    $0xc,%eax
  801538:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	25 07 0e 00 00       	and    $0xe07,%eax
  801547:	50                   	push   %eax
  801548:	56                   	push   %esi
  801549:	6a 00                	push   $0x0
  80154b:	52                   	push   %edx
  80154c:	6a 00                	push   $0x0
  80154e:	e8 63 f8 ff ff       	call   800db6 <sys_page_map>
  801553:	89 c3                	mov    %eax,%ebx
  801555:	83 c4 20             	add    $0x20,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 31                	js     80158d <dup+0xd5>
		goto err;

	return newfdnum;
  80155c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80155f:	89 d8                	mov    %ebx,%eax
  801561:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801564:	5b                   	pop    %ebx
  801565:	5e                   	pop    %esi
  801566:	5f                   	pop    %edi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801569:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801570:	83 ec 0c             	sub    $0xc,%esp
  801573:	25 07 0e 00 00       	and    $0xe07,%eax
  801578:	50                   	push   %eax
  801579:	57                   	push   %edi
  80157a:	6a 00                	push   $0x0
  80157c:	53                   	push   %ebx
  80157d:	6a 00                	push   $0x0
  80157f:	e8 32 f8 ff ff       	call   800db6 <sys_page_map>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	83 c4 20             	add    $0x20,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	79 a3                	jns    801530 <dup+0x78>
	sys_page_unmap(0, newfd);
  80158d:	83 ec 08             	sub    $0x8,%esp
  801590:	56                   	push   %esi
  801591:	6a 00                	push   $0x0
  801593:	e8 64 f8 ff ff       	call   800dfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801598:	83 c4 08             	add    $0x8,%esp
  80159b:	57                   	push   %edi
  80159c:	6a 00                	push   $0x0
  80159e:	e8 59 f8 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	eb b7                	jmp    80155f <dup+0xa7>

008015a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015a8:	f3 0f 1e fb          	endbr32 
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 1c             	sub    $0x1c,%esp
  8015b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b9:	50                   	push   %eax
  8015ba:	53                   	push   %ebx
  8015bb:	e8 65 fd ff ff       	call   801325 <fd_lookup>
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 3f                	js     801606 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cd:	50                   	push   %eax
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	ff 30                	pushl  (%eax)
  8015d3:	e8 a1 fd ff ff       	call   801379 <dev_lookup>
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 27                	js     801606 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e2:	8b 42 08             	mov    0x8(%edx),%eax
  8015e5:	83 e0 03             	and    $0x3,%eax
  8015e8:	83 f8 01             	cmp    $0x1,%eax
  8015eb:	74 1e                	je     80160b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f0:	8b 40 08             	mov    0x8(%eax),%eax
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	74 35                	je     80162c <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	ff 75 10             	pushl  0x10(%ebp)
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	52                   	push   %edx
  801601:	ff d0                	call   *%eax
  801603:	83 c4 10             	add    $0x10,%esp
}
  801606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801609:	c9                   	leave  
  80160a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80160b:	a1 04 40 80 00       	mov    0x804004,%eax
  801610:	8b 40 48             	mov    0x48(%eax),%eax
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	53                   	push   %ebx
  801617:	50                   	push   %eax
  801618:	68 2d 2a 80 00       	push   $0x802a2d
  80161d:	e8 01 ed ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162a:	eb da                	jmp    801606 <read+0x5e>
		return -E_NOT_SUPP;
  80162c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801631:	eb d3                	jmp    801606 <read+0x5e>

00801633 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801633:	f3 0f 1e fb          	endbr32 
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	57                   	push   %edi
  80163b:	56                   	push   %esi
  80163c:	53                   	push   %ebx
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	8b 7d 08             	mov    0x8(%ebp),%edi
  801643:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80164b:	eb 02                	jmp    80164f <readn+0x1c>
  80164d:	01 c3                	add    %eax,%ebx
  80164f:	39 f3                	cmp    %esi,%ebx
  801651:	73 21                	jae    801674 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	89 f0                	mov    %esi,%eax
  801658:	29 d8                	sub    %ebx,%eax
  80165a:	50                   	push   %eax
  80165b:	89 d8                	mov    %ebx,%eax
  80165d:	03 45 0c             	add    0xc(%ebp),%eax
  801660:	50                   	push   %eax
  801661:	57                   	push   %edi
  801662:	e8 41 ff ff ff       	call   8015a8 <read>
		if (m < 0)
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 04                	js     801672 <readn+0x3f>
			return m;
		if (m == 0)
  80166e:	75 dd                	jne    80164d <readn+0x1a>
  801670:	eb 02                	jmp    801674 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801672:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801674:	89 d8                	mov    %ebx,%eax
  801676:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801679:	5b                   	pop    %ebx
  80167a:	5e                   	pop    %esi
  80167b:	5f                   	pop    %edi
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80167e:	f3 0f 1e fb          	endbr32 
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	53                   	push   %ebx
  801686:	83 ec 1c             	sub    $0x1c,%esp
  801689:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168f:	50                   	push   %eax
  801690:	53                   	push   %ebx
  801691:	e8 8f fc ff ff       	call   801325 <fd_lookup>
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	78 3a                	js     8016d7 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a3:	50                   	push   %eax
  8016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a7:	ff 30                	pushl  (%eax)
  8016a9:	e8 cb fc ff ff       	call   801379 <dev_lookup>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 22                	js     8016d7 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016bc:	74 1e                	je     8016dc <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c4:	85 d2                	test   %edx,%edx
  8016c6:	74 35                	je     8016fd <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	ff 75 10             	pushl  0x10(%ebp)
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	50                   	push   %eax
  8016d2:	ff d2                	call   *%edx
  8016d4:	83 c4 10             	add    $0x10,%esp
}
  8016d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016dc:	a1 04 40 80 00       	mov    0x804004,%eax
  8016e1:	8b 40 48             	mov    0x48(%eax),%eax
  8016e4:	83 ec 04             	sub    $0x4,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	50                   	push   %eax
  8016e9:	68 49 2a 80 00       	push   $0x802a49
  8016ee:	e8 30 ec ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fb:	eb da                	jmp    8016d7 <write+0x59>
		return -E_NOT_SUPP;
  8016fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801702:	eb d3                	jmp    8016d7 <write+0x59>

00801704 <seek>:

int
seek(int fdnum, off_t offset)
{
  801704:	f3 0f 1e fb          	endbr32 
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801711:	50                   	push   %eax
  801712:	ff 75 08             	pushl  0x8(%ebp)
  801715:	e8 0b fc ff ff       	call   801325 <fd_lookup>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 0e                	js     80172f <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801721:	8b 55 0c             	mov    0xc(%ebp),%edx
  801724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801727:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801731:	f3 0f 1e fb          	endbr32 
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
  801739:	83 ec 1c             	sub    $0x1c,%esp
  80173c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801742:	50                   	push   %eax
  801743:	53                   	push   %ebx
  801744:	e8 dc fb ff ff       	call   801325 <fd_lookup>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	78 37                	js     801787 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801756:	50                   	push   %eax
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	ff 30                	pushl  (%eax)
  80175c:	e8 18 fc ff ff       	call   801379 <dev_lookup>
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	78 1f                	js     801787 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80176f:	74 1b                	je     80178c <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801774:	8b 52 18             	mov    0x18(%edx),%edx
  801777:	85 d2                	test   %edx,%edx
  801779:	74 32                	je     8017ad <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	50                   	push   %eax
  801782:	ff d2                	call   *%edx
  801784:	83 c4 10             	add    $0x10,%esp
}
  801787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80178c:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801791:	8b 40 48             	mov    0x48(%eax),%eax
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	53                   	push   %ebx
  801798:	50                   	push   %eax
  801799:	68 0c 2a 80 00       	push   $0x802a0c
  80179e:	e8 80 eb ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ab:	eb da                	jmp    801787 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b2:	eb d3                	jmp    801787 <ftruncate+0x56>

008017b4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017b4:	f3 0f 1e fb          	endbr32 
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 1c             	sub    $0x1c,%esp
  8017bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	ff 75 08             	pushl  0x8(%ebp)
  8017c9:	e8 57 fb ff ff       	call   801325 <fd_lookup>
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 4b                	js     801820 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017db:	50                   	push   %eax
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	ff 30                	pushl  (%eax)
  8017e1:	e8 93 fb ff ff       	call   801379 <dev_lookup>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 33                	js     801820 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017f4:	74 2f                	je     801825 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801800:	00 00 00 
	stat->st_isdir = 0;
  801803:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80180a:	00 00 00 
	stat->st_dev = dev;
  80180d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	53                   	push   %ebx
  801817:	ff 75 f0             	pushl  -0x10(%ebp)
  80181a:	ff 50 14             	call   *0x14(%eax)
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801823:	c9                   	leave  
  801824:	c3                   	ret    
		return -E_NOT_SUPP;
  801825:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182a:	eb f4                	jmp    801820 <fstat+0x6c>

0080182c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80182c:	f3 0f 1e fb          	endbr32 
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	56                   	push   %esi
  801834:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	6a 00                	push   $0x0
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	e8 fb 01 00 00       	call   801a3d <open>
  801842:	89 c3                	mov    %eax,%ebx
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 1b                	js     801866 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	50                   	push   %eax
  801852:	e8 5d ff ff ff       	call   8017b4 <fstat>
  801857:	89 c6                	mov    %eax,%esi
	close(fd);
  801859:	89 1c 24             	mov    %ebx,(%esp)
  80185c:	e8 fd fb ff ff       	call   80145e <close>
	return r;
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	89 f3                	mov    %esi,%ebx
}
  801866:	89 d8                	mov    %ebx,%eax
  801868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    

0080186f <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	89 c6                	mov    %eax,%esi
  801876:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801878:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80187f:	74 27                	je     8018a8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801881:	6a 07                	push   $0x7
  801883:	68 00 50 80 00       	push   $0x805000
  801888:	56                   	push   %esi
  801889:	ff 35 00 40 80 00    	pushl  0x804000
  80188f:	e8 5e 08 00 00       	call   8020f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801894:	83 c4 0c             	add    $0xc,%esp
  801897:	6a 00                	push   $0x0
  801899:	53                   	push   %ebx
  80189a:	6a 00                	push   $0x0
  80189c:	e8 e4 07 00 00       	call   802085 <ipc_recv>
}
  8018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a4:	5b                   	pop    %ebx
  8018a5:	5e                   	pop    %esi
  8018a6:	5d                   	pop    %ebp
  8018a7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	6a 01                	push   $0x1
  8018ad:	e8 9a 08 00 00       	call   80214c <ipc_find_env>
  8018b2:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	eb c5                	jmp    801881 <fsipc+0x12>

008018bc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018bc:	f3 0f 1e fb          	endbr32 
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018de:	b8 02 00 00 00       	mov    $0x2,%eax
  8018e3:	e8 87 ff ff ff       	call   80186f <fsipc>
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <devfile_flush>:
{
  8018ea:	f3 0f 1e fb          	endbr32 
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fa:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801904:	b8 06 00 00 00       	mov    $0x6,%eax
  801909:	e8 61 ff ff ff       	call   80186f <fsipc>
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <devfile_stat>:
{
  801910:	f3 0f 1e fb          	endbr32 
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	53                   	push   %ebx
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	8b 40 0c             	mov    0xc(%eax),%eax
  801924:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801929:	ba 00 00 00 00       	mov    $0x0,%edx
  80192e:	b8 05 00 00 00       	mov    $0x5,%eax
  801933:	e8 37 ff ff ff       	call   80186f <fsipc>
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 2c                	js     801968 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80193c:	83 ec 08             	sub    $0x8,%esp
  80193f:	68 00 50 80 00       	push   $0x805000
  801944:	53                   	push   %ebx
  801945:	e8 e3 ef ff ff       	call   80092d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80194a:	a1 80 50 80 00       	mov    0x805080,%eax
  80194f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801955:	a1 84 50 80 00       	mov    0x805084,%eax
  80195a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devfile_write>:
{
  80196d:	f3 0f 1e fb          	endbr32 
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 0c             	sub    $0xc,%esp
  801977:	8b 45 10             	mov    0x10(%ebp),%eax
  80197a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80197f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801984:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801987:	8b 55 08             	mov    0x8(%ebp),%edx
  80198a:	8b 52 0c             	mov    0xc(%edx),%edx
  80198d:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801993:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801998:	50                   	push   %eax
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	68 08 50 80 00       	push   $0x805008
  8019a1:	e8 3d f1 ff ff       	call   800ae3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8019b0:	e8 ba fe ff ff       	call   80186f <fsipc>
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <devfile_read>:
{
  8019b7:	f3 0f 1e fb          	endbr32 
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019ce:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8019de:	e8 8c fe ff ff       	call   80186f <fsipc>
  8019e3:	89 c3                	mov    %eax,%ebx
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	78 1f                	js     801a08 <devfile_read+0x51>
	assert(r <= n);
  8019e9:	39 f0                	cmp    %esi,%eax
  8019eb:	77 24                	ja     801a11 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019f2:	7f 33                	jg     801a27 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	50                   	push   %eax
  8019f8:	68 00 50 80 00       	push   $0x805000
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	e8 de f0 ff ff       	call   800ae3 <memmove>
	return r;
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    
	assert(r <= n);
  801a11:	68 78 2a 80 00       	push   $0x802a78
  801a16:	68 7f 2a 80 00       	push   $0x802a7f
  801a1b:	6a 7d                	push   $0x7d
  801a1d:	68 94 2a 80 00       	push   $0x802a94
  801a22:	e8 15 e8 ff ff       	call   80023c <_panic>
	assert(r <= PGSIZE);
  801a27:	68 9f 2a 80 00       	push   $0x802a9f
  801a2c:	68 7f 2a 80 00       	push   $0x802a7f
  801a31:	6a 7e                	push   $0x7e
  801a33:	68 94 2a 80 00       	push   $0x802a94
  801a38:	e8 ff e7 ff ff       	call   80023c <_panic>

00801a3d <open>:
{
  801a3d:	f3 0f 1e fb          	endbr32 
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	56                   	push   %esi
  801a45:	53                   	push   %ebx
  801a46:	83 ec 1c             	sub    $0x1c,%esp
  801a49:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a4c:	56                   	push   %esi
  801a4d:	e8 98 ee ff ff       	call   8008ea <strlen>
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a5a:	7f 6c                	jg     801ac8 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	e8 67 f8 ff ff       	call   8012cf <fd_alloc>
  801a68:	89 c3                	mov    %eax,%ebx
  801a6a:	83 c4 10             	add    $0x10,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 3c                	js     801aad <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	56                   	push   %esi
  801a75:	68 00 50 80 00       	push   $0x805000
  801a7a:	e8 ae ee ff ff       	call   80092d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a82:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	e8 db fd ff ff       	call   80186f <fsipc>
  801a94:	89 c3                	mov    %eax,%ebx
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 19                	js     801ab6 <open+0x79>
	return fd2num(fd);
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa3:	e8 f8 f7 ff ff       	call   8012a0 <fd2num>
  801aa8:	89 c3                	mov    %eax,%ebx
  801aaa:	83 c4 10             	add    $0x10,%esp
}
  801aad:	89 d8                	mov    %ebx,%eax
  801aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    
		fd_close(fd, 0);
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 f4             	pushl  -0xc(%ebp)
  801abe:	e8 10 f9 ff ff       	call   8013d3 <fd_close>
		return r;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	eb e5                	jmp    801aad <open+0x70>
		return -E_BAD_PATH;
  801ac8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801acd:	eb de                	jmp    801aad <open+0x70>

00801acf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801acf:	f3 0f 1e fb          	endbr32 
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	b8 08 00 00 00       	mov    $0x8,%eax
  801ae3:	e8 87 fd ff ff       	call   80186f <fsipc>
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aea:	f3 0f 1e fb          	endbr32 
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	56                   	push   %esi
  801af2:	53                   	push   %ebx
  801af3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801af6:	83 ec 0c             	sub    $0xc,%esp
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	e8 b3 f7 ff ff       	call   8012b4 <fd2data>
  801b01:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b03:	83 c4 08             	add    $0x8,%esp
  801b06:	68 ab 2a 80 00       	push   $0x802aab
  801b0b:	53                   	push   %ebx
  801b0c:	e8 1c ee ff ff       	call   80092d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b11:	8b 46 04             	mov    0x4(%esi),%eax
  801b14:	2b 06                	sub    (%esi),%eax
  801b16:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b1c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b23:	00 00 00 
	stat->st_dev = &devpipe;
  801b26:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b2d:	30 80 00 
	return 0;
}
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
  801b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b3c:	f3 0f 1e fb          	endbr32 
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	53                   	push   %ebx
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b4a:	53                   	push   %ebx
  801b4b:	6a 00                	push   $0x0
  801b4d:	e8 aa f2 ff ff       	call   800dfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b52:	89 1c 24             	mov    %ebx,(%esp)
  801b55:	e8 5a f7 ff ff       	call   8012b4 <fd2data>
  801b5a:	83 c4 08             	add    $0x8,%esp
  801b5d:	50                   	push   %eax
  801b5e:	6a 00                	push   $0x0
  801b60:	e8 97 f2 ff ff       	call   800dfc <sys_page_unmap>
}
  801b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <_pipeisclosed>:
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 1c             	sub    $0x1c,%esp
  801b73:	89 c7                	mov    %eax,%edi
  801b75:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b77:	a1 04 40 80 00       	mov    0x804004,%eax
  801b7c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b7f:	83 ec 0c             	sub    $0xc,%esp
  801b82:	57                   	push   %edi
  801b83:	e8 01 06 00 00       	call   802189 <pageref>
  801b88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b8b:	89 34 24             	mov    %esi,(%esp)
  801b8e:	e8 f6 05 00 00       	call   802189 <pageref>
		nn = thisenv->env_runs;
  801b93:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b99:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	39 cb                	cmp    %ecx,%ebx
  801ba1:	74 1b                	je     801bbe <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ba3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba6:	75 cf                	jne    801b77 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ba8:	8b 42 58             	mov    0x58(%edx),%eax
  801bab:	6a 01                	push   $0x1
  801bad:	50                   	push   %eax
  801bae:	53                   	push   %ebx
  801baf:	68 b2 2a 80 00       	push   $0x802ab2
  801bb4:	e8 6a e7 ff ff       	call   800323 <cprintf>
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	eb b9                	jmp    801b77 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bbe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc1:	0f 94 c0             	sete   %al
  801bc4:	0f b6 c0             	movzbl %al,%eax
}
  801bc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5e                   	pop    %esi
  801bcc:	5f                   	pop    %edi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    

00801bcf <devpipe_write>:
{
  801bcf:	f3 0f 1e fb          	endbr32 
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	57                   	push   %edi
  801bd7:	56                   	push   %esi
  801bd8:	53                   	push   %ebx
  801bd9:	83 ec 28             	sub    $0x28,%esp
  801bdc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bdf:	56                   	push   %esi
  801be0:	e8 cf f6 ff ff       	call   8012b4 <fd2data>
  801be5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	bf 00 00 00 00       	mov    $0x0,%edi
  801bef:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bf2:	74 4f                	je     801c43 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bf4:	8b 43 04             	mov    0x4(%ebx),%eax
  801bf7:	8b 0b                	mov    (%ebx),%ecx
  801bf9:	8d 51 20             	lea    0x20(%ecx),%edx
  801bfc:	39 d0                	cmp    %edx,%eax
  801bfe:	72 14                	jb     801c14 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c00:	89 da                	mov    %ebx,%edx
  801c02:	89 f0                	mov    %esi,%eax
  801c04:	e8 61 ff ff ff       	call   801b6a <_pipeisclosed>
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	75 3b                	jne    801c48 <devpipe_write+0x79>
			sys_yield();
  801c0d:	e8 3a f1 ff ff       	call   800d4c <sys_yield>
  801c12:	eb e0                	jmp    801bf4 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c17:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c1b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c1e:	89 c2                	mov    %eax,%edx
  801c20:	c1 fa 1f             	sar    $0x1f,%edx
  801c23:	89 d1                	mov    %edx,%ecx
  801c25:	c1 e9 1b             	shr    $0x1b,%ecx
  801c28:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c2b:	83 e2 1f             	and    $0x1f,%edx
  801c2e:	29 ca                	sub    %ecx,%edx
  801c30:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c34:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c38:	83 c0 01             	add    $0x1,%eax
  801c3b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c3e:	83 c7 01             	add    $0x1,%edi
  801c41:	eb ac                	jmp    801bef <devpipe_write+0x20>
	return i;
  801c43:	8b 45 10             	mov    0x10(%ebp),%eax
  801c46:	eb 05                	jmp    801c4d <devpipe_write+0x7e>
				return 0;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5f                   	pop    %edi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <devpipe_read>:
{
  801c55:	f3 0f 1e fb          	endbr32 
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	57                   	push   %edi
  801c5d:	56                   	push   %esi
  801c5e:	53                   	push   %ebx
  801c5f:	83 ec 18             	sub    $0x18,%esp
  801c62:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c65:	57                   	push   %edi
  801c66:	e8 49 f6 ff ff       	call   8012b4 <fd2data>
  801c6b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	be 00 00 00 00       	mov    $0x0,%esi
  801c75:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c78:	75 14                	jne    801c8e <devpipe_read+0x39>
	return i;
  801c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7d:	eb 02                	jmp    801c81 <devpipe_read+0x2c>
				return i;
  801c7f:	89 f0                	mov    %esi,%eax
}
  801c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5f                   	pop    %edi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
			sys_yield();
  801c89:	e8 be f0 ff ff       	call   800d4c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c8e:	8b 03                	mov    (%ebx),%eax
  801c90:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c93:	75 18                	jne    801cad <devpipe_read+0x58>
			if (i > 0)
  801c95:	85 f6                	test   %esi,%esi
  801c97:	75 e6                	jne    801c7f <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c99:	89 da                	mov    %ebx,%edx
  801c9b:	89 f8                	mov    %edi,%eax
  801c9d:	e8 c8 fe ff ff       	call   801b6a <_pipeisclosed>
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	74 e3                	je     801c89 <devpipe_read+0x34>
				return 0;
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cab:	eb d4                	jmp    801c81 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cad:	99                   	cltd   
  801cae:	c1 ea 1b             	shr    $0x1b,%edx
  801cb1:	01 d0                	add    %edx,%eax
  801cb3:	83 e0 1f             	and    $0x1f,%eax
  801cb6:	29 d0                	sub    %edx,%eax
  801cb8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cc3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cc6:	83 c6 01             	add    $0x1,%esi
  801cc9:	eb aa                	jmp    801c75 <devpipe_read+0x20>

00801ccb <pipe>:
{
  801ccb:	f3 0f 1e fb          	endbr32 
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cda:	50                   	push   %eax
  801cdb:	e8 ef f5 ff ff       	call   8012cf <fd_alloc>
  801ce0:	89 c3                	mov    %eax,%ebx
  801ce2:	83 c4 10             	add    $0x10,%esp
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	0f 88 23 01 00 00    	js     801e10 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	68 07 04 00 00       	push   $0x407
  801cf5:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf8:	6a 00                	push   $0x0
  801cfa:	e8 70 f0 ff ff       	call   800d6f <sys_page_alloc>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	85 c0                	test   %eax,%eax
  801d06:	0f 88 04 01 00 00    	js     801e10 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d12:	50                   	push   %eax
  801d13:	e8 b7 f5 ff ff       	call   8012cf <fd_alloc>
  801d18:	89 c3                	mov    %eax,%ebx
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	0f 88 db 00 00 00    	js     801e00 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	68 07 04 00 00       	push   $0x407
  801d2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d30:	6a 00                	push   $0x0
  801d32:	e8 38 f0 ff ff       	call   800d6f <sys_page_alloc>
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	0f 88 bc 00 00 00    	js     801e00 <pipe+0x135>
	va = fd2data(fd0);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4a:	e8 65 f5 ff ff       	call   8012b4 <fd2data>
  801d4f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d51:	83 c4 0c             	add    $0xc,%esp
  801d54:	68 07 04 00 00       	push   $0x407
  801d59:	50                   	push   %eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	e8 0e f0 ff ff       	call   800d6f <sys_page_alloc>
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	85 c0                	test   %eax,%eax
  801d68:	0f 88 82 00 00 00    	js     801df0 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6e:	83 ec 0c             	sub    $0xc,%esp
  801d71:	ff 75 f0             	pushl  -0x10(%ebp)
  801d74:	e8 3b f5 ff ff       	call   8012b4 <fd2data>
  801d79:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d80:	50                   	push   %eax
  801d81:	6a 00                	push   $0x0
  801d83:	56                   	push   %esi
  801d84:	6a 00                	push   $0x0
  801d86:	e8 2b f0 ff ff       	call   800db6 <sys_page_map>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	83 c4 20             	add    $0x20,%esp
  801d90:	85 c0                	test   %eax,%eax
  801d92:	78 4e                	js     801de2 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d94:	a1 20 30 80 00       	mov    0x803020,%eax
  801d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dab:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbd:	e8 de f4 ff ff       	call   8012a0 <fd2num>
  801dc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dc7:	83 c4 04             	add    $0x4,%esp
  801dca:	ff 75 f0             	pushl  -0x10(%ebp)
  801dcd:	e8 ce f4 ff ff       	call   8012a0 <fd2num>
  801dd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de0:	eb 2e                	jmp    801e10 <pipe+0x145>
	sys_page_unmap(0, va);
  801de2:	83 ec 08             	sub    $0x8,%esp
  801de5:	56                   	push   %esi
  801de6:	6a 00                	push   $0x0
  801de8:	e8 0f f0 ff ff       	call   800dfc <sys_page_unmap>
  801ded:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	ff 75 f0             	pushl  -0x10(%ebp)
  801df6:	6a 00                	push   $0x0
  801df8:	e8 ff ef ff ff       	call   800dfc <sys_page_unmap>
  801dfd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	ff 75 f4             	pushl  -0xc(%ebp)
  801e06:	6a 00                	push   $0x0
  801e08:	e8 ef ef ff ff       	call   800dfc <sys_page_unmap>
  801e0d:	83 c4 10             	add    $0x10,%esp
}
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    

00801e19 <pipeisclosed>:
{
  801e19:	f3 0f 1e fb          	endbr32 
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e26:	50                   	push   %eax
  801e27:	ff 75 08             	pushl  0x8(%ebp)
  801e2a:	e8 f6 f4 ff ff       	call   801325 <fd_lookup>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 18                	js     801e4e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3c:	e8 73 f4 ff ff       	call   8012b4 <fd2data>
  801e41:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	e8 1f fd ff ff       	call   801b6a <_pipeisclosed>
  801e4b:	83 c4 10             	add    $0x10,%esp
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e50:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	c3                   	ret    

00801e5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e5a:	f3 0f 1e fb          	endbr32 
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e64:	68 ca 2a 80 00       	push   $0x802aca
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	e8 bc ea ff ff       	call   80092d <strcpy>
	return 0;
}
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <devcons_write>:
{
  801e78:	f3 0f 1e fb          	endbr32 
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	57                   	push   %edi
  801e80:	56                   	push   %esi
  801e81:	53                   	push   %ebx
  801e82:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e88:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e8d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e93:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e96:	73 31                	jae    801ec9 <devcons_write+0x51>
		m = n - tot;
  801e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e9b:	29 f3                	sub    %esi,%ebx
  801e9d:	83 fb 7f             	cmp    $0x7f,%ebx
  801ea0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ea5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	53                   	push   %ebx
  801eac:	89 f0                	mov    %esi,%eax
  801eae:	03 45 0c             	add    0xc(%ebp),%eax
  801eb1:	50                   	push   %eax
  801eb2:	57                   	push   %edi
  801eb3:	e8 2b ec ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  801eb8:	83 c4 08             	add    $0x8,%esp
  801ebb:	53                   	push   %ebx
  801ebc:	57                   	push   %edi
  801ebd:	e8 dd ed ff ff       	call   800c9f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ec2:	01 de                	add    %ebx,%esi
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	eb ca                	jmp    801e93 <devcons_write+0x1b>
}
  801ec9:	89 f0                	mov    %esi,%eax
  801ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5e                   	pop    %esi
  801ed0:	5f                   	pop    %edi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    

00801ed3 <devcons_read>:
{
  801ed3:	f3 0f 1e fb          	endbr32 
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 08             	sub    $0x8,%esp
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ee6:	74 21                	je     801f09 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ee8:	e8 d4 ed ff ff       	call   800cc1 <sys_cgetc>
  801eed:	85 c0                	test   %eax,%eax
  801eef:	75 07                	jne    801ef8 <devcons_read+0x25>
		sys_yield();
  801ef1:	e8 56 ee ff ff       	call   800d4c <sys_yield>
  801ef6:	eb f0                	jmp    801ee8 <devcons_read+0x15>
	if (c < 0)
  801ef8:	78 0f                	js     801f09 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801efa:	83 f8 04             	cmp    $0x4,%eax
  801efd:	74 0c                	je     801f0b <devcons_read+0x38>
	*(char*)vbuf = c;
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	88 02                	mov    %al,(%edx)
	return 1;
  801f04:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    
		return 0;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f10:	eb f7                	jmp    801f09 <devcons_read+0x36>

00801f12 <cputchar>:
{
  801f12:	f3 0f 1e fb          	endbr32 
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f22:	6a 01                	push   $0x1
  801f24:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f27:	50                   	push   %eax
  801f28:	e8 72 ed ff ff       	call   800c9f <sys_cputs>
}
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <getchar>:
{
  801f32:	f3 0f 1e fb          	endbr32 
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f3c:	6a 01                	push   $0x1
  801f3e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f41:	50                   	push   %eax
  801f42:	6a 00                	push   $0x0
  801f44:	e8 5f f6 ff ff       	call   8015a8 <read>
	if (r < 0)
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 06                	js     801f56 <getchar+0x24>
	if (r < 1)
  801f50:	74 06                	je     801f58 <getchar+0x26>
	return c;
  801f52:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    
		return -E_EOF;
  801f58:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f5d:	eb f7                	jmp    801f56 <getchar+0x24>

00801f5f <iscons>:
{
  801f5f:	f3 0f 1e fb          	endbr32 
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6c:	50                   	push   %eax
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	e8 b0 f3 ff ff       	call   801325 <fd_lookup>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	78 11                	js     801f8d <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f85:	39 10                	cmp    %edx,(%eax)
  801f87:	0f 94 c0             	sete   %al
  801f8a:	0f b6 c0             	movzbl %al,%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <opencons>:
{
  801f8f:	f3 0f 1e fb          	endbr32 
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9c:	50                   	push   %eax
  801f9d:	e8 2d f3 ff ff       	call   8012cf <fd_alloc>
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	78 3a                	js     801fe3 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	68 07 04 00 00       	push   $0x407
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	6a 00                	push   $0x0
  801fb6:	e8 b4 ed ff ff       	call   800d6f <sys_page_alloc>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 21                	js     801fe3 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fcb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	50                   	push   %eax
  801fdb:	e8 c0 f2 ff ff       	call   8012a0 <fd2num>
  801fe0:	83 c4 10             	add    $0x10,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fe5:	f3 0f 1e fb          	endbr32 
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	53                   	push   %ebx
  801fed:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ff0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ff7:	74 0d                	je     802006 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802004:	c9                   	leave  
  802005:	c3                   	ret    
		envid_t envid=sys_getenvid();
  802006:	e8 1e ed ff ff       	call   800d29 <sys_getenvid>
  80200b:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	6a 07                	push   $0x7
  802012:	68 00 f0 bf ee       	push   $0xeebff000
  802017:	50                   	push   %eax
  802018:	e8 52 ed ff ff       	call   800d6f <sys_page_alloc>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	85 c0                	test   %eax,%eax
  802022:	78 29                	js     80204d <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802024:	83 ec 08             	sub    $0x8,%esp
  802027:	68 61 20 80 00       	push   $0x802061
  80202c:	53                   	push   %ebx
  80202d:	e8 9c ee ff ff       	call   800ece <sys_env_set_pgfault_upcall>
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	85 c0                	test   %eax,%eax
  802037:	79 c0                	jns    801ff9 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 04 2b 80 00       	push   $0x802b04
  802041:	6a 24                	push   $0x24
  802043:	68 3b 2b 80 00       	push   $0x802b3b
  802048:	e8 ef e1 ff ff       	call   80023c <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 d8 2a 80 00       	push   $0x802ad8
  802055:	6a 22                	push   $0x22
  802057:	68 3b 2b 80 00       	push   $0x802b3b
  80205c:	e8 db e1 ff ff       	call   80023c <_panic>

00802061 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802061:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802062:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802067:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802069:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  80206c:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  80206f:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  802073:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  802078:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  80207c:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80207e:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80207f:	83 c4 04             	add    $0x4,%esp
	popfl
  802082:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802083:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802084:	c3                   	ret    

00802085 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802085:	f3 0f 1e fb          	endbr32 
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	56                   	push   %esi
  80208d:	53                   	push   %ebx
  80208e:	8b 75 08             	mov    0x8(%ebp),%esi
  802091:	8b 45 0c             	mov    0xc(%ebp),%eax
  802094:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802097:	85 c0                	test   %eax,%eax
  802099:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80209e:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	50                   	push   %eax
  8020a5:	e8 91 ee ff ff       	call   800f3b <sys_ipc_recv>
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	78 2b                	js     8020dc <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8020b1:	85 f6                	test   %esi,%esi
  8020b3:	74 0a                	je     8020bf <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  8020b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8020ba:	8b 40 74             	mov    0x74(%eax),%eax
  8020bd:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  8020bf:	85 db                	test   %ebx,%ebx
  8020c1:	74 0a                	je     8020cd <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  8020c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8020c8:	8b 40 78             	mov    0x78(%eax),%eax
  8020cb:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8020cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8020d2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    
		if(from_env_store)
  8020dc:	85 f6                	test   %esi,%esi
  8020de:	74 06                	je     8020e6 <ipc_recv+0x61>
			*from_env_store=0;
  8020e0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8020e6:	85 db                	test   %ebx,%ebx
  8020e8:	74 eb                	je     8020d5 <ipc_recv+0x50>
			*perm_store=0;
  8020ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020f0:	eb e3                	jmp    8020d5 <ipc_recv+0x50>

008020f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020f2:	f3 0f 1e fb          	endbr32 
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	57                   	push   %edi
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  802102:	8b 75 0c             	mov    0xc(%ebp),%esi
  802105:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802108:	85 db                	test   %ebx,%ebx
  80210a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80210f:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802112:	ff 75 14             	pushl  0x14(%ebp)
  802115:	53                   	push   %ebx
  802116:	56                   	push   %esi
  802117:	57                   	push   %edi
  802118:	e8 f7 ed ff ff       	call   800f14 <sys_ipc_try_send>
		if(!res)
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	74 20                	je     802144 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802124:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802127:	75 07                	jne    802130 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  802129:	e8 1e ec ff ff       	call   800d4c <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  80212e:	eb e2                	jmp    802112 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	68 49 2b 80 00       	push   $0x802b49
  802138:	6a 3f                	push   $0x3f
  80213a:	68 61 2b 80 00       	push   $0x802b61
  80213f:	e8 f8 e0 ff ff       	call   80023c <_panic>
	}
}
  802144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    

0080214c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80214c:	f3 0f 1e fb          	endbr32 
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80215b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80215e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802164:	8b 52 50             	mov    0x50(%edx),%edx
  802167:	39 ca                	cmp    %ecx,%edx
  802169:	74 11                	je     80217c <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80216b:	83 c0 01             	add    $0x1,%eax
  80216e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802173:	75 e6                	jne    80215b <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	eb 0b                	jmp    802187 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80217c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80217f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802184:	8b 40 48             	mov    0x48(%eax),%eax
}
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    

00802189 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802189:	f3 0f 1e fb          	endbr32 
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802193:	89 c2                	mov    %eax,%edx
  802195:	c1 ea 16             	shr    $0x16,%edx
  802198:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80219f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021a4:	f6 c1 01             	test   $0x1,%cl
  8021a7:	74 1c                	je     8021c5 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021a9:	c1 e8 0c             	shr    $0xc,%eax
  8021ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021b3:	a8 01                	test   $0x1,%al
  8021b5:	74 0e                	je     8021c5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021b7:	c1 e8 0c             	shr    $0xc,%eax
  8021ba:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021c1:	ef 
  8021c2:	0f b7 d2             	movzwl %dx,%edx
}
  8021c5:	89 d0                	mov    %edx,%eax
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    
  8021c9:	66 90                	xchg   %ax,%ax
  8021cb:	66 90                	xchg   %ax,%ax
  8021cd:	66 90                	xchg   %ax,%ax
  8021cf:	90                   	nop

008021d0 <__udivdi3>:
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	57                   	push   %edi
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
  8021db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021eb:	85 d2                	test   %edx,%edx
  8021ed:	75 19                	jne    802208 <__udivdi3+0x38>
  8021ef:	39 f3                	cmp    %esi,%ebx
  8021f1:	76 4d                	jbe    802240 <__udivdi3+0x70>
  8021f3:	31 ff                	xor    %edi,%edi
  8021f5:	89 e8                	mov    %ebp,%eax
  8021f7:	89 f2                	mov    %esi,%edx
  8021f9:	f7 f3                	div    %ebx
  8021fb:	89 fa                	mov    %edi,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	76 14                	jbe    802220 <__udivdi3+0x50>
  80220c:	31 ff                	xor    %edi,%edi
  80220e:	31 c0                	xor    %eax,%eax
  802210:	89 fa                	mov    %edi,%edx
  802212:	83 c4 1c             	add    $0x1c,%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    
  80221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802220:	0f bd fa             	bsr    %edx,%edi
  802223:	83 f7 1f             	xor    $0x1f,%edi
  802226:	75 48                	jne    802270 <__udivdi3+0xa0>
  802228:	39 f2                	cmp    %esi,%edx
  80222a:	72 06                	jb     802232 <__udivdi3+0x62>
  80222c:	31 c0                	xor    %eax,%eax
  80222e:	39 eb                	cmp    %ebp,%ebx
  802230:	77 de                	ja     802210 <__udivdi3+0x40>
  802232:	b8 01 00 00 00       	mov    $0x1,%eax
  802237:	eb d7                	jmp    802210 <__udivdi3+0x40>
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	89 d9                	mov    %ebx,%ecx
  802242:	85 db                	test   %ebx,%ebx
  802244:	75 0b                	jne    802251 <__udivdi3+0x81>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f3                	div    %ebx
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	31 d2                	xor    %edx,%edx
  802253:	89 f0                	mov    %esi,%eax
  802255:	f7 f1                	div    %ecx
  802257:	89 c6                	mov    %eax,%esi
  802259:	89 e8                	mov    %ebp,%eax
  80225b:	89 f7                	mov    %esi,%edi
  80225d:	f7 f1                	div    %ecx
  80225f:	89 fa                	mov    %edi,%edx
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	5d                   	pop    %ebp
  802268:	c3                   	ret    
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 f9                	mov    %edi,%ecx
  802272:	b8 20 00 00 00       	mov    $0x20,%eax
  802277:	29 f8                	sub    %edi,%eax
  802279:	d3 e2                	shl    %cl,%edx
  80227b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	89 da                	mov    %ebx,%edx
  802283:	d3 ea                	shr    %cl,%edx
  802285:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802289:	09 d1                	or     %edx,%ecx
  80228b:	89 f2                	mov    %esi,%edx
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 f9                	mov    %edi,%ecx
  802293:	d3 e3                	shl    %cl,%ebx
  802295:	89 c1                	mov    %eax,%ecx
  802297:	d3 ea                	shr    %cl,%edx
  802299:	89 f9                	mov    %edi,%ecx
  80229b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80229f:	89 eb                	mov    %ebp,%ebx
  8022a1:	d3 e6                	shl    %cl,%esi
  8022a3:	89 c1                	mov    %eax,%ecx
  8022a5:	d3 eb                	shr    %cl,%ebx
  8022a7:	09 de                	or     %ebx,%esi
  8022a9:	89 f0                	mov    %esi,%eax
  8022ab:	f7 74 24 08          	divl   0x8(%esp)
  8022af:	89 d6                	mov    %edx,%esi
  8022b1:	89 c3                	mov    %eax,%ebx
  8022b3:	f7 64 24 0c          	mull   0xc(%esp)
  8022b7:	39 d6                	cmp    %edx,%esi
  8022b9:	72 15                	jb     8022d0 <__udivdi3+0x100>
  8022bb:	89 f9                	mov    %edi,%ecx
  8022bd:	d3 e5                	shl    %cl,%ebp
  8022bf:	39 c5                	cmp    %eax,%ebp
  8022c1:	73 04                	jae    8022c7 <__udivdi3+0xf7>
  8022c3:	39 d6                	cmp    %edx,%esi
  8022c5:	74 09                	je     8022d0 <__udivdi3+0x100>
  8022c7:	89 d8                	mov    %ebx,%eax
  8022c9:	31 ff                	xor    %edi,%edi
  8022cb:	e9 40 ff ff ff       	jmp    802210 <__udivdi3+0x40>
  8022d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022d3:	31 ff                	xor    %edi,%edi
  8022d5:	e9 36 ff ff ff       	jmp    802210 <__udivdi3+0x40>
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__umoddi3>:
  8022e0:	f3 0f 1e fb          	endbr32 
  8022e4:	55                   	push   %ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 1c             	sub    $0x1c,%esp
  8022eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	75 19                	jne    802318 <__umoddi3+0x38>
  8022ff:	39 df                	cmp    %ebx,%edi
  802301:	76 5d                	jbe    802360 <__umoddi3+0x80>
  802303:	89 f0                	mov    %esi,%eax
  802305:	89 da                	mov    %ebx,%edx
  802307:	f7 f7                	div    %edi
  802309:	89 d0                	mov    %edx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	83 c4 1c             	add    $0x1c,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5f                   	pop    %edi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	89 f2                	mov    %esi,%edx
  80231a:	39 d8                	cmp    %ebx,%eax
  80231c:	76 12                	jbe    802330 <__umoddi3+0x50>
  80231e:	89 f0                	mov    %esi,%eax
  802320:	89 da                	mov    %ebx,%edx
  802322:	83 c4 1c             	add    $0x1c,%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5f                   	pop    %edi
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	75 50                	jne    802388 <__umoddi3+0xa8>
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	0f 82 e0 00 00 00    	jb     802420 <__umoddi3+0x140>
  802340:	89 d9                	mov    %ebx,%ecx
  802342:	39 f7                	cmp    %esi,%edi
  802344:	0f 86 d6 00 00 00    	jbe    802420 <__umoddi3+0x140>
  80234a:	89 d0                	mov    %edx,%eax
  80234c:	89 ca                	mov    %ecx,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 fd                	mov    %edi,%ebp
  802362:	85 ff                	test   %edi,%edi
  802364:	75 0b                	jne    802371 <__umoddi3+0x91>
  802366:	b8 01 00 00 00       	mov    $0x1,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f7                	div    %edi
  80236f:	89 c5                	mov    %eax,%ebp
  802371:	89 d8                	mov    %ebx,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f5                	div    %ebp
  802377:	89 f0                	mov    %esi,%eax
  802379:	f7 f5                	div    %ebp
  80237b:	89 d0                	mov    %edx,%eax
  80237d:	31 d2                	xor    %edx,%edx
  80237f:	eb 8c                	jmp    80230d <__umoddi3+0x2d>
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 e9                	mov    %ebp,%ecx
  80238a:	ba 20 00 00 00       	mov    $0x20,%edx
  80238f:	29 ea                	sub    %ebp,%edx
  802391:	d3 e0                	shl    %cl,%eax
  802393:	89 44 24 08          	mov    %eax,0x8(%esp)
  802397:	89 d1                	mov    %edx,%ecx
  802399:	89 f8                	mov    %edi,%eax
  80239b:	d3 e8                	shr    %cl,%eax
  80239d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023a9:	09 c1                	or     %eax,%ecx
  8023ab:	89 d8                	mov    %ebx,%eax
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 e9                	mov    %ebp,%ecx
  8023b3:	d3 e7                	shl    %cl,%edi
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023bf:	d3 e3                	shl    %cl,%ebx
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	89 d1                	mov    %edx,%ecx
  8023c5:	89 f0                	mov    %esi,%eax
  8023c7:	d3 e8                	shr    %cl,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	89 fa                	mov    %edi,%edx
  8023cd:	d3 e6                	shl    %cl,%esi
  8023cf:	09 d8                	or     %ebx,%eax
  8023d1:	f7 74 24 08          	divl   0x8(%esp)
  8023d5:	89 d1                	mov    %edx,%ecx
  8023d7:	89 f3                	mov    %esi,%ebx
  8023d9:	f7 64 24 0c          	mull   0xc(%esp)
  8023dd:	89 c6                	mov    %eax,%esi
  8023df:	89 d7                	mov    %edx,%edi
  8023e1:	39 d1                	cmp    %edx,%ecx
  8023e3:	72 06                	jb     8023eb <__umoddi3+0x10b>
  8023e5:	75 10                	jne    8023f7 <__umoddi3+0x117>
  8023e7:	39 c3                	cmp    %eax,%ebx
  8023e9:	73 0c                	jae    8023f7 <__umoddi3+0x117>
  8023eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023f3:	89 d7                	mov    %edx,%edi
  8023f5:	89 c6                	mov    %eax,%esi
  8023f7:	89 ca                	mov    %ecx,%edx
  8023f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023fe:	29 f3                	sub    %esi,%ebx
  802400:	19 fa                	sbb    %edi,%edx
  802402:	89 d0                	mov    %edx,%eax
  802404:	d3 e0                	shl    %cl,%eax
  802406:	89 e9                	mov    %ebp,%ecx
  802408:	d3 eb                	shr    %cl,%ebx
  80240a:	d3 ea                	shr    %cl,%edx
  80240c:	09 d8                	or     %ebx,%eax
  80240e:	83 c4 1c             	add    $0x1c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
  802416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	29 fe                	sub    %edi,%esi
  802422:	19 c3                	sbb    %eax,%ebx
  802424:	89 f2                	mov    %esi,%edx
  802426:	89 d9                	mov    %ebx,%ecx
  802428:	e9 1d ff ff ff       	jmp    80234a <__umoddi3+0x6a>
