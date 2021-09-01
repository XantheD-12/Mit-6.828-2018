
obj/user/icode.debug：     文件格式 elf32-i386


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
  80002c:	e8 07 01 00 00       	call   800138 <libmain>
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
  80003c:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  800042:	c7 05 00 30 80 00 00 	movl   $0x802600,0x803000
  800049:	26 80 00 

	cprintf("icode startup\n");
  80004c:	68 06 26 80 00       	push   $0x802606
  800051:	e8 31 02 00 00       	call   800287 <cprintf>

	cprintf("icode: open /motd\n");
  800056:	c7 04 24 15 26 80 00 	movl   $0x802615,(%esp)
  80005d:	e8 25 02 00 00       	call   800287 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800062:	83 c4 08             	add    $0x8,%esp
  800065:	6a 00                	push   $0x0
  800067:	68 28 26 80 00       	push   $0x802628
  80006c:	e8 10 16 00 00       	call   801681 <open>
  800071:	89 c6                	mov    %eax,%esi
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	85 c0                	test   %eax,%eax
  800078:	78 18                	js     800092 <umain+0x5f>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	68 51 26 80 00       	push   $0x802651
  800082:	e8 00 02 00 00       	call   800287 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  800090:	eb 1f                	jmp    8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);
  800092:	50                   	push   %eax
  800093:	68 2e 26 80 00       	push   $0x80262e
  800098:	6a 0f                	push   $0xf
  80009a:	68 44 26 80 00       	push   $0x802644
  80009f:	e8 fc 00 00 00       	call   8001a0 <_panic>
		sys_cputs(buf, n);
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	50                   	push   %eax
  8000a8:	53                   	push   %ebx
  8000a9:	e8 55 0b 00 00       	call   800c03 <sys_cputs>
  8000ae:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	68 00 02 00 00       	push   $0x200
  8000b9:	53                   	push   %ebx
  8000ba:	56                   	push   %esi
  8000bb:	e8 2c 11 00 00       	call   8011ec <read>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	7f dd                	jg     8000a4 <umain+0x71>

	cprintf("icode: close /motd\n");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 64 26 80 00       	push   $0x802664
  8000cf:	e8 b3 01 00 00       	call   800287 <cprintf>
	close(fd);
  8000d4:	89 34 24             	mov    %esi,(%esp)
  8000d7:	e8 c6 0f 00 00       	call   8010a2 <close>

	cprintf("icode: spawn /init\n");
  8000dc:	c7 04 24 78 26 80 00 	movl   $0x802678,(%esp)
  8000e3:	e8 9f 01 00 00       	call   800287 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ef:	68 8c 26 80 00       	push   $0x80268c
  8000f4:	68 95 26 80 00       	push   $0x802695
  8000f9:	68 9f 26 80 00       	push   $0x80269f
  8000fe:	68 9e 26 80 00       	push   $0x80269e
  800103:	e8 8b 1b 00 00       	call   801c93 <spawnl>
  800108:	83 c4 20             	add    $0x20,%esp
  80010b:	85 c0                	test   %eax,%eax
  80010d:	78 17                	js     800126 <umain+0xf3>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 bb 26 80 00       	push   $0x8026bb
  800117:	e8 6b 01 00 00       	call   800287 <cprintf>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800126:	50                   	push   %eax
  800127:	68 a4 26 80 00       	push   $0x8026a4
  80012c:	6a 1a                	push   $0x1a
  80012e:	68 44 26 80 00       	push   $0x802644
  800133:	e8 68 00 00 00       	call   8001a0 <_panic>

00800138 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
  800141:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800144:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800147:	e8 41 0b 00 00       	call   800c8d <sys_getenvid>
  80014c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800151:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800154:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800159:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015e:	85 db                	test   %ebx,%ebx
  800160:	7e 07                	jle    800169 <libmain+0x31>
		binaryname = argv[0];
  800162:	8b 06                	mov    (%esi),%eax
  800164:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	e8 c0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800173:	e8 0a 00 00 00       	call   800182 <exit>
}
  800178:	83 c4 10             	add    $0x10,%esp
  80017b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017e:	5b                   	pop    %ebx
  80017f:	5e                   	pop    %esi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    

00800182 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800182:	f3 0f 1e fb          	endbr32 
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018c:	e8 42 0f 00 00       	call   8010d3 <close_all>
	sys_env_destroy(0);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	6a 00                	push   $0x0
  800196:	e8 ad 0a 00 00       	call   800c48 <sys_env_destroy>
}
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001a0:	f3 0f 1e fb          	endbr32 
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001a9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ac:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001b2:	e8 d6 0a 00 00       	call   800c8d <sys_getenvid>
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	56                   	push   %esi
  8001c1:	50                   	push   %eax
  8001c2:	68 d8 26 80 00       	push   $0x8026d8
  8001c7:	e8 bb 00 00 00       	call   800287 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cc:	83 c4 18             	add    $0x18,%esp
  8001cf:	53                   	push   %ebx
  8001d0:	ff 75 10             	pushl  0x10(%ebp)
  8001d3:	e8 5a 00 00 00       	call   800232 <vcprintf>
	cprintf("\n");
  8001d8:	c7 04 24 9e 2b 80 00 	movl   $0x802b9e,(%esp)
  8001df:	e8 a3 00 00 00       	call   800287 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e7:	cc                   	int3   
  8001e8:	eb fd                	jmp    8001e7 <_panic+0x47>

008001ea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ea:	f3 0f 1e fb          	endbr32 
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f8:	8b 13                	mov    (%ebx),%edx
  8001fa:	8d 42 01             	lea    0x1(%edx),%eax
  8001fd:	89 03                	mov    %eax,(%ebx)
  8001ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800202:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800206:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020b:	74 09                	je     800216 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800214:	c9                   	leave  
  800215:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800216:	83 ec 08             	sub    $0x8,%esp
  800219:	68 ff 00 00 00       	push   $0xff
  80021e:	8d 43 08             	lea    0x8(%ebx),%eax
  800221:	50                   	push   %eax
  800222:	e8 dc 09 00 00       	call   800c03 <sys_cputs>
		b->idx = 0;
  800227:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	eb db                	jmp    80020d <putch+0x23>

