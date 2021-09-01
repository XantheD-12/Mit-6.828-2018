
obj/user/fairness.debug：     文件格式 elf32-i386


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
  80002c:	e8 74 00 00 00       	call   8000a5 <libmain>
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
  80003c:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003f:	e8 6c 0b 00 00       	call   800bb0 <sys_getenvid>
  800044:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800046:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
  80004d:	00 c0 ee 
  800050:	74 2d                	je     80007f <umain+0x4c>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800052:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	50                   	push   %eax
  80005b:	53                   	push   %ebx
  80005c:	68 51 1f 80 00       	push   $0x801f51
  800061:	e8 44 01 00 00       	call   8001aa <cprintf>
  800066:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800069:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006e:	6a 00                	push   $0x0
  800070:	6a 00                	push   $0x0
  800072:	6a 00                	push   $0x0
  800074:	50                   	push   %eax
  800075:	e8 fa 0d 00 00       	call   800e74 <ipc_send>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	eb ea                	jmp    800069 <umain+0x36>
			ipc_recv(&who, 0, 0);
  80007f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 00                	push   $0x0
  800087:	6a 00                	push   $0x0
  800089:	56                   	push   %esi
  80008a:	e8 78 0d 00 00       	call   800e07 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008f:	83 c4 0c             	add    $0xc,%esp
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	53                   	push   %ebx
  800096:	68 40 1f 80 00       	push   $0x801f40
  80009b:	e8 0a 01 00 00       	call   8001aa <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	eb dd                	jmp    800082 <umain+0x4f>

008000a5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a5:	f3 0f 1e fb          	endbr32 
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
  8000ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000b1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000b4:	e8 f7 0a 00 00       	call   800bb0 <sys_getenvid>
  8000b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000be:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c6:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	85 db                	test   %ebx,%ebx
  8000cd:	7e 07                	jle    8000d6 <libmain+0x31>
		binaryname = argv[0];
  8000cf:	8b 06                	mov    (%esi),%eax
  8000d1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	e8 53 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0a 00 00 00       	call   8000ef <exit>
}
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f9:	e8 fc 0f 00 00       	call   8010fa <close_all>
	sys_env_destroy(0);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	6a 00                	push   $0x0
  800103:	e8 63 0a 00 00       	call   800b6b <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010d:	f3 0f 1e fb          	endbr32 
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	53                   	push   %ebx
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011b:	8b 13                	mov    (%ebx),%edx
  80011d:	8d 42 01             	lea    0x1(%edx),%eax
  800120:	89 03                	mov    %eax,(%ebx)
  800122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800125:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800129:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012e:	74 09                	je     800139 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800130:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800137:	c9                   	leave  
  800138:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	68 ff 00 00 00       	push   $0xff
  800141:	8d 43 08             	lea    0x8(%ebx),%eax
  800144:	50                   	push   %eax
  800145:	e8 dc 09 00 00       	call   800b26 <sys_cputs>
		b->idx = 0;
  80014a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	eb db                	jmp    800130 <putch+0x23>

00800155 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800155:	f3 0f 1e fb          	endbr32 
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 0d 01 80 00       	push   $0x80010d
  800188:	e8 20 01 00 00       	call   8002ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 84 09 00 00       	call   800b26 <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	f3 0f 1e fb          	endbr32 
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b7:	50                   	push   %eax
  8001b8:	ff 75 08             	pushl  0x8(%ebp)
  8001bb:	e8 95 ff ff ff       	call   800155 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 1c             	sub    $0x1c,%esp
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 d6                	mov    %edx,%esi
  8001cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	89 c2                	mov    %eax,%edx
  8001d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ef:	39 c2                	cmp    %eax,%edx
  8001f1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f4:	72 3e                	jb     800234 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 18             	pushl  0x18(%ebp)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	53                   	push   %ebx
  800200:	50                   	push   %eax
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	ff 75 e4             	pushl  -0x1c(%ebp)
  800207:	ff 75 e0             	pushl  -0x20(%ebp)
  80020a:	ff 75 dc             	pushl  -0x24(%ebp)
  80020d:	ff 75 d8             	pushl  -0x28(%ebp)
  800210:	e8 cb 1a 00 00       	call   801ce0 <__udivdi3>
  800215:	83 c4 18             	add    $0x18,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	89 f2                	mov    %esi,%edx
  80021c:	89 f8                	mov    %edi,%eax
  80021e:	e8 9f ff ff ff       	call   8001c2 <printnum>
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	eb 13                	jmp    80023b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	ff 75 18             	pushl  0x18(%ebp)
  80022f:	ff d7                	call   *%edi
  800231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ed                	jg     800228 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	ff 75 dc             	pushl  -0x24(%ebp)
  80024b:	ff 75 d8             	pushl  -0x28(%ebp)
  80024e:	e8 9d 1b 00 00       	call   801df0 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 72 1f 80 00 	movsbl 0x801f72(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026b:	f3 0f 1e fb          	endbr32 
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800275:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	3b 50 04             	cmp    0x4(%eax),%edx
  80027e:	73 0a                	jae    80028a <sprintputch+0x1f>
		*b->buf++ = ch;
  800280:	8d 4a 01             	lea    0x1(%edx),%ecx
  800283:	89 08                	mov    %ecx,(%eax)
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	88 02                	mov    %al,(%edx)
}
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    

