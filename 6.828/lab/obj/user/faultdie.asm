
obj/user/faultdie.debug：     文件格式 elf32-i386


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
  80002c:	e8 57 00 00 00       	call   800088 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800040:	8b 42 04             	mov    0x4(%edx),%eax
  800043:	83 e0 07             	and    $0x7,%eax
  800046:	50                   	push   %eax
  800047:	ff 32                	pushl  (%edx)
  800049:	68 c0 1f 80 00       	push   $0x801fc0
  80004e:	e8 3a 01 00 00       	call   80018d <cprintf>
	sys_env_destroy(sys_getenvid());
  800053:	e8 3b 0b 00 00       	call   800b93 <sys_getenvid>
  800058:	89 04 24             	mov    %eax,(%esp)
  80005b:	e8 ee 0a 00 00       	call   800b4e <sys_env_destroy>
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <umain>:

void
umain(int argc, char **argv)
{
  800065:	f3 0f 1e fb          	endbr32 
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80006f:	68 33 00 80 00       	push   $0x800033
  800074:	e8 71 0d 00 00       	call   800dea <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800079:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800080:	00 00 00 
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	c9                   	leave  
  800087:	c3                   	ret    

00800088 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	56                   	push   %esi
  800090:	53                   	push   %ebx
  800091:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800094:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800097:	e8 f7 0a 00 00       	call   800b93 <sys_getenvid>
  80009c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	85 db                	test   %ebx,%ebx
  8000b0:	7e 07                	jle    8000b9 <libmain+0x31>
		binaryname = argv[0];
  8000b2:	8b 06                	mov    (%esi),%eax
  8000b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
  8000be:	e8 a2 ff ff ff       	call   800065 <umain>

	// exit gracefully
	exit();
  8000c3:	e8 0a 00 00 00       	call   8000d2 <exit>
}
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000dc:	e8 98 0f 00 00       	call   801079 <close_all>
	sys_env_destroy(0);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	6a 00                	push   $0x0
  8000e6:	e8 63 0a 00 00       	call   800b4e <sys_env_destroy>
}
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	c9                   	leave  
  8000ef:	c3                   	ret    

008000f0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f0:	f3 0f 1e fb          	endbr32 
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fe:	8b 13                	mov    (%ebx),%edx
  800100:	8d 42 01             	lea    0x1(%edx),%eax
  800103:	89 03                	mov    %eax,(%ebx)
  800105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800108:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800111:	74 09                	je     80011c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800113:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011a:	c9                   	leave  
  80011b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	68 ff 00 00 00       	push   $0xff
  800124:	8d 43 08             	lea    0x8(%ebx),%eax
  800127:	50                   	push   %eax
  800128:	e8 dc 09 00 00       	call   800b09 <sys_cputs>
		b->idx = 0;
  80012d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	eb db                	jmp    800113 <putch+0x23>