00800232 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800232:	f3 0f 1e fb          	endbr32 
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800246:	00 00 00 
	b.cnt = 0;
  800249:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800250:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	50                   	push   %eax
  800260:	68 ea 01 80 00       	push   $0x8001ea
  800265:	e8 20 01 00 00       	call   80038a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026a:	83 c4 08             	add    $0x8,%esp
  80026d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800273:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	e8 84 09 00 00       	call   800c03 <sys_cputs>

	return b.cnt;
}
  80027f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800287:	f3 0f 1e fb          	endbr32 
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800291:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800294:	50                   	push   %eax
  800295:	ff 75 08             	pushl  0x8(%ebp)
  800298:	e8 95 ff ff ff       	call   800232 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 1c             	sub    $0x1c,%esp
  8002a8:	89 c7                	mov    %eax,%edi
  8002aa:	89 d6                	mov    %edx,%esi
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b2:	89 d1                	mov    %edx,%ecx
  8002b4:	89 c2                	mov    %eax,%edx
  8002b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002cc:	39 c2                	cmp    %eax,%edx
  8002ce:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d1:	72 3e                	jb     800311 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	ff 75 18             	pushl  0x18(%ebp)
  8002d9:	83 eb 01             	sub    $0x1,%ebx
  8002dc:	53                   	push   %ebx
  8002dd:	50                   	push   %eax
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ed:	e8 9e 20 00 00       	call   802390 <__udivdi3>
  8002f2:	83 c4 18             	add    $0x18,%esp
  8002f5:	52                   	push   %edx
  8002f6:	50                   	push   %eax
  8002f7:	89 f2                	mov    %esi,%edx
  8002f9:	89 f8                	mov    %edi,%eax
  8002fb:	e8 9f ff ff ff       	call   80029f <printnum>
  800300:	83 c4 20             	add    $0x20,%esp
  800303:	eb 13                	jmp    800318 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	56                   	push   %esi
  800309:	ff 75 18             	pushl  0x18(%ebp)
  80030c:	ff d7                	call   *%edi
  80030e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800311:	83 eb 01             	sub    $0x1,%ebx
  800314:	85 db                	test   %ebx,%ebx
  800316:	7f ed                	jg     800305 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	56                   	push   %esi
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800322:	ff 75 e0             	pushl  -0x20(%ebp)
  800325:	ff 75 dc             	pushl  -0x24(%ebp)
  800328:	ff 75 d8             	pushl  -0x28(%ebp)
  80032b:	e8 70 21 00 00       	call   8024a0 <__umoddi3>
  800330:	83 c4 14             	add    $0x14,%esp
  800333:	0f be 80 fb 26 80 00 	movsbl 0x8026fb(%eax),%eax
  80033a:	50                   	push   %eax
  80033b:	ff d7                	call   *%edi
}
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800343:	5b                   	pop    %ebx
  800344:	5e                   	pop    %esi
  800345:	5f                   	pop    %edi
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800348:	f3 0f 1e fb          	endbr32 
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800352:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800356:	8b 10                	mov    (%eax),%edx
  800358:	3b 50 04             	cmp    0x4(%eax),%edx
  80035b:	73 0a                	jae    800367 <sprintputch+0x1f>
		*b->buf++ = ch;
  80035d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800360:	89 08                	mov    %ecx,(%eax)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	88 02                	mov    %al,(%edx)
}
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <printfmt>:
{
  800369:	f3 0f 1e fb          	endbr32 
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800373:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800376:	50                   	push   %eax
  800377:	ff 75 10             	pushl  0x10(%ebp)
  80037a:	ff 75 0c             	pushl  0xc(%ebp)
  80037d:	ff 75 08             	pushl  0x8(%ebp)
  800380:	e8 05 00 00 00       	call   80038a <vprintfmt>
}
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <vprintfmt>:
{
  80038a:	f3 0f 1e fb          	endbr32 
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
  800394:	83 ec 3c             	sub    $0x3c,%esp
  800397:	8b 75 08             	mov    0x8(%ebp),%esi
  80039a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039d:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a0:	e9 8e 03 00 00       	jmp    800733 <vprintfmt+0x3a9>
		padc = ' ';
  8003a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8d 47 01             	lea    0x1(%edi),%eax
  8003c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c9:	0f b6 17             	movzbl (%edi),%edx
  8003cc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cf:	3c 55                	cmp    $0x55,%al
  8003d1:	0f 87 df 03 00 00    	ja     8007b6 <vprintfmt+0x42c>
  8003d7:	0f b6 c0             	movzbl %al,%eax
  8003da:	3e ff 24 85 40 28 80 	notrack jmp *0x802840(,%eax,4)
  8003e1:	00 
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e9:	eb d8                	jmp    8003c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ee:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003f2:	eb cf                	jmp    8003c3 <vprintfmt+0x39>
  8003f4:	0f b6 d2             	movzbl %dl,%edx
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800402:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800405:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800409:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040f:	83 f9 09             	cmp    $0x9,%ecx
  800412:	77 55                	ja     800469 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800414:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800417:	eb e9                	jmp    800402 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 40 04             	lea    0x4(%eax),%eax
  800427:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800431:	79 90                	jns    8003c3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800433:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800436:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800439:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800440:	eb 81                	jmp    8003c3 <vprintfmt+0x39>
  800442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800445:	85 c0                	test   %eax,%eax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	0f 49 d0             	cmovns %eax,%edx
  80044f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800455:	e9 69 ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800464:	e9 5a ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
  800469:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	eb bc                	jmp    80042d <vprintfmt+0xa3>
			lflag++;
  800471:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800477:	e9 47 ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	53                   	push   %ebx
  800486:	ff 30                	pushl  (%eax)
  800488:	ff d6                	call   *%esi
			break;
  80048a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800490:	e9 9b 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800495:	8b 45 14             	mov    0x14(%ebp),%eax
  800498:	8d 78 04             	lea    0x4(%eax),%edi
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	99                   	cltd   
  80049e:	31 d0                	xor    %edx,%eax
  8004a0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a2:	83 f8 0f             	cmp    $0xf,%eax
  8004a5:	7f 23                	jg     8004ca <vprintfmt+0x140>
  8004a7:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8004ae:	85 d2                	test   %edx,%edx
  8004b0:	74 18                	je     8004ca <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004b2:	52                   	push   %edx
  8004b3:	68 d1 2a 80 00       	push   $0x802ad1
  8004b8:	53                   	push   %ebx
  8004b9:	56                   	push   %esi
  8004ba:	e8 aa fe ff ff       	call   800369 <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c5:	e9 66 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004ca:	50                   	push   %eax
  8004cb:	68 13 27 80 00       	push   $0x802713
  8004d0:	53                   	push   %ebx
  8004d1:	56                   	push   %esi
  8004d2:	e8 92 fe ff ff       	call   800369 <printfmt>
  8004d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004da:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004dd:	e9 4e 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	83 c0 04             	add    $0x4,%eax
  8004e8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	b8 0c 27 80 00       	mov    $0x80270c,%eax
  8004f7:	0f 45 c2             	cmovne %edx,%eax
  8004fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800501:	7e 06                	jle    800509 <vprintfmt+0x17f>
  800503:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800507:	75 0d                	jne    800516 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800509:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	03 45 e0             	add    -0x20(%ebp),%eax
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800514:	eb 55                	jmp    80056b <vprintfmt+0x1e1>
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 d8             	pushl  -0x28(%ebp)
  80051c:	ff 75 cc             	pushl  -0x34(%ebp)
  80051f:	e8 46 03 00 00       	call   80086a <strnlen>
  800524:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800527:	29 c2                	sub    %eax,%edx
  800529:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800531:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800538:	85 ff                	test   %edi,%edi
  80053a:	7e 11                	jle    80054d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 75 e0             	pushl  -0x20(%ebp)
  800543:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800545:	83 ef 01             	sub    $0x1,%edi
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	eb eb                	jmp    800538 <vprintfmt+0x1ae>
  80054d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800550:	85 d2                	test   %edx,%edx
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
  800557:	0f 49 c2             	cmovns %edx,%eax
  80055a:	29 c2                	sub    %eax,%edx
  80055c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80055f:	eb a8                	jmp    800509 <vprintfmt+0x17f>
					putch(ch, putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	52                   	push   %edx
  800566:	ff d6                	call   *%esi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800570:	83 c7 01             	add    $0x1,%edi
  800573:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800577:	0f be d0             	movsbl %al,%edx
  80057a:	85 d2                	test   %edx,%edx
  80057c:	74 4b                	je     8005c9 <vprintfmt+0x23f>
  80057e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800582:	78 06                	js     80058a <vprintfmt+0x200>
  800584:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800588:	78 1e                	js     8005a8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80058a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058e:	74 d1                	je     800561 <vprintfmt+0x1d7>
  800590:	0f be c0             	movsbl %al,%eax
  800593:	83 e8 20             	sub    $0x20,%eax
  800596:	83 f8 5e             	cmp    $0x5e,%eax
  800599:	76 c6                	jbe    800561 <vprintfmt+0x1d7>
					putch('?', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	53                   	push   %ebx
  80059f:	6a 3f                	push   $0x3f
  8005a1:	ff d6                	call   *%esi
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb c3                	jmp    80056b <vprintfmt+0x1e1>
  8005a8:	89 cf                	mov    %ecx,%edi
  8005aa:	eb 0e                	jmp    8005ba <vprintfmt+0x230>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 67 01 00 00       	jmp    800730 <vprintfmt+0x3a6>
  8005c9:	89 cf                	mov    %ecx,%edi
  8005cb:	eb ed                	jmp    8005ba <vprintfmt+0x230>
	if (lflag >= 2)
  8005cd:	83 f9 01             	cmp    $0x1,%ecx
  8005d0:	7f 1b                	jg     8005ed <vprintfmt+0x263>
	else if (lflag)
  8005d2:	85 c9                	test   %ecx,%ecx
  8005d4:	74 63                	je     800639 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	99                   	cltd   
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb 17                	jmp    800604 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 50 04             	mov    0x4(%eax),%edx
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 40 08             	lea    0x8(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800604:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800607:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	0f 89 ff 00 00 00    	jns    800716 <vprintfmt+0x38c>
				putch('-', putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	6a 2d                	push   $0x2d
  80061d:	ff d6                	call   *%esi
				num = -(long long) num;
  80061f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800622:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800625:	f7 da                	neg    %edx
  800627:	83 d1 00             	adc    $0x0,%ecx
  80062a:	f7 d9                	neg    %ecx
  80062c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	e9 dd 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	99                   	cltd   
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb b4                	jmp    800604 <vprintfmt+0x27a>
	if (lflag >= 2)
  800650:	83 f9 01             	cmp    $0x1,%ecx
  800653:	7f 1e                	jg     800673 <vprintfmt+0x2e9>
	else if (lflag)
  800655:	85 c9                	test   %ecx,%ecx
  800657:	74 32                	je     80068b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800669:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80066e:	e9 a3 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	8b 48 04             	mov    0x4(%eax),%ecx
  80067b:	8d 40 08             	lea    0x8(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800681:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800686:	e9 8b 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	b9 00 00 00 00       	mov    $0x0,%ecx
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006a0:	eb 74                	jmp    800716 <vprintfmt+0x38c>
	if (lflag >= 2)
  8006a2:	83 f9 01             	cmp    $0x1,%ecx
  8006a5:	7f 1b                	jg     8006c2 <vprintfmt+0x338>
	else if (lflag)
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	74 2c                	je     8006d7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 10                	mov    (%eax),%edx
  8006b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b5:	8d 40 04             	lea    0x4(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006c0:	eb 54                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 10                	mov    (%eax),%edx
  8006c7:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ca:	8d 40 08             	lea    0x8(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8006d0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006d5:	eb 3f                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8006e7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006ec:	eb 28                	jmp    800716 <vprintfmt+0x38c>
			putch('0', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 30                	push   $0x30
  8006f4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f6:	83 c4 08             	add    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 78                	push   $0x78
  8006fc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800708:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80071d:	57                   	push   %edi
  80071e:	ff 75 e0             	pushl  -0x20(%ebp)
  800721:	50                   	push   %eax
  800722:	51                   	push   %ecx
  800723:	52                   	push   %edx
  800724:	89 da                	mov    %ebx,%edx
  800726:	89 f0                	mov    %esi,%eax
  800728:	e8 72 fb ff ff       	call   80029f <printnum>
			break;
  80072d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800733:	83 c7 01             	add    $0x1,%edi
  800736:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073a:	83 f8 25             	cmp    $0x25,%eax
  80073d:	0f 84 62 fc ff ff    	je     8003a5 <vprintfmt+0x1b>
			if (ch == '\0')
  800743:	85 c0                	test   %eax,%eax
  800745:	0f 84 8b 00 00 00    	je     8007d6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	50                   	push   %eax
  800750:	ff d6                	call   *%esi
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	eb dc                	jmp    800733 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800757:	83 f9 01             	cmp    $0x1,%ecx
  80075a:	7f 1b                	jg     800777 <vprintfmt+0x3ed>
	else if (lflag)
  80075c:	85 c9                	test   %ecx,%ecx
  80075e:	74 2c                	je     80078c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 10                	mov    (%eax),%edx
  800765:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800770:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800775:	eb 9f                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 10                	mov    (%eax),%edx
  80077c:	8b 48 04             	mov    0x4(%eax),%ecx
  80077f:	8d 40 08             	lea    0x8(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80078a:	eb 8a                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007a1:	e9 70 ff ff ff       	jmp    800716 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	6a 25                	push   $0x25
  8007ac:	ff d6                	call   *%esi
			break;
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	e9 7a ff ff ff       	jmp    800730 <vprintfmt+0x3a6>
			putch('%', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 25                	push   $0x25
  8007bc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 f8                	mov    %edi,%eax
  8007c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c7:	74 05                	je     8007ce <vprintfmt+0x444>
  8007c9:	83 e8 01             	sub    $0x1,%eax
  8007cc:	eb f5                	jmp    8007c3 <vprintfmt+0x439>
  8007ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d1:	e9 5a ff ff ff       	jmp    800730 <vprintfmt+0x3a6>
}
  8007d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d9:	5b                   	pop    %ebx
  8007da:	5e                   	pop    %esi
  8007db:	5f                   	pop    %edi
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ff:	85 c0                	test   %eax,%eax
  800801:	74 26                	je     800829 <vsnprintf+0x4b>
  800803:	85 d2                	test   %edx,%edx
  800805:	7e 22                	jle    800829 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800807:	ff 75 14             	pushl  0x14(%ebp)
  80080a:	ff 75 10             	pushl  0x10(%ebp)
  80080d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800810:	50                   	push   %eax
  800811:	68 48 03 80 00       	push   $0x800348
  800816:	e8 6f fb ff ff       	call   80038a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    
		return -E_INVAL;
  800829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082e:	eb f7                	jmp    800827 <vsnprintf+0x49>

00800830 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083d:	50                   	push   %eax
  80083e:	ff 75 10             	pushl  0x10(%ebp)
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 08             	pushl  0x8(%ebp)
  800847:	e8 92 ff ff ff       	call   8007de <vsnprintf>
	va_end(ap);

	return rc;
}
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800861:	74 05                	je     800868 <strlen+0x1a>
		n++;
  800863:	83 c0 01             	add    $0x1,%eax
  800866:	eb f5                	jmp    80085d <strlen+0xf>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086a:	f3 0f 1e fb          	endbr32 
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	39 d0                	cmp    %edx,%eax
  80087e:	74 0d                	je     80088d <strnlen+0x23>
  800880:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800884:	74 05                	je     80088b <strnlen+0x21>
		n++;
  800886:	83 c0 01             	add    $0x1,%eax
  800889:	eb f1                	jmp    80087c <strnlen+0x12>
  80088b:	89 c2                	mov    %eax,%edx
	return n;
}
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800891:	f3 0f 1e fb          	endbr32 
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	84 d2                	test   %dl,%dl
  8008b0:	75 f2                	jne    8008a4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008b2:	89 c8                	mov    %ecx,%eax
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	83 ec 10             	sub    $0x10,%esp
  8008c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c5:	53                   	push   %ebx
  8008c6:	e8 83 ff ff ff       	call   80084e <strlen>
  8008cb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	01 d8                	add    %ebx,%eax
  8008d3:	50                   	push   %eax
  8008d4:	e8 b8 ff ff ff       	call   800891 <strcpy>
	return dst;
}
  8008d9:	89 d8                	mov    %ebx,%eax
  8008db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	89 f3                	mov    %esi,%ebx
  8008f1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f4:	89 f0                	mov    %esi,%eax
  8008f6:	39 d8                	cmp    %ebx,%eax
  8008f8:	74 11                	je     80090b <strncpy+0x2b>
		*dst++ = *src;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 0a             	movzbl (%edx),%ecx
  800900:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800903:	80 f9 01             	cmp    $0x1,%cl
  800906:	83 da ff             	sbb    $0xffffffff,%edx
  800909:	eb eb                	jmp    8008f6 <strncpy+0x16>
	}
	return ret;
}
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800911:	f3 0f 1e fb          	endbr32 
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	56                   	push   %esi
  800919:	53                   	push   %ebx
  80091a:	8b 75 08             	mov    0x8(%ebp),%esi
  80091d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800920:	8b 55 10             	mov    0x10(%ebp),%edx
  800923:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800925:	85 d2                	test   %edx,%edx
  800927:	74 21                	je     80094a <strlcpy+0x39>
  800929:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	74 14                	je     800947 <strlcpy+0x36>
  800933:	0f b6 19             	movzbl (%ecx),%ebx
  800936:	84 db                	test   %bl,%bl
  800938:	74 0b                	je     800945 <strlcpy+0x34>
			*dst++ = *src++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	88 5a ff             	mov    %bl,-0x1(%edx)
  800943:	eb ea                	jmp    80092f <strlcpy+0x1e>
  800945:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800947:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094a:	29 f0                	sub    %esi,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5e                   	pop    %esi
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 0c                	je     800970 <strcmp+0x20>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	75 08                	jne    800970 <strcmp+0x20>
		p++, q++;
  800968:	83 c1 01             	add    $0x1,%ecx
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	eb ed                	jmp    80095d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800970:	0f b6 c0             	movzbl %al,%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	89 c3                	mov    %eax,%ebx
  80098a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098d:	eb 06                	jmp    800995 <strncmp+0x1b>
		n--, p++, q++;
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800995:	39 d8                	cmp    %ebx,%eax
  800997:	74 16                	je     8009af <strncmp+0x35>
  800999:	0f b6 08             	movzbl (%eax),%ecx
  80099c:	84 c9                	test   %cl,%cl
  80099e:	74 04                	je     8009a4 <strncmp+0x2a>
  8009a0:	3a 0a                	cmp    (%edx),%cl
  8009a2:	74 eb                	je     80098f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a4:	0f b6 00             	movzbl (%eax),%eax
  8009a7:	0f b6 12             	movzbl (%edx),%edx
  8009aa:	29 d0                	sub    %edx,%eax
}
  8009ac:	5b                   	pop    %ebx
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    
		return 0;
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b4:	eb f6                	jmp    8009ac <strncmp+0x32>

008009b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b6:	f3 0f 1e fb          	endbr32 
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	0f b6 10             	movzbl (%eax),%edx
  8009c7:	84 d2                	test   %dl,%dl
  8009c9:	74 09                	je     8009d4 <strchr+0x1e>
		if (*s == c)
  8009cb:	38 ca                	cmp    %cl,%dl
  8009cd:	74 0a                	je     8009d9 <strchr+0x23>
	for (; *s; s++)
  8009cf:	83 c0 01             	add    $0x1,%eax
  8009d2:	eb f0                	jmp    8009c4 <strchr+0xe>
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ec:	38 ca                	cmp    %cl,%dl
  8009ee:	74 09                	je     8009f9 <strfind+0x1e>
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	74 05                	je     8009f9 <strfind+0x1e>
	for (; *s; s++)
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	eb f0                	jmp    8009e9 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0b:	85 c9                	test   %ecx,%ecx
  800a0d:	74 31                	je     800a40 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0f:	89 f8                	mov    %edi,%eax
  800a11:	09 c8                	or     %ecx,%eax
  800a13:	a8 03                	test   $0x3,%al
  800a15:	75 23                	jne    800a3a <memset+0x3f>
		c &= 0xFF;
  800a17:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1b:	89 d3                	mov    %edx,%ebx
  800a1d:	c1 e3 08             	shl    $0x8,%ebx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 18             	shl    $0x18,%eax
  800a25:	89 d6                	mov    %edx,%esi
  800a27:	c1 e6 10             	shl    $0x10,%esi
  800a2a:	09 f0                	or     %esi,%eax
  800a2c:	09 c2                	or     %eax,%edx
  800a2e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a30:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a33:	89 d0                	mov    %edx,%eax
  800a35:	fc                   	cld    
  800a36:	f3 ab                	rep stos %eax,%es:(%edi)
  800a38:	eb 06                	jmp    800a40 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	fc                   	cld    
  800a3e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a40:	89 f8                	mov    %edi,%eax
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	57                   	push   %edi
  800a4f:	56                   	push   %esi
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a59:	39 c6                	cmp    %eax,%esi
  800a5b:	73 32                	jae    800a8f <memmove+0x48>
  800a5d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a60:	39 c2                	cmp    %eax,%edx
  800a62:	76 2b                	jbe    800a8f <memmove+0x48>
		s += n;
		d += n;
  800a64:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a67:	89 fe                	mov    %edi,%esi
  800a69:	09 ce                	or     %ecx,%esi
  800a6b:	09 d6                	or     %edx,%esi
  800a6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a73:	75 0e                	jne    800a83 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a75:	83 ef 04             	sub    $0x4,%edi
  800a78:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7e:	fd                   	std    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb 09                	jmp    800a8c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a83:	83 ef 01             	sub    $0x1,%edi
  800a86:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a89:	fd                   	std    
  800a8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8c:	fc                   	cld    
  800a8d:	eb 1a                	jmp    800aa9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	09 ca                	or     %ecx,%edx
  800a93:	09 f2                	or     %esi,%edx
  800a95:	f6 c2 03             	test   $0x3,%dl
  800a98:	75 0a                	jne    800aa4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	fc                   	cld    
  800aa0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa2:	eb 05                	jmp    800aa9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aa4:	89 c7                	mov    %eax,%edi
  800aa6:	fc                   	cld    
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa9:	5e                   	pop    %esi
  800aaa:	5f                   	pop    %edi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aad:	f3 0f 1e fb          	endbr32 
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab7:	ff 75 10             	pushl  0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 82 ff ff ff       	call   800a47 <memmove>
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac7:	f3 0f 1e fb          	endbr32 
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	56                   	push   %esi
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad6:	89 c6                	mov    %eax,%esi
  800ad8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800adb:	39 f0                	cmp    %esi,%eax
  800add:	74 1c                	je     800afb <memcmp+0x34>
		if (*s1 != *s2)
  800adf:	0f b6 08             	movzbl (%eax),%ecx
  800ae2:	0f b6 1a             	movzbl (%edx),%ebx
  800ae5:	38 d9                	cmp    %bl,%cl
  800ae7:	75 08                	jne    800af1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae9:	83 c0 01             	add    $0x1,%eax
  800aec:	83 c2 01             	add    $0x1,%edx
  800aef:	eb ea                	jmp    800adb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800af1:	0f b6 c1             	movzbl %cl,%eax
  800af4:	0f b6 db             	movzbl %bl,%ebx
  800af7:	29 d8                	sub    %ebx,%eax
  800af9:	eb 05                	jmp    800b00 <memcmp+0x39>
	}

	return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b04:	f3 0f 1e fb          	endbr32 
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b16:	39 d0                	cmp    %edx,%eax
  800b18:	73 09                	jae    800b23 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b1a:	38 08                	cmp    %cl,(%eax)
  800b1c:	74 05                	je     800b23 <memfind+0x1f>
	for (; s < ends; s++)
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	eb f3                	jmp    800b16 <memfind+0x12>
			break;
	return (void *) s;
}
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b25:	f3 0f 1e fb          	endbr32 
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b35:	eb 03                	jmp    800b3a <strtol+0x15>
		s++;
  800b37:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3a:	0f b6 01             	movzbl (%ecx),%eax
  800b3d:	3c 20                	cmp    $0x20,%al
  800b3f:	74 f6                	je     800b37 <strtol+0x12>
  800b41:	3c 09                	cmp    $0x9,%al
  800b43:	74 f2                	je     800b37 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b45:	3c 2b                	cmp    $0x2b,%al
  800b47:	74 2a                	je     800b73 <strtol+0x4e>
	int neg = 0;
  800b49:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4e:	3c 2d                	cmp    $0x2d,%al
  800b50:	74 2b                	je     800b7d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b52:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b58:	75 0f                	jne    800b69 <strtol+0x44>
  800b5a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5d:	74 28                	je     800b87 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5f:	85 db                	test   %ebx,%ebx
  800b61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b66:	0f 44 d8             	cmove  %eax,%ebx
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b71:	eb 46                	jmp    800bb9 <strtol+0x94>
		s++;
  800b73:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b76:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7b:	eb d5                	jmp    800b52 <strtol+0x2d>
		s++, neg = 1;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	bf 01 00 00 00       	mov    $0x1,%edi
  800b85:	eb cb                	jmp    800b52 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b87:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8b:	74 0e                	je     800b9b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	75 d8                	jne    800b69 <strtol+0x44>
		s++, base = 8;
  800b91:	83 c1 01             	add    $0x1,%ecx
  800b94:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b99:	eb ce                	jmp    800b69 <strtol+0x44>
		s += 2, base = 16;
  800b9b:	83 c1 02             	add    $0x2,%ecx
  800b9e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba3:	eb c4                	jmp    800b69 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba5:	0f be d2             	movsbl %dl,%edx
  800ba8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bab:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bae:	7d 3a                	jge    800bea <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bb0:	83 c1 01             	add    $0x1,%ecx
  800bb3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb9:	0f b6 11             	movzbl (%ecx),%edx
  800bbc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbf:	89 f3                	mov    %esi,%ebx
  800bc1:	80 fb 09             	cmp    $0x9,%bl
  800bc4:	76 df                	jbe    800ba5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bc6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc9:	89 f3                	mov    %esi,%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 08                	ja     800bd8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd0:	0f be d2             	movsbl %dl,%edx
  800bd3:	83 ea 57             	sub    $0x57,%edx
  800bd6:	eb d3                	jmp    800bab <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bd8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdb:	89 f3                	mov    %esi,%ebx
  800bdd:	80 fb 19             	cmp    $0x19,%bl
  800be0:	77 08                	ja     800bea <strtol+0xc5>
			dig = *s - 'A' + 10;
  800be2:	0f be d2             	movsbl %dl,%edx
  800be5:	83 ea 37             	sub    $0x37,%edx
  800be8:	eb c1                	jmp    800bab <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bee:	74 05                	je     800bf5 <strtol+0xd0>
		*endptr = (char *) s;
  800bf0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf5:	89 c2                	mov    %eax,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	85 ff                	test   %edi,%edi
  800bfb:	0f 45 c2             	cmovne %edx,%eax
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c03:	f3 0f 1e fb          	endbr32 
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 c3                	mov    %eax,%ebx
  800c1a:	89 c7                	mov    %eax,%edi
  800c1c:	89 c6                	mov    %eax,%esi
  800c1e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c25:	f3 0f 1e fb          	endbr32 
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 01 00 00 00       	mov    $0x1,%eax
  800c39:	89 d1                	mov    %edx,%ecx
  800c3b:	89 d3                	mov    %edx,%ebx
  800c3d:	89 d7                	mov    %edx,%edi
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c48:	f3 0f 1e fb          	endbr32 
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c62:	89 cb                	mov    %ecx,%ebx
  800c64:	89 cf                	mov    %ecx,%edi
  800c66:	89 ce                	mov    %ecx,%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	50                   	push   %eax
  800c7a:	6a 03                	push   $0x3
  800c7c:	68 ff 29 80 00       	push   $0x8029ff
  800c81:	6a 23                	push   $0x23
  800c83:	68 1c 2a 80 00       	push   $0x802a1c
  800c88:	e8 13 f5 ff ff       	call   8001a0 <_panic>

00800c8d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8d:	f3 0f 1e fb          	endbr32 
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca1:	89 d1                	mov    %edx,%ecx
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	89 d6                	mov    %edx,%esi
  800ca9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_yield>:

void
sys_yield(void)
{
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	f3 0f 1e fb          	endbr32 
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	be 00 00 00 00       	mov    $0x0,%esi
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	89 f7                	mov    %esi,%edi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 04                	push   $0x4
  800d09:	68 ff 29 80 00       	push   $0x8029ff
  800d0e:	6a 23                	push   $0x23
  800d10:	68 1c 2a 80 00       	push   $0x802a1c
  800d15:	e8 86 f4 ff ff       	call   8001a0 <_panic>

00800d1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1a:	f3 0f 1e fb          	endbr32 
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d38:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 05                	push   $0x5
  800d4f:	68 ff 29 80 00       	push   $0x8029ff
  800d54:	6a 23                	push   $0x23
  800d56:	68 1c 2a 80 00       	push   $0x802a1c
  800d5b:	e8 40 f4 ff ff       	call   8001a0 <_panic>

00800d60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d60:	f3 0f 1e fb          	endbr32 
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	89 de                	mov    %ebx,%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 06                	push   $0x6
  800d95:	68 ff 29 80 00       	push   $0x8029ff
  800d9a:	6a 23                	push   $0x23
  800d9c:	68 1c 2a 80 00       	push   $0x802a1c
  800da1:	e8 fa f3 ff ff       	call   8001a0 <_panic>

00800da6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da6:	f3 0f 1e fb          	endbr32 
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 08                	push   $0x8
  800ddb:	68 ff 29 80 00       	push   $0x8029ff
  800de0:	6a 23                	push   $0x23
  800de2:	68 1c 2a 80 00       	push   $0x802a1c
  800de7:	e8 b4 f3 ff ff       	call   8001a0 <_panic>

00800dec <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	b8 09 00 00 00       	mov    $0x9,%eax
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 de                	mov    %ebx,%esi
  800e0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7f 08                	jg     800e1b <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	83 ec 0c             	sub    $0xc,%esp
  800e1e:	50                   	push   %eax
  800e1f:	6a 09                	push   $0x9
  800e21:	68 ff 29 80 00       	push   $0x8029ff
  800e26:	6a 23                	push   $0x23
  800e28:	68 1c 2a 80 00       	push   $0x802a1c
  800e2d:	e8 6e f3 ff ff       	call   8001a0 <_panic>

00800e32 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e32:	f3 0f 1e fb          	endbr32 
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0a                	push   $0xa
  800e67:	68 ff 29 80 00       	push   $0x8029ff
  800e6c:	6a 23                	push   $0x23
  800e6e:	68 1c 2a 80 00       	push   $0x802a1c
  800e73:	e8 28 f3 ff ff       	call   8001a0 <_panic>

00800e78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e78:	f3 0f 1e fb          	endbr32 
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8d:	be 00 00 00 00       	mov    $0x0,%esi
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e98:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9f:	f3 0f 1e fb          	endbr32 
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb9:	89 cb                	mov    %ecx,%ebx
  800ebb:	89 cf                	mov    %ecx,%edi
  800ebd:	89 ce                	mov    %ecx,%esi
  800ebf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7f 08                	jg     800ecd <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	50                   	push   %eax
  800ed1:	6a 0d                	push   $0xd
  800ed3:	68 ff 29 80 00       	push   $0x8029ff
  800ed8:	6a 23                	push   $0x23
  800eda:	68 1c 2a 80 00       	push   $0x802a1c
  800edf:	e8 bc f2 ff ff       	call   8001a0 <_panic>

00800ee4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ee4:	f3 0f 1e fb          	endbr32 
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	05 00 00 00 30       	add    $0x30000000,%eax
  800ef3:	c1 e8 0c             	shr    $0xc,%eax
}
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef8:	f3 0f 1e fb          	endbr32 
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f0c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f13:	f3 0f 1e fb          	endbr32 
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	c1 ea 16             	shr    $0x16,%edx
  800f24:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f2b:	f6 c2 01             	test   $0x1,%dl
  800f2e:	74 2d                	je     800f5d <fd_alloc+0x4a>
  800f30:	89 c2                	mov    %eax,%edx
  800f32:	c1 ea 0c             	shr    $0xc,%edx
  800f35:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3c:	f6 c2 01             	test   $0x1,%dl
  800f3f:	74 1c                	je     800f5d <fd_alloc+0x4a>
  800f41:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f46:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f4b:	75 d2                	jne    800f1f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f56:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f5b:	eb 0a                	jmp    800f67 <fd_alloc+0x54>
			*fd_store = fd;
  800f5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f60:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f69:	f3 0f 1e fb          	endbr32 
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f73:	83 f8 1f             	cmp    $0x1f,%eax
  800f76:	77 30                	ja     800fa8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f78:	c1 e0 0c             	shl    $0xc,%eax
  800f7b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f80:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f86:	f6 c2 01             	test   $0x1,%dl
  800f89:	74 24                	je     800faf <fd_lookup+0x46>
  800f8b:	89 c2                	mov    %eax,%edx
  800f8d:	c1 ea 0c             	shr    $0xc,%edx
  800f90:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f97:	f6 c2 01             	test   $0x1,%dl
  800f9a:	74 1a                	je     800fb6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9f:	89 02                	mov    %eax,(%edx)
	return 0;
  800fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
		return -E_INVAL;
  800fa8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fad:	eb f7                	jmp    800fa6 <fd_lookup+0x3d>
		return -E_INVAL;
  800faf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb4:	eb f0                	jmp    800fa6 <fd_lookup+0x3d>
  800fb6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fbb:	eb e9                	jmp    800fa6 <fd_lookup+0x3d>

00800fbd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fbd:	f3 0f 1e fb          	endbr32 
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fca:	ba a8 2a 80 00       	mov    $0x802aa8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fcf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fd4:	39 08                	cmp    %ecx,(%eax)
  800fd6:	74 33                	je     80100b <dev_lookup+0x4e>
  800fd8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fdb:	8b 02                	mov    (%edx),%eax
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	75 f3                	jne    800fd4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fe1:	a1 04 40 80 00       	mov    0x804004,%eax
  800fe6:	8b 40 48             	mov    0x48(%eax),%eax
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	51                   	push   %ecx
  800fed:	50                   	push   %eax
  800fee:	68 2c 2a 80 00       	push   $0x802a2c
  800ff3:	e8 8f f2 ff ff       	call   800287 <cprintf>
	*dev = 0;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    
			*dev = devtab[i];
  80100b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
  801015:	eb f2                	jmp    801009 <dev_lookup+0x4c>

00801017 <fd_close>:
{
  801017:	f3 0f 1e fb          	endbr32 
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
  801021:	83 ec 24             	sub    $0x24,%esp
  801024:	8b 75 08             	mov    0x8(%ebp),%esi
  801027:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80102a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80102d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801034:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801037:	50                   	push   %eax
  801038:	e8 2c ff ff ff       	call   800f69 <fd_lookup>
  80103d:	89 c3                	mov    %eax,%ebx
  80103f:	83 c4 10             	add    $0x10,%esp
  801042:	85 c0                	test   %eax,%eax
  801044:	78 05                	js     80104b <fd_close+0x34>
	    || fd != fd2)
  801046:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801049:	74 16                	je     801061 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80104b:	89 f8                	mov    %edi,%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	b8 00 00 00 00       	mov    $0x0,%eax
  801054:	0f 44 d8             	cmove  %eax,%ebx
}
  801057:	89 d8                	mov    %ebx,%eax
  801059:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801067:	50                   	push   %eax
  801068:	ff 36                	pushl  (%esi)
  80106a:	e8 4e ff ff ff       	call   800fbd <dev_lookup>
  80106f:	89 c3                	mov    %eax,%ebx
  801071:	83 c4 10             	add    $0x10,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	78 1a                	js     801092 <fd_close+0x7b>
		if (dev->dev_close)
  801078:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801083:	85 c0                	test   %eax,%eax
  801085:	74 0b                	je     801092 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801087:	83 ec 0c             	sub    $0xc,%esp
  80108a:	56                   	push   %esi
  80108b:	ff d0                	call   *%eax
  80108d:	89 c3                	mov    %eax,%ebx
  80108f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801092:	83 ec 08             	sub    $0x8,%esp
  801095:	56                   	push   %esi
  801096:	6a 00                	push   $0x0
  801098:	e8 c3 fc ff ff       	call   800d60 <sys_page_unmap>
	return r;
  80109d:	83 c4 10             	add    $0x10,%esp
  8010a0:	eb b5                	jmp    801057 <fd_close+0x40>

008010a2 <close>:

int
close(int fdnum)
{
  8010a2:	f3 0f 1e fb          	endbr32 
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010af:	50                   	push   %eax
  8010b0:	ff 75 08             	pushl  0x8(%ebp)
  8010b3:	e8 b1 fe ff ff       	call   800f69 <fd_lookup>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	79 02                	jns    8010c1 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    
		return fd_close(fd, 1);
  8010c1:	83 ec 08             	sub    $0x8,%esp
  8010c4:	6a 01                	push   $0x1
  8010c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c9:	e8 49 ff ff ff       	call   801017 <fd_close>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	eb ec                	jmp    8010bf <close+0x1d>

008010d3 <close_all>:

void
close_all(void)
{
  8010d3:	f3 0f 1e fb          	endbr32 
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	53                   	push   %ebx
  8010db:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010de:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010e3:	83 ec 0c             	sub    $0xc,%esp
  8010e6:	53                   	push   %ebx
  8010e7:	e8 b6 ff ff ff       	call   8010a2 <close>
	for (i = 0; i < MAXFD; i++)
  8010ec:	83 c3 01             	add    $0x1,%ebx
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	83 fb 20             	cmp    $0x20,%ebx
  8010f5:	75 ec                	jne    8010e3 <close_all+0x10>
}
  8010f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010fc:	f3 0f 1e fb          	endbr32 
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801109:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80110c:	50                   	push   %eax
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 54 fe ff ff       	call   800f69 <fd_lookup>
  801115:	89 c3                	mov    %eax,%ebx
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	0f 88 81 00 00 00    	js     8011a3 <dup+0xa7>
		return r;
	close(newfdnum);
  801122:	83 ec 0c             	sub    $0xc,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	e8 75 ff ff ff       	call   8010a2 <close>

	newfd = INDEX2FD(newfdnum);
  80112d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801130:	c1 e6 0c             	shl    $0xc,%esi
  801133:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801139:	83 c4 04             	add    $0x4,%esp
  80113c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113f:	e8 b4 fd ff ff       	call   800ef8 <fd2data>
  801144:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801146:	89 34 24             	mov    %esi,(%esp)
  801149:	e8 aa fd ff ff       	call   800ef8 <fd2data>
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801153:	89 d8                	mov    %ebx,%eax
  801155:	c1 e8 16             	shr    $0x16,%eax
  801158:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115f:	a8 01                	test   $0x1,%al
  801161:	74 11                	je     801174 <dup+0x78>
  801163:	89 d8                	mov    %ebx,%eax
  801165:	c1 e8 0c             	shr    $0xc,%eax
  801168:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80116f:	f6 c2 01             	test   $0x1,%dl
  801172:	75 39                	jne    8011ad <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801174:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801177:	89 d0                	mov    %edx,%eax
  801179:	c1 e8 0c             	shr    $0xc,%eax
  80117c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	25 07 0e 00 00       	and    $0xe07,%eax
  80118b:	50                   	push   %eax
  80118c:	56                   	push   %esi
  80118d:	6a 00                	push   $0x0
  80118f:	52                   	push   %edx
  801190:	6a 00                	push   $0x0
  801192:	e8 83 fb ff ff       	call   800d1a <sys_page_map>
  801197:	89 c3                	mov    %eax,%ebx
  801199:	83 c4 20             	add    $0x20,%esp
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 31                	js     8011d1 <dup+0xd5>
		goto err;

	return newfdnum;
  8011a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011a3:	89 d8                	mov    %ebx,%eax
  8011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bc:	50                   	push   %eax
  8011bd:	57                   	push   %edi
  8011be:	6a 00                	push   $0x0
  8011c0:	53                   	push   %ebx
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 52 fb ff ff       	call   800d1a <sys_page_map>
  8011c8:	89 c3                	mov    %eax,%ebx
  8011ca:	83 c4 20             	add    $0x20,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	79 a3                	jns    801174 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	56                   	push   %esi
  8011d5:	6a 00                	push   $0x0
  8011d7:	e8 84 fb ff ff       	call   800d60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011dc:	83 c4 08             	add    $0x8,%esp
  8011df:	57                   	push   %edi
  8011e0:	6a 00                	push   $0x0
  8011e2:	e8 79 fb ff ff       	call   800d60 <sys_page_unmap>
	return r;
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	eb b7                	jmp    8011a3 <dup+0xa7>

008011ec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011ec:	f3 0f 1e fb          	endbr32 
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 1c             	sub    $0x1c,%esp
  8011f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	53                   	push   %ebx
  8011ff:	e8 65 fd ff ff       	call   800f69 <fd_lookup>
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	78 3f                	js     80124a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801211:	50                   	push   %eax
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	ff 30                	pushl  (%eax)
  801217:	e8 a1 fd ff ff       	call   800fbd <dev_lookup>
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	78 27                	js     80124a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801223:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801226:	8b 42 08             	mov    0x8(%edx),%eax
  801229:	83 e0 03             	and    $0x3,%eax
  80122c:	83 f8 01             	cmp    $0x1,%eax
  80122f:	74 1e                	je     80124f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801234:	8b 40 08             	mov    0x8(%eax),%eax
  801237:	85 c0                	test   %eax,%eax
  801239:	74 35                	je     801270 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80123b:	83 ec 04             	sub    $0x4,%esp
  80123e:	ff 75 10             	pushl  0x10(%ebp)
  801241:	ff 75 0c             	pushl  0xc(%ebp)
  801244:	52                   	push   %edx
  801245:	ff d0                	call   *%eax
  801247:	83 c4 10             	add    $0x10,%esp
}
  80124a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80124f:	a1 04 40 80 00       	mov    0x804004,%eax
  801254:	8b 40 48             	mov    0x48(%eax),%eax
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	53                   	push   %ebx
  80125b:	50                   	push   %eax
  80125c:	68 6d 2a 80 00       	push   $0x802a6d
  801261:	e8 21 f0 ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126e:	eb da                	jmp    80124a <read+0x5e>
		return -E_NOT_SUPP;
  801270:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801275:	eb d3                	jmp    80124a <read+0x5e>

00801277 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801277:	f3 0f 1e fb          	endbr32 
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	57                   	push   %edi
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
  801281:	83 ec 0c             	sub    $0xc,%esp
  801284:	8b 7d 08             	mov    0x8(%ebp),%edi
  801287:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80128a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128f:	eb 02                	jmp    801293 <readn+0x1c>
  801291:	01 c3                	add    %eax,%ebx
  801293:	39 f3                	cmp    %esi,%ebx
  801295:	73 21                	jae    8012b8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	89 f0                	mov    %esi,%eax
  80129c:	29 d8                	sub    %ebx,%eax
  80129e:	50                   	push   %eax
  80129f:	89 d8                	mov    %ebx,%eax
  8012a1:	03 45 0c             	add    0xc(%ebp),%eax
  8012a4:	50                   	push   %eax
  8012a5:	57                   	push   %edi
  8012a6:	e8 41 ff ff ff       	call   8011ec <read>
		if (m < 0)
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 04                	js     8012b6 <readn+0x3f>
			return m;
		if (m == 0)
  8012b2:	75 dd                	jne    801291 <readn+0x1a>
  8012b4:	eb 02                	jmp    8012b8 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012b8:	89 d8                	mov    %ebx,%eax
  8012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bd:	5b                   	pop    %ebx
  8012be:	5e                   	pop    %esi
  8012bf:	5f                   	pop    %edi
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012c2:	f3 0f 1e fb          	endbr32 
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	53                   	push   %ebx
  8012ca:	83 ec 1c             	sub    $0x1c,%esp
  8012cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d3:	50                   	push   %eax
  8012d4:	53                   	push   %ebx
  8012d5:	e8 8f fc ff ff       	call   800f69 <fd_lookup>
  8012da:	83 c4 10             	add    $0x10,%esp
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	78 3a                	js     80131b <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e1:	83 ec 08             	sub    $0x8,%esp
  8012e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012eb:	ff 30                	pushl  (%eax)
  8012ed:	e8 cb fc ff ff       	call   800fbd <dev_lookup>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 22                	js     80131b <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801300:	74 1e                	je     801320 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	8b 52 0c             	mov    0xc(%edx),%edx
  801308:	85 d2                	test   %edx,%edx
  80130a:	74 35                	je     801341 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80130c:	83 ec 04             	sub    $0x4,%esp
  80130f:	ff 75 10             	pushl  0x10(%ebp)
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	50                   	push   %eax
  801316:	ff d2                	call   *%edx
  801318:	83 c4 10             	add    $0x10,%esp
}
  80131b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801320:	a1 04 40 80 00       	mov    0x804004,%eax
  801325:	8b 40 48             	mov    0x48(%eax),%eax
  801328:	83 ec 04             	sub    $0x4,%esp
  80132b:	53                   	push   %ebx
  80132c:	50                   	push   %eax
  80132d:	68 89 2a 80 00       	push   $0x802a89
  801332:	e8 50 ef ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133f:	eb da                	jmp    80131b <write+0x59>
		return -E_NOT_SUPP;
  801341:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801346:	eb d3                	jmp    80131b <write+0x59>