0080028c <printfmt>:
{
  80028c:	f3 0f 1e fb          	endbr32 
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800296:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800299:	50                   	push   %eax
  80029a:	ff 75 10             	pushl  0x10(%ebp)
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	e8 05 00 00 00       	call   8002ad <vprintfmt>
}
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <vprintfmt>:
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 3c             	sub    $0x3c,%esp
  8002ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c3:	e9 8e 03 00 00       	jmp    800656 <vprintfmt+0x3a9>
		padc = ' ';
  8002c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002cc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e6:	8d 47 01             	lea    0x1(%edi),%eax
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	0f b6 17             	movzbl (%edi),%edx
  8002ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f2:	3c 55                	cmp    $0x55,%al
  8002f4:	0f 87 df 03 00 00    	ja     8006d9 <vprintfmt+0x42c>
  8002fa:	0f b6 c0             	movzbl %al,%eax
  8002fd:	3e ff 24 85 c0 20 80 	notrack jmp *0x8020c0(,%eax,4)
  800304:	00 
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80030c:	eb d8                	jmp    8002e6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800311:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800315:	eb cf                	jmp    8002e6 <vprintfmt+0x39>
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800332:	83 f9 09             	cmp    $0x9,%ecx
  800335:	77 55                	ja     80038c <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	eb e9                	jmp    800325 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 40 04             	lea    0x4(%eax),%eax
  80034a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800354:	79 90                	jns    8002e6 <vprintfmt+0x39>
				width = precision, precision = -1;
  800356:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800363:	eb 81                	jmp    8002e6 <vprintfmt+0x39>
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	0f 49 d0             	cmovns %eax,%edx
  800372:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800378:	e9 69 ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800380:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800387:	e9 5a ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800392:	eb bc                	jmp    800350 <vprintfmt+0xa3>
			lflag++;
  800394:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039a:	e9 47 ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 78 04             	lea    0x4(%eax),%edi
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 30                	pushl  (%eax)
  8003ab:	ff d6                	call   *%esi
			break;
  8003ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b3:	e9 9b 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 78 04             	lea    0x4(%eax),%edi
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	99                   	cltd   
  8003c1:	31 d0                	xor    %edx,%eax
  8003c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c5:	83 f8 0f             	cmp    $0xf,%eax
  8003c8:	7f 23                	jg     8003ed <vprintfmt+0x140>
  8003ca:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 71 23 80 00       	push   $0x802371
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 aa fe ff ff       	call   80028c <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 66 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 8a 1f 80 00       	push   $0x801f8a
  8003f3:	53                   	push   %ebx
  8003f4:	56                   	push   %esi
  8003f5:	e8 92 fe ff ff       	call   80028c <printfmt>
  8003fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800400:	e9 4e 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	83 c0 04             	add    $0x4,%eax
  80040b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800413:	85 d2                	test   %edx,%edx
  800415:	b8 83 1f 80 00       	mov    $0x801f83,%eax
  80041a:	0f 45 c2             	cmovne %edx,%eax
  80041d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800424:	7e 06                	jle    80042c <vprintfmt+0x17f>
  800426:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80042a:	75 0d                	jne    800439 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80042f:	89 c7                	mov    %eax,%edi
  800431:	03 45 e0             	add    -0x20(%ebp),%eax
  800434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800437:	eb 55                	jmp    80048e <vprintfmt+0x1e1>
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 d8             	pushl  -0x28(%ebp)
  80043f:	ff 75 cc             	pushl  -0x34(%ebp)
  800442:	e8 46 03 00 00       	call   80078d <strnlen>
  800447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044a:	29 c2                	sub    %eax,%edx
  80044c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800454:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80045b:	85 ff                	test   %edi,%edi
  80045d:	7e 11                	jle    800470 <vprintfmt+0x1c3>
					putch(padc, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	ff 75 e0             	pushl  -0x20(%ebp)
  800466:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800468:	83 ef 01             	sub    $0x1,%edi
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	eb eb                	jmp    80045b <vprintfmt+0x1ae>
  800470:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800473:	85 d2                	test   %edx,%edx
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	0f 49 c2             	cmovns %edx,%eax
  80047d:	29 c2                	sub    %eax,%edx
  80047f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800482:	eb a8                	jmp    80042c <vprintfmt+0x17f>
					putch(ch, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	52                   	push   %edx
  800489:	ff d6                	call   *%esi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800491:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800493:	83 c7 01             	add    $0x1,%edi
  800496:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80049a:	0f be d0             	movsbl %al,%edx
  80049d:	85 d2                	test   %edx,%edx
  80049f:	74 4b                	je     8004ec <vprintfmt+0x23f>
  8004a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a5:	78 06                	js     8004ad <vprintfmt+0x200>
  8004a7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ab:	78 1e                	js     8004cb <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b1:	74 d1                	je     800484 <vprintfmt+0x1d7>
  8004b3:	0f be c0             	movsbl %al,%eax
  8004b6:	83 e8 20             	sub    $0x20,%eax
  8004b9:	83 f8 5e             	cmp    $0x5e,%eax
  8004bc:	76 c6                	jbe    800484 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	53                   	push   %ebx
  8004c2:	6a 3f                	push   $0x3f
  8004c4:	ff d6                	call   *%esi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	eb c3                	jmp    80048e <vprintfmt+0x1e1>
  8004cb:	89 cf                	mov    %ecx,%edi
  8004cd:	eb 0e                	jmp    8004dd <vprintfmt+0x230>
				putch(' ', putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	6a 20                	push   $0x20
  8004d5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ee                	jg     8004cf <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e7:	e9 67 01 00 00       	jmp    800653 <vprintfmt+0x3a6>
  8004ec:	89 cf                	mov    %ecx,%edi
  8004ee:	eb ed                	jmp    8004dd <vprintfmt+0x230>
	if (lflag >= 2)
  8004f0:	83 f9 01             	cmp    $0x1,%ecx
  8004f3:	7f 1b                	jg     800510 <vprintfmt+0x263>
	else if (lflag)
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	74 63                	je     80055c <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	99                   	cltd   
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	eb 17                	jmp    800527 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 50 04             	mov    0x4(%eax),%edx
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8d 40 08             	lea    0x8(%eax),%eax
  800524:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800532:	85 c9                	test   %ecx,%ecx
  800534:	0f 89 ff 00 00 00    	jns    800639 <vprintfmt+0x38c>
				putch('-', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 2d                	push   $0x2d
  800540:	ff d6                	call   *%esi
				num = -(long long) num;
  800542:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800545:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800548:	f7 da                	neg    %edx
  80054a:	83 d1 00             	adc    $0x0,%ecx
  80054d:	f7 d9                	neg    %ecx
  80054f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800552:	b8 0a 00 00 00       	mov    $0xa,%eax
  800557:	e9 dd 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	99                   	cltd   
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 04             	lea    0x4(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	eb b4                	jmp    800527 <vprintfmt+0x27a>
	if (lflag >= 2)
  800573:	83 f9 01             	cmp    $0x1,%ecx
  800576:	7f 1e                	jg     800596 <vprintfmt+0x2e9>
	else if (lflag)
  800578:	85 c9                	test   %ecx,%ecx
  80057a:	74 32                	je     8005ae <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800591:	e9 a3 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8b 48 04             	mov    0x4(%eax),%ecx
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005a9:	e9 8b 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
  8005b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005c3:	eb 74                	jmp    800639 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005c5:	83 f9 01             	cmp    $0x1,%ecx
  8005c8:	7f 1b                	jg     8005e5 <vprintfmt+0x338>
	else if (lflag)
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	74 2c                	je     8005fa <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005de:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005e3:	eb 54                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 10                	mov    (%eax),%edx
  8005ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ed:	8d 40 08             	lea    0x8(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005f3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005f8:	eb 3f                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 10                	mov    (%eax),%edx
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80060a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80060f:	eb 28                	jmp    800639 <vprintfmt+0x38c>
			putch('0', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 30                	push   $0x30
  800617:	ff d6                	call   *%esi
			putch('x', putdat);
  800619:	83 c4 08             	add    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 78                	push   $0x78
  80061f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800634:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800640:	57                   	push   %edi
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	50                   	push   %eax
  800645:	51                   	push   %ecx
  800646:	52                   	push   %edx
  800647:	89 da                	mov    %ebx,%edx
  800649:	89 f0                	mov    %esi,%eax
  80064b:	e8 72 fb ff ff       	call   8001c2 <printnum>
			break;
  800650:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	83 c7 01             	add    $0x1,%edi
  800659:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065d:	83 f8 25             	cmp    $0x25,%eax
  800660:	0f 84 62 fc ff ff    	je     8002c8 <vprintfmt+0x1b>
			if (ch == '\0')
  800666:	85 c0                	test   %eax,%eax
  800668:	0f 84 8b 00 00 00    	je     8006f9 <vprintfmt+0x44c>
			putch(ch, putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	50                   	push   %eax
  800673:	ff d6                	call   *%esi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	eb dc                	jmp    800656 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80067a:	83 f9 01             	cmp    $0x1,%ecx
  80067d:	7f 1b                	jg     80069a <vprintfmt+0x3ed>
	else if (lflag)
  80067f:	85 c9                	test   %ecx,%ecx
  800681:	74 2c                	je     8006af <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800693:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800698:	eb 9f                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a2:	8d 40 08             	lea    0x8(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006ad:	eb 8a                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 10                	mov    (%eax),%edx
  8006b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bf:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006c4:	e9 70 ff ff ff       	jmp    800639 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 25                	push   $0x25
  8006cf:	ff d6                	call   *%esi
			break;
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	e9 7a ff ff ff       	jmp    800653 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 25                	push   $0x25
  8006df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 f8                	mov    %edi,%eax
  8006e6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ea:	74 05                	je     8006f1 <vprintfmt+0x444>
  8006ec:	83 e8 01             	sub    $0x1,%eax
  8006ef:	eb f5                	jmp    8006e6 <vprintfmt+0x439>
  8006f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f4:	e9 5a ff ff ff       	jmp    800653 <vprintfmt+0x3a6>
}
  8006f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fc:	5b                   	pop    %ebx
  8006fd:	5e                   	pop    %esi
  8006fe:	5f                   	pop    %edi
  8006ff:	5d                   	pop    %ebp
  800700:	c3                   	ret    

00800701 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800701:	f3 0f 1e fb          	endbr32 
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	83 ec 18             	sub    $0x18,%esp
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800714:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800718:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80071b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800722:	85 c0                	test   %eax,%eax
  800724:	74 26                	je     80074c <vsnprintf+0x4b>
  800726:	85 d2                	test   %edx,%edx
  800728:	7e 22                	jle    80074c <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80072a:	ff 75 14             	pushl  0x14(%ebp)
  80072d:	ff 75 10             	pushl  0x10(%ebp)
  800730:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	68 6b 02 80 00       	push   $0x80026b
  800739:	e8 6f fb ff ff       	call   8002ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800741:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800747:	83 c4 10             	add    $0x10,%esp
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    
		return -E_INVAL;
  80074c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800751:	eb f7                	jmp    80074a <vsnprintf+0x49>

00800753 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800753:	f3 0f 1e fb          	endbr32 
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80075d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800760:	50                   	push   %eax
  800761:	ff 75 10             	pushl  0x10(%ebp)
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	e8 92 ff ff ff       	call   800701 <vsnprintf>
	va_end(ap);

	return rc;
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800771:	f3 0f 1e fb          	endbr32 
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800784:	74 05                	je     80078b <strlen+0x1a>
		n++;
  800786:	83 c0 01             	add    $0x1,%eax
  800789:	eb f5                	jmp    800780 <strlen+0xf>
	return n;
}
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800797:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	39 d0                	cmp    %edx,%eax
  8007a1:	74 0d                	je     8007b0 <strnlen+0x23>
  8007a3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a7:	74 05                	je     8007ae <strnlen+0x21>
		n++;
  8007a9:	83 c0 01             	add    $0x1,%eax
  8007ac:	eb f1                	jmp    80079f <strnlen+0x12>
  8007ae:	89 c2                	mov    %eax,%edx
	return n;
}
  8007b0:	89 d0                	mov    %edx,%eax
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b4:	f3 0f 1e fb          	endbr32 
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007cb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007ce:	83 c0 01             	add    $0x1,%eax
  8007d1:	84 d2                	test   %dl,%dl
  8007d3:	75 f2                	jne    8007c7 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007d5:	89 c8                	mov    %ecx,%eax
  8007d7:	5b                   	pop    %ebx
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007da:	f3 0f 1e fb          	endbr32 
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	53                   	push   %ebx
  8007e2:	83 ec 10             	sub    $0x10,%esp
  8007e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e8:	53                   	push   %ebx
  8007e9:	e8 83 ff ff ff       	call   800771 <strlen>
  8007ee:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	01 d8                	add    %ebx,%eax
  8007f6:	50                   	push   %eax
  8007f7:	e8 b8 ff ff ff       	call   8007b4 <strcpy>
	return dst;
}
  8007fc:	89 d8                	mov    %ebx,%eax
  8007fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800803:	f3 0f 1e fb          	endbr32 
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	56                   	push   %esi
  80080b:	53                   	push   %ebx
  80080c:	8b 75 08             	mov    0x8(%ebp),%esi
  80080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800812:	89 f3                	mov    %esi,%ebx
  800814:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800817:	89 f0                	mov    %esi,%eax
  800819:	39 d8                	cmp    %ebx,%eax
  80081b:	74 11                	je     80082e <strncpy+0x2b>
		*dst++ = *src;
  80081d:	83 c0 01             	add    $0x1,%eax
  800820:	0f b6 0a             	movzbl (%edx),%ecx
  800823:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800826:	80 f9 01             	cmp    $0x1,%cl
  800829:	83 da ff             	sbb    $0xffffffff,%edx
  80082c:	eb eb                	jmp    800819 <strncpy+0x16>
	}
	return ret;
}
  80082e:	89 f0                	mov    %esi,%eax
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800834:	f3 0f 1e fb          	endbr32 
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	56                   	push   %esi
  80083c:	53                   	push   %ebx
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800843:	8b 55 10             	mov    0x10(%ebp),%edx
  800846:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 21                	je     80086d <strlcpy+0x39>
  80084c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800850:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800852:	39 c2                	cmp    %eax,%edx
  800854:	74 14                	je     80086a <strlcpy+0x36>
  800856:	0f b6 19             	movzbl (%ecx),%ebx
  800859:	84 db                	test   %bl,%bl
  80085b:	74 0b                	je     800868 <strlcpy+0x34>
			*dst++ = *src++;
  80085d:	83 c1 01             	add    $0x1,%ecx
  800860:	83 c2 01             	add    $0x1,%edx
  800863:	88 5a ff             	mov    %bl,-0x1(%edx)
  800866:	eb ea                	jmp    800852 <strlcpy+0x1e>
  800868:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80086a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80086d:	29 f0                	sub    %esi,%eax
}
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800873:	f3 0f 1e fb          	endbr32 
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800880:	0f b6 01             	movzbl (%ecx),%eax
  800883:	84 c0                	test   %al,%al
  800885:	74 0c                	je     800893 <strcmp+0x20>
  800887:	3a 02                	cmp    (%edx),%al
  800889:	75 08                	jne    800893 <strcmp+0x20>
		p++, q++;
  80088b:	83 c1 01             	add    $0x1,%ecx
  80088e:	83 c2 01             	add    $0x1,%edx
  800891:	eb ed                	jmp    800880 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800893:	0f b6 c0             	movzbl %al,%eax
  800896:	0f b6 12             	movzbl (%edx),%edx
  800899:	29 d0                	sub    %edx,%eax
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80089d:	f3 0f 1e fb          	endbr32 
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ab:	89 c3                	mov    %eax,%ebx
  8008ad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strncmp+0x1b>
		n--, p++, q++;
  8008b2:	83 c0 01             	add    $0x1,%eax
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b8:	39 d8                	cmp    %ebx,%eax
  8008ba:	74 16                	je     8008d2 <strncmp+0x35>
  8008bc:	0f b6 08             	movzbl (%eax),%ecx
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	74 04                	je     8008c7 <strncmp+0x2a>
  8008c3:	3a 0a                	cmp    (%edx),%cl
  8008c5:	74 eb                	je     8008b2 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c7:	0f b6 00             	movzbl (%eax),%eax
  8008ca:	0f b6 12             	movzbl (%edx),%edx
  8008cd:	29 d0                	sub    %edx,%eax
}
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb f6                	jmp    8008cf <strncmp+0x32>

008008d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e7:	0f b6 10             	movzbl (%eax),%edx
  8008ea:	84 d2                	test   %dl,%dl
  8008ec:	74 09                	je     8008f7 <strchr+0x1e>
		if (*s == c)
  8008ee:	38 ca                	cmp    %cl,%dl
  8008f0:	74 0a                	je     8008fc <strchr+0x23>
	for (; *s; s++)
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	eb f0                	jmp    8008e7 <strchr+0xe>
			return (char *) s;
	return 0;
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fe:	f3 0f 1e fb          	endbr32 
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090f:	38 ca                	cmp    %cl,%dl
  800911:	74 09                	je     80091c <strfind+0x1e>
  800913:	84 d2                	test   %dl,%dl
  800915:	74 05                	je     80091c <strfind+0x1e>
	for (; *s; s++)
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	eb f0                	jmp    80090c <strfind+0xe>
			break;
	return (char *) s;
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80091e:	f3 0f 1e fb          	endbr32 
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	57                   	push   %edi
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092e:	85 c9                	test   %ecx,%ecx
  800930:	74 31                	je     800963 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800932:	89 f8                	mov    %edi,%eax
  800934:	09 c8                	or     %ecx,%eax
  800936:	a8 03                	test   $0x3,%al
  800938:	75 23                	jne    80095d <memset+0x3f>
		c &= 0xFF;
  80093a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093e:	89 d3                	mov    %edx,%ebx
  800940:	c1 e3 08             	shl    $0x8,%ebx
  800943:	89 d0                	mov    %edx,%eax
  800945:	c1 e0 18             	shl    $0x18,%eax
  800948:	89 d6                	mov    %edx,%esi
  80094a:	c1 e6 10             	shl    $0x10,%esi
  80094d:	09 f0                	or     %esi,%eax
  80094f:	09 c2                	or     %eax,%edx
  800951:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800953:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800956:	89 d0                	mov    %edx,%eax
  800958:	fc                   	cld    
  800959:	f3 ab                	rep stos %eax,%es:(%edi)
  80095b:	eb 06                	jmp    800963 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	fc                   	cld    
  800961:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800963:	89 f8                	mov    %edi,%eax
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5f                   	pop    %edi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096a:	f3 0f 1e fb          	endbr32 
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	57                   	push   %edi
  800972:	56                   	push   %esi
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 75 0c             	mov    0xc(%ebp),%esi
  800979:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097c:	39 c6                	cmp    %eax,%esi
  80097e:	73 32                	jae    8009b2 <memmove+0x48>
  800980:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800983:	39 c2                	cmp    %eax,%edx
  800985:	76 2b                	jbe    8009b2 <memmove+0x48>
		s += n;
		d += n;
  800987:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098a:	89 fe                	mov    %edi,%esi
  80098c:	09 ce                	or     %ecx,%esi
  80098e:	09 d6                	or     %edx,%esi
  800990:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800996:	75 0e                	jne    8009a6 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800998:	83 ef 04             	sub    $0x4,%edi
  80099b:	8d 72 fc             	lea    -0x4(%edx),%esi
  80099e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a1:	fd                   	std    
  8009a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a4:	eb 09                	jmp    8009af <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a6:	83 ef 01             	sub    $0x1,%edi
  8009a9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009af:	fc                   	cld    
  8009b0:	eb 1a                	jmp    8009cc <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	89 c2                	mov    %eax,%edx
  8009b4:	09 ca                	or     %ecx,%edx
  8009b6:	09 f2                	or     %esi,%edx
  8009b8:	f6 c2 03             	test   $0x3,%dl
  8009bb:	75 0a                	jne    8009c7 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c0:	89 c7                	mov    %eax,%edi
  8009c2:	fc                   	cld    
  8009c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c5:	eb 05                	jmp    8009cc <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009c7:	89 c7                	mov    %eax,%edi
  8009c9:	fc                   	cld    
  8009ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009cc:	5e                   	pop    %esi
  8009cd:	5f                   	pop    %edi
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d0:	f3 0f 1e fb          	endbr32 
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	e8 82 ff ff ff       	call   80096a <memmove>
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ea:	f3 0f 1e fb          	endbr32 
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f9:	89 c6                	mov    %eax,%esi
  8009fb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fe:	39 f0                	cmp    %esi,%eax
  800a00:	74 1c                	je     800a1e <memcmp+0x34>
		if (*s1 != *s2)
  800a02:	0f b6 08             	movzbl (%eax),%ecx
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	38 d9                	cmp    %bl,%cl
  800a0a:	75 08                	jne    800a14 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	eb ea                	jmp    8009fe <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a14:	0f b6 c1             	movzbl %cl,%eax
  800a17:	0f b6 db             	movzbl %bl,%ebx
  800a1a:	29 d8                	sub    %ebx,%eax
  800a1c:	eb 05                	jmp    800a23 <memcmp+0x39>
	}

	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5b                   	pop    %ebx
  800a24:	5e                   	pop    %esi
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a27:	f3 0f 1e fb          	endbr32 
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a39:	39 d0                	cmp    %edx,%eax
  800a3b:	73 09                	jae    800a46 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a3d:	38 08                	cmp    %cl,(%eax)
  800a3f:	74 05                	je     800a46 <memfind+0x1f>
	for (; s < ends; s++)
  800a41:	83 c0 01             	add    $0x1,%eax
  800a44:	eb f3                	jmp    800a39 <memfind+0x12>
			break;
	return (void *) s;
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a48:	f3 0f 1e fb          	endbr32 
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	57                   	push   %edi
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a58:	eb 03                	jmp    800a5d <strtol+0x15>
		s++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a5d:	0f b6 01             	movzbl (%ecx),%eax
  800a60:	3c 20                	cmp    $0x20,%al
  800a62:	74 f6                	je     800a5a <strtol+0x12>
  800a64:	3c 09                	cmp    $0x9,%al
  800a66:	74 f2                	je     800a5a <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a68:	3c 2b                	cmp    $0x2b,%al
  800a6a:	74 2a                	je     800a96 <strtol+0x4e>
	int neg = 0;
  800a6c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a71:	3c 2d                	cmp    $0x2d,%al
  800a73:	74 2b                	je     800aa0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7b:	75 0f                	jne    800a8c <strtol+0x44>
  800a7d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a80:	74 28                	je     800aaa <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a89:	0f 44 d8             	cmove  %eax,%ebx
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a91:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a94:	eb 46                	jmp    800adc <strtol+0x94>
		s++;
  800a96:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a99:	bf 00 00 00 00       	mov    $0x0,%edi
  800a9e:	eb d5                	jmp    800a75 <strtol+0x2d>
		s++, neg = 1;
  800aa0:	83 c1 01             	add    $0x1,%ecx
  800aa3:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa8:	eb cb                	jmp    800a75 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aaa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aae:	74 0e                	je     800abe <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab0:	85 db                	test   %ebx,%ebx
  800ab2:	75 d8                	jne    800a8c <strtol+0x44>
		s++, base = 8;
  800ab4:	83 c1 01             	add    $0x1,%ecx
  800ab7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800abc:	eb ce                	jmp    800a8c <strtol+0x44>
		s += 2, base = 16;
  800abe:	83 c1 02             	add    $0x2,%ecx
  800ac1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ac6:	eb c4                	jmp    800a8c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ac8:	0f be d2             	movsbl %dl,%edx
  800acb:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ace:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ad1:	7d 3a                	jge    800b0d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800adc:	0f b6 11             	movzbl (%ecx),%edx
  800adf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ae2:	89 f3                	mov    %esi,%ebx
  800ae4:	80 fb 09             	cmp    $0x9,%bl
  800ae7:	76 df                	jbe    800ac8 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ae9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aec:	89 f3                	mov    %esi,%ebx
  800aee:	80 fb 19             	cmp    $0x19,%bl
  800af1:	77 08                	ja     800afb <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af3:	0f be d2             	movsbl %dl,%edx
  800af6:	83 ea 57             	sub    $0x57,%edx
  800af9:	eb d3                	jmp    800ace <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800afb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800afe:	89 f3                	mov    %esi,%ebx
  800b00:	80 fb 19             	cmp    $0x19,%bl
  800b03:	77 08                	ja     800b0d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b05:	0f be d2             	movsbl %dl,%edx
  800b08:	83 ea 37             	sub    $0x37,%edx
  800b0b:	eb c1                	jmp    800ace <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b11:	74 05                	je     800b18 <strtol+0xd0>
		*endptr = (char *) s;
  800b13:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b16:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	f7 da                	neg    %edx
  800b1c:	85 ff                	test   %edi,%edi
  800b1e:	0f 45 c2             	cmovne %edx,%eax
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b26:	f3 0f 1e fb          	endbr32 
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	8b 55 08             	mov    0x8(%ebp),%edx
  800b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3b:	89 c3                	mov    %eax,%ebx
  800b3d:	89 c7                	mov    %eax,%edi
  800b3f:	89 c6                	mov    %eax,%esi
  800b41:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5c:	89 d1                	mov    %edx,%ecx
  800b5e:	89 d3                	mov    %edx,%ebx
  800b60:	89 d7                	mov    %edx,%edi
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6b:	f3 0f 1e fb          	endbr32 
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	b8 03 00 00 00       	mov    $0x3,%eax
  800b85:	89 cb                	mov    %ecx,%ebx
  800b87:	89 cf                	mov    %ecx,%edi
  800b89:	89 ce                	mov    %ecx,%esi
  800b8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	7f 08                	jg     800b99 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	50                   	push   %eax
  800b9d:	6a 03                	push   $0x3
  800b9f:	68 7f 22 80 00       	push   $0x80227f
  800ba4:	6a 23                	push   $0x23
  800ba6:	68 9c 22 80 00       	push   $0x80229c
  800bab:	e8 a0 10 00 00       	call   801c50 <_panic>