00800138 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800145:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014c:	00 00 00 
	b.cnt = 0;
  80014f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800156:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800165:	50                   	push   %eax
  800166:	68 f0 00 80 00       	push   $0x8000f0
  80016b:	e8 20 01 00 00       	call   800290 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800170:	83 c4 08             	add    $0x8,%esp
  800173:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800179:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017f:	50                   	push   %eax
  800180:	e8 84 09 00 00       	call   800b09 <sys_cputs>

	return b.cnt;
}
  800185:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018d:	f3 0f 1e fb          	endbr32 
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800197:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019a:	50                   	push   %eax
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 ff ff ff       	call   800138 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 1c             	sub    $0x1c,%esp
  8001ae:	89 c7                	mov    %eax,%edi
  8001b0:	89 d6                	mov    %edx,%esi
  8001b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b8:	89 d1                	mov    %edx,%ecx
  8001ba:	89 c2                	mov    %eax,%edx
  8001bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d2:	39 c2                	cmp    %eax,%edx
  8001d4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001d7:	72 3e                	jb     800217 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 18             	pushl  0x18(%ebp)
  8001df:	83 eb 01             	sub    $0x1,%ebx
  8001e2:	53                   	push   %ebx
  8001e3:	50                   	push   %eax
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f3:	e8 68 1b 00 00       	call   801d60 <__udivdi3>
  8001f8:	83 c4 18             	add    $0x18,%esp
  8001fb:	52                   	push   %edx
  8001fc:	50                   	push   %eax
  8001fd:	89 f2                	mov    %esi,%edx
  8001ff:	89 f8                	mov    %edi,%eax
  800201:	e8 9f ff ff ff       	call   8001a5 <printnum>
  800206:	83 c4 20             	add    $0x20,%esp
  800209:	eb 13                	jmp    80021e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	56                   	push   %esi
  80020f:	ff 75 18             	pushl  0x18(%ebp)
  800212:	ff d7                	call   *%edi
  800214:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800217:	83 eb 01             	sub    $0x1,%ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7f ed                	jg     80020b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	56                   	push   %esi
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e4             	pushl  -0x1c(%ebp)
  800228:	ff 75 e0             	pushl  -0x20(%ebp)
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	e8 3a 1c 00 00       	call   801e70 <__umoddi3>
  800236:	83 c4 14             	add    $0x14,%esp
  800239:	0f be 80 e6 1f 80 00 	movsbl 0x801fe6(%eax),%eax
  800240:	50                   	push   %eax
  800241:	ff d7                	call   *%edi
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1f>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	f3 0f 1e fb          	endbr32 
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800279:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027c:	50                   	push   %eax
  80027d:	ff 75 10             	pushl  0x10(%ebp)
  800280:	ff 75 0c             	pushl  0xc(%ebp)
  800283:	ff 75 08             	pushl  0x8(%ebp)
  800286:	e8 05 00 00 00       	call   800290 <vprintfmt>
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <vprintfmt>:
{
  800290:	f3 0f 1e fb          	endbr32 
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 3c             	sub    $0x3c,%esp
  80029d:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a6:	e9 8e 03 00 00       	jmp    800639 <vprintfmt+0x3a9>
		padc = ' ';
  8002ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c9:	8d 47 01             	lea    0x1(%edi),%eax
  8002cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cf:	0f b6 17             	movzbl (%edi),%edx
  8002d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d5:	3c 55                	cmp    $0x55,%al
  8002d7:	0f 87 df 03 00 00    	ja     8006bc <vprintfmt+0x42c>
  8002dd:	0f b6 c0             	movzbl %al,%eax
  8002e0:	3e ff 24 85 20 21 80 	notrack jmp *0x802120(,%eax,4)
  8002e7:	00 
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002eb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ef:	eb d8                	jmp    8002c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002f8:	eb cf                	jmp    8002c9 <vprintfmt+0x39>
  8002fa:	0f b6 d2             	movzbl %dl,%edx
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800308:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800312:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800315:	83 f9 09             	cmp    $0x9,%ecx
  800318:	77 55                	ja     80036f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80031a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031d:	eb e9                	jmp    800308 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	8b 00                	mov    (%eax),%eax
  800324:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800327:	8b 45 14             	mov    0x14(%ebp),%eax
  80032a:	8d 40 04             	lea    0x4(%eax),%eax
  80032d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800333:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800337:	79 90                	jns    8002c9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800339:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80033c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800346:	eb 81                	jmp    8002c9 <vprintfmt+0x39>
  800348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034b:	85 c0                	test   %eax,%eax
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	0f 49 d0             	cmovns %eax,%edx
  800355:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035b:	e9 69 ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800363:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80036a:	e9 5a ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
  80036f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800372:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800375:	eb bc                	jmp    800333 <vprintfmt+0xa3>
			lflag++;
  800377:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037d:	e9 47 ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800382:	8b 45 14             	mov    0x14(%ebp),%eax
  800385:	8d 78 04             	lea    0x4(%eax),%edi
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	53                   	push   %ebx
  80038c:	ff 30                	pushl  (%eax)
  80038e:	ff d6                	call   *%esi
			break;
  800390:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800393:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800396:	e9 9b 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80039b:	8b 45 14             	mov    0x14(%ebp),%eax
  80039e:	8d 78 04             	lea    0x4(%eax),%edi
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	99                   	cltd   
  8003a4:	31 d0                	xor    %edx,%eax
  8003a6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a8:	83 f8 0f             	cmp    $0xf,%eax
  8003ab:	7f 23                	jg     8003d0 <vprintfmt+0x140>
  8003ad:	8b 14 85 80 22 80 00 	mov    0x802280(,%eax,4),%edx
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	74 18                	je     8003d0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003b8:	52                   	push   %edx
  8003b9:	68 25 24 80 00       	push   $0x802425
  8003be:	53                   	push   %ebx
  8003bf:	56                   	push   %esi
  8003c0:	e8 aa fe ff ff       	call   80026f <printfmt>
  8003c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cb:	e9 66 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003d0:	50                   	push   %eax
  8003d1:	68 fe 1f 80 00       	push   $0x801ffe
  8003d6:	53                   	push   %ebx
  8003d7:	56                   	push   %esi
  8003d8:	e8 92 fe ff ff       	call   80026f <printfmt>
  8003dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e3:	e9 4e 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	83 c0 04             	add    $0x4,%eax
  8003ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003f6:	85 d2                	test   %edx,%edx
  8003f8:	b8 f7 1f 80 00       	mov    $0x801ff7,%eax
  8003fd:	0f 45 c2             	cmovne %edx,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800403:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800407:	7e 06                	jle    80040f <vprintfmt+0x17f>
  800409:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80040d:	75 0d                	jne    80041c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800412:	89 c7                	mov    %eax,%edi
  800414:	03 45 e0             	add    -0x20(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041a:	eb 55                	jmp    800471 <vprintfmt+0x1e1>
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d8             	pushl  -0x28(%ebp)
  800422:	ff 75 cc             	pushl  -0x34(%ebp)
  800425:	e8 46 03 00 00       	call   800770 <strnlen>
  80042a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042d:	29 c2                	sub    %eax,%edx
  80042f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800437:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80043b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043e:	85 ff                	test   %edi,%edi
  800440:	7e 11                	jle    800453 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	53                   	push   %ebx
  800446:	ff 75 e0             	pushl  -0x20(%ebp)
  800449:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	83 ef 01             	sub    $0x1,%edi
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	eb eb                	jmp    80043e <vprintfmt+0x1ae>
  800453:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	b8 00 00 00 00       	mov    $0x0,%eax
  80045d:	0f 49 c2             	cmovns %edx,%eax
  800460:	29 c2                	sub    %eax,%edx
  800462:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800465:	eb a8                	jmp    80040f <vprintfmt+0x17f>
					putch(ch, putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	53                   	push   %ebx
  80046b:	52                   	push   %edx
  80046c:	ff d6                	call   *%esi
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800474:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800476:	83 c7 01             	add    $0x1,%edi
  800479:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047d:	0f be d0             	movsbl %al,%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	74 4b                	je     8004cf <vprintfmt+0x23f>
  800484:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800488:	78 06                	js     800490 <vprintfmt+0x200>
  80048a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048e:	78 1e                	js     8004ae <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800490:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800494:	74 d1                	je     800467 <vprintfmt+0x1d7>
  800496:	0f be c0             	movsbl %al,%eax
  800499:	83 e8 20             	sub    $0x20,%eax
  80049c:	83 f8 5e             	cmp    $0x5e,%eax
  80049f:	76 c6                	jbe    800467 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 3f                	push   $0x3f
  8004a7:	ff d6                	call   *%esi
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	eb c3                	jmp    800471 <vprintfmt+0x1e1>
  8004ae:	89 cf                	mov    %ecx,%edi
  8004b0:	eb 0e                	jmp    8004c0 <vprintfmt+0x230>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 67 01 00 00       	jmp    800636 <vprintfmt+0x3a6>
  8004cf:	89 cf                	mov    %ecx,%edi
  8004d1:	eb ed                	jmp    8004c0 <vprintfmt+0x230>
	if (lflag >= 2)
  8004d3:	83 f9 01             	cmp    $0x1,%ecx
  8004d6:	7f 1b                	jg     8004f3 <vprintfmt+0x263>
	else if (lflag)
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	74 63                	je     80053f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e4:	99                   	cltd   
  8004e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 40 04             	lea    0x4(%eax),%eax
  8004ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f1:	eb 17                	jmp    80050a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8b 50 04             	mov    0x4(%eax),%edx
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 40 08             	lea    0x8(%eax),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80050d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800510:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800515:	85 c9                	test   %ecx,%ecx
  800517:	0f 89 ff 00 00 00    	jns    80061c <vprintfmt+0x38c>
				putch('-', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	6a 2d                	push   $0x2d
  800523:	ff d6                	call   *%esi
				num = -(long long) num;
  800525:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800528:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80052b:	f7 da                	neg    %edx
  80052d:	83 d1 00             	adc    $0x0,%ecx
  800530:	f7 d9                	neg    %ecx
  800532:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800535:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053a:	e9 dd 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800547:	99                   	cltd   
  800548:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 40 04             	lea    0x4(%eax),%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	eb b4                	jmp    80050a <vprintfmt+0x27a>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7f 1e                	jg     800579 <vprintfmt+0x2e9>
	else if (lflag)
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	74 32                	je     800591 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800574:	e9 a3 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 10                	mov    (%eax),%edx
  80057e:	8b 48 04             	mov    0x4(%eax),%ecx
  800581:	8d 40 08             	lea    0x8(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80058c:	e9 8b 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005a6:	eb 74                	jmp    80061c <vprintfmt+0x38c>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7f 1b                	jg     8005c8 <vprintfmt+0x338>
	else if (lflag)
  8005ad:	85 c9                	test   %ecx,%ecx
  8005af:	74 2c                	je     8005dd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 10                	mov    (%eax),%edx
  8005b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005c6:	eb 54                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d0:	8d 40 08             	lea    0x8(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005db:	eb 3f                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005ed:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005f2:	eb 28                	jmp    80061c <vprintfmt+0x38c>
			putch('0', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 30                	push   $0x30
  8005fa:	ff d6                	call   *%esi
			putch('x', putdat);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 78                	push   $0x78
  800602:	ff d6                	call   *%esi
			num = (unsigned long long)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800617:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800623:	57                   	push   %edi
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	50                   	push   %eax
  800628:	51                   	push   %ecx
  800629:	52                   	push   %edx
  80062a:	89 da                	mov    %ebx,%edx
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	e8 72 fb ff ff       	call   8001a5 <printnum>
			break;
  800633:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	83 c7 01             	add    $0x1,%edi
  80063c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800640:	83 f8 25             	cmp    $0x25,%eax
  800643:	0f 84 62 fc ff ff    	je     8002ab <vprintfmt+0x1b>
			if (ch == '\0')
  800649:	85 c0                	test   %eax,%eax
  80064b:	0f 84 8b 00 00 00    	je     8006dc <vprintfmt+0x44c>
			putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	50                   	push   %eax
  800656:	ff d6                	call   *%esi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb dc                	jmp    800639 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80065d:	83 f9 01             	cmp    $0x1,%ecx
  800660:	7f 1b                	jg     80067d <vprintfmt+0x3ed>
	else if (lflag)
  800662:	85 c9                	test   %ecx,%ecx
  800664:	74 2c                	je     800692 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80067b:	eb 9f                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	8b 48 04             	mov    0x4(%eax),%ecx
  800685:	8d 40 08             	lea    0x8(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800690:	eb 8a                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006a7:	e9 70 ff ff ff       	jmp    80061c <vprintfmt+0x38c>
			putch(ch, putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 25                	push   $0x25
  8006b2:	ff d6                	call   *%esi
			break;
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	e9 7a ff ff ff       	jmp    800636 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 25                	push   $0x25
  8006c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	89 f8                	mov    %edi,%eax
  8006c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006cd:	74 05                	je     8006d4 <vprintfmt+0x444>
  8006cf:	83 e8 01             	sub    $0x1,%eax
  8006d2:	eb f5                	jmp    8006c9 <vprintfmt+0x439>
  8006d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d7:	e9 5a ff ff ff       	jmp    800636 <vprintfmt+0x3a6>
}
  8006dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	f3 0f 1e fb          	endbr32 
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 18             	sub    $0x18,%esp
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800705:	85 c0                	test   %eax,%eax
  800707:	74 26                	je     80072f <vsnprintf+0x4b>
  800709:	85 d2                	test   %edx,%edx
  80070b:	7e 22                	jle    80072f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80070d:	ff 75 14             	pushl  0x14(%ebp)
  800710:	ff 75 10             	pushl  0x10(%ebp)
  800713:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	68 4e 02 80 00       	push   $0x80024e
  80071c:	e8 6f fb ff ff       	call   800290 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800724:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072a:	83 c4 10             	add    $0x10,%esp
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    
		return -E_INVAL;
  80072f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800734:	eb f7                	jmp    80072d <vsnprintf+0x49>

00800736 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800736:	f3 0f 1e fb          	endbr32 
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800740:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800743:	50                   	push   %eax
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 92 ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800754:	f3 0f 1e fb          	endbr32 
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800767:	74 05                	je     80076e <strlen+0x1a>
		n++;
  800769:	83 c0 01             	add    $0x1,%eax
  80076c:	eb f5                	jmp    800763 <strlen+0xf>
	return n;
}
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800770:	f3 0f 1e fb          	endbr32 
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	39 d0                	cmp    %edx,%eax
  800784:	74 0d                	je     800793 <strnlen+0x23>
  800786:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80078a:	74 05                	je     800791 <strnlen+0x21>
		n++;
  80078c:	83 c0 01             	add    $0x1,%eax
  80078f:	eb f1                	jmp    800782 <strnlen+0x12>
  800791:	89 c2                	mov    %eax,%edx
	return n;
}
  800793:	89 d0                	mov    %edx,%eax
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800797:	f3 0f 1e fb          	endbr32 
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ae:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007b1:	83 c0 01             	add    $0x1,%eax
  8007b4:	84 d2                	test   %dl,%dl
  8007b6:	75 f2                	jne    8007aa <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007b8:	89 c8                	mov    %ecx,%eax
  8007ba:	5b                   	pop    %ebx
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bd:	f3 0f 1e fb          	endbr32 
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	53                   	push   %ebx
  8007c5:	83 ec 10             	sub    $0x10,%esp
  8007c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007cb:	53                   	push   %ebx
  8007cc:	e8 83 ff ff ff       	call   800754 <strlen>
  8007d1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007d4:	ff 75 0c             	pushl  0xc(%ebp)
  8007d7:	01 d8                	add    %ebx,%eax
  8007d9:	50                   	push   %eax
  8007da:	e8 b8 ff ff ff       	call   800797 <strcpy>
	return dst;
}
  8007df:	89 d8                	mov    %ebx,%eax
  8007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f5:	89 f3                	mov    %esi,%ebx
  8007f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007fa:	89 f0                	mov    %esi,%eax
  8007fc:	39 d8                	cmp    %ebx,%eax
  8007fe:	74 11                	je     800811 <strncpy+0x2b>
		*dst++ = *src;
  800800:	83 c0 01             	add    $0x1,%eax
  800803:	0f b6 0a             	movzbl (%edx),%ecx
  800806:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800809:	80 f9 01             	cmp    $0x1,%cl
  80080c:	83 da ff             	sbb    $0xffffffff,%edx
  80080f:	eb eb                	jmp    8007fc <strncpy+0x16>
	}
	return ret;
}
  800811:	89 f0                	mov    %esi,%eax
  800813:	5b                   	pop    %ebx
  800814:	5e                   	pop    %esi
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800826:	8b 55 10             	mov    0x10(%ebp),%edx
  800829:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082b:	85 d2                	test   %edx,%edx
  80082d:	74 21                	je     800850 <strlcpy+0x39>
  80082f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800833:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800835:	39 c2                	cmp    %eax,%edx
  800837:	74 14                	je     80084d <strlcpy+0x36>
  800839:	0f b6 19             	movzbl (%ecx),%ebx
  80083c:	84 db                	test   %bl,%bl
  80083e:	74 0b                	je     80084b <strlcpy+0x34>
			*dst++ = *src++;
  800840:	83 c1 01             	add    $0x1,%ecx
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	88 5a ff             	mov    %bl,-0x1(%edx)
  800849:	eb ea                	jmp    800835 <strlcpy+0x1e>
  80084b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80084d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800850:	29 f0                	sub    %esi,%eax
}
  800852:	5b                   	pop    %ebx
  800853:	5e                   	pop    %esi
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800863:	0f b6 01             	movzbl (%ecx),%eax
  800866:	84 c0                	test   %al,%al
  800868:	74 0c                	je     800876 <strcmp+0x20>
  80086a:	3a 02                	cmp    (%edx),%al
  80086c:	75 08                	jne    800876 <strcmp+0x20>
		p++, q++;
  80086e:	83 c1 01             	add    $0x1,%ecx
  800871:	83 c2 01             	add    $0x1,%edx
  800874:	eb ed                	jmp    800863 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800876:	0f b6 c0             	movzbl %al,%eax
  800879:	0f b6 12             	movzbl (%edx),%edx
  80087c:	29 d0                	sub    %edx,%eax
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800880:	f3 0f 1e fb          	endbr32 
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	53                   	push   %ebx
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088e:	89 c3                	mov    %eax,%ebx
  800890:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800893:	eb 06                	jmp    80089b <strncmp+0x1b>
		n--, p++, q++;
  800895:	83 c0 01             	add    $0x1,%eax
  800898:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80089b:	39 d8                	cmp    %ebx,%eax
  80089d:	74 16                	je     8008b5 <strncmp+0x35>
  80089f:	0f b6 08             	movzbl (%eax),%ecx
  8008a2:	84 c9                	test   %cl,%cl
  8008a4:	74 04                	je     8008aa <strncmp+0x2a>
  8008a6:	3a 0a                	cmp    (%edx),%cl
  8008a8:	74 eb                	je     800895 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008aa:	0f b6 00             	movzbl (%eax),%eax
  8008ad:	0f b6 12             	movzbl (%edx),%edx
  8008b0:	29 d0                	sub    %edx,%eax
}
  8008b2:	5b                   	pop    %ebx
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    
		return 0;
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ba:	eb f6                	jmp    8008b2 <strncmp+0x32>

008008bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ca:	0f b6 10             	movzbl (%eax),%edx
  8008cd:	84 d2                	test   %dl,%dl
  8008cf:	74 09                	je     8008da <strchr+0x1e>
		if (*s == c)
  8008d1:	38 ca                	cmp    %cl,%dl
  8008d3:	74 0a                	je     8008df <strchr+0x23>
	for (; *s; s++)
  8008d5:	83 c0 01             	add    $0x1,%eax
  8008d8:	eb f0                	jmp    8008ca <strchr+0xe>
			return (char *) s;
	return 0;
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e1:	f3 0f 1e fb          	endbr32 
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008f2:	38 ca                	cmp    %cl,%dl
  8008f4:	74 09                	je     8008ff <strfind+0x1e>
  8008f6:	84 d2                	test   %dl,%dl
  8008f8:	74 05                	je     8008ff <strfind+0x1e>
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	eb f0                	jmp    8008ef <strfind+0xe>
			break;
	return (char *) s;
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800901:	f3 0f 1e fb          	endbr32 
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	57                   	push   %edi
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800911:	85 c9                	test   %ecx,%ecx
  800913:	74 31                	je     800946 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800915:	89 f8                	mov    %edi,%eax
  800917:	09 c8                	or     %ecx,%eax
  800919:	a8 03                	test   $0x3,%al
  80091b:	75 23                	jne    800940 <memset+0x3f>
		c &= 0xFF;
  80091d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800921:	89 d3                	mov    %edx,%ebx
  800923:	c1 e3 08             	shl    $0x8,%ebx
  800926:	89 d0                	mov    %edx,%eax
  800928:	c1 e0 18             	shl    $0x18,%eax
  80092b:	89 d6                	mov    %edx,%esi
  80092d:	c1 e6 10             	shl    $0x10,%esi
  800930:	09 f0                	or     %esi,%eax
  800932:	09 c2                	or     %eax,%edx
  800934:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800936:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800939:	89 d0                	mov    %edx,%eax
  80093b:	fc                   	cld    
  80093c:	f3 ab                	rep stos %eax,%es:(%edi)
  80093e:	eb 06                	jmp    800946 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	fc                   	cld    
  800944:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800946:	89 f8                	mov    %edi,%eax
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5f                   	pop    %edi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	57                   	push   %edi
  800955:	56                   	push   %esi
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 75 0c             	mov    0xc(%ebp),%esi
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80095f:	39 c6                	cmp    %eax,%esi
  800961:	73 32                	jae    800995 <memmove+0x48>
  800963:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800966:	39 c2                	cmp    %eax,%edx
  800968:	76 2b                	jbe    800995 <memmove+0x48>
		s += n;
		d += n;
  80096a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096d:	89 fe                	mov    %edi,%esi
  80096f:	09 ce                	or     %ecx,%esi
  800971:	09 d6                	or     %edx,%esi
  800973:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800979:	75 0e                	jne    800989 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80097b:	83 ef 04             	sub    $0x4,%edi
  80097e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800981:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800984:	fd                   	std    
  800985:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800987:	eb 09                	jmp    800992 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800989:	83 ef 01             	sub    $0x1,%edi
  80098c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80098f:	fd                   	std    
  800990:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800992:	fc                   	cld    
  800993:	eb 1a                	jmp    8009af <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800995:	89 c2                	mov    %eax,%edx
  800997:	09 ca                	or     %ecx,%edx
  800999:	09 f2                	or     %esi,%edx
  80099b:	f6 c2 03             	test   $0x3,%dl
  80099e:	75 0a                	jne    8009aa <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009a3:	89 c7                	mov    %eax,%edi
  8009a5:	fc                   	cld    
  8009a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a8:	eb 05                	jmp    8009af <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009aa:	89 c7                	mov    %eax,%edi
  8009ac:	fc                   	cld    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009af:	5e                   	pop    %esi
  8009b0:	5f                   	pop    %edi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009bd:	ff 75 10             	pushl  0x10(%ebp)
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 82 ff ff ff       	call   80094d <memmove>
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009cd:	f3 0f 1e fb          	endbr32 
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 c6                	mov    %eax,%esi
  8009de:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e1:	39 f0                	cmp    %esi,%eax
  8009e3:	74 1c                	je     800a01 <memcmp+0x34>
		if (*s1 != *s2)
  8009e5:	0f b6 08             	movzbl (%eax),%ecx
  8009e8:	0f b6 1a             	movzbl (%edx),%ebx
  8009eb:	38 d9                	cmp    %bl,%cl
  8009ed:	75 08                	jne    8009f7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009ef:	83 c0 01             	add    $0x1,%eax
  8009f2:	83 c2 01             	add    $0x1,%edx
  8009f5:	eb ea                	jmp    8009e1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009f7:	0f b6 c1             	movzbl %cl,%eax
  8009fa:	0f b6 db             	movzbl %bl,%ebx
  8009fd:	29 d8                	sub    %ebx,%eax
  8009ff:	eb 05                	jmp    800a06 <memcmp+0x39>
	}

	return 0;
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a17:	89 c2                	mov    %eax,%edx
  800a19:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1c:	39 d0                	cmp    %edx,%eax
  800a1e:	73 09                	jae    800a29 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a20:	38 08                	cmp    %cl,(%eax)
  800a22:	74 05                	je     800a29 <memfind+0x1f>
	for (; s < ends; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f3                	jmp    800a1c <memfind+0x12>
			break;
	return (void *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a2b:	f3 0f 1e fb          	endbr32 
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3b:	eb 03                	jmp    800a40 <strtol+0x15>
		s++;
  800a3d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a40:	0f b6 01             	movzbl (%ecx),%eax
  800a43:	3c 20                	cmp    $0x20,%al
  800a45:	74 f6                	je     800a3d <strtol+0x12>
  800a47:	3c 09                	cmp    $0x9,%al
  800a49:	74 f2                	je     800a3d <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a4b:	3c 2b                	cmp    $0x2b,%al
  800a4d:	74 2a                	je     800a79 <strtol+0x4e>
	int neg = 0;
  800a4f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a54:	3c 2d                	cmp    $0x2d,%al
  800a56:	74 2b                	je     800a83 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a58:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a5e:	75 0f                	jne    800a6f <strtol+0x44>
  800a60:	80 39 30             	cmpb   $0x30,(%ecx)
  800a63:	74 28                	je     800a8d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a65:	85 db                	test   %ebx,%ebx
  800a67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6c:	0f 44 d8             	cmove  %eax,%ebx
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a77:	eb 46                	jmp    800abf <strtol+0x94>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a81:	eb d5                	jmp    800a58 <strtol+0x2d>
		s++, neg = 1;
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8b:	eb cb                	jmp    800a58 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a91:	74 0e                	je     800aa1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	75 d8                	jne    800a6f <strtol+0x44>
		s++, base = 8;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a9f:	eb ce                	jmp    800a6f <strtol+0x44>
		s += 2, base = 16;
  800aa1:	83 c1 02             	add    $0x2,%ecx
  800aa4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa9:	eb c4                	jmp    800a6f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aab:	0f be d2             	movsbl %dl,%edx
  800aae:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ab4:	7d 3a                	jge    800af0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800abf:	0f b6 11             	movzbl (%ecx),%edx
  800ac2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac5:	89 f3                	mov    %esi,%ebx
  800ac7:	80 fb 09             	cmp    $0x9,%bl
  800aca:	76 df                	jbe    800aab <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800acc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800acf:	89 f3                	mov    %esi,%ebx
  800ad1:	80 fb 19             	cmp    $0x19,%bl
  800ad4:	77 08                	ja     800ade <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad6:	0f be d2             	movsbl %dl,%edx
  800ad9:	83 ea 57             	sub    $0x57,%edx
  800adc:	eb d3                	jmp    800ab1 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ade:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae1:	89 f3                	mov    %esi,%ebx
  800ae3:	80 fb 19             	cmp    $0x19,%bl
  800ae6:	77 08                	ja     800af0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae8:	0f be d2             	movsbl %dl,%edx
  800aeb:	83 ea 37             	sub    $0x37,%edx
  800aee:	eb c1                	jmp    800ab1 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af4:	74 05                	je     800afb <strtol+0xd0>
		*endptr = (char *) s;
  800af6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	f7 da                	neg    %edx
  800aff:	85 ff                	test   %edi,%edi
  800b01:	0f 45 c2             	cmovne %edx,%eax
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b09:	f3 0f 1e fb          	endbr32 
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	57                   	push   %edi
  800b11:	56                   	push   %esi
  800b12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
  800b18:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1e:	89 c3                	mov    %eax,%ebx
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	89 c6                	mov    %eax,%esi
  800b24:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b2b:	f3 0f 1e fb          	endbr32 
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3f:	89 d1                	mov    %edx,%ecx
  800b41:	89 d3                	mov    %edx,%ebx
  800b43:	89 d7                	mov    %edx,%edi
  800b45:	89 d6                	mov    %edx,%esi
  800b47:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b4e:	f3 0f 1e fb          	endbr32 
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b60:	8b 55 08             	mov    0x8(%ebp),%edx
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	89 cb                	mov    %ecx,%ebx
  800b6a:	89 cf                	mov    %ecx,%edi
  800b6c:	89 ce                	mov    %ecx,%esi
  800b6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b70:	85 c0                	test   %eax,%eax
  800b72:	7f 08                	jg     800b7c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7c:	83 ec 0c             	sub    $0xc,%esp
  800b7f:	50                   	push   %eax
  800b80:	6a 03                	push   $0x3
  800b82:	68 df 22 80 00       	push   $0x8022df
  800b87:	6a 23                	push   $0x23
  800b89:	68 fc 22 80 00       	push   $0x8022fc
  800b8e:	e8 3c 10 00 00       	call   801bcf <_panic>

00800b93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b93:	f3 0f 1e fb          	endbr32 
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba7:	89 d1                	mov    %edx,%ecx
  800ba9:	89 d3                	mov    %edx,%ebx
  800bab:	89 d7                	mov    %edx,%edi
  800bad:	89 d6                	mov    %edx,%esi
  800baf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_yield>:

void
sys_yield(void)
{
  800bb6:	f3 0f 1e fb          	endbr32 
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bca:	89 d1                	mov    %edx,%ecx
  800bcc:	89 d3                	mov    %edx,%ebx
  800bce:	89 d7                	mov    %edx,%edi
  800bd0:	89 d6                	mov    %edx,%esi
  800bd2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd9:	f3 0f 1e fb          	endbr32 
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be6:	be 00 00 00 00       	mov    $0x0,%esi
  800beb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf9:	89 f7                	mov    %esi,%edi
  800bfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	7f 08                	jg     800c09 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	50                   	push   %eax
  800c0d:	6a 04                	push   $0x4
  800c0f:	68 df 22 80 00       	push   $0x8022df
  800c14:	6a 23                	push   $0x23
  800c16:	68 fc 22 80 00       	push   $0x8022fc
  800c1b:	e8 af 0f 00 00       	call   801bcf <_panic>

00800c20 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c20:	f3 0f 1e fb          	endbr32 
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	b8 05 00 00 00       	mov    $0x5,%eax
  800c38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c3e:	8b 75 18             	mov    0x18(%ebp),%esi
  800c41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c43:	85 c0                	test   %eax,%eax
  800c45:	7f 08                	jg     800c4f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	50                   	push   %eax
  800c53:	6a 05                	push   $0x5
  800c55:	68 df 22 80 00       	push   $0x8022df
  800c5a:	6a 23                	push   $0x23
  800c5c:	68 fc 22 80 00       	push   $0x8022fc
  800c61:	e8 69 0f 00 00       	call   801bcf <_panic>

00800c66 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c66:	f3 0f 1e fb          	endbr32 
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c83:	89 df                	mov    %ebx,%edi
  800c85:	89 de                	mov    %ebx,%esi
  800c87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 06                	push   $0x6
  800c9b:	68 df 22 80 00       	push   $0x8022df
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 fc 22 80 00       	push   $0x8022fc
  800ca7:	e8 23 0f 00 00       	call   801bcf <_panic>

00800cac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 08                	push   $0x8
  800ce1:	68 df 22 80 00       	push   $0x8022df
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 fc 22 80 00       	push   $0x8022fc
  800ced:	e8 dd 0e 00 00       	call   801bcf <_panic>

00800cf2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf2:	f3 0f 1e fb          	endbr32 
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	89 de                	mov    %ebx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 09                	push   $0x9
  800d27:	68 df 22 80 00       	push   $0x8022df
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 fc 22 80 00       	push   $0x8022fc
  800d33:	e8 97 0e 00 00       	call   801bcf <_panic>

00800d38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d38:	f3 0f 1e fb          	endbr32 
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	89 de                	mov    %ebx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 0a                	push   $0xa
  800d6d:	68 df 22 80 00       	push   $0x8022df
  800d72:	6a 23                	push   $0x23
  800d74:	68 fc 22 80 00       	push   $0x8022fc
  800d79:	e8 51 0e 00 00       	call   801bcf <_panic>

00800d7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d93:	be 00 00 00 00       	mov    $0x0,%esi
  800d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da5:	f3 0f 1e fb          	endbr32 
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dbf:	89 cb                	mov    %ecx,%ebx
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	89 ce                	mov    %ecx,%esi
  800dc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7f 08                	jg     800dd3 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	50                   	push   %eax
  800dd7:	6a 0d                	push   $0xd
  800dd9:	68 df 22 80 00       	push   $0x8022df
  800dde:	6a 23                	push   $0x23
  800de0:	68 fc 22 80 00       	push   $0x8022fc
  800de5:	e8 e5 0d 00 00       	call   801bcf <_panic>

00800dea <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dea:	f3 0f 1e fb          	endbr32 
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	53                   	push   %ebx
  800df2:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  800df5:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800dfc:	74 0d                	je     800e0b <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800e06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    
		envid_t envid=sys_getenvid();
  800e0b:	e8 83 fd ff ff       	call   800b93 <sys_getenvid>
  800e10:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	6a 07                	push   $0x7
  800e17:	68 00 f0 bf ee       	push   $0xeebff000
  800e1c:	50                   	push   %eax
  800e1d:	e8 b7 fd ff ff       	call   800bd9 <sys_page_alloc>
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	78 29                	js     800e52 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  800e29:	83 ec 08             	sub    $0x8,%esp
  800e2c:	68 66 0e 80 00       	push   $0x800e66
  800e31:	53                   	push   %ebx
  800e32:	e8 01 ff ff ff       	call   800d38 <sys_env_set_pgfault_upcall>
  800e37:	83 c4 10             	add    $0x10,%esp
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	79 c0                	jns    800dfe <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  800e3e:	83 ec 04             	sub    $0x4,%esp
  800e41:	68 38 23 80 00       	push   $0x802338
  800e46:	6a 24                	push   $0x24
  800e48:	68 6f 23 80 00       	push   $0x80236f
  800e4d:	e8 7d 0d 00 00       	call   801bcf <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  800e52:	83 ec 04             	sub    $0x4,%esp
  800e55:	68 0c 23 80 00       	push   $0x80230c
  800e5a:	6a 22                	push   $0x22
  800e5c:	68 6f 23 80 00       	push   $0x80236f
  800e61:	e8 69 0d 00 00       	call   801bcf <_panic>

00800e66 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e66:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e67:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800e6c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e6e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  800e71:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  800e74:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  800e78:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  800e7d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  800e81:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800e83:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800e84:	83 c4 04             	add    $0x4,%esp
	popfl
  800e87:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800e88:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800e89:	c3                   	ret    

00800e8a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e8a:	f3 0f 1e fb          	endbr32 
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	05 00 00 00 30       	add    $0x30000000,%eax
  800e99:	c1 e8 0c             	shr    $0xc,%eax
}
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eb2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eb9:	f3 0f 1e fb          	endbr32 
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	c1 ea 16             	shr    $0x16,%edx
  800eca:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed1:	f6 c2 01             	test   $0x1,%dl
  800ed4:	74 2d                	je     800f03 <fd_alloc+0x4a>
  800ed6:	89 c2                	mov    %eax,%edx
  800ed8:	c1 ea 0c             	shr    $0xc,%edx
  800edb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee2:	f6 c2 01             	test   $0x1,%dl
  800ee5:	74 1c                	je     800f03 <fd_alloc+0x4a>
  800ee7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eec:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ef1:	75 d2                	jne    800ec5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800efc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f01:	eb 0a                	jmp    800f0d <fd_alloc+0x54>
			*fd_store = fd;
  800f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f06:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f0f:	f3 0f 1e fb          	endbr32 
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f19:	83 f8 1f             	cmp    $0x1f,%eax
  800f1c:	77 30                	ja     800f4e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f1e:	c1 e0 0c             	shl    $0xc,%eax
  800f21:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f26:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f2c:	f6 c2 01             	test   $0x1,%dl
  800f2f:	74 24                	je     800f55 <fd_lookup+0x46>
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	c1 ea 0c             	shr    $0xc,%edx
  800f36:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3d:	f6 c2 01             	test   $0x1,%dl
  800f40:	74 1a                	je     800f5c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	89 02                	mov    %eax,(%edx)
	return 0;
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
		return -E_INVAL;
  800f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f53:	eb f7                	jmp    800f4c <fd_lookup+0x3d>
		return -E_INVAL;
  800f55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5a:	eb f0                	jmp    800f4c <fd_lookup+0x3d>
  800f5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f61:	eb e9                	jmp    800f4c <fd_lookup+0x3d>

00800f63 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f63:	f3 0f 1e fb          	endbr32 
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f70:	ba fc 23 80 00       	mov    $0x8023fc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f75:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f7a:	39 08                	cmp    %ecx,(%eax)
  800f7c:	74 33                	je     800fb1 <dev_lookup+0x4e>
  800f7e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f81:	8b 02                	mov    (%edx),%eax
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 f3                	jne    800f7a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f87:	a1 04 40 80 00       	mov    0x804004,%eax
  800f8c:	8b 40 48             	mov    0x48(%eax),%eax
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	51                   	push   %ecx
  800f93:	50                   	push   %eax
  800f94:	68 80 23 80 00       	push   $0x802380
  800f99:	e8 ef f1 ff ff       	call   80018d <cprintf>
	*dev = 0;
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fa7:	83 c4 10             	add    $0x10,%esp
  800faa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    
			*dev = devtab[i];
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbb:	eb f2                	jmp    800faf <dev_lookup+0x4c>

00800fbd <fd_close>:
{
  800fbd:	f3 0f 1e fb          	endbr32 
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	57                   	push   %edi
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
  800fc7:	83 ec 24             	sub    $0x24,%esp
  800fca:	8b 75 08             	mov    0x8(%ebp),%esi
  800fcd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fd3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fda:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fdd:	50                   	push   %eax
  800fde:	e8 2c ff ff ff       	call   800f0f <fd_lookup>
  800fe3:	89 c3                	mov    %eax,%ebx
  800fe5:	83 c4 10             	add    $0x10,%esp
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	78 05                	js     800ff1 <fd_close+0x34>
	    || fd != fd2)
  800fec:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fef:	74 16                	je     801007 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800ff1:	89 f8                	mov    %edi,%eax
  800ff3:	84 c0                	test   %al,%al
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	0f 44 d8             	cmove  %eax,%ebx
}
  800ffd:	89 d8                	mov    %ebx,%eax
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80100d:	50                   	push   %eax
  80100e:	ff 36                	pushl  (%esi)
  801010:	e8 4e ff ff ff       	call   800f63 <dev_lookup>
  801015:	89 c3                	mov    %eax,%ebx
  801017:	83 c4 10             	add    $0x10,%esp
  80101a:	85 c0                	test   %eax,%eax
  80101c:	78 1a                	js     801038 <fd_close+0x7b>
		if (dev->dev_close)
  80101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801021:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801029:	85 c0                	test   %eax,%eax
  80102b:	74 0b                	je     801038 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80102d:	83 ec 0c             	sub    $0xc,%esp
  801030:	56                   	push   %esi
  801031:	ff d0                	call   *%eax
  801033:	89 c3                	mov    %eax,%ebx
  801035:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801038:	83 ec 08             	sub    $0x8,%esp
  80103b:	56                   	push   %esi
  80103c:	6a 00                	push   $0x0
  80103e:	e8 23 fc ff ff       	call   800c66 <sys_page_unmap>
	return r;
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	eb b5                	jmp    800ffd <fd_close+0x40>

00801048 <close>:

int
close(int fdnum)
{
  801048:	f3 0f 1e fb          	endbr32 
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801052:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801055:	50                   	push   %eax
  801056:	ff 75 08             	pushl  0x8(%ebp)
  801059:	e8 b1 fe ff ff       	call   800f0f <fd_lookup>
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	79 02                	jns    801067 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    
		return fd_close(fd, 1);
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	6a 01                	push   $0x1
  80106c:	ff 75 f4             	pushl  -0xc(%ebp)
  80106f:	e8 49 ff ff ff       	call   800fbd <fd_close>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	eb ec                	jmp    801065 <close+0x1d>

00801079 <close_all>:

void
close_all(void)
{
  801079:	f3 0f 1e fb          	endbr32 
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	53                   	push   %ebx
  801081:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801084:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801089:	83 ec 0c             	sub    $0xc,%esp
  80108c:	53                   	push   %ebx
  80108d:	e8 b6 ff ff ff       	call   801048 <close>
	for (i = 0; i < MAXFD; i++)
  801092:	83 c3 01             	add    $0x1,%ebx
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	83 fb 20             	cmp    $0x20,%ebx
  80109b:	75 ec                	jne    801089 <close_all+0x10>
}
  80109d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010a2:	f3 0f 1e fb          	endbr32 
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	ff 75 08             	pushl  0x8(%ebp)
  8010b6:	e8 54 fe ff ff       	call   800f0f <fd_lookup>
  8010bb:	89 c3                	mov    %eax,%ebx
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	0f 88 81 00 00 00    	js     801149 <dup+0xa7>
		return r;
	close(newfdnum);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ce:	e8 75 ff ff ff       	call   801048 <close>

	newfd = INDEX2FD(newfdnum);
  8010d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010d6:	c1 e6 0c             	shl    $0xc,%esi
  8010d9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010df:	83 c4 04             	add    $0x4,%esp
  8010e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e5:	e8 b4 fd ff ff       	call   800e9e <fd2data>
  8010ea:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010ec:	89 34 24             	mov    %esi,(%esp)
  8010ef:	e8 aa fd ff ff       	call   800e9e <fd2data>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010f9:	89 d8                	mov    %ebx,%eax
  8010fb:	c1 e8 16             	shr    $0x16,%eax
  8010fe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801105:	a8 01                	test   $0x1,%al
  801107:	74 11                	je     80111a <dup+0x78>
  801109:	89 d8                	mov    %ebx,%eax
  80110b:	c1 e8 0c             	shr    $0xc,%eax
  80110e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801115:	f6 c2 01             	test   $0x1,%dl
  801118:	75 39                	jne    801153 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80111a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80111d:	89 d0                	mov    %edx,%eax
  80111f:	c1 e8 0c             	shr    $0xc,%eax
  801122:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801129:	83 ec 0c             	sub    $0xc,%esp
  80112c:	25 07 0e 00 00       	and    $0xe07,%eax
  801131:	50                   	push   %eax
  801132:	56                   	push   %esi
  801133:	6a 00                	push   $0x0
  801135:	52                   	push   %edx
  801136:	6a 00                	push   $0x0
  801138:	e8 e3 fa ff ff       	call   800c20 <sys_page_map>
  80113d:	89 c3                	mov    %eax,%ebx
  80113f:	83 c4 20             	add    $0x20,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	78 31                	js     801177 <dup+0xd5>
		goto err;

	return newfdnum;
  801146:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801149:	89 d8                	mov    %ebx,%eax
  80114b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801153:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	25 07 0e 00 00       	and    $0xe07,%eax
  801162:	50                   	push   %eax
  801163:	57                   	push   %edi
  801164:	6a 00                	push   $0x0
  801166:	53                   	push   %ebx
  801167:	6a 00                	push   $0x0
  801169:	e8 b2 fa ff ff       	call   800c20 <sys_page_map>
  80116e:	89 c3                	mov    %eax,%ebx
  801170:	83 c4 20             	add    $0x20,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	79 a3                	jns    80111a <dup+0x78>
	sys_page_unmap(0, newfd);
  801177:	83 ec 08             	sub    $0x8,%esp
  80117a:	56                   	push   %esi
  80117b:	6a 00                	push   $0x0
  80117d:	e8 e4 fa ff ff       	call   800c66 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801182:	83 c4 08             	add    $0x8,%esp
  801185:	57                   	push   %edi
  801186:	6a 00                	push   $0x0
  801188:	e8 d9 fa ff ff       	call   800c66 <sys_page_unmap>
	return r;
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	eb b7                	jmp    801149 <dup+0xa7>

00801192 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801192:	f3 0f 1e fb          	endbr32 
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	53                   	push   %ebx
  80119a:	83 ec 1c             	sub    $0x1c,%esp
  80119d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	53                   	push   %ebx
  8011a5:	e8 65 fd ff ff       	call   800f0f <fd_lookup>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	78 3f                	js     8011f0 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b7:	50                   	push   %eax
  8011b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bb:	ff 30                	pushl  (%eax)
  8011bd:	e8 a1 fd ff ff       	call   800f63 <dev_lookup>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 27                	js     8011f0 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cc:	8b 42 08             	mov    0x8(%edx),%eax
  8011cf:	83 e0 03             	and    $0x3,%eax
  8011d2:	83 f8 01             	cmp    $0x1,%eax
  8011d5:	74 1e                	je     8011f5 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	8b 40 08             	mov    0x8(%eax),%eax
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	74 35                	je     801216 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011e1:	83 ec 04             	sub    $0x4,%esp
  8011e4:	ff 75 10             	pushl  0x10(%ebp)
  8011e7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ea:	52                   	push   %edx
  8011eb:	ff d0                	call   *%eax
  8011ed:	83 c4 10             	add    $0x10,%esp
}
  8011f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8011fa:	8b 40 48             	mov    0x48(%eax),%eax
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	53                   	push   %ebx
  801201:	50                   	push   %eax
  801202:	68 c1 23 80 00       	push   $0x8023c1
  801207:	e8 81 ef ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801214:	eb da                	jmp    8011f0 <read+0x5e>
		return -E_NOT_SUPP;
  801216:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80121b:	eb d3                	jmp    8011f0 <read+0x5e>

0080121d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80121d:	f3 0f 1e fb          	endbr32 
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	57                   	push   %edi
  801225:	56                   	push   %esi
  801226:	53                   	push   %ebx
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80122d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801230:	bb 00 00 00 00       	mov    $0x0,%ebx
  801235:	eb 02                	jmp    801239 <readn+0x1c>
  801237:	01 c3                	add    %eax,%ebx
  801239:	39 f3                	cmp    %esi,%ebx
  80123b:	73 21                	jae    80125e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	89 f0                	mov    %esi,%eax
  801242:	29 d8                	sub    %ebx,%eax
  801244:	50                   	push   %eax
  801245:	89 d8                	mov    %ebx,%eax
  801247:	03 45 0c             	add    0xc(%ebp),%eax
  80124a:	50                   	push   %eax
  80124b:	57                   	push   %edi
  80124c:	e8 41 ff ff ff       	call   801192 <read>
		if (m < 0)
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	78 04                	js     80125c <readn+0x3f>
			return m;
		if (m == 0)
  801258:	75 dd                	jne    801237 <readn+0x1a>
  80125a:	eb 02                	jmp    80125e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80125c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80125e:	89 d8                	mov    %ebx,%eax
  801260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801268:	f3 0f 1e fb          	endbr32 
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	53                   	push   %ebx
  801270:	83 ec 1c             	sub    $0x1c,%esp
  801273:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801276:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801279:	50                   	push   %eax
  80127a:	53                   	push   %ebx
  80127b:	e8 8f fc ff ff       	call   800f0f <fd_lookup>
  801280:	83 c4 10             	add    $0x10,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 3a                	js     8012c1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128d:	50                   	push   %eax
  80128e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801291:	ff 30                	pushl  (%eax)
  801293:	e8 cb fc ff ff       	call   800f63 <dev_lookup>
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	78 22                	js     8012c1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80129f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a6:	74 1e                	je     8012c6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8012ae:	85 d2                	test   %edx,%edx
  8012b0:	74 35                	je     8012e7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	ff 75 10             	pushl  0x10(%ebp)
  8012b8:	ff 75 0c             	pushl  0xc(%ebp)
  8012bb:	50                   	push   %eax
  8012bc:	ff d2                	call   *%edx
  8012be:	83 c4 10             	add    $0x10,%esp
}
  8012c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	8b 40 48             	mov    0x48(%eax),%eax
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	53                   	push   %ebx
  8012d2:	50                   	push   %eax
  8012d3:	68 dd 23 80 00       	push   $0x8023dd
  8012d8:	e8 b0 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e5:	eb da                	jmp    8012c1 <write+0x59>
		return -E_NOT_SUPP;
  8012e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ec:	eb d3                	jmp    8012c1 <write+0x59>