00801348 <seek>:

int
seek(int fdnum, off_t offset)
{
  801348:	f3 0f 1e fb          	endbr32 
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801352:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801355:	50                   	push   %eax
  801356:	ff 75 08             	pushl  0x8(%ebp)
  801359:	e8 0b fc ff ff       	call   800f69 <fd_lookup>
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	78 0e                	js     801373 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801365:	8b 55 0c             	mov    0xc(%ebp),%edx
  801368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80136e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801375:	f3 0f 1e fb          	endbr32 
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	53                   	push   %ebx
  80137d:	83 ec 1c             	sub    $0x1c,%esp
  801380:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801383:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801386:	50                   	push   %eax
  801387:	53                   	push   %ebx
  801388:	e8 dc fb ff ff       	call   800f69 <fd_lookup>
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 37                	js     8013cb <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139a:	50                   	push   %eax
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	ff 30                	pushl  (%eax)
  8013a0:	e8 18 fc ff ff       	call   800fbd <dev_lookup>
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 1f                	js     8013cb <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013b3:	74 1b                	je     8013d0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b8:	8b 52 18             	mov    0x18(%edx),%edx
  8013bb:	85 d2                	test   %edx,%edx
  8013bd:	74 32                	je     8013f1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	ff 75 0c             	pushl  0xc(%ebp)
  8013c5:	50                   	push   %eax
  8013c6:	ff d2                	call   *%edx
  8013c8:	83 c4 10             	add    $0x10,%esp
}
  8013cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013d0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d5:	8b 40 48             	mov    0x48(%eax),%eax
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	53                   	push   %ebx
  8013dc:	50                   	push   %eax
  8013dd:	68 4c 2a 80 00       	push   $0x802a4c
  8013e2:	e8 a0 ee ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ef:	eb da                	jmp    8013cb <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f6:	eb d3                	jmp    8013cb <ftruncate+0x56>