00800bb0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bb0:	f3 0f 1e fb          	endbr32 
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_yield>:

void
sys_yield(void)
{
  800bd3:	f3 0f 1e fb          	endbr32 
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800be2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be7:	89 d1                	mov    %edx,%ecx
  800be9:	89 d3                	mov    %edx,%ebx
  800beb:	89 d7                	mov    %edx,%edi
  800bed:	89 d6                	mov    %edx,%esi
  800bef:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf6:	f3 0f 1e fb          	endbr32 
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c03:	be 00 00 00 00       	mov    $0x0,%esi
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c16:	89 f7                	mov    %esi,%edi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 04                	push   $0x4
  800c2c:	68 7f 22 80 00       	push   $0x80227f
  800c31:	6a 23                	push   $0x23
  800c33:	68 9c 22 80 00       	push   $0x80229c
  800c38:	e8 13 10 00 00       	call   801c50 <_panic>

00800c3d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3d:	f3 0f 1e fb          	endbr32 
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c50:	b8 05 00 00 00       	mov    $0x5,%eax
  800c55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c5b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c60:	85 c0                	test   %eax,%eax
  800c62:	7f 08                	jg     800c6c <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 05                	push   $0x5
  800c72:	68 7f 22 80 00       	push   $0x80227f
  800c77:	6a 23                	push   $0x23
  800c79:	68 9c 22 80 00       	push   $0x80229c
  800c7e:	e8 cd 0f 00 00       	call   801c50 <_panic>

00800c83 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c83:	f3 0f 1e fb          	endbr32 
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca0:	89 df                	mov    %ebx,%edi
  800ca2:	89 de                	mov    %ebx,%esi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 06                	push   $0x6
  800cb8:	68 7f 22 80 00       	push   $0x80227f
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 9c 22 80 00       	push   $0x80229c
  800cc4:	e8 87 0f 00 00       	call   801c50 <_panic>

00800cc9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 08                	push   $0x8
  800cfe:	68 7f 22 80 00       	push   $0x80227f
  800d03:	6a 23                	push   $0x23
  800d05:	68 9c 22 80 00       	push   $0x80229c
  800d0a:	e8 41 0f 00 00       	call   801c50 <_panic>

00800d0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d0f:	f3 0f 1e fb          	endbr32 
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 09                	push   $0x9
  800d44:	68 7f 22 80 00       	push   $0x80227f
  800d49:	6a 23                	push   $0x23
  800d4b:	68 9c 22 80 00       	push   $0x80229c
  800d50:	e8 fb 0e 00 00       	call   801c50 <_panic>

00800d55 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d55:	f3 0f 1e fb          	endbr32 
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 0a                	push   $0xa
  800d8a:	68 7f 22 80 00       	push   $0x80227f
  800d8f:	6a 23                	push   $0x23
  800d91:	68 9c 22 80 00       	push   $0x80229c
  800d96:	e8 b5 0e 00 00       	call   801c50 <_panic>

00800d9b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db0:	be 00 00 00 00       	mov    $0x0,%esi
  800db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	89 cb                	mov    %ecx,%ebx
  800dde:	89 cf                	mov    %ecx,%edi
  800de0:	89 ce                	mov    %ecx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 0d                	push   $0xd
  800df6:	68 7f 22 80 00       	push   $0x80227f
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 9c 22 80 00       	push   $0x80229c
  800e02:	e8 49 0e 00 00       	call   801c50 <_panic>

00800e07 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e07:	f3 0f 1e fb          	endbr32 
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	8b 75 08             	mov    0x8(%ebp),%esi
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800e20:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	50                   	push   %eax
  800e27:	e8 96 ff ff ff       	call   800dc2 <sys_ipc_recv>
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	78 2b                	js     800e5e <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  800e33:	85 f6                	test   %esi,%esi
  800e35:	74 0a                	je     800e41 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  800e37:	a1 04 40 80 00       	mov    0x804004,%eax
  800e3c:	8b 40 74             	mov    0x74(%eax),%eax
  800e3f:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	74 0a                	je     800e4f <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  800e45:	a1 04 40 80 00       	mov    0x804004,%eax
  800e4a:	8b 40 78             	mov    0x78(%eax),%eax
  800e4d:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  800e4f:	a1 04 40 80 00       	mov    0x804004,%eax
  800e54:	8b 40 70             	mov    0x70(%eax),%eax
}
  800e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		if(from_env_store)
  800e5e:	85 f6                	test   %esi,%esi
  800e60:	74 06                	je     800e68 <ipc_recv+0x61>
			*from_env_store=0;
  800e62:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  800e68:	85 db                	test   %ebx,%ebx
  800e6a:	74 eb                	je     800e57 <ipc_recv+0x50>
			*perm_store=0;
  800e6c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800e72:	eb e3                	jmp    800e57 <ipc_recv+0x50>

