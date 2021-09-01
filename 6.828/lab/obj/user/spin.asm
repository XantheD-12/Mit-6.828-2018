
obj/user/spin.debug：     文件格式 elf32-i386


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
  80002c:	e8 88 00 00 00       	call   8000b9 <libmain>
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
  80003a:	53                   	push   %ebx
  80003b:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003e:	68 20 23 80 00       	push   $0x802320
  800043:	e8 76 01 00 00       	call   8001be <cprintf>
	if ((env = fork()) == 0) {
  800048:	e8 b1 0e 00 00       	call   800efe <fork>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	85 c0                	test   %eax,%eax
  800052:	75 12                	jne    800066 <umain+0x33>
		cprintf("I am the child.  Spinning...\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 98 23 80 00       	push   $0x802398
  80005c:	e8 5d 01 00 00       	call   8001be <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
  800064:	eb fe                	jmp    800064 <umain+0x31>
  800066:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	68 48 23 80 00       	push   $0x802348
  800070:	e8 49 01 00 00       	call   8001be <cprintf>
	sys_yield();
  800075:	e8 6d 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80007a:	e8 68 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80007f:	e8 63 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800084:	e8 5e 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800089:	e8 59 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80008e:	e8 54 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800093:	e8 4f 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800098:	e8 4a 0b 00 00       	call   800be7 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  80009d:	c7 04 24 70 23 80 00 	movl   $0x802370,(%esp)
  8000a4:	e8 15 01 00 00       	call   8001be <cprintf>
	sys_env_destroy(env);
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 ce 0a 00 00       	call   800b7f <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    

008000b9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
  8000c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c8:	e8 f7 0a 00 00       	call   800bc4 <sys_getenvid>
  8000cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000da:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000df:	85 db                	test   %ebx,%ebx
  8000e1:	7e 07                	jle    8000ea <libmain+0x31>
		binaryname = argv[0];
  8000e3:	8b 06                	mov    (%esi),%eax
  8000e5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ea:	83 ec 08             	sub    $0x8,%esp
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	e8 3f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f4:	e8 0a 00 00 00       	call   800103 <exit>
}
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ff:	5b                   	pop    %ebx
  800100:	5e                   	pop    %esi
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    

00800103 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800103:	f3 0f 1e fb          	endbr32 
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010d:	e8 18 12 00 00       	call   80132a <close_all>
	sys_env_destroy(0);
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	6a 00                	push   $0x0
  800117:	e8 63 0a 00 00       	call   800b7f <sys_env_destroy>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	f3 0f 1e fb          	endbr32 
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	53                   	push   %ebx
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012f:	8b 13                	mov    (%ebx),%edx
  800131:	8d 42 01             	lea    0x1(%edx),%eax
  800134:	89 03                	mov    %eax,(%ebx)
  800136:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800139:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800142:	74 09                	je     80014d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800144:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80014d:	83 ec 08             	sub    $0x8,%esp
  800150:	68 ff 00 00 00       	push   $0xff
  800155:	8d 43 08             	lea    0x8(%ebx),%eax
  800158:	50                   	push   %eax
  800159:	e8 dc 09 00 00       	call   800b3a <sys_cputs>
		b->idx = 0;
  80015e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	eb db                	jmp    800144 <putch+0x23>

00800169 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800176:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80017d:	00 00 00 
	b.cnt = 0;
  800180:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800187:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018a:	ff 75 0c             	pushl  0xc(%ebp)
  80018d:	ff 75 08             	pushl  0x8(%ebp)
  800190:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800196:	50                   	push   %eax
  800197:	68 21 01 80 00       	push   $0x800121
  80019c:	e8 20 01 00 00       	call   8002c1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a1:	83 c4 08             	add    $0x8,%esp
  8001a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 84 09 00 00       	call   800b3a <sys_cputs>

	return b.cnt;
}
  8001b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001be:	f3 0f 1e fb          	endbr32 
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	e8 95 ff ff ff       	call   800169 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    

008001d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 1c             	sub    $0x1c,%esp
  8001df:	89 c7                	mov    %eax,%edi
  8001e1:	89 d6                	mov    %edx,%esi
  8001e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	89 d1                	mov    %edx,%ecx
  8001eb:	89 c2                	mov    %eax,%edx
  8001ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800203:	39 c2                	cmp    %eax,%edx
  800205:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800208:	72 3e                	jb     800248 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	ff 75 18             	pushl  0x18(%ebp)
  800210:	83 eb 01             	sub    $0x1,%ebx
  800213:	53                   	push   %ebx
  800214:	50                   	push   %eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	ff 75 dc             	pushl  -0x24(%ebp)
  800221:	ff 75 d8             	pushl  -0x28(%ebp)
  800224:	e8 87 1e 00 00       	call   8020b0 <__udivdi3>
  800229:	83 c4 18             	add    $0x18,%esp
  80022c:	52                   	push   %edx
  80022d:	50                   	push   %eax
  80022e:	89 f2                	mov    %esi,%edx
  800230:	89 f8                	mov    %edi,%eax
  800232:	e8 9f ff ff ff       	call   8001d6 <printnum>
  800237:	83 c4 20             	add    $0x20,%esp
  80023a:	eb 13                	jmp    80024f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	56                   	push   %esi
  800240:	ff 75 18             	pushl  0x18(%ebp)
  800243:	ff d7                	call   *%edi
  800245:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800248:	83 eb 01             	sub    $0x1,%ebx
  80024b:	85 db                	test   %ebx,%ebx
  80024d:	7f ed                	jg     80023c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	56                   	push   %esi
  800253:	83 ec 04             	sub    $0x4,%esp
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	ff 75 d8             	pushl  -0x28(%ebp)
  800262:	e8 59 1f 00 00       	call   8021c0 <__umoddi3>
  800267:	83 c4 14             	add    $0x14,%esp
  80026a:	0f be 80 c0 23 80 00 	movsbl 0x8023c0(%eax),%eax
  800271:	50                   	push   %eax
  800272:	ff d7                	call   *%edi
}
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    

0080027f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027f:	f3 0f 1e fb          	endbr32 
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800289:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028d:	8b 10                	mov    (%eax),%edx
  80028f:	3b 50 04             	cmp    0x4(%eax),%edx
  800292:	73 0a                	jae    80029e <sprintputch+0x1f>
		*b->buf++ = ch;
  800294:	8d 4a 01             	lea    0x1(%edx),%ecx
  800297:	89 08                	mov    %ecx,(%eax)
  800299:	8b 45 08             	mov    0x8(%ebp),%eax
  80029c:	88 02                	mov    %al,(%edx)
}
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <printfmt>:
{
  8002a0:	f3 0f 1e fb          	endbr32 
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002aa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ad:	50                   	push   %eax
  8002ae:	ff 75 10             	pushl  0x10(%ebp)
  8002b1:	ff 75 0c             	pushl  0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	e8 05 00 00 00       	call   8002c1 <vprintfmt>
}
  8002bc:	83 c4 10             	add    $0x10,%esp
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    