008012ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8012ee:	f3 0f 1e fb          	endbr32 
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fb:	50                   	push   %eax
  8012fc:	ff 75 08             	pushl  0x8(%ebp)
  8012ff:	e8 0b fc ff ff       	call   800f0f <fd_lookup>
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	85 c0                	test   %eax,%eax
  801309:	78 0e                	js     801319 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80130b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801311:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131b:	f3 0f 1e fb          	endbr32 
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	53                   	push   %ebx
  801323:	83 ec 1c             	sub    $0x1c,%esp
  801326:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801329:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	53                   	push   %ebx
  80132e:	e8 dc fb ff ff       	call   800f0f <fd_lookup>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 37                	js     801371 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	ff 30                	pushl  (%eax)
  801346:	e8 18 fc ff ff       	call   800f63 <dev_lookup>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 1f                	js     801371 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801355:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801359:	74 1b                	je     801376 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80135b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135e:	8b 52 18             	mov    0x18(%edx),%edx
  801361:	85 d2                	test   %edx,%edx
  801363:	74 32                	je     801397 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	50                   	push   %eax
  80136c:	ff d2                	call   *%edx
  80136e:	83 c4 10             	add    $0x10,%esp
}
  801371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801374:	c9                   	leave  
  801375:	c3                   	ret    
			thisenv->env_id, fdnum);
  801376:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80137b:	8b 40 48             	mov    0x48(%eax),%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	53                   	push   %ebx
  801382:	50                   	push   %eax
  801383:	68 a0 23 80 00       	push   $0x8023a0
  801388:	e8 00 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801395:	eb da                	jmp    801371 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801397:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139c:	eb d3                	jmp    801371 <ftruncate+0x56>