00800e74 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e74:	f3 0f 1e fb          	endbr32 
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  800e8a:	85 db                	test   %ebx,%ebx
  800e8c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800e91:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  800e94:	ff 75 14             	pushl  0x14(%ebp)
  800e97:	53                   	push   %ebx
  800e98:	56                   	push   %esi
  800e99:	57                   	push   %edi
  800e9a:	e8 fc fe ff ff       	call   800d9b <sys_ipc_try_send>
		if(!res)
  800e9f:	83 c4 10             	add    $0x10,%esp
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	74 20                	je     800ec6 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  800ea6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800ea9:	75 07                	jne    800eb2 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  800eab:	e8 23 fd ff ff       	call   800bd3 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  800eb0:	eb e2                	jmp    800e94 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	68 aa 22 80 00       	push   $0x8022aa
  800eba:	6a 3f                	push   $0x3f
  800ebc:	68 c2 22 80 00       	push   $0x8022c2
  800ec1:	e8 8a 0d 00 00       	call   801c50 <_panic>
	}
}
  800ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800ed8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800edd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800ee0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800ee6:	8b 52 50             	mov    0x50(%edx),%edx
  800ee9:	39 ca                	cmp    %ecx,%edx
  800eeb:	74 11                	je     800efe <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  800eed:	83 c0 01             	add    $0x1,%eax
  800ef0:	3d 00 04 00 00       	cmp    $0x400,%eax
  800ef5:	75 e6                	jne    800edd <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  800ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  800efc:	eb 0b                	jmp    800f09 <ipc_find_env+0x3b>
			return envs[i].env_id;
  800efe:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f01:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f06:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f0b:	f3 0f 1e fb          	endbr32 
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	05 00 00 00 30       	add    $0x30000000,%eax
  800f1a:	c1 e8 0c             	shr    $0xc,%eax
}
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f1f:	f3 0f 1e fb          	endbr32 
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f33:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f3a:	f3 0f 1e fb          	endbr32 
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f46:	89 c2                	mov    %eax,%edx
  800f48:	c1 ea 16             	shr    $0x16,%edx
  800f4b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f52:	f6 c2 01             	test   $0x1,%dl
  800f55:	74 2d                	je     800f84 <fd_alloc+0x4a>
  800f57:	89 c2                	mov    %eax,%edx
  800f59:	c1 ea 0c             	shr    $0xc,%edx
  800f5c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f63:	f6 c2 01             	test   $0x1,%dl
  800f66:	74 1c                	je     800f84 <fd_alloc+0x4a>
  800f68:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f6d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f72:	75 d2                	jne    800f46 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f7d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f82:	eb 0a                	jmp    800f8e <fd_alloc+0x54>
			*fd_store = fd;
  800f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f87:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f90:	f3 0f 1e fb          	endbr32 
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f9a:	83 f8 1f             	cmp    $0x1f,%eax
  800f9d:	77 30                	ja     800fcf <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f9f:	c1 e0 0c             	shl    $0xc,%eax
  800fa2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fa7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fad:	f6 c2 01             	test   $0x1,%dl
  800fb0:	74 24                	je     800fd6 <fd_lookup+0x46>
  800fb2:	89 c2                	mov    %eax,%edx
  800fb4:	c1 ea 0c             	shr    $0xc,%edx
  800fb7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fbe:	f6 c2 01             	test   $0x1,%dl
  800fc1:	74 1a                	je     800fdd <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc6:	89 02                	mov    %eax,(%edx)
	return 0;
  800fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    
		return -E_INVAL;
  800fcf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd4:	eb f7                	jmp    800fcd <fd_lookup+0x3d>
		return -E_INVAL;
  800fd6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdb:	eb f0                	jmp    800fcd <fd_lookup+0x3d>
  800fdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe2:	eb e9                	jmp    800fcd <fd_lookup+0x3d>

00800fe4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fe4:	f3 0f 1e fb          	endbr32 
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 08             	sub    $0x8,%esp
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	ba 48 23 80 00       	mov    $0x802348,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ff6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ffb:	39 08                	cmp    %ecx,(%eax)
  800ffd:	74 33                	je     801032 <dev_lookup+0x4e>
  800fff:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801002:	8b 02                	mov    (%edx),%eax
  801004:	85 c0                	test   %eax,%eax
  801006:	75 f3                	jne    800ffb <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801008:	a1 04 40 80 00       	mov    0x804004,%eax
  80100d:	8b 40 48             	mov    0x48(%eax),%eax
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	51                   	push   %ecx
  801014:	50                   	push   %eax
  801015:	68 cc 22 80 00       	push   $0x8022cc
  80101a:	e8 8b f1 ff ff       	call   8001aa <cprintf>
	*dev = 0;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801028:	83 c4 10             	add    $0x10,%esp
  80102b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    
			*dev = devtab[i];
  801032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801035:	89 01                	mov    %eax,(%ecx)
			return 0;
  801037:	b8 00 00 00 00       	mov    $0x0,%eax
  80103c:	eb f2                	jmp    801030 <dev_lookup+0x4c>

0080103e <fd_close>:
{
  80103e:	f3 0f 1e fb          	endbr32 
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	83 ec 24             	sub    $0x24,%esp
  80104b:	8b 75 08             	mov    0x8(%ebp),%esi
  80104e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801051:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801054:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801055:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105e:	50                   	push   %eax
  80105f:	e8 2c ff ff ff       	call   800f90 <fd_lookup>
  801064:	89 c3                	mov    %eax,%ebx
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	78 05                	js     801072 <fd_close+0x34>
	    || fd != fd2)
  80106d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801070:	74 16                	je     801088 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801072:	89 f8                	mov    %edi,%eax
  801074:	84 c0                	test   %al,%al
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
  80107b:	0f 44 d8             	cmove  %eax,%ebx
}
  80107e:	89 d8                	mov    %ebx,%eax
  801080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801088:	83 ec 08             	sub    $0x8,%esp
  80108b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80108e:	50                   	push   %eax
  80108f:	ff 36                	pushl  (%esi)
  801091:	e8 4e ff ff ff       	call   800fe4 <dev_lookup>
  801096:	89 c3                	mov    %eax,%ebx
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	85 c0                	test   %eax,%eax
  80109d:	78 1a                	js     8010b9 <fd_close+0x7b>
		if (dev->dev_close)
  80109f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010a2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 0b                	je     8010b9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010ae:	83 ec 0c             	sub    $0xc,%esp
  8010b1:	56                   	push   %esi
  8010b2:	ff d0                	call   *%eax
  8010b4:	89 c3                	mov    %eax,%ebx
  8010b6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	56                   	push   %esi
  8010bd:	6a 00                	push   $0x0
  8010bf:	e8 bf fb ff ff       	call   800c83 <sys_page_unmap>
	return r;
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	eb b5                	jmp    80107e <fd_close+0x40>

008010c9 <close>:

int
close(int fdnum)
{
  8010c9:	f3 0f 1e fb          	endbr32 
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 08             	pushl  0x8(%ebp)
  8010da:	e8 b1 fe ff ff       	call   800f90 <fd_lookup>
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	79 02                	jns    8010e8 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    
		return fd_close(fd, 1);
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	6a 01                	push   $0x1
  8010ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f0:	e8 49 ff ff ff       	call   80103e <fd_close>
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	eb ec                	jmp    8010e6 <close+0x1d>

008010fa <close_all>:

void
close_all(void)
{
  8010fa:	f3 0f 1e fb          	endbr32 
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	53                   	push   %ebx
  801102:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801105:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	53                   	push   %ebx
  80110e:	e8 b6 ff ff ff       	call   8010c9 <close>
	for (i = 0; i < MAXFD; i++)
  801113:	83 c3 01             	add    $0x1,%ebx
  801116:	83 c4 10             	add    $0x10,%esp
  801119:	83 fb 20             	cmp    $0x20,%ebx
  80111c:	75 ec                	jne    80110a <close_all+0x10>
}
  80111e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801123:	f3 0f 1e fb          	endbr32 
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	57                   	push   %edi
  80112b:	56                   	push   %esi
  80112c:	53                   	push   %ebx
  80112d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801130:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801133:	50                   	push   %eax
  801134:	ff 75 08             	pushl  0x8(%ebp)
  801137:	e8 54 fe ff ff       	call   800f90 <fd_lookup>
  80113c:	89 c3                	mov    %eax,%ebx
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	0f 88 81 00 00 00    	js     8011ca <dup+0xa7>
		return r;
	close(newfdnum);
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	ff 75 0c             	pushl  0xc(%ebp)
  80114f:	e8 75 ff ff ff       	call   8010c9 <close>

	newfd = INDEX2FD(newfdnum);
  801154:	8b 75 0c             	mov    0xc(%ebp),%esi
  801157:	c1 e6 0c             	shl    $0xc,%esi
  80115a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801160:	83 c4 04             	add    $0x4,%esp
  801163:	ff 75 e4             	pushl  -0x1c(%ebp)
  801166:	e8 b4 fd ff ff       	call   800f1f <fd2data>
  80116b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80116d:	89 34 24             	mov    %esi,(%esp)
  801170:	e8 aa fd ff ff       	call   800f1f <fd2data>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80117a:	89 d8                	mov    %ebx,%eax
  80117c:	c1 e8 16             	shr    $0x16,%eax
  80117f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801186:	a8 01                	test   $0x1,%al
  801188:	74 11                	je     80119b <dup+0x78>
  80118a:	89 d8                	mov    %ebx,%eax
  80118c:	c1 e8 0c             	shr    $0xc,%eax
  80118f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801196:	f6 c2 01             	test   $0x1,%dl
  801199:	75 39                	jne    8011d4 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80119b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	c1 e8 0c             	shr    $0xc,%eax
  8011a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b2:	50                   	push   %eax
  8011b3:	56                   	push   %esi
  8011b4:	6a 00                	push   $0x0
  8011b6:	52                   	push   %edx
  8011b7:	6a 00                	push   $0x0
  8011b9:	e8 7f fa ff ff       	call   800c3d <sys_page_map>
  8011be:	89 c3                	mov    %eax,%ebx
  8011c0:	83 c4 20             	add    $0x20,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	78 31                	js     8011f8 <dup+0xd5>
		goto err;

	return newfdnum;
  8011c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011ca:	89 d8                	mov    %ebx,%eax
  8011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cf:	5b                   	pop    %ebx
  8011d0:	5e                   	pop    %esi
  8011d1:	5f                   	pop    %edi
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e3:	50                   	push   %eax
  8011e4:	57                   	push   %edi
  8011e5:	6a 00                	push   $0x0
  8011e7:	53                   	push   %ebx
  8011e8:	6a 00                	push   $0x0
  8011ea:	e8 4e fa ff ff       	call   800c3d <sys_page_map>
  8011ef:	89 c3                	mov    %eax,%ebx
  8011f1:	83 c4 20             	add    $0x20,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	79 a3                	jns    80119b <dup+0x78>
	sys_page_unmap(0, newfd);
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	56                   	push   %esi
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 80 fa ff ff       	call   800c83 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801203:	83 c4 08             	add    $0x8,%esp
  801206:	57                   	push   %edi
  801207:	6a 00                	push   $0x0
  801209:	e8 75 fa ff ff       	call   800c83 <sys_page_unmap>
	return r;
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	eb b7                	jmp    8011ca <dup+0xa7>

00801213 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801213:	f3 0f 1e fb          	endbr32 
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	53                   	push   %ebx
  80121b:	83 ec 1c             	sub    $0x1c,%esp
  80121e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	53                   	push   %ebx
  801226:	e8 65 fd ff ff       	call   800f90 <fd_lookup>
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 3f                	js     801271 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123c:	ff 30                	pushl  (%eax)
  80123e:	e8 a1 fd ff ff       	call   800fe4 <dev_lookup>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	78 27                	js     801271 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80124a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124d:	8b 42 08             	mov    0x8(%edx),%eax
  801250:	83 e0 03             	and    $0x3,%eax
  801253:	83 f8 01             	cmp    $0x1,%eax
  801256:	74 1e                	je     801276 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125b:	8b 40 08             	mov    0x8(%eax),%eax
  80125e:	85 c0                	test   %eax,%eax
  801260:	74 35                	je     801297 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	ff 75 10             	pushl  0x10(%ebp)
  801268:	ff 75 0c             	pushl  0xc(%ebp)
  80126b:	52                   	push   %edx
  80126c:	ff d0                	call   *%eax
  80126e:	83 c4 10             	add    $0x10,%esp
}
  801271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801274:	c9                   	leave  
  801275:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801276:	a1 04 40 80 00       	mov    0x804004,%eax
  80127b:	8b 40 48             	mov    0x48(%eax),%eax
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	53                   	push   %ebx
  801282:	50                   	push   %eax
  801283:	68 0d 23 80 00       	push   $0x80230d
  801288:	e8 1d ef ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801295:	eb da                	jmp    801271 <read+0x5e>
		return -E_NOT_SUPP;
  801297:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80129c:	eb d3                	jmp    801271 <read+0x5e>