008002c1 <vprintfmt>:
{
  8002c1:	f3 0f 1e fb          	endbr32 
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 3c             	sub    $0x3c,%esp
  8002ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d7:	e9 8e 03 00 00       	jmp    80066a <vprintfmt+0x3a9>
		padc = ' ';
  8002dc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 df 03 00 00    	ja     8006ed <vprintfmt+0x42c>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	3e ff 24 85 00 25 80 	notrack jmp *0x802500(,%eax,4)
  800318:	00 
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800320:	eb d8                	jmp    8002fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800325:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800329:	eb cf                	jmp    8002fa <vprintfmt+0x39>
  80032b:	0f b6 d2             	movzbl %dl,%edx
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800331:	b8 00 00 00 00       	mov    $0x0,%eax
  800336:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800339:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800340:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800343:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800346:	83 f9 09             	cmp    $0x9,%ecx
  800349:	77 55                	ja     8003a0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80034b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034e:	eb e9                	jmp    800339 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 40 04             	lea    0x4(%eax),%eax
  80035e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800364:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800368:	79 90                	jns    8002fa <vprintfmt+0x39>
				width = precision, precision = -1;
  80036a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80036d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800370:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800377:	eb 81                	jmp    8002fa <vprintfmt+0x39>
  800379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	0f 49 d0             	cmovns %eax,%edx
  800386:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038c:	e9 69 ff ff ff       	jmp    8002fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800394:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80039b:	e9 5a ff ff ff       	jmp    8002fa <vprintfmt+0x39>
  8003a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	eb bc                	jmp    800364 <vprintfmt+0xa3>
			lflag++;
  8003a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ae:	e9 47 ff ff ff       	jmp    8002fa <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8d 78 04             	lea    0x4(%eax),%edi
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	53                   	push   %ebx
  8003bd:	ff 30                	pushl  (%eax)
  8003bf:	ff d6                	call   *%esi
			break;
  8003c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c7:	e9 9b 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8d 78 04             	lea    0x4(%eax),%edi
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	99                   	cltd   
  8003d5:	31 d0                	xor    %edx,%eax
  8003d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d9:	83 f8 0f             	cmp    $0xf,%eax
  8003dc:	7f 23                	jg     800401 <vprintfmt+0x140>
  8003de:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 18                	je     800401 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003e9:	52                   	push   %edx
  8003ea:	68 11 29 80 00       	push   $0x802911
  8003ef:	53                   	push   %ebx
  8003f0:	56                   	push   %esi
  8003f1:	e8 aa fe ff ff       	call   8002a0 <printfmt>
  8003f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fc:	e9 66 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800401:	50                   	push   %eax
  800402:	68 d8 23 80 00       	push   $0x8023d8
  800407:	53                   	push   %ebx
  800408:	56                   	push   %esi
  800409:	e8 92 fe ff ff       	call   8002a0 <printfmt>
  80040e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800414:	e9 4e 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	83 c0 04             	add    $0x4,%eax
  80041f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800427:	85 d2                	test   %edx,%edx
  800429:	b8 d1 23 80 00       	mov    $0x8023d1,%eax
  80042e:	0f 45 c2             	cmovne %edx,%eax
  800431:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800434:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800438:	7e 06                	jle    800440 <vprintfmt+0x17f>
  80043a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80043e:	75 0d                	jne    80044d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800440:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800443:	89 c7                	mov    %eax,%edi
  800445:	03 45 e0             	add    -0x20(%ebp),%eax
  800448:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044b:	eb 55                	jmp    8004a2 <vprintfmt+0x1e1>
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 d8             	pushl  -0x28(%ebp)
  800453:	ff 75 cc             	pushl  -0x34(%ebp)
  800456:	e8 46 03 00 00       	call   8007a1 <strnlen>
  80045b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045e:	29 c2                	sub    %eax,%edx
  800460:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800468:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046f:	85 ff                	test   %edi,%edi
  800471:	7e 11                	jle    800484 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	53                   	push   %ebx
  800477:	ff 75 e0             	pushl  -0x20(%ebp)
  80047a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80047c:	83 ef 01             	sub    $0x1,%edi
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb eb                	jmp    80046f <vprintfmt+0x1ae>
  800484:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	0f 49 c2             	cmovns %edx,%eax
  800491:	29 c2                	sub    %eax,%edx
  800493:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800496:	eb a8                	jmp    800440 <vprintfmt+0x17f>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	52                   	push   %edx
  80049d:	ff d6                	call   *%esi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a7:	83 c7 01             	add    $0x1,%edi
  8004aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ae:	0f be d0             	movsbl %al,%edx
  8004b1:	85 d2                	test   %edx,%edx
  8004b3:	74 4b                	je     800500 <vprintfmt+0x23f>
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	78 06                	js     8004c1 <vprintfmt+0x200>
  8004bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004bf:	78 1e                	js     8004df <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c5:	74 d1                	je     800498 <vprintfmt+0x1d7>
  8004c7:	0f be c0             	movsbl %al,%eax
  8004ca:	83 e8 20             	sub    $0x20,%eax
  8004cd:	83 f8 5e             	cmp    $0x5e,%eax
  8004d0:	76 c6                	jbe    800498 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	6a 3f                	push   $0x3f
  8004d8:	ff d6                	call   *%esi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	eb c3                	jmp    8004a2 <vprintfmt+0x1e1>
  8004df:	89 cf                	mov    %ecx,%edi
  8004e1:	eb 0e                	jmp    8004f1 <vprintfmt+0x230>
				putch(' ', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 20                	push   $0x20
  8004e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004eb:	83 ef 01             	sub    $0x1,%edi
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	85 ff                	test   %edi,%edi
  8004f3:	7f ee                	jg     8004e3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fb:	e9 67 01 00 00       	jmp    800667 <vprintfmt+0x3a6>
  800500:	89 cf                	mov    %ecx,%edi
  800502:	eb ed                	jmp    8004f1 <vprintfmt+0x230>
	if (lflag >= 2)
  800504:	83 f9 01             	cmp    $0x1,%ecx
  800507:	7f 1b                	jg     800524 <vprintfmt+0x263>
	else if (lflag)
  800509:	85 c9                	test   %ecx,%ecx
  80050b:	74 63                	je     800570 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	99                   	cltd   
  800516:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	eb 17                	jmp    80053b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 50 04             	mov    0x4(%eax),%edx
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8d 40 08             	lea    0x8(%eax),%eax
  800538:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800541:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800546:	85 c9                	test   %ecx,%ecx
  800548:	0f 89 ff 00 00 00    	jns    80064d <vprintfmt+0x38c>
				putch('-', putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	53                   	push   %ebx
  800552:	6a 2d                	push   $0x2d
  800554:	ff d6                	call   *%esi
				num = -(long long) num;
  800556:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800559:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055c:	f7 da                	neg    %edx
  80055e:	83 d1 00             	adc    $0x0,%ecx
  800561:	f7 d9                	neg    %ecx
  800563:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 dd 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb b4                	jmp    80053b <vprintfmt+0x27a>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7f 1e                	jg     8005aa <vprintfmt+0x2e9>
	else if (lflag)
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	74 32                	je     8005c2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8b 10                	mov    (%eax),%edx
  800595:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059a:	8d 40 04             	lea    0x4(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005a5:	e9 a3 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 10                	mov    (%eax),%edx
  8005af:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b2:	8d 40 08             	lea    0x8(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005bd:	e9 8b 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 10                	mov    (%eax),%edx
  8005c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cc:	8d 40 04             	lea    0x4(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005d7:	eb 74                	jmp    80064d <vprintfmt+0x38c>
	if (lflag >= 2)
  8005d9:	83 f9 01             	cmp    $0x1,%ecx
  8005dc:	7f 1b                	jg     8005f9 <vprintfmt+0x338>
	else if (lflag)
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	74 2c                	je     80060e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 10                	mov    (%eax),%edx
  8005e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005f2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005f7:	eb 54                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 10                	mov    (%eax),%edx
  8005fe:	8b 48 04             	mov    0x4(%eax),%ecx
  800601:	8d 40 08             	lea    0x8(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800607:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80060c:	eb 3f                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 10                	mov    (%eax),%edx
  800613:	b9 00 00 00 00       	mov    $0x0,%ecx
  800618:	8d 40 04             	lea    0x4(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80061e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800623:	eb 28                	jmp    80064d <vprintfmt+0x38c>
			putch('0', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 30                	push   $0x30
  80062b:	ff d6                	call   *%esi
			putch('x', putdat);
  80062d:	83 c4 08             	add    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	6a 78                	push   $0x78
  800633:	ff d6                	call   *%esi
			num = (unsigned long long)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80063f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800648:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80064d:	83 ec 0c             	sub    $0xc,%esp
  800650:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800654:	57                   	push   %edi
  800655:	ff 75 e0             	pushl  -0x20(%ebp)
  800658:	50                   	push   %eax
  800659:	51                   	push   %ecx
  80065a:	52                   	push   %edx
  80065b:	89 da                	mov    %ebx,%edx
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	e8 72 fb ff ff       	call   8001d6 <printnum>
			break;
  800664:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066a:	83 c7 01             	add    $0x1,%edi
  80066d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800671:	83 f8 25             	cmp    $0x25,%eax
  800674:	0f 84 62 fc ff ff    	je     8002dc <vprintfmt+0x1b>
			if (ch == '\0')
  80067a:	85 c0                	test   %eax,%eax
  80067c:	0f 84 8b 00 00 00    	je     80070d <vprintfmt+0x44c>
			putch(ch, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	50                   	push   %eax
  800687:	ff d6                	call   *%esi
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	eb dc                	jmp    80066a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80068e:	83 f9 01             	cmp    $0x1,%ecx
  800691:	7f 1b                	jg     8006ae <vprintfmt+0x3ed>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	74 2c                	je     8006c3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 10                	mov    (%eax),%edx
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006ac:	eb 9f                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 10                	mov    (%eax),%edx
  8006b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b6:	8d 40 08             	lea    0x8(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006c1:	eb 8a                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006d8:	e9 70 ff ff ff       	jmp    80064d <vprintfmt+0x38c>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 25                	push   $0x25
  8006e3:	ff d6                	call   *%esi
			break;
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	e9 7a ff ff ff       	jmp    800667 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 25                	push   $0x25
  8006f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 f8                	mov    %edi,%eax
  8006fa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006fe:	74 05                	je     800705 <vprintfmt+0x444>
  800700:	83 e8 01             	sub    $0x1,%eax
  800703:	eb f5                	jmp    8006fa <vprintfmt+0x439>
  800705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800708:	e9 5a ff ff ff       	jmp    800667 <vprintfmt+0x3a6>
}
  80070d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800710:	5b                   	pop    %ebx
  800711:	5e                   	pop    %esi
  800712:	5f                   	pop    %edi
  800713:	5d                   	pop    %ebp
  800714:	c3                   	ret    

00800715 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800715:	f3 0f 1e fb          	endbr32 
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 18             	sub    $0x18,%esp
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800728:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80072c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80072f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800736:	85 c0                	test   %eax,%eax
  800738:	74 26                	je     800760 <vsnprintf+0x4b>
  80073a:	85 d2                	test   %edx,%edx
  80073c:	7e 22                	jle    800760 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80073e:	ff 75 14             	pushl  0x14(%ebp)
  800741:	ff 75 10             	pushl  0x10(%ebp)
  800744:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800747:	50                   	push   %eax
  800748:	68 7f 02 80 00       	push   $0x80027f
  80074d:	e8 6f fb ff ff       	call   8002c1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800755:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    
		return -E_INVAL;
  800760:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800765:	eb f7                	jmp    80075e <vsnprintf+0x49>

00800767 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800767:	f3 0f 1e fb          	endbr32 
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800774:	50                   	push   %eax
  800775:	ff 75 10             	pushl  0x10(%ebp)
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 08             	pushl  0x8(%ebp)
  80077e:	e8 92 ff ff ff       	call   800715 <vsnprintf>
	va_end(ap);

	return rc;
}
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800785:	f3 0f 1e fb          	endbr32 
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80078f:	b8 00 00 00 00       	mov    $0x0,%eax
  800794:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800798:	74 05                	je     80079f <strlen+0x1a>
		n++;
  80079a:	83 c0 01             	add    $0x1,%eax
  80079d:	eb f5                	jmp    800794 <strlen+0xf>
	return n;
}
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a1:	f3 0f 1e fb          	endbr32 
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b3:	39 d0                	cmp    %edx,%eax
  8007b5:	74 0d                	je     8007c4 <strnlen+0x23>
  8007b7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007bb:	74 05                	je     8007c2 <strnlen+0x21>
		n++;
  8007bd:	83 c0 01             	add    $0x1,%eax
  8007c0:	eb f1                	jmp    8007b3 <strnlen+0x12>
  8007c2:	89 c2                	mov    %eax,%edx
	return n;
}
  8007c4:	89 d0                	mov    %edx,%eax
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c8:	f3 0f 1e fb          	endbr32 
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007df:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007e2:	83 c0 01             	add    $0x1,%eax
  8007e5:	84 d2                	test   %dl,%dl
  8007e7:	75 f2                	jne    8007db <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007e9:	89 c8                	mov    %ecx,%eax
  8007eb:	5b                   	pop    %ebx
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ee:	f3 0f 1e fb          	endbr32 
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 10             	sub    $0x10,%esp
  8007f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fc:	53                   	push   %ebx
  8007fd:	e8 83 ff ff ff       	call   800785 <strlen>
  800802:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	01 d8                	add    %ebx,%eax
  80080a:	50                   	push   %eax
  80080b:	e8 b8 ff ff ff       	call   8007c8 <strcpy>
	return dst;
}
  800810:	89 d8                	mov    %ebx,%eax
  800812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
  800826:	89 f3                	mov    %esi,%ebx
  800828:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082b:	89 f0                	mov    %esi,%eax
  80082d:	39 d8                	cmp    %ebx,%eax
  80082f:	74 11                	je     800842 <strncpy+0x2b>
		*dst++ = *src;
  800831:	83 c0 01             	add    $0x1,%eax
  800834:	0f b6 0a             	movzbl (%edx),%ecx
  800837:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083a:	80 f9 01             	cmp    $0x1,%cl
  80083d:	83 da ff             	sbb    $0xffffffff,%edx
  800840:	eb eb                	jmp    80082d <strncpy+0x16>
	}
	return ret;
}
  800842:	89 f0                	mov    %esi,%eax
  800844:	5b                   	pop    %ebx
  800845:	5e                   	pop    %esi
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800848:	f3 0f 1e fb          	endbr32 
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	56                   	push   %esi
  800850:	53                   	push   %ebx
  800851:	8b 75 08             	mov    0x8(%ebp),%esi
  800854:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800857:	8b 55 10             	mov    0x10(%ebp),%edx
  80085a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085c:	85 d2                	test   %edx,%edx
  80085e:	74 21                	je     800881 <strlcpy+0x39>
  800860:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800864:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800866:	39 c2                	cmp    %eax,%edx
  800868:	74 14                	je     80087e <strlcpy+0x36>
  80086a:	0f b6 19             	movzbl (%ecx),%ebx
  80086d:	84 db                	test   %bl,%bl
  80086f:	74 0b                	je     80087c <strlcpy+0x34>
			*dst++ = *src++;
  800871:	83 c1 01             	add    $0x1,%ecx
  800874:	83 c2 01             	add    $0x1,%edx
  800877:	88 5a ff             	mov    %bl,-0x1(%edx)
  80087a:	eb ea                	jmp    800866 <strlcpy+0x1e>
  80087c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80087e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800881:	29 f0                	sub    %esi,%eax
}
  800883:	5b                   	pop    %ebx
  800884:	5e                   	pop    %esi
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800887:	f3 0f 1e fb          	endbr32 
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800894:	0f b6 01             	movzbl (%ecx),%eax
  800897:	84 c0                	test   %al,%al
  800899:	74 0c                	je     8008a7 <strcmp+0x20>
  80089b:	3a 02                	cmp    (%edx),%al
  80089d:	75 08                	jne    8008a7 <strcmp+0x20>
		p++, q++;
  80089f:	83 c1 01             	add    $0x1,%ecx
  8008a2:	83 c2 01             	add    $0x1,%edx
  8008a5:	eb ed                	jmp    800894 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a7:	0f b6 c0             	movzbl %al,%eax
  8008aa:	0f b6 12             	movzbl (%edx),%edx
  8008ad:	29 d0                	sub    %edx,%eax
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b1:	f3 0f 1e fb          	endbr32 
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	53                   	push   %ebx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bf:	89 c3                	mov    %eax,%ebx
  8008c1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c4:	eb 06                	jmp    8008cc <strncmp+0x1b>
		n--, p++, q++;
  8008c6:	83 c0 01             	add    $0x1,%eax
  8008c9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008cc:	39 d8                	cmp    %ebx,%eax
  8008ce:	74 16                	je     8008e6 <strncmp+0x35>
  8008d0:	0f b6 08             	movzbl (%eax),%ecx
  8008d3:	84 c9                	test   %cl,%cl
  8008d5:	74 04                	je     8008db <strncmp+0x2a>
  8008d7:	3a 0a                	cmp    (%edx),%cl
  8008d9:	74 eb                	je     8008c6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008db:	0f b6 00             	movzbl (%eax),%eax
  8008de:	0f b6 12             	movzbl (%edx),%edx
  8008e1:	29 d0                	sub    %edx,%eax
}
  8008e3:	5b                   	pop    %ebx
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    
		return 0;
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb f6                	jmp    8008e3 <strncmp+0x32>

008008ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ed:	f3 0f 1e fb          	endbr32 
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fb:	0f b6 10             	movzbl (%eax),%edx
  8008fe:	84 d2                	test   %dl,%dl
  800900:	74 09                	je     80090b <strchr+0x1e>
		if (*s == c)
  800902:	38 ca                	cmp    %cl,%dl
  800904:	74 0a                	je     800910 <strchr+0x23>
	for (; *s; s++)
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	eb f0                	jmp    8008fb <strchr+0xe>
			return (char *) s;
	return 0;
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800912:	f3 0f 1e fb          	endbr32 
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800920:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800923:	38 ca                	cmp    %cl,%dl
  800925:	74 09                	je     800930 <strfind+0x1e>
  800927:	84 d2                	test   %dl,%dl
  800929:	74 05                	je     800930 <strfind+0x1e>
	for (; *s; s++)
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	eb f0                	jmp    800920 <strfind+0xe>
			break;
	return (char *) s;
}
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800932:	f3 0f 1e fb          	endbr32 
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	57                   	push   %edi
  80093a:	56                   	push   %esi
  80093b:	53                   	push   %ebx
  80093c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800942:	85 c9                	test   %ecx,%ecx
  800944:	74 31                	je     800977 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800946:	89 f8                	mov    %edi,%eax
  800948:	09 c8                	or     %ecx,%eax
  80094a:	a8 03                	test   $0x3,%al
  80094c:	75 23                	jne    800971 <memset+0x3f>
		c &= 0xFF;
  80094e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800952:	89 d3                	mov    %edx,%ebx
  800954:	c1 e3 08             	shl    $0x8,%ebx
  800957:	89 d0                	mov    %edx,%eax
  800959:	c1 e0 18             	shl    $0x18,%eax
  80095c:	89 d6                	mov    %edx,%esi
  80095e:	c1 e6 10             	shl    $0x10,%esi
  800961:	09 f0                	or     %esi,%eax
  800963:	09 c2                	or     %eax,%edx
  800965:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800967:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096a:	89 d0                	mov    %edx,%eax
  80096c:	fc                   	cld    
  80096d:	f3 ab                	rep stos %eax,%es:(%edi)
  80096f:	eb 06                	jmp    800977 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
  800974:	fc                   	cld    
  800975:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800977:	89 f8                	mov    %edi,%eax
  800979:	5b                   	pop    %ebx
  80097a:	5e                   	pop    %esi
  80097b:	5f                   	pop    %edi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097e:	f3 0f 1e fb          	endbr32 
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	57                   	push   %edi
  800986:	56                   	push   %esi
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800990:	39 c6                	cmp    %eax,%esi
  800992:	73 32                	jae    8009c6 <memmove+0x48>
  800994:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800997:	39 c2                	cmp    %eax,%edx
  800999:	76 2b                	jbe    8009c6 <memmove+0x48>
		s += n;
		d += n;
  80099b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	89 fe                	mov    %edi,%esi
  8009a0:	09 ce                	or     %ecx,%esi
  8009a2:	09 d6                	or     %edx,%esi
  8009a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009aa:	75 0e                	jne    8009ba <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009ac:	83 ef 04             	sub    $0x4,%edi
  8009af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b8:	eb 09                	jmp    8009c3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ba:	83 ef 01             	sub    $0x1,%edi
  8009bd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c3:	fc                   	cld    
  8009c4:	eb 1a                	jmp    8009e0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	09 ca                	or     %ecx,%edx
  8009ca:	09 f2                	or     %esi,%edx
  8009cc:	f6 c2 03             	test   $0x3,%dl
  8009cf:	75 0a                	jne    8009db <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d4:	89 c7                	mov    %eax,%edi
  8009d6:	fc                   	cld    
  8009d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d9:	eb 05                	jmp    8009e0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009db:	89 c7                	mov    %eax,%edi
  8009dd:	fc                   	cld    
  8009de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e0:	5e                   	pop    %esi
  8009e1:	5f                   	pop    %edi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e4:	f3 0f 1e fb          	endbr32 
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009ee:	ff 75 10             	pushl  0x10(%ebp)
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 82 ff ff ff       	call   80097e <memmove>
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0d:	89 c6                	mov    %eax,%esi
  800a0f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a12:	39 f0                	cmp    %esi,%eax
  800a14:	74 1c                	je     800a32 <memcmp+0x34>
		if (*s1 != *s2)
  800a16:	0f b6 08             	movzbl (%eax),%ecx
  800a19:	0f b6 1a             	movzbl (%edx),%ebx
  800a1c:	38 d9                	cmp    %bl,%cl
  800a1e:	75 08                	jne    800a28 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	eb ea                	jmp    800a12 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a28:	0f b6 c1             	movzbl %cl,%eax
  800a2b:	0f b6 db             	movzbl %bl,%ebx
  800a2e:	29 d8                	sub    %ebx,%eax
  800a30:	eb 05                	jmp    800a37 <memcmp+0x39>
	}

	return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a3b:	f3 0f 1e fb          	endbr32 
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a4d:	39 d0                	cmp    %edx,%eax
  800a4f:	73 09                	jae    800a5a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a51:	38 08                	cmp    %cl,(%eax)
  800a53:	74 05                	je     800a5a <memfind+0x1f>
	for (; s < ends; s++)
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	eb f3                	jmp    800a4d <memfind+0x12>
			break;
	return (void *) s;
}
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6c:	eb 03                	jmp    800a71 <strtol+0x15>
		s++;
  800a6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a71:	0f b6 01             	movzbl (%ecx),%eax
  800a74:	3c 20                	cmp    $0x20,%al
  800a76:	74 f6                	je     800a6e <strtol+0x12>
  800a78:	3c 09                	cmp    $0x9,%al
  800a7a:	74 f2                	je     800a6e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a7c:	3c 2b                	cmp    $0x2b,%al
  800a7e:	74 2a                	je     800aaa <strtol+0x4e>
	int neg = 0;
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a85:	3c 2d                	cmp    $0x2d,%al
  800a87:	74 2b                	je     800ab4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8f:	75 0f                	jne    800aa0 <strtol+0x44>
  800a91:	80 39 30             	cmpb   $0x30,(%ecx)
  800a94:	74 28                	je     800abe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a96:	85 db                	test   %ebx,%ebx
  800a98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a9d:	0f 44 d8             	cmove  %eax,%ebx
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa8:	eb 46                	jmp    800af0 <strtol+0x94>
		s++;
  800aaa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aad:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab2:	eb d5                	jmp    800a89 <strtol+0x2d>
		s++, neg = 1;
  800ab4:	83 c1 01             	add    $0x1,%ecx
  800ab7:	bf 01 00 00 00       	mov    $0x1,%edi
  800abc:	eb cb                	jmp    800a89 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac2:	74 0e                	je     800ad2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	75 d8                	jne    800aa0 <strtol+0x44>
		s++, base = 8;
  800ac8:	83 c1 01             	add    $0x1,%ecx
  800acb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad0:	eb ce                	jmp    800aa0 <strtol+0x44>
		s += 2, base = 16;
  800ad2:	83 c1 02             	add    $0x2,%ecx
  800ad5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ada:	eb c4                	jmp    800aa0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800adc:	0f be d2             	movsbl %dl,%edx
  800adf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae5:	7d 3a                	jge    800b21 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af0:	0f b6 11             	movzbl (%ecx),%edx
  800af3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af6:	89 f3                	mov    %esi,%ebx
  800af8:	80 fb 09             	cmp    $0x9,%bl
  800afb:	76 df                	jbe    800adc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800afd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b00:	89 f3                	mov    %esi,%ebx
  800b02:	80 fb 19             	cmp    $0x19,%bl
  800b05:	77 08                	ja     800b0f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b07:	0f be d2             	movsbl %dl,%edx
  800b0a:	83 ea 57             	sub    $0x57,%edx
  800b0d:	eb d3                	jmp    800ae2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b0f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	80 fb 19             	cmp    $0x19,%bl
  800b17:	77 08                	ja     800b21 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b19:	0f be d2             	movsbl %dl,%edx
  800b1c:	83 ea 37             	sub    $0x37,%edx
  800b1f:	eb c1                	jmp    800ae2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b25:	74 05                	je     800b2c <strtol+0xd0>
		*endptr = (char *) s;
  800b27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2c:	89 c2                	mov    %eax,%edx
  800b2e:	f7 da                	neg    %edx
  800b30:	85 ff                	test   %edi,%edi
  800b32:	0f 45 c2             	cmovne %edx,%eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3a:	f3 0f 1e fb          	endbr32 
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5c:	f3 0f 1e fb          	endbr32 
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	57                   	push   %edi
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b70:	89 d1                	mov    %edx,%ecx
  800b72:	89 d3                	mov    %edx,%ebx
  800b74:	89 d7                	mov    %edx,%edi
  800b76:	89 d6                	mov    %edx,%esi
  800b78:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7f:	f3 0f 1e fb          	endbr32 
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b91:	8b 55 08             	mov    0x8(%ebp),%edx
  800b94:	b8 03 00 00 00       	mov    $0x3,%eax
  800b99:	89 cb                	mov    %ecx,%ebx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	89 ce                	mov    %ecx,%esi
  800b9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	7f 08                	jg     800bad <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bad:	83 ec 0c             	sub    $0xc,%esp
  800bb0:	50                   	push   %eax
  800bb1:	6a 03                	push   $0x3
  800bb3:	68 bf 26 80 00       	push   $0x8026bf
  800bb8:	6a 23                	push   $0x23
  800bba:	68 dc 26 80 00       	push   $0x8026dc
  800bbf:	e8 bc 12 00 00       	call   801e80 <_panic>