008013f8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013f8:	f3 0f 1e fb          	endbr32 
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	53                   	push   %ebx
  801400:	83 ec 1c             	sub    $0x1c,%esp
  801403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801406:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801409:	50                   	push   %eax
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	e8 57 fb ff ff       	call   800f69 <fd_lookup>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 4b                	js     801464 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801423:	ff 30                	pushl  (%eax)
  801425:	e8 93 fb ff ff       	call   800fbd <dev_lookup>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 33                	js     801464 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801434:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801438:	74 2f                	je     801469 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80143a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80143d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801444:	00 00 00 
	stat->st_isdir = 0;
  801447:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80144e:	00 00 00 
	stat->st_dev = dev;
  801451:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	53                   	push   %ebx
  80145b:	ff 75 f0             	pushl  -0x10(%ebp)
  80145e:	ff 50 14             	call   *0x14(%eax)
  801461:	83 c4 10             	add    $0x10,%esp
}
  801464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801467:	c9                   	leave  
  801468:	c3                   	ret    
		return -E_NOT_SUPP;
  801469:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146e:	eb f4                	jmp    801464 <fstat+0x6c>

00801470 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801470:	f3 0f 1e fb          	endbr32 
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	56                   	push   %esi
  801478:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	6a 00                	push   $0x0
  80147e:	ff 75 08             	pushl  0x8(%ebp)
  801481:	e8 fb 01 00 00       	call   801681 <open>
  801486:	89 c3                	mov    %eax,%ebx
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 1b                	js     8014aa <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	ff 75 0c             	pushl  0xc(%ebp)
  801495:	50                   	push   %eax
  801496:	e8 5d ff ff ff       	call   8013f8 <fstat>
  80149b:	89 c6                	mov    %eax,%esi
	close(fd);
  80149d:	89 1c 24             	mov    %ebx,(%esp)
  8014a0:	e8 fd fb ff ff       	call   8010a2 <close>
	return r;
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	89 f3                	mov    %esi,%ebx
}
  8014aa:	89 d8                	mov    %ebx,%eax
  8014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014af:	5b                   	pop    %ebx
  8014b0:	5e                   	pop    %esi
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	56                   	push   %esi
  8014b7:	53                   	push   %ebx
  8014b8:	89 c6                	mov    %eax,%esi
  8014ba:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014bc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014c3:	74 27                	je     8014ec <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014c5:	6a 07                	push   $0x7
  8014c7:	68 00 50 80 00       	push   $0x805000
  8014cc:	56                   	push   %esi
  8014cd:	ff 35 00 40 80 00    	pushl  0x804000
  8014d3:	e8 d5 0d 00 00       	call   8022ad <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014d8:	83 c4 0c             	add    $0xc,%esp
  8014db:	6a 00                	push   $0x0
  8014dd:	53                   	push   %ebx
  8014de:	6a 00                	push   $0x0
  8014e0:	e8 5b 0d 00 00       	call   802240 <ipc_recv>
}
  8014e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e8:	5b                   	pop    %ebx
  8014e9:	5e                   	pop    %esi
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	6a 01                	push   $0x1
  8014f1:	e8 11 0e 00 00       	call   802307 <ipc_find_env>
  8014f6:	a3 00 40 80 00       	mov    %eax,0x804000
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	eb c5                	jmp    8014c5 <fsipc+0x12>