0080129e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80129e:	f3 0f 1e fb          	endbr32 
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	57                   	push   %edi
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b6:	eb 02                	jmp    8012ba <readn+0x1c>
  8012b8:	01 c3                	add    %eax,%ebx
  8012ba:	39 f3                	cmp    %esi,%ebx
  8012bc:	73 21                	jae    8012df <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	89 f0                	mov    %esi,%eax
  8012c3:	29 d8                	sub    %ebx,%eax
  8012c5:	50                   	push   %eax
  8012c6:	89 d8                	mov    %ebx,%eax
  8012c8:	03 45 0c             	add    0xc(%ebp),%eax
  8012cb:	50                   	push   %eax
  8012cc:	57                   	push   %edi
  8012cd:	e8 41 ff ff ff       	call   801213 <read>
		if (m < 0)
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 04                	js     8012dd <readn+0x3f>
			return m;
		if (m == 0)
  8012d9:	75 dd                	jne    8012b8 <readn+0x1a>
  8012db:	eb 02                	jmp    8012df <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012dd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012df:	89 d8                	mov    %ebx,%eax
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    

008012e9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012e9:	f3 0f 1e fb          	endbr32 
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	53                   	push   %ebx
  8012f1:	83 ec 1c             	sub    $0x1c,%esp
  8012f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012fa:	50                   	push   %eax
  8012fb:	53                   	push   %ebx
  8012fc:	e8 8f fc ff ff       	call   800f90 <fd_lookup>
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 3a                	js     801342 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801308:	83 ec 08             	sub    $0x8,%esp
  80130b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130e:	50                   	push   %eax
  80130f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801312:	ff 30                	pushl  (%eax)
  801314:	e8 cb fc ff ff       	call   800fe4 <dev_lookup>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 22                	js     801342 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801323:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801327:	74 1e                	je     801347 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132c:	8b 52 0c             	mov    0xc(%edx),%edx
  80132f:	85 d2                	test   %edx,%edx
  801331:	74 35                	je     801368 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	ff 75 10             	pushl  0x10(%ebp)
  801339:	ff 75 0c             	pushl  0xc(%ebp)
  80133c:	50                   	push   %eax
  80133d:	ff d2                	call   *%edx
  80133f:	83 c4 10             	add    $0x10,%esp
}
  801342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801345:	c9                   	leave  
  801346:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801347:	a1 04 40 80 00       	mov    0x804004,%eax
  80134c:	8b 40 48             	mov    0x48(%eax),%eax
  80134f:	83 ec 04             	sub    $0x4,%esp
  801352:	53                   	push   %ebx
  801353:	50                   	push   %eax
  801354:	68 29 23 80 00       	push   $0x802329
  801359:	e8 4c ee ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801366:	eb da                	jmp    801342 <write+0x59>
		return -E_NOT_SUPP;
  801368:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136d:	eb d3                	jmp    801342 <write+0x59>

0080136f <seek>:

int
seek(int fdnum, off_t offset)
{
  80136f:	f3 0f 1e fb          	endbr32 
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137c:	50                   	push   %eax
  80137d:	ff 75 08             	pushl  0x8(%ebp)
  801380:	e8 0b fc ff ff       	call   800f90 <fd_lookup>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	78 0e                	js     80139a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80138c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801392:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80139c:	f3 0f 1e fb          	endbr32 
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	53                   	push   %ebx
  8013a4:	83 ec 1c             	sub    $0x1c,%esp
  8013a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ad:	50                   	push   %eax
  8013ae:	53                   	push   %ebx
  8013af:	e8 dc fb ff ff       	call   800f90 <fd_lookup>
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 37                	js     8013f2 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c1:	50                   	push   %eax
  8013c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c5:	ff 30                	pushl  (%eax)
  8013c7:	e8 18 fc ff ff       	call   800fe4 <dev_lookup>
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 1f                	js     8013f2 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013da:	74 1b                	je     8013f7 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013df:	8b 52 18             	mov    0x18(%edx),%edx
  8013e2:	85 d2                	test   %edx,%edx
  8013e4:	74 32                	je     801418 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ec:	50                   	push   %eax
  8013ed:	ff d2                	call   *%edx
  8013ef:	83 c4 10             	add    $0x10,%esp
}
  8013f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013f7:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013fc:	8b 40 48             	mov    0x48(%eax),%eax
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	53                   	push   %ebx
  801403:	50                   	push   %eax
  801404:	68 ec 22 80 00       	push   $0x8022ec
  801409:	e8 9c ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801416:	eb da                	jmp    8013f2 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801418:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141d:	eb d3                	jmp    8013f2 <ftruncate+0x56>

0080141f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80141f:	f3 0f 1e fb          	endbr32 
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	53                   	push   %ebx
  801427:	83 ec 1c             	sub    $0x1c,%esp
  80142a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801430:	50                   	push   %eax
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	e8 57 fb ff ff       	call   800f90 <fd_lookup>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 4b                	js     80148b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801440:	83 ec 08             	sub    $0x8,%esp
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144a:	ff 30                	pushl  (%eax)
  80144c:	e8 93 fb ff ff       	call   800fe4 <dev_lookup>
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 33                	js     80148b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80145f:	74 2f                	je     801490 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801461:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801464:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80146b:	00 00 00 
	stat->st_isdir = 0;
  80146e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801475:	00 00 00 
	stat->st_dev = dev;
  801478:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	53                   	push   %ebx
  801482:	ff 75 f0             	pushl  -0x10(%ebp)
  801485:	ff 50 14             	call   *0x14(%eax)
  801488:	83 c4 10             	add    $0x10,%esp
}
  80148b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    
		return -E_NOT_SUPP;
  801490:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801495:	eb f4                	jmp    80148b <fstat+0x6c>

00801497 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801497:	f3 0f 1e fb          	endbr32 
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	56                   	push   %esi
  80149f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	6a 00                	push   $0x0
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 fb 01 00 00       	call   8016a8 <open>
  8014ad:	89 c3                	mov    %eax,%ebx
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 1b                	js     8014d1 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	50                   	push   %eax
  8014bd:	e8 5d ff ff ff       	call   80141f <fstat>
  8014c2:	89 c6                	mov    %eax,%esi
	close(fd);
  8014c4:	89 1c 24             	mov    %ebx,(%esp)
  8014c7:	e8 fd fb ff ff       	call   8010c9 <close>
	return r;
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	89 f3                	mov    %esi,%ebx
}
  8014d1:	89 d8                	mov    %ebx,%eax
  8014d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d6:	5b                   	pop    %ebx
  8014d7:	5e                   	pop    %esi
  8014d8:	5d                   	pop    %ebp
  8014d9:	c3                   	ret    

008014da <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	56                   	push   %esi
  8014de:	53                   	push   %ebx
  8014df:	89 c6                	mov    %eax,%esi
  8014e1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014e3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014ea:	74 27                	je     801513 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ec:	6a 07                	push   $0x7
  8014ee:	68 00 50 80 00       	push   $0x805000
  8014f3:	56                   	push   %esi
  8014f4:	ff 35 00 40 80 00    	pushl  0x804000
  8014fa:	e8 75 f9 ff ff       	call   800e74 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014ff:	83 c4 0c             	add    $0xc,%esp
  801502:	6a 00                	push   $0x0
  801504:	53                   	push   %ebx
  801505:	6a 00                	push   $0x0
  801507:	e8 fb f8 ff ff       	call   800e07 <ipc_recv>
}
  80150c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	6a 01                	push   $0x1
  801518:	e8 b1 f9 ff ff       	call   800ece <ipc_find_env>
  80151d:	a3 00 40 80 00       	mov    %eax,0x804000
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	eb c5                	jmp    8014ec <fsipc+0x12>