00800bc4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_yield>:

void
sys_yield(void)
{
  800be7:	f3 0f 1e fb          	endbr32 
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bfb:	89 d1                	mov    %edx,%ecx
  800bfd:	89 d3                	mov    %edx,%ebx
  800bff:	89 d7                	mov    %edx,%edi
  800c01:	89 d6                	mov    %edx,%esi
  800c03:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0a:	f3 0f 1e fb          	endbr32 
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c17:	be 00 00 00 00       	mov    $0x0,%esi
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	b8 04 00 00 00       	mov    $0x4,%eax
  800c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2a:	89 f7                	mov    %esi,%edi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 04                	push   $0x4
  800c40:	68 bf 26 80 00       	push   $0x8026bf
  800c45:	6a 23                	push   $0x23
  800c47:	68 dc 26 80 00       	push   $0x8026dc
  800c4c:	e8 2f 12 00 00       	call   801e80 <_panic>

00800c51 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	b8 05 00 00 00       	mov    $0x5,%eax
  800c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6f:	8b 75 18             	mov    0x18(%ebp),%esi
  800c72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 05                	push   $0x5
  800c86:	68 bf 26 80 00       	push   $0x8026bf
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 dc 26 80 00       	push   $0x8026dc
  800c92:	e8 e9 11 00 00       	call   801e80 <_panic>

00800c97 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 06                	push   $0x6
  800ccc:	68 bf 26 80 00       	push   $0x8026bf
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 dc 26 80 00       	push   $0x8026dc
  800cd8:	e8 a3 11 00 00       	call   801e80 <_panic>

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	89 de                	mov    %ebx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d10:	6a 08                	push   $0x8
  800d12:	68 bf 26 80 00       	push   $0x8026bf
  800d17:	6a 23                	push   $0x23
  800d19:	68 dc 26 80 00       	push   $0x8026dc
  800d1e:	e8 5d 11 00 00       	call   801e80 <_panic>

00800d23 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 09                	push   $0x9
  800d58:	68 bf 26 80 00       	push   $0x8026bf
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 dc 26 80 00       	push   $0x8026dc
  800d64:	e8 17 11 00 00       	call   801e80 <_panic>

00800d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 0a                	push   $0xa
  800d9e:	68 bf 26 80 00       	push   $0x8026bf
  800da3:	6a 23                	push   $0x23
  800da5:	68 dc 26 80 00       	push   $0x8026dc
  800daa:	e8 d1 10 00 00       	call   801e80 <_panic>

00800daf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800daf:	f3 0f 1e fb          	endbr32 
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc4:	be 00 00 00 00       	mov    $0x0,%esi
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd6:	f3 0f 1e fb          	endbr32 
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df0:	89 cb                	mov    %ecx,%ebx
  800df2:	89 cf                	mov    %ecx,%edi
  800df4:	89 ce                	mov    %ecx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 0d                	push   $0xd
  800e0a:	68 bf 26 80 00       	push   $0x8026bf
  800e0f:	6a 23                	push   $0x23
  800e11:	68 dc 26 80 00       	push   $0x8026dc
  800e16:	e8 65 10 00 00       	call   801e80 <_panic>

00800e1b <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e27:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800e29:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e2d:	74 7f                	je     800eae <pgfault+0x93>
  800e2f:	89 f0                	mov    %esi,%eax
  800e31:	c1 e8 0c             	shr    $0xc,%eax
  800e34:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e3b:	f6 c4 08             	test   $0x8,%ah
  800e3e:	74 6e                	je     800eae <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800e40:	e8 7f fd ff ff       	call   800bc4 <sys_getenvid>
  800e45:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800e47:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800e4d:	83 ec 04             	sub    $0x4,%esp
  800e50:	6a 07                	push   $0x7
  800e52:	68 00 f0 7f 00       	push   $0x7ff000
  800e57:	50                   	push   %eax
  800e58:	e8 ad fd ff ff       	call   800c0a <sys_page_alloc>
  800e5d:	83 c4 10             	add    $0x10,%esp
  800e60:	85 c0                	test   %eax,%eax
  800e62:	78 5e                	js     800ec2 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	68 00 10 00 00       	push   $0x1000
  800e6c:	56                   	push   %esi
  800e6d:	68 00 f0 7f 00       	push   $0x7ff000
  800e72:	e8 6d fb ff ff       	call   8009e4 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800e77:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	68 00 f0 7f 00       	push   $0x7ff000
  800e85:	53                   	push   %ebx
  800e86:	e8 c6 fd ff ff       	call   800c51 <sys_page_map>
  800e8b:	83 c4 20             	add    $0x20,%esp
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	78 44                	js     800ed6 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	68 00 f0 7f 00       	push   $0x7ff000
  800e9a:	53                   	push   %ebx
  800e9b:	e8 f7 fd ff ff       	call   800c97 <sys_page_unmap>
  800ea0:	83 c4 10             	add    $0x10,%esp
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	78 43                	js     800eea <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800ea7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800eae:	83 ec 04             	sub    $0x4,%esp
  800eb1:	68 ea 26 80 00       	push   $0x8026ea
  800eb6:	6a 1e                	push   $0x1e
  800eb8:	68 07 27 80 00       	push   $0x802707
  800ebd:	e8 be 0f 00 00       	call   801e80 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800ec2:	83 ec 04             	sub    $0x4,%esp
  800ec5:	68 98 27 80 00       	push   $0x802798
  800eca:	6a 2b                	push   $0x2b
  800ecc:	68 07 27 80 00       	push   $0x802707
  800ed1:	e8 aa 0f 00 00       	call   801e80 <_panic>
		panic("pgfault: sys_page_map Failed!");
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	68 12 27 80 00       	push   $0x802712
  800ede:	6a 2f                	push   $0x2f
  800ee0:	68 07 27 80 00       	push   $0x802707
  800ee5:	e8 96 0f 00 00       	call   801e80 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800eea:	83 ec 04             	sub    $0x4,%esp
  800eed:	68 b8 27 80 00       	push   $0x8027b8
  800ef2:	6a 32                	push   $0x32
  800ef4:	68 07 27 80 00       	push   $0x802707
  800ef9:	e8 82 0f 00 00       	call   801e80 <_panic>

00800efe <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800efe:	f3 0f 1e fb          	endbr32 
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f0b:	68 1b 0e 80 00       	push   $0x800e1b
  800f10:	e8 b5 0f 00 00       	call   801eca <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f15:	b8 07 00 00 00       	mov    $0x7,%eax
  800f1a:	cd 30                	int    $0x30
  800f1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  800f22:	83 c4 10             	add    $0x10,%esp
  800f25:	85 c0                	test   %eax,%eax
  800f27:	78 2b                	js     800f54 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800f29:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  800f2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f32:	0f 85 ba 00 00 00    	jne    800ff2 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  800f38:	e8 87 fc ff ff       	call   800bc4 <sys_getenvid>
  800f3d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f42:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f45:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f4a:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f4f:	e9 90 01 00 00       	jmp    8010e4 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	68 30 27 80 00       	push   $0x802730
  800f5c:	6a 76                	push   $0x76
  800f5e:	68 07 27 80 00       	push   $0x802707
  800f63:	e8 18 0f 00 00       	call   801e80 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  800f68:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  800f6f:	e8 50 fc ff ff       	call   800bc4 <sys_getenvid>
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800f7d:	56                   	push   %esi
  800f7e:	57                   	push   %edi
  800f7f:	ff 75 e0             	pushl  -0x20(%ebp)
  800f82:	57                   	push   %edi
  800f83:	50                   	push   %eax
  800f84:	e8 c8 fc ff ff       	call   800c51 <sys_page_map>
  800f89:	83 c4 20             	add    $0x20,%esp
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	79 50                	jns    800fe0 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  800f90:	83 ec 04             	sub    $0x4,%esp
  800f93:	68 49 27 80 00       	push   $0x802749
  800f98:	6a 4b                	push   $0x4b
  800f9a:	68 07 27 80 00       	push   $0x802707
  800f9f:	e8 dc 0e 00 00       	call   801e80 <_panic>
			panic("duppage:child sys_page_map Failed!");
  800fa4:	83 ec 04             	sub    $0x4,%esp
  800fa7:	68 d8 27 80 00       	push   $0x8027d8
  800fac:	6a 50                	push   $0x50
  800fae:	68 07 27 80 00       	push   $0x802707
  800fb3:	e8 c8 0e 00 00       	call   801e80 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  800fb8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	25 07 0e 00 00       	and    $0xe07,%eax
  800fc7:	50                   	push   %eax
  800fc8:	57                   	push   %edi
  800fc9:	ff 75 e0             	pushl  -0x20(%ebp)
  800fcc:	57                   	push   %edi
  800fcd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd0:	e8 7c fc ff ff       	call   800c51 <sys_page_map>
  800fd5:	83 c4 20             	add    $0x20,%esp
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	0f 88 b4 00 00 00    	js     801094 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800fe0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fe6:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fec:	0f 84 b6 00 00 00    	je     8010a8 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  800ff2:	89 d8                	mov    %ebx,%eax
  800ff4:	c1 e8 16             	shr    $0x16,%eax
  800ff7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ffe:	a8 01                	test   $0x1,%al
  801000:	74 de                	je     800fe0 <fork+0xe2>
  801002:	89 de                	mov    %ebx,%esi
  801004:	c1 ee 0c             	shr    $0xc,%esi
  801007:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80100e:	a8 01                	test   $0x1,%al
  801010:	74 ce                	je     800fe0 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801012:	e8 ad fb ff ff       	call   800bc4 <sys_getenvid>
  801017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  80101a:	89 f7                	mov    %esi,%edi
  80101c:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80101f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801026:	f6 c4 04             	test   $0x4,%ah
  801029:	0f 85 39 ff ff ff    	jne    800f68 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80102f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801036:	a9 02 08 00 00       	test   $0x802,%eax
  80103b:	0f 84 77 ff ff ff    	je     800fb8 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	68 05 08 00 00       	push   $0x805
  801049:	57                   	push   %edi
  80104a:	ff 75 e0             	pushl  -0x20(%ebp)
  80104d:	57                   	push   %edi
  80104e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801051:	e8 fb fb ff ff       	call   800c51 <sys_page_map>
  801056:	83 c4 20             	add    $0x20,%esp
  801059:	85 c0                	test   %eax,%eax
  80105b:	0f 88 43 ff ff ff    	js     800fa4 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  801061:	83 ec 0c             	sub    $0xc,%esp
  801064:	68 05 08 00 00       	push   $0x805
  801069:	57                   	push   %edi
  80106a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80106d:	50                   	push   %eax
  80106e:	57                   	push   %edi
  80106f:	50                   	push   %eax
  801070:	e8 dc fb ff ff       	call   800c51 <sys_page_map>
  801075:	83 c4 20             	add    $0x20,%esp
  801078:	85 c0                	test   %eax,%eax
  80107a:	0f 89 60 ff ff ff    	jns    800fe0 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  801080:	83 ec 04             	sub    $0x4,%esp
  801083:	68 fc 27 80 00       	push   $0x8027fc
  801088:	6a 52                	push   $0x52
  80108a:	68 07 27 80 00       	push   $0x802707
  80108f:	e8 ec 0d 00 00       	call   801e80 <_panic>
			panic("duppage: single sys_page_map Failed!");
  801094:	83 ec 04             	sub    $0x4,%esp
  801097:	68 20 28 80 00       	push   $0x802820
  80109c:	6a 56                	push   $0x56
  80109e:	68 07 27 80 00       	push   $0x802707
  8010a3:	e8 d8 0d 00 00       	call   801e80 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8010a8:	83 ec 04             	sub    $0x4,%esp
  8010ab:	6a 07                	push   $0x7
  8010ad:	68 00 f0 bf ee       	push   $0xeebff000
  8010b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8010b5:	e8 50 fb ff ff       	call   800c0a <sys_page_alloc>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 2e                	js     8010ef <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010c1:	83 ec 08             	sub    $0x8,%esp
  8010c4:	68 46 1f 80 00       	push   $0x801f46
  8010c9:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8010cc:	57                   	push   %edi
  8010cd:	e8 97 fc ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  8010d2:	83 c4 08             	add    $0x8,%esp
  8010d5:	6a 02                	push   $0x2
  8010d7:	57                   	push   %edi
  8010d8:	e8 00 fc ff ff       	call   800cdd <sys_env_set_status>
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	78 22                	js     801106 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  8010e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ea:	5b                   	pop    %ebx
  8010eb:	5e                   	pop    %esi
  8010ec:	5f                   	pop    %edi
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	68 66 27 80 00       	push   $0x802766
  8010f7:	68 83 00 00 00       	push   $0x83
  8010fc:	68 07 27 80 00       	push   $0x802707
  801101:	e8 7a 0d 00 00       	call   801e80 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801106:	83 ec 04             	sub    $0x4,%esp
  801109:	68 48 28 80 00       	push   $0x802848
  80110e:	68 89 00 00 00       	push   $0x89
  801113:	68 07 27 80 00       	push   $0x802707
  801118:	e8 63 0d 00 00       	call   801e80 <_panic>

0080111d <sfork>:

// Challenge!
int
sfork(void)
{
  80111d:	f3 0f 1e fb          	endbr32 
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801127:	68 82 27 80 00       	push   $0x802782
  80112c:	68 93 00 00 00       	push   $0x93
  801131:	68 07 27 80 00       	push   $0x802707
  801136:	e8 45 0d 00 00       	call   801e80 <_panic>

0080113b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80113b:	f3 0f 1e fb          	endbr32 
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	05 00 00 00 30       	add    $0x30000000,%eax
  80114a:	c1 e8 0c             	shr    $0xc,%eax
}
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80114f:	f3 0f 1e fb          	endbr32 
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80115e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801163:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80116a:	f3 0f 1e fb          	endbr32 
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801176:	89 c2                	mov    %eax,%edx
  801178:	c1 ea 16             	shr    $0x16,%edx
  80117b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801182:	f6 c2 01             	test   $0x1,%dl
  801185:	74 2d                	je     8011b4 <fd_alloc+0x4a>
  801187:	89 c2                	mov    %eax,%edx
  801189:	c1 ea 0c             	shr    $0xc,%edx
  80118c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801193:	f6 c2 01             	test   $0x1,%dl
  801196:	74 1c                	je     8011b4 <fd_alloc+0x4a>
  801198:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80119d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011a2:	75 d2                	jne    801176 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011ad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011b2:	eb 0a                	jmp    8011be <fd_alloc+0x54>
			*fd_store = fd;
  8011b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011c0:	f3 0f 1e fb          	endbr32 
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ca:	83 f8 1f             	cmp    $0x1f,%eax
  8011cd:	77 30                	ja     8011ff <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011cf:	c1 e0 0c             	shl    $0xc,%eax
  8011d2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011d7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011dd:	f6 c2 01             	test   $0x1,%dl
  8011e0:	74 24                	je     801206 <fd_lookup+0x46>
  8011e2:	89 c2                	mov    %eax,%edx
  8011e4:	c1 ea 0c             	shr    $0xc,%edx
  8011e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ee:	f6 c2 01             	test   $0x1,%dl
  8011f1:	74 1a                	je     80120d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f6:	89 02                	mov    %eax,(%edx)
	return 0;
  8011f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    
		return -E_INVAL;
  8011ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801204:	eb f7                	jmp    8011fd <fd_lookup+0x3d>
		return -E_INVAL;
  801206:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120b:	eb f0                	jmp    8011fd <fd_lookup+0x3d>
  80120d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801212:	eb e9                	jmp    8011fd <fd_lookup+0x3d>

00801214 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801214:	f3 0f 1e fb          	endbr32 
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 08             	sub    $0x8,%esp
  80121e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801221:	ba e8 28 80 00       	mov    $0x8028e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801226:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80122b:	39 08                	cmp    %ecx,(%eax)
  80122d:	74 33                	je     801262 <dev_lookup+0x4e>
  80122f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801232:	8b 02                	mov    (%edx),%eax
  801234:	85 c0                	test   %eax,%eax
  801236:	75 f3                	jne    80122b <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801238:	a1 04 40 80 00       	mov    0x804004,%eax
  80123d:	8b 40 48             	mov    0x48(%eax),%eax
  801240:	83 ec 04             	sub    $0x4,%esp
  801243:	51                   	push   %ecx
  801244:	50                   	push   %eax
  801245:	68 6c 28 80 00       	push   $0x80286c
  80124a:	e8 6f ef ff ff       	call   8001be <cprintf>
	*dev = 0;
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    
			*dev = devtab[i];
  801262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801265:	89 01                	mov    %eax,(%ecx)
			return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb f2                	jmp    801260 <dev_lookup+0x4c>

0080126e <fd_close>:
{
  80126e:	f3 0f 1e fb          	endbr32 
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	57                   	push   %edi
  801276:	56                   	push   %esi
  801277:	53                   	push   %ebx
  801278:	83 ec 24             	sub    $0x24,%esp
  80127b:	8b 75 08             	mov    0x8(%ebp),%esi
  80127e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801281:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801284:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801285:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80128b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80128e:	50                   	push   %eax
  80128f:	e8 2c ff ff ff       	call   8011c0 <fd_lookup>
  801294:	89 c3                	mov    %eax,%ebx
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	78 05                	js     8012a2 <fd_close+0x34>
	    || fd != fd2)
  80129d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012a0:	74 16                	je     8012b8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012a2:	89 f8                	mov    %edi,%eax
  8012a4:	84 c0                	test   %al,%al
  8012a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ab:	0f 44 d8             	cmove  %eax,%ebx
}
  8012ae:	89 d8                	mov    %ebx,%eax
  8012b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5f                   	pop    %edi
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012b8:	83 ec 08             	sub    $0x8,%esp
  8012bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012be:	50                   	push   %eax
  8012bf:	ff 36                	pushl  (%esi)
  8012c1:	e8 4e ff ff ff       	call   801214 <dev_lookup>
  8012c6:	89 c3                	mov    %eax,%ebx
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 1a                	js     8012e9 <fd_close+0x7b>
		if (dev->dev_close)
  8012cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	74 0b                	je     8012e9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8012de:	83 ec 0c             	sub    $0xc,%esp
  8012e1:	56                   	push   %esi
  8012e2:	ff d0                	call   *%eax
  8012e4:	89 c3                	mov    %eax,%ebx
  8012e6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	56                   	push   %esi
  8012ed:	6a 00                	push   $0x0
  8012ef:	e8 a3 f9 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	eb b5                	jmp    8012ae <fd_close+0x40>