0080139e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80139e:	f3 0f 1e fb          	endbr32 
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	53                   	push   %ebx
  8013a6:	83 ec 1c             	sub    $0x1c,%esp
  8013a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013af:	50                   	push   %eax
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 57 fb ff ff       	call   800f0f <fd_lookup>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	78 4b                	js     80140a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c9:	ff 30                	pushl  (%eax)
  8013cb:	e8 93 fb ff ff       	call   800f63 <dev_lookup>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 33                	js     80140a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013de:	74 2f                	je     80140f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013e0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013e3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013ea:	00 00 00 
	stat->st_isdir = 0;
  8013ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013f4:	00 00 00 
	stat->st_dev = dev;
  8013f7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	53                   	push   %ebx
  801401:	ff 75 f0             	pushl  -0x10(%ebp)
  801404:	ff 50 14             	call   *0x14(%eax)
  801407:	83 c4 10             	add    $0x10,%esp
}
  80140a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    
		return -E_NOT_SUPP;
  80140f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801414:	eb f4                	jmp    80140a <fstat+0x6c>

00801416 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801416:	f3 0f 1e fb          	endbr32 
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	6a 00                	push   $0x0
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 fb 01 00 00       	call   801627 <open>
  80142c:	89 c3                	mov    %eax,%ebx
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 1b                	js     801450 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801435:	83 ec 08             	sub    $0x8,%esp
  801438:	ff 75 0c             	pushl  0xc(%ebp)
  80143b:	50                   	push   %eax
  80143c:	e8 5d ff ff ff       	call   80139e <fstat>
  801441:	89 c6                	mov    %eax,%esi
	close(fd);
  801443:	89 1c 24             	mov    %ebx,(%esp)
  801446:	e8 fd fb ff ff       	call   801048 <close>
	return r;
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	89 f3                	mov    %esi,%ebx
}
  801450:	89 d8                	mov    %ebx,%eax
  801452:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	89 c6                	mov    %eax,%esi
  801460:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801462:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801469:	74 27                	je     801492 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80146b:	6a 07                	push   $0x7
  80146d:	68 00 50 80 00       	push   $0x805000
  801472:	56                   	push   %esi
  801473:	ff 35 00 40 80 00    	pushl  0x804000
  801479:	e8 08 08 00 00       	call   801c86 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80147e:	83 c4 0c             	add    $0xc,%esp
  801481:	6a 00                	push   $0x0
  801483:	53                   	push   %ebx
  801484:	6a 00                	push   $0x0
  801486:	e8 8e 07 00 00       	call   801c19 <ipc_recv>
}
  80148b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80148e:	5b                   	pop    %ebx
  80148f:	5e                   	pop    %esi
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801492:	83 ec 0c             	sub    $0xc,%esp
  801495:	6a 01                	push   $0x1
  801497:	e8 44 08 00 00       	call   801ce0 <ipc_find_env>
  80149c:	a3 00 40 80 00       	mov    %eax,0x804000
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	eb c5                	jmp    80146b <fsipc+0x12>