00801527 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801527:	f3 0f 1e fb          	endbr32 
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8b 40 0c             	mov    0xc(%eax),%eax
  801537:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801544:	ba 00 00 00 00       	mov    $0x0,%edx
  801549:	b8 02 00 00 00       	mov    $0x2,%eax
  80154e:	e8 87 ff ff ff       	call   8014da <fsipc>
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <devfile_flush>:
{
  801555:	f3 0f 1e fb          	endbr32 
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8b 40 0c             	mov    0xc(%eax),%eax
  801565:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80156a:	ba 00 00 00 00       	mov    $0x0,%edx
  80156f:	b8 06 00 00 00       	mov    $0x6,%eax
  801574:	e8 61 ff ff ff       	call   8014da <fsipc>
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <devfile_stat>:
{
  80157b:	f3 0f 1e fb          	endbr32 
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8b 40 0c             	mov    0xc(%eax),%eax
  80158f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801594:	ba 00 00 00 00       	mov    $0x0,%edx
  801599:	b8 05 00 00 00       	mov    $0x5,%eax
  80159e:	e8 37 ff ff ff       	call   8014da <fsipc>
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 2c                	js     8015d3 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	68 00 50 80 00       	push   $0x805000
  8015af:	53                   	push   %ebx
  8015b0:	e8 ff f1 ff ff       	call   8007b4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015b5:	a1 80 50 80 00       	mov    0x805080,%eax
  8015ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015c0:	a1 84 50 80 00       	mov    0x805084,%eax
  8015c5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <devfile_write>:
{
  8015d8:	f3 0f 1e fb          	endbr32 
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 0c             	sub    $0xc,%esp
  8015e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e5:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015ea:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015ef:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f5:	8b 52 0c             	mov    0xc(%edx),%edx
  8015f8:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8015fe:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801603:	50                   	push   %eax
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	68 08 50 80 00       	push   $0x805008
  80160c:	e8 59 f3 ff ff       	call   80096a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801611:	ba 00 00 00 00       	mov    $0x0,%edx
  801616:	b8 04 00 00 00       	mov    $0x4,%eax
  80161b:	e8 ba fe ff ff       	call   8014da <fsipc>
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <devfile_read>:
{
  801622:	f3 0f 1e fb          	endbr32 
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	56                   	push   %esi
  80162a:	53                   	push   %ebx
  80162b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	8b 40 0c             	mov    0xc(%eax),%eax
  801634:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801639:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	b8 03 00 00 00       	mov    $0x3,%eax
  801649:	e8 8c fe ff ff       	call   8014da <fsipc>
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	85 c0                	test   %eax,%eax
  801652:	78 1f                	js     801673 <devfile_read+0x51>
	assert(r <= n);
  801654:	39 f0                	cmp    %esi,%eax
  801656:	77 24                	ja     80167c <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801658:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80165d:	7f 33                	jg     801692 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	50                   	push   %eax
  801663:	68 00 50 80 00       	push   $0x805000
  801668:	ff 75 0c             	pushl  0xc(%ebp)
  80166b:	e8 fa f2 ff ff       	call   80096a <memmove>
	return r;
  801670:	83 c4 10             	add    $0x10,%esp
}
  801673:	89 d8                	mov    %ebx,%eax
  801675:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    
	assert(r <= n);
  80167c:	68 58 23 80 00       	push   $0x802358
  801681:	68 5f 23 80 00       	push   $0x80235f
  801686:	6a 7d                	push   $0x7d
  801688:	68 74 23 80 00       	push   $0x802374
  80168d:	e8 be 05 00 00       	call   801c50 <_panic>
	assert(r <= PGSIZE);
  801692:	68 7f 23 80 00       	push   $0x80237f
  801697:	68 5f 23 80 00       	push   $0x80235f
  80169c:	6a 7e                	push   $0x7e
  80169e:	68 74 23 80 00       	push   $0x802374
  8016a3:	e8 a8 05 00 00       	call   801c50 <_panic>

008016a8 <open>:
{
  8016a8:	f3 0f 1e fb          	endbr32 
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 1c             	sub    $0x1c,%esp
  8016b4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016b7:	56                   	push   %esi
  8016b8:	e8 b4 f0 ff ff       	call   800771 <strlen>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016c5:	7f 6c                	jg     801733 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016c7:	83 ec 0c             	sub    $0xc,%esp
  8016ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cd:	50                   	push   %eax
  8016ce:	e8 67 f8 ff ff       	call   800f3a <fd_alloc>
  8016d3:	89 c3                	mov    %eax,%ebx
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 3c                	js     801718 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	56                   	push   %esi
  8016e0:	68 00 50 80 00       	push   $0x805000
  8016e5:	e8 ca f0 ff ff       	call   8007b4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ed:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8016fa:	e8 db fd ff ff       	call   8014da <fsipc>
  8016ff:	89 c3                	mov    %eax,%ebx
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	85 c0                	test   %eax,%eax
  801706:	78 19                	js     801721 <open+0x79>
	return fd2num(fd);
  801708:	83 ec 0c             	sub    $0xc,%esp
  80170b:	ff 75 f4             	pushl  -0xc(%ebp)
  80170e:	e8 f8 f7 ff ff       	call   800f0b <fd2num>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
}
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5e                   	pop    %esi
  80171f:	5d                   	pop    %ebp
  801720:	c3                   	ret    
		fd_close(fd, 0);
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	6a 00                	push   $0x0
  801726:	ff 75 f4             	pushl  -0xc(%ebp)
  801729:	e8 10 f9 ff ff       	call   80103e <fd_close>
		return r;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	eb e5                	jmp    801718 <open+0x70>
		return -E_BAD_PATH;
  801733:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801738:	eb de                	jmp    801718 <open+0x70>

0080173a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80173a:	f3 0f 1e fb          	endbr32 
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 08 00 00 00       	mov    $0x8,%eax
  80174e:	e8 87 fd ff ff       	call   8014da <fsipc>
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801755:	f3 0f 1e fb          	endbr32 
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	e8 b3 f7 ff ff       	call   800f1f <fd2data>
  80176c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80176e:	83 c4 08             	add    $0x8,%esp
  801771:	68 8b 23 80 00       	push   $0x80238b
  801776:	53                   	push   %ebx
  801777:	e8 38 f0 ff ff       	call   8007b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80177c:	8b 46 04             	mov    0x4(%esi),%eax
  80177f:	2b 06                	sub    (%esi),%eax
  801781:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801787:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80178e:	00 00 00 
	stat->st_dev = &devpipe;
  801791:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801798:	30 80 00 
	return 0;
}
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017a7:	f3 0f 1e fb          	endbr32 
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	53                   	push   %ebx
  8017af:	83 ec 0c             	sub    $0xc,%esp
  8017b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017b5:	53                   	push   %ebx
  8017b6:	6a 00                	push   $0x0
  8017b8:	e8 c6 f4 ff ff       	call   800c83 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017bd:	89 1c 24             	mov    %ebx,(%esp)
  8017c0:	e8 5a f7 ff ff       	call   800f1f <fd2data>
  8017c5:	83 c4 08             	add    $0x8,%esp
  8017c8:	50                   	push   %eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	e8 b3 f4 ff ff       	call   800c83 <sys_page_unmap>
}
  8017d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <_pipeisclosed>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	57                   	push   %edi
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	83 ec 1c             	sub    $0x1c,%esp
  8017de:	89 c7                	mov    %eax,%edi
  8017e0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017e2:	a1 04 40 80 00       	mov    0x804004,%eax
  8017e7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017ea:	83 ec 0c             	sub    $0xc,%esp
  8017ed:	57                   	push   %edi
  8017ee:	e8 a7 04 00 00       	call   801c9a <pageref>
  8017f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017f6:	89 34 24             	mov    %esi,(%esp)
  8017f9:	e8 9c 04 00 00       	call   801c9a <pageref>
		nn = thisenv->env_runs;
  8017fe:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801804:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	39 cb                	cmp    %ecx,%ebx
  80180c:	74 1b                	je     801829 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80180e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801811:	75 cf                	jne    8017e2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801813:	8b 42 58             	mov    0x58(%edx),%eax
  801816:	6a 01                	push   $0x1
  801818:	50                   	push   %eax
  801819:	53                   	push   %ebx
  80181a:	68 92 23 80 00       	push   $0x802392
  80181f:	e8 86 e9 ff ff       	call   8001aa <cprintf>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	eb b9                	jmp    8017e2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801829:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80182c:	0f 94 c0             	sete   %al
  80182f:	0f b6 c0             	movzbl %al,%eax
}
  801832:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5f                   	pop    %edi
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    