008012f9 <close>:

int
close(int fdnum)
{
  8012f9:	f3 0f 1e fb          	endbr32 
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801303:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801306:	50                   	push   %eax
  801307:	ff 75 08             	pushl  0x8(%ebp)
  80130a:	e8 b1 fe ff ff       	call   8011c0 <fd_lookup>
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	79 02                	jns    801318 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    
		return fd_close(fd, 1);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	6a 01                	push   $0x1
  80131d:	ff 75 f4             	pushl  -0xc(%ebp)
  801320:	e8 49 ff ff ff       	call   80126e <fd_close>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	eb ec                	jmp    801316 <close+0x1d>

0080132a <close_all>:

void
close_all(void)
{
  80132a:	f3 0f 1e fb          	endbr32 
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	53                   	push   %ebx
  801332:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801335:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	53                   	push   %ebx
  80133e:	e8 b6 ff ff ff       	call   8012f9 <close>
	for (i = 0; i < MAXFD; i++)
  801343:	83 c3 01             	add    $0x1,%ebx
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	83 fb 20             	cmp    $0x20,%ebx
  80134c:	75 ec                	jne    80133a <close_all+0x10>
}
  80134e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801353:	f3 0f 1e fb          	endbr32 
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	57                   	push   %edi
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801360:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	ff 75 08             	pushl  0x8(%ebp)
  801367:	e8 54 fe ff ff       	call   8011c0 <fd_lookup>
  80136c:	89 c3                	mov    %eax,%ebx
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	0f 88 81 00 00 00    	js     8013fa <dup+0xa7>
		return r;
	close(newfdnum);
  801379:	83 ec 0c             	sub    $0xc,%esp
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 75 ff ff ff       	call   8012f9 <close>

	newfd = INDEX2FD(newfdnum);
  801384:	8b 75 0c             	mov    0xc(%ebp),%esi
  801387:	c1 e6 0c             	shl    $0xc,%esi
  80138a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801390:	83 c4 04             	add    $0x4,%esp
  801393:	ff 75 e4             	pushl  -0x1c(%ebp)
  801396:	e8 b4 fd ff ff       	call   80114f <fd2data>
  80139b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80139d:	89 34 24             	mov    %esi,(%esp)
  8013a0:	e8 aa fd ff ff       	call   80114f <fd2data>
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013aa:	89 d8                	mov    %ebx,%eax
  8013ac:	c1 e8 16             	shr    $0x16,%eax
  8013af:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b6:	a8 01                	test   $0x1,%al
  8013b8:	74 11                	je     8013cb <dup+0x78>
  8013ba:	89 d8                	mov    %ebx,%eax
  8013bc:	c1 e8 0c             	shr    $0xc,%eax
  8013bf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c6:	f6 c2 01             	test   $0x1,%dl
  8013c9:	75 39                	jne    801404 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ce:	89 d0                	mov    %edx,%eax
  8013d0:	c1 e8 0c             	shr    $0xc,%eax
  8013d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013da:	83 ec 0c             	sub    $0xc,%esp
  8013dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e2:	50                   	push   %eax
  8013e3:	56                   	push   %esi
  8013e4:	6a 00                	push   $0x0
  8013e6:	52                   	push   %edx
  8013e7:	6a 00                	push   $0x0
  8013e9:	e8 63 f8 ff ff       	call   800c51 <sys_page_map>
  8013ee:	89 c3                	mov    %eax,%ebx
  8013f0:	83 c4 20             	add    $0x20,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 31                	js     801428 <dup+0xd5>
		goto err;

	return newfdnum;
  8013f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ff:	5b                   	pop    %ebx
  801400:	5e                   	pop    %esi
  801401:	5f                   	pop    %edi
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801404:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	25 07 0e 00 00       	and    $0xe07,%eax
  801413:	50                   	push   %eax
  801414:	57                   	push   %edi
  801415:	6a 00                	push   $0x0
  801417:	53                   	push   %ebx
  801418:	6a 00                	push   $0x0
  80141a:	e8 32 f8 ff ff       	call   800c51 <sys_page_map>
  80141f:	89 c3                	mov    %eax,%ebx
  801421:	83 c4 20             	add    $0x20,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	79 a3                	jns    8013cb <dup+0x78>
	sys_page_unmap(0, newfd);
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	56                   	push   %esi
  80142c:	6a 00                	push   $0x0
  80142e:	e8 64 f8 ff ff       	call   800c97 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801433:	83 c4 08             	add    $0x8,%esp
  801436:	57                   	push   %edi
  801437:	6a 00                	push   $0x0
  801439:	e8 59 f8 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	eb b7                	jmp    8013fa <dup+0xa7>

00801443 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801443:	f3 0f 1e fb          	endbr32 
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	53                   	push   %ebx
  80144b:	83 ec 1c             	sub    $0x1c,%esp
  80144e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801451:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801454:	50                   	push   %eax
  801455:	53                   	push   %ebx
  801456:	e8 65 fd ff ff       	call   8011c0 <fd_lookup>
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 3f                	js     8014a1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146c:	ff 30                	pushl  (%eax)
  80146e:	e8 a1 fd ff ff       	call   801214 <dev_lookup>
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	78 27                	js     8014a1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80147a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147d:	8b 42 08             	mov    0x8(%edx),%eax
  801480:	83 e0 03             	and    $0x3,%eax
  801483:	83 f8 01             	cmp    $0x1,%eax
  801486:	74 1e                	je     8014a6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148b:	8b 40 08             	mov    0x8(%eax),%eax
  80148e:	85 c0                	test   %eax,%eax
  801490:	74 35                	je     8014c7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	ff 75 10             	pushl  0x10(%ebp)
  801498:	ff 75 0c             	pushl  0xc(%ebp)
  80149b:	52                   	push   %edx
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
}
  8014a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a6:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ab:	8b 40 48             	mov    0x48(%eax),%eax
  8014ae:	83 ec 04             	sub    $0x4,%esp
  8014b1:	53                   	push   %ebx
  8014b2:	50                   	push   %eax
  8014b3:	68 ad 28 80 00       	push   $0x8028ad
  8014b8:	e8 01 ed ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c5:	eb da                	jmp    8014a1 <read+0x5e>
		return -E_NOT_SUPP;
  8014c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014cc:	eb d3                	jmp    8014a1 <read+0x5e>

