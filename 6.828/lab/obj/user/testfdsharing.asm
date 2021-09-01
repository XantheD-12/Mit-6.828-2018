
obj/user/testfdsharing.debug：     文件格式 elf32-i386


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
  80002c:	e8 9d 01 00 00       	call   8001ce <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800040:	6a 00                	push   $0x0
  800042:	68 80 24 80 00       	push   $0x802480
  800047:	e8 eb 19 00 00       	call   801a37 <open>
  80004c:	89 c3                	mov    %eax,%ebx
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	0f 88 ff 00 00 00    	js     800158 <umain+0x125>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	6a 00                	push   $0x0
  80005e:	50                   	push   %eax
  80005f:	e8 9a 16 00 00       	call   8016fe <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800064:	83 c4 0c             	add    $0xc,%esp
  800067:	68 00 02 00 00       	push   $0x200
  80006c:	68 20 42 80 00       	push   $0x804220
  800071:	53                   	push   %ebx
  800072:	e8 b6 15 00 00       	call   80162d <readn>
  800077:	89 c6                	mov    %eax,%esi
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 8e e6 00 00 00    	jle    80016a <umain+0x137>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800084:	e8 d4 0f 00 00       	call   80105d <fork>
  800089:	89 c7                	mov    %eax,%edi
  80008b:	85 c0                	test   %eax,%eax
  80008d:	0f 88 e9 00 00 00    	js     80017c <umain+0x149>
		panic("fork: %e", r);
	if (r == 0) {
  800093:	75 7b                	jne    800110 <umain+0xdd>
		seek(fd, 0);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	6a 00                	push   $0x0
  80009a:	53                   	push   %ebx
  80009b:	e8 5e 16 00 00       	call   8016fe <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000a0:	c7 04 24 f0 24 80 00 	movl   $0x8024f0,(%esp)
  8000a7:	e8 71 02 00 00       	call   80031d <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000ac:	83 c4 0c             	add    $0xc,%esp
  8000af:	68 00 02 00 00       	push   $0x200
  8000b4:	68 20 40 80 00       	push   $0x804020
  8000b9:	53                   	push   %ebx
  8000ba:	e8 6e 15 00 00       	call   80162d <readn>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	39 c6                	cmp    %eax,%esi
  8000c4:	0f 85 c4 00 00 00    	jne    80018e <umain+0x15b>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	56                   	push   %esi
  8000ce:	68 20 40 80 00       	push   $0x804020
  8000d3:	68 20 42 80 00       	push   $0x804220
  8000d8:	e8 80 0a 00 00       	call   800b5d <memcmp>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 85 bc 00 00 00    	jne    8001a4 <umain+0x171>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 bb 24 80 00       	push   $0x8024bb
  8000f0:	e8 28 02 00 00       	call   80031d <cprintf>
		seek(fd, 0);
  8000f5:	83 c4 08             	add    $0x8,%esp
  8000f8:	6a 00                	push   $0x0
  8000fa:	53                   	push   %ebx
  8000fb:	e8 fe 15 00 00       	call   8016fe <seek>
		close(fd);
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 50 13 00 00       	call   801458 <close>
		exit();
  800108:	e8 0b 01 00 00       	call   800218 <exit>
  80010d:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	57                   	push   %edi
  800114:	e8 31 1d 00 00       	call   801e4a <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800119:	83 c4 0c             	add    $0xc,%esp
  80011c:	68 00 02 00 00       	push   $0x200
  800121:	68 20 40 80 00       	push   $0x804020
  800126:	53                   	push   %ebx
  800127:	e8 01 15 00 00       	call   80162d <readn>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	39 c6                	cmp    %eax,%esi
  800131:	0f 85 81 00 00 00    	jne    8001b8 <umain+0x185>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 d4 24 80 00       	push   $0x8024d4
  80013f:	e8 d9 01 00 00       	call   80031d <cprintf>
	close(fd);
  800144:	89 1c 24             	mov    %ebx,(%esp)
  800147:	e8 0c 13 00 00       	call   801458 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014c:	cc                   	int3   

	breakpoint();
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    
		panic("open motd: %e", fd);
  800158:	50                   	push   %eax
  800159:	68 85 24 80 00       	push   $0x802485
  80015e:	6a 0c                	push   $0xc
  800160:	68 93 24 80 00       	push   $0x802493
  800165:	e8 cc 00 00 00       	call   800236 <_panic>
		panic("readn: %e", n);
  80016a:	50                   	push   %eax
  80016b:	68 a8 24 80 00       	push   $0x8024a8
  800170:	6a 0f                	push   $0xf
  800172:	68 93 24 80 00       	push   $0x802493
  800177:	e8 ba 00 00 00       	call   800236 <_panic>
		panic("fork: %e", r);
  80017c:	50                   	push   %eax
  80017d:	68 b2 24 80 00       	push   $0x8024b2
  800182:	6a 12                	push   $0x12
  800184:	68 93 24 80 00       	push   $0x802493
  800189:	e8 a8 00 00 00       	call   800236 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	68 34 25 80 00       	push   $0x802534
  800198:	6a 17                	push   $0x17
  80019a:	68 93 24 80 00       	push   $0x802493
  80019f:	e8 92 00 00 00       	call   800236 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 60 25 80 00       	push   $0x802560
  8001ac:	6a 19                	push   $0x19
  8001ae:	68 93 24 80 00       	push   $0x802493
  8001b3:	e8 7e 00 00 00       	call   800236 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	56                   	push   %esi
  8001bd:	68 98 25 80 00       	push   $0x802598
  8001c2:	6a 21                	push   $0x21
  8001c4:	68 93 24 80 00       	push   $0x802493
  8001c9:	e8 68 00 00 00       	call   800236 <_panic>

008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	f3 0f 1e fb          	endbr32 
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 41 0b 00 00       	call   800d23 <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x31>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	f3 0f 1e fb          	endbr32 
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800222:	e8 62 12 00 00       	call   801489 <close_all>
	sys_env_destroy(0);
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	6a 00                	push   $0x0
  80022c:	e8 ad 0a 00 00       	call   800cde <sys_env_destroy>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800236:	f3 0f 1e fb          	endbr32 
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80023f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800242:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800248:	e8 d6 0a 00 00       	call   800d23 <sys_getenvid>
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	56                   	push   %esi
  800257:	50                   	push   %eax
  800258:	68 c8 25 80 00       	push   $0x8025c8
  80025d:	e8 bb 00 00 00       	call   80031d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	53                   	push   %ebx
  800266:	ff 75 10             	pushl  0x10(%ebp)
  800269:	e8 5a 00 00 00       	call   8002c8 <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 d2 24 80 00 	movl   $0x8024d2,(%esp)
  800275:	e8 a3 00 00 00       	call   80031d <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027d:	cc                   	int3   
  80027e:	eb fd                	jmp    80027d <_panic+0x47>

00800280 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800280:	f3 0f 1e fb          	endbr32 
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	53                   	push   %ebx
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80028e:	8b 13                	mov    (%ebx),%edx
  800290:	8d 42 01             	lea    0x1(%edx),%eax
  800293:	89 03                	mov    %eax,(%ebx)
  800295:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800298:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80029c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a1:	74 09                	je     8002ac <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	68 ff 00 00 00       	push   $0xff
  8002b4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b7:	50                   	push   %eax
  8002b8:	e8 dc 09 00 00       	call   800c99 <sys_cputs>
		b->idx = 0;
  8002bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb db                	jmp    8002a3 <putch+0x23>

008002c8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c8:	f3 0f 1e fb          	endbr32 
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002dc:	00 00 00 
	b.cnt = 0;
  8002df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f5:	50                   	push   %eax
  8002f6:	68 80 02 80 00       	push   $0x800280
  8002fb:	e8 20 01 00 00       	call   800420 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800300:	83 c4 08             	add    $0x8,%esp
  800303:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800309:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	e8 84 09 00 00       	call   800c99 <sys_cputs>

	return b.cnt;
}
  800315:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031d:	f3 0f 1e fb          	endbr32 
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800327:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032a:	50                   	push   %eax
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 95 ff ff ff       	call   8002c8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	57                   	push   %edi
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
  80033b:	83 ec 1c             	sub    $0x1c,%esp
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 d6                	mov    %edx,%esi
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	8b 55 0c             	mov    0xc(%ebp),%edx
  800348:	89 d1                	mov    %edx,%ecx
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800362:	39 c2                	cmp    %eax,%edx
  800364:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800367:	72 3e                	jb     8003a7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	ff 75 18             	pushl  0x18(%ebp)
  80036f:	83 eb 01             	sub    $0x1,%ebx
  800372:	53                   	push   %ebx
  800373:	50                   	push   %eax
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037a:	ff 75 e0             	pushl  -0x20(%ebp)
  80037d:	ff 75 dc             	pushl  -0x24(%ebp)
  800380:	ff 75 d8             	pushl  -0x28(%ebp)
  800383:	e8 98 1e 00 00       	call   802220 <__udivdi3>
  800388:	83 c4 18             	add    $0x18,%esp
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	89 f2                	mov    %esi,%edx
  80038f:	89 f8                	mov    %edi,%eax
  800391:	e8 9f ff ff ff       	call   800335 <printnum>
  800396:	83 c4 20             	add    $0x20,%esp
  800399:	eb 13                	jmp    8003ae <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	ff 75 18             	pushl  0x18(%ebp)
  8003a2:	ff d7                	call   *%edi
  8003a4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003a7:	83 eb 01             	sub    $0x1,%ebx
  8003aa:	85 db                	test   %ebx,%ebx
  8003ac:	7f ed                	jg     80039b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	56                   	push   %esi
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003be:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c1:	e8 6a 1f 00 00       	call   802330 <__umoddi3>
  8003c6:	83 c4 14             	add    $0x14,%esp
  8003c9:	0f be 80 eb 25 80 00 	movsbl 0x8025eb(%eax),%eax
  8003d0:	50                   	push   %eax
  8003d1:	ff d7                	call   *%edi
}
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d9:	5b                   	pop    %ebx
  8003da:	5e                   	pop    %esi
  8003db:	5f                   	pop    %edi
  8003dc:	5d                   	pop    %ebp
  8003dd:	c3                   	ret    