0080183a <devpipe_write>:
{
  80183a:	f3 0f 1e fb          	endbr32 
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	57                   	push   %edi
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	83 ec 28             	sub    $0x28,%esp
  801847:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80184a:	56                   	push   %esi
  80184b:	e8 cf f6 ff ff       	call   800f1f <fd2data>
  801850:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	bf 00 00 00 00       	mov    $0x0,%edi
  80185a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80185d:	74 4f                	je     8018ae <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80185f:	8b 43 04             	mov    0x4(%ebx),%eax
  801862:	8b 0b                	mov    (%ebx),%ecx
  801864:	8d 51 20             	lea    0x20(%ecx),%edx
  801867:	39 d0                	cmp    %edx,%eax
  801869:	72 14                	jb     80187f <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80186b:	89 da                	mov    %ebx,%edx
  80186d:	89 f0                	mov    %esi,%eax
  80186f:	e8 61 ff ff ff       	call   8017d5 <_pipeisclosed>
  801874:	85 c0                	test   %eax,%eax
  801876:	75 3b                	jne    8018b3 <devpipe_write+0x79>
			sys_yield();
  801878:	e8 56 f3 ff ff       	call   800bd3 <sys_yield>
  80187d:	eb e0                	jmp    80185f <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80187f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801882:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801886:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801889:	89 c2                	mov    %eax,%edx
  80188b:	c1 fa 1f             	sar    $0x1f,%edx
  80188e:	89 d1                	mov    %edx,%ecx
  801890:	c1 e9 1b             	shr    $0x1b,%ecx
  801893:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801896:	83 e2 1f             	and    $0x1f,%edx
  801899:	29 ca                	sub    %ecx,%edx
  80189b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80189f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018a3:	83 c0 01             	add    $0x1,%eax
  8018a6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018a9:	83 c7 01             	add    $0x1,%edi
  8018ac:	eb ac                	jmp    80185a <devpipe_write+0x20>
	return i;
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	eb 05                	jmp    8018b8 <devpipe_write+0x7e>
				return 0;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <devpipe_read>:
{
  8018c0:	f3 0f 1e fb          	endbr32 
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	57                   	push   %edi
  8018c8:	56                   	push   %esi
  8018c9:	53                   	push   %ebx
  8018ca:	83 ec 18             	sub    $0x18,%esp
  8018cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018d0:	57                   	push   %edi
  8018d1:	e8 49 f6 ff ff       	call   800f1f <fd2data>
  8018d6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	be 00 00 00 00       	mov    $0x0,%esi
  8018e0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018e3:	75 14                	jne    8018f9 <devpipe_read+0x39>
	return i;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	eb 02                	jmp    8018ec <devpipe_read+0x2c>
				return i;
  8018ea:	89 f0                	mov    %esi,%eax
}
  8018ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5f                   	pop    %edi
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    
			sys_yield();
  8018f4:	e8 da f2 ff ff       	call   800bd3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8018f9:	8b 03                	mov    (%ebx),%eax
  8018fb:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018fe:	75 18                	jne    801918 <devpipe_read+0x58>
			if (i > 0)
  801900:	85 f6                	test   %esi,%esi
  801902:	75 e6                	jne    8018ea <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801904:	89 da                	mov    %ebx,%edx
  801906:	89 f8                	mov    %edi,%eax
  801908:	e8 c8 fe ff ff       	call   8017d5 <_pipeisclosed>
  80190d:	85 c0                	test   %eax,%eax
  80190f:	74 e3                	je     8018f4 <devpipe_read+0x34>
				return 0;
  801911:	b8 00 00 00 00       	mov    $0x0,%eax
  801916:	eb d4                	jmp    8018ec <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801918:	99                   	cltd   
  801919:	c1 ea 1b             	shr    $0x1b,%edx
  80191c:	01 d0                	add    %edx,%eax
  80191e:	83 e0 1f             	and    $0x1f,%eax
  801921:	29 d0                	sub    %edx,%eax
  801923:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801928:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80192e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801931:	83 c6 01             	add    $0x1,%esi
  801934:	eb aa                	jmp    8018e0 <devpipe_read+0x20>

00801936 <pipe>:
{
  801936:	f3 0f 1e fb          	endbr32 
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	56                   	push   %esi
  80193e:	53                   	push   %ebx
  80193f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801942:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801945:	50                   	push   %eax
  801946:	e8 ef f5 ff ff       	call   800f3a <fd_alloc>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	0f 88 23 01 00 00    	js     801a7b <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 07 04 00 00       	push   $0x407
  801960:	ff 75 f4             	pushl  -0xc(%ebp)
  801963:	6a 00                	push   $0x0
  801965:	e8 8c f2 ff ff       	call   800bf6 <sys_page_alloc>
  80196a:	89 c3                	mov    %eax,%ebx
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	0f 88 04 01 00 00    	js     801a7b <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197d:	50                   	push   %eax
  80197e:	e8 b7 f5 ff ff       	call   800f3a <fd_alloc>
  801983:	89 c3                	mov    %eax,%ebx
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	0f 88 db 00 00 00    	js     801a6b <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	68 07 04 00 00       	push   $0x407
  801998:	ff 75 f0             	pushl  -0x10(%ebp)
  80199b:	6a 00                	push   $0x0
  80199d:	e8 54 f2 ff ff       	call   800bf6 <sys_page_alloc>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	0f 88 bc 00 00 00    	js     801a6b <pipe+0x135>
	va = fd2data(fd0);
  8019af:	83 ec 0c             	sub    $0xc,%esp
  8019b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b5:	e8 65 f5 ff ff       	call   800f1f <fd2data>
  8019ba:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019bc:	83 c4 0c             	add    $0xc,%esp
  8019bf:	68 07 04 00 00       	push   $0x407
  8019c4:	50                   	push   %eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	e8 2a f2 ff ff       	call   800bf6 <sys_page_alloc>
  8019cc:	89 c3                	mov    %eax,%ebx
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	0f 88 82 00 00 00    	js     801a5b <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8019df:	e8 3b f5 ff ff       	call   800f1f <fd2data>
  8019e4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019eb:	50                   	push   %eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	56                   	push   %esi
  8019ef:	6a 00                	push   $0x0
  8019f1:	e8 47 f2 ff ff       	call   800c3d <sys_page_map>
  8019f6:	89 c3                	mov    %eax,%ebx
  8019f8:	83 c4 20             	add    $0x20,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 4e                	js     801a4d <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8019ff:	a1 20 30 80 00       	mov    0x803020,%eax
  801a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a07:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a16:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a22:	83 ec 0c             	sub    $0xc,%esp
  801a25:	ff 75 f4             	pushl  -0xc(%ebp)
  801a28:	e8 de f4 ff ff       	call   800f0b <fd2num>
  801a2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a30:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a32:	83 c4 04             	add    $0x4,%esp
  801a35:	ff 75 f0             	pushl  -0x10(%ebp)
  801a38:	e8 ce f4 ff ff       	call   800f0b <fd2num>
  801a3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a40:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4b:	eb 2e                	jmp    801a7b <pipe+0x145>
	sys_page_unmap(0, va);
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	56                   	push   %esi
  801a51:	6a 00                	push   $0x0
  801a53:	e8 2b f2 ff ff       	call   800c83 <sys_page_unmap>
  801a58:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801a61:	6a 00                	push   $0x0
  801a63:	e8 1b f2 ff ff       	call   800c83 <sys_page_unmap>
  801a68:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a71:	6a 00                	push   $0x0
  801a73:	e8 0b f2 ff ff       	call   800c83 <sys_page_unmap>
  801a78:	83 c4 10             	add    $0x10,%esp
}
  801a7b:	89 d8                	mov    %ebx,%eax
  801a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    

00801a84 <pipeisclosed>:
{
  801a84:	f3 0f 1e fb          	endbr32 
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a91:	50                   	push   %eax
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	e8 f6 f4 ff ff       	call   800f90 <fd_lookup>
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 18                	js     801ab9 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801aa1:	83 ec 0c             	sub    $0xc,%esp
  801aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa7:	e8 73 f4 ff ff       	call   800f1f <fd2data>
  801aac:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	e8 1f fd ff ff       	call   8017d5 <_pipeisclosed>
  801ab6:	83 c4 10             	add    $0x10,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801abb:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac4:	c3                   	ret    

00801ac5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ac5:	f3 0f 1e fb          	endbr32 
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801acf:	68 aa 23 80 00       	push   $0x8023aa
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	e8 d8 ec ff ff       	call   8007b4 <strcpy>
	return 0;
}
  801adc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <devcons_write>:
{
  801ae3:	f3 0f 1e fb          	endbr32 
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	57                   	push   %edi
  801aeb:	56                   	push   %esi
  801aec:	53                   	push   %ebx
  801aed:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801af3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801af8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801afe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b01:	73 31                	jae    801b34 <devcons_write+0x51>
		m = n - tot;
  801b03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b06:	29 f3                	sub    %esi,%ebx
  801b08:	83 fb 7f             	cmp    $0x7f,%ebx
  801b0b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b10:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	53                   	push   %ebx
  801b17:	89 f0                	mov    %esi,%eax
  801b19:	03 45 0c             	add    0xc(%ebp),%eax
  801b1c:	50                   	push   %eax
  801b1d:	57                   	push   %edi
  801b1e:	e8 47 ee ff ff       	call   80096a <memmove>
		sys_cputs(buf, m);
  801b23:	83 c4 08             	add    $0x8,%esp
  801b26:	53                   	push   %ebx
  801b27:	57                   	push   %edi
  801b28:	e8 f9 ef ff ff       	call   800b26 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b2d:	01 de                	add    %ebx,%esi
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	eb ca                	jmp    801afe <devcons_write+0x1b>
}
  801b34:	89 f0                	mov    %esi,%eax
  801b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5f                   	pop    %edi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <devcons_read>:
{
  801b3e:	f3 0f 1e fb          	endbr32 
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b51:	74 21                	je     801b74 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801b53:	e8 f0 ef ff ff       	call   800b48 <sys_cgetc>
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	75 07                	jne    801b63 <devcons_read+0x25>
		sys_yield();
  801b5c:	e8 72 f0 ff ff       	call   800bd3 <sys_yield>
  801b61:	eb f0                	jmp    801b53 <devcons_read+0x15>
	if (c < 0)
  801b63:	78 0f                	js     801b74 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801b65:	83 f8 04             	cmp    $0x4,%eax
  801b68:	74 0c                	je     801b76 <devcons_read+0x38>
	*(char*)vbuf = c;
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	88 02                	mov    %al,(%edx)
	return 1;
  801b6f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
		return 0;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	eb f7                	jmp    801b74 <devcons_read+0x36>

00801b7d <cputchar>:
{
  801b7d:	f3 0f 1e fb          	endbr32 
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b8d:	6a 01                	push   $0x1
  801b8f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b92:	50                   	push   %eax
  801b93:	e8 8e ef ff ff       	call   800b26 <sys_cputs>
}
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <getchar>:
{
  801b9d:	f3 0f 1e fb          	endbr32 
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ba7:	6a 01                	push   $0x1
  801ba9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bac:	50                   	push   %eax
  801bad:	6a 00                	push   $0x0
  801baf:	e8 5f f6 ff ff       	call   801213 <read>
	if (r < 0)
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 06                	js     801bc1 <getchar+0x24>
	if (r < 1)
  801bbb:	74 06                	je     801bc3 <getchar+0x26>
	return c;
  801bbd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    
		return -E_EOF;
  801bc3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bc8:	eb f7                	jmp    801bc1 <getchar+0x24>

00801bca <iscons>:
{
  801bca:	f3 0f 1e fb          	endbr32 
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd7:	50                   	push   %eax
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	e8 b0 f3 ff ff       	call   800f90 <fd_lookup>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 11                	js     801bf8 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bea:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bf0:	39 10                	cmp    %edx,(%eax)
  801bf2:	0f 94 c0             	sete   %al
  801bf5:	0f b6 c0             	movzbl %al,%eax
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <opencons>:
{
  801bfa:	f3 0f 1e fb          	endbr32 
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c07:	50                   	push   %eax
  801c08:	e8 2d f3 ff ff       	call   800f3a <fd_alloc>
  801c0d:	83 c4 10             	add    $0x10,%esp
  801c10:	85 c0                	test   %eax,%eax
  801c12:	78 3a                	js     801c4e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	68 07 04 00 00       	push   $0x407
  801c1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1f:	6a 00                	push   $0x0
  801c21:	e8 d0 ef ff ff       	call   800bf6 <sys_page_alloc>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 21                	js     801c4e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c30:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c36:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c42:	83 ec 0c             	sub    $0xc,%esp
  801c45:	50                   	push   %eax
  801c46:	e8 c0 f2 ff ff       	call   800f0b <fd2num>
  801c4b:	83 c4 10             	add    $0x10,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c50:	f3 0f 1e fb          	endbr32 
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801c59:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c5c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801c62:	e8 49 ef ff ff       	call   800bb0 <sys_getenvid>
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	56                   	push   %esi
  801c71:	50                   	push   %eax
  801c72:	68 b8 23 80 00       	push   $0x8023b8
  801c77:	e8 2e e5 ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c7c:	83 c4 18             	add    $0x18,%esp
  801c7f:	53                   	push   %ebx
  801c80:	ff 75 10             	pushl  0x10(%ebp)
  801c83:	e8 cd e4 ff ff       	call   800155 <vcprintf>
	cprintf("\n");
  801c88:	c7 04 24 a3 23 80 00 	movl   $0x8023a3,(%esp)
  801c8f:	e8 16 e5 ff ff       	call   8001aa <cprintf>
  801c94:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c97:	cc                   	int3   
  801c98:	eb fd                	jmp    801c97 <_panic+0x47>

00801c9a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c9a:	f3 0f 1e fb          	endbr32 
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ca4:	89 c2                	mov    %eax,%edx
  801ca6:	c1 ea 16             	shr    $0x16,%edx
  801ca9:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801cb0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801cb5:	f6 c1 01             	test   $0x1,%cl
  801cb8:	74 1c                	je     801cd6 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801cba:	c1 e8 0c             	shr    $0xc,%eax
  801cbd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cc4:	a8 01                	test   $0x1,%al
  801cc6:	74 0e                	je     801cd6 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cc8:	c1 e8 0c             	shr    $0xc,%eax
  801ccb:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801cd2:	ef 
  801cd3:	0f b7 d2             	movzwl %dx,%edx
}
  801cd6:	89 d0                	mov    %edx,%eax
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	66 90                	xchg   %ax,%ax
  801cde:	66 90                	xchg   %ax,%ax

00801ce0 <__udivdi3>:
  801ce0:	f3 0f 1e fb          	endbr32 
  801ce4:	55                   	push   %ebp
  801ce5:	57                   	push   %edi
  801ce6:	56                   	push   %esi
  801ce7:	53                   	push   %ebx
  801ce8:	83 ec 1c             	sub    $0x1c,%esp
  801ceb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cf7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cfb:	85 d2                	test   %edx,%edx
  801cfd:	75 19                	jne    801d18 <__udivdi3+0x38>
  801cff:	39 f3                	cmp    %esi,%ebx
  801d01:	76 4d                	jbe    801d50 <__udivdi3+0x70>
  801d03:	31 ff                	xor    %edi,%edi
  801d05:	89 e8                	mov    %ebp,%eax
  801d07:	89 f2                	mov    %esi,%edx
  801d09:	f7 f3                	div    %ebx
  801d0b:	89 fa                	mov    %edi,%edx
  801d0d:	83 c4 1c             	add    $0x1c,%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5f                   	pop    %edi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
  801d15:	8d 76 00             	lea    0x0(%esi),%esi
  801d18:	39 f2                	cmp    %esi,%edx
  801d1a:	76 14                	jbe    801d30 <__udivdi3+0x50>
  801d1c:	31 ff                	xor    %edi,%edi
  801d1e:	31 c0                	xor    %eax,%eax
  801d20:	89 fa                	mov    %edi,%edx
  801d22:	83 c4 1c             	add    $0x1c,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
  801d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d30:	0f bd fa             	bsr    %edx,%edi
  801d33:	83 f7 1f             	xor    $0x1f,%edi
  801d36:	75 48                	jne    801d80 <__udivdi3+0xa0>
  801d38:	39 f2                	cmp    %esi,%edx
  801d3a:	72 06                	jb     801d42 <__udivdi3+0x62>
  801d3c:	31 c0                	xor    %eax,%eax
  801d3e:	39 eb                	cmp    %ebp,%ebx
  801d40:	77 de                	ja     801d20 <__udivdi3+0x40>
  801d42:	b8 01 00 00 00       	mov    $0x1,%eax
  801d47:	eb d7                	jmp    801d20 <__udivdi3+0x40>
  801d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d50:	89 d9                	mov    %ebx,%ecx
  801d52:	85 db                	test   %ebx,%ebx
  801d54:	75 0b                	jne    801d61 <__udivdi3+0x81>
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f3                	div    %ebx
  801d5f:	89 c1                	mov    %eax,%ecx
  801d61:	31 d2                	xor    %edx,%edx
  801d63:	89 f0                	mov    %esi,%eax
  801d65:	f7 f1                	div    %ecx
  801d67:	89 c6                	mov    %eax,%esi
  801d69:	89 e8                	mov    %ebp,%eax
  801d6b:	89 f7                	mov    %esi,%edi
  801d6d:	f7 f1                	div    %ecx
  801d6f:	89 fa                	mov    %edi,%edx
  801d71:	83 c4 1c             	add    $0x1c,%esp
  801d74:	5b                   	pop    %ebx
  801d75:	5e                   	pop    %esi
  801d76:	5f                   	pop    %edi
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    
  801d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d80:	89 f9                	mov    %edi,%ecx
  801d82:	b8 20 00 00 00       	mov    $0x20,%eax
  801d87:	29 f8                	sub    %edi,%eax
  801d89:	d3 e2                	shl    %cl,%edx
  801d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d8f:	89 c1                	mov    %eax,%ecx
  801d91:	89 da                	mov    %ebx,%edx
  801d93:	d3 ea                	shr    %cl,%edx
  801d95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d99:	09 d1                	or     %edx,%ecx
  801d9b:	89 f2                	mov    %esi,%edx
  801d9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801da1:	89 f9                	mov    %edi,%ecx
  801da3:	d3 e3                	shl    %cl,%ebx
  801da5:	89 c1                	mov    %eax,%ecx
  801da7:	d3 ea                	shr    %cl,%edx
  801da9:	89 f9                	mov    %edi,%ecx
  801dab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801daf:	89 eb                	mov    %ebp,%ebx
  801db1:	d3 e6                	shl    %cl,%esi
  801db3:	89 c1                	mov    %eax,%ecx
  801db5:	d3 eb                	shr    %cl,%ebx
  801db7:	09 de                	or     %ebx,%esi
  801db9:	89 f0                	mov    %esi,%eax
  801dbb:	f7 74 24 08          	divl   0x8(%esp)
  801dbf:	89 d6                	mov    %edx,%esi
  801dc1:	89 c3                	mov    %eax,%ebx
  801dc3:	f7 64 24 0c          	mull   0xc(%esp)
  801dc7:	39 d6                	cmp    %edx,%esi
  801dc9:	72 15                	jb     801de0 <__udivdi3+0x100>
  801dcb:	89 f9                	mov    %edi,%ecx
  801dcd:	d3 e5                	shl    %cl,%ebp
  801dcf:	39 c5                	cmp    %eax,%ebp
  801dd1:	73 04                	jae    801dd7 <__udivdi3+0xf7>
  801dd3:	39 d6                	cmp    %edx,%esi
  801dd5:	74 09                	je     801de0 <__udivdi3+0x100>
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	31 ff                	xor    %edi,%edi
  801ddb:	e9 40 ff ff ff       	jmp    801d20 <__udivdi3+0x40>
  801de0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801de3:	31 ff                	xor    %edi,%edi
  801de5:	e9 36 ff ff ff       	jmp    801d20 <__udivdi3+0x40>
  801dea:	66 90                	xchg   %ax,%ax
  801dec:	66 90                	xchg   %ax,%ax
  801dee:	66 90                	xchg   %ax,%ax

00801df0 <__umoddi3>:
  801df0:	f3 0f 1e fb          	endbr32 
  801df4:	55                   	push   %ebp
  801df5:	57                   	push   %edi
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 1c             	sub    $0x1c,%esp
  801dfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e03:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	75 19                	jne    801e28 <__umoddi3+0x38>
  801e0f:	39 df                	cmp    %ebx,%edi
  801e11:	76 5d                	jbe    801e70 <__umoddi3+0x80>
  801e13:	89 f0                	mov    %esi,%eax
  801e15:	89 da                	mov    %ebx,%edx
  801e17:	f7 f7                	div    %edi
  801e19:	89 d0                	mov    %edx,%eax
  801e1b:	31 d2                	xor    %edx,%edx
  801e1d:	83 c4 1c             	add    $0x1c,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5f                   	pop    %edi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    
  801e25:	8d 76 00             	lea    0x0(%esi),%esi
  801e28:	89 f2                	mov    %esi,%edx
  801e2a:	39 d8                	cmp    %ebx,%eax
  801e2c:	76 12                	jbe    801e40 <__umoddi3+0x50>
  801e2e:	89 f0                	mov    %esi,%eax
  801e30:	89 da                	mov    %ebx,%edx
  801e32:	83 c4 1c             	add    $0x1c,%esp
  801e35:	5b                   	pop    %ebx
  801e36:	5e                   	pop    %esi
  801e37:	5f                   	pop    %edi
  801e38:	5d                   	pop    %ebp
  801e39:	c3                   	ret    
  801e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e40:	0f bd e8             	bsr    %eax,%ebp
  801e43:	83 f5 1f             	xor    $0x1f,%ebp
  801e46:	75 50                	jne    801e98 <__umoddi3+0xa8>
  801e48:	39 d8                	cmp    %ebx,%eax
  801e4a:	0f 82 e0 00 00 00    	jb     801f30 <__umoddi3+0x140>
  801e50:	89 d9                	mov    %ebx,%ecx
  801e52:	39 f7                	cmp    %esi,%edi
  801e54:	0f 86 d6 00 00 00    	jbe    801f30 <__umoddi3+0x140>
  801e5a:	89 d0                	mov    %edx,%eax
  801e5c:	89 ca                	mov    %ecx,%edx
  801e5e:	83 c4 1c             	add    $0x1c,%esp
  801e61:	5b                   	pop    %ebx
  801e62:	5e                   	pop    %esi
  801e63:	5f                   	pop    %edi
  801e64:	5d                   	pop    %ebp
  801e65:	c3                   	ret    
  801e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e6d:	8d 76 00             	lea    0x0(%esi),%esi
  801e70:	89 fd                	mov    %edi,%ebp
  801e72:	85 ff                	test   %edi,%edi
  801e74:	75 0b                	jne    801e81 <__umoddi3+0x91>
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	31 d2                	xor    %edx,%edx
  801e7d:	f7 f7                	div    %edi
  801e7f:	89 c5                	mov    %eax,%ebp
  801e81:	89 d8                	mov    %ebx,%eax
  801e83:	31 d2                	xor    %edx,%edx
  801e85:	f7 f5                	div    %ebp
  801e87:	89 f0                	mov    %esi,%eax
  801e89:	f7 f5                	div    %ebp
  801e8b:	89 d0                	mov    %edx,%eax
  801e8d:	31 d2                	xor    %edx,%edx
  801e8f:	eb 8c                	jmp    801e1d <__umoddi3+0x2d>
  801e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e98:	89 e9                	mov    %ebp,%ecx
  801e9a:	ba 20 00 00 00       	mov    $0x20,%edx
  801e9f:	29 ea                	sub    %ebp,%edx
  801ea1:	d3 e0                	shl    %cl,%eax
  801ea3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea7:	89 d1                	mov    %edx,%ecx
  801ea9:	89 f8                	mov    %edi,%eax
  801eab:	d3 e8                	shr    %cl,%eax
  801ead:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801eb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eb5:	8b 54 24 04          	mov    0x4(%esp),%edx
  801eb9:	09 c1                	or     %eax,%ecx
  801ebb:	89 d8                	mov    %ebx,%eax
  801ebd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ec1:	89 e9                	mov    %ebp,%ecx
  801ec3:	d3 e7                	shl    %cl,%edi
  801ec5:	89 d1                	mov    %edx,%ecx
  801ec7:	d3 e8                	shr    %cl,%eax
  801ec9:	89 e9                	mov    %ebp,%ecx
  801ecb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ecf:	d3 e3                	shl    %cl,%ebx
  801ed1:	89 c7                	mov    %eax,%edi
  801ed3:	89 d1                	mov    %edx,%ecx
  801ed5:	89 f0                	mov    %esi,%eax
  801ed7:	d3 e8                	shr    %cl,%eax
  801ed9:	89 e9                	mov    %ebp,%ecx
  801edb:	89 fa                	mov    %edi,%edx
  801edd:	d3 e6                	shl    %cl,%esi
  801edf:	09 d8                	or     %ebx,%eax
  801ee1:	f7 74 24 08          	divl   0x8(%esp)
  801ee5:	89 d1                	mov    %edx,%ecx
  801ee7:	89 f3                	mov    %esi,%ebx
  801ee9:	f7 64 24 0c          	mull   0xc(%esp)
  801eed:	89 c6                	mov    %eax,%esi
  801eef:	89 d7                	mov    %edx,%edi
  801ef1:	39 d1                	cmp    %edx,%ecx
  801ef3:	72 06                	jb     801efb <__umoddi3+0x10b>
  801ef5:	75 10                	jne    801f07 <__umoddi3+0x117>
  801ef7:	39 c3                	cmp    %eax,%ebx
  801ef9:	73 0c                	jae    801f07 <__umoddi3+0x117>
  801efb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801eff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801f03:	89 d7                	mov    %edx,%edi
  801f05:	89 c6                	mov    %eax,%esi
  801f07:	89 ca                	mov    %ecx,%edx
  801f09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f0e:	29 f3                	sub    %esi,%ebx
  801f10:	19 fa                	sbb    %edi,%edx
  801f12:	89 d0                	mov    %edx,%eax
  801f14:	d3 e0                	shl    %cl,%eax
  801f16:	89 e9                	mov    %ebp,%ecx
  801f18:	d3 eb                	shr    %cl,%ebx
  801f1a:	d3 ea                	shr    %cl,%edx
  801f1c:	09 d8                	or     %ebx,%eax
  801f1e:	83 c4 1c             	add    $0x1c,%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    
  801f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f2d:	8d 76 00             	lea    0x0(%esi),%esi
  801f30:	29 fe                	sub    %edi,%esi
  801f32:	19 c3                	sbb    %eax,%ebx
  801f34:	89 f2                	mov    %esi,%edx
  801f36:	89 d9                	mov    %ebx,%ecx
  801f38:	e9 1d ff ff ff       	jmp    801e5a <__umoddi3+0x6a>