008014ce <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ce:	f3 0f 1e fb          	endbr32 
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	57                   	push   %edi
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014de:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e6:	eb 02                	jmp    8014ea <readn+0x1c>
  8014e8:	01 c3                	add    %eax,%ebx
  8014ea:	39 f3                	cmp    %esi,%ebx
  8014ec:	73 21                	jae    80150f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	89 f0                	mov    %esi,%eax
  8014f3:	29 d8                	sub    %ebx,%eax
  8014f5:	50                   	push   %eax
  8014f6:	89 d8                	mov    %ebx,%eax
  8014f8:	03 45 0c             	add    0xc(%ebp),%eax
  8014fb:	50                   	push   %eax
  8014fc:	57                   	push   %edi
  8014fd:	e8 41 ff ff ff       	call   801443 <read>
		if (m < 0)
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	78 04                	js     80150d <readn+0x3f>
			return m;
		if (m == 0)
  801509:	75 dd                	jne    8014e8 <readn+0x1a>
  80150b:	eb 02                	jmp    80150f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80150d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80150f:	89 d8                	mov    %ebx,%eax
  801511:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801514:	5b                   	pop    %ebx
  801515:	5e                   	pop    %esi
  801516:	5f                   	pop    %edi
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801519:	f3 0f 1e fb          	endbr32 
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	53                   	push   %ebx
  801521:	83 ec 1c             	sub    $0x1c,%esp
  801524:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801527:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	53                   	push   %ebx
  80152c:	e8 8f fc ff ff       	call   8011c0 <fd_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 3a                	js     801572 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	ff 30                	pushl  (%eax)
  801544:	e8 cb fc ff ff       	call   801214 <dev_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 22                	js     801572 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801553:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801557:	74 1e                	je     801577 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 52 0c             	mov    0xc(%edx),%edx
  80155f:	85 d2                	test   %edx,%edx
  801561:	74 35                	je     801598 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	ff 75 10             	pushl  0x10(%ebp)
  801569:	ff 75 0c             	pushl  0xc(%ebp)
  80156c:	50                   	push   %eax
  80156d:	ff d2                	call   *%edx
  80156f:	83 c4 10             	add    $0x10,%esp
}
  801572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801575:	c9                   	leave  
  801576:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801577:	a1 04 40 80 00       	mov    0x804004,%eax
  80157c:	8b 40 48             	mov    0x48(%eax),%eax
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	53                   	push   %ebx
  801583:	50                   	push   %eax
  801584:	68 c9 28 80 00       	push   $0x8028c9
  801589:	e8 30 ec ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801596:	eb da                	jmp    801572 <write+0x59>
		return -E_NOT_SUPP;
  801598:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159d:	eb d3                	jmp    801572 <write+0x59>

0080159f <seek>:

int
seek(int fdnum, off_t offset)
{
  80159f:	f3 0f 1e fb          	endbr32 
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	ff 75 08             	pushl  0x8(%ebp)
  8015b0:	e8 0b fc ff ff       	call   8011c0 <fd_lookup>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 0e                	js     8015ca <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8015bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015cc:	f3 0f 1e fb          	endbr32 
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 1c             	sub    $0x1c,%esp
  8015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015dd:	50                   	push   %eax
  8015de:	53                   	push   %ebx
  8015df:	e8 dc fb ff ff       	call   8011c0 <fd_lookup>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 37                	js     801622 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f1:	50                   	push   %eax
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	ff 30                	pushl  (%eax)
  8015f7:	e8 18 fc ff ff       	call   801214 <dev_lookup>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 1f                	js     801622 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160a:	74 1b                	je     801627 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80160c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160f:	8b 52 18             	mov    0x18(%edx),%edx
  801612:	85 d2                	test   %edx,%edx
  801614:	74 32                	je     801648 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	50                   	push   %eax
  80161d:	ff d2                	call   *%edx
  80161f:	83 c4 10             	add    $0x10,%esp
}
  801622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801625:	c9                   	leave  
  801626:	c3                   	ret    
			thisenv->env_id, fdnum);
  801627:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80162c:	8b 40 48             	mov    0x48(%eax),%eax
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	53                   	push   %ebx
  801633:	50                   	push   %eax
  801634:	68 8c 28 80 00       	push   $0x80288c
  801639:	e8 80 eb ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801646:	eb da                	jmp    801622 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801648:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164d:	eb d3                	jmp    801622 <ftruncate+0x56>

0080164f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80164f:	f3 0f 1e fb          	endbr32 
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	53                   	push   %ebx
  801657:	83 ec 1c             	sub    $0x1c,%esp
  80165a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801660:	50                   	push   %eax
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	e8 57 fb ff ff       	call   8011c0 <fd_lookup>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 4b                	js     8016bb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	ff 30                	pushl  (%eax)
  80167c:	e8 93 fb ff ff       	call   801214 <dev_lookup>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 33                	js     8016bb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80168f:	74 2f                	je     8016c0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801691:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801694:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80169b:	00 00 00 
	stat->st_isdir = 0;
  80169e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a5:	00 00 00 
	stat->st_dev = dev;
  8016a8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	53                   	push   %ebx
  8016b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b5:	ff 50 14             	call   *0x14(%eax)
  8016b8:	83 c4 10             	add    $0x10,%esp
}
  8016bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c5:	eb f4                	jmp    8016bb <fstat+0x6c>