00801500 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801500:	f3 0f 1e fb          	endbr32 
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8b 40 0c             	mov    0xc(%eax),%eax
  801510:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80151d:	ba 00 00 00 00       	mov    $0x0,%edx
  801522:	b8 02 00 00 00       	mov    $0x2,%eax
  801527:	e8 87 ff ff ff       	call   8014b3 <fsipc>
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <devfile_flush>:
{
  80152e:	f3 0f 1e fb          	endbr32 
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8b 40 0c             	mov    0xc(%eax),%eax
  80153e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801543:	ba 00 00 00 00       	mov    $0x0,%edx
  801548:	b8 06 00 00 00       	mov    $0x6,%eax
  80154d:	e8 61 ff ff ff       	call   8014b3 <fsipc>
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <devfile_stat>:
{
  801554:	f3 0f 1e fb          	endbr32 
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	53                   	push   %ebx
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	8b 40 0c             	mov    0xc(%eax),%eax
  801568:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80156d:	ba 00 00 00 00       	mov    $0x0,%edx
  801572:	b8 05 00 00 00       	mov    $0x5,%eax
  801577:	e8 37 ff ff ff       	call   8014b3 <fsipc>
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 2c                	js     8015ac <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	68 00 50 80 00       	push   $0x805000
  801588:	53                   	push   %ebx
  801589:	e8 03 f3 ff ff       	call   800891 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80158e:	a1 80 50 80 00       	mov    0x805080,%eax
  801593:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801599:	a1 84 50 80 00       	mov    0x805084,%eax
  80159e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <devfile_write>:
{
  8015b1:	f3 0f 1e fb          	endbr32 
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015be:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015c3:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015c8:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ce:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d1:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8015d7:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  8015dc:	50                   	push   %eax
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	68 08 50 80 00       	push   $0x805008
  8015e5:	e8 5d f4 ff ff       	call   800a47 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 04 00 00 00       	mov    $0x4,%eax
  8015f4:	e8 ba fe ff ff       	call   8014b3 <fsipc>
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <devfile_read>:
{
  8015fb:	f3 0f 1e fb          	endbr32 
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
  801604:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8b 40 0c             	mov    0xc(%eax),%eax
  80160d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801612:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	b8 03 00 00 00       	mov    $0x3,%eax
  801622:	e8 8c fe ff ff       	call   8014b3 <fsipc>
  801627:	89 c3                	mov    %eax,%ebx
  801629:	85 c0                	test   %eax,%eax
  80162b:	78 1f                	js     80164c <devfile_read+0x51>
	assert(r <= n);
  80162d:	39 f0                	cmp    %esi,%eax
  80162f:	77 24                	ja     801655 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801631:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801636:	7f 33                	jg     80166b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	50                   	push   %eax
  80163c:	68 00 50 80 00       	push   $0x805000
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 fe f3 ff ff       	call   800a47 <memmove>
	return r;
  801649:	83 c4 10             	add    $0x10,%esp
}
  80164c:	89 d8                	mov    %ebx,%eax
  80164e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    
	assert(r <= n);
  801655:	68 b8 2a 80 00       	push   $0x802ab8
  80165a:	68 bf 2a 80 00       	push   $0x802abf
  80165f:	6a 7d                	push   $0x7d
  801661:	68 d4 2a 80 00       	push   $0x802ad4
  801666:	e8 35 eb ff ff       	call   8001a0 <_panic>
	assert(r <= PGSIZE);
  80166b:	68 df 2a 80 00       	push   $0x802adf
  801670:	68 bf 2a 80 00       	push   $0x802abf
  801675:	6a 7e                	push   $0x7e
  801677:	68 d4 2a 80 00       	push   $0x802ad4
  80167c:	e8 1f eb ff ff       	call   8001a0 <_panic>

00801681 <open>:
{
  801681:	f3 0f 1e fb          	endbr32 
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	56                   	push   %esi
  801689:	53                   	push   %ebx
  80168a:	83 ec 1c             	sub    $0x1c,%esp
  80168d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801690:	56                   	push   %esi
  801691:	e8 b8 f1 ff ff       	call   80084e <strlen>
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80169e:	7f 6c                	jg     80170c <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016a0:	83 ec 0c             	sub    $0xc,%esp
  8016a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 67 f8 ff ff       	call   800f13 <fd_alloc>
  8016ac:	89 c3                	mov    %eax,%ebx
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 3c                	js     8016f1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	56                   	push   %esi
  8016b9:	68 00 50 80 00       	push   $0x805000
  8016be:	e8 ce f1 ff ff       	call   800891 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d3:	e8 db fd ff ff       	call   8014b3 <fsipc>
  8016d8:	89 c3                	mov    %eax,%ebx
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 19                	js     8016fa <open+0x79>
	return fd2num(fd);
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e7:	e8 f8 f7 ff ff       	call   800ee4 <fd2num>
  8016ec:	89 c3                	mov    %eax,%ebx
  8016ee:	83 c4 10             	add    $0x10,%esp
}
  8016f1:	89 d8                	mov    %ebx,%eax
  8016f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    
		fd_close(fd, 0);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	6a 00                	push   $0x0
  8016ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801702:	e8 10 f9 ff ff       	call   801017 <fd_close>
		return r;
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	eb e5                	jmp    8016f1 <open+0x70>
		return -E_BAD_PATH;
  80170c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801711:	eb de                	jmp    8016f1 <open+0x70>

00801713 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801713:	f3 0f 1e fb          	endbr32 
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80171d:	ba 00 00 00 00       	mov    $0x0,%edx
  801722:	b8 08 00 00 00       	mov    $0x8,%eax
  801727:	e8 87 fd ff ff       	call   8014b3 <fsipc>
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80172e:	f3 0f 1e fb          	endbr32 
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	57                   	push   %edi
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	//cprintf("spawn start\n");
	if ((r = open(prog, O_RDONLY)) < 0)
  80173e:	6a 00                	push   $0x0
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	e8 39 ff ff ff       	call   801681 <open>
  801748:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	0f 88 e9 04 00 00    	js     801c42 <spawn+0x514>
  801759:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;
	
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 00 02 00 00       	push   $0x200
  801763:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801769:	50                   	push   %eax
  80176a:	51                   	push   %ecx
  80176b:	e8 07 fb ff ff       	call   801277 <readn>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	3d 00 02 00 00       	cmp    $0x200,%eax
  801778:	75 7e                	jne    8017f8 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  80177a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801781:	45 4c 46 
  801784:	75 72                	jne    8017f8 <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801786:	b8 07 00 00 00       	mov    $0x7,%eax
  80178b:	cd 30                	int    $0x30
  80178d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801793:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801799:	85 c0                	test   %eax,%eax
  80179b:	0f 88 95 04 00 00    	js     801c36 <spawn+0x508>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8017a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017a6:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8017a9:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8017af:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017b5:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017ba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8017bc:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8017c2:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	char *string_store;
	uintptr_t *argv_store;
	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8017c8:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8017cd:	be 00 00 00 00       	mov    $0x0,%esi
  8017d2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8017d5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  8017dc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	74 4d                	je     801830 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	50                   	push   %eax
  8017e7:	e8 62 f0 ff ff       	call   80084e <strlen>
  8017ec:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8017f0:	83 c3 01             	add    $0x1,%ebx
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	eb dd                	jmp    8017d5 <spawn+0xa7>
		close(fd);
  8017f8:	83 ec 0c             	sub    $0xc,%esp
  8017fb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801801:	e8 9c f8 ff ff       	call   8010a2 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801806:	83 c4 0c             	add    $0xc,%esp
  801809:	68 7f 45 4c 46       	push   $0x464c457f
  80180e:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801814:	68 eb 2a 80 00       	push   $0x802aeb
  801819:	e8 69 ea ff ff       	call   800287 <cprintf>
		return -E_NOT_EXEC;
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801828:	ff ff ff 
  80182b:	e9 12 04 00 00       	jmp    801c42 <spawn+0x514>
  801830:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801836:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80183c:	bf 00 10 40 00       	mov    $0x401000,%edi
  801841:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801843:	89 fa                	mov    %edi,%edx
  801845:	83 e2 fc             	and    $0xfffffffc,%edx
  801848:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80184f:	29 c2                	sub    %eax,%edx
  801851:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801857:	8d 42 f8             	lea    -0x8(%edx),%eax
  80185a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80185f:	0f 86 00 04 00 00    	jbe    801c65 <spawn+0x537>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	6a 07                	push   $0x7
  80186a:	68 00 00 40 00       	push   $0x400000
  80186f:	6a 00                	push   $0x0
  801871:	e8 5d f4 ff ff       	call   800cd3 <sys_page_alloc>
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	85 c0                	test   %eax,%eax
  80187b:	0f 88 e9 03 00 00    	js     801c6a <spawn+0x53c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)

	for (i = 0; i < argc; i++) {
  801881:	be 00 00 00 00       	mov    $0x0,%esi
  801886:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80188c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80188f:	eb 30                	jmp    8018c1 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801891:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801897:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80189d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8018a0:	83 ec 08             	sub    $0x8,%esp
  8018a3:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018a6:	57                   	push   %edi
  8018a7:	e8 e5 ef ff ff       	call   800891 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018ac:	83 c4 04             	add    $0x4,%esp
  8018af:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018b2:	e8 97 ef ff ff       	call   80084e <strlen>
  8018b7:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8018bb:	83 c6 01             	add    $0x1,%esi
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8018c7:	7f c8                	jg     801891 <spawn+0x163>
	}

	argv_store[argc] = 0;
  8018c9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8018cf:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8018d5:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018dc:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8018e2:	0f 85 82 00 00 00    	jne    80196a <spawn+0x23c>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8018e8:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8018ee:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8018f4:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8018f7:	89 c8                	mov    %ecx,%eax
  8018f9:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8018ff:	89 51 f8             	mov    %edx,-0x8(%ecx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801902:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801907:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	6a 07                	push   $0x7
  801912:	68 00 d0 bf ee       	push   $0xeebfd000
  801917:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80191d:	68 00 00 40 00       	push   $0x400000
  801922:	6a 00                	push   $0x0
  801924:	e8 f1 f3 ff ff       	call   800d1a <sys_page_map>
  801929:	83 c4 20             	add    $0x20,%esp
  80192c:	85 c0                	test   %eax,%eax
  80192e:	0f 88 41 03 00 00    	js     801c75 <spawn+0x547>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	68 00 00 40 00       	push   $0x400000
  80193c:	6a 00                	push   $0x0
  80193e:	e8 1d f4 ff ff       	call   800d60 <sys_page_unmap>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	0f 88 27 03 00 00    	js     801c75 <spawn+0x547>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80194e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801954:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80195b:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801962:	00 00 00 
  801965:	e9 4f 01 00 00       	jmp    801ab9 <spawn+0x38b>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80196a:	68 60 2b 80 00       	push   $0x802b60
  80196f:	68 bf 2a 80 00       	push   $0x802abf
  801974:	68 ea 00 00 00       	push   $0xea
  801979:	68 05 2b 80 00       	push   $0x802b05
  80197e:	e8 1d e8 ff ff       	call   8001a0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	6a 07                	push   $0x7
  801988:	68 00 00 40 00       	push   $0x400000
  80198d:	6a 00                	push   $0x0
  80198f:	e8 3f f3 ff ff       	call   800cd3 <sys_page_alloc>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	0f 88 b1 02 00 00    	js     801c50 <spawn+0x522>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019a8:	01 f0                	add    %esi,%eax
  8019aa:	50                   	push   %eax
  8019ab:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019b1:	e8 92 f9 ff ff       	call   801348 <seek>
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	0f 88 96 02 00 00    	js     801c57 <spawn+0x529>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019ca:	29 f0                	sub    %esi,%eax
  8019cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8019d6:	0f 47 c1             	cmova  %ecx,%eax
  8019d9:	50                   	push   %eax
  8019da:	68 00 00 40 00       	push   $0x400000
  8019df:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019e5:	e8 8d f8 ff ff       	call   801277 <readn>
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	0f 88 69 02 00 00    	js     801c5e <spawn+0x530>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019fe:	53                   	push   %ebx
  8019ff:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a05:	68 00 00 40 00       	push   $0x400000
  801a0a:	6a 00                	push   $0x0
  801a0c:	e8 09 f3 ff ff       	call   800d1a <sys_page_map>
  801a11:	83 c4 20             	add    $0x20,%esp
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 7c                	js     801a94 <spawn+0x366>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	68 00 00 40 00       	push   $0x400000
  801a20:	6a 00                	push   $0x0
  801a22:	e8 39 f3 ff ff       	call   800d60 <sys_page_unmap>
  801a27:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a2a:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801a30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a36:	89 fe                	mov    %edi,%esi
  801a38:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801a3e:	76 69                	jbe    801aa9 <spawn+0x37b>
		if (i >= filesz) {
  801a40:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801a46:	0f 87 37 ff ff ff    	ja     801983 <spawn+0x255>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a55:	53                   	push   %ebx
  801a56:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a5c:	e8 72 f2 ff ff       	call   800cd3 <sys_page_alloc>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	79 c2                	jns    801a2a <spawn+0x2fc>
  801a68:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a73:	e8 d0 f1 ff ff       	call   800c48 <sys_env_destroy>
	close(fd);
  801a78:	83 c4 04             	add    $0x4,%esp
  801a7b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a81:	e8 1c f6 ff ff       	call   8010a2 <close>
	return r;
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801a8f:	e9 ae 01 00 00       	jmp    801c42 <spawn+0x514>
				panic("spawn: sys_page_map data: %e", r);
  801a94:	50                   	push   %eax
  801a95:	68 11 2b 80 00       	push   $0x802b11
  801a9a:	68 1b 01 00 00       	push   $0x11b
  801a9f:	68 05 2b 80 00       	push   $0x802b05
  801aa4:	e8 f7 e6 ff ff       	call   8001a0 <_panic>
  801aa9:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801aaf:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ab6:	83 c6 20             	add    $0x20,%esi
  801ab9:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ac0:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801ac6:	7e 6d                	jle    801b35 <spawn+0x407>
		if (ph->p_type != ELF_PROG_LOAD)
  801ac8:	83 3e 01             	cmpl   $0x1,(%esi)
  801acb:	75 e2                	jne    801aaf <spawn+0x381>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801acd:	8b 46 18             	mov    0x18(%esi),%eax
  801ad0:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801ad3:	83 f8 01             	cmp    $0x1,%eax
  801ad6:	19 c0                	sbb    %eax,%eax
  801ad8:	83 e0 fe             	and    $0xfffffffe,%eax
  801adb:	83 c0 07             	add    $0x7,%eax
  801ade:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ae4:	8b 4e 04             	mov    0x4(%esi),%ecx
  801ae7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801aed:	8b 56 10             	mov    0x10(%esi),%edx
  801af0:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801af6:	8b 7e 14             	mov    0x14(%esi),%edi
  801af9:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801aff:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801b02:	89 d8                	mov    %ebx,%eax
  801b04:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b09:	74 1a                	je     801b25 <spawn+0x3f7>
		va -= i;
  801b0b:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801b0d:	01 c7                	add    %eax,%edi
  801b0f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801b15:	01 c2                	add    %eax,%edx
  801b17:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801b1d:	29 c1                	sub    %eax,%ecx
  801b1f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b25:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2a:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801b30:	e9 01 ff ff ff       	jmp    801a36 <spawn+0x308>
	close(fd);
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b3e:	e8 5f f5 ff ff       	call   8010a2 <close>
  801b43:	83 c4 10             	add    $0x10,%esp
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  801b46:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801b4b:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801b51:	eb 33                	jmp    801b86 <spawn+0x458>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
		sys_page_map(thisenv->env_id,(void *)addr,child,(void *)addr,(uvpt[PGNUM(addr)] & PTE_SYSCALL));
  801b53:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b5a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b60:	8b 52 48             	mov    0x48(%edx),%edx
  801b63:	83 ec 0c             	sub    $0xc,%esp
  801b66:	25 07 0e 00 00       	and    $0xe07,%eax
  801b6b:	50                   	push   %eax
  801b6c:	53                   	push   %ebx
  801b6d:	56                   	push   %esi
  801b6e:	53                   	push   %ebx
  801b6f:	52                   	push   %edx
  801b70:	e8 a5 f1 ff ff       	call   800d1a <sys_page_map>
  801b75:	83 c4 20             	add    $0x20,%esp
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  801b78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b7e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801b84:	74 3b                	je     801bc1 <spawn+0x493>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	c1 e8 16             	shr    $0x16,%eax
  801b8b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b92:	a8 01                	test   $0x1,%al
  801b94:	74 e2                	je     801b78 <spawn+0x44a>
  801b96:	89 d8                	mov    %ebx,%eax
  801b98:	c1 e8 0c             	shr    $0xc,%eax
  801b9b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ba2:	f6 c2 01             	test   $0x1,%dl
  801ba5:	74 d1                	je     801b78 <spawn+0x44a>
  801ba7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bae:	f6 c2 04             	test   $0x4,%dl
  801bb1:	74 c5                	je     801b78 <spawn+0x44a>
  801bb3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801bba:	f6 c6 04             	test   $0x4,%dh
  801bbd:	74 b9                	je     801b78 <spawn+0x44a>
  801bbf:	eb 92                	jmp    801b53 <spawn+0x425>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801bc1:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801bc8:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801bcb:	83 ec 08             	sub    $0x8,%esp
  801bce:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801bd4:	50                   	push   %eax
  801bd5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bdb:	e8 0c f2 ff ff       	call   800dec <sys_env_set_trapframe>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 25                	js     801c0c <spawn+0x4de>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	6a 02                	push   $0x2
  801bec:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bf2:	e8 af f1 ff ff       	call   800da6 <sys_env_set_status>
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 23                	js     801c21 <spawn+0x4f3>
	return child;
  801bfe:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c04:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c0a:	eb 36                	jmp    801c42 <spawn+0x514>
		panic("sys_env_set_trapframe: %e", r);
  801c0c:	50                   	push   %eax
  801c0d:	68 2e 2b 80 00       	push   $0x802b2e
  801c12:	68 82 00 00 00       	push   $0x82
  801c17:	68 05 2b 80 00       	push   $0x802b05
  801c1c:	e8 7f e5 ff ff       	call   8001a0 <_panic>
		panic("sys_env_set_status: %e", r);
  801c21:	50                   	push   %eax
  801c22:	68 48 2b 80 00       	push   $0x802b48
  801c27:	68 84 00 00 00       	push   $0x84
  801c2c:	68 05 2b 80 00       	push   $0x802b05
  801c31:	e8 6a e5 ff ff       	call   8001a0 <_panic>
		return r;
  801c36:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c3c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801c42:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	89 c7                	mov    %eax,%edi
  801c52:	e9 13 fe ff ff       	jmp    801a6a <spawn+0x33c>
  801c57:	89 c7                	mov    %eax,%edi
  801c59:	e9 0c fe ff ff       	jmp    801a6a <spawn+0x33c>
  801c5e:	89 c7                	mov    %eax,%edi
  801c60:	e9 05 fe ff ff       	jmp    801a6a <spawn+0x33c>
		return -E_NO_MEM;
  801c65:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  801c6a:	c1 e8 1f             	shr    $0x1f,%eax
  801c6d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c73:	eb cd                	jmp    801c42 <spawn+0x514>
	sys_page_unmap(0, UTEMP);
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	68 00 00 40 00       	push   $0x400000
  801c7d:	6a 00                	push   $0x0
  801c7f:	e8 dc f0 ff ff       	call   800d60 <sys_page_unmap>
  801c84:	83 c4 10             	add    $0x10,%esp
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  801c87:	c7 85 94 fd ff ff 01 	movl   $0x1,-0x26c(%ebp)
  801c8e:	00 00 00 
  801c91:	eb af                	jmp    801c42 <spawn+0x514>

00801c93 <spawnl>:
{
  801c93:	f3 0f 1e fb          	endbr32 
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	57                   	push   %edi
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801ca0:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ca8:	8d 4a 04             	lea    0x4(%edx),%ecx
  801cab:	83 3a 00             	cmpl   $0x0,(%edx)
  801cae:	74 07                	je     801cb7 <spawnl+0x24>
		argc++;
  801cb0:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801cb3:	89 ca                	mov    %ecx,%edx
  801cb5:	eb f1                	jmp    801ca8 <spawnl+0x15>
	const char *argv[argc+2];
  801cb7:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801cbe:	89 d1                	mov    %edx,%ecx
  801cc0:	83 e1 f0             	and    $0xfffffff0,%ecx
  801cc3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801cc9:	89 e6                	mov    %esp,%esi
  801ccb:	29 d6                	sub    %edx,%esi
  801ccd:	89 f2                	mov    %esi,%edx
  801ccf:	39 d4                	cmp    %edx,%esp
  801cd1:	74 10                	je     801ce3 <spawnl+0x50>
  801cd3:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801cd9:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801ce0:	00 
  801ce1:	eb ec                	jmp    801ccf <spawnl+0x3c>
  801ce3:	89 ca                	mov    %ecx,%edx
  801ce5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801ceb:	29 d4                	sub    %edx,%esp
  801ced:	85 d2                	test   %edx,%edx
  801cef:	74 05                	je     801cf6 <spawnl+0x63>
  801cf1:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801cf6:	8d 74 24 03          	lea    0x3(%esp),%esi
  801cfa:	89 f2                	mov    %esi,%edx
  801cfc:	c1 ea 02             	shr    $0x2,%edx
  801cff:	83 e6 fc             	and    $0xfffffffc,%esi
  801d02:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801d04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d07:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d0e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d15:	00 
	va_start(vl, arg0);
  801d16:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d19:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	eb 0b                	jmp    801d2d <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801d22:	83 c0 01             	add    $0x1,%eax
  801d25:	8b 39                	mov    (%ecx),%edi
  801d27:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d2a:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d2d:	39 d0                	cmp    %edx,%eax
  801d2f:	75 f1                	jne    801d22 <spawnl+0x8f>
	return spawn(prog, argv);
  801d31:	83 ec 08             	sub    $0x8,%esp
  801d34:	56                   	push   %esi
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 f1 f9 ff ff       	call   80172e <spawn>
}
  801d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    

00801d45 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d45:	f3 0f 1e fb          	endbr32 
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	56                   	push   %esi
  801d4d:	53                   	push   %ebx
  801d4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	ff 75 08             	pushl  0x8(%ebp)
  801d57:	e8 9c f1 ff ff       	call   800ef8 <fd2data>
  801d5c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d5e:	83 c4 08             	add    $0x8,%esp
  801d61:	68 86 2b 80 00       	push   $0x802b86
  801d66:	53                   	push   %ebx
  801d67:	e8 25 eb ff ff       	call   800891 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d6c:	8b 46 04             	mov    0x4(%esi),%eax
  801d6f:	2b 06                	sub    (%esi),%eax
  801d71:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d77:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d7e:	00 00 00 
	stat->st_dev = &devpipe;
  801d81:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801d88:	30 80 00 
	return 0;
}
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    

00801d97 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d97:	f3 0f 1e fb          	endbr32 
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	53                   	push   %ebx
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801da5:	53                   	push   %ebx
  801da6:	6a 00                	push   $0x0
  801da8:	e8 b3 ef ff ff       	call   800d60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dad:	89 1c 24             	mov    %ebx,(%esp)
  801db0:	e8 43 f1 ff ff       	call   800ef8 <fd2data>
  801db5:	83 c4 08             	add    $0x8,%esp
  801db8:	50                   	push   %eax
  801db9:	6a 00                	push   $0x0
  801dbb:	e8 a0 ef ff ff       	call   800d60 <sys_page_unmap>
}
  801dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <_pipeisclosed>:
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	57                   	push   %edi
  801dc9:	56                   	push   %esi
  801dca:	53                   	push   %ebx
  801dcb:	83 ec 1c             	sub    $0x1c,%esp
  801dce:	89 c7                	mov    %eax,%edi
  801dd0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dd2:	a1 04 40 80 00       	mov    0x804004,%eax
  801dd7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	57                   	push   %edi
  801dde:	e8 61 05 00 00       	call   802344 <pageref>
  801de3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801de6:	89 34 24             	mov    %esi,(%esp)
  801de9:	e8 56 05 00 00       	call   802344 <pageref>
		nn = thisenv->env_runs;
  801dee:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801df4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	39 cb                	cmp    %ecx,%ebx
  801dfc:	74 1b                	je     801e19 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dfe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e01:	75 cf                	jne    801dd2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e03:	8b 42 58             	mov    0x58(%edx),%eax
  801e06:	6a 01                	push   $0x1
  801e08:	50                   	push   %eax
  801e09:	53                   	push   %ebx
  801e0a:	68 8d 2b 80 00       	push   $0x802b8d
  801e0f:	e8 73 e4 ff ff       	call   800287 <cprintf>
  801e14:	83 c4 10             	add    $0x10,%esp
  801e17:	eb b9                	jmp    801dd2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e19:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e1c:	0f 94 c0             	sete   %al
  801e1f:	0f b6 c0             	movzbl %al,%eax
}
  801e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5f                   	pop    %edi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <devpipe_write>:
{
  801e2a:	f3 0f 1e fb          	endbr32 
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 28             	sub    $0x28,%esp
  801e37:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e3a:	56                   	push   %esi
  801e3b:	e8 b8 f0 ff ff       	call   800ef8 <fd2data>
  801e40:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e4d:	74 4f                	je     801e9e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e4f:	8b 43 04             	mov    0x4(%ebx),%eax
  801e52:	8b 0b                	mov    (%ebx),%ecx
  801e54:	8d 51 20             	lea    0x20(%ecx),%edx
  801e57:	39 d0                	cmp    %edx,%eax
  801e59:	72 14                	jb     801e6f <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801e5b:	89 da                	mov    %ebx,%edx
  801e5d:	89 f0                	mov    %esi,%eax
  801e5f:	e8 61 ff ff ff       	call   801dc5 <_pipeisclosed>
  801e64:	85 c0                	test   %eax,%eax
  801e66:	75 3b                	jne    801ea3 <devpipe_write+0x79>
			sys_yield();
  801e68:	e8 43 ee ff ff       	call   800cb0 <sys_yield>
  801e6d:	eb e0                	jmp    801e4f <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e72:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e76:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e79:	89 c2                	mov    %eax,%edx
  801e7b:	c1 fa 1f             	sar    $0x1f,%edx
  801e7e:	89 d1                	mov    %edx,%ecx
  801e80:	c1 e9 1b             	shr    $0x1b,%ecx
  801e83:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e86:	83 e2 1f             	and    $0x1f,%edx
  801e89:	29 ca                	sub    %ecx,%edx
  801e8b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e8f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e93:	83 c0 01             	add    $0x1,%eax
  801e96:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e99:	83 c7 01             	add    $0x1,%edi
  801e9c:	eb ac                	jmp    801e4a <devpipe_write+0x20>
	return i;
  801e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea1:	eb 05                	jmp    801ea8 <devpipe_write+0x7e>
				return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5e                   	pop    %esi
  801ead:	5f                   	pop    %edi
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <devpipe_read>:
{
  801eb0:	f3 0f 1e fb          	endbr32 
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	57                   	push   %edi
  801eb8:	56                   	push   %esi
  801eb9:	53                   	push   %ebx
  801eba:	83 ec 18             	sub    $0x18,%esp
  801ebd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ec0:	57                   	push   %edi
  801ec1:	e8 32 f0 ff ff       	call   800ef8 <fd2data>
  801ec6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	be 00 00 00 00       	mov    $0x0,%esi
  801ed0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ed3:	75 14                	jne    801ee9 <devpipe_read+0x39>
	return i;
  801ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed8:	eb 02                	jmp    801edc <devpipe_read+0x2c>
				return i;
  801eda:	89 f0                	mov    %esi,%eax
}
  801edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    
			sys_yield();
  801ee4:	e8 c7 ed ff ff       	call   800cb0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ee9:	8b 03                	mov    (%ebx),%eax
  801eeb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eee:	75 18                	jne    801f08 <devpipe_read+0x58>
			if (i > 0)
  801ef0:	85 f6                	test   %esi,%esi
  801ef2:	75 e6                	jne    801eda <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801ef4:	89 da                	mov    %ebx,%edx
  801ef6:	89 f8                	mov    %edi,%eax
  801ef8:	e8 c8 fe ff ff       	call   801dc5 <_pipeisclosed>
  801efd:	85 c0                	test   %eax,%eax
  801eff:	74 e3                	je     801ee4 <devpipe_read+0x34>
				return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
  801f06:	eb d4                	jmp    801edc <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f08:	99                   	cltd   
  801f09:	c1 ea 1b             	shr    $0x1b,%edx
  801f0c:	01 d0                	add    %edx,%eax
  801f0e:	83 e0 1f             	and    $0x1f,%eax
  801f11:	29 d0                	sub    %edx,%eax
  801f13:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f1b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f1e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f21:	83 c6 01             	add    $0x1,%esi
  801f24:	eb aa                	jmp    801ed0 <devpipe_read+0x20>

00801f26 <pipe>:
{
  801f26:	f3 0f 1e fb          	endbr32 
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
  801f2f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f35:	50                   	push   %eax
  801f36:	e8 d8 ef ff ff       	call   800f13 <fd_alloc>
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	0f 88 23 01 00 00    	js     80206b <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	68 07 04 00 00       	push   $0x407
  801f50:	ff 75 f4             	pushl  -0xc(%ebp)
  801f53:	6a 00                	push   $0x0
  801f55:	e8 79 ed ff ff       	call   800cd3 <sys_page_alloc>
  801f5a:	89 c3                	mov    %eax,%ebx
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	0f 88 04 01 00 00    	js     80206b <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	e8 a0 ef ff ff       	call   800f13 <fd_alloc>
  801f73:	89 c3                	mov    %eax,%ebx
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	0f 88 db 00 00 00    	js     80205b <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	68 07 04 00 00       	push   $0x407
  801f88:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8b:	6a 00                	push   $0x0
  801f8d:	e8 41 ed ff ff       	call   800cd3 <sys_page_alloc>
  801f92:	89 c3                	mov    %eax,%ebx
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	85 c0                	test   %eax,%eax
  801f99:	0f 88 bc 00 00 00    	js     80205b <pipe+0x135>
	va = fd2data(fd0);
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa5:	e8 4e ef ff ff       	call   800ef8 <fd2data>
  801faa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fac:	83 c4 0c             	add    $0xc,%esp
  801faf:	68 07 04 00 00       	push   $0x407
  801fb4:	50                   	push   %eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	e8 17 ed ff ff       	call   800cd3 <sys_page_alloc>
  801fbc:	89 c3                	mov    %eax,%ebx
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	0f 88 82 00 00 00    	js     80204b <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcf:	e8 24 ef ff ff       	call   800ef8 <fd2data>
  801fd4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fdb:	50                   	push   %eax
  801fdc:	6a 00                	push   $0x0
  801fde:	56                   	push   %esi
  801fdf:	6a 00                	push   $0x0
  801fe1:	e8 34 ed ff ff       	call   800d1a <sys_page_map>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	83 c4 20             	add    $0x20,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 4e                	js     80203d <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801fef:	a1 20 30 80 00       	mov    0x803020,%eax
  801ff4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802003:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802006:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	ff 75 f4             	pushl  -0xc(%ebp)
  802018:	e8 c7 ee ff ff       	call   800ee4 <fd2num>
  80201d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802020:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802022:	83 c4 04             	add    $0x4,%esp
  802025:	ff 75 f0             	pushl  -0x10(%ebp)
  802028:	e8 b7 ee ff ff       	call   800ee4 <fd2num>
  80202d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802030:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80203b:	eb 2e                	jmp    80206b <pipe+0x145>
	sys_page_unmap(0, va);
  80203d:	83 ec 08             	sub    $0x8,%esp
  802040:	56                   	push   %esi
  802041:	6a 00                	push   $0x0
  802043:	e8 18 ed ff ff       	call   800d60 <sys_page_unmap>
  802048:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80204b:	83 ec 08             	sub    $0x8,%esp
  80204e:	ff 75 f0             	pushl  -0x10(%ebp)
  802051:	6a 00                	push   $0x0
  802053:	e8 08 ed ff ff       	call   800d60 <sys_page_unmap>
  802058:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80205b:	83 ec 08             	sub    $0x8,%esp
  80205e:	ff 75 f4             	pushl  -0xc(%ebp)
  802061:	6a 00                	push   $0x0
  802063:	e8 f8 ec ff ff       	call   800d60 <sys_page_unmap>
  802068:	83 c4 10             	add    $0x10,%esp
}
  80206b:	89 d8                	mov    %ebx,%eax
  80206d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5d                   	pop    %ebp
  802073:	c3                   	ret    

00802074 <pipeisclosed>:
{
  802074:	f3 0f 1e fb          	endbr32 
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80207e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802081:	50                   	push   %eax
  802082:	ff 75 08             	pushl  0x8(%ebp)
  802085:	e8 df ee ff ff       	call   800f69 <fd_lookup>
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 18                	js     8020a9 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	ff 75 f4             	pushl  -0xc(%ebp)
  802097:	e8 5c ee ff ff       	call   800ef8 <fd2data>
  80209c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	e8 1f fd ff ff       	call   801dc5 <_pipeisclosed>
  8020a6:	83 c4 10             	add    $0x10,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020ab:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	c3                   	ret    

008020b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020b5:	f3 0f 1e fb          	endbr32 
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020bf:	68 a5 2b 80 00       	push   $0x802ba5
  8020c4:	ff 75 0c             	pushl  0xc(%ebp)
  8020c7:	e8 c5 e7 ff ff       	call   800891 <strcpy>
	return 0;
}
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <devcons_write>:
{
  8020d3:	f3 0f 1e fb          	endbr32 
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	57                   	push   %edi
  8020db:	56                   	push   %esi
  8020dc:	53                   	push   %ebx
  8020dd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020e3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020e8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f1:	73 31                	jae    802124 <devcons_write+0x51>
		m = n - tot;
  8020f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020f6:	29 f3                	sub    %esi,%ebx
  8020f8:	83 fb 7f             	cmp    $0x7f,%ebx
  8020fb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802100:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	53                   	push   %ebx
  802107:	89 f0                	mov    %esi,%eax
  802109:	03 45 0c             	add    0xc(%ebp),%eax
  80210c:	50                   	push   %eax
  80210d:	57                   	push   %edi
  80210e:	e8 34 e9 ff ff       	call   800a47 <memmove>
		sys_cputs(buf, m);
  802113:	83 c4 08             	add    $0x8,%esp
  802116:	53                   	push   %ebx
  802117:	57                   	push   %edi
  802118:	e8 e6 ea ff ff       	call   800c03 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80211d:	01 de                	add    %ebx,%esi
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	eb ca                	jmp    8020ee <devcons_write+0x1b>
}
  802124:	89 f0                	mov    %esi,%eax
  802126:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802129:	5b                   	pop    %ebx
  80212a:	5e                   	pop    %esi
  80212b:	5f                   	pop    %edi
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <devcons_read>:
{
  80212e:	f3 0f 1e fb          	endbr32 
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 08             	sub    $0x8,%esp
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80213d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802141:	74 21                	je     802164 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802143:	e8 dd ea ff ff       	call   800c25 <sys_cgetc>
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 07                	jne    802153 <devcons_read+0x25>
		sys_yield();
  80214c:	e8 5f eb ff ff       	call   800cb0 <sys_yield>
  802151:	eb f0                	jmp    802143 <devcons_read+0x15>
	if (c < 0)
  802153:	78 0f                	js     802164 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802155:	83 f8 04             	cmp    $0x4,%eax
  802158:	74 0c                	je     802166 <devcons_read+0x38>
	*(char*)vbuf = c;
  80215a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215d:	88 02                	mov    %al,(%edx)
	return 1;
  80215f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    
		return 0;
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
  80216b:	eb f7                	jmp    802164 <devcons_read+0x36>

0080216d <cputchar>:
{
  80216d:	f3 0f 1e fb          	endbr32 
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80217d:	6a 01                	push   $0x1
  80217f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802182:	50                   	push   %eax
  802183:	e8 7b ea ff ff       	call   800c03 <sys_cputs>
}
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <getchar>:
{
  80218d:	f3 0f 1e fb          	endbr32 
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802197:	6a 01                	push   $0x1
  802199:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80219c:	50                   	push   %eax
  80219d:	6a 00                	push   $0x0
  80219f:	e8 48 f0 ff ff       	call   8011ec <read>
	if (r < 0)
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 06                	js     8021b1 <getchar+0x24>
	if (r < 1)
  8021ab:	74 06                	je     8021b3 <getchar+0x26>
	return c;
  8021ad:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    
		return -E_EOF;
  8021b3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021b8:	eb f7                	jmp    8021b1 <getchar+0x24>

008021ba <iscons>:
{
  8021ba:	f3 0f 1e fb          	endbr32 
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c7:	50                   	push   %eax
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	e8 99 ed ff ff       	call   800f69 <fd_lookup>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 11                	js     8021e8 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021e0:	39 10                	cmp    %edx,(%eax)
  8021e2:	0f 94 c0             	sete   %al
  8021e5:	0f b6 c0             	movzbl %al,%eax
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <opencons>:
{
  8021ea:	f3 0f 1e fb          	endbr32 
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f7:	50                   	push   %eax
  8021f8:	e8 16 ed ff ff       	call   800f13 <fd_alloc>
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	85 c0                	test   %eax,%eax
  802202:	78 3a                	js     80223e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	68 07 04 00 00       	push   $0x407
  80220c:	ff 75 f4             	pushl  -0xc(%ebp)
  80220f:	6a 00                	push   $0x0
  802211:	e8 bd ea ff ff       	call   800cd3 <sys_page_alloc>
  802216:	83 c4 10             	add    $0x10,%esp
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 21                	js     80223e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802226:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802232:	83 ec 0c             	sub    $0xc,%esp
  802235:	50                   	push   %eax
  802236:	e8 a9 ec ff ff       	call   800ee4 <fd2num>
  80223b:	83 c4 10             	add    $0x10,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802240:	f3 0f 1e fb          	endbr32 
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	56                   	push   %esi
  802248:	53                   	push   %ebx
  802249:	8b 75 08             	mov    0x8(%ebp),%esi
  80224c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802252:	85 c0                	test   %eax,%eax
  802254:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802259:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	50                   	push   %eax
  802260:	e8 3a ec ff ff       	call   800e9f <sys_ipc_recv>
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	85 c0                	test   %eax,%eax
  80226a:	78 2b                	js     802297 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  80226c:	85 f6                	test   %esi,%esi
  80226e:	74 0a                	je     80227a <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  802270:	a1 04 40 80 00       	mov    0x804004,%eax
  802275:	8b 40 74             	mov    0x74(%eax),%eax
  802278:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  80227a:	85 db                	test   %ebx,%ebx
  80227c:	74 0a                	je     802288 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  80227e:	a1 04 40 80 00       	mov    0x804004,%eax
  802283:	8b 40 78             	mov    0x78(%eax),%eax
  802286:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802288:	a1 04 40 80 00       	mov    0x804004,%eax
  80228d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802290:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    
		if(from_env_store)
  802297:	85 f6                	test   %esi,%esi
  802299:	74 06                	je     8022a1 <ipc_recv+0x61>
			*from_env_store=0;
  80229b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022a1:	85 db                	test   %ebx,%ebx
  8022a3:	74 eb                	je     802290 <ipc_recv+0x50>
			*perm_store=0;
  8022a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ab:	eb e3                	jmp    802290 <ipc_recv+0x50>

008022ad <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022ad:	f3 0f 1e fb          	endbr32 
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	57                   	push   %edi
  8022b5:	56                   	push   %esi
  8022b6:	53                   	push   %ebx
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8022c3:	85 db                	test   %ebx,%ebx
  8022c5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022ca:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8022cd:	ff 75 14             	pushl  0x14(%ebp)
  8022d0:	53                   	push   %ebx
  8022d1:	56                   	push   %esi
  8022d2:	57                   	push   %edi
  8022d3:	e8 a0 eb ff ff       	call   800e78 <sys_ipc_try_send>
		if(!res)
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 20                	je     8022ff <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  8022df:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022e2:	75 07                	jne    8022eb <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  8022e4:	e8 c7 e9 ff ff       	call   800cb0 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8022e9:	eb e2                	jmp    8022cd <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	68 b1 2b 80 00       	push   $0x802bb1
  8022f3:	6a 3f                	push   $0x3f
  8022f5:	68 c9 2b 80 00       	push   $0x802bc9
  8022fa:	e8 a1 de ff ff       	call   8001a0 <_panic>
	}
}
  8022ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802302:	5b                   	pop    %ebx
  802303:	5e                   	pop    %esi
  802304:	5f                   	pop    %edi
  802305:	5d                   	pop    %ebp
  802306:	c3                   	ret    

00802307 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802307:	f3 0f 1e fb          	endbr32 
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802316:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802319:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80231f:	8b 52 50             	mov    0x50(%edx),%edx
  802322:	39 ca                	cmp    %ecx,%edx
  802324:	74 11                	je     802337 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802326:	83 c0 01             	add    $0x1,%eax
  802329:	3d 00 04 00 00       	cmp    $0x400,%eax
  80232e:	75 e6                	jne    802316 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
  802335:	eb 0b                	jmp    802342 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802337:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80233a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80233f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802344:	f3 0f 1e fb          	endbr32 
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80234e:	89 c2                	mov    %eax,%edx
  802350:	c1 ea 16             	shr    $0x16,%edx
  802353:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80235a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80235f:	f6 c1 01             	test   $0x1,%cl
  802362:	74 1c                	je     802380 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802364:	c1 e8 0c             	shr    $0xc,%eax
  802367:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80236e:	a8 01                	test   $0x1,%al
  802370:	74 0e                	je     802380 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802372:	c1 e8 0c             	shr    $0xc,%eax
  802375:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80237c:	ef 
  80237d:	0f b7 d2             	movzwl %dx,%edx
}
  802380:	89 d0                	mov    %edx,%eax
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    
  802384:	66 90                	xchg   %ax,%ax
  802386:	66 90                	xchg   %ax,%ax
  802388:	66 90                	xchg   %ax,%ax
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <__udivdi3>:
  802390:	f3 0f 1e fb          	endbr32 
  802394:	55                   	push   %ebp
  802395:	57                   	push   %edi
  802396:	56                   	push   %esi
  802397:	53                   	push   %ebx
  802398:	83 ec 1c             	sub    $0x1c,%esp
  80239b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80239f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023ab:	85 d2                	test   %edx,%edx
  8023ad:	75 19                	jne    8023c8 <__udivdi3+0x38>
  8023af:	39 f3                	cmp    %esi,%ebx
  8023b1:	76 4d                	jbe    802400 <__udivdi3+0x70>
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	89 e8                	mov    %ebp,%eax
  8023b7:	89 f2                	mov    %esi,%edx
  8023b9:	f7 f3                	div    %ebx
  8023bb:	89 fa                	mov    %edi,%edx
  8023bd:	83 c4 1c             	add    $0x1c,%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	39 f2                	cmp    %esi,%edx
  8023ca:	76 14                	jbe    8023e0 <__udivdi3+0x50>
  8023cc:	31 ff                	xor    %edi,%edi
  8023ce:	31 c0                	xor    %eax,%eax
  8023d0:	89 fa                	mov    %edi,%edx
  8023d2:	83 c4 1c             	add    $0x1c,%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
  8023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023e0:	0f bd fa             	bsr    %edx,%edi
  8023e3:	83 f7 1f             	xor    $0x1f,%edi
  8023e6:	75 48                	jne    802430 <__udivdi3+0xa0>
  8023e8:	39 f2                	cmp    %esi,%edx
  8023ea:	72 06                	jb     8023f2 <__udivdi3+0x62>
  8023ec:	31 c0                	xor    %eax,%eax
  8023ee:	39 eb                	cmp    %ebp,%ebx
  8023f0:	77 de                	ja     8023d0 <__udivdi3+0x40>
  8023f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f7:	eb d7                	jmp    8023d0 <__udivdi3+0x40>
  8023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802400:	89 d9                	mov    %ebx,%ecx
  802402:	85 db                	test   %ebx,%ebx
  802404:	75 0b                	jne    802411 <__udivdi3+0x81>
  802406:	b8 01 00 00 00       	mov    $0x1,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f3                	div    %ebx
  80240f:	89 c1                	mov    %eax,%ecx
  802411:	31 d2                	xor    %edx,%edx
  802413:	89 f0                	mov    %esi,%eax
  802415:	f7 f1                	div    %ecx
  802417:	89 c6                	mov    %eax,%esi
  802419:	89 e8                	mov    %ebp,%eax
  80241b:	89 f7                	mov    %esi,%edi
  80241d:	f7 f1                	div    %ecx
  80241f:	89 fa                	mov    %edi,%edx
  802421:	83 c4 1c             	add    $0x1c,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5f                   	pop    %edi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
  802429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802430:	89 f9                	mov    %edi,%ecx
  802432:	b8 20 00 00 00       	mov    $0x20,%eax
  802437:	29 f8                	sub    %edi,%eax
  802439:	d3 e2                	shl    %cl,%edx
  80243b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80243f:	89 c1                	mov    %eax,%ecx
  802441:	89 da                	mov    %ebx,%edx
  802443:	d3 ea                	shr    %cl,%edx
  802445:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802449:	09 d1                	or     %edx,%ecx
  80244b:	89 f2                	mov    %esi,%edx
  80244d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802451:	89 f9                	mov    %edi,%ecx
  802453:	d3 e3                	shl    %cl,%ebx
  802455:	89 c1                	mov    %eax,%ecx
  802457:	d3 ea                	shr    %cl,%edx
  802459:	89 f9                	mov    %edi,%ecx
  80245b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80245f:	89 eb                	mov    %ebp,%ebx
  802461:	d3 e6                	shl    %cl,%esi
  802463:	89 c1                	mov    %eax,%ecx
  802465:	d3 eb                	shr    %cl,%ebx
  802467:	09 de                	or     %ebx,%esi
  802469:	89 f0                	mov    %esi,%eax
  80246b:	f7 74 24 08          	divl   0x8(%esp)
  80246f:	89 d6                	mov    %edx,%esi
  802471:	89 c3                	mov    %eax,%ebx
  802473:	f7 64 24 0c          	mull   0xc(%esp)
  802477:	39 d6                	cmp    %edx,%esi
  802479:	72 15                	jb     802490 <__udivdi3+0x100>
  80247b:	89 f9                	mov    %edi,%ecx
  80247d:	d3 e5                	shl    %cl,%ebp
  80247f:	39 c5                	cmp    %eax,%ebp
  802481:	73 04                	jae    802487 <__udivdi3+0xf7>
  802483:	39 d6                	cmp    %edx,%esi
  802485:	74 09                	je     802490 <__udivdi3+0x100>
  802487:	89 d8                	mov    %ebx,%eax
  802489:	31 ff                	xor    %edi,%edi
  80248b:	e9 40 ff ff ff       	jmp    8023d0 <__udivdi3+0x40>
  802490:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802493:	31 ff                	xor    %edi,%edi
  802495:	e9 36 ff ff ff       	jmp    8023d0 <__udivdi3+0x40>
  80249a:	66 90                	xchg   %ax,%ax
  80249c:	66 90                	xchg   %ax,%ax
  80249e:	66 90                	xchg   %ax,%ax

008024a0 <__umoddi3>:
  8024a0:	f3 0f 1e fb          	endbr32 
  8024a4:	55                   	push   %ebp
  8024a5:	57                   	push   %edi
  8024a6:	56                   	push   %esi
  8024a7:	53                   	push   %ebx
  8024a8:	83 ec 1c             	sub    $0x1c,%esp
  8024ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	75 19                	jne    8024d8 <__umoddi3+0x38>
  8024bf:	39 df                	cmp    %ebx,%edi
  8024c1:	76 5d                	jbe    802520 <__umoddi3+0x80>
  8024c3:	89 f0                	mov    %esi,%eax
  8024c5:	89 da                	mov    %ebx,%edx
  8024c7:	f7 f7                	div    %edi
  8024c9:	89 d0                	mov    %edx,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	83 c4 1c             	add    $0x1c,%esp
  8024d0:	5b                   	pop    %ebx
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    
  8024d5:	8d 76 00             	lea    0x0(%esi),%esi
  8024d8:	89 f2                	mov    %esi,%edx
  8024da:	39 d8                	cmp    %ebx,%eax
  8024dc:	76 12                	jbe    8024f0 <__umoddi3+0x50>
  8024de:	89 f0                	mov    %esi,%eax
  8024e0:	89 da                	mov    %ebx,%edx
  8024e2:	83 c4 1c             	add    $0x1c,%esp
  8024e5:	5b                   	pop    %ebx
  8024e6:	5e                   	pop    %esi
  8024e7:	5f                   	pop    %edi
  8024e8:	5d                   	pop    %ebp
  8024e9:	c3                   	ret    
  8024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f0:	0f bd e8             	bsr    %eax,%ebp
  8024f3:	83 f5 1f             	xor    $0x1f,%ebp
  8024f6:	75 50                	jne    802548 <__umoddi3+0xa8>
  8024f8:	39 d8                	cmp    %ebx,%eax
  8024fa:	0f 82 e0 00 00 00    	jb     8025e0 <__umoddi3+0x140>
  802500:	89 d9                	mov    %ebx,%ecx
  802502:	39 f7                	cmp    %esi,%edi
  802504:	0f 86 d6 00 00 00    	jbe    8025e0 <__umoddi3+0x140>
  80250a:	89 d0                	mov    %edx,%eax
  80250c:	89 ca                	mov    %ecx,%edx
  80250e:	83 c4 1c             	add    $0x1c,%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5f                   	pop    %edi
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    
  802516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	89 fd                	mov    %edi,%ebp
  802522:	85 ff                	test   %edi,%edi
  802524:	75 0b                	jne    802531 <__umoddi3+0x91>
  802526:	b8 01 00 00 00       	mov    $0x1,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	f7 f7                	div    %edi
  80252f:	89 c5                	mov    %eax,%ebp
  802531:	89 d8                	mov    %ebx,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	f7 f5                	div    %ebp
  802537:	89 f0                	mov    %esi,%eax
  802539:	f7 f5                	div    %ebp
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	31 d2                	xor    %edx,%edx
  80253f:	eb 8c                	jmp    8024cd <__umoddi3+0x2d>
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	ba 20 00 00 00       	mov    $0x20,%edx
  80254f:	29 ea                	sub    %ebp,%edx
  802551:	d3 e0                	shl    %cl,%eax
  802553:	89 44 24 08          	mov    %eax,0x8(%esp)
  802557:	89 d1                	mov    %edx,%ecx
  802559:	89 f8                	mov    %edi,%eax
  80255b:	d3 e8                	shr    %cl,%eax
  80255d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802561:	89 54 24 04          	mov    %edx,0x4(%esp)
  802565:	8b 54 24 04          	mov    0x4(%esp),%edx
  802569:	09 c1                	or     %eax,%ecx
  80256b:	89 d8                	mov    %ebx,%eax
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 e9                	mov    %ebp,%ecx
  802573:	d3 e7                	shl    %cl,%edi
  802575:	89 d1                	mov    %edx,%ecx
  802577:	d3 e8                	shr    %cl,%eax
  802579:	89 e9                	mov    %ebp,%ecx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	d3 e3                	shl    %cl,%ebx
  802581:	89 c7                	mov    %eax,%edi
  802583:	89 d1                	mov    %edx,%ecx
  802585:	89 f0                	mov    %esi,%eax
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 fa                	mov    %edi,%edx
  80258d:	d3 e6                	shl    %cl,%esi
  80258f:	09 d8                	or     %ebx,%eax
  802591:	f7 74 24 08          	divl   0x8(%esp)
  802595:	89 d1                	mov    %edx,%ecx
  802597:	89 f3                	mov    %esi,%ebx
  802599:	f7 64 24 0c          	mull   0xc(%esp)
  80259d:	89 c6                	mov    %eax,%esi
  80259f:	89 d7                	mov    %edx,%edi
  8025a1:	39 d1                	cmp    %edx,%ecx
  8025a3:	72 06                	jb     8025ab <__umoddi3+0x10b>
  8025a5:	75 10                	jne    8025b7 <__umoddi3+0x117>
  8025a7:	39 c3                	cmp    %eax,%ebx
  8025a9:	73 0c                	jae    8025b7 <__umoddi3+0x117>
  8025ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025b3:	89 d7                	mov    %edx,%edi
  8025b5:	89 c6                	mov    %eax,%esi
  8025b7:	89 ca                	mov    %ecx,%edx
  8025b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025be:	29 f3                	sub    %esi,%ebx
  8025c0:	19 fa                	sbb    %edi,%edx
  8025c2:	89 d0                	mov    %edx,%eax
  8025c4:	d3 e0                	shl    %cl,%eax
  8025c6:	89 e9                	mov    %ebp,%ecx
  8025c8:	d3 eb                	shr    %cl,%ebx
  8025ca:	d3 ea                	shr    %cl,%edx
  8025cc:	09 d8                	or     %ebx,%eax
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	29 fe                	sub    %edi,%esi
  8025e2:	19 c3                	sbb    %eax,%ebx
  8025e4:	89 f2                	mov    %esi,%edx
  8025e6:	89 d9                	mov    %ebx,%ecx
  8025e8:	e9 1d ff ff ff       	jmp    80250a <__umoddi3+0x6a>