008014a6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014a6:	f3 0f 1e fb          	endbr32 
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014be:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c8:	b8 02 00 00 00       	mov    $0x2,%eax
  8014cd:	e8 87 ff ff ff       	call   801459 <fsipc>
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <devfile_flush>:
{
  8014d4:	f3 0f 1e fb          	endbr32 
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8014f3:	e8 61 ff ff ff       	call   801459 <fsipc>
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <devfile_stat>:
{
  8014fa:	f3 0f 1e fb          	endbr32 
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	53                   	push   %ebx
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8b 40 0c             	mov    0xc(%eax),%eax
  80150e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	b8 05 00 00 00       	mov    $0x5,%eax
  80151d:	e8 37 ff ff ff       	call   801459 <fsipc>
  801522:	85 c0                	test   %eax,%eax
  801524:	78 2c                	js     801552 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	68 00 50 80 00       	push   $0x805000
  80152e:	53                   	push   %ebx
  80152f:	e8 63 f2 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801534:	a1 80 50 80 00       	mov    0x805080,%eax
  801539:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80153f:	a1 84 50 80 00       	mov    0x805084,%eax
  801544:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <devfile_write>:
{
  801557:	f3 0f 1e fb          	endbr32 
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 0c             	sub    $0xc,%esp
  801561:	8b 45 10             	mov    0x10(%ebp),%eax
  801564:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801569:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80156e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801571:	8b 55 08             	mov    0x8(%ebp),%edx
  801574:	8b 52 0c             	mov    0xc(%edx),%edx
  801577:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80157d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801582:	50                   	push   %eax
  801583:	ff 75 0c             	pushl  0xc(%ebp)
  801586:	68 08 50 80 00       	push   $0x805008
  80158b:	e8 bd f3 ff ff       	call   80094d <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801590:	ba 00 00 00 00       	mov    $0x0,%edx
  801595:	b8 04 00 00 00       	mov    $0x4,%eax
  80159a:	e8 ba fe ff ff       	call   801459 <fsipc>
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <devfile_read>:
{
  8015a1:	f3 0f 1e fb          	endbr32 
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015b8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015be:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c3:	b8 03 00 00 00       	mov    $0x3,%eax
  8015c8:	e8 8c fe ff ff       	call   801459 <fsipc>
  8015cd:	89 c3                	mov    %eax,%ebx
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 1f                	js     8015f2 <devfile_read+0x51>
	assert(r <= n);
  8015d3:	39 f0                	cmp    %esi,%eax
  8015d5:	77 24                	ja     8015fb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015d7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015dc:	7f 33                	jg     801611 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	50                   	push   %eax
  8015e2:	68 00 50 80 00       	push   $0x805000
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	e8 5e f3 ff ff       	call   80094d <memmove>
	return r;
  8015ef:	83 c4 10             	add    $0x10,%esp
}
  8015f2:	89 d8                	mov    %ebx,%eax
  8015f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f7:	5b                   	pop    %ebx
  8015f8:	5e                   	pop    %esi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    
	assert(r <= n);
  8015fb:	68 0c 24 80 00       	push   $0x80240c
  801600:	68 13 24 80 00       	push   $0x802413
  801605:	6a 7d                	push   $0x7d
  801607:	68 28 24 80 00       	push   $0x802428
  80160c:	e8 be 05 00 00       	call   801bcf <_panic>
	assert(r <= PGSIZE);
  801611:	68 33 24 80 00       	push   $0x802433
  801616:	68 13 24 80 00       	push   $0x802413
  80161b:	6a 7e                	push   $0x7e
  80161d:	68 28 24 80 00       	push   $0x802428
  801622:	e8 a8 05 00 00       	call   801bcf <_panic>

00801627 <open>:
{
  801627:	f3 0f 1e fb          	endbr32 
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	56                   	push   %esi
  80162f:	53                   	push   %ebx
  801630:	83 ec 1c             	sub    $0x1c,%esp
  801633:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801636:	56                   	push   %esi
  801637:	e8 18 f1 ff ff       	call   800754 <strlen>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801644:	7f 6c                	jg     8016b2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164c:	50                   	push   %eax
  80164d:	e8 67 f8 ff ff       	call   800eb9 <fd_alloc>
  801652:	89 c3                	mov    %eax,%ebx
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 3c                	js     801697 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	56                   	push   %esi
  80165f:	68 00 50 80 00       	push   $0x805000
  801664:	e8 2e f1 ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801674:	b8 01 00 00 00       	mov    $0x1,%eax
  801679:	e8 db fd ff ff       	call   801459 <fsipc>
  80167e:	89 c3                	mov    %eax,%ebx
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	85 c0                	test   %eax,%eax
  801685:	78 19                	js     8016a0 <open+0x79>
	return fd2num(fd);
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	ff 75 f4             	pushl  -0xc(%ebp)
  80168d:	e8 f8 f7 ff ff       	call   800e8a <fd2num>
  801692:	89 c3                	mov    %eax,%ebx
  801694:	83 c4 10             	add    $0x10,%esp
}
  801697:	89 d8                	mov    %ebx,%eax
  801699:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169c:	5b                   	pop    %ebx
  80169d:	5e                   	pop    %esi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    
		fd_close(fd, 0);
  8016a0:	83 ec 08             	sub    $0x8,%esp
  8016a3:	6a 00                	push   $0x0
  8016a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a8:	e8 10 f9 ff ff       	call   800fbd <fd_close>
		return r;
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	eb e5                	jmp    801697 <open+0x70>
		return -E_BAD_PATH;
  8016b2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016b7:	eb de                	jmp    801697 <open+0x70>

008016b9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016b9:	f3 0f 1e fb          	endbr32 
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8016cd:	e8 87 fd ff ff       	call   801459 <fsipc>
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016d4:	f3 0f 1e fb          	endbr32 
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016e0:	83 ec 0c             	sub    $0xc,%esp
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	e8 b3 f7 ff ff       	call   800e9e <fd2data>
  8016eb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016ed:	83 c4 08             	add    $0x8,%esp
  8016f0:	68 3f 24 80 00       	push   $0x80243f
  8016f5:	53                   	push   %ebx
  8016f6:	e8 9c f0 ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016fb:	8b 46 04             	mov    0x4(%esi),%eax
  8016fe:	2b 06                	sub    (%esi),%eax
  801700:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801706:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80170d:	00 00 00 
	stat->st_dev = &devpipe;
  801710:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801717:	30 80 00 
	return 0;
}
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
  80171f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801722:	5b                   	pop    %ebx
  801723:	5e                   	pop    %esi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801726:	f3 0f 1e fb          	endbr32 
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 0c             	sub    $0xc,%esp
  801731:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801734:	53                   	push   %ebx
  801735:	6a 00                	push   $0x0
  801737:	e8 2a f5 ff ff       	call   800c66 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80173c:	89 1c 24             	mov    %ebx,(%esp)
  80173f:	e8 5a f7 ff ff       	call   800e9e <fd2data>
  801744:	83 c4 08             	add    $0x8,%esp
  801747:	50                   	push   %eax
  801748:	6a 00                	push   $0x0
  80174a:	e8 17 f5 ff ff       	call   800c66 <sys_page_unmap>
}
  80174f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <_pipeisclosed>:
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	57                   	push   %edi
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
  80175a:	83 ec 1c             	sub    $0x1c,%esp
  80175d:	89 c7                	mov    %eax,%edi
  80175f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801761:	a1 04 40 80 00       	mov    0x804004,%eax
  801766:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801769:	83 ec 0c             	sub    $0xc,%esp
  80176c:	57                   	push   %edi
  80176d:	e8 ab 05 00 00       	call   801d1d <pageref>
  801772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801775:	89 34 24             	mov    %esi,(%esp)
  801778:	e8 a0 05 00 00       	call   801d1d <pageref>
		nn = thisenv->env_runs;
  80177d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801783:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	39 cb                	cmp    %ecx,%ebx
  80178b:	74 1b                	je     8017a8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80178d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801790:	75 cf                	jne    801761 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801792:	8b 42 58             	mov    0x58(%edx),%eax
  801795:	6a 01                	push   $0x1
  801797:	50                   	push   %eax
  801798:	53                   	push   %ebx
  801799:	68 46 24 80 00       	push   $0x802446
  80179e:	e8 ea e9 ff ff       	call   80018d <cprintf>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	eb b9                	jmp    801761 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017ab:	0f 94 c0             	sete   %al
  8017ae:	0f b6 c0             	movzbl %al,%eax
}
  8017b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b4:	5b                   	pop    %ebx
  8017b5:	5e                   	pop    %esi
  8017b6:	5f                   	pop    %edi
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <devpipe_write>:
{
  8017b9:	f3 0f 1e fb          	endbr32 
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	57                   	push   %edi
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
  8017c3:	83 ec 28             	sub    $0x28,%esp
  8017c6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017c9:	56                   	push   %esi
  8017ca:	e8 cf f6 ff ff       	call   800e9e <fd2data>
  8017cf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017dc:	74 4f                	je     80182d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017de:	8b 43 04             	mov    0x4(%ebx),%eax
  8017e1:	8b 0b                	mov    (%ebx),%ecx
  8017e3:	8d 51 20             	lea    0x20(%ecx),%edx
  8017e6:	39 d0                	cmp    %edx,%eax
  8017e8:	72 14                	jb     8017fe <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8017ea:	89 da                	mov    %ebx,%edx
  8017ec:	89 f0                	mov    %esi,%eax
  8017ee:	e8 61 ff ff ff       	call   801754 <_pipeisclosed>
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	75 3b                	jne    801832 <devpipe_write+0x79>
			sys_yield();
  8017f7:	e8 ba f3 ff ff       	call   800bb6 <sys_yield>
  8017fc:	eb e0                	jmp    8017de <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801801:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801805:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801808:	89 c2                	mov    %eax,%edx
  80180a:	c1 fa 1f             	sar    $0x1f,%edx
  80180d:	89 d1                	mov    %edx,%ecx
  80180f:	c1 e9 1b             	shr    $0x1b,%ecx
  801812:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801815:	83 e2 1f             	and    $0x1f,%edx
  801818:	29 ca                	sub    %ecx,%edx
  80181a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80181e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801822:	83 c0 01             	add    $0x1,%eax
  801825:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801828:	83 c7 01             	add    $0x1,%edi
  80182b:	eb ac                	jmp    8017d9 <devpipe_write+0x20>
	return i;
  80182d:	8b 45 10             	mov    0x10(%ebp),%eax
  801830:	eb 05                	jmp    801837 <devpipe_write+0x7e>
				return 0;
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801837:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183a:	5b                   	pop    %ebx
  80183b:	5e                   	pop    %esi
  80183c:	5f                   	pop    %edi
  80183d:	5d                   	pop    %ebp
  80183e:	c3                   	ret    

0080183f <devpipe_read>:
{
  80183f:	f3 0f 1e fb          	endbr32 
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	57                   	push   %edi
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
  801849:	83 ec 18             	sub    $0x18,%esp
  80184c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80184f:	57                   	push   %edi
  801850:	e8 49 f6 ff ff       	call   800e9e <fd2data>
  801855:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	be 00 00 00 00       	mov    $0x0,%esi
  80185f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801862:	75 14                	jne    801878 <devpipe_read+0x39>
	return i;
  801864:	8b 45 10             	mov    0x10(%ebp),%eax
  801867:	eb 02                	jmp    80186b <devpipe_read+0x2c>
				return i;
  801869:	89 f0                	mov    %esi,%eax
}
  80186b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5f                   	pop    %edi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    
			sys_yield();
  801873:	e8 3e f3 ff ff       	call   800bb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801878:	8b 03                	mov    (%ebx),%eax
  80187a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80187d:	75 18                	jne    801897 <devpipe_read+0x58>
			if (i > 0)
  80187f:	85 f6                	test   %esi,%esi
  801881:	75 e6                	jne    801869 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801883:	89 da                	mov    %ebx,%edx
  801885:	89 f8                	mov    %edi,%eax
  801887:	e8 c8 fe ff ff       	call   801754 <_pipeisclosed>
  80188c:	85 c0                	test   %eax,%eax
  80188e:	74 e3                	je     801873 <devpipe_read+0x34>
				return 0;
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
  801895:	eb d4                	jmp    80186b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801897:	99                   	cltd   
  801898:	c1 ea 1b             	shr    $0x1b,%edx
  80189b:	01 d0                	add    %edx,%eax
  80189d:	83 e0 1f             	and    $0x1f,%eax
  8018a0:	29 d0                	sub    %edx,%eax
  8018a2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018aa:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018ad:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018b0:	83 c6 01             	add    $0x1,%esi
  8018b3:	eb aa                	jmp    80185f <devpipe_read+0x20>

008018b5 <pipe>:
{
  8018b5:	f3 0f 1e fb          	endbr32 
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c4:	50                   	push   %eax
  8018c5:	e8 ef f5 ff ff       	call   800eb9 <fd_alloc>
  8018ca:	89 c3                	mov    %eax,%ebx
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	0f 88 23 01 00 00    	js     8019fa <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	68 07 04 00 00       	push   $0x407
  8018df:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e2:	6a 00                	push   $0x0
  8018e4:	e8 f0 f2 ff ff       	call   800bd9 <sys_page_alloc>
  8018e9:	89 c3                	mov    %eax,%ebx
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	0f 88 04 01 00 00    	js     8019fa <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fc:	50                   	push   %eax
  8018fd:	e8 b7 f5 ff ff       	call   800eb9 <fd_alloc>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	0f 88 db 00 00 00    	js     8019ea <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80190f:	83 ec 04             	sub    $0x4,%esp
  801912:	68 07 04 00 00       	push   $0x407
  801917:	ff 75 f0             	pushl  -0x10(%ebp)
  80191a:	6a 00                	push   $0x0
  80191c:	e8 b8 f2 ff ff       	call   800bd9 <sys_page_alloc>
  801921:	89 c3                	mov    %eax,%ebx
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	0f 88 bc 00 00 00    	js     8019ea <pipe+0x135>
	va = fd2data(fd0);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	ff 75 f4             	pushl  -0xc(%ebp)
  801934:	e8 65 f5 ff ff       	call   800e9e <fd2data>
  801939:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80193b:	83 c4 0c             	add    $0xc,%esp
  80193e:	68 07 04 00 00       	push   $0x407
  801943:	50                   	push   %eax
  801944:	6a 00                	push   $0x0
  801946:	e8 8e f2 ff ff       	call   800bd9 <sys_page_alloc>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	0f 88 82 00 00 00    	js     8019da <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801958:	83 ec 0c             	sub    $0xc,%esp
  80195b:	ff 75 f0             	pushl  -0x10(%ebp)
  80195e:	e8 3b f5 ff ff       	call   800e9e <fd2data>
  801963:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80196a:	50                   	push   %eax
  80196b:	6a 00                	push   $0x0
  80196d:	56                   	push   %esi
  80196e:	6a 00                	push   $0x0
  801970:	e8 ab f2 ff ff       	call   800c20 <sys_page_map>
  801975:	89 c3                	mov    %eax,%ebx
  801977:	83 c4 20             	add    $0x20,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 4e                	js     8019cc <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80197e:	a1 20 30 80 00       	mov    0x803020,%eax
  801983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801986:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801992:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801995:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a7:	e8 de f4 ff ff       	call   800e8a <fd2num>
  8019ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019af:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019b1:	83 c4 04             	add    $0x4,%esp
  8019b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b7:	e8 ce f4 ff ff       	call   800e8a <fd2num>
  8019bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ca:	eb 2e                	jmp    8019fa <pipe+0x145>
	sys_page_unmap(0, va);
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	56                   	push   %esi
  8019d0:	6a 00                	push   $0x0
  8019d2:	e8 8f f2 ff ff       	call   800c66 <sys_page_unmap>
  8019d7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e0:	6a 00                	push   $0x0
  8019e2:	e8 7f f2 ff ff       	call   800c66 <sys_page_unmap>
  8019e7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f0:	6a 00                	push   $0x0
  8019f2:	e8 6f f2 ff ff       	call   800c66 <sys_page_unmap>
  8019f7:	83 c4 10             	add    $0x10,%esp
}
  8019fa:	89 d8                	mov    %ebx,%eax
  8019fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <pipeisclosed>:
{
  801a03:	f3 0f 1e fb          	endbr32 
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a10:	50                   	push   %eax
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 f6 f4 ff ff       	call   800f0f <fd_lookup>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 18                	js     801a38 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	ff 75 f4             	pushl  -0xc(%ebp)
  801a26:	e8 73 f4 ff ff       	call   800e9e <fd2data>
  801a2b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	e8 1f fd ff ff       	call   801754 <_pipeisclosed>
  801a35:	83 c4 10             	add    $0x10,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a3a:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a43:	c3                   	ret    

00801a44 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a44:	f3 0f 1e fb          	endbr32 
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801a4e:	68 5e 24 80 00       	push   $0x80245e
  801a53:	ff 75 0c             	pushl  0xc(%ebp)
  801a56:	e8 3c ed ff ff       	call   800797 <strcpy>
	return 0;
}
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <devcons_write>:
{
  801a62:	f3 0f 1e fb          	endbr32 
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a72:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a77:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a7d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a80:	73 31                	jae    801ab3 <devcons_write+0x51>
		m = n - tot;
  801a82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a85:	29 f3                	sub    %esi,%ebx
  801a87:	83 fb 7f             	cmp    $0x7f,%ebx
  801a8a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a8f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	53                   	push   %ebx
  801a96:	89 f0                	mov    %esi,%eax
  801a98:	03 45 0c             	add    0xc(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	57                   	push   %edi
  801a9d:	e8 ab ee ff ff       	call   80094d <memmove>
		sys_cputs(buf, m);
  801aa2:	83 c4 08             	add    $0x8,%esp
  801aa5:	53                   	push   %ebx
  801aa6:	57                   	push   %edi
  801aa7:	e8 5d f0 ff ff       	call   800b09 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801aac:	01 de                	add    %ebx,%esi
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	eb ca                	jmp    801a7d <devcons_write+0x1b>
}
  801ab3:	89 f0                	mov    %esi,%eax
  801ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5f                   	pop    %edi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    

00801abd <devcons_read>:
{
  801abd:	f3 0f 1e fb          	endbr32 
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801acc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad0:	74 21                	je     801af3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ad2:	e8 54 f0 ff ff       	call   800b2b <sys_cgetc>
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	75 07                	jne    801ae2 <devcons_read+0x25>
		sys_yield();
  801adb:	e8 d6 f0 ff ff       	call   800bb6 <sys_yield>
  801ae0:	eb f0                	jmp    801ad2 <devcons_read+0x15>
	if (c < 0)
  801ae2:	78 0f                	js     801af3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ae4:	83 f8 04             	cmp    $0x4,%eax
  801ae7:	74 0c                	je     801af5 <devcons_read+0x38>
	*(char*)vbuf = c;
  801ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aec:	88 02                	mov    %al,(%edx)
	return 1;
  801aee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    
		return 0;
  801af5:	b8 00 00 00 00       	mov    $0x0,%eax
  801afa:	eb f7                	jmp    801af3 <devcons_read+0x36>

00801afc <cputchar>:
{
  801afc:	f3 0f 1e fb          	endbr32 
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b0c:	6a 01                	push   $0x1
  801b0e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	e8 f2 ef ff ff       	call   800b09 <sys_cputs>
}
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <getchar>:
{
  801b1c:	f3 0f 1e fb          	endbr32 
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b26:	6a 01                	push   $0x1
  801b28:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b2b:	50                   	push   %eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	e8 5f f6 ff ff       	call   801192 <read>
	if (r < 0)
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 06                	js     801b40 <getchar+0x24>
	if (r < 1)
  801b3a:	74 06                	je     801b42 <getchar+0x26>
	return c;
  801b3c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    
		return -E_EOF;
  801b42:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b47:	eb f7                	jmp    801b40 <getchar+0x24>

00801b49 <iscons>:
{
  801b49:	f3 0f 1e fb          	endbr32 
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b56:	50                   	push   %eax
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	e8 b0 f3 ff ff       	call   800f0f <fd_lookup>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 11                	js     801b77 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b69:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b6f:	39 10                	cmp    %edx,(%eax)
  801b71:	0f 94 c0             	sete   %al
  801b74:	0f b6 c0             	movzbl %al,%eax
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <opencons>:
{
  801b79:	f3 0f 1e fb          	endbr32 
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b86:	50                   	push   %eax
  801b87:	e8 2d f3 ff ff       	call   800eb9 <fd_alloc>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 3a                	js     801bcd <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	68 07 04 00 00       	push   $0x407
  801b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b9e:	6a 00                	push   $0x0
  801ba0:	e8 34 f0 ff ff       	call   800bd9 <sys_page_alloc>
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 21                	js     801bcd <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bb5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	50                   	push   %eax
  801bc5:	e8 c0 f2 ff ff       	call   800e8a <fd2num>
  801bca:	83 c4 10             	add    $0x10,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bcf:	f3 0f 1e fb          	endbr32 
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801bd8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801bdb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801be1:	e8 ad ef ff ff       	call   800b93 <sys_getenvid>
  801be6:	83 ec 0c             	sub    $0xc,%esp
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	56                   	push   %esi
  801bf0:	50                   	push   %eax
  801bf1:	68 6c 24 80 00       	push   $0x80246c
  801bf6:	e8 92 e5 ff ff       	call   80018d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801bfb:	83 c4 18             	add    $0x18,%esp
  801bfe:	53                   	push   %ebx
  801bff:	ff 75 10             	pushl  0x10(%ebp)
  801c02:	e8 31 e5 ff ff       	call   800138 <vcprintf>
	cprintf("\n");
  801c07:	c7 04 24 57 24 80 00 	movl   $0x802457,(%esp)
  801c0e:	e8 7a e5 ff ff       	call   80018d <cprintf>
  801c13:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c16:	cc                   	int3   
  801c17:	eb fd                	jmp    801c16 <_panic+0x47>

00801c19 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c19:	f3 0f 1e fb          	endbr32 
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	56                   	push   %esi
  801c21:	53                   	push   %ebx
  801c22:	8b 75 08             	mov    0x8(%ebp),%esi
  801c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c32:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	50                   	push   %eax
  801c39:	e8 67 f1 ff ff       	call   800da5 <sys_ipc_recv>
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 2b                	js     801c70 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801c45:	85 f6                	test   %esi,%esi
  801c47:	74 0a                	je     801c53 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801c49:	a1 04 40 80 00       	mov    0x804004,%eax
  801c4e:	8b 40 74             	mov    0x74(%eax),%eax
  801c51:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801c53:	85 db                	test   %ebx,%ebx
  801c55:	74 0a                	je     801c61 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801c57:	a1 04 40 80 00       	mov    0x804004,%eax
  801c5c:	8b 40 78             	mov    0x78(%eax),%eax
  801c5f:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801c61:	a1 04 40 80 00       	mov    0x804004,%eax
  801c66:	8b 40 70             	mov    0x70(%eax),%eax
}
  801c69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    
		if(from_env_store)
  801c70:	85 f6                	test   %esi,%esi
  801c72:	74 06                	je     801c7a <ipc_recv+0x61>
			*from_env_store=0;
  801c74:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801c7a:	85 db                	test   %ebx,%ebx
  801c7c:	74 eb                	je     801c69 <ipc_recv+0x50>
			*perm_store=0;
  801c7e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c84:	eb e3                	jmp    801c69 <ipc_recv+0x50>

00801c86 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c86:	f3 0f 1e fb          	endbr32 
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	57                   	push   %edi
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 0c             	sub    $0xc,%esp
  801c93:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c96:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801c9c:	85 db                	test   %ebx,%ebx
  801c9e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ca3:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801ca6:	ff 75 14             	pushl  0x14(%ebp)
  801ca9:	53                   	push   %ebx
  801caa:	56                   	push   %esi
  801cab:	57                   	push   %edi
  801cac:	e8 cd f0 ff ff       	call   800d7e <sys_ipc_try_send>
		if(!res)
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	74 20                	je     801cd8 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  801cb8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cbb:	75 07                	jne    801cc4 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  801cbd:	e8 f4 ee ff ff       	call   800bb6 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801cc2:	eb e2                	jmp    801ca6 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	68 8f 24 80 00       	push   $0x80248f
  801ccc:	6a 3f                	push   $0x3f
  801cce:	68 a7 24 80 00       	push   $0x8024a7
  801cd3:	e8 f7 fe ff ff       	call   801bcf <_panic>
	}
}
  801cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ce0:	f3 0f 1e fb          	endbr32 
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cef:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cf2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cf8:	8b 52 50             	mov    0x50(%edx),%edx
  801cfb:	39 ca                	cmp    %ecx,%edx
  801cfd:	74 11                	je     801d10 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801cff:	83 c0 01             	add    $0x1,%eax
  801d02:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d07:	75 e6                	jne    801cef <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0e:	eb 0b                	jmp    801d1b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801d10:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d13:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d18:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d27:	89 c2                	mov    %eax,%edx
  801d29:	c1 ea 16             	shr    $0x16,%edx
  801d2c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d33:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d38:	f6 c1 01             	test   $0x1,%cl
  801d3b:	74 1c                	je     801d59 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d3d:	c1 e8 0c             	shr    $0xc,%eax
  801d40:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d47:	a8 01                	test   $0x1,%al
  801d49:	74 0e                	je     801d59 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d4b:	c1 e8 0c             	shr    $0xc,%eax
  801d4e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d55:	ef 
  801d56:	0f b7 d2             	movzwl %dx,%edx
}
  801d59:	89 d0                	mov    %edx,%eax
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    
  801d5d:	66 90                	xchg   %ax,%ax
  801d5f:	90                   	nop

00801d60 <__udivdi3>:
  801d60:	f3 0f 1e fb          	endbr32 
  801d64:	55                   	push   %ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 1c             	sub    $0x1c,%esp
  801d6b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d73:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d7b:	85 d2                	test   %edx,%edx
  801d7d:	75 19                	jne    801d98 <__udivdi3+0x38>
  801d7f:	39 f3                	cmp    %esi,%ebx
  801d81:	76 4d                	jbe    801dd0 <__udivdi3+0x70>
  801d83:	31 ff                	xor    %edi,%edi
  801d85:	89 e8                	mov    %ebp,%eax
  801d87:	89 f2                	mov    %esi,%edx
  801d89:	f7 f3                	div    %ebx
  801d8b:	89 fa                	mov    %edi,%edx
  801d8d:	83 c4 1c             	add    $0x1c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
  801d95:	8d 76 00             	lea    0x0(%esi),%esi
  801d98:	39 f2                	cmp    %esi,%edx
  801d9a:	76 14                	jbe    801db0 <__udivdi3+0x50>
  801d9c:	31 ff                	xor    %edi,%edi
  801d9e:	31 c0                	xor    %eax,%eax
  801da0:	89 fa                	mov    %edi,%edx
  801da2:	83 c4 1c             	add    $0x1c,%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
  801daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801db0:	0f bd fa             	bsr    %edx,%edi
  801db3:	83 f7 1f             	xor    $0x1f,%edi
  801db6:	75 48                	jne    801e00 <__udivdi3+0xa0>
  801db8:	39 f2                	cmp    %esi,%edx
  801dba:	72 06                	jb     801dc2 <__udivdi3+0x62>
  801dbc:	31 c0                	xor    %eax,%eax
  801dbe:	39 eb                	cmp    %ebp,%ebx
  801dc0:	77 de                	ja     801da0 <__udivdi3+0x40>
  801dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc7:	eb d7                	jmp    801da0 <__udivdi3+0x40>
  801dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dd0:	89 d9                	mov    %ebx,%ecx
  801dd2:	85 db                	test   %ebx,%ebx
  801dd4:	75 0b                	jne    801de1 <__udivdi3+0x81>
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	f7 f3                	div    %ebx
  801ddf:	89 c1                	mov    %eax,%ecx
  801de1:	31 d2                	xor    %edx,%edx
  801de3:	89 f0                	mov    %esi,%eax
  801de5:	f7 f1                	div    %ecx
  801de7:	89 c6                	mov    %eax,%esi
  801de9:	89 e8                	mov    %ebp,%eax
  801deb:	89 f7                	mov    %esi,%edi
  801ded:	f7 f1                	div    %ecx
  801def:	89 fa                	mov    %edi,%edx
  801df1:	83 c4 1c             	add    $0x1c,%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5f                   	pop    %edi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
  801df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e00:	89 f9                	mov    %edi,%ecx
  801e02:	b8 20 00 00 00       	mov    $0x20,%eax
  801e07:	29 f8                	sub    %edi,%eax
  801e09:	d3 e2                	shl    %cl,%edx
  801e0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e0f:	89 c1                	mov    %eax,%ecx
  801e11:	89 da                	mov    %ebx,%edx
  801e13:	d3 ea                	shr    %cl,%edx
  801e15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e19:	09 d1                	or     %edx,%ecx
  801e1b:	89 f2                	mov    %esi,%edx
  801e1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e21:	89 f9                	mov    %edi,%ecx
  801e23:	d3 e3                	shl    %cl,%ebx
  801e25:	89 c1                	mov    %eax,%ecx
  801e27:	d3 ea                	shr    %cl,%edx
  801e29:	89 f9                	mov    %edi,%ecx
  801e2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e2f:	89 eb                	mov    %ebp,%ebx
  801e31:	d3 e6                	shl    %cl,%esi
  801e33:	89 c1                	mov    %eax,%ecx
  801e35:	d3 eb                	shr    %cl,%ebx
  801e37:	09 de                	or     %ebx,%esi
  801e39:	89 f0                	mov    %esi,%eax
  801e3b:	f7 74 24 08          	divl   0x8(%esp)
  801e3f:	89 d6                	mov    %edx,%esi
  801e41:	89 c3                	mov    %eax,%ebx
  801e43:	f7 64 24 0c          	mull   0xc(%esp)
  801e47:	39 d6                	cmp    %edx,%esi
  801e49:	72 15                	jb     801e60 <__udivdi3+0x100>
  801e4b:	89 f9                	mov    %edi,%ecx
  801e4d:	d3 e5                	shl    %cl,%ebp
  801e4f:	39 c5                	cmp    %eax,%ebp
  801e51:	73 04                	jae    801e57 <__udivdi3+0xf7>
  801e53:	39 d6                	cmp    %edx,%esi
  801e55:	74 09                	je     801e60 <__udivdi3+0x100>
  801e57:	89 d8                	mov    %ebx,%eax
  801e59:	31 ff                	xor    %edi,%edi
  801e5b:	e9 40 ff ff ff       	jmp    801da0 <__udivdi3+0x40>
  801e60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e63:	31 ff                	xor    %edi,%edi
  801e65:	e9 36 ff ff ff       	jmp    801da0 <__udivdi3+0x40>
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	66 90                	xchg   %ax,%ax
  801e6e:	66 90                	xchg   %ax,%ax

00801e70 <__umoddi3>:
  801e70:	f3 0f 1e fb          	endbr32 
  801e74:	55                   	push   %ebp
  801e75:	57                   	push   %edi
  801e76:	56                   	push   %esi
  801e77:	53                   	push   %ebx
  801e78:	83 ec 1c             	sub    $0x1c,%esp
  801e7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e83:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	75 19                	jne    801ea8 <__umoddi3+0x38>
  801e8f:	39 df                	cmp    %ebx,%edi
  801e91:	76 5d                	jbe    801ef0 <__umoddi3+0x80>
  801e93:	89 f0                	mov    %esi,%eax
  801e95:	89 da                	mov    %ebx,%edx
  801e97:	f7 f7                	div    %edi
  801e99:	89 d0                	mov    %edx,%eax
  801e9b:	31 d2                	xor    %edx,%edx
  801e9d:	83 c4 1c             	add    $0x1c,%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    
  801ea5:	8d 76 00             	lea    0x0(%esi),%esi
  801ea8:	89 f2                	mov    %esi,%edx
  801eaa:	39 d8                	cmp    %ebx,%eax
  801eac:	76 12                	jbe    801ec0 <__umoddi3+0x50>
  801eae:	89 f0                	mov    %esi,%eax
  801eb0:	89 da                	mov    %ebx,%edx
  801eb2:	83 c4 1c             	add    $0x1c,%esp
  801eb5:	5b                   	pop    %ebx
  801eb6:	5e                   	pop    %esi
  801eb7:	5f                   	pop    %edi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    
  801eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ec0:	0f bd e8             	bsr    %eax,%ebp
  801ec3:	83 f5 1f             	xor    $0x1f,%ebp
  801ec6:	75 50                	jne    801f18 <__umoddi3+0xa8>
  801ec8:	39 d8                	cmp    %ebx,%eax
  801eca:	0f 82 e0 00 00 00    	jb     801fb0 <__umoddi3+0x140>
  801ed0:	89 d9                	mov    %ebx,%ecx
  801ed2:	39 f7                	cmp    %esi,%edi
  801ed4:	0f 86 d6 00 00 00    	jbe    801fb0 <__umoddi3+0x140>
  801eda:	89 d0                	mov    %edx,%eax
  801edc:	89 ca                	mov    %ecx,%edx
  801ede:	83 c4 1c             	add    $0x1c,%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5f                   	pop    %edi
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    
  801ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	89 fd                	mov    %edi,%ebp
  801ef2:	85 ff                	test   %edi,%edi
  801ef4:	75 0b                	jne    801f01 <__umoddi3+0x91>
  801ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  801efb:	31 d2                	xor    %edx,%edx
  801efd:	f7 f7                	div    %edi
  801eff:	89 c5                	mov    %eax,%ebp
  801f01:	89 d8                	mov    %ebx,%eax
  801f03:	31 d2                	xor    %edx,%edx
  801f05:	f7 f5                	div    %ebp
  801f07:	89 f0                	mov    %esi,%eax
  801f09:	f7 f5                	div    %ebp
  801f0b:	89 d0                	mov    %edx,%eax
  801f0d:	31 d2                	xor    %edx,%edx
  801f0f:	eb 8c                	jmp    801e9d <__umoddi3+0x2d>
  801f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f18:	89 e9                	mov    %ebp,%ecx
  801f1a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f1f:	29 ea                	sub    %ebp,%edx
  801f21:	d3 e0                	shl    %cl,%eax
  801f23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f27:	89 d1                	mov    %edx,%ecx
  801f29:	89 f8                	mov    %edi,%eax
  801f2b:	d3 e8                	shr    %cl,%eax
  801f2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f31:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f35:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f39:	09 c1                	or     %eax,%ecx
  801f3b:	89 d8                	mov    %ebx,%eax
  801f3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f41:	89 e9                	mov    %ebp,%ecx
  801f43:	d3 e7                	shl    %cl,%edi
  801f45:	89 d1                	mov    %edx,%ecx
  801f47:	d3 e8                	shr    %cl,%eax
  801f49:	89 e9                	mov    %ebp,%ecx
  801f4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f4f:	d3 e3                	shl    %cl,%ebx
  801f51:	89 c7                	mov    %eax,%edi
  801f53:	89 d1                	mov    %edx,%ecx
  801f55:	89 f0                	mov    %esi,%eax
  801f57:	d3 e8                	shr    %cl,%eax
  801f59:	89 e9                	mov    %ebp,%ecx
  801f5b:	89 fa                	mov    %edi,%edx
  801f5d:	d3 e6                	shl    %cl,%esi
  801f5f:	09 d8                	or     %ebx,%eax
  801f61:	f7 74 24 08          	divl   0x8(%esp)
  801f65:	89 d1                	mov    %edx,%ecx
  801f67:	89 f3                	mov    %esi,%ebx
  801f69:	f7 64 24 0c          	mull   0xc(%esp)
  801f6d:	89 c6                	mov    %eax,%esi
  801f6f:	89 d7                	mov    %edx,%edi
  801f71:	39 d1                	cmp    %edx,%ecx
  801f73:	72 06                	jb     801f7b <__umoddi3+0x10b>
  801f75:	75 10                	jne    801f87 <__umoddi3+0x117>
  801f77:	39 c3                	cmp    %eax,%ebx
  801f79:	73 0c                	jae    801f87 <__umoddi3+0x117>
  801f7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801f7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f83:	89 d7                	mov    %edx,%edi
  801f85:	89 c6                	mov    %eax,%esi
  801f87:	89 ca                	mov    %ecx,%edx
  801f89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f8e:	29 f3                	sub    %esi,%ebx
  801f90:	19 fa                	sbb    %edi,%edx
  801f92:	89 d0                	mov    %edx,%eax
  801f94:	d3 e0                	shl    %cl,%eax
  801f96:	89 e9                	mov    %ebp,%ecx
  801f98:	d3 eb                	shr    %cl,%ebx
  801f9a:	d3 ea                	shr    %cl,%edx
  801f9c:	09 d8                	or     %ebx,%eax
  801f9e:	83 c4 1c             	add    $0x1c,%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    
  801fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fad:	8d 76 00             	lea    0x0(%esi),%esi
  801fb0:	29 fe                	sub    %edi,%esi
  801fb2:	19 c3                	sbb    %eax,%ebx
  801fb4:	89 f2                	mov    %esi,%edx
  801fb6:	89 d9                	mov    %ebx,%ecx
  801fb8:	e9 1d ff ff ff       	jmp    801eda <__umoddi3+0x6a>