008016c7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016c7:	f3 0f 1e fb          	endbr32 
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	6a 00                	push   $0x0
  8016d5:	ff 75 08             	pushl  0x8(%ebp)
  8016d8:	e8 fb 01 00 00       	call   8018d8 <open>
  8016dd:	89 c3                	mov    %eax,%ebx
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 1b                	js     801701 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	50                   	push   %eax
  8016ed:	e8 5d ff ff ff       	call   80164f <fstat>
  8016f2:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f4:	89 1c 24             	mov    %ebx,(%esp)
  8016f7:	e8 fd fb ff ff       	call   8012f9 <close>
	return r;
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	89 f3                	mov    %esi,%ebx
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	56                   	push   %esi
  80170e:	53                   	push   %ebx
  80170f:	89 c6                	mov    %eax,%esi
  801711:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801713:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80171a:	74 27                	je     801743 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80171c:	6a 07                	push   $0x7
  80171e:	68 00 50 80 00       	push   $0x805000
  801723:	56                   	push   %esi
  801724:	ff 35 00 40 80 00    	pushl  0x804000
  80172a:	e8 a8 08 00 00       	call   801fd7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80172f:	83 c4 0c             	add    $0xc,%esp
  801732:	6a 00                	push   $0x0
  801734:	53                   	push   %ebx
  801735:	6a 00                	push   $0x0
  801737:	e8 2e 08 00 00       	call   801f6a <ipc_recv>
}
  80173c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	6a 01                	push   $0x1
  801748:	e8 e4 08 00 00       	call   802031 <ipc_find_env>
  80174d:	a3 00 40 80 00       	mov    %eax,0x804000
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	eb c5                	jmp    80171c <fsipc+0x12>