008003de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003de:	f3 0f 1e fb          	endbr32 
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f1:	73 0a                	jae    8003fd <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f6:	89 08                	mov    %ecx,(%eax)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	88 02                	mov    %al,(%edx)
}
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <printfmt>:
{
  8003ff:	f3 0f 1e fb          	endbr32 
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800409:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 10             	pushl  0x10(%ebp)
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 05 00 00 00       	call   800420 <vprintfmt>
}
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <vprintfmt>:
{
  800420:	f3 0f 1e fb          	endbr32 
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	57                   	push   %edi
  800428:	56                   	push   %esi
  800429:	53                   	push   %ebx
  80042a:	83 ec 3c             	sub    $0x3c,%esp
  80042d:	8b 75 08             	mov    0x8(%ebp),%esi
  800430:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800433:	8b 7d 10             	mov    0x10(%ebp),%edi
  800436:	e9 8e 03 00 00       	jmp    8007c9 <vprintfmt+0x3a9>
		padc = ' ';
  80043b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80043f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800446:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800454:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8d 47 01             	lea    0x1(%edi),%eax
  80045c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045f:	0f b6 17             	movzbl (%edi),%edx
  800462:	8d 42 dd             	lea    -0x23(%edx),%eax
  800465:	3c 55                	cmp    $0x55,%al
  800467:	0f 87 df 03 00 00    	ja     80084c <vprintfmt+0x42c>
  80046d:	0f b6 c0             	movzbl %al,%eax
  800470:	3e ff 24 85 20 27 80 	notrack jmp *0x802720(,%eax,4)
  800477:	00 
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80047f:	eb d8                	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800484:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800488:	eb cf                	jmp    800459 <vprintfmt+0x39>
  80048a:	0f b6 d2             	movzbl %dl,%edx
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800498:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a5:	83 f9 09             	cmp    $0x9,%ecx
  8004a8:	77 55                	ja     8004ff <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004aa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ad:	eb e9                	jmp    800498 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8d 40 04             	lea    0x4(%eax),%eax
  8004bd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c7:	79 90                	jns    800459 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d6:	eb 81                	jmp    800459 <vprintfmt+0x39>
  8004d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	0f 49 d0             	cmovns %eax,%edx
  8004e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004eb:	e9 69 ff ff ff       	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004fa:	e9 5a ff ff ff       	jmp    800459 <vprintfmt+0x39>
  8004ff:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	eb bc                	jmp    8004c3 <vprintfmt+0xa3>
			lflag++;
  800507:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050d:	e9 47 ff ff ff       	jmp    800459 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 30                	pushl  (%eax)
  80051e:	ff d6                	call   *%esi
			break;
  800520:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800523:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800526:	e9 9b 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 78 04             	lea    0x4(%eax),%edi
  800531:	8b 00                	mov    (%eax),%eax
  800533:	99                   	cltd   
  800534:	31 d0                	xor    %edx,%eax
  800536:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800538:	83 f8 0f             	cmp    $0xf,%eax
  80053b:	7f 23                	jg     800560 <vprintfmt+0x140>
  80053d:	8b 14 85 80 28 80 00 	mov    0x802880(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 18                	je     800560 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800548:	52                   	push   %edx
  800549:	68 31 2b 80 00       	push   $0x802b31
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 aa fe ff ff       	call   8003ff <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055b:	e9 66 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800560:	50                   	push   %eax
  800561:	68 03 26 80 00       	push   $0x802603
  800566:	53                   	push   %ebx
  800567:	56                   	push   %esi
  800568:	e8 92 fe ff ff       	call   8003ff <printfmt>
  80056d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800570:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800573:	e9 4e 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	83 c0 04             	add    $0x4,%eax
  80057e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800586:	85 d2                	test   %edx,%edx
  800588:	b8 fc 25 80 00       	mov    $0x8025fc,%eax
  80058d:	0f 45 c2             	cmovne %edx,%eax
  800590:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x17f>
  800599:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80059d:	75 0d                	jne    8005ac <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	eb 55                	jmp    800601 <vprintfmt+0x1e1>
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b2:	ff 75 cc             	pushl  -0x34(%ebp)
  8005b5:	e8 46 03 00 00       	call   800900 <strnlen>
  8005ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005bd:	29 c2                	sub    %eax,%edx
  8005bf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	85 ff                	test   %edi,%edi
  8005d0:	7e 11                	jle    8005e3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	83 ef 01             	sub    $0x1,%edi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	eb eb                	jmp    8005ce <vprintfmt+0x1ae>
  8005e3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005e6:	85 d2                	test   %edx,%edx
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	0f 49 c2             	cmovns %edx,%eax
  8005f0:	29 c2                	sub    %eax,%edx
  8005f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005f5:	eb a8                	jmp    80059f <vprintfmt+0x17f>
					putch(ch, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	52                   	push   %edx
  8005fc:	ff d6                	call   *%esi
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800604:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800606:	83 c7 01             	add    $0x1,%edi
  800609:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060d:	0f be d0             	movsbl %al,%edx
  800610:	85 d2                	test   %edx,%edx
  800612:	74 4b                	je     80065f <vprintfmt+0x23f>
  800614:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800618:	78 06                	js     800620 <vprintfmt+0x200>
  80061a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80061e:	78 1e                	js     80063e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800620:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800624:	74 d1                	je     8005f7 <vprintfmt+0x1d7>
  800626:	0f be c0             	movsbl %al,%eax
  800629:	83 e8 20             	sub    $0x20,%eax
  80062c:	83 f8 5e             	cmp    $0x5e,%eax
  80062f:	76 c6                	jbe    8005f7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 3f                	push   $0x3f
  800637:	ff d6                	call   *%esi
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb c3                	jmp    800601 <vprintfmt+0x1e1>
  80063e:	89 cf                	mov    %ecx,%edi
  800640:	eb 0e                	jmp    800650 <vprintfmt+0x230>
				putch(' ', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	6a 20                	push   $0x20
  800648:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064a:	83 ef 01             	sub    $0x1,%edi
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	85 ff                	test   %edi,%edi
  800652:	7f ee                	jg     800642 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	e9 67 01 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
  80065f:	89 cf                	mov    %ecx,%edi
  800661:	eb ed                	jmp    800650 <vprintfmt+0x230>
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7f 1b                	jg     800683 <vprintfmt+0x263>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	74 63                	je     8006cf <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	99                   	cltd   
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	eb 17                	jmp    80069a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a5:	85 c9                	test   %ecx,%ecx
  8006a7:	0f 89 ff 00 00 00    	jns    8007ac <vprintfmt+0x38c>
				putch('-', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 2d                	push   $0x2d
  8006b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bb:	f7 da                	neg    %edx
  8006bd:	83 d1 00             	adc    $0x0,%ecx
  8006c0:	f7 d9                	neg    %ecx
  8006c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 dd 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	99                   	cltd   
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	eb b4                	jmp    80069a <vprintfmt+0x27a>
	if (lflag >= 2)
  8006e6:	83 f9 01             	cmp    $0x1,%ecx
  8006e9:	7f 1e                	jg     800709 <vprintfmt+0x2e9>
	else if (lflag)
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	74 32                	je     800721 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800704:	e9 a3 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 10                	mov    (%eax),%edx
  80070e:	8b 48 04             	mov    0x4(%eax),%ecx
  800711:	8d 40 08             	lea    0x8(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80071c:	e9 8b 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 10                	mov    (%eax),%edx
  800726:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800731:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800736:	eb 74                	jmp    8007ac <vprintfmt+0x38c>
	if (lflag >= 2)
  800738:	83 f9 01             	cmp    $0x1,%ecx
  80073b:	7f 1b                	jg     800758 <vprintfmt+0x338>
	else if (lflag)
  80073d:	85 c9                	test   %ecx,%ecx
  80073f:	74 2c                	je     80076d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 10                	mov    (%eax),%edx
  800746:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074b:	8d 40 04             	lea    0x4(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800751:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800756:	eb 54                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	8b 48 04             	mov    0x4(%eax),%ecx
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800766:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80076b:	eb 3f                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 10                	mov    (%eax),%edx
  800772:	b9 00 00 00 00       	mov    $0x0,%ecx
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80077d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800782:	eb 28                	jmp    8007ac <vprintfmt+0x38c>
			putch('0', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	6a 30                	push   $0x30
  80078a:	ff d6                	call   *%esi
			putch('x', putdat);
  80078c:	83 c4 08             	add    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	6a 78                	push   $0x78
  800792:	ff d6                	call   *%esi
			num = (unsigned long long)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 10                	mov    (%eax),%edx
  800799:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80079e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ac:	83 ec 0c             	sub    $0xc,%esp
  8007af:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b3:	57                   	push   %edi
  8007b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	51                   	push   %ecx
  8007b9:	52                   	push   %edx
  8007ba:	89 da                	mov    %ebx,%edx
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	e8 72 fb ff ff       	call   800335 <printnum>
			break;
  8007c3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	83 c7 01             	add    $0x1,%edi
  8007cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d0:	83 f8 25             	cmp    $0x25,%eax
  8007d3:	0f 84 62 fc ff ff    	je     80043b <vprintfmt+0x1b>
			if (ch == '\0')
  8007d9:	85 c0                	test   %eax,%eax
  8007db:	0f 84 8b 00 00 00    	je     80086c <vprintfmt+0x44c>
			putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	50                   	push   %eax
  8007e6:	ff d6                	call   *%esi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	eb dc                	jmp    8007c9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007ed:	83 f9 01             	cmp    $0x1,%ecx
  8007f0:	7f 1b                	jg     80080d <vprintfmt+0x3ed>
	else if (lflag)
  8007f2:	85 c9                	test   %ecx,%ecx
  8007f4:	74 2c                	je     800822 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 10                	mov    (%eax),%edx
  8007fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800800:	8d 40 04             	lea    0x4(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800806:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80080b:	eb 9f                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	8b 48 04             	mov    0x4(%eax),%ecx
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800820:	eb 8a                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 10                	mov    (%eax),%edx
  800827:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082c:	8d 40 04             	lea    0x4(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800832:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800837:	e9 70 ff ff ff       	jmp    8007ac <vprintfmt+0x38c>
			putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	6a 25                	push   $0x25
  800842:	ff d6                	call   *%esi
			break;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	e9 7a ff ff ff       	jmp    8007c6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	89 f8                	mov    %edi,%eax
  800859:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085d:	74 05                	je     800864 <vprintfmt+0x444>
  80085f:	83 e8 01             	sub    $0x1,%eax
  800862:	eb f5                	jmp    800859 <vprintfmt+0x439>
  800864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800867:	e9 5a ff ff ff       	jmp    8007c6 <vprintfmt+0x3a6>
}
  80086c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	f3 0f 1e fb          	endbr32 
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 18             	sub    $0x18,%esp
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800884:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800887:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800895:	85 c0                	test   %eax,%eax
  800897:	74 26                	je     8008bf <vsnprintf+0x4b>
  800899:	85 d2                	test   %edx,%edx
  80089b:	7e 22                	jle    8008bf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089d:	ff 75 14             	pushl  0x14(%ebp)
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a6:	50                   	push   %eax
  8008a7:	68 de 03 80 00       	push   $0x8003de
  8008ac:	e8 6f fb ff ff       	call   800420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_INVAL;
  8008bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c4:	eb f7                	jmp    8008bd <vsnprintf+0x49>

008008c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c6:	f3 0f 1e fb          	endbr32 
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	50                   	push   %eax
  8008d4:	ff 75 10             	pushl  0x10(%ebp)
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 92 ff ff ff       	call   800874 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f7:	74 05                	je     8008fe <strlen+0x1a>
		n++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	eb f5                	jmp    8008f3 <strlen+0xf>
	return n;
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800900:	f3 0f 1e fb          	endbr32 
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	39 d0                	cmp    %edx,%eax
  800914:	74 0d                	je     800923 <strnlen+0x23>
  800916:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091a:	74 05                	je     800921 <strnlen+0x21>
		n++;
  80091c:	83 c0 01             	add    $0x1,%eax
  80091f:	eb f1                	jmp    800912 <strnlen+0x12>
  800921:	89 c2                	mov    %eax,%edx
	return n;
}
  800923:	89 d0                	mov    %edx,%eax
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
  80093a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80093e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800941:	83 c0 01             	add    $0x1,%eax
  800944:	84 d2                	test   %dl,%dl
  800946:	75 f2                	jne    80093a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800948:	89 c8                	mov    %ecx,%eax
  80094a:	5b                   	pop    %ebx
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	83 ec 10             	sub    $0x10,%esp
  800958:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095b:	53                   	push   %ebx
  80095c:	e8 83 ff ff ff       	call   8008e4 <strlen>
  800961:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	01 d8                	add    %ebx,%eax
  800969:	50                   	push   %eax
  80096a:	e8 b8 ff ff ff       	call   800927 <strcpy>
	return dst;
}
  80096f:	89 d8                	mov    %ebx,%eax
  800971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 75 08             	mov    0x8(%ebp),%esi
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	89 f3                	mov    %esi,%ebx
  800987:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098a:	89 f0                	mov    %esi,%eax
  80098c:	39 d8                	cmp    %ebx,%eax
  80098e:	74 11                	je     8009a1 <strncpy+0x2b>
		*dst++ = *src;
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	0f b6 0a             	movzbl (%edx),%ecx
  800996:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800999:	80 f9 01             	cmp    $0x1,%cl
  80099c:	83 da ff             	sbb    $0xffffffff,%edx
  80099f:	eb eb                	jmp    80098c <strncpy+0x16>
	}
	return ret;
}
  8009a1:	89 f0                	mov    %esi,%eax
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a7:	f3 0f 1e fb          	endbr32 
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bb:	85 d2                	test   %edx,%edx
  8009bd:	74 21                	je     8009e0 <strlcpy+0x39>
  8009bf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	74 14                	je     8009dd <strlcpy+0x36>
  8009c9:	0f b6 19             	movzbl (%ecx),%ebx
  8009cc:	84 db                	test   %bl,%bl
  8009ce:	74 0b                	je     8009db <strlcpy+0x34>
			*dst++ = *src++;
  8009d0:	83 c1 01             	add    $0x1,%ecx
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d9:	eb ea                	jmp    8009c5 <strlcpy+0x1e>
  8009db:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e0:	29 f0                	sub    %esi,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e6:	f3 0f 1e fb          	endbr32 
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	84 c0                	test   %al,%al
  8009f8:	74 0c                	je     800a06 <strcmp+0x20>
  8009fa:	3a 02                	cmp    (%edx),%al
  8009fc:	75 08                	jne    800a06 <strcmp+0x20>
		p++, q++;
  8009fe:	83 c1 01             	add    $0x1,%ecx
  800a01:	83 c2 01             	add    $0x1,%edx
  800a04:	eb ed                	jmp    8009f3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a06:	0f b6 c0             	movzbl %al,%eax
  800a09:	0f b6 12             	movzbl (%edx),%edx
  800a0c:	29 d0                	sub    %edx,%eax
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1e:	89 c3                	mov    %eax,%ebx
  800a20:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a23:	eb 06                	jmp    800a2b <strncmp+0x1b>
		n--, p++, q++;
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a2b:	39 d8                	cmp    %ebx,%eax
  800a2d:	74 16                	je     800a45 <strncmp+0x35>
  800a2f:	0f b6 08             	movzbl (%eax),%ecx
  800a32:	84 c9                	test   %cl,%cl
  800a34:	74 04                	je     800a3a <strncmp+0x2a>
  800a36:	3a 0a                	cmp    (%edx),%cl
  800a38:	74 eb                	je     800a25 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3a:	0f b6 00             	movzbl (%eax),%eax
  800a3d:	0f b6 12             	movzbl (%edx),%edx
  800a40:	29 d0                	sub    %edx,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    
		return 0;
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	eb f6                	jmp    800a42 <strncmp+0x32>

00800a4c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5a:	0f b6 10             	movzbl (%eax),%edx
  800a5d:	84 d2                	test   %dl,%dl
  800a5f:	74 09                	je     800a6a <strchr+0x1e>
		if (*s == c)
  800a61:	38 ca                	cmp    %cl,%dl
  800a63:	74 0a                	je     800a6f <strchr+0x23>
	for (; *s; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f0                	jmp    800a5a <strchr+0xe>
			return (char *) s;
	return 0;
  800a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 09                	je     800a8f <strfind+0x1e>
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 05                	je     800a8f <strfind+0x1e>
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	eb f0                	jmp    800a7f <strfind+0xe>
			break;
	return (char *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a91:	f3 0f 1e fb          	endbr32 
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	57                   	push   %edi
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa1:	85 c9                	test   %ecx,%ecx
  800aa3:	74 31                	je     800ad6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa5:	89 f8                	mov    %edi,%eax
  800aa7:	09 c8                	or     %ecx,%eax
  800aa9:	a8 03                	test   $0x3,%al
  800aab:	75 23                	jne    800ad0 <memset+0x3f>
		c &= 0xFF;
  800aad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab1:	89 d3                	mov    %edx,%ebx
  800ab3:	c1 e3 08             	shl    $0x8,%ebx
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	c1 e0 18             	shl    $0x18,%eax
  800abb:	89 d6                	mov    %edx,%esi
  800abd:	c1 e6 10             	shl    $0x10,%esi
  800ac0:	09 f0                	or     %esi,%eax
  800ac2:	09 c2                	or     %eax,%edx
  800ac4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	fc                   	cld    
  800acc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ace:	eb 06                	jmp    800ad6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	fc                   	cld    
  800ad4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad6:	89 f8                	mov    %edi,%eax
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800add:	f3 0f 1e fb          	endbr32 
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	57                   	push   %edi
  800ae5:	56                   	push   %esi
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aef:	39 c6                	cmp    %eax,%esi
  800af1:	73 32                	jae    800b25 <memmove+0x48>
  800af3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	76 2b                	jbe    800b25 <memmove+0x48>
		s += n;
		d += n;
  800afa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afd:	89 fe                	mov    %edi,%esi
  800aff:	09 ce                	or     %ecx,%esi
  800b01:	09 d6                	or     %edx,%esi
  800b03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b09:	75 0e                	jne    800b19 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0b:	83 ef 04             	sub    $0x4,%edi
  800b0e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b14:	fd                   	std    
  800b15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b17:	eb 09                	jmp    800b22 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b19:	83 ef 01             	sub    $0x1,%edi
  800b1c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1f:	fd                   	std    
  800b20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b22:	fc                   	cld    
  800b23:	eb 1a                	jmp    800b3f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	09 ca                	or     %ecx,%edx
  800b29:	09 f2                	or     %esi,%edx
  800b2b:	f6 c2 03             	test   $0x3,%dl
  800b2e:	75 0a                	jne    800b3a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b30:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b38:	eb 05                	jmp    800b3f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b3a:	89 c7                	mov    %eax,%edi
  800b3c:	fc                   	cld    
  800b3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b43:	f3 0f 1e fb          	endbr32 
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4d:	ff 75 10             	pushl  0x10(%ebp)
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	ff 75 08             	pushl  0x8(%ebp)
  800b56:	e8 82 ff ff ff       	call   800add <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 c6                	mov    %eax,%esi
  800b6e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b71:	39 f0                	cmp    %esi,%eax
  800b73:	74 1c                	je     800b91 <memcmp+0x34>
		if (*s1 != *s2)
  800b75:	0f b6 08             	movzbl (%eax),%ecx
  800b78:	0f b6 1a             	movzbl (%edx),%ebx
  800b7b:	38 d9                	cmp    %bl,%cl
  800b7d:	75 08                	jne    800b87 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7f:	83 c0 01             	add    $0x1,%eax
  800b82:	83 c2 01             	add    $0x1,%edx
  800b85:	eb ea                	jmp    800b71 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b87:	0f b6 c1             	movzbl %cl,%eax
  800b8a:	0f b6 db             	movzbl %bl,%ebx
  800b8d:	29 d8                	sub    %ebx,%eax
  800b8f:	eb 05                	jmp    800b96 <memcmp+0x39>
	}

	return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9a:	f3 0f 1e fb          	endbr32 
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba7:	89 c2                	mov    %eax,%edx
  800ba9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bac:	39 d0                	cmp    %edx,%eax
  800bae:	73 09                	jae    800bb9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb0:	38 08                	cmp    %cl,(%eax)
  800bb2:	74 05                	je     800bb9 <memfind+0x1f>
	for (; s < ends; s++)
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	eb f3                	jmp    800bac <memfind+0x12>
			break;
	return (void *) s;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbb:	f3 0f 1e fb          	endbr32 
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcb:	eb 03                	jmp    800bd0 <strtol+0x15>
		s++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd0:	0f b6 01             	movzbl (%ecx),%eax
  800bd3:	3c 20                	cmp    $0x20,%al
  800bd5:	74 f6                	je     800bcd <strtol+0x12>
  800bd7:	3c 09                	cmp    $0x9,%al
  800bd9:	74 f2                	je     800bcd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bdb:	3c 2b                	cmp    $0x2b,%al
  800bdd:	74 2a                	je     800c09 <strtol+0x4e>
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be4:	3c 2d                	cmp    $0x2d,%al
  800be6:	74 2b                	je     800c13 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bee:	75 0f                	jne    800bff <strtol+0x44>
  800bf0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf3:	74 28                	je     800c1d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	0f 44 d8             	cmove  %eax,%ebx
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c07:	eb 46                	jmp    800c4f <strtol+0x94>
		s++;
  800c09:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c11:	eb d5                	jmp    800be8 <strtol+0x2d>
		s++, neg = 1;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1b:	eb cb                	jmp    800be8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c21:	74 0e                	je     800c31 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	75 d8                	jne    800bff <strtol+0x44>
		s++, base = 8;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2f:	eb ce                	jmp    800bff <strtol+0x44>
		s += 2, base = 16;
  800c31:	83 c1 02             	add    $0x2,%ecx
  800c34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c39:	eb c4                	jmp    800bff <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c41:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c44:	7d 3a                	jge    800c80 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c4d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4f:	0f b6 11             	movzbl (%ecx),%edx
  800c52:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c55:	89 f3                	mov    %esi,%ebx
  800c57:	80 fb 09             	cmp    $0x9,%bl
  800c5a:	76 df                	jbe    800c3b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 08                	ja     800c6e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 57             	sub    $0x57,%edx
  800c6c:	eb d3                	jmp    800c41 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c6e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 19             	cmp    $0x19,%bl
  800c76:	77 08                	ja     800c80 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 37             	sub    $0x37,%edx
  800c7e:	eb c1                	jmp    800c41 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c84:	74 05                	je     800c8b <strtol+0xd0>
		*endptr = (char *) s;
  800c86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c89:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	85 ff                	test   %edi,%edi
  800c91:	0f 45 c2             	cmovne %edx,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cae:	89 c3                	mov    %eax,%ebx
  800cb0:	89 c7                	mov    %eax,%edi
  800cb2:	89 c6                	mov    %eax,%esi
  800cb4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_cgetc>:

int
sys_cgetc(void)
{
  800cbb:	f3 0f 1e fb          	endbr32 
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cca:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 d3                	mov    %edx,%ebx
  800cd3:	89 d7                	mov    %edx,%edi
  800cd5:	89 d6                	mov    %edx,%esi
  800cd7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	89 cb                	mov    %ecx,%ebx
  800cfa:	89 cf                	mov    %ecx,%edi
  800cfc:	89 ce                	mov    %ecx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 03                	push   $0x3
  800d12:	68 df 28 80 00       	push   $0x8028df
  800d17:	6a 23                	push   $0x23
  800d19:	68 fc 28 80 00       	push   $0x8028fc
  800d1e:	e8 13 f5 ff ff       	call   800236 <_panic>

00800d23 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 02 00 00 00       	mov    $0x2,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_yield>:

void
sys_yield(void)
{
  800d46:	f3 0f 1e fb          	endbr32 
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	be 00 00 00 00       	mov    $0x0,%esi
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 04 00 00 00       	mov    $0x4,%eax
  800d86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d89:	89 f7                	mov    %esi,%edi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 04                	push   $0x4
  800d9f:	68 df 28 80 00       	push   $0x8028df
  800da4:	6a 23                	push   $0x23
  800da6:	68 fc 28 80 00       	push   $0x8028fc
  800dab:	e8 86 f4 ff ff       	call   800236 <_panic>

00800db0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dce:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 05                	push   $0x5
  800de5:	68 df 28 80 00       	push   $0x8028df
  800dea:	6a 23                	push   $0x23
  800dec:	68 fc 28 80 00       	push   $0x8028fc
  800df1:	e8 40 f4 ff ff       	call   800236 <_panic>

00800df6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df6:	f3 0f 1e fb          	endbr32 
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 06                	push   $0x6
  800e2b:	68 df 28 80 00       	push   $0x8028df
  800e30:	6a 23                	push   $0x23
  800e32:	68 fc 28 80 00       	push   $0x8028fc
  800e37:	e8 fa f3 ff ff       	call   800236 <_panic>

00800e3c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	b8 08 00 00 00       	mov    $0x8,%eax
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	89 de                	mov    %ebx,%esi
  800e5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 08                	push   $0x8
  800e71:	68 df 28 80 00       	push   $0x8028df
  800e76:	6a 23                	push   $0x23
  800e78:	68 fc 28 80 00       	push   $0x8028fc
  800e7d:	e8 b4 f3 ff ff       	call   800236 <_panic>

00800e82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e82:	f3 0f 1e fb          	endbr32 
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 09                	push   $0x9
  800eb7:	68 df 28 80 00       	push   $0x8028df
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 fc 28 80 00       	push   $0x8028fc
  800ec3:	e8 6e f3 ff ff       	call   800236 <_panic>

00800ec8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec8:	f3 0f 1e fb          	endbr32 
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee5:	89 df                	mov    %ebx,%edi
  800ee7:	89 de                	mov    %ebx,%esi
  800ee9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	7f 08                	jg     800ef7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	83 ec 0c             	sub    $0xc,%esp
  800efa:	50                   	push   %eax
  800efb:	6a 0a                	push   $0xa
  800efd:	68 df 28 80 00       	push   $0x8028df
  800f02:	6a 23                	push   $0x23
  800f04:	68 fc 28 80 00       	push   $0x8028fc
  800f09:	e8 28 f3 ff ff       	call   800236 <_panic>

00800f0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0e:	f3 0f 1e fb          	endbr32 
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f23:	be 00 00 00 00       	mov    $0x0,%esi
  800f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7f 08                	jg     800f63 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	50                   	push   %eax
  800f67:	6a 0d                	push   $0xd
  800f69:	68 df 28 80 00       	push   $0x8028df
  800f6e:	6a 23                	push   $0x23
  800f70:	68 fc 28 80 00       	push   $0x8028fc
  800f75:	e8 bc f2 ff ff       	call   800236 <_panic>

00800f7a <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800f7a:	f3 0f 1e fb          	endbr32 
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f86:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f88:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f8c:	74 7f                	je     80100d <pgfault+0x93>
  800f8e:	89 f0                	mov    %esi,%eax
  800f90:	c1 e8 0c             	shr    $0xc,%eax
  800f93:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f9a:	f6 c4 08             	test   $0x8,%ah
  800f9d:	74 6e                	je     80100d <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800f9f:	e8 7f fd ff ff       	call   800d23 <sys_getenvid>
  800fa4:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800fa6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800fac:	83 ec 04             	sub    $0x4,%esp
  800faf:	6a 07                	push   $0x7
  800fb1:	68 00 f0 7f 00       	push   $0x7ff000
  800fb6:	50                   	push   %eax
  800fb7:	e8 ad fd ff ff       	call   800d69 <sys_page_alloc>
  800fbc:	83 c4 10             	add    $0x10,%esp
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	78 5e                	js     801021 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800fc3:	83 ec 04             	sub    $0x4,%esp
  800fc6:	68 00 10 00 00       	push   $0x1000
  800fcb:	56                   	push   %esi
  800fcc:	68 00 f0 7f 00       	push   $0x7ff000
  800fd1:	e8 6d fb ff ff       	call   800b43 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800fd6:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	68 00 f0 7f 00       	push   $0x7ff000
  800fe4:	53                   	push   %ebx
  800fe5:	e8 c6 fd ff ff       	call   800db0 <sys_page_map>
  800fea:	83 c4 20             	add    $0x20,%esp
  800fed:	85 c0                	test   %eax,%eax
  800fef:	78 44                	js     801035 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	68 00 f0 7f 00       	push   $0x7ff000
  800ff9:	53                   	push   %ebx
  800ffa:	e8 f7 fd ff ff       	call   800df6 <sys_page_unmap>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	85 c0                	test   %eax,%eax
  801004:	78 43                	js     801049 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  801006:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  80100d:	83 ec 04             	sub    $0x4,%esp
  801010:	68 0a 29 80 00       	push   $0x80290a
  801015:	6a 1e                	push   $0x1e
  801017:	68 27 29 80 00       	push   $0x802927
  80101c:	e8 15 f2 ff ff       	call   800236 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  801021:	83 ec 04             	sub    $0x4,%esp
  801024:	68 b8 29 80 00       	push   $0x8029b8
  801029:	6a 2b                	push   $0x2b
  80102b:	68 27 29 80 00       	push   $0x802927
  801030:	e8 01 f2 ff ff       	call   800236 <_panic>
		panic("pgfault: sys_page_map Failed!");
  801035:	83 ec 04             	sub    $0x4,%esp
  801038:	68 32 29 80 00       	push   $0x802932
  80103d:	6a 2f                	push   $0x2f
  80103f:	68 27 29 80 00       	push   $0x802927
  801044:	e8 ed f1 ff ff       	call   800236 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	68 d8 29 80 00       	push   $0x8029d8
  801051:	6a 32                	push   $0x32
  801053:	68 27 29 80 00       	push   $0x802927
  801058:	e8 d9 f1 ff ff       	call   800236 <_panic>

0080105d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80105d:	f3 0f 1e fb          	endbr32 
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
  801067:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80106a:	68 7a 0f 80 00       	push   $0x800f7a
  80106f:	e8 be 0f 00 00       	call   802032 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801074:	b8 07 00 00 00       	mov    $0x7,%eax
  801079:	cd 30                	int    $0x30
  80107b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80107e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	85 c0                	test   %eax,%eax
  801086:	78 2b                	js     8010b3 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801088:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  80108d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801091:	0f 85 ba 00 00 00    	jne    801151 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  801097:	e8 87 fc ff ff       	call   800d23 <sys_getenvid>
  80109c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a9:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8010ae:	e9 90 01 00 00       	jmp    801243 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	68 50 29 80 00       	push   $0x802950
  8010bb:	6a 76                	push   $0x76
  8010bd:	68 27 29 80 00       	push   $0x802927
  8010c2:	e8 6f f1 ff ff       	call   800236 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  8010c7:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  8010ce:	e8 50 fc ff ff       	call   800d23 <sys_getenvid>
  8010d3:	83 ec 0c             	sub    $0xc,%esp
  8010d6:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  8010dc:	56                   	push   %esi
  8010dd:	57                   	push   %edi
  8010de:	ff 75 e0             	pushl  -0x20(%ebp)
  8010e1:	57                   	push   %edi
  8010e2:	50                   	push   %eax
  8010e3:	e8 c8 fc ff ff       	call   800db0 <sys_page_map>
  8010e8:	83 c4 20             	add    $0x20,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	79 50                	jns    80113f <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	68 69 29 80 00       	push   $0x802969
  8010f7:	6a 4b                	push   $0x4b
  8010f9:	68 27 29 80 00       	push   $0x802927
  8010fe:	e8 33 f1 ff ff       	call   800236 <_panic>
			panic("duppage:child sys_page_map Failed!");
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	68 f8 29 80 00       	push   $0x8029f8
  80110b:	6a 50                	push   $0x50
  80110d:	68 27 29 80 00       	push   $0x802927
  801112:	e8 1f f1 ff ff       	call   800236 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  801117:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80111e:	83 ec 0c             	sub    $0xc,%esp
  801121:	25 07 0e 00 00       	and    $0xe07,%eax
  801126:	50                   	push   %eax
  801127:	57                   	push   %edi
  801128:	ff 75 e0             	pushl  -0x20(%ebp)
  80112b:	57                   	push   %edi
  80112c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80112f:	e8 7c fc ff ff       	call   800db0 <sys_page_map>
  801134:	83 c4 20             	add    $0x20,%esp
  801137:	85 c0                	test   %eax,%eax
  801139:	0f 88 b4 00 00 00    	js     8011f3 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  80113f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801145:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80114b:	0f 84 b6 00 00 00    	je     801207 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801151:	89 d8                	mov    %ebx,%eax
  801153:	c1 e8 16             	shr    $0x16,%eax
  801156:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115d:	a8 01                	test   $0x1,%al
  80115f:	74 de                	je     80113f <fork+0xe2>
  801161:	89 de                	mov    %ebx,%esi
  801163:	c1 ee 0c             	shr    $0xc,%esi
  801166:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80116d:	a8 01                	test   $0x1,%al
  80116f:	74 ce                	je     80113f <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801171:	e8 ad fb ff ff       	call   800d23 <sys_getenvid>
  801176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801179:	89 f7                	mov    %esi,%edi
  80117b:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80117e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801185:	f6 c4 04             	test   $0x4,%ah
  801188:	0f 85 39 ff ff ff    	jne    8010c7 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80118e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801195:	a9 02 08 00 00       	test   $0x802,%eax
  80119a:	0f 84 77 ff ff ff    	je     801117 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  8011a0:	83 ec 0c             	sub    $0xc,%esp
  8011a3:	68 05 08 00 00       	push   $0x805
  8011a8:	57                   	push   %edi
  8011a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8011ac:	57                   	push   %edi
  8011ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b0:	e8 fb fb ff ff       	call   800db0 <sys_page_map>
  8011b5:	83 c4 20             	add    $0x20,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	0f 88 43 ff ff ff    	js     801103 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8011c0:	83 ec 0c             	sub    $0xc,%esp
  8011c3:	68 05 08 00 00       	push   $0x805
  8011c8:	57                   	push   %edi
  8011c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011cc:	50                   	push   %eax
  8011cd:	57                   	push   %edi
  8011ce:	50                   	push   %eax
  8011cf:	e8 dc fb ff ff       	call   800db0 <sys_page_map>
  8011d4:	83 c4 20             	add    $0x20,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	0f 89 60 ff ff ff    	jns    80113f <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	68 1c 2a 80 00       	push   $0x802a1c
  8011e7:	6a 52                	push   $0x52
  8011e9:	68 27 29 80 00       	push   $0x802927
  8011ee:	e8 43 f0 ff ff       	call   800236 <_panic>
			panic("duppage: single sys_page_map Failed!");
  8011f3:	83 ec 04             	sub    $0x4,%esp
  8011f6:	68 40 2a 80 00       	push   $0x802a40
  8011fb:	6a 56                	push   $0x56
  8011fd:	68 27 29 80 00       	push   $0x802927
  801202:	e8 2f f0 ff ff       	call   800236 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	6a 07                	push   $0x7
  80120c:	68 00 f0 bf ee       	push   $0xeebff000
  801211:	ff 75 dc             	pushl  -0x24(%ebp)
  801214:	e8 50 fb ff ff       	call   800d69 <sys_page_alloc>
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	85 c0                	test   %eax,%eax
  80121e:	78 2e                	js     80124e <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801220:	83 ec 08             	sub    $0x8,%esp
  801223:	68 ae 20 80 00       	push   $0x8020ae
  801228:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80122b:	57                   	push   %edi
  80122c:	e8 97 fc ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801231:	83 c4 08             	add    $0x8,%esp
  801234:	6a 02                	push   $0x2
  801236:	57                   	push   %edi
  801237:	e8 00 fc ff ff       	call   800e3c <sys_env_set_status>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	78 22                	js     801265 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801243:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  80124e:	83 ec 04             	sub    $0x4,%esp
  801251:	68 86 29 80 00       	push   $0x802986
  801256:	68 83 00 00 00       	push   $0x83
  80125b:	68 27 29 80 00       	push   $0x802927
  801260:	e8 d1 ef ff ff       	call   800236 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801265:	83 ec 04             	sub    $0x4,%esp
  801268:	68 68 2a 80 00       	push   $0x802a68
  80126d:	68 89 00 00 00       	push   $0x89
  801272:	68 27 29 80 00       	push   $0x802927
  801277:	e8 ba ef ff ff       	call   800236 <_panic>

0080127c <sfork>:

// Challenge!
int
sfork(void)
{
  80127c:	f3 0f 1e fb          	endbr32 
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801286:	68 a2 29 80 00       	push   $0x8029a2
  80128b:	68 93 00 00 00       	push   $0x93
  801290:	68 27 29 80 00       	push   $0x802927
  801295:	e8 9c ef ff ff       	call   800236 <_panic>

0080129a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80129a:	f3 0f 1e fb          	endbr32 
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	05 00 00 00 30       	add    $0x30000000,%eax
  8012a9:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012ae:	f3 0f 1e fb          	endbr32 
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012c9:	f3 0f 1e fb          	endbr32 
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	c1 ea 16             	shr    $0x16,%edx
  8012da:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e1:	f6 c2 01             	test   $0x1,%dl
  8012e4:	74 2d                	je     801313 <fd_alloc+0x4a>
  8012e6:	89 c2                	mov    %eax,%edx
  8012e8:	c1 ea 0c             	shr    $0xc,%edx
  8012eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f2:	f6 c2 01             	test   $0x1,%dl
  8012f5:	74 1c                	je     801313 <fd_alloc+0x4a>
  8012f7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012fc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801301:	75 d2                	jne    8012d5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80130c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801311:	eb 0a                	jmp    80131d <fd_alloc+0x54>
			*fd_store = fd;
  801313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801316:	89 01                	mov    %eax,(%ecx)
			return 0;
  801318:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80131f:	f3 0f 1e fb          	endbr32 
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801329:	83 f8 1f             	cmp    $0x1f,%eax
  80132c:	77 30                	ja     80135e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80132e:	c1 e0 0c             	shl    $0xc,%eax
  801331:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801336:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80133c:	f6 c2 01             	test   $0x1,%dl
  80133f:	74 24                	je     801365 <fd_lookup+0x46>
  801341:	89 c2                	mov    %eax,%edx
  801343:	c1 ea 0c             	shr    $0xc,%edx
  801346:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134d:	f6 c2 01             	test   $0x1,%dl
  801350:	74 1a                	je     80136c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	89 02                	mov    %eax,(%edx)
	return 0;
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    
		return -E_INVAL;
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801363:	eb f7                	jmp    80135c <fd_lookup+0x3d>
		return -E_INVAL;
  801365:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136a:	eb f0                	jmp    80135c <fd_lookup+0x3d>
  80136c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801371:	eb e9                	jmp    80135c <fd_lookup+0x3d>

00801373 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801373:	f3 0f 1e fb          	endbr32 
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 08             	sub    $0x8,%esp
  80137d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801380:	ba 08 2b 80 00       	mov    $0x802b08,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801385:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80138a:	39 08                	cmp    %ecx,(%eax)
  80138c:	74 33                	je     8013c1 <dev_lookup+0x4e>
  80138e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801391:	8b 02                	mov    (%edx),%eax
  801393:	85 c0                	test   %eax,%eax
  801395:	75 f3                	jne    80138a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801397:	a1 20 44 80 00       	mov    0x804420,%eax
  80139c:	8b 40 48             	mov    0x48(%eax),%eax
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	51                   	push   %ecx
  8013a3:	50                   	push   %eax
  8013a4:	68 8c 2a 80 00       	push   $0x802a8c
  8013a9:	e8 6f ef ff ff       	call   80031d <cprintf>
	*dev = 0;
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    
			*dev = devtab[i];
  8013c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cb:	eb f2                	jmp    8013bf <dev_lookup+0x4c>

008013cd <fd_close>:
{
  8013cd:	f3 0f 1e fb          	endbr32 
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	57                   	push   %edi
  8013d5:	56                   	push   %esi
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 24             	sub    $0x24,%esp
  8013da:	8b 75 08             	mov    0x8(%ebp),%esi
  8013dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013ea:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ed:	50                   	push   %eax
  8013ee:	e8 2c ff ff ff       	call   80131f <fd_lookup>
  8013f3:	89 c3                	mov    %eax,%ebx
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 05                	js     801401 <fd_close+0x34>
	    || fd != fd2)
  8013fc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013ff:	74 16                	je     801417 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801401:	89 f8                	mov    %edi,%eax
  801403:	84 c0                	test   %al,%al
  801405:	b8 00 00 00 00       	mov    $0x0,%eax
  80140a:	0f 44 d8             	cmove  %eax,%ebx
}
  80140d:	89 d8                	mov    %ebx,%eax
  80140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80141d:	50                   	push   %eax
  80141e:	ff 36                	pushl  (%esi)
  801420:	e8 4e ff ff ff       	call   801373 <dev_lookup>
  801425:	89 c3                	mov    %eax,%ebx
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 1a                	js     801448 <fd_close+0x7b>
		if (dev->dev_close)
  80142e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801431:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801434:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801439:	85 c0                	test   %eax,%eax
  80143b:	74 0b                	je     801448 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	56                   	push   %esi
  801441:	ff d0                	call   *%eax
  801443:	89 c3                	mov    %eax,%ebx
  801445:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	56                   	push   %esi
  80144c:	6a 00                	push   $0x0
  80144e:	e8 a3 f9 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	eb b5                	jmp    80140d <fd_close+0x40>

00801458 <close>:

int
close(int fdnum)
{
  801458:	f3 0f 1e fb          	endbr32 
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 b1 fe ff ff       	call   80131f <fd_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	79 02                	jns    801477 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    
		return fd_close(fd, 1);
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	6a 01                	push   $0x1
  80147c:	ff 75 f4             	pushl  -0xc(%ebp)
  80147f:	e8 49 ff ff ff       	call   8013cd <fd_close>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	eb ec                	jmp    801475 <close+0x1d>

00801489 <close_all>:

void
close_all(void)
{
  801489:	f3 0f 1e fb          	endbr32 
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	53                   	push   %ebx
  801491:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801494:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	53                   	push   %ebx
  80149d:	e8 b6 ff ff ff       	call   801458 <close>
	for (i = 0; i < MAXFD; i++)
  8014a2:	83 c3 01             	add    $0x1,%ebx
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	83 fb 20             	cmp    $0x20,%ebx
  8014ab:	75 ec                	jne    801499 <close_all+0x10>
}
  8014ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014b2:	f3 0f 1e fb          	endbr32 
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	57                   	push   %edi
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	ff 75 08             	pushl  0x8(%ebp)
  8014c6:	e8 54 fe ff ff       	call   80131f <fd_lookup>
  8014cb:	89 c3                	mov    %eax,%ebx
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	0f 88 81 00 00 00    	js     801559 <dup+0xa7>
		return r;
	close(newfdnum);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	e8 75 ff ff ff       	call   801458 <close>

	newfd = INDEX2FD(newfdnum);
  8014e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e6:	c1 e6 0c             	shl    $0xc,%esi
  8014e9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014ef:	83 c4 04             	add    $0x4,%esp
  8014f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014f5:	e8 b4 fd ff ff       	call   8012ae <fd2data>
  8014fa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014fc:	89 34 24             	mov    %esi,(%esp)
  8014ff:	e8 aa fd ff ff       	call   8012ae <fd2data>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801509:	89 d8                	mov    %ebx,%eax
  80150b:	c1 e8 16             	shr    $0x16,%eax
  80150e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801515:	a8 01                	test   $0x1,%al
  801517:	74 11                	je     80152a <dup+0x78>
  801519:	89 d8                	mov    %ebx,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
  80151e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801525:	f6 c2 01             	test   $0x1,%dl
  801528:	75 39                	jne    801563 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80152d:	89 d0                	mov    %edx,%eax
  80152f:	c1 e8 0c             	shr    $0xc,%eax
  801532:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	25 07 0e 00 00       	and    $0xe07,%eax
  801541:	50                   	push   %eax
  801542:	56                   	push   %esi
  801543:	6a 00                	push   $0x0
  801545:	52                   	push   %edx
  801546:	6a 00                	push   $0x0
  801548:	e8 63 f8 ff ff       	call   800db0 <sys_page_map>
  80154d:	89 c3                	mov    %eax,%ebx
  80154f:	83 c4 20             	add    $0x20,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	78 31                	js     801587 <dup+0xd5>
		goto err;

	return newfdnum;
  801556:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801559:	89 d8                	mov    %ebx,%eax
  80155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801563:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	25 07 0e 00 00       	and    $0xe07,%eax
  801572:	50                   	push   %eax
  801573:	57                   	push   %edi
  801574:	6a 00                	push   $0x0
  801576:	53                   	push   %ebx
  801577:	6a 00                	push   $0x0
  801579:	e8 32 f8 ff ff       	call   800db0 <sys_page_map>
  80157e:	89 c3                	mov    %eax,%ebx
  801580:	83 c4 20             	add    $0x20,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	79 a3                	jns    80152a <dup+0x78>
	sys_page_unmap(0, newfd);
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	56                   	push   %esi
  80158b:	6a 00                	push   $0x0
  80158d:	e8 64 f8 ff ff       	call   800df6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801592:	83 c4 08             	add    $0x8,%esp
  801595:	57                   	push   %edi
  801596:	6a 00                	push   $0x0
  801598:	e8 59 f8 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	eb b7                	jmp    801559 <dup+0xa7>

008015a2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015a2:	f3 0f 1e fb          	endbr32 
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 1c             	sub    $0x1c,%esp
  8015ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b3:	50                   	push   %eax
  8015b4:	53                   	push   %ebx
  8015b5:	e8 65 fd ff ff       	call   80131f <fd_lookup>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 3f                	js     801600 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	ff 30                	pushl  (%eax)
  8015cd:	e8 a1 fd ff ff       	call   801373 <dev_lookup>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 27                	js     801600 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015dc:	8b 42 08             	mov    0x8(%edx),%eax
  8015df:	83 e0 03             	and    $0x3,%eax
  8015e2:	83 f8 01             	cmp    $0x1,%eax
  8015e5:	74 1e                	je     801605 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 40 08             	mov    0x8(%eax),%eax
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 35                	je     801626 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	ff 75 10             	pushl  0x10(%ebp)
  8015f7:	ff 75 0c             	pushl  0xc(%ebp)
  8015fa:	52                   	push   %edx
  8015fb:	ff d0                	call   *%eax
  8015fd:	83 c4 10             	add    $0x10,%esp
}
  801600:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801603:	c9                   	leave  
  801604:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801605:	a1 20 44 80 00       	mov    0x804420,%eax
  80160a:	8b 40 48             	mov    0x48(%eax),%eax
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	53                   	push   %ebx
  801611:	50                   	push   %eax
  801612:	68 cd 2a 80 00       	push   $0x802acd
  801617:	e8 01 ed ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801624:	eb da                	jmp    801600 <read+0x5e>
		return -E_NOT_SUPP;
  801626:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162b:	eb d3                	jmp    801600 <read+0x5e>

0080162d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80162d:	f3 0f 1e fb          	endbr32 
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	57                   	push   %edi
  801635:	56                   	push   %esi
  801636:	53                   	push   %ebx
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80163d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801640:	bb 00 00 00 00       	mov    $0x0,%ebx
  801645:	eb 02                	jmp    801649 <readn+0x1c>
  801647:	01 c3                	add    %eax,%ebx
  801649:	39 f3                	cmp    %esi,%ebx
  80164b:	73 21                	jae    80166e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	89 f0                	mov    %esi,%eax
  801652:	29 d8                	sub    %ebx,%eax
  801654:	50                   	push   %eax
  801655:	89 d8                	mov    %ebx,%eax
  801657:	03 45 0c             	add    0xc(%ebp),%eax
  80165a:	50                   	push   %eax
  80165b:	57                   	push   %edi
  80165c:	e8 41 ff ff ff       	call   8015a2 <read>
		if (m < 0)
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 04                	js     80166c <readn+0x3f>
			return m;
		if (m == 0)
  801668:	75 dd                	jne    801647 <readn+0x1a>
  80166a:	eb 02                	jmp    80166e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80166c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80166e:	89 d8                	mov    %ebx,%eax
  801670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5f                   	pop    %edi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801678:	f3 0f 1e fb          	endbr32 
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	53                   	push   %ebx
  801680:	83 ec 1c             	sub    $0x1c,%esp
  801683:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801686:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801689:	50                   	push   %eax
  80168a:	53                   	push   %ebx
  80168b:	e8 8f fc ff ff       	call   80131f <fd_lookup>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	78 3a                	js     8016d1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a1:	ff 30                	pushl  (%eax)
  8016a3:	e8 cb fc ff ff       	call   801373 <dev_lookup>
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 22                	js     8016d1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b6:	74 1e                	je     8016d6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8016be:	85 d2                	test   %edx,%edx
  8016c0:	74 35                	je     8016f7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	ff 75 10             	pushl  0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	50                   	push   %eax
  8016cc:	ff d2                	call   *%edx
  8016ce:	83 c4 10             	add    $0x10,%esp
}
  8016d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016d6:	a1 20 44 80 00       	mov    0x804420,%eax
  8016db:	8b 40 48             	mov    0x48(%eax),%eax
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	53                   	push   %ebx
  8016e2:	50                   	push   %eax
  8016e3:	68 e9 2a 80 00       	push   $0x802ae9
  8016e8:	e8 30 ec ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f5:	eb da                	jmp    8016d1 <write+0x59>
		return -E_NOT_SUPP;
  8016f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fc:	eb d3                	jmp    8016d1 <write+0x59>

008016fe <seek>:

int
seek(int fdnum, off_t offset)
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801708:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170b:	50                   	push   %eax
  80170c:	ff 75 08             	pushl  0x8(%ebp)
  80170f:	e8 0b fc ff ff       	call   80131f <fd_lookup>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	78 0e                	js     801729 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801721:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80172b:	f3 0f 1e fb          	endbr32 
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	53                   	push   %ebx
  801733:	83 ec 1c             	sub    $0x1c,%esp
  801736:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801739:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173c:	50                   	push   %eax
  80173d:	53                   	push   %ebx
  80173e:	e8 dc fb ff ff       	call   80131f <fd_lookup>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 37                	js     801781 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801750:	50                   	push   %eax
  801751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801754:	ff 30                	pushl  (%eax)
  801756:	e8 18 fc ff ff       	call   801373 <dev_lookup>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 1f                	js     801781 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801769:	74 1b                	je     801786 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80176b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176e:	8b 52 18             	mov    0x18(%edx),%edx
  801771:	85 d2                	test   %edx,%edx
  801773:	74 32                	je     8017a7 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	50                   	push   %eax
  80177c:	ff d2                	call   *%edx
  80177e:	83 c4 10             	add    $0x10,%esp
}
  801781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801784:	c9                   	leave  
  801785:	c3                   	ret    
			thisenv->env_id, fdnum);
  801786:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80178b:	8b 40 48             	mov    0x48(%eax),%eax
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	53                   	push   %ebx
  801792:	50                   	push   %eax
  801793:	68 ac 2a 80 00       	push   $0x802aac
  801798:	e8 80 eb ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a5:	eb da                	jmp    801781 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ac:	eb d3                	jmp    801781 <ftruncate+0x56>

008017ae <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ae:	f3 0f 1e fb          	endbr32 
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	53                   	push   %ebx
  8017b6:	83 ec 1c             	sub    $0x1c,%esp
  8017b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bf:	50                   	push   %eax
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	e8 57 fb ff ff       	call   80131f <fd_lookup>
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 4b                	js     80181a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	50                   	push   %eax
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	ff 30                	pushl  (%eax)
  8017db:	e8 93 fb ff ff       	call   801373 <dev_lookup>
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 33                	js     80181a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017ee:	74 2f                	je     80181f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017fa:	00 00 00 
	stat->st_isdir = 0;
  8017fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801804:	00 00 00 
	stat->st_dev = dev;
  801807:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	53                   	push   %ebx
  801811:	ff 75 f0             	pushl  -0x10(%ebp)
  801814:	ff 50 14             	call   *0x14(%eax)
  801817:	83 c4 10             	add    $0x10,%esp
}
  80181a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    
		return -E_NOT_SUPP;
  80181f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801824:	eb f4                	jmp    80181a <fstat+0x6c>

00801826 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801826:	f3 0f 1e fb          	endbr32 
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	6a 00                	push   $0x0
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	e8 fb 01 00 00       	call   801a37 <open>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 1b                	js     801860 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801845:	83 ec 08             	sub    $0x8,%esp
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	50                   	push   %eax
  80184c:	e8 5d ff ff ff       	call   8017ae <fstat>
  801851:	89 c6                	mov    %eax,%esi
	close(fd);
  801853:	89 1c 24             	mov    %ebx,(%esp)
  801856:	e8 fd fb ff ff       	call   801458 <close>
	return r;
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	89 f3                	mov    %esi,%ebx
}
  801860:	89 d8                	mov    %ebx,%eax
  801862:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	89 c6                	mov    %eax,%esi
  801870:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801872:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801879:	74 27                	je     8018a2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80187b:	6a 07                	push   $0x7
  80187d:	68 00 50 80 00       	push   $0x805000
  801882:	56                   	push   %esi
  801883:	ff 35 00 40 80 00    	pushl  0x804000
  801889:	e8 b1 08 00 00       	call   80213f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80188e:	83 c4 0c             	add    $0xc,%esp
  801891:	6a 00                	push   $0x0
  801893:	53                   	push   %ebx
  801894:	6a 00                	push   $0x0
  801896:	e8 37 08 00 00       	call   8020d2 <ipc_recv>
}
  80189b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189e:	5b                   	pop    %ebx
  80189f:	5e                   	pop    %esi
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	6a 01                	push   $0x1
  8018a7:	e8 ed 08 00 00       	call   802199 <ipc_find_env>
  8018ac:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	eb c5                	jmp    80187b <fsipc+0x12>

008018b6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018b6:	f3 0f 1e fb          	endbr32 
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ce:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	b8 02 00 00 00       	mov    $0x2,%eax
  8018dd:	e8 87 ff ff ff       	call   801869 <fsipc>
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <devfile_flush>:
{
  8018e4:	f3 0f 1e fb          	endbr32 
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fe:	b8 06 00 00 00       	mov    $0x6,%eax
  801903:	e8 61 ff ff ff       	call   801869 <fsipc>
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <devfile_stat>:
{
  80190a:	f3 0f 1e fb          	endbr32 
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	53                   	push   %ebx
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8b 40 0c             	mov    0xc(%eax),%eax
  80191e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801923:	ba 00 00 00 00       	mov    $0x0,%edx
  801928:	b8 05 00 00 00       	mov    $0x5,%eax
  80192d:	e8 37 ff ff ff       	call   801869 <fsipc>
  801932:	85 c0                	test   %eax,%eax
  801934:	78 2c                	js     801962 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	68 00 50 80 00       	push   $0x805000
  80193e:	53                   	push   %ebx
  80193f:	e8 e3 ef ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801944:	a1 80 50 80 00       	mov    0x805080,%eax
  801949:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80194f:	a1 84 50 80 00       	mov    0x805084,%eax
  801954:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <devfile_write>:
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801979:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80197e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801981:	8b 55 08             	mov    0x8(%ebp),%edx
  801984:	8b 52 0c             	mov    0xc(%edx),%edx
  801987:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80198d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801992:	50                   	push   %eax
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	68 08 50 80 00       	push   $0x805008
  80199b:	e8 3d f1 ff ff       	call   800add <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	b8 04 00 00 00       	mov    $0x4,%eax
  8019aa:	e8 ba fe ff ff       	call   801869 <fsipc>
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <devfile_read>:
{
  8019b1:	f3 0f 1e fb          	endbr32 
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	56                   	push   %esi
  8019b9:	53                   	push   %ebx
  8019ba:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019c8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8019d8:	e8 8c fe ff ff       	call   801869 <fsipc>
  8019dd:	89 c3                	mov    %eax,%ebx
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 1f                	js     801a02 <devfile_read+0x51>
	assert(r <= n);
  8019e3:	39 f0                	cmp    %esi,%eax
  8019e5:	77 24                	ja     801a0b <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019e7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ec:	7f 33                	jg     801a21 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	50                   	push   %eax
  8019f2:	68 00 50 80 00       	push   $0x805000
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	e8 de f0 ff ff       	call   800add <memmove>
	return r;
  8019ff:	83 c4 10             	add    $0x10,%esp
}
  801a02:	89 d8                	mov    %ebx,%eax
  801a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    
	assert(r <= n);
  801a0b:	68 18 2b 80 00       	push   $0x802b18
  801a10:	68 1f 2b 80 00       	push   $0x802b1f
  801a15:	6a 7d                	push   $0x7d
  801a17:	68 34 2b 80 00       	push   $0x802b34
  801a1c:	e8 15 e8 ff ff       	call   800236 <_panic>
	assert(r <= PGSIZE);
  801a21:	68 3f 2b 80 00       	push   $0x802b3f
  801a26:	68 1f 2b 80 00       	push   $0x802b1f
  801a2b:	6a 7e                	push   $0x7e
  801a2d:	68 34 2b 80 00       	push   $0x802b34
  801a32:	e8 ff e7 ff ff       	call   800236 <_panic>

00801a37 <open>:
{
  801a37:	f3 0f 1e fb          	endbr32 
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 1c             	sub    $0x1c,%esp
  801a43:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a46:	56                   	push   %esi
  801a47:	e8 98 ee ff ff       	call   8008e4 <strlen>
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a54:	7f 6c                	jg     801ac2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5c:	50                   	push   %eax
  801a5d:	e8 67 f8 ff ff       	call   8012c9 <fd_alloc>
  801a62:	89 c3                	mov    %eax,%ebx
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 3c                	js     801aa7 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	56                   	push   %esi
  801a6f:	68 00 50 80 00       	push   $0x805000
  801a74:	e8 ae ee ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a84:	b8 01 00 00 00       	mov    $0x1,%eax
  801a89:	e8 db fd ff ff       	call   801869 <fsipc>
  801a8e:	89 c3                	mov    %eax,%ebx
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 19                	js     801ab0 <open+0x79>
	return fd2num(fd);
  801a97:	83 ec 0c             	sub    $0xc,%esp
  801a9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9d:	e8 f8 f7 ff ff       	call   80129a <fd2num>
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	83 c4 10             	add    $0x10,%esp
}
  801aa7:	89 d8                	mov    %ebx,%eax
  801aa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
		fd_close(fd, 0);
  801ab0:	83 ec 08             	sub    $0x8,%esp
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab8:	e8 10 f9 ff ff       	call   8013cd <fd_close>
		return r;
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	eb e5                	jmp    801aa7 <open+0x70>
		return -E_BAD_PATH;
  801ac2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ac7:	eb de                	jmp    801aa7 <open+0x70>

00801ac9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ac9:	f3 0f 1e fb          	endbr32 
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad8:	b8 08 00 00 00       	mov    $0x8,%eax
  801add:	e8 87 fd ff ff       	call   801869 <fsipc>
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ae4:	f3 0f 1e fb          	endbr32 
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	56                   	push   %esi
  801aec:	53                   	push   %ebx
  801aed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801af0:	83 ec 0c             	sub    $0xc,%esp
  801af3:	ff 75 08             	pushl  0x8(%ebp)
  801af6:	e8 b3 f7 ff ff       	call   8012ae <fd2data>
  801afb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801afd:	83 c4 08             	add    $0x8,%esp
  801b00:	68 4b 2b 80 00       	push   $0x802b4b
  801b05:	53                   	push   %ebx
  801b06:	e8 1c ee ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b0b:	8b 46 04             	mov    0x4(%esi),%eax
  801b0e:	2b 06                	sub    (%esi),%eax
  801b10:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b1d:	00 00 00 
	stat->st_dev = &devpipe;
  801b20:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b27:	30 80 00 
	return 0;
}
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5e                   	pop    %esi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b36:	f3 0f 1e fb          	endbr32 
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b44:	53                   	push   %ebx
  801b45:	6a 00                	push   $0x0
  801b47:	e8 aa f2 ff ff       	call   800df6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b4c:	89 1c 24             	mov    %ebx,(%esp)
  801b4f:	e8 5a f7 ff ff       	call   8012ae <fd2data>
  801b54:	83 c4 08             	add    $0x8,%esp
  801b57:	50                   	push   %eax
  801b58:	6a 00                	push   $0x0
  801b5a:	e8 97 f2 ff ff       	call   800df6 <sys_page_unmap>
}
  801b5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <_pipeisclosed>:
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	57                   	push   %edi
  801b68:	56                   	push   %esi
  801b69:	53                   	push   %ebx
  801b6a:	83 ec 1c             	sub    $0x1c,%esp
  801b6d:	89 c7                	mov    %eax,%edi
  801b6f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b71:	a1 20 44 80 00       	mov    0x804420,%eax
  801b76:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	57                   	push   %edi
  801b7d:	e8 54 06 00 00       	call   8021d6 <pageref>
  801b82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b85:	89 34 24             	mov    %esi,(%esp)
  801b88:	e8 49 06 00 00       	call   8021d6 <pageref>
		nn = thisenv->env_runs;
  801b8d:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b93:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	39 cb                	cmp    %ecx,%ebx
  801b9b:	74 1b                	je     801bb8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b9d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba0:	75 cf                	jne    801b71 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ba2:	8b 42 58             	mov    0x58(%edx),%eax
  801ba5:	6a 01                	push   $0x1
  801ba7:	50                   	push   %eax
  801ba8:	53                   	push   %ebx
  801ba9:	68 52 2b 80 00       	push   $0x802b52
  801bae:	e8 6a e7 ff ff       	call   80031d <cprintf>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	eb b9                	jmp    801b71 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bb8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbb:	0f 94 c0             	sete   %al
  801bbe:	0f b6 c0             	movzbl %al,%eax
}
  801bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5f                   	pop    %edi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <devpipe_write>:
{
  801bc9:	f3 0f 1e fb          	endbr32 
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	57                   	push   %edi
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 28             	sub    $0x28,%esp
  801bd6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bd9:	56                   	push   %esi
  801bda:	e8 cf f6 ff ff       	call   8012ae <fd2data>
  801bdf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	bf 00 00 00 00       	mov    $0x0,%edi
  801be9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bec:	74 4f                	je     801c3d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bee:	8b 43 04             	mov    0x4(%ebx),%eax
  801bf1:	8b 0b                	mov    (%ebx),%ecx
  801bf3:	8d 51 20             	lea    0x20(%ecx),%edx
  801bf6:	39 d0                	cmp    %edx,%eax
  801bf8:	72 14                	jb     801c0e <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bfa:	89 da                	mov    %ebx,%edx
  801bfc:	89 f0                	mov    %esi,%eax
  801bfe:	e8 61 ff ff ff       	call   801b64 <_pipeisclosed>
  801c03:	85 c0                	test   %eax,%eax
  801c05:	75 3b                	jne    801c42 <devpipe_write+0x79>
			sys_yield();
  801c07:	e8 3a f1 ff ff       	call   800d46 <sys_yield>
  801c0c:	eb e0                	jmp    801bee <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c11:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c15:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c18:	89 c2                	mov    %eax,%edx
  801c1a:	c1 fa 1f             	sar    $0x1f,%edx
  801c1d:	89 d1                	mov    %edx,%ecx
  801c1f:	c1 e9 1b             	shr    $0x1b,%ecx
  801c22:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c25:	83 e2 1f             	and    $0x1f,%edx
  801c28:	29 ca                	sub    %ecx,%edx
  801c2a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c2e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c32:	83 c0 01             	add    $0x1,%eax
  801c35:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c38:	83 c7 01             	add    $0x1,%edi
  801c3b:	eb ac                	jmp    801be9 <devpipe_write+0x20>
	return i;
  801c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c40:	eb 05                	jmp    801c47 <devpipe_write+0x7e>
				return 0;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5f                   	pop    %edi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    

00801c4f <devpipe_read>:
{
  801c4f:	f3 0f 1e fb          	endbr32 
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	57                   	push   %edi
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	83 ec 18             	sub    $0x18,%esp
  801c5c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c5f:	57                   	push   %edi
  801c60:	e8 49 f6 ff ff       	call   8012ae <fd2data>
  801c65:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	be 00 00 00 00       	mov    $0x0,%esi
  801c6f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c72:	75 14                	jne    801c88 <devpipe_read+0x39>
	return i;
  801c74:	8b 45 10             	mov    0x10(%ebp),%eax
  801c77:	eb 02                	jmp    801c7b <devpipe_read+0x2c>
				return i;
  801c79:	89 f0                	mov    %esi,%eax
}
  801c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5f                   	pop    %edi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    
			sys_yield();
  801c83:	e8 be f0 ff ff       	call   800d46 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c88:	8b 03                	mov    (%ebx),%eax
  801c8a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c8d:	75 18                	jne    801ca7 <devpipe_read+0x58>
			if (i > 0)
  801c8f:	85 f6                	test   %esi,%esi
  801c91:	75 e6                	jne    801c79 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c93:	89 da                	mov    %ebx,%edx
  801c95:	89 f8                	mov    %edi,%eax
  801c97:	e8 c8 fe ff ff       	call   801b64 <_pipeisclosed>
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	74 e3                	je     801c83 <devpipe_read+0x34>
				return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca5:	eb d4                	jmp    801c7b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ca7:	99                   	cltd   
  801ca8:	c1 ea 1b             	shr    $0x1b,%edx
  801cab:	01 d0                	add    %edx,%eax
  801cad:	83 e0 1f             	and    $0x1f,%eax
  801cb0:	29 d0                	sub    %edx,%eax
  801cb2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cba:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cbd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cc0:	83 c6 01             	add    $0x1,%esi
  801cc3:	eb aa                	jmp    801c6f <devpipe_read+0x20>

00801cc5 <pipe>:
{
  801cc5:	f3 0f 1e fb          	endbr32 
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	56                   	push   %esi
  801ccd:	53                   	push   %ebx
  801cce:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd4:	50                   	push   %eax
  801cd5:	e8 ef f5 ff ff       	call   8012c9 <fd_alloc>
  801cda:	89 c3                	mov    %eax,%ebx
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	0f 88 23 01 00 00    	js     801e0a <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	68 07 04 00 00       	push   $0x407
  801cef:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf2:	6a 00                	push   $0x0
  801cf4:	e8 70 f0 ff ff       	call   800d69 <sys_page_alloc>
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	0f 88 04 01 00 00    	js     801e0a <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d06:	83 ec 0c             	sub    $0xc,%esp
  801d09:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d0c:	50                   	push   %eax
  801d0d:	e8 b7 f5 ff ff       	call   8012c9 <fd_alloc>
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	0f 88 db 00 00 00    	js     801dfa <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	68 07 04 00 00       	push   $0x407
  801d27:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2a:	6a 00                	push   $0x0
  801d2c:	e8 38 f0 ff ff       	call   800d69 <sys_page_alloc>
  801d31:	89 c3                	mov    %eax,%ebx
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	85 c0                	test   %eax,%eax
  801d38:	0f 88 bc 00 00 00    	js     801dfa <pipe+0x135>
	va = fd2data(fd0);
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	ff 75 f4             	pushl  -0xc(%ebp)
  801d44:	e8 65 f5 ff ff       	call   8012ae <fd2data>
  801d49:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d4b:	83 c4 0c             	add    $0xc,%esp
  801d4e:	68 07 04 00 00       	push   $0x407
  801d53:	50                   	push   %eax
  801d54:	6a 00                	push   $0x0
  801d56:	e8 0e f0 ff ff       	call   800d69 <sys_page_alloc>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	85 c0                	test   %eax,%eax
  801d62:	0f 88 82 00 00 00    	js     801dea <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d6e:	e8 3b f5 ff ff       	call   8012ae <fd2data>
  801d73:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d7a:	50                   	push   %eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	56                   	push   %esi
  801d7e:	6a 00                	push   $0x0
  801d80:	e8 2b f0 ff ff       	call   800db0 <sys_page_map>
  801d85:	89 c3                	mov    %eax,%ebx
  801d87:	83 c4 20             	add    $0x20,%esp
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 4e                	js     801ddc <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d8e:	a1 20 30 80 00       	mov    0x803020,%eax
  801d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d96:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801da5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	ff 75 f4             	pushl  -0xc(%ebp)
  801db7:	e8 de f4 ff ff       	call   80129a <fd2num>
  801dbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dc1:	83 c4 04             	add    $0x4,%esp
  801dc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc7:	e8 ce f4 ff ff       	call   80129a <fd2num>
  801dcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dcf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dda:	eb 2e                	jmp    801e0a <pipe+0x145>
	sys_page_unmap(0, va);
  801ddc:	83 ec 08             	sub    $0x8,%esp
  801ddf:	56                   	push   %esi
  801de0:	6a 00                	push   $0x0
  801de2:	e8 0f f0 ff ff       	call   800df6 <sys_page_unmap>
  801de7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dea:	83 ec 08             	sub    $0x8,%esp
  801ded:	ff 75 f0             	pushl  -0x10(%ebp)
  801df0:	6a 00                	push   $0x0
  801df2:	e8 ff ef ff ff       	call   800df6 <sys_page_unmap>
  801df7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801dfa:	83 ec 08             	sub    $0x8,%esp
  801dfd:	ff 75 f4             	pushl  -0xc(%ebp)
  801e00:	6a 00                	push   $0x0
  801e02:	e8 ef ef ff ff       	call   800df6 <sys_page_unmap>
  801e07:	83 c4 10             	add    $0x10,%esp
}
  801e0a:	89 d8                	mov    %ebx,%eax
  801e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <pipeisclosed>:
{
  801e13:	f3 0f 1e fb          	endbr32 
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e20:	50                   	push   %eax
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	e8 f6 f4 ff ff       	call   80131f <fd_lookup>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 18                	js     801e48 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	ff 75 f4             	pushl  -0xc(%ebp)
  801e36:	e8 73 f4 ff ff       	call   8012ae <fd2data>
  801e3b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	e8 1f fd ff ff       	call   801b64 <_pipeisclosed>
  801e45:	83 c4 10             	add    $0x10,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801e4a:	f3 0f 1e fb          	endbr32 
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801e56:	85 f6                	test   %esi,%esi
  801e58:	74 13                	je     801e6d <wait+0x23>
	e = &envs[ENVX(envid)];
  801e5a:	89 f3                	mov    %esi,%ebx
  801e5c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e62:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801e65:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801e6b:	eb 1b                	jmp    801e88 <wait+0x3e>
	assert(envid != 0);
  801e6d:	68 6a 2b 80 00       	push   $0x802b6a
  801e72:	68 1f 2b 80 00       	push   $0x802b1f
  801e77:	6a 09                	push   $0x9
  801e79:	68 75 2b 80 00       	push   $0x802b75
  801e7e:	e8 b3 e3 ff ff       	call   800236 <_panic>
		sys_yield();
  801e83:	e8 be ee ff ff       	call   800d46 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e88:	8b 43 48             	mov    0x48(%ebx),%eax
  801e8b:	39 f0                	cmp    %esi,%eax
  801e8d:	75 07                	jne    801e96 <wait+0x4c>
  801e8f:	8b 43 54             	mov    0x54(%ebx),%eax
  801e92:	85 c0                	test   %eax,%eax
  801e94:	75 ed                	jne    801e83 <wait+0x39>
}
  801e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e99:	5b                   	pop    %ebx
  801e9a:	5e                   	pop    %esi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e9d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea6:	c3                   	ret    

00801ea7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ea7:	f3 0f 1e fb          	endbr32 
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eb1:	68 80 2b 80 00       	push   $0x802b80
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	e8 69 ea ff ff       	call   800927 <strcpy>
	return 0;
}
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <devcons_write>:
{
  801ec5:	f3 0f 1e fb          	endbr32 
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	57                   	push   %edi
  801ecd:	56                   	push   %esi
  801ece:	53                   	push   %ebx
  801ecf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ed5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801eda:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ee0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ee3:	73 31                	jae    801f16 <devcons_write+0x51>
		m = n - tot;
  801ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ee8:	29 f3                	sub    %esi,%ebx
  801eea:	83 fb 7f             	cmp    $0x7f,%ebx
  801eed:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ef2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	53                   	push   %ebx
  801ef9:	89 f0                	mov    %esi,%eax
  801efb:	03 45 0c             	add    0xc(%ebp),%eax
  801efe:	50                   	push   %eax
  801eff:	57                   	push   %edi
  801f00:	e8 d8 eb ff ff       	call   800add <memmove>
		sys_cputs(buf, m);
  801f05:	83 c4 08             	add    $0x8,%esp
  801f08:	53                   	push   %ebx
  801f09:	57                   	push   %edi
  801f0a:	e8 8a ed ff ff       	call   800c99 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f0f:	01 de                	add    %ebx,%esi
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	eb ca                	jmp    801ee0 <devcons_write+0x1b>
}
  801f16:	89 f0                	mov    %esi,%eax
  801f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5f                   	pop    %edi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    

00801f20 <devcons_read>:
{
  801f20:	f3 0f 1e fb          	endbr32 
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f33:	74 21                	je     801f56 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f35:	e8 81 ed ff ff       	call   800cbb <sys_cgetc>
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	75 07                	jne    801f45 <devcons_read+0x25>
		sys_yield();
  801f3e:	e8 03 ee ff ff       	call   800d46 <sys_yield>
  801f43:	eb f0                	jmp    801f35 <devcons_read+0x15>
	if (c < 0)
  801f45:	78 0f                	js     801f56 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f47:	83 f8 04             	cmp    $0x4,%eax
  801f4a:	74 0c                	je     801f58 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4f:	88 02                	mov    %al,(%edx)
	return 1;
  801f51:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    
		return 0;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5d:	eb f7                	jmp    801f56 <devcons_read+0x36>

00801f5f <cputchar>:
{
  801f5f:	f3 0f 1e fb          	endbr32 
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f6f:	6a 01                	push   $0x1
  801f71:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	e8 1f ed ff ff       	call   800c99 <sys_cputs>
}
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <getchar>:
{
  801f7f:	f3 0f 1e fb          	endbr32 
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f89:	6a 01                	push   $0x1
  801f8b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f8e:	50                   	push   %eax
  801f8f:	6a 00                	push   $0x0
  801f91:	e8 0c f6 ff ff       	call   8015a2 <read>
	if (r < 0)
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 06                	js     801fa3 <getchar+0x24>
	if (r < 1)
  801f9d:	74 06                	je     801fa5 <getchar+0x26>
	return c;
  801f9f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    
		return -E_EOF;
  801fa5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801faa:	eb f7                	jmp    801fa3 <getchar+0x24>

00801fac <iscons>:
{
  801fac:	f3 0f 1e fb          	endbr32 
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb9:	50                   	push   %eax
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	e8 5d f3 ff ff       	call   80131f <fd_lookup>
  801fc2:	83 c4 10             	add    $0x10,%esp
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 11                	js     801fda <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fd2:	39 10                	cmp    %edx,(%eax)
  801fd4:	0f 94 c0             	sete   %al
  801fd7:	0f b6 c0             	movzbl %al,%eax
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <opencons>:
{
  801fdc:	f3 0f 1e fb          	endbr32 
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe9:	50                   	push   %eax
  801fea:	e8 da f2 ff ff       	call   8012c9 <fd_alloc>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 3a                	js     802030 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	68 07 04 00 00       	push   $0x407
  801ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  802001:	6a 00                	push   $0x0
  802003:	e8 61 ed ff ff       	call   800d69 <sys_page_alloc>
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	85 c0                	test   %eax,%eax
  80200d:	78 21                	js     802030 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802018:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	50                   	push   %eax
  802028:	e8 6d f2 ff ff       	call   80129a <fd2num>
  80202d:	83 c4 10             	add    $0x10,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802032:	f3 0f 1e fb          	endbr32 
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	53                   	push   %ebx
  80203a:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  80203d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802044:	74 0d                	je     802053 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80204e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802051:	c9                   	leave  
  802052:	c3                   	ret    
		envid_t envid=sys_getenvid();
  802053:	e8 cb ec ff ff       	call   800d23 <sys_getenvid>
  802058:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	6a 07                	push   $0x7
  80205f:	68 00 f0 bf ee       	push   $0xeebff000
  802064:	50                   	push   %eax
  802065:	e8 ff ec ff ff       	call   800d69 <sys_page_alloc>
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	85 c0                	test   %eax,%eax
  80206f:	78 29                	js     80209a <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802071:	83 ec 08             	sub    $0x8,%esp
  802074:	68 ae 20 80 00       	push   $0x8020ae
  802079:	53                   	push   %ebx
  80207a:	e8 49 ee ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	79 c0                	jns    802046 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 b8 2b 80 00       	push   $0x802bb8
  80208e:	6a 24                	push   $0x24
  802090:	68 ef 2b 80 00       	push   $0x802bef
  802095:	e8 9c e1 ff ff       	call   800236 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 8c 2b 80 00       	push   $0x802b8c
  8020a2:	6a 22                	push   $0x22
  8020a4:	68 ef 2b 80 00       	push   $0x802bef
  8020a9:	e8 88 e1 ff ff       	call   800236 <_panic>

008020ae <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020ae:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020af:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8020b4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020b6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8020b9:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8020bc:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8020c0:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8020c5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8020c9:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8020cb:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8020cc:	83 c4 04             	add    $0x4,%esp
	popfl
  8020cf:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020d0:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8020d1:	c3                   	ret    

008020d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020d2:	f3 0f 1e fb          	endbr32 
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	56                   	push   %esi
  8020da:	53                   	push   %ebx
  8020db:	8b 75 08             	mov    0x8(%ebp),%esi
  8020de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020eb:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	50                   	push   %eax
  8020f2:	e8 3e ee ff ff       	call   800f35 <sys_ipc_recv>
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 2b                	js     802129 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8020fe:	85 f6                	test   %esi,%esi
  802100:	74 0a                	je     80210c <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  802102:	a1 20 44 80 00       	mov    0x804420,%eax
  802107:	8b 40 74             	mov    0x74(%eax),%eax
  80210a:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  80210c:	85 db                	test   %ebx,%ebx
  80210e:	74 0a                	je     80211a <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  802110:	a1 20 44 80 00       	mov    0x804420,%eax
  802115:	8b 40 78             	mov    0x78(%eax),%eax
  802118:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80211a:	a1 20 44 80 00       	mov    0x804420,%eax
  80211f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802125:	5b                   	pop    %ebx
  802126:	5e                   	pop    %esi
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    
		if(from_env_store)
  802129:	85 f6                	test   %esi,%esi
  80212b:	74 06                	je     802133 <ipc_recv+0x61>
			*from_env_store=0;
  80212d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802133:	85 db                	test   %ebx,%ebx
  802135:	74 eb                	je     802122 <ipc_recv+0x50>
			*perm_store=0;
  802137:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80213d:	eb e3                	jmp    802122 <ipc_recv+0x50>

0080213f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80213f:	f3 0f 1e fb          	endbr32 
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	57                   	push   %edi
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	83 ec 0c             	sub    $0xc,%esp
  80214c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80214f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802152:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802155:	85 db                	test   %ebx,%ebx
  802157:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80215c:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  80215f:	ff 75 14             	pushl  0x14(%ebp)
  802162:	53                   	push   %ebx
  802163:	56                   	push   %esi
  802164:	57                   	push   %edi
  802165:	e8 a4 ed ff ff       	call   800f0e <sys_ipc_try_send>
		if(!res)
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	85 c0                	test   %eax,%eax
  80216f:	74 20                	je     802191 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802171:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802174:	75 07                	jne    80217d <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  802176:	e8 cb eb ff ff       	call   800d46 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  80217b:	eb e2                	jmp    80215f <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 fd 2b 80 00       	push   $0x802bfd
  802185:	6a 3f                	push   $0x3f
  802187:	68 15 2c 80 00       	push   $0x802c15
  80218c:	e8 a5 e0 ff ff       	call   800236 <_panic>
	}
}
  802191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802199:	f3 0f 1e fb          	endbr32 
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021a8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ab:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b1:	8b 52 50             	mov    0x50(%edx),%edx
  8021b4:	39 ca                	cmp    %ecx,%edx
  8021b6:	74 11                	je     8021c9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021b8:	83 c0 01             	add    $0x1,%eax
  8021bb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c0:	75 e6                	jne    8021a8 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	eb 0b                	jmp    8021d4 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021c9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d6:	f3 0f 1e fb          	endbr32 
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	c1 ea 16             	shr    $0x16,%edx
  8021e5:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021ec:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f1:	f6 c1 01             	test   $0x1,%cl
  8021f4:	74 1c                	je     802212 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021f6:	c1 e8 0c             	shr    $0xc,%eax
  8021f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802200:	a8 01                	test   $0x1,%al
  802202:	74 0e                	je     802212 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802204:	c1 e8 0c             	shr    $0xc,%eax
  802207:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80220e:	ef 
  80220f:	0f b7 d2             	movzwl %dx,%edx
}
  802212:	89 d0                	mov    %edx,%eax
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd fa             	bsr    %edx,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 40 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 36 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 19                	jne    802368 <__umoddi3+0x38>
  80234f:	39 df                	cmp    %ebx,%edi
  802351:	76 5d                	jbe    8023b0 <__umoddi3+0x80>
  802353:	89 f0                	mov    %esi,%eax
  802355:	89 da                	mov    %ebx,%edx
  802357:	f7 f7                	div    %edi
  802359:	89 d0                	mov    %edx,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 f2                	mov    %esi,%edx
  80236a:	39 d8                	cmp    %ebx,%eax
  80236c:	76 12                	jbe    802380 <__umoddi3+0x50>
  80236e:	89 f0                	mov    %esi,%eax
  802370:	89 da                	mov    %ebx,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	75 50                	jne    8023d8 <__umoddi3+0xa8>
  802388:	39 d8                	cmp    %ebx,%eax
  80238a:	0f 82 e0 00 00 00    	jb     802470 <__umoddi3+0x140>
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	39 f7                	cmp    %esi,%edi
  802394:	0f 86 d6 00 00 00    	jbe    802470 <__umoddi3+0x140>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 ca                	mov    %ecx,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 fd                	mov    %edi,%ebp
  8023b2:	85 ff                	test   %edi,%edi
  8023b4:	75 0b                	jne    8023c1 <__umoddi3+0x91>
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f7                	div    %edi
  8023bf:	89 c5                	mov    %eax,%ebp
  8023c1:	89 d8                	mov    %ebx,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	31 d2                	xor    %edx,%edx
  8023cf:	eb 8c                	jmp    80235d <__umoddi3+0x2d>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	ba 20 00 00 00       	mov    $0x20,%edx
  8023df:	29 ea                	sub    %ebp,%edx
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023f9:	09 c1                	or     %eax,%ecx
  8023fb:	89 d8                	mov    %ebx,%eax
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e7                	shl    %cl,%edi
  802405:	89 d1                	mov    %edx,%ecx
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e3                	shl    %cl,%ebx
  802411:	89 c7                	mov    %eax,%edi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	89 f0                	mov    %esi,%eax
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	d3 e6                	shl    %cl,%esi
  80241f:	09 d8                	or     %ebx,%eax
  802421:	f7 74 24 08          	divl   0x8(%esp)
  802425:	89 d1                	mov    %edx,%ecx
  802427:	89 f3                	mov    %esi,%ebx
  802429:	f7 64 24 0c          	mull   0xc(%esp)
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	89 d7                	mov    %edx,%edi
  802431:	39 d1                	cmp    %edx,%ecx
  802433:	72 06                	jb     80243b <__umoddi3+0x10b>
  802435:	75 10                	jne    802447 <__umoddi3+0x117>
  802437:	39 c3                	cmp    %eax,%ebx
  802439:	73 0c                	jae    802447 <__umoddi3+0x117>
  80243b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80243f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802443:	89 d7                	mov    %edx,%edi
  802445:	89 c6                	mov    %eax,%esi
  802447:	89 ca                	mov    %ecx,%edx
  802449:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80244e:	29 f3                	sub    %esi,%ebx
  802450:	19 fa                	sbb    %edi,%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	d3 e0                	shl    %cl,%eax
  802456:	89 e9                	mov    %ebp,%ecx
  802458:	d3 eb                	shr    %cl,%ebx
  80245a:	d3 ea                	shr    %cl,%edx
  80245c:	09 d8                	or     %ebx,%eax
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	29 fe                	sub    %edi,%esi
  802472:	19 c3                	sbb    %eax,%ebx
  802474:	89 f2                	mov    %esi,%edx
  802476:	89 d9                	mov    %ebx,%ecx
  802478:	e9 1d ff ff ff       	jmp    80239a <__umoddi3+0x6a>