00801757 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801757:	f3 0f 1e fb          	endbr32 
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8b 40 0c             	mov    0xc(%eax),%eax
  801767:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801774:	ba 00 00 00 00       	mov    $0x0,%edx
  801779:	b8 02 00 00 00       	mov    $0x2,%eax
  80177e:	e8 87 ff ff ff       	call   80170a <fsipc>
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <devfile_flush>:
{
  801785:	f3 0f 1e fb          	endbr32 
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80179a:	ba 00 00 00 00       	mov    $0x0,%edx
  80179f:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a4:	e8 61 ff ff ff       	call   80170a <fsipc>
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <devfile_stat>:
{
  8017ab:	f3 0f 1e fb          	endbr32 
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	53                   	push   %ebx
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ce:	e8 37 ff ff ff       	call   80170a <fsipc>
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 2c                	js     801803 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	68 00 50 80 00       	push   $0x805000
  8017df:	53                   	push   %ebx
  8017e0:	e8 e3 ef ff ff       	call   8007c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e5:	a1 80 50 80 00       	mov    0x805080,%eax
  8017ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017f0:	a1 84 50 80 00       	mov    0x805084,%eax
  8017f5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <devfile_write>:
{
  801808:	f3 0f 1e fb          	endbr32 
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80181a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80181f:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801822:	8b 55 08             	mov    0x8(%ebp),%edx
  801825:	8b 52 0c             	mov    0xc(%edx),%edx
  801828:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80182e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801833:	50                   	push   %eax
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	68 08 50 80 00       	push   $0x805008
  80183c:	e8 3d f1 ff ff       	call   80097e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	b8 04 00 00 00       	mov    $0x4,%eax
  80184b:	e8 ba fe ff ff       	call   80170a <fsipc>
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <devfile_read>:
{
  801852:	f3 0f 1e fb          	endbr32 
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	56                   	push   %esi
  80185a:	53                   	push   %ebx
  80185b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	8b 40 0c             	mov    0xc(%eax),%eax
  801864:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801869:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
  801874:	b8 03 00 00 00       	mov    $0x3,%eax
  801879:	e8 8c fe ff ff       	call   80170a <fsipc>
  80187e:	89 c3                	mov    %eax,%ebx
  801880:	85 c0                	test   %eax,%eax
  801882:	78 1f                	js     8018a3 <devfile_read+0x51>
	assert(r <= n);
  801884:	39 f0                	cmp    %esi,%eax
  801886:	77 24                	ja     8018ac <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801888:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80188d:	7f 33                	jg     8018c2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	50                   	push   %eax
  801893:	68 00 50 80 00       	push   $0x805000
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	e8 de f0 ff ff       	call   80097e <memmove>
	return r;
  8018a0:	83 c4 10             	add    $0x10,%esp
}
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5e                   	pop    %esi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    
	assert(r <= n);
  8018ac:	68 f8 28 80 00       	push   $0x8028f8
  8018b1:	68 ff 28 80 00       	push   $0x8028ff
  8018b6:	6a 7d                	push   $0x7d
  8018b8:	68 14 29 80 00       	push   $0x802914
  8018bd:	e8 be 05 00 00       	call   801e80 <_panic>
	assert(r <= PGSIZE);
  8018c2:	68 1f 29 80 00       	push   $0x80291f
  8018c7:	68 ff 28 80 00       	push   $0x8028ff
  8018cc:	6a 7e                	push   $0x7e
  8018ce:	68 14 29 80 00       	push   $0x802914
  8018d3:	e8 a8 05 00 00       	call   801e80 <_panic>

008018d8 <open>:
{
  8018d8:	f3 0f 1e fb          	endbr32 
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 1c             	sub    $0x1c,%esp
  8018e4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018e7:	56                   	push   %esi
  8018e8:	e8 98 ee ff ff       	call   800785 <strlen>
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018f5:	7f 6c                	jg     801963 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8018f7:	83 ec 0c             	sub    $0xc,%esp
  8018fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	e8 67 f8 ff ff       	call   80116a <fd_alloc>
  801903:	89 c3                	mov    %eax,%ebx
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 3c                	js     801948 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80190c:	83 ec 08             	sub    $0x8,%esp
  80190f:	56                   	push   %esi
  801910:	68 00 50 80 00       	push   $0x805000
  801915:	e8 ae ee ff ff       	call   8007c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801922:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801925:	b8 01 00 00 00       	mov    $0x1,%eax
  80192a:	e8 db fd ff ff       	call   80170a <fsipc>
  80192f:	89 c3                	mov    %eax,%ebx
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	85 c0                	test   %eax,%eax
  801936:	78 19                	js     801951 <open+0x79>
	return fd2num(fd);
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	ff 75 f4             	pushl  -0xc(%ebp)
  80193e:	e8 f8 f7 ff ff       	call   80113b <fd2num>
  801943:	89 c3                	mov    %eax,%ebx
  801945:	83 c4 10             	add    $0x10,%esp
}
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5e                   	pop    %esi
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    
		fd_close(fd, 0);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	6a 00                	push   $0x0
  801956:	ff 75 f4             	pushl  -0xc(%ebp)
  801959:	e8 10 f9 ff ff       	call   80126e <fd_close>
		return r;
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	eb e5                	jmp    801948 <open+0x70>
		return -E_BAD_PATH;
  801963:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801968:	eb de                	jmp    801948 <open+0x70>

0080196a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80196a:	f3 0f 1e fb          	endbr32 
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	b8 08 00 00 00       	mov    $0x8,%eax
  80197e:	e8 87 fd ff ff       	call   80170a <fsipc>
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801985:	f3 0f 1e fb          	endbr32 
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	56                   	push   %esi
  80198d:	53                   	push   %ebx
  80198e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	e8 b3 f7 ff ff       	call   80114f <fd2data>
  80199c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80199e:	83 c4 08             	add    $0x8,%esp
  8019a1:	68 2b 29 80 00       	push   $0x80292b
  8019a6:	53                   	push   %ebx
  8019a7:	e8 1c ee ff ff       	call   8007c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019ac:	8b 46 04             	mov    0x4(%esi),%eax
  8019af:	2b 06                	sub    (%esi),%eax
  8019b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019b7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019be:	00 00 00 
	stat->st_dev = &devpipe;
  8019c1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019c8:	30 80 00 
	return 0;
}
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019d7:	f3 0f 1e fb          	endbr32 
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
  8019df:	83 ec 0c             	sub    $0xc,%esp
  8019e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019e5:	53                   	push   %ebx
  8019e6:	6a 00                	push   $0x0
  8019e8:	e8 aa f2 ff ff       	call   800c97 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019ed:	89 1c 24             	mov    %ebx,(%esp)
  8019f0:	e8 5a f7 ff ff       	call   80114f <fd2data>
  8019f5:	83 c4 08             	add    $0x8,%esp
  8019f8:	50                   	push   %eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	e8 97 f2 ff ff       	call   800c97 <sys_page_unmap>
}
  801a00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <_pipeisclosed>:
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	57                   	push   %edi
  801a09:	56                   	push   %esi
  801a0a:	53                   	push   %ebx
  801a0b:	83 ec 1c             	sub    $0x1c,%esp
  801a0e:	89 c7                	mov    %eax,%edi
  801a10:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a12:	a1 04 40 80 00       	mov    0x804004,%eax
  801a17:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	57                   	push   %edi
  801a1e:	e8 4b 06 00 00       	call   80206e <pageref>
  801a23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a26:	89 34 24             	mov    %esi,(%esp)
  801a29:	e8 40 06 00 00       	call   80206e <pageref>
		nn = thisenv->env_runs;
  801a2e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a34:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	39 cb                	cmp    %ecx,%ebx
  801a3c:	74 1b                	je     801a59 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a41:	75 cf                	jne    801a12 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a43:	8b 42 58             	mov    0x58(%edx),%eax
  801a46:	6a 01                	push   $0x1
  801a48:	50                   	push   %eax
  801a49:	53                   	push   %ebx
  801a4a:	68 32 29 80 00       	push   $0x802932
  801a4f:	e8 6a e7 ff ff       	call   8001be <cprintf>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	eb b9                	jmp    801a12 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a5c:	0f 94 c0             	sete   %al
  801a5f:	0f b6 c0             	movzbl %al,%eax
}
  801a62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5f                   	pop    %edi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <devpipe_write>:
{
  801a6a:	f3 0f 1e fb          	endbr32 
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 28             	sub    $0x28,%esp
  801a77:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a7a:	56                   	push   %esi
  801a7b:	e8 cf f6 ff ff       	call   80114f <fd2data>
  801a80:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	bf 00 00 00 00       	mov    $0x0,%edi
  801a8a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a8d:	74 4f                	je     801ade <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a8f:	8b 43 04             	mov    0x4(%ebx),%eax
  801a92:	8b 0b                	mov    (%ebx),%ecx
  801a94:	8d 51 20             	lea    0x20(%ecx),%edx
  801a97:	39 d0                	cmp    %edx,%eax
  801a99:	72 14                	jb     801aaf <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801a9b:	89 da                	mov    %ebx,%edx
  801a9d:	89 f0                	mov    %esi,%eax
  801a9f:	e8 61 ff ff ff       	call   801a05 <_pipeisclosed>
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	75 3b                	jne    801ae3 <devpipe_write+0x79>
			sys_yield();
  801aa8:	e8 3a f1 ff ff       	call   800be7 <sys_yield>
  801aad:	eb e0                	jmp    801a8f <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801aaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ab6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ab9:	89 c2                	mov    %eax,%edx
  801abb:	c1 fa 1f             	sar    $0x1f,%edx
  801abe:	89 d1                	mov    %edx,%ecx
  801ac0:	c1 e9 1b             	shr    $0x1b,%ecx
  801ac3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ac6:	83 e2 1f             	and    $0x1f,%edx
  801ac9:	29 ca                	sub    %ecx,%edx
  801acb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801acf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ad3:	83 c0 01             	add    $0x1,%eax
  801ad6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ad9:	83 c7 01             	add    $0x1,%edi
  801adc:	eb ac                	jmp    801a8a <devpipe_write+0x20>
	return i;
  801ade:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae1:	eb 05                	jmp    801ae8 <devpipe_write+0x7e>
				return 0;
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5f                   	pop    %edi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <devpipe_read>:
{
  801af0:	f3 0f 1e fb          	endbr32 
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	57                   	push   %edi
  801af8:	56                   	push   %esi
  801af9:	53                   	push   %ebx
  801afa:	83 ec 18             	sub    $0x18,%esp
  801afd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b00:	57                   	push   %edi
  801b01:	e8 49 f6 ff ff       	call   80114f <fd2data>
  801b06:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	be 00 00 00 00       	mov    $0x0,%esi
  801b10:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b13:	75 14                	jne    801b29 <devpipe_read+0x39>
	return i;
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	eb 02                	jmp    801b1c <devpipe_read+0x2c>
				return i;
  801b1a:	89 f0                	mov    %esi,%eax
}
  801b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    
			sys_yield();
  801b24:	e8 be f0 ff ff       	call   800be7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b29:	8b 03                	mov    (%ebx),%eax
  801b2b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b2e:	75 18                	jne    801b48 <devpipe_read+0x58>
			if (i > 0)
  801b30:	85 f6                	test   %esi,%esi
  801b32:	75 e6                	jne    801b1a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801b34:	89 da                	mov    %ebx,%edx
  801b36:	89 f8                	mov    %edi,%eax
  801b38:	e8 c8 fe ff ff       	call   801a05 <_pipeisclosed>
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	74 e3                	je     801b24 <devpipe_read+0x34>
				return 0;
  801b41:	b8 00 00 00 00       	mov    $0x0,%eax
  801b46:	eb d4                	jmp    801b1c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b48:	99                   	cltd   
  801b49:	c1 ea 1b             	shr    $0x1b,%edx
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	83 e0 1f             	and    $0x1f,%eax
  801b51:	29 d0                	sub    %edx,%eax
  801b53:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b5b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b5e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b61:	83 c6 01             	add    $0x1,%esi
  801b64:	eb aa                	jmp    801b10 <devpipe_read+0x20>

00801b66 <pipe>:
{
  801b66:	f3 0f 1e fb          	endbr32 
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	56                   	push   %esi
  801b6e:	53                   	push   %ebx
  801b6f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b75:	50                   	push   %eax
  801b76:	e8 ef f5 ff ff       	call   80116a <fd_alloc>
  801b7b:	89 c3                	mov    %eax,%ebx
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	85 c0                	test   %eax,%eax
  801b82:	0f 88 23 01 00 00    	js     801cab <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	68 07 04 00 00       	push   $0x407
  801b90:	ff 75 f4             	pushl  -0xc(%ebp)
  801b93:	6a 00                	push   $0x0
  801b95:	e8 70 f0 ff ff       	call   800c0a <sys_page_alloc>
  801b9a:	89 c3                	mov    %eax,%ebx
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	0f 88 04 01 00 00    	js     801cab <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ba7:	83 ec 0c             	sub    $0xc,%esp
  801baa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	e8 b7 f5 ff ff       	call   80116a <fd_alloc>
  801bb3:	89 c3                	mov    %eax,%ebx
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	0f 88 db 00 00 00    	js     801c9b <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	68 07 04 00 00       	push   $0x407
  801bc8:	ff 75 f0             	pushl  -0x10(%ebp)
  801bcb:	6a 00                	push   $0x0
  801bcd:	e8 38 f0 ff ff       	call   800c0a <sys_page_alloc>
  801bd2:	89 c3                	mov    %eax,%ebx
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	0f 88 bc 00 00 00    	js     801c9b <pipe+0x135>
	va = fd2data(fd0);
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	ff 75 f4             	pushl  -0xc(%ebp)
  801be5:	e8 65 f5 ff ff       	call   80114f <fd2data>
  801bea:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bec:	83 c4 0c             	add    $0xc,%esp
  801bef:	68 07 04 00 00       	push   $0x407
  801bf4:	50                   	push   %eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	e8 0e f0 ff ff       	call   800c0a <sys_page_alloc>
  801bfc:	89 c3                	mov    %eax,%ebx
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	85 c0                	test   %eax,%eax
  801c03:	0f 88 82 00 00 00    	js     801c8b <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c0f:	e8 3b f5 ff ff       	call   80114f <fd2data>
  801c14:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c1b:	50                   	push   %eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	56                   	push   %esi
  801c1f:	6a 00                	push   $0x0
  801c21:	e8 2b f0 ff ff       	call   800c51 <sys_page_map>
  801c26:	89 c3                	mov    %eax,%ebx
  801c28:	83 c4 20             	add    $0x20,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 4e                	js     801c7d <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801c2f:	a1 20 30 80 00       	mov    0x803020,%eax
  801c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c37:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c46:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	ff 75 f4             	pushl  -0xc(%ebp)
  801c58:	e8 de f4 ff ff       	call   80113b <fd2num>
  801c5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c60:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c62:	83 c4 04             	add    $0x4,%esp
  801c65:	ff 75 f0             	pushl  -0x10(%ebp)
  801c68:	e8 ce f4 ff ff       	call   80113b <fd2num>
  801c6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c70:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c7b:	eb 2e                	jmp    801cab <pipe+0x145>
	sys_page_unmap(0, va);
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	56                   	push   %esi
  801c81:	6a 00                	push   $0x0
  801c83:	e8 0f f0 ff ff       	call   800c97 <sys_page_unmap>
  801c88:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c91:	6a 00                	push   $0x0
  801c93:	e8 ff ef ff ff       	call   800c97 <sys_page_unmap>
  801c98:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c9b:	83 ec 08             	sub    $0x8,%esp
  801c9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca1:	6a 00                	push   $0x0
  801ca3:	e8 ef ef ff ff       	call   800c97 <sys_page_unmap>
  801ca8:	83 c4 10             	add    $0x10,%esp
}
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <pipeisclosed>:
{
  801cb4:	f3 0f 1e fb          	endbr32 
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc1:	50                   	push   %eax
  801cc2:	ff 75 08             	pushl  0x8(%ebp)
  801cc5:	e8 f6 f4 ff ff       	call   8011c0 <fd_lookup>
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	78 18                	js     801ce9 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd7:	e8 73 f4 ff ff       	call   80114f <fd2data>
  801cdc:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce1:	e8 1f fd ff ff       	call   801a05 <_pipeisclosed>
  801ce6:	83 c4 10             	add    $0x10,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ceb:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	c3                   	ret    

00801cf5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cf5:	f3 0f 1e fb          	endbr32 
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801cff:	68 4a 29 80 00       	push   $0x80294a
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	e8 bc ea ff ff       	call   8007c8 <strcpy>
	return 0;
}
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <devcons_write>:
{
  801d13:	f3 0f 1e fb          	endbr32 
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	57                   	push   %edi
  801d1b:	56                   	push   %esi
  801d1c:	53                   	push   %ebx
  801d1d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d23:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d28:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d31:	73 31                	jae    801d64 <devcons_write+0x51>
		m = n - tot;
  801d33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d36:	29 f3                	sub    %esi,%ebx
  801d38:	83 fb 7f             	cmp    $0x7f,%ebx
  801d3b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d40:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	53                   	push   %ebx
  801d47:	89 f0                	mov    %esi,%eax
  801d49:	03 45 0c             	add    0xc(%ebp),%eax
  801d4c:	50                   	push   %eax
  801d4d:	57                   	push   %edi
  801d4e:	e8 2b ec ff ff       	call   80097e <memmove>
		sys_cputs(buf, m);
  801d53:	83 c4 08             	add    $0x8,%esp
  801d56:	53                   	push   %ebx
  801d57:	57                   	push   %edi
  801d58:	e8 dd ed ff ff       	call   800b3a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d5d:	01 de                	add    %ebx,%esi
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	eb ca                	jmp    801d2e <devcons_write+0x1b>
}
  801d64:	89 f0                	mov    %esi,%eax
  801d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d69:	5b                   	pop    %ebx
  801d6a:	5e                   	pop    %esi
  801d6b:	5f                   	pop    %edi
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <devcons_read>:
{
  801d6e:	f3 0f 1e fb          	endbr32 
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d81:	74 21                	je     801da4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801d83:	e8 d4 ed ff ff       	call   800b5c <sys_cgetc>
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	75 07                	jne    801d93 <devcons_read+0x25>
		sys_yield();
  801d8c:	e8 56 ee ff ff       	call   800be7 <sys_yield>
  801d91:	eb f0                	jmp    801d83 <devcons_read+0x15>
	if (c < 0)
  801d93:	78 0f                	js     801da4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801d95:	83 f8 04             	cmp    $0x4,%eax
  801d98:	74 0c                	je     801da6 <devcons_read+0x38>
	*(char*)vbuf = c;
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	88 02                	mov    %al,(%edx)
	return 1;
  801d9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    
		return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dab:	eb f7                	jmp    801da4 <devcons_read+0x36>

00801dad <cputchar>:
{
  801dad:	f3 0f 1e fb          	endbr32 
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dbd:	6a 01                	push   $0x1
  801dbf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dc2:	50                   	push   %eax
  801dc3:	e8 72 ed ff ff       	call   800b3a <sys_cputs>
}
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <getchar>:
{
  801dcd:	f3 0f 1e fb          	endbr32 
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801dd7:	6a 01                	push   $0x1
  801dd9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ddc:	50                   	push   %eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	e8 5f f6 ff ff       	call   801443 <read>
	if (r < 0)
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	85 c0                	test   %eax,%eax
  801de9:	78 06                	js     801df1 <getchar+0x24>
	if (r < 1)
  801deb:	74 06                	je     801df3 <getchar+0x26>
	return c;
  801ded:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    
		return -E_EOF;
  801df3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801df8:	eb f7                	jmp    801df1 <getchar+0x24>

00801dfa <iscons>:
{
  801dfa:	f3 0f 1e fb          	endbr32 
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e07:	50                   	push   %eax
  801e08:	ff 75 08             	pushl  0x8(%ebp)
  801e0b:	e8 b0 f3 ff ff       	call   8011c0 <fd_lookup>
  801e10:	83 c4 10             	add    $0x10,%esp
  801e13:	85 c0                	test   %eax,%eax
  801e15:	78 11                	js     801e28 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e20:	39 10                	cmp    %edx,(%eax)
  801e22:	0f 94 c0             	sete   %al
  801e25:	0f b6 c0             	movzbl %al,%eax
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <opencons>:
{
  801e2a:	f3 0f 1e fb          	endbr32 
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e37:	50                   	push   %eax
  801e38:	e8 2d f3 ff ff       	call   80116a <fd_alloc>
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 3a                	js     801e7e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	68 07 04 00 00       	push   $0x407
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	6a 00                	push   $0x0
  801e51:	e8 b4 ed ff ff       	call   800c0a <sys_page_alloc>
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 21                	js     801e7e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e60:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e66:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	50                   	push   %eax
  801e76:	e8 c0 f2 ff ff       	call   80113b <fd2num>
  801e7b:	83 c4 10             	add    $0x10,%esp
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e80:	f3 0f 1e fb          	endbr32 
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e89:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e8c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e92:	e8 2d ed ff ff       	call   800bc4 <sys_getenvid>
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	ff 75 08             	pushl  0x8(%ebp)
  801ea0:	56                   	push   %esi
  801ea1:	50                   	push   %eax
  801ea2:	68 58 29 80 00       	push   $0x802958
  801ea7:	e8 12 e3 ff ff       	call   8001be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	53                   	push   %ebx
  801eb0:	ff 75 10             	pushl  0x10(%ebp)
  801eb3:	e8 b1 e2 ff ff       	call   800169 <vcprintf>
	cprintf("\n");
  801eb8:	c7 04 24 b4 23 80 00 	movl   $0x8023b4,(%esp)
  801ebf:	e8 fa e2 ff ff       	call   8001be <cprintf>
  801ec4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ec7:	cc                   	int3   
  801ec8:	eb fd                	jmp    801ec7 <_panic+0x47>

00801eca <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801eca:	f3 0f 1e fb          	endbr32 
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ed5:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801edc:	74 0d                	je     801eeb <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    
		envid_t envid=sys_getenvid();
  801eeb:	e8 d4 ec ff ff       	call   800bc4 <sys_getenvid>
  801ef0:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	6a 07                	push   $0x7
  801ef7:	68 00 f0 bf ee       	push   $0xeebff000
  801efc:	50                   	push   %eax
  801efd:	e8 08 ed ff ff       	call   800c0a <sys_page_alloc>
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	85 c0                	test   %eax,%eax
  801f07:	78 29                	js     801f32 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  801f09:	83 ec 08             	sub    $0x8,%esp
  801f0c:	68 46 1f 80 00       	push   $0x801f46
  801f11:	53                   	push   %ebx
  801f12:	e8 52 ee ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	79 c0                	jns    801ede <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 a8 29 80 00       	push   $0x8029a8
  801f26:	6a 24                	push   $0x24
  801f28:	68 df 29 80 00       	push   $0x8029df
  801f2d:	e8 4e ff ff ff       	call   801e80 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	68 7c 29 80 00       	push   $0x80297c
  801f3a:	6a 22                	push   $0x22
  801f3c:	68 df 29 80 00       	push   $0x8029df
  801f41:	e8 3a ff ff ff       	call   801e80 <_panic>

00801f46 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f46:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f47:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f4c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f4e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  801f51:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  801f54:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  801f58:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  801f5d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  801f61:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801f63:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  801f64:	83 c4 04             	add    $0x4,%esp
	popfl
  801f67:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f68:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801f69:	c3                   	ret    

00801f6a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f6a:	f3 0f 1e fb          	endbr32 
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	56                   	push   %esi
  801f72:	53                   	push   %ebx
  801f73:	8b 75 08             	mov    0x8(%ebp),%esi
  801f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f83:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	50                   	push   %eax
  801f8a:	e8 47 ee ff ff       	call   800dd6 <sys_ipc_recv>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 2b                	js     801fc1 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801f96:	85 f6                	test   %esi,%esi
  801f98:	74 0a                	je     801fa4 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801f9a:	a1 04 40 80 00       	mov    0x804004,%eax
  801f9f:	8b 40 74             	mov    0x74(%eax),%eax
  801fa2:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801fa4:	85 db                	test   %ebx,%ebx
  801fa6:	74 0a                	je     801fb2 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801fa8:	a1 04 40 80 00       	mov    0x804004,%eax
  801fad:	8b 40 78             	mov    0x78(%eax),%eax
  801fb0:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801fb2:	a1 04 40 80 00       	mov    0x804004,%eax
  801fb7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    
		if(from_env_store)
  801fc1:	85 f6                	test   %esi,%esi
  801fc3:	74 06                	je     801fcb <ipc_recv+0x61>
			*from_env_store=0;
  801fc5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801fcb:	85 db                	test   %ebx,%ebx
  801fcd:	74 eb                	je     801fba <ipc_recv+0x50>
			*perm_store=0;
  801fcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fd5:	eb e3                	jmp    801fba <ipc_recv+0x50>

00801fd7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fd7:	f3 0f 1e fb          	endbr32 
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	57                   	push   %edi
  801fdf:	56                   	push   %esi
  801fe0:	53                   	push   %ebx
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fe7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801fed:	85 db                	test   %ebx,%ebx
  801fef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ff4:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801ff7:	ff 75 14             	pushl  0x14(%ebp)
  801ffa:	53                   	push   %ebx
  801ffb:	56                   	push   %esi
  801ffc:	57                   	push   %edi
  801ffd:	e8 ad ed ff ff       	call   800daf <sys_ipc_try_send>
		if(!res)
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	74 20                	je     802029 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802009:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80200c:	75 07                	jne    802015 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80200e:	e8 d4 eb ff ff       	call   800be7 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802013:	eb e2                	jmp    801ff7 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 ed 29 80 00       	push   $0x8029ed
  80201d:	6a 3f                	push   $0x3f
  80201f:	68 05 2a 80 00       	push   $0x802a05
  802024:	e8 57 fe ff ff       	call   801e80 <_panic>
	}
}
  802029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5f                   	pop    %edi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    

00802031 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802031:	f3 0f 1e fb          	endbr32 
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802040:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802043:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802049:	8b 52 50             	mov    0x50(%edx),%edx
  80204c:	39 ca                	cmp    %ecx,%edx
  80204e:	74 11                	je     802061 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802050:	83 c0 01             	add    $0x1,%eax
  802053:	3d 00 04 00 00       	cmp    $0x400,%eax
  802058:	75 e6                	jne    802040 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	eb 0b                	jmp    80206c <ipc_find_env+0x3b>
			return envs[i].env_id;
  802061:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802064:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802069:	8b 40 48             	mov    0x48(%eax),%eax
}
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80206e:	f3 0f 1e fb          	endbr32 
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802078:	89 c2                	mov    %eax,%edx
  80207a:	c1 ea 16             	shr    $0x16,%edx
  80207d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802084:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802089:	f6 c1 01             	test   $0x1,%cl
  80208c:	74 1c                	je     8020aa <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80208e:	c1 e8 0c             	shr    $0xc,%eax
  802091:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802098:	a8 01                	test   $0x1,%al
  80209a:	74 0e                	je     8020aa <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80209c:	c1 e8 0c             	shr    $0xc,%eax
  80209f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020a6:	ef 
  8020a7:	0f b7 d2             	movzwl %dx,%edx
}
  8020aa:	89 d0                	mov    %edx,%eax
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    
  8020ae:	66 90                	xchg   %ax,%ax

008020b0 <__udivdi3>:
  8020b0:	f3 0f 1e fb          	endbr32 
  8020b4:	55                   	push   %ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020cb:	85 d2                	test   %edx,%edx
  8020cd:	75 19                	jne    8020e8 <__udivdi3+0x38>
  8020cf:	39 f3                	cmp    %esi,%ebx
  8020d1:	76 4d                	jbe    802120 <__udivdi3+0x70>
  8020d3:	31 ff                	xor    %edi,%edi
  8020d5:	89 e8                	mov    %ebp,%eax
  8020d7:	89 f2                	mov    %esi,%edx
  8020d9:	f7 f3                	div    %ebx
  8020db:	89 fa                	mov    %edi,%edx
  8020dd:	83 c4 1c             	add    $0x1c,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5f                   	pop    %edi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
  8020e5:	8d 76 00             	lea    0x0(%esi),%esi
  8020e8:	39 f2                	cmp    %esi,%edx
  8020ea:	76 14                	jbe    802100 <__udivdi3+0x50>
  8020ec:	31 ff                	xor    %edi,%edi
  8020ee:	31 c0                	xor    %eax,%eax
  8020f0:	89 fa                	mov    %edi,%edx
  8020f2:	83 c4 1c             	add    $0x1c,%esp
  8020f5:	5b                   	pop    %ebx
  8020f6:	5e                   	pop    %esi
  8020f7:	5f                   	pop    %edi
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    
  8020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802100:	0f bd fa             	bsr    %edx,%edi
  802103:	83 f7 1f             	xor    $0x1f,%edi
  802106:	75 48                	jne    802150 <__udivdi3+0xa0>
  802108:	39 f2                	cmp    %esi,%edx
  80210a:	72 06                	jb     802112 <__udivdi3+0x62>
  80210c:	31 c0                	xor    %eax,%eax
  80210e:	39 eb                	cmp    %ebp,%ebx
  802110:	77 de                	ja     8020f0 <__udivdi3+0x40>
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	eb d7                	jmp    8020f0 <__udivdi3+0x40>
  802119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802120:	89 d9                	mov    %ebx,%ecx
  802122:	85 db                	test   %ebx,%ebx
  802124:	75 0b                	jne    802131 <__udivdi3+0x81>
  802126:	b8 01 00 00 00       	mov    $0x1,%eax
  80212b:	31 d2                	xor    %edx,%edx
  80212d:	f7 f3                	div    %ebx
  80212f:	89 c1                	mov    %eax,%ecx
  802131:	31 d2                	xor    %edx,%edx
  802133:	89 f0                	mov    %esi,%eax
  802135:	f7 f1                	div    %ecx
  802137:	89 c6                	mov    %eax,%esi
  802139:	89 e8                	mov    %ebp,%eax
  80213b:	89 f7                	mov    %esi,%edi
  80213d:	f7 f1                	div    %ecx
  80213f:	89 fa                	mov    %edi,%edx
  802141:	83 c4 1c             	add    $0x1c,%esp
  802144:	5b                   	pop    %ebx
  802145:	5e                   	pop    %esi
  802146:	5f                   	pop    %edi
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 f9                	mov    %edi,%ecx
  802152:	b8 20 00 00 00       	mov    $0x20,%eax
  802157:	29 f8                	sub    %edi,%eax
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 da                	mov    %ebx,%edx
  802163:	d3 ea                	shr    %cl,%edx
  802165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802169:	09 d1                	or     %edx,%ecx
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e3                	shl    %cl,%ebx
  802175:	89 c1                	mov    %eax,%ecx
  802177:	d3 ea                	shr    %cl,%edx
  802179:	89 f9                	mov    %edi,%ecx
  80217b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80217f:	89 eb                	mov    %ebp,%ebx
  802181:	d3 e6                	shl    %cl,%esi
  802183:	89 c1                	mov    %eax,%ecx
  802185:	d3 eb                	shr    %cl,%ebx
  802187:	09 de                	or     %ebx,%esi
  802189:	89 f0                	mov    %esi,%eax
  80218b:	f7 74 24 08          	divl   0x8(%esp)
  80218f:	89 d6                	mov    %edx,%esi
  802191:	89 c3                	mov    %eax,%ebx
  802193:	f7 64 24 0c          	mull   0xc(%esp)
  802197:	39 d6                	cmp    %edx,%esi
  802199:	72 15                	jb     8021b0 <__udivdi3+0x100>
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	39 c5                	cmp    %eax,%ebp
  8021a1:	73 04                	jae    8021a7 <__udivdi3+0xf7>
  8021a3:	39 d6                	cmp    %edx,%esi
  8021a5:	74 09                	je     8021b0 <__udivdi3+0x100>
  8021a7:	89 d8                	mov    %ebx,%eax
  8021a9:	31 ff                	xor    %edi,%edi
  8021ab:	e9 40 ff ff ff       	jmp    8020f0 <__udivdi3+0x40>
  8021b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	e9 36 ff ff ff       	jmp    8020f0 <__udivdi3+0x40>
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	75 19                	jne    8021f8 <__umoddi3+0x38>
  8021df:	39 df                	cmp    %ebx,%edi
  8021e1:	76 5d                	jbe    802240 <__umoddi3+0x80>
  8021e3:	89 f0                	mov    %esi,%eax
  8021e5:	89 da                	mov    %ebx,%edx
  8021e7:	f7 f7                	div    %edi
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	89 f2                	mov    %esi,%edx
  8021fa:	39 d8                	cmp    %ebx,%eax
  8021fc:	76 12                	jbe    802210 <__umoddi3+0x50>
  8021fe:	89 f0                	mov    %esi,%eax
  802200:	89 da                	mov    %ebx,%edx
  802202:	83 c4 1c             	add    $0x1c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	0f bd e8             	bsr    %eax,%ebp
  802213:	83 f5 1f             	xor    $0x1f,%ebp
  802216:	75 50                	jne    802268 <__umoddi3+0xa8>
  802218:	39 d8                	cmp    %ebx,%eax
  80221a:	0f 82 e0 00 00 00    	jb     802300 <__umoddi3+0x140>
  802220:	89 d9                	mov    %ebx,%ecx
  802222:	39 f7                	cmp    %esi,%edi
  802224:	0f 86 d6 00 00 00    	jbe    802300 <__umoddi3+0x140>
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	89 ca                	mov    %ecx,%edx
  80222e:	83 c4 1c             	add    $0x1c,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80223d:	8d 76 00             	lea    0x0(%esi),%esi
  802240:	89 fd                	mov    %edi,%ebp
  802242:	85 ff                	test   %edi,%edi
  802244:	75 0b                	jne    802251 <__umoddi3+0x91>
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	f7 f7                	div    %edi
  80224f:	89 c5                	mov    %eax,%ebp
  802251:	89 d8                	mov    %ebx,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f5                	div    %ebp
  802257:	89 f0                	mov    %esi,%eax
  802259:	f7 f5                	div    %ebp
  80225b:	89 d0                	mov    %edx,%eax
  80225d:	31 d2                	xor    %edx,%edx
  80225f:	eb 8c                	jmp    8021ed <__umoddi3+0x2d>
  802261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	ba 20 00 00 00       	mov    $0x20,%edx
  80226f:	29 ea                	sub    %ebp,%edx
  802271:	d3 e0                	shl    %cl,%eax
  802273:	89 44 24 08          	mov    %eax,0x8(%esp)
  802277:	89 d1                	mov    %edx,%ecx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	d3 e8                	shr    %cl,%eax
  80227d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802281:	89 54 24 04          	mov    %edx,0x4(%esp)
  802285:	8b 54 24 04          	mov    0x4(%esp),%edx
  802289:	09 c1                	or     %eax,%ecx
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e7                	shl    %cl,%edi
  802295:	89 d1                	mov    %edx,%ecx
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	89 d1                	mov    %edx,%ecx
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	d3 e6                	shl    %cl,%esi
  8022af:	09 d8                	or     %ebx,%eax
  8022b1:	f7 74 24 08          	divl   0x8(%esp)
  8022b5:	89 d1                	mov    %edx,%ecx
  8022b7:	89 f3                	mov    %esi,%ebx
  8022b9:	f7 64 24 0c          	mull   0xc(%esp)
  8022bd:	89 c6                	mov    %eax,%esi
  8022bf:	89 d7                	mov    %edx,%edi
  8022c1:	39 d1                	cmp    %edx,%ecx
  8022c3:	72 06                	jb     8022cb <__umoddi3+0x10b>
  8022c5:	75 10                	jne    8022d7 <__umoddi3+0x117>
  8022c7:	39 c3                	cmp    %eax,%ebx
  8022c9:	73 0c                	jae    8022d7 <__umoddi3+0x117>
  8022cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022d3:	89 d7                	mov    %edx,%edi
  8022d5:	89 c6                	mov    %eax,%esi
  8022d7:	89 ca                	mov    %ecx,%edx
  8022d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022de:	29 f3                	sub    %esi,%ebx
  8022e0:	19 fa                	sbb    %edi,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	d3 e0                	shl    %cl,%eax
  8022e6:	89 e9                	mov    %ebp,%ecx
  8022e8:	d3 eb                	shr    %cl,%ebx
  8022ea:	d3 ea                	shr    %cl,%edx
  8022ec:	09 d8                	or     %ebx,%eax
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	29 fe                	sub    %edi,%esi
  802302:	19 c3                	sbb    %eax,%ebx
  802304:	89 f2                	mov    %esi,%edx
  802306:	89 d9                	mov    %ebx,%ecx
  802308:	e9 1d ff ff ff       	jmp    80222a <__umoddi3+0x6a>
