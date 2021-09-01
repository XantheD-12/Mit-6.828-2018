
obj/user/pingpong.debug：     文件格式 elf32-i386


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
  80002c:	e8 93 00 00 00       	call   8000c4 <libmain>
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
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  800040:	e8 c4 0e 00 00       	call   800f09 <fork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 4f                	jne    80009b <umain+0x68>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004f:	83 ec 04             	sub    $0x4,%esp
  800052:	6a 00                	push   $0x0
  800054:	6a 00                	push   $0x0
  800056:	56                   	push   %esi
  800057:	e8 ea 10 00 00       	call   801146 <ipc_recv>
  80005c:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800061:	e8 69 0b 00 00       	call   800bcf <sys_getenvid>
  800066:	57                   	push   %edi
  800067:	53                   	push   %ebx
  800068:	50                   	push   %eax
  800069:	68 36 23 80 00       	push   $0x802336
  80006e:	e8 56 01 00 00       	call   8001c9 <cprintf>
		if (i == 10)
  800073:	83 c4 20             	add    $0x20,%esp
  800076:	83 fb 0a             	cmp    $0xa,%ebx
  800079:	74 18                	je     800093 <umain+0x60>
			return;
		i++;
  80007b:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007e:	6a 00                	push   $0x0
  800080:	6a 00                	push   $0x0
  800082:	53                   	push   %ebx
  800083:	ff 75 e4             	pushl  -0x1c(%ebp)
  800086:	e8 28 11 00 00       	call   8011b3 <ipc_send>
		if (i == 10)
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 fb 0a             	cmp    $0xa,%ebx
  800091:	75 bc                	jne    80004f <umain+0x1c>
			return;
	}

}
  800093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5f                   	pop    %edi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
  80009b:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80009d:	e8 2d 0b 00 00       	call   800bcf <sys_getenvid>
  8000a2:	83 ec 04             	sub    $0x4,%esp
  8000a5:	53                   	push   %ebx
  8000a6:	50                   	push   %eax
  8000a7:	68 20 23 80 00       	push   $0x802320
  8000ac:	e8 18 01 00 00       	call   8001c9 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 00                	push   $0x0
  8000b5:	6a 00                	push   $0x0
  8000b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ba:	e8 f4 10 00 00       	call   8011b3 <ipc_send>
  8000bf:	83 c4 20             	add    $0x20,%esp
  8000c2:	eb 88                	jmp    80004c <umain+0x19>

008000c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
  8000cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d3:	e8 f7 0a 00 00       	call   800bcf <sys_getenvid>
  8000d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e5:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	85 db                	test   %ebx,%ebx
  8000ec:	7e 07                	jle    8000f5 <libmain+0x31>
		binaryname = argv[0];
  8000ee:	8b 06                	mov    (%esi),%eax
  8000f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	e8 34 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ff:	e8 0a 00 00 00       	call   80010e <exit>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	f3 0f 1e fb          	endbr32 
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800118:	e8 1c 13 00 00       	call   801439 <close_all>
	sys_env_destroy(0);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	6a 00                	push   $0x0
  800122:	e8 63 0a 00 00       	call   800b8a <sys_env_destroy>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	c9                   	leave  
  80012b:	c3                   	ret    

0080012c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012c:	f3 0f 1e fb          	endbr32 
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	53                   	push   %ebx
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013a:	8b 13                	mov    (%ebx),%edx
  80013c:	8d 42 01             	lea    0x1(%edx),%eax
  80013f:	89 03                	mov    %eax,(%ebx)
  800141:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800144:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800148:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014d:	74 09                	je     800158 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80014f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800156:	c9                   	leave  
  800157:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800158:	83 ec 08             	sub    $0x8,%esp
  80015b:	68 ff 00 00 00       	push   $0xff
  800160:	8d 43 08             	lea    0x8(%ebx),%eax
  800163:	50                   	push   %eax
  800164:	e8 dc 09 00 00       	call   800b45 <sys_cputs>
		b->idx = 0;
  800169:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	eb db                	jmp    80014f <putch+0x23>

00800174 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800174:	f3 0f 1e fb          	endbr32 
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800181:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800188:	00 00 00 
	b.cnt = 0;
  80018b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800192:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a1:	50                   	push   %eax
  8001a2:	68 2c 01 80 00       	push   $0x80012c
  8001a7:	e8 20 01 00 00       	call   8002cc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ac:	83 c4 08             	add    $0x8,%esp
  8001af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 84 09 00 00       	call   800b45 <sys_cputs>

	return b.cnt;
}
  8001c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c9:	f3 0f 1e fb          	endbr32 
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d6:	50                   	push   %eax
  8001d7:	ff 75 08             	pushl  0x8(%ebp)
  8001da:	e8 95 ff ff ff       	call   800174 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	57                   	push   %edi
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	83 ec 1c             	sub    $0x1c,%esp
  8001ea:	89 c7                	mov    %eax,%edi
  8001ec:	89 d6                	mov    %edx,%esi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800207:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800213:	72 3e                	jb     800253 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	ff 75 18             	pushl  0x18(%ebp)
  80021b:	83 eb 01             	sub    $0x1,%ebx
  80021e:	53                   	push   %ebx
  80021f:	50                   	push   %eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	ff 75 e4             	pushl  -0x1c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	ff 75 d8             	pushl  -0x28(%ebp)
  80022f:	e8 8c 1e 00 00       	call   8020c0 <__udivdi3>
  800234:	83 c4 18             	add    $0x18,%esp
  800237:	52                   	push   %edx
  800238:	50                   	push   %eax
  800239:	89 f2                	mov    %esi,%edx
  80023b:	89 f8                	mov    %edi,%eax
  80023d:	e8 9f ff ff ff       	call   8001e1 <printnum>
  800242:	83 c4 20             	add    $0x20,%esp
  800245:	eb 13                	jmp    80025a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	ff 75 18             	pushl  0x18(%ebp)
  80024e:	ff d7                	call   *%edi
  800250:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800253:	83 eb 01             	sub    $0x1,%ebx
  800256:	85 db                	test   %ebx,%ebx
  800258:	7f ed                	jg     800247 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	56                   	push   %esi
  80025e:	83 ec 04             	sub    $0x4,%esp
  800261:	ff 75 e4             	pushl  -0x1c(%ebp)
  800264:	ff 75 e0             	pushl  -0x20(%ebp)
  800267:	ff 75 dc             	pushl  -0x24(%ebp)
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 5e 1f 00 00       	call   8021d0 <__umoddi3>
  800272:	83 c4 14             	add    $0x14,%esp
  800275:	0f be 80 53 23 80 00 	movsbl 0x802353(%eax),%eax
  80027c:	50                   	push   %eax
  80027d:	ff d7                	call   *%edi
}
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    

0080028a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028a:	f3 0f 1e fb          	endbr32 
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800294:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800298:	8b 10                	mov    (%eax),%edx
  80029a:	3b 50 04             	cmp    0x4(%eax),%edx
  80029d:	73 0a                	jae    8002a9 <sprintputch+0x1f>
		*b->buf++ = ch;
  80029f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a2:	89 08                	mov    %ecx,(%eax)
  8002a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a7:	88 02                	mov    %al,(%edx)
}
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <printfmt>:
{
  8002ab:	f3 0f 1e fb          	endbr32 
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 10             	pushl  0x10(%ebp)
  8002bc:	ff 75 0c             	pushl  0xc(%ebp)
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 05 00 00 00       	call   8002cc <vprintfmt>
}
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    

008002cc <vprintfmt>:
{
  8002cc:	f3 0f 1e fb          	endbr32 
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002df:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e2:	e9 8e 03 00 00       	jmp    800675 <vprintfmt+0x3a9>
		padc = ' ';
  8002e7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002eb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800300:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800305:	8d 47 01             	lea    0x1(%edi),%eax
  800308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030b:	0f b6 17             	movzbl (%edi),%edx
  80030e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800311:	3c 55                	cmp    $0x55,%al
  800313:	0f 87 df 03 00 00    	ja     8006f8 <vprintfmt+0x42c>
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	3e ff 24 85 a0 24 80 	notrack jmp *0x8024a0(,%eax,4)
  800323:	00 
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800327:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032b:	eb d8                	jmp    800305 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800330:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800334:	eb cf                	jmp    800305 <vprintfmt+0x39>
  800336:	0f b6 d2             	movzbl %dl,%edx
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800344:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800347:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800351:	83 f9 09             	cmp    $0x9,%ecx
  800354:	77 55                	ja     8003ab <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800356:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800359:	eb e9                	jmp    800344 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800363:	8b 45 14             	mov    0x14(%ebp),%eax
  800366:	8d 40 04             	lea    0x4(%eax),%eax
  800369:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800373:	79 90                	jns    800305 <vprintfmt+0x39>
				width = precision, precision = -1;
  800375:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800382:	eb 81                	jmp    800305 <vprintfmt+0x39>
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	ba 00 00 00 00       	mov    $0x0,%edx
  80038e:	0f 49 d0             	cmovns %eax,%edx
  800391:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800397:	e9 69 ff ff ff       	jmp    800305 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a6:	e9 5a ff ff ff       	jmp    800305 <vprintfmt+0x39>
  8003ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b1:	eb bc                	jmp    80036f <vprintfmt+0xa3>
			lflag++;
  8003b3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b9:	e9 47 ff ff ff       	jmp    800305 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 78 04             	lea    0x4(%eax),%edi
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	53                   	push   %ebx
  8003c8:	ff 30                	pushl  (%eax)
  8003ca:	ff d6                	call   *%esi
			break;
  8003cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d2:	e9 9b 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	99                   	cltd   
  8003e0:	31 d0                	xor    %edx,%eax
  8003e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e4:	83 f8 0f             	cmp    $0xf,%eax
  8003e7:	7f 23                	jg     80040c <vprintfmt+0x140>
  8003e9:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  8003f0:	85 d2                	test   %edx,%edx
  8003f2:	74 18                	je     80040c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f4:	52                   	push   %edx
  8003f5:	68 d1 28 80 00       	push   $0x8028d1
  8003fa:	53                   	push   %ebx
  8003fb:	56                   	push   %esi
  8003fc:	e8 aa fe ff ff       	call   8002ab <printfmt>
  800401:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
  800407:	e9 66 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80040c:	50                   	push   %eax
  80040d:	68 6b 23 80 00       	push   $0x80236b
  800412:	53                   	push   %ebx
  800413:	56                   	push   %esi
  800414:	e8 92 fe ff ff       	call   8002ab <printfmt>
  800419:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041f:	e9 4e 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	83 c0 04             	add    $0x4,%eax
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 64 23 80 00       	mov    $0x802364,%eax
  800439:	0f 45 c2             	cmovne %edx,%eax
  80043c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800443:	7e 06                	jle    80044b <vprintfmt+0x17f>
  800445:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800449:	75 0d                	jne    800458 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044e:	89 c7                	mov    %eax,%edi
  800450:	03 45 e0             	add    -0x20(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	eb 55                	jmp    8004ad <vprintfmt+0x1e1>
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 d8             	pushl  -0x28(%ebp)
  80045e:	ff 75 cc             	pushl  -0x34(%ebp)
  800461:	e8 46 03 00 00       	call   8007ac <strnlen>
  800466:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800469:	29 c2                	sub    %eax,%edx
  80046b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800473:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800477:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047a:	85 ff                	test   %edi,%edi
  80047c:	7e 11                	jle    80048f <vprintfmt+0x1c3>
					putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	53                   	push   %ebx
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800487:	83 ef 01             	sub    $0x1,%edi
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	eb eb                	jmp    80047a <vprintfmt+0x1ae>
  80048f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800492:	85 d2                	test   %edx,%edx
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	0f 49 c2             	cmovns %edx,%eax
  80049c:	29 c2                	sub    %eax,%edx
  80049e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a1:	eb a8                	jmp    80044b <vprintfmt+0x17f>
					putch(ch, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	52                   	push   %edx
  8004a8:	ff d6                	call   *%esi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b2:	83 c7 01             	add    $0x1,%edi
  8004b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b9:	0f be d0             	movsbl %al,%edx
  8004bc:	85 d2                	test   %edx,%edx
  8004be:	74 4b                	je     80050b <vprintfmt+0x23f>
  8004c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c4:	78 06                	js     8004cc <vprintfmt+0x200>
  8004c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ca:	78 1e                	js     8004ea <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d0:	74 d1                	je     8004a3 <vprintfmt+0x1d7>
  8004d2:	0f be c0             	movsbl %al,%eax
  8004d5:	83 e8 20             	sub    $0x20,%eax
  8004d8:	83 f8 5e             	cmp    $0x5e,%eax
  8004db:	76 c6                	jbe    8004a3 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	53                   	push   %ebx
  8004e1:	6a 3f                	push   $0x3f
  8004e3:	ff d6                	call   *%esi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	eb c3                	jmp    8004ad <vprintfmt+0x1e1>
  8004ea:	89 cf                	mov    %ecx,%edi
  8004ec:	eb 0e                	jmp    8004fc <vprintfmt+0x230>
				putch(' ', putdat);
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	53                   	push   %ebx
  8004f2:	6a 20                	push   $0x20
  8004f4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f6:	83 ef 01             	sub    $0x1,%edi
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	7f ee                	jg     8004ee <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800500:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
  800506:	e9 67 01 00 00       	jmp    800672 <vprintfmt+0x3a6>
  80050b:	89 cf                	mov    %ecx,%edi
  80050d:	eb ed                	jmp    8004fc <vprintfmt+0x230>
	if (lflag >= 2)
  80050f:	83 f9 01             	cmp    $0x1,%ecx
  800512:	7f 1b                	jg     80052f <vprintfmt+0x263>
	else if (lflag)
  800514:	85 c9                	test   %ecx,%ecx
  800516:	74 63                	je     80057b <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800520:	99                   	cltd   
  800521:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 04             	lea    0x4(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	eb 17                	jmp    800546 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8b 50 04             	mov    0x4(%eax),%edx
  800535:	8b 00                	mov    (%eax),%eax
  800537:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 40 08             	lea    0x8(%eax),%eax
  800543:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800551:	85 c9                	test   %ecx,%ecx
  800553:	0f 89 ff 00 00 00    	jns    800658 <vprintfmt+0x38c>
				putch('-', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 2d                	push   $0x2d
  80055f:	ff d6                	call   *%esi
				num = -(long long) num;
  800561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800564:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800567:	f7 da                	neg    %edx
  800569:	83 d1 00             	adc    $0x0,%ecx
  80056c:	f7 d9                	neg    %ecx
  80056e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800571:	b8 0a 00 00 00       	mov    $0xa,%eax
  800576:	e9 dd 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800583:	99                   	cltd   
  800584:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	eb b4                	jmp    800546 <vprintfmt+0x27a>
	if (lflag >= 2)
  800592:	83 f9 01             	cmp    $0x1,%ecx
  800595:	7f 1e                	jg     8005b5 <vprintfmt+0x2e9>
	else if (lflag)
  800597:	85 c9                	test   %ecx,%ecx
  800599:	74 32                	je     8005cd <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8b 10                	mov    (%eax),%edx
  8005a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ab:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005b0:	e9 a3 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 10                	mov    (%eax),%edx
  8005ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bd:	8d 40 08             	lea    0x8(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005c8:	e9 8b 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005e2:	eb 74                	jmp    800658 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005e4:	83 f9 01             	cmp    $0x1,%ecx
  8005e7:	7f 1b                	jg     800604 <vprintfmt+0x338>
	else if (lflag)
  8005e9:	85 c9                	test   %ecx,%ecx
  8005eb:	74 2c                	je     800619 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 10                	mov    (%eax),%edx
  8005f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8005fd:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800602:	eb 54                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	8b 48 04             	mov    0x4(%eax),%ecx
  80060c:	8d 40 08             	lea    0x8(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800612:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800617:	eb 3f                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800623:	8d 40 04             	lea    0x4(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800629:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80062e:	eb 28                	jmp    800658 <vprintfmt+0x38c>
			putch('0', putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	6a 30                	push   $0x30
  800636:	ff d6                	call   *%esi
			putch('x', putdat);
  800638:	83 c4 08             	add    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 78                	push   $0x78
  80063e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80065f:	57                   	push   %edi
  800660:	ff 75 e0             	pushl  -0x20(%ebp)
  800663:	50                   	push   %eax
  800664:	51                   	push   %ecx
  800665:	52                   	push   %edx
  800666:	89 da                	mov    %ebx,%edx
  800668:	89 f0                	mov    %esi,%eax
  80066a:	e8 72 fb ff ff       	call   8001e1 <printnum>
			break;
  80066f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800675:	83 c7 01             	add    $0x1,%edi
  800678:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067c:	83 f8 25             	cmp    $0x25,%eax
  80067f:	0f 84 62 fc ff ff    	je     8002e7 <vprintfmt+0x1b>
			if (ch == '\0')
  800685:	85 c0                	test   %eax,%eax
  800687:	0f 84 8b 00 00 00    	je     800718 <vprintfmt+0x44c>
			putch(ch, putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	50                   	push   %eax
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	eb dc                	jmp    800675 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800699:	83 f9 01             	cmp    $0x1,%ecx
  80069c:	7f 1b                	jg     8006b9 <vprintfmt+0x3ed>
	else if (lflag)
  80069e:	85 c9                	test   %ecx,%ecx
  8006a0:	74 2c                	je     8006ce <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006b7:	eb 9f                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006cc:	eb 8a                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d8:	8d 40 04             	lea    0x4(%eax),%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006de:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006e3:	e9 70 ff ff ff       	jmp    800658 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	6a 25                	push   $0x25
  8006ee:	ff d6                	call   *%esi
			break;
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	e9 7a ff ff ff       	jmp    800672 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 25                	push   $0x25
  8006fe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	89 f8                	mov    %edi,%eax
  800705:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800709:	74 05                	je     800710 <vprintfmt+0x444>
  80070b:	83 e8 01             	sub    $0x1,%eax
  80070e:	eb f5                	jmp    800705 <vprintfmt+0x439>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800713:	e9 5a ff ff ff       	jmp    800672 <vprintfmt+0x3a6>
}
  800718:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071b:	5b                   	pop    %ebx
  80071c:	5e                   	pop    %esi
  80071d:	5f                   	pop    %edi
  80071e:	5d                   	pop    %ebp
  80071f:	c3                   	ret    

00800720 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800720:	f3 0f 1e fb          	endbr32 
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	83 ec 18             	sub    $0x18,%esp
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800730:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800733:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800737:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80073a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800741:	85 c0                	test   %eax,%eax
  800743:	74 26                	je     80076b <vsnprintf+0x4b>
  800745:	85 d2                	test   %edx,%edx
  800747:	7e 22                	jle    80076b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800749:	ff 75 14             	pushl  0x14(%ebp)
  80074c:	ff 75 10             	pushl  0x10(%ebp)
  80074f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	68 8a 02 80 00       	push   $0x80028a
  800758:	e8 6f fb ff ff       	call   8002cc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80075d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800760:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800766:	83 c4 10             	add    $0x10,%esp
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    
		return -E_INVAL;
  80076b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800770:	eb f7                	jmp    800769 <vsnprintf+0x49>

00800772 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800772:	f3 0f 1e fb          	endbr32 
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077f:	50                   	push   %eax
  800780:	ff 75 10             	pushl  0x10(%ebp)
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	ff 75 08             	pushl  0x8(%ebp)
  800789:	e8 92 ff ff ff       	call   800720 <vsnprintf>
	va_end(ap);

	return rc;
}
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	f3 0f 1e fb          	endbr32 
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a3:	74 05                	je     8007aa <strlen+0x1a>
		n++;
  8007a5:	83 c0 01             	add    $0x1,%eax
  8007a8:	eb f5                	jmp    80079f <strlen+0xf>
	return n;
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007be:	39 d0                	cmp    %edx,%eax
  8007c0:	74 0d                	je     8007cf <strnlen+0x23>
  8007c2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c6:	74 05                	je     8007cd <strnlen+0x21>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
  8007cb:	eb f1                	jmp    8007be <strnlen+0x12>
  8007cd:	89 c2                	mov    %eax,%edx
	return n;
}
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ea:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007ed:	83 c0 01             	add    $0x1,%eax
  8007f0:	84 d2                	test   %dl,%dl
  8007f2:	75 f2                	jne    8007e6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007f4:	89 c8                	mov    %ecx,%eax
  8007f6:	5b                   	pop    %ebx
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f9:	f3 0f 1e fb          	endbr32 
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	53                   	push   %ebx
  800801:	83 ec 10             	sub    $0x10,%esp
  800804:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800807:	53                   	push   %ebx
  800808:	e8 83 ff ff ff       	call   800790 <strlen>
  80080d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	01 d8                	add    %ebx,%eax
  800815:	50                   	push   %eax
  800816:	e8 b8 ff ff ff       	call   8007d3 <strcpy>
	return dst;
}
  80081b:	89 d8                	mov    %ebx,%eax
  80081d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	f3 0f 1e fb          	endbr32 
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	56                   	push   %esi
  80082a:	53                   	push   %ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800831:	89 f3                	mov    %esi,%ebx
  800833:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800836:	89 f0                	mov    %esi,%eax
  800838:	39 d8                	cmp    %ebx,%eax
  80083a:	74 11                	je     80084d <strncpy+0x2b>
		*dst++ = *src;
  80083c:	83 c0 01             	add    $0x1,%eax
  80083f:	0f b6 0a             	movzbl (%edx),%ecx
  800842:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800845:	80 f9 01             	cmp    $0x1,%cl
  800848:	83 da ff             	sbb    $0xffffffff,%edx
  80084b:	eb eb                	jmp    800838 <strncpy+0x16>
	}
	return ret;
}
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	5b                   	pop    %ebx
  800850:	5e                   	pop    %esi
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800853:	f3 0f 1e fb          	endbr32 
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	56                   	push   %esi
  80085b:	53                   	push   %ebx
  80085c:	8b 75 08             	mov    0x8(%ebp),%esi
  80085f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800862:	8b 55 10             	mov    0x10(%ebp),%edx
  800865:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800867:	85 d2                	test   %edx,%edx
  800869:	74 21                	je     80088c <strlcpy+0x39>
  80086b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80086f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800871:	39 c2                	cmp    %eax,%edx
  800873:	74 14                	je     800889 <strlcpy+0x36>
  800875:	0f b6 19             	movzbl (%ecx),%ebx
  800878:	84 db                	test   %bl,%bl
  80087a:	74 0b                	je     800887 <strlcpy+0x34>
			*dst++ = *src++;
  80087c:	83 c1 01             	add    $0x1,%ecx
  80087f:	83 c2 01             	add    $0x1,%edx
  800882:	88 5a ff             	mov    %bl,-0x1(%edx)
  800885:	eb ea                	jmp    800871 <strlcpy+0x1e>
  800887:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800889:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80088c:	29 f0                	sub    %esi,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5e                   	pop    %esi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800892:	f3 0f 1e fb          	endbr32 
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089f:	0f b6 01             	movzbl (%ecx),%eax
  8008a2:	84 c0                	test   %al,%al
  8008a4:	74 0c                	je     8008b2 <strcmp+0x20>
  8008a6:	3a 02                	cmp    (%edx),%al
  8008a8:	75 08                	jne    8008b2 <strcmp+0x20>
		p++, q++;
  8008aa:	83 c1 01             	add    $0x1,%ecx
  8008ad:	83 c2 01             	add    $0x1,%edx
  8008b0:	eb ed                	jmp    80089f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	0f b6 12             	movzbl (%edx),%edx
  8008b8:	29 d0                	sub    %edx,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	89 c3                	mov    %eax,%ebx
  8008cc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cf:	eb 06                	jmp    8008d7 <strncmp+0x1b>
		n--, p++, q++;
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d7:	39 d8                	cmp    %ebx,%eax
  8008d9:	74 16                	je     8008f1 <strncmp+0x35>
  8008db:	0f b6 08             	movzbl (%eax),%ecx
  8008de:	84 c9                	test   %cl,%cl
  8008e0:	74 04                	je     8008e6 <strncmp+0x2a>
  8008e2:	3a 0a                	cmp    (%edx),%cl
  8008e4:	74 eb                	je     8008d1 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e6:	0f b6 00             	movzbl (%eax),%eax
  8008e9:	0f b6 12             	movzbl (%edx),%edx
  8008ec:	29 d0                	sub    %edx,%eax
}
  8008ee:	5b                   	pop    %ebx
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    
		return 0;
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb f6                	jmp    8008ee <strncmp+0x32>

008008f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f8:	f3 0f 1e fb          	endbr32 
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800906:	0f b6 10             	movzbl (%eax),%edx
  800909:	84 d2                	test   %dl,%dl
  80090b:	74 09                	je     800916 <strchr+0x1e>
		if (*s == c)
  80090d:	38 ca                	cmp    %cl,%dl
  80090f:	74 0a                	je     80091b <strchr+0x23>
	for (; *s; s++)
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	eb f0                	jmp    800906 <strchr+0xe>
			return (char *) s;
	return 0;
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091d:	f3 0f 1e fb          	endbr32 
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80092e:	38 ca                	cmp    %cl,%dl
  800930:	74 09                	je     80093b <strfind+0x1e>
  800932:	84 d2                	test   %dl,%dl
  800934:	74 05                	je     80093b <strfind+0x1e>
	for (; *s; s++)
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	eb f0                	jmp    80092b <strfind+0xe>
			break;
	return (char *) s;
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80093d:	f3 0f 1e fb          	endbr32 
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	57                   	push   %edi
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
  800947:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094d:	85 c9                	test   %ecx,%ecx
  80094f:	74 31                	je     800982 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800951:	89 f8                	mov    %edi,%eax
  800953:	09 c8                	or     %ecx,%eax
  800955:	a8 03                	test   $0x3,%al
  800957:	75 23                	jne    80097c <memset+0x3f>
		c &= 0xFF;
  800959:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095d:	89 d3                	mov    %edx,%ebx
  80095f:	c1 e3 08             	shl    $0x8,%ebx
  800962:	89 d0                	mov    %edx,%eax
  800964:	c1 e0 18             	shl    $0x18,%eax
  800967:	89 d6                	mov    %edx,%esi
  800969:	c1 e6 10             	shl    $0x10,%esi
  80096c:	09 f0                	or     %esi,%eax
  80096e:	09 c2                	or     %eax,%edx
  800970:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800972:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800975:	89 d0                	mov    %edx,%eax
  800977:	fc                   	cld    
  800978:	f3 ab                	rep stos %eax,%es:(%edi)
  80097a:	eb 06                	jmp    800982 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	fc                   	cld    
  800980:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800982:	89 f8                	mov    %edi,%eax
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5f                   	pop    %edi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800989:	f3 0f 1e fb          	endbr32 
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	57                   	push   %edi
  800991:	56                   	push   %esi
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 75 0c             	mov    0xc(%ebp),%esi
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80099b:	39 c6                	cmp    %eax,%esi
  80099d:	73 32                	jae    8009d1 <memmove+0x48>
  80099f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a2:	39 c2                	cmp    %eax,%edx
  8009a4:	76 2b                	jbe    8009d1 <memmove+0x48>
		s += n;
		d += n;
  8009a6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a9:	89 fe                	mov    %edi,%esi
  8009ab:	09 ce                	or     %ecx,%esi
  8009ad:	09 d6                	or     %edx,%esi
  8009af:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b5:	75 0e                	jne    8009c5 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b7:	83 ef 04             	sub    $0x4,%edi
  8009ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c3:	eb 09                	jmp    8009ce <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c5:	83 ef 01             	sub    $0x1,%edi
  8009c8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009cb:	fd                   	std    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ce:	fc                   	cld    
  8009cf:	eb 1a                	jmp    8009eb <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d1:	89 c2                	mov    %eax,%edx
  8009d3:	09 ca                	or     %ecx,%edx
  8009d5:	09 f2                	or     %esi,%edx
  8009d7:	f6 c2 03             	test   $0x3,%dl
  8009da:	75 0a                	jne    8009e6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb 05                	jmp    8009eb <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009e6:	89 c7                	mov    %eax,%edi
  8009e8:	fc                   	cld    
  8009e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f9:	ff 75 10             	pushl  0x10(%ebp)
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	ff 75 08             	pushl  0x8(%ebp)
  800a02:	e8 82 ff ff ff       	call   800989 <memmove>
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a09:	f3 0f 1e fb          	endbr32 
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a18:	89 c6                	mov    %eax,%esi
  800a1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1d:	39 f0                	cmp    %esi,%eax
  800a1f:	74 1c                	je     800a3d <memcmp+0x34>
		if (*s1 != *s2)
  800a21:	0f b6 08             	movzbl (%eax),%ecx
  800a24:	0f b6 1a             	movzbl (%edx),%ebx
  800a27:	38 d9                	cmp    %bl,%cl
  800a29:	75 08                	jne    800a33 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	83 c2 01             	add    $0x1,%edx
  800a31:	eb ea                	jmp    800a1d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a33:	0f b6 c1             	movzbl %cl,%eax
  800a36:	0f b6 db             	movzbl %bl,%ebx
  800a39:	29 d8                	sub    %ebx,%eax
  800a3b:	eb 05                	jmp    800a42 <memcmp+0x39>
	}

	return 0;
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a46:	f3 0f 1e fb          	endbr32 
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a58:	39 d0                	cmp    %edx,%eax
  800a5a:	73 09                	jae    800a65 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5c:	38 08                	cmp    %cl,(%eax)
  800a5e:	74 05                	je     800a65 <memfind+0x1f>
	for (; s < ends; s++)
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	eb f3                	jmp    800a58 <memfind+0x12>
			break;
	return (void *) s;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a67:	f3 0f 1e fb          	endbr32 
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	57                   	push   %edi
  800a6f:	56                   	push   %esi
  800a70:	53                   	push   %ebx
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a77:	eb 03                	jmp    800a7c <strtol+0x15>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7c:	0f b6 01             	movzbl (%ecx),%eax
  800a7f:	3c 20                	cmp    $0x20,%al
  800a81:	74 f6                	je     800a79 <strtol+0x12>
  800a83:	3c 09                	cmp    $0x9,%al
  800a85:	74 f2                	je     800a79 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a87:	3c 2b                	cmp    $0x2b,%al
  800a89:	74 2a                	je     800ab5 <strtol+0x4e>
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a90:	3c 2d                	cmp    $0x2d,%al
  800a92:	74 2b                	je     800abf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a94:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9a:	75 0f                	jne    800aab <strtol+0x44>
  800a9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9f:	74 28                	je     800ac9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa8:	0f 44 d8             	cmove  %eax,%ebx
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab3:	eb 46                	jmp    800afb <strtol+0x94>
		s++;
  800ab5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab8:	bf 00 00 00 00       	mov    $0x0,%edi
  800abd:	eb d5                	jmp    800a94 <strtol+0x2d>
		s++, neg = 1;
  800abf:	83 c1 01             	add    $0x1,%ecx
  800ac2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac7:	eb cb                	jmp    800a94 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800acd:	74 0e                	je     800add <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800acf:	85 db                	test   %ebx,%ebx
  800ad1:	75 d8                	jne    800aab <strtol+0x44>
		s++, base = 8;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800adb:	eb ce                	jmp    800aab <strtol+0x44>
		s += 2, base = 16;
  800add:	83 c1 02             	add    $0x2,%ecx
  800ae0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae5:	eb c4                	jmp    800aab <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ae7:	0f be d2             	movsbl %dl,%edx
  800aea:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aed:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af0:	7d 3a                	jge    800b2c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af2:	83 c1 01             	add    $0x1,%ecx
  800af5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800af9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800afb:	0f b6 11             	movzbl (%ecx),%edx
  800afe:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b01:	89 f3                	mov    %esi,%ebx
  800b03:	80 fb 09             	cmp    $0x9,%bl
  800b06:	76 df                	jbe    800ae7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0b:	89 f3                	mov    %esi,%ebx
  800b0d:	80 fb 19             	cmp    $0x19,%bl
  800b10:	77 08                	ja     800b1a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 57             	sub    $0x57,%edx
  800b18:	eb d3                	jmp    800aed <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b1a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b1d:	89 f3                	mov    %esi,%ebx
  800b1f:	80 fb 19             	cmp    $0x19,%bl
  800b22:	77 08                	ja     800b2c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b24:	0f be d2             	movsbl %dl,%edx
  800b27:	83 ea 37             	sub    $0x37,%edx
  800b2a:	eb c1                	jmp    800aed <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b30:	74 05                	je     800b37 <strtol+0xd0>
		*endptr = (char *) s;
  800b32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b35:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	f7 da                	neg    %edx
  800b3b:	85 ff                	test   %edi,%edi
  800b3d:	0f 45 c2             	cmovne %edx,%eax
}
  800b40:	5b                   	pop    %ebx
  800b41:	5e                   	pop    %esi
  800b42:	5f                   	pop    %edi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b45:	f3 0f 1e fb          	endbr32 
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	89 c3                	mov    %eax,%ebx
  800b5c:	89 c7                	mov    %eax,%edi
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b67:	f3 0f 1e fb          	endbr32 
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7b:	89 d1                	mov    %edx,%ecx
  800b7d:	89 d3                	mov    %edx,%ebx
  800b7f:	89 d7                	mov    %edx,%edi
  800b81:	89 d6                	mov    %edx,%esi
  800b83:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5f                   	pop    %edi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba4:	89 cb                	mov    %ecx,%ebx
  800ba6:	89 cf                	mov    %ecx,%edi
  800ba8:	89 ce                	mov    %ecx,%esi
  800baa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bac:	85 c0                	test   %eax,%eax
  800bae:	7f 08                	jg     800bb8 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb8:	83 ec 0c             	sub    $0xc,%esp
  800bbb:	50                   	push   %eax
  800bbc:	6a 03                	push   $0x3
  800bbe:	68 5f 26 80 00       	push   $0x80265f
  800bc3:	6a 23                	push   $0x23
  800bc5:	68 7c 26 80 00       	push   $0x80267c
  800bca:	e8 c0 13 00 00       	call   801f8f <_panic>

00800bcf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bcf:	f3 0f 1e fb          	endbr32 
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	b8 02 00 00 00       	mov    $0x2,%eax
  800be3:	89 d1                	mov    %edx,%ecx
  800be5:	89 d3                	mov    %edx,%ebx
  800be7:	89 d7                	mov    %edx,%edi
  800be9:	89 d6                	mov    %edx,%esi
  800beb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <sys_yield>:

void
sys_yield(void)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c06:	89 d1                	mov    %edx,%ecx
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	89 d7                	mov    %edx,%edi
  800c0c:	89 d6                	mov    %edx,%esi
  800c0e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c15:	f3 0f 1e fb          	endbr32 
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c22:	be 00 00 00 00       	mov    $0x0,%esi
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	b8 04 00 00 00       	mov    $0x4,%eax
  800c32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c35:	89 f7                	mov    %esi,%edi
  800c37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	7f 08                	jg     800c45 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	83 ec 0c             	sub    $0xc,%esp
  800c48:	50                   	push   %eax
  800c49:	6a 04                	push   $0x4
  800c4b:	68 5f 26 80 00       	push   $0x80265f
  800c50:	6a 23                	push   $0x23
  800c52:	68 7c 26 80 00       	push   $0x80267c
  800c57:	e8 33 13 00 00       	call   801f8f <_panic>

00800c5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c5c:	f3 0f 1e fb          	endbr32 
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 05                	push   $0x5
  800c91:	68 5f 26 80 00       	push   $0x80265f
  800c96:	6a 23                	push   $0x23
  800c98:	68 7c 26 80 00       	push   $0x80267c
  800c9d:	e8 ed 12 00 00       	call   801f8f <_panic>

00800ca2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbf:	89 df                	mov    %ebx,%edi
  800cc1:	89 de                	mov    %ebx,%esi
  800cc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7f 08                	jg     800cd1 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd1:	83 ec 0c             	sub    $0xc,%esp
  800cd4:	50                   	push   %eax
  800cd5:	6a 06                	push   $0x6
  800cd7:	68 5f 26 80 00       	push   $0x80265f
  800cdc:	6a 23                	push   $0x23
  800cde:	68 7c 26 80 00       	push   $0x80267c
  800ce3:	e8 a7 12 00 00       	call   801f8f <_panic>

00800ce8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce8:	f3 0f 1e fb          	endbr32 
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	b8 08 00 00 00       	mov    $0x8,%eax
  800d05:	89 df                	mov    %ebx,%edi
  800d07:	89 de                	mov    %ebx,%esi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 08                	push   $0x8
  800d1d:	68 5f 26 80 00       	push   $0x80265f
  800d22:	6a 23                	push   $0x23
  800d24:	68 7c 26 80 00       	push   $0x80267c
  800d29:	e8 61 12 00 00       	call   801f8f <_panic>

00800d2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d2e:	f3 0f 1e fb          	endbr32 
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	b8 09 00 00 00       	mov    $0x9,%eax
  800d4b:	89 df                	mov    %ebx,%edi
  800d4d:	89 de                	mov    %ebx,%esi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 09                	push   $0x9
  800d63:	68 5f 26 80 00       	push   $0x80265f
  800d68:	6a 23                	push   $0x23
  800d6a:	68 7c 26 80 00       	push   $0x80267c
  800d6f:	e8 1b 12 00 00       	call   801f8f <_panic>

00800d74 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d74:	f3 0f 1e fb          	endbr32 
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 0a                	push   $0xa
  800da9:	68 5f 26 80 00       	push   $0x80265f
  800dae:	6a 23                	push   $0x23
  800db0:	68 7c 26 80 00       	push   $0x80267c
  800db5:	e8 d5 11 00 00       	call   801f8f <_panic>

00800dba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dba:	f3 0f 1e fb          	endbr32 
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcf:	be 00 00 00 00       	mov    $0x0,%esi
  800dd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dda:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de1:	f3 0f 1e fb          	endbr32 
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfb:	89 cb                	mov    %ecx,%ebx
  800dfd:	89 cf                	mov    %ecx,%edi
  800dff:	89 ce                	mov    %ecx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	50                   	push   %eax
  800e13:	6a 0d                	push   $0xd
  800e15:	68 5f 26 80 00       	push   $0x80265f
  800e1a:	6a 23                	push   $0x23
  800e1c:	68 7c 26 80 00       	push   $0x80267c
  800e21:	e8 69 11 00 00       	call   801f8f <_panic>

00800e26 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800e26:	f3 0f 1e fb          	endbr32 
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e32:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800e34:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e38:	74 7f                	je     800eb9 <pgfault+0x93>
  800e3a:	89 f0                	mov    %esi,%eax
  800e3c:	c1 e8 0c             	shr    $0xc,%eax
  800e3f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e46:	f6 c4 08             	test   $0x8,%ah
  800e49:	74 6e                	je     800eb9 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800e4b:	e8 7f fd ff ff       	call   800bcf <sys_getenvid>
  800e50:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800e52:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800e58:	83 ec 04             	sub    $0x4,%esp
  800e5b:	6a 07                	push   $0x7
  800e5d:	68 00 f0 7f 00       	push   $0x7ff000
  800e62:	50                   	push   %eax
  800e63:	e8 ad fd ff ff       	call   800c15 <sys_page_alloc>
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	78 5e                	js     800ecd <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800e6f:	83 ec 04             	sub    $0x4,%esp
  800e72:	68 00 10 00 00       	push   $0x1000
  800e77:	56                   	push   %esi
  800e78:	68 00 f0 7f 00       	push   $0x7ff000
  800e7d:	e8 6d fb ff ff       	call   8009ef <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800e82:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	68 00 f0 7f 00       	push   $0x7ff000
  800e90:	53                   	push   %ebx
  800e91:	e8 c6 fd ff ff       	call   800c5c <sys_page_map>
  800e96:	83 c4 20             	add    $0x20,%esp
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	78 44                	js     800ee1 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	68 00 f0 7f 00       	push   $0x7ff000
  800ea5:	53                   	push   %ebx
  800ea6:	e8 f7 fd ff ff       	call   800ca2 <sys_page_unmap>
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	78 43                	js     800ef5 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800eb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800eb9:	83 ec 04             	sub    $0x4,%esp
  800ebc:	68 8a 26 80 00       	push   $0x80268a
  800ec1:	6a 1e                	push   $0x1e
  800ec3:	68 a7 26 80 00       	push   $0x8026a7
  800ec8:	e8 c2 10 00 00       	call   801f8f <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800ecd:	83 ec 04             	sub    $0x4,%esp
  800ed0:	68 38 27 80 00       	push   $0x802738
  800ed5:	6a 2b                	push   $0x2b
  800ed7:	68 a7 26 80 00       	push   $0x8026a7
  800edc:	e8 ae 10 00 00       	call   801f8f <_panic>
		panic("pgfault: sys_page_map Failed!");
  800ee1:	83 ec 04             	sub    $0x4,%esp
  800ee4:	68 b2 26 80 00       	push   $0x8026b2
  800ee9:	6a 2f                	push   $0x2f
  800eeb:	68 a7 26 80 00       	push   $0x8026a7
  800ef0:	e8 9a 10 00 00       	call   801f8f <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800ef5:	83 ec 04             	sub    $0x4,%esp
  800ef8:	68 58 27 80 00       	push   $0x802758
  800efd:	6a 32                	push   $0x32
  800eff:	68 a7 26 80 00       	push   $0x8026a7
  800f04:	e8 86 10 00 00       	call   801f8f <_panic>

00800f09 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f09:	f3 0f 1e fb          	endbr32 
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f16:	68 26 0e 80 00       	push   $0x800e26
  800f1b:	e8 b9 10 00 00       	call   801fd9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f20:	b8 07 00 00 00       	mov    $0x7,%eax
  800f25:	cd 30                	int    $0x30
  800f27:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	85 c0                	test   %eax,%eax
  800f32:	78 2b                	js     800f5f <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800f34:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  800f39:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f3d:	0f 85 ba 00 00 00    	jne    800ffd <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  800f43:	e8 87 fc ff ff       	call   800bcf <sys_getenvid>
  800f48:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f4d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f50:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f55:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f5a:	e9 90 01 00 00       	jmp    8010ef <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	68 d0 26 80 00       	push   $0x8026d0
  800f67:	6a 76                	push   $0x76
  800f69:	68 a7 26 80 00       	push   $0x8026a7
  800f6e:	e8 1c 10 00 00       	call   801f8f <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  800f73:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  800f7a:	e8 50 fc ff ff       	call   800bcf <sys_getenvid>
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800f88:	56                   	push   %esi
  800f89:	57                   	push   %edi
  800f8a:	ff 75 e0             	pushl  -0x20(%ebp)
  800f8d:	57                   	push   %edi
  800f8e:	50                   	push   %eax
  800f8f:	e8 c8 fc ff ff       	call   800c5c <sys_page_map>
  800f94:	83 c4 20             	add    $0x20,%esp
  800f97:	85 c0                	test   %eax,%eax
  800f99:	79 50                	jns    800feb <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  800f9b:	83 ec 04             	sub    $0x4,%esp
  800f9e:	68 e9 26 80 00       	push   $0x8026e9
  800fa3:	6a 4b                	push   $0x4b
  800fa5:	68 a7 26 80 00       	push   $0x8026a7
  800faa:	e8 e0 0f 00 00       	call   801f8f <_panic>
			panic("duppage:child sys_page_map Failed!");
  800faf:	83 ec 04             	sub    $0x4,%esp
  800fb2:	68 78 27 80 00       	push   $0x802778
  800fb7:	6a 50                	push   $0x50
  800fb9:	68 a7 26 80 00       	push   $0x8026a7
  800fbe:	e8 cc 0f 00 00       	call   801f8f <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  800fc3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fca:	83 ec 0c             	sub    $0xc,%esp
  800fcd:	25 07 0e 00 00       	and    $0xe07,%eax
  800fd2:	50                   	push   %eax
  800fd3:	57                   	push   %edi
  800fd4:	ff 75 e0             	pushl  -0x20(%ebp)
  800fd7:	57                   	push   %edi
  800fd8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fdb:	e8 7c fc ff ff       	call   800c5c <sys_page_map>
  800fe0:	83 c4 20             	add    $0x20,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	0f 88 b4 00 00 00    	js     80109f <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800feb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800ff1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800ff7:	0f 84 b6 00 00 00    	je     8010b3 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  800ffd:	89 d8                	mov    %ebx,%eax
  800fff:	c1 e8 16             	shr    $0x16,%eax
  801002:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801009:	a8 01                	test   $0x1,%al
  80100b:	74 de                	je     800feb <fork+0xe2>
  80100d:	89 de                	mov    %ebx,%esi
  80100f:	c1 ee 0c             	shr    $0xc,%esi
  801012:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801019:	a8 01                	test   $0x1,%al
  80101b:	74 ce                	je     800feb <fork+0xe2>
	envid_t f_id=sys_getenvid();
  80101d:	e8 ad fb ff ff       	call   800bcf <sys_getenvid>
  801022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801025:	89 f7                	mov    %esi,%edi
  801027:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80102a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801031:	f6 c4 04             	test   $0x4,%ah
  801034:	0f 85 39 ff ff ff    	jne    800f73 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80103a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801041:	a9 02 08 00 00       	test   $0x802,%eax
  801046:	0f 84 77 ff ff ff    	je     800fc3 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  80104c:	83 ec 0c             	sub    $0xc,%esp
  80104f:	68 05 08 00 00       	push   $0x805
  801054:	57                   	push   %edi
  801055:	ff 75 e0             	pushl  -0x20(%ebp)
  801058:	57                   	push   %edi
  801059:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105c:	e8 fb fb ff ff       	call   800c5c <sys_page_map>
  801061:	83 c4 20             	add    $0x20,%esp
  801064:	85 c0                	test   %eax,%eax
  801066:	0f 88 43 ff ff ff    	js     800faf <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  80106c:	83 ec 0c             	sub    $0xc,%esp
  80106f:	68 05 08 00 00       	push   $0x805
  801074:	57                   	push   %edi
  801075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	57                   	push   %edi
  80107a:	50                   	push   %eax
  80107b:	e8 dc fb ff ff       	call   800c5c <sys_page_map>
  801080:	83 c4 20             	add    $0x20,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	0f 89 60 ff ff ff    	jns    800feb <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 9c 27 80 00       	push   $0x80279c
  801093:	6a 52                	push   $0x52
  801095:	68 a7 26 80 00       	push   $0x8026a7
  80109a:	e8 f0 0e 00 00       	call   801f8f <_panic>
			panic("duppage: single sys_page_map Failed!");
  80109f:	83 ec 04             	sub    $0x4,%esp
  8010a2:	68 c0 27 80 00       	push   $0x8027c0
  8010a7:	6a 56                	push   $0x56
  8010a9:	68 a7 26 80 00       	push   $0x8026a7
  8010ae:	e8 dc 0e 00 00       	call   801f8f <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	6a 07                	push   $0x7
  8010b8:	68 00 f0 bf ee       	push   $0xeebff000
  8010bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8010c0:	e8 50 fb ff ff       	call   800c15 <sys_page_alloc>
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	78 2e                	js     8010fa <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	68 55 20 80 00       	push   $0x802055
  8010d4:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8010d7:	57                   	push   %edi
  8010d8:	e8 97 fc ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  8010dd:	83 c4 08             	add    $0x8,%esp
  8010e0:	6a 02                	push   $0x2
  8010e2:	57                   	push   %edi
  8010e3:	e8 00 fc ff ff       	call   800ce8 <sys_env_set_status>
  8010e8:	83 c4 10             	add    $0x10,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	78 22                	js     801111 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  8010ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  8010fa:	83 ec 04             	sub    $0x4,%esp
  8010fd:	68 06 27 80 00       	push   $0x802706
  801102:	68 83 00 00 00       	push   $0x83
  801107:	68 a7 26 80 00       	push   $0x8026a7
  80110c:	e8 7e 0e 00 00       	call   801f8f <_panic>
		panic("fork: sys_env_set_status Failed!");
  801111:	83 ec 04             	sub    $0x4,%esp
  801114:	68 e8 27 80 00       	push   $0x8027e8
  801119:	68 89 00 00 00       	push   $0x89
  80111e:	68 a7 26 80 00       	push   $0x8026a7
  801123:	e8 67 0e 00 00       	call   801f8f <_panic>

00801128 <sfork>:

// Challenge!
int
sfork(void)
{
  801128:	f3 0f 1e fb          	endbr32 
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801132:	68 22 27 80 00       	push   $0x802722
  801137:	68 93 00 00 00       	push   $0x93
  80113c:	68 a7 26 80 00       	push   $0x8026a7
  801141:	e8 49 0e 00 00       	call   801f8f <_panic>

00801146 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801146:	f3 0f 1e fb          	endbr32 
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
  80114f:	8b 75 08             	mov    0x8(%ebp),%esi
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801158:	85 c0                	test   %eax,%eax
  80115a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80115f:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	50                   	push   %eax
  801166:	e8 76 fc ff ff       	call   800de1 <sys_ipc_recv>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 2b                	js     80119d <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801172:	85 f6                	test   %esi,%esi
  801174:	74 0a                	je     801180 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801176:	a1 04 40 80 00       	mov    0x804004,%eax
  80117b:	8b 40 74             	mov    0x74(%eax),%eax
  80117e:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801180:	85 db                	test   %ebx,%ebx
  801182:	74 0a                	je     80118e <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801184:	a1 04 40 80 00       	mov    0x804004,%eax
  801189:	8b 40 78             	mov    0x78(%eax),%eax
  80118c:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80118e:	a1 04 40 80 00       	mov    0x804004,%eax
  801193:	8b 40 70             	mov    0x70(%eax),%eax
}
  801196:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    
		if(from_env_store)
  80119d:	85 f6                	test   %esi,%esi
  80119f:	74 06                	je     8011a7 <ipc_recv+0x61>
			*from_env_store=0;
  8011a1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8011a7:	85 db                	test   %ebx,%ebx
  8011a9:	74 eb                	je     801196 <ipc_recv+0x50>
			*perm_store=0;
  8011ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011b1:	eb e3                	jmp    801196 <ipc_recv+0x50>

008011b3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011b3:	f3 0f 1e fb          	endbr32 
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	57                   	push   %edi
  8011bb:	56                   	push   %esi
  8011bc:	53                   	push   %ebx
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8011c9:	85 db                	test   %ebx,%ebx
  8011cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011d0:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8011d3:	ff 75 14             	pushl  0x14(%ebp)
  8011d6:	53                   	push   %ebx
  8011d7:	56                   	push   %esi
  8011d8:	57                   	push   %edi
  8011d9:	e8 dc fb ff ff       	call   800dba <sys_ipc_try_send>
		if(!res)
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	74 20                	je     801205 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  8011e5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011e8:	75 07                	jne    8011f1 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  8011ea:	e8 03 fa ff ff       	call   800bf2 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8011ef:	eb e2                	jmp    8011d3 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	68 09 28 80 00       	push   $0x802809
  8011f9:	6a 3f                	push   $0x3f
  8011fb:	68 21 28 80 00       	push   $0x802821
  801200:	e8 8a 0d 00 00       	call   801f8f <_panic>
	}
}
  801205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801208:	5b                   	pop    %ebx
  801209:	5e                   	pop    %esi
  80120a:	5f                   	pop    %edi
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80120d:	f3 0f 1e fb          	endbr32 
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801217:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80121c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80121f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801225:	8b 52 50             	mov    0x50(%edx),%edx
  801228:	39 ca                	cmp    %ecx,%edx
  80122a:	74 11                	je     80123d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80122c:	83 c0 01             	add    $0x1,%eax
  80122f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801234:	75 e6                	jne    80121c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801236:	b8 00 00 00 00       	mov    $0x0,%eax
  80123b:	eb 0b                	jmp    801248 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80123d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801240:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801245:	8b 40 48             	mov    0x48(%eax),%eax
}
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	05 00 00 00 30       	add    $0x30000000,%eax
  801259:	c1 e8 0c             	shr    $0xc,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80125e:	f3 0f 1e fb          	endbr32 
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80126d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801272:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801279:	f3 0f 1e fb          	endbr32 
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801285:	89 c2                	mov    %eax,%edx
  801287:	c1 ea 16             	shr    $0x16,%edx
  80128a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801291:	f6 c2 01             	test   $0x1,%dl
  801294:	74 2d                	je     8012c3 <fd_alloc+0x4a>
  801296:	89 c2                	mov    %eax,%edx
  801298:	c1 ea 0c             	shr    $0xc,%edx
  80129b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012a2:	f6 c2 01             	test   $0x1,%dl
  8012a5:	74 1c                	je     8012c3 <fd_alloc+0x4a>
  8012a7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012ac:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012b1:	75 d2                	jne    801285 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012bc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012c1:	eb 0a                	jmp    8012cd <fd_alloc+0x54>
			*fd_store = fd;
  8012c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    

008012cf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012cf:	f3 0f 1e fb          	endbr32 
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012d9:	83 f8 1f             	cmp    $0x1f,%eax
  8012dc:	77 30                	ja     80130e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012de:	c1 e0 0c             	shl    $0xc,%eax
  8012e1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012e6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012ec:	f6 c2 01             	test   $0x1,%dl
  8012ef:	74 24                	je     801315 <fd_lookup+0x46>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	c1 ea 0c             	shr    $0xc,%edx
  8012f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012fd:	f6 c2 01             	test   $0x1,%dl
  801300:	74 1a                	je     80131c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801302:	8b 55 0c             	mov    0xc(%ebp),%edx
  801305:	89 02                	mov    %eax,(%edx)
	return 0;
  801307:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    
		return -E_INVAL;
  80130e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801313:	eb f7                	jmp    80130c <fd_lookup+0x3d>
		return -E_INVAL;
  801315:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131a:	eb f0                	jmp    80130c <fd_lookup+0x3d>
  80131c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801321:	eb e9                	jmp    80130c <fd_lookup+0x3d>

00801323 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801323:	f3 0f 1e fb          	endbr32 
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801330:	ba a8 28 80 00       	mov    $0x8028a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801335:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80133a:	39 08                	cmp    %ecx,(%eax)
  80133c:	74 33                	je     801371 <dev_lookup+0x4e>
  80133e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801341:	8b 02                	mov    (%edx),%eax
  801343:	85 c0                	test   %eax,%eax
  801345:	75 f3                	jne    80133a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801347:	a1 04 40 80 00       	mov    0x804004,%eax
  80134c:	8b 40 48             	mov    0x48(%eax),%eax
  80134f:	83 ec 04             	sub    $0x4,%esp
  801352:	51                   	push   %ecx
  801353:	50                   	push   %eax
  801354:	68 2c 28 80 00       	push   $0x80282c
  801359:	e8 6b ee ff ff       	call   8001c9 <cprintf>
	*dev = 0;
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
			*dev = devtab[i];
  801371:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801374:	89 01                	mov    %eax,(%ecx)
			return 0;
  801376:	b8 00 00 00 00       	mov    $0x0,%eax
  80137b:	eb f2                	jmp    80136f <dev_lookup+0x4c>

0080137d <fd_close>:
{
  80137d:	f3 0f 1e fb          	endbr32 
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	57                   	push   %edi
  801385:	56                   	push   %esi
  801386:	53                   	push   %ebx
  801387:	83 ec 24             	sub    $0x24,%esp
  80138a:	8b 75 08             	mov    0x8(%ebp),%esi
  80138d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801390:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801393:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801394:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80139a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80139d:	50                   	push   %eax
  80139e:	e8 2c ff ff ff       	call   8012cf <fd_lookup>
  8013a3:	89 c3                	mov    %eax,%ebx
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 05                	js     8013b1 <fd_close+0x34>
	    || fd != fd2)
  8013ac:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013af:	74 16                	je     8013c7 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013b1:	89 f8                	mov    %edi,%eax
  8013b3:	84 c0                	test   %al,%al
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	0f 44 d8             	cmove  %eax,%ebx
}
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 36                	pushl  (%esi)
  8013d0:	e8 4e ff ff ff       	call   801323 <dev_lookup>
  8013d5:	89 c3                	mov    %eax,%ebx
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 1a                	js     8013f8 <fd_close+0x7b>
		if (dev->dev_close)
  8013de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013e4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	74 0b                	je     8013f8 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	56                   	push   %esi
  8013f1:	ff d0                	call   *%eax
  8013f3:	89 c3                	mov    %eax,%ebx
  8013f5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013f8:	83 ec 08             	sub    $0x8,%esp
  8013fb:	56                   	push   %esi
  8013fc:	6a 00                	push   $0x0
  8013fe:	e8 9f f8 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	eb b5                	jmp    8013bd <fd_close+0x40>

00801408 <close>:

int
close(int fdnum)
{
  801408:	f3 0f 1e fb          	endbr32 
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801412:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	e8 b1 fe ff ff       	call   8012cf <fd_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	79 02                	jns    801427 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    
		return fd_close(fd, 1);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	6a 01                	push   $0x1
  80142c:	ff 75 f4             	pushl  -0xc(%ebp)
  80142f:	e8 49 ff ff ff       	call   80137d <fd_close>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	eb ec                	jmp    801425 <close+0x1d>

00801439 <close_all>:

void
close_all(void)
{
  801439:	f3 0f 1e fb          	endbr32 
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	53                   	push   %ebx
  801441:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801444:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	53                   	push   %ebx
  80144d:	e8 b6 ff ff ff       	call   801408 <close>
	for (i = 0; i < MAXFD; i++)
  801452:	83 c3 01             	add    $0x1,%ebx
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	83 fb 20             	cmp    $0x20,%ebx
  80145b:	75 ec                	jne    801449 <close_all+0x10>
}
  80145d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801462:	f3 0f 1e fb          	endbr32 
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	57                   	push   %edi
  80146a:	56                   	push   %esi
  80146b:	53                   	push   %ebx
  80146c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80146f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801472:	50                   	push   %eax
  801473:	ff 75 08             	pushl  0x8(%ebp)
  801476:	e8 54 fe ff ff       	call   8012cf <fd_lookup>
  80147b:	89 c3                	mov    %eax,%ebx
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	0f 88 81 00 00 00    	js     801509 <dup+0xa7>
		return r;
	close(newfdnum);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	e8 75 ff ff ff       	call   801408 <close>

	newfd = INDEX2FD(newfdnum);
  801493:	8b 75 0c             	mov    0xc(%ebp),%esi
  801496:	c1 e6 0c             	shl    $0xc,%esi
  801499:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a5:	e8 b4 fd ff ff       	call   80125e <fd2data>
  8014aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014ac:	89 34 24             	mov    %esi,(%esp)
  8014af:	e8 aa fd ff ff       	call   80125e <fd2data>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014b9:	89 d8                	mov    %ebx,%eax
  8014bb:	c1 e8 16             	shr    $0x16,%eax
  8014be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c5:	a8 01                	test   $0x1,%al
  8014c7:	74 11                	je     8014da <dup+0x78>
  8014c9:	89 d8                	mov    %ebx,%eax
  8014cb:	c1 e8 0c             	shr    $0xc,%eax
  8014ce:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014d5:	f6 c2 01             	test   $0x1,%dl
  8014d8:	75 39                	jne    801513 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014dd:	89 d0                	mov    %edx,%eax
  8014df:	c1 e8 0c             	shr    $0xc,%eax
  8014e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f1:	50                   	push   %eax
  8014f2:	56                   	push   %esi
  8014f3:	6a 00                	push   $0x0
  8014f5:	52                   	push   %edx
  8014f6:	6a 00                	push   $0x0
  8014f8:	e8 5f f7 ff ff       	call   800c5c <sys_page_map>
  8014fd:	89 c3                	mov    %eax,%ebx
  8014ff:	83 c4 20             	add    $0x20,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 31                	js     801537 <dup+0xd5>
		goto err;

	return newfdnum;
  801506:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801509:	89 d8                	mov    %ebx,%eax
  80150b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150e:	5b                   	pop    %ebx
  80150f:	5e                   	pop    %esi
  801510:	5f                   	pop    %edi
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801513:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80151a:	83 ec 0c             	sub    $0xc,%esp
  80151d:	25 07 0e 00 00       	and    $0xe07,%eax
  801522:	50                   	push   %eax
  801523:	57                   	push   %edi
  801524:	6a 00                	push   $0x0
  801526:	53                   	push   %ebx
  801527:	6a 00                	push   $0x0
  801529:	e8 2e f7 ff ff       	call   800c5c <sys_page_map>
  80152e:	89 c3                	mov    %eax,%ebx
  801530:	83 c4 20             	add    $0x20,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	79 a3                	jns    8014da <dup+0x78>
	sys_page_unmap(0, newfd);
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	56                   	push   %esi
  80153b:	6a 00                	push   $0x0
  80153d:	e8 60 f7 ff ff       	call   800ca2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801542:	83 c4 08             	add    $0x8,%esp
  801545:	57                   	push   %edi
  801546:	6a 00                	push   $0x0
  801548:	e8 55 f7 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	eb b7                	jmp    801509 <dup+0xa7>

00801552 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801552:	f3 0f 1e fb          	endbr32 
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	53                   	push   %ebx
  80155a:	83 ec 1c             	sub    $0x1c,%esp
  80155d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801560:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	53                   	push   %ebx
  801565:	e8 65 fd ff ff       	call   8012cf <fd_lookup>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 3f                	js     8015b0 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	ff 30                	pushl  (%eax)
  80157d:	e8 a1 fd ff ff       	call   801323 <dev_lookup>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	78 27                	js     8015b0 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801589:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158c:	8b 42 08             	mov    0x8(%edx),%eax
  80158f:	83 e0 03             	and    $0x3,%eax
  801592:	83 f8 01             	cmp    $0x1,%eax
  801595:	74 1e                	je     8015b5 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 40 08             	mov    0x8(%eax),%eax
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 35                	je     8015d6 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	ff 75 10             	pushl  0x10(%ebp)
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	52                   	push   %edx
  8015ab:	ff d0                	call   *%eax
  8015ad:	83 c4 10             	add    $0x10,%esp
}
  8015b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015ba:	8b 40 48             	mov    0x48(%eax),%eax
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	53                   	push   %ebx
  8015c1:	50                   	push   %eax
  8015c2:	68 6d 28 80 00       	push   $0x80286d
  8015c7:	e8 fd eb ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d4:	eb da                	jmp    8015b0 <read+0x5e>
		return -E_NOT_SUPP;
  8015d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015db:	eb d3                	jmp    8015b0 <read+0x5e>

008015dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015dd:	f3 0f 1e fb          	endbr32 
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	57                   	push   %edi
  8015e5:	56                   	push   %esi
  8015e6:	53                   	push   %ebx
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f5:	eb 02                	jmp    8015f9 <readn+0x1c>
  8015f7:	01 c3                	add    %eax,%ebx
  8015f9:	39 f3                	cmp    %esi,%ebx
  8015fb:	73 21                	jae    80161e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	89 f0                	mov    %esi,%eax
  801602:	29 d8                	sub    %ebx,%eax
  801604:	50                   	push   %eax
  801605:	89 d8                	mov    %ebx,%eax
  801607:	03 45 0c             	add    0xc(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	57                   	push   %edi
  80160c:	e8 41 ff ff ff       	call   801552 <read>
		if (m < 0)
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	78 04                	js     80161c <readn+0x3f>
			return m;
		if (m == 0)
  801618:	75 dd                	jne    8015f7 <readn+0x1a>
  80161a:	eb 02                	jmp    80161e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80161c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80161e:	89 d8                	mov    %ebx,%eax
  801620:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801623:	5b                   	pop    %ebx
  801624:	5e                   	pop    %esi
  801625:	5f                   	pop    %edi
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    

00801628 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801628:	f3 0f 1e fb          	endbr32 
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	53                   	push   %ebx
  801630:	83 ec 1c             	sub    $0x1c,%esp
  801633:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801636:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	53                   	push   %ebx
  80163b:	e8 8f fc ff ff       	call   8012cf <fd_lookup>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	78 3a                	js     801681 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164d:	50                   	push   %eax
  80164e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801651:	ff 30                	pushl  (%eax)
  801653:	e8 cb fc ff ff       	call   801323 <dev_lookup>
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	85 c0                	test   %eax,%eax
  80165d:	78 22                	js     801681 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801666:	74 1e                	je     801686 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166b:	8b 52 0c             	mov    0xc(%edx),%edx
  80166e:	85 d2                	test   %edx,%edx
  801670:	74 35                	je     8016a7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	ff 75 10             	pushl  0x10(%ebp)
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	50                   	push   %eax
  80167c:	ff d2                	call   *%edx
  80167e:	83 c4 10             	add    $0x10,%esp
}
  801681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801684:	c9                   	leave  
  801685:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801686:	a1 04 40 80 00       	mov    0x804004,%eax
  80168b:	8b 40 48             	mov    0x48(%eax),%eax
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	53                   	push   %ebx
  801692:	50                   	push   %eax
  801693:	68 89 28 80 00       	push   $0x802889
  801698:	e8 2c eb ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a5:	eb da                	jmp    801681 <write+0x59>
		return -E_NOT_SUPP;
  8016a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ac:	eb d3                	jmp    801681 <write+0x59>

008016ae <seek>:

int
seek(int fdnum, off_t offset)
{
  8016ae:	f3 0f 1e fb          	endbr32 
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 0b fc ff ff       	call   8012cf <fd_lookup>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 0e                	js     8016d9 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016db:	f3 0f 1e fb          	endbr32 
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 1c             	sub    $0x1c,%esp
  8016e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ec:	50                   	push   %eax
  8016ed:	53                   	push   %ebx
  8016ee:	e8 dc fb ff ff       	call   8012cf <fd_lookup>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 37                	js     801731 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801700:	50                   	push   %eax
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	ff 30                	pushl  (%eax)
  801706:	e8 18 fc ff ff       	call   801323 <dev_lookup>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 1f                	js     801731 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801715:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801719:	74 1b                	je     801736 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80171b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171e:	8b 52 18             	mov    0x18(%edx),%edx
  801721:	85 d2                	test   %edx,%edx
  801723:	74 32                	je     801757 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	50                   	push   %eax
  80172c:	ff d2                	call   *%edx
  80172e:	83 c4 10             	add    $0x10,%esp
}
  801731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801734:	c9                   	leave  
  801735:	c3                   	ret    
			thisenv->env_id, fdnum);
  801736:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80173b:	8b 40 48             	mov    0x48(%eax),%eax
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	53                   	push   %ebx
  801742:	50                   	push   %eax
  801743:	68 4c 28 80 00       	push   $0x80284c
  801748:	e8 7c ea ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801755:	eb da                	jmp    801731 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801757:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80175c:	eb d3                	jmp    801731 <ftruncate+0x56>

0080175e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80175e:	f3 0f 1e fb          	endbr32 
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	53                   	push   %ebx
  801766:	83 ec 1c             	sub    $0x1c,%esp
  801769:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80176c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176f:	50                   	push   %eax
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	e8 57 fb ff ff       	call   8012cf <fd_lookup>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 4b                	js     8017ca <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801785:	50                   	push   %eax
  801786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801789:	ff 30                	pushl  (%eax)
  80178b:	e8 93 fb ff ff       	call   801323 <dev_lookup>
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	78 33                	js     8017ca <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80179e:	74 2f                	je     8017cf <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017aa:	00 00 00 
	stat->st_isdir = 0;
  8017ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017b4:	00 00 00 
	stat->st_dev = dev;
  8017b7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	53                   	push   %ebx
  8017c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c4:	ff 50 14             	call   *0x14(%eax)
  8017c7:	83 c4 10             	add    $0x10,%esp
}
  8017ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    
		return -E_NOT_SUPP;
  8017cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d4:	eb f4                	jmp    8017ca <fstat+0x6c>

008017d6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017d6:	f3 0f 1e fb          	endbr32 
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	e8 fb 01 00 00       	call   8019e7 <open>
  8017ec:	89 c3                	mov    %eax,%ebx
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	78 1b                	js     801810 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017f5:	83 ec 08             	sub    $0x8,%esp
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	50                   	push   %eax
  8017fc:	e8 5d ff ff ff       	call   80175e <fstat>
  801801:	89 c6                	mov    %eax,%esi
	close(fd);
  801803:	89 1c 24             	mov    %ebx,(%esp)
  801806:	e8 fd fb ff ff       	call   801408 <close>
	return r;
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	89 f3                	mov    %esi,%ebx
}
  801810:	89 d8                	mov    %ebx,%eax
  801812:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    

00801819 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	89 c6                	mov    %eax,%esi
  801820:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801822:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801829:	74 27                	je     801852 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80182b:	6a 07                	push   $0x7
  80182d:	68 00 50 80 00       	push   $0x805000
  801832:	56                   	push   %esi
  801833:	ff 35 00 40 80 00    	pushl  0x804000
  801839:	e8 75 f9 ff ff       	call   8011b3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80183e:	83 c4 0c             	add    $0xc,%esp
  801841:	6a 00                	push   $0x0
  801843:	53                   	push   %ebx
  801844:	6a 00                	push   $0x0
  801846:	e8 fb f8 ff ff       	call   801146 <ipc_recv>
}
  80184b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184e:	5b                   	pop    %ebx
  80184f:	5e                   	pop    %esi
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801852:	83 ec 0c             	sub    $0xc,%esp
  801855:	6a 01                	push   $0x1
  801857:	e8 b1 f9 ff ff       	call   80120d <ipc_find_env>
  80185c:	a3 00 40 80 00       	mov    %eax,0x804000
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	eb c5                	jmp    80182b <fsipc+0x12>

00801866 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801866:	f3 0f 1e fb          	endbr32 
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	8b 40 0c             	mov    0xc(%eax),%eax
  801876:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80187b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801883:	ba 00 00 00 00       	mov    $0x0,%edx
  801888:	b8 02 00 00 00       	mov    $0x2,%eax
  80188d:	e8 87 ff ff ff       	call   801819 <fsipc>
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <devfile_flush>:
{
  801894:	f3 0f 1e fb          	endbr32 
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ae:	b8 06 00 00 00       	mov    $0x6,%eax
  8018b3:	e8 61 ff ff ff       	call   801819 <fsipc>
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <devfile_stat>:
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ce:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8018dd:	e8 37 ff ff ff       	call   801819 <fsipc>
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 2c                	js     801912 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	68 00 50 80 00       	push   $0x805000
  8018ee:	53                   	push   %ebx
  8018ef:	e8 df ee ff ff       	call   8007d3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018f4:	a1 80 50 80 00       	mov    0x805080,%eax
  8018f9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ff:	a1 84 50 80 00       	mov    0x805084,%eax
  801904:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <devfile_write>:
{
  801917:	f3 0f 1e fb          	endbr32 
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	8b 45 10             	mov    0x10(%ebp),%eax
  801924:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801929:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80192e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801931:	8b 55 08             	mov    0x8(%ebp),%edx
  801934:	8b 52 0c             	mov    0xc(%edx),%edx
  801937:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80193d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801942:	50                   	push   %eax
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	68 08 50 80 00       	push   $0x805008
  80194b:	e8 39 f0 ff ff       	call   800989 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	b8 04 00 00 00       	mov    $0x4,%eax
  80195a:	e8 ba fe ff ff       	call   801819 <fsipc>
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <devfile_read>:
{
  801961:	f3 0f 1e fb          	endbr32 
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
  80196a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 40 0c             	mov    0xc(%eax),%eax
  801973:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801978:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
  801983:	b8 03 00 00 00       	mov    $0x3,%eax
  801988:	e8 8c fe ff ff       	call   801819 <fsipc>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 1f                	js     8019b2 <devfile_read+0x51>
	assert(r <= n);
  801993:	39 f0                	cmp    %esi,%eax
  801995:	77 24                	ja     8019bb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801997:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80199c:	7f 33                	jg     8019d1 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	50                   	push   %eax
  8019a2:	68 00 50 80 00       	push   $0x805000
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	e8 da ef ff ff       	call   800989 <memmove>
	return r;
  8019af:	83 c4 10             	add    $0x10,%esp
}
  8019b2:	89 d8                	mov    %ebx,%eax
  8019b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    
	assert(r <= n);
  8019bb:	68 b8 28 80 00       	push   $0x8028b8
  8019c0:	68 bf 28 80 00       	push   $0x8028bf
  8019c5:	6a 7d                	push   $0x7d
  8019c7:	68 d4 28 80 00       	push   $0x8028d4
  8019cc:	e8 be 05 00 00       	call   801f8f <_panic>
	assert(r <= PGSIZE);
  8019d1:	68 df 28 80 00       	push   $0x8028df
  8019d6:	68 bf 28 80 00       	push   $0x8028bf
  8019db:	6a 7e                	push   $0x7e
  8019dd:	68 d4 28 80 00       	push   $0x8028d4
  8019e2:	e8 a8 05 00 00       	call   801f8f <_panic>

008019e7 <open>:
{
  8019e7:	f3 0f 1e fb          	endbr32 
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	56                   	push   %esi
  8019ef:	53                   	push   %ebx
  8019f0:	83 ec 1c             	sub    $0x1c,%esp
  8019f3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019f6:	56                   	push   %esi
  8019f7:	e8 94 ed ff ff       	call   800790 <strlen>
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a04:	7f 6c                	jg     801a72 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0c:	50                   	push   %eax
  801a0d:	e8 67 f8 ff ff       	call   801279 <fd_alloc>
  801a12:	89 c3                	mov    %eax,%ebx
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 3c                	js     801a57 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	56                   	push   %esi
  801a1f:	68 00 50 80 00       	push   $0x805000
  801a24:	e8 aa ed ff ff       	call   8007d3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a34:	b8 01 00 00 00       	mov    $0x1,%eax
  801a39:	e8 db fd ff ff       	call   801819 <fsipc>
  801a3e:	89 c3                	mov    %eax,%ebx
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 19                	js     801a60 <open+0x79>
	return fd2num(fd);
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4d:	e8 f8 f7 ff ff       	call   80124a <fd2num>
  801a52:	89 c3                	mov    %eax,%ebx
  801a54:	83 c4 10             	add    $0x10,%esp
}
  801a57:	89 d8                	mov    %ebx,%eax
  801a59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    
		fd_close(fd, 0);
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 f4             	pushl  -0xc(%ebp)
  801a68:	e8 10 f9 ff ff       	call   80137d <fd_close>
		return r;
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	eb e5                	jmp    801a57 <open+0x70>
		return -E_BAD_PATH;
  801a72:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a77:	eb de                	jmp    801a57 <open+0x70>

00801a79 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a79:	f3 0f 1e fb          	endbr32 
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a83:	ba 00 00 00 00       	mov    $0x0,%edx
  801a88:	b8 08 00 00 00       	mov    $0x8,%eax
  801a8d:	e8 87 fd ff ff       	call   801819 <fsipc>
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a94:	f3 0f 1e fb          	endbr32 
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aa0:	83 ec 0c             	sub    $0xc,%esp
  801aa3:	ff 75 08             	pushl  0x8(%ebp)
  801aa6:	e8 b3 f7 ff ff       	call   80125e <fd2data>
  801aab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801aad:	83 c4 08             	add    $0x8,%esp
  801ab0:	68 eb 28 80 00       	push   $0x8028eb
  801ab5:	53                   	push   %ebx
  801ab6:	e8 18 ed ff ff       	call   8007d3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801abb:	8b 46 04             	mov    0x4(%esi),%eax
  801abe:	2b 06                	sub    (%esi),%eax
  801ac0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ac6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801acd:	00 00 00 
	stat->st_dev = &devpipe;
  801ad0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ad7:	30 80 00 
	return 0;
}
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ae6:	f3 0f 1e fb          	endbr32 
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801af4:	53                   	push   %ebx
  801af5:	6a 00                	push   $0x0
  801af7:	e8 a6 f1 ff ff       	call   800ca2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801afc:	89 1c 24             	mov    %ebx,(%esp)
  801aff:	e8 5a f7 ff ff       	call   80125e <fd2data>
  801b04:	83 c4 08             	add    $0x8,%esp
  801b07:	50                   	push   %eax
  801b08:	6a 00                	push   $0x0
  801b0a:	e8 93 f1 ff ff       	call   800ca2 <sys_page_unmap>
}
  801b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <_pipeisclosed>:
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	57                   	push   %edi
  801b18:	56                   	push   %esi
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 1c             	sub    $0x1c,%esp
  801b1d:	89 c7                	mov    %eax,%edi
  801b1f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b21:	a1 04 40 80 00       	mov    0x804004,%eax
  801b26:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	57                   	push   %edi
  801b2d:	e8 47 05 00 00       	call   802079 <pageref>
  801b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b35:	89 34 24             	mov    %esi,(%esp)
  801b38:	e8 3c 05 00 00       	call   802079 <pageref>
		nn = thisenv->env_runs;
  801b3d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b43:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	39 cb                	cmp    %ecx,%ebx
  801b4b:	74 1b                	je     801b68 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b50:	75 cf                	jne    801b21 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b52:	8b 42 58             	mov    0x58(%edx),%eax
  801b55:	6a 01                	push   $0x1
  801b57:	50                   	push   %eax
  801b58:	53                   	push   %ebx
  801b59:	68 f2 28 80 00       	push   $0x8028f2
  801b5e:	e8 66 e6 ff ff       	call   8001c9 <cprintf>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	eb b9                	jmp    801b21 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b6b:	0f 94 c0             	sete   %al
  801b6e:	0f b6 c0             	movzbl %al,%eax
}
  801b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b74:	5b                   	pop    %ebx
  801b75:	5e                   	pop    %esi
  801b76:	5f                   	pop    %edi
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    

00801b79 <devpipe_write>:
{
  801b79:	f3 0f 1e fb          	endbr32 
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	57                   	push   %edi
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	83 ec 28             	sub    $0x28,%esp
  801b86:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b89:	56                   	push   %esi
  801b8a:	e8 cf f6 ff ff       	call   80125e <fd2data>
  801b8f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	bf 00 00 00 00       	mov    $0x0,%edi
  801b99:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b9c:	74 4f                	je     801bed <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b9e:	8b 43 04             	mov    0x4(%ebx),%eax
  801ba1:	8b 0b                	mov    (%ebx),%ecx
  801ba3:	8d 51 20             	lea    0x20(%ecx),%edx
  801ba6:	39 d0                	cmp    %edx,%eax
  801ba8:	72 14                	jb     801bbe <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801baa:	89 da                	mov    %ebx,%edx
  801bac:	89 f0                	mov    %esi,%eax
  801bae:	e8 61 ff ff ff       	call   801b14 <_pipeisclosed>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	75 3b                	jne    801bf2 <devpipe_write+0x79>
			sys_yield();
  801bb7:	e8 36 f0 ff ff       	call   800bf2 <sys_yield>
  801bbc:	eb e0                	jmp    801b9e <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bc5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bc8:	89 c2                	mov    %eax,%edx
  801bca:	c1 fa 1f             	sar    $0x1f,%edx
  801bcd:	89 d1                	mov    %edx,%ecx
  801bcf:	c1 e9 1b             	shr    $0x1b,%ecx
  801bd2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bd5:	83 e2 1f             	and    $0x1f,%edx
  801bd8:	29 ca                	sub    %ecx,%edx
  801bda:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bde:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801be2:	83 c0 01             	add    $0x1,%eax
  801be5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801be8:	83 c7 01             	add    $0x1,%edi
  801beb:	eb ac                	jmp    801b99 <devpipe_write+0x20>
	return i;
  801bed:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf0:	eb 05                	jmp    801bf7 <devpipe_write+0x7e>
				return 0;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5f                   	pop    %edi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <devpipe_read>:
{
  801bff:	f3 0f 1e fb          	endbr32 
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	57                   	push   %edi
  801c07:	56                   	push   %esi
  801c08:	53                   	push   %ebx
  801c09:	83 ec 18             	sub    $0x18,%esp
  801c0c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c0f:	57                   	push   %edi
  801c10:	e8 49 f6 ff ff       	call   80125e <fd2data>
  801c15:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	be 00 00 00 00       	mov    $0x0,%esi
  801c1f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c22:	75 14                	jne    801c38 <devpipe_read+0x39>
	return i;
  801c24:	8b 45 10             	mov    0x10(%ebp),%eax
  801c27:	eb 02                	jmp    801c2b <devpipe_read+0x2c>
				return i;
  801c29:	89 f0                	mov    %esi,%eax
}
  801c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5f                   	pop    %edi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    
			sys_yield();
  801c33:	e8 ba ef ff ff       	call   800bf2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c38:	8b 03                	mov    (%ebx),%eax
  801c3a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c3d:	75 18                	jne    801c57 <devpipe_read+0x58>
			if (i > 0)
  801c3f:	85 f6                	test   %esi,%esi
  801c41:	75 e6                	jne    801c29 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c43:	89 da                	mov    %ebx,%edx
  801c45:	89 f8                	mov    %edi,%eax
  801c47:	e8 c8 fe ff ff       	call   801b14 <_pipeisclosed>
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	74 e3                	je     801c33 <devpipe_read+0x34>
				return 0;
  801c50:	b8 00 00 00 00       	mov    $0x0,%eax
  801c55:	eb d4                	jmp    801c2b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c57:	99                   	cltd   
  801c58:	c1 ea 1b             	shr    $0x1b,%edx
  801c5b:	01 d0                	add    %edx,%eax
  801c5d:	83 e0 1f             	and    $0x1f,%eax
  801c60:	29 d0                	sub    %edx,%eax
  801c62:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c6a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c6d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c70:	83 c6 01             	add    $0x1,%esi
  801c73:	eb aa                	jmp    801c1f <devpipe_read+0x20>

00801c75 <pipe>:
{
  801c75:	f3 0f 1e fb          	endbr32 
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	56                   	push   %esi
  801c7d:	53                   	push   %ebx
  801c7e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c84:	50                   	push   %eax
  801c85:	e8 ef f5 ff ff       	call   801279 <fd_alloc>
  801c8a:	89 c3                	mov    %eax,%ebx
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	0f 88 23 01 00 00    	js     801dba <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 07 04 00 00       	push   $0x407
  801c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca2:	6a 00                	push   $0x0
  801ca4:	e8 6c ef ff ff       	call   800c15 <sys_page_alloc>
  801ca9:	89 c3                	mov    %eax,%ebx
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	0f 88 04 01 00 00    	js     801dba <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801cb6:	83 ec 0c             	sub    $0xc,%esp
  801cb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cbc:	50                   	push   %eax
  801cbd:	e8 b7 f5 ff ff       	call   801279 <fd_alloc>
  801cc2:	89 c3                	mov    %eax,%ebx
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	0f 88 db 00 00 00    	js     801daa <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	68 07 04 00 00       	push   $0x407
  801cd7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cda:	6a 00                	push   $0x0
  801cdc:	e8 34 ef ff ff       	call   800c15 <sys_page_alloc>
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	0f 88 bc 00 00 00    	js     801daa <pipe+0x135>
	va = fd2data(fd0);
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf4:	e8 65 f5 ff ff       	call   80125e <fd2data>
  801cf9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfb:	83 c4 0c             	add    $0xc,%esp
  801cfe:	68 07 04 00 00       	push   $0x407
  801d03:	50                   	push   %eax
  801d04:	6a 00                	push   $0x0
  801d06:	e8 0a ef ff ff       	call   800c15 <sys_page_alloc>
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	85 c0                	test   %eax,%eax
  801d12:	0f 88 82 00 00 00    	js     801d9a <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d18:	83 ec 0c             	sub    $0xc,%esp
  801d1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1e:	e8 3b f5 ff ff       	call   80125e <fd2data>
  801d23:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d2a:	50                   	push   %eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	56                   	push   %esi
  801d2e:	6a 00                	push   $0x0
  801d30:	e8 27 ef ff ff       	call   800c5c <sys_page_map>
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	83 c4 20             	add    $0x20,%esp
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	78 4e                	js     801d8c <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d3e:	a1 20 30 80 00       	mov    0x803020,%eax
  801d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d46:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d55:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	ff 75 f4             	pushl  -0xc(%ebp)
  801d67:	e8 de f4 ff ff       	call   80124a <fd2num>
  801d6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d71:	83 c4 04             	add    $0x4,%esp
  801d74:	ff 75 f0             	pushl  -0x10(%ebp)
  801d77:	e8 ce f4 ff ff       	call   80124a <fd2num>
  801d7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d82:	83 c4 10             	add    $0x10,%esp
  801d85:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d8a:	eb 2e                	jmp    801dba <pipe+0x145>
	sys_page_unmap(0, va);
  801d8c:	83 ec 08             	sub    $0x8,%esp
  801d8f:	56                   	push   %esi
  801d90:	6a 00                	push   $0x0
  801d92:	e8 0b ef ff ff       	call   800ca2 <sys_page_unmap>
  801d97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801da0:	6a 00                	push   $0x0
  801da2:	e8 fb ee ff ff       	call   800ca2 <sys_page_unmap>
  801da7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801daa:	83 ec 08             	sub    $0x8,%esp
  801dad:	ff 75 f4             	pushl  -0xc(%ebp)
  801db0:	6a 00                	push   $0x0
  801db2:	e8 eb ee ff ff       	call   800ca2 <sys_page_unmap>
  801db7:	83 c4 10             	add    $0x10,%esp
}
  801dba:	89 d8                	mov    %ebx,%eax
  801dbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <pipeisclosed>:
{
  801dc3:	f3 0f 1e fb          	endbr32 
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd0:	50                   	push   %eax
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	e8 f6 f4 ff ff       	call   8012cf <fd_lookup>
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	78 18                	js     801df8 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 f4             	pushl  -0xc(%ebp)
  801de6:	e8 73 f4 ff ff       	call   80125e <fd2data>
  801deb:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	e8 1f fd ff ff       	call   801b14 <_pipeisclosed>
  801df5:	83 c4 10             	add    $0x10,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dfa:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801e03:	c3                   	ret    

00801e04 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e04:	f3 0f 1e fb          	endbr32 
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e0e:	68 0a 29 80 00       	push   $0x80290a
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	e8 b8 e9 ff ff       	call   8007d3 <strcpy>
	return 0;
}
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <devcons_write>:
{
  801e22:	f3 0f 1e fb          	endbr32 
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	57                   	push   %edi
  801e2a:	56                   	push   %esi
  801e2b:	53                   	push   %ebx
  801e2c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e32:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e37:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e40:	73 31                	jae    801e73 <devcons_write+0x51>
		m = n - tot;
  801e42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e45:	29 f3                	sub    %esi,%ebx
  801e47:	83 fb 7f             	cmp    $0x7f,%ebx
  801e4a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e4f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	53                   	push   %ebx
  801e56:	89 f0                	mov    %esi,%eax
  801e58:	03 45 0c             	add    0xc(%ebp),%eax
  801e5b:	50                   	push   %eax
  801e5c:	57                   	push   %edi
  801e5d:	e8 27 eb ff ff       	call   800989 <memmove>
		sys_cputs(buf, m);
  801e62:	83 c4 08             	add    $0x8,%esp
  801e65:	53                   	push   %ebx
  801e66:	57                   	push   %edi
  801e67:	e8 d9 ec ff ff       	call   800b45 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e6c:	01 de                	add    %ebx,%esi
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	eb ca                	jmp    801e3d <devcons_write+0x1b>
}
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5e                   	pop    %esi
  801e7a:	5f                   	pop    %edi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    

00801e7d <devcons_read>:
{
  801e7d:	f3 0f 1e fb          	endbr32 
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e90:	74 21                	je     801eb3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801e92:	e8 d0 ec ff ff       	call   800b67 <sys_cgetc>
  801e97:	85 c0                	test   %eax,%eax
  801e99:	75 07                	jne    801ea2 <devcons_read+0x25>
		sys_yield();
  801e9b:	e8 52 ed ff ff       	call   800bf2 <sys_yield>
  801ea0:	eb f0                	jmp    801e92 <devcons_read+0x15>
	if (c < 0)
  801ea2:	78 0f                	js     801eb3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ea4:	83 f8 04             	cmp    $0x4,%eax
  801ea7:	74 0c                	je     801eb5 <devcons_read+0x38>
	*(char*)vbuf = c;
  801ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eac:	88 02                	mov    %al,(%edx)
	return 1;
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    
		return 0;
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eba:	eb f7                	jmp    801eb3 <devcons_read+0x36>

00801ebc <cputchar>:
{
  801ebc:	f3 0f 1e fb          	endbr32 
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ecc:	6a 01                	push   $0x1
  801ece:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ed1:	50                   	push   %eax
  801ed2:	e8 6e ec ff ff       	call   800b45 <sys_cputs>
}
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <getchar>:
{
  801edc:	f3 0f 1e fb          	endbr32 
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ee6:	6a 01                	push   $0x1
  801ee8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eeb:	50                   	push   %eax
  801eec:	6a 00                	push   $0x0
  801eee:	e8 5f f6 ff ff       	call   801552 <read>
	if (r < 0)
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	78 06                	js     801f00 <getchar+0x24>
	if (r < 1)
  801efa:	74 06                	je     801f02 <getchar+0x26>
	return c;
  801efc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    
		return -E_EOF;
  801f02:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f07:	eb f7                	jmp    801f00 <getchar+0x24>

00801f09 <iscons>:
{
  801f09:	f3 0f 1e fb          	endbr32 
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f16:	50                   	push   %eax
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	e8 b0 f3 ff ff       	call   8012cf <fd_lookup>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 11                	js     801f37 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f2f:	39 10                	cmp    %edx,(%eax)
  801f31:	0f 94 c0             	sete   %al
  801f34:	0f b6 c0             	movzbl %al,%eax
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <opencons>:
{
  801f39:	f3 0f 1e fb          	endbr32 
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f46:	50                   	push   %eax
  801f47:	e8 2d f3 ff ff       	call   801279 <fd_alloc>
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	78 3a                	js     801f8d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f53:	83 ec 04             	sub    $0x4,%esp
  801f56:	68 07 04 00 00       	push   $0x407
  801f5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5e:	6a 00                	push   $0x0
  801f60:	e8 b0 ec ff ff       	call   800c15 <sys_page_alloc>
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 21                	js     801f8d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f75:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	50                   	push   %eax
  801f85:	e8 c0 f2 ff ff       	call   80124a <fd2num>
  801f8a:	83 c4 10             	add    $0x10,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f8f:	f3 0f 1e fb          	endbr32 
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	56                   	push   %esi
  801f97:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f98:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f9b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801fa1:	e8 29 ec ff ff       	call   800bcf <sys_getenvid>
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	ff 75 08             	pushl  0x8(%ebp)
  801faf:	56                   	push   %esi
  801fb0:	50                   	push   %eax
  801fb1:	68 18 29 80 00       	push   $0x802918
  801fb6:	e8 0e e2 ff ff       	call   8001c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	53                   	push   %ebx
  801fbf:	ff 75 10             	pushl  0x10(%ebp)
  801fc2:	e8 ad e1 ff ff       	call   800174 <vcprintf>
	cprintf("\n");
  801fc7:	c7 04 24 03 29 80 00 	movl   $0x802903,(%esp)
  801fce:	e8 f6 e1 ff ff       	call   8001c9 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fd6:	cc                   	int3   
  801fd7:	eb fd                	jmp    801fd6 <_panic+0x47>

00801fd9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801fd9:	f3 0f 1e fb          	endbr32 
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	53                   	push   %ebx
  801fe1:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fe4:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801feb:	74 0d                	je     801ffa <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    
		envid_t envid=sys_getenvid();
  801ffa:	e8 d0 eb ff ff       	call   800bcf <sys_getenvid>
  801fff:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  802001:	83 ec 04             	sub    $0x4,%esp
  802004:	6a 07                	push   $0x7
  802006:	68 00 f0 bf ee       	push   $0xeebff000
  80200b:	50                   	push   %eax
  80200c:	e8 04 ec ff ff       	call   800c15 <sys_page_alloc>
  802011:	83 c4 10             	add    $0x10,%esp
  802014:	85 c0                	test   %eax,%eax
  802016:	78 29                	js     802041 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	68 55 20 80 00       	push   $0x802055
  802020:	53                   	push   %ebx
  802021:	e8 4e ed ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	85 c0                	test   %eax,%eax
  80202b:	79 c0                	jns    801fed <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	68 68 29 80 00       	push   $0x802968
  802035:	6a 24                	push   $0x24
  802037:	68 9f 29 80 00       	push   $0x80299f
  80203c:	e8 4e ff ff ff       	call   801f8f <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	68 3c 29 80 00       	push   $0x80293c
  802049:	6a 22                	push   $0x22
  80204b:	68 9f 29 80 00       	push   $0x80299f
  802050:	e8 3a ff ff ff       	call   801f8f <_panic>

00802055 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802055:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802056:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80205b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80205d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  802060:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  802063:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  802067:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  80206c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  802070:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802072:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802073:	83 c4 04             	add    $0x4,%esp
	popfl
  802076:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802077:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802078:	c3                   	ret    

00802079 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802079:	f3 0f 1e fb          	endbr32 
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802083:	89 c2                	mov    %eax,%edx
  802085:	c1 ea 16             	shr    $0x16,%edx
  802088:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80208f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802094:	f6 c1 01             	test   $0x1,%cl
  802097:	74 1c                	je     8020b5 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802099:	c1 e8 0c             	shr    $0xc,%eax
  80209c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020a3:	a8 01                	test   $0x1,%al
  8020a5:	74 0e                	je     8020b5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020a7:	c1 e8 0c             	shr    $0xc,%eax
  8020aa:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020b1:	ef 
  8020b2:	0f b7 d2             	movzwl %dx,%edx
}
  8020b5:	89 d0                	mov    %edx,%eax
  8020b7:	5d                   	pop    %ebp
  8020b8:	c3                   	ret    
  8020b9:	66 90                	xchg   %ax,%ax
  8020bb:	66 90                	xchg   %ax,%ax
  8020bd:	66 90                	xchg   %ax,%ax
  8020bf:	90                   	nop

008020c0 <__udivdi3>:
  8020c0:	f3 0f 1e fb          	endbr32 
  8020c4:	55                   	push   %ebp
  8020c5:	57                   	push   %edi
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	83 ec 1c             	sub    $0x1c,%esp
  8020cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020db:	85 d2                	test   %edx,%edx
  8020dd:	75 19                	jne    8020f8 <__udivdi3+0x38>
  8020df:	39 f3                	cmp    %esi,%ebx
  8020e1:	76 4d                	jbe    802130 <__udivdi3+0x70>
  8020e3:	31 ff                	xor    %edi,%edi
  8020e5:	89 e8                	mov    %ebp,%eax
  8020e7:	89 f2                	mov    %esi,%edx
  8020e9:	f7 f3                	div    %ebx
  8020eb:	89 fa                	mov    %edi,%edx
  8020ed:	83 c4 1c             	add    $0x1c,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	39 f2                	cmp    %esi,%edx
  8020fa:	76 14                	jbe    802110 <__udivdi3+0x50>
  8020fc:	31 ff                	xor    %edi,%edi
  8020fe:	31 c0                	xor    %eax,%eax
  802100:	89 fa                	mov    %edi,%edx
  802102:	83 c4 1c             	add    $0x1c,%esp
  802105:	5b                   	pop    %ebx
  802106:	5e                   	pop    %esi
  802107:	5f                   	pop    %edi
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    
  80210a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802110:	0f bd fa             	bsr    %edx,%edi
  802113:	83 f7 1f             	xor    $0x1f,%edi
  802116:	75 48                	jne    802160 <__udivdi3+0xa0>
  802118:	39 f2                	cmp    %esi,%edx
  80211a:	72 06                	jb     802122 <__udivdi3+0x62>
  80211c:	31 c0                	xor    %eax,%eax
  80211e:	39 eb                	cmp    %ebp,%ebx
  802120:	77 de                	ja     802100 <__udivdi3+0x40>
  802122:	b8 01 00 00 00       	mov    $0x1,%eax
  802127:	eb d7                	jmp    802100 <__udivdi3+0x40>
  802129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802130:	89 d9                	mov    %ebx,%ecx
  802132:	85 db                	test   %ebx,%ebx
  802134:	75 0b                	jne    802141 <__udivdi3+0x81>
  802136:	b8 01 00 00 00       	mov    $0x1,%eax
  80213b:	31 d2                	xor    %edx,%edx
  80213d:	f7 f3                	div    %ebx
  80213f:	89 c1                	mov    %eax,%ecx
  802141:	31 d2                	xor    %edx,%edx
  802143:	89 f0                	mov    %esi,%eax
  802145:	f7 f1                	div    %ecx
  802147:	89 c6                	mov    %eax,%esi
  802149:	89 e8                	mov    %ebp,%eax
  80214b:	89 f7                	mov    %esi,%edi
  80214d:	f7 f1                	div    %ecx
  80214f:	89 fa                	mov    %edi,%edx
  802151:	83 c4 1c             	add    $0x1c,%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5f                   	pop    %edi
  802157:	5d                   	pop    %ebp
  802158:	c3                   	ret    
  802159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802160:	89 f9                	mov    %edi,%ecx
  802162:	b8 20 00 00 00       	mov    $0x20,%eax
  802167:	29 f8                	sub    %edi,%eax
  802169:	d3 e2                	shl    %cl,%edx
  80216b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	89 da                	mov    %ebx,%edx
  802173:	d3 ea                	shr    %cl,%edx
  802175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802179:	09 d1                	or     %edx,%ecx
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e3                	shl    %cl,%ebx
  802185:	89 c1                	mov    %eax,%ecx
  802187:	d3 ea                	shr    %cl,%edx
  802189:	89 f9                	mov    %edi,%ecx
  80218b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80218f:	89 eb                	mov    %ebp,%ebx
  802191:	d3 e6                	shl    %cl,%esi
  802193:	89 c1                	mov    %eax,%ecx
  802195:	d3 eb                	shr    %cl,%ebx
  802197:	09 de                	or     %ebx,%esi
  802199:	89 f0                	mov    %esi,%eax
  80219b:	f7 74 24 08          	divl   0x8(%esp)
  80219f:	89 d6                	mov    %edx,%esi
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	f7 64 24 0c          	mull   0xc(%esp)
  8021a7:	39 d6                	cmp    %edx,%esi
  8021a9:	72 15                	jb     8021c0 <__udivdi3+0x100>
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	39 c5                	cmp    %eax,%ebp
  8021b1:	73 04                	jae    8021b7 <__udivdi3+0xf7>
  8021b3:	39 d6                	cmp    %edx,%esi
  8021b5:	74 09                	je     8021c0 <__udivdi3+0x100>
  8021b7:	89 d8                	mov    %ebx,%eax
  8021b9:	31 ff                	xor    %edi,%edi
  8021bb:	e9 40 ff ff ff       	jmp    802100 <__udivdi3+0x40>
  8021c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021c3:	31 ff                	xor    %edi,%edi
  8021c5:	e9 36 ff ff ff       	jmp    802100 <__udivdi3+0x40>
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	57                   	push   %edi
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
  8021db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	75 19                	jne    802208 <__umoddi3+0x38>
  8021ef:	39 df                	cmp    %ebx,%edi
  8021f1:	76 5d                	jbe    802250 <__umoddi3+0x80>
  8021f3:	89 f0                	mov    %esi,%eax
  8021f5:	89 da                	mov    %ebx,%edx
  8021f7:	f7 f7                	div    %edi
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	89 f2                	mov    %esi,%edx
  80220a:	39 d8                	cmp    %ebx,%eax
  80220c:	76 12                	jbe    802220 <__umoddi3+0x50>
  80220e:	89 f0                	mov    %esi,%eax
  802210:	89 da                	mov    %ebx,%edx
  802212:	83 c4 1c             	add    $0x1c,%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    
  80221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802220:	0f bd e8             	bsr    %eax,%ebp
  802223:	83 f5 1f             	xor    $0x1f,%ebp
  802226:	75 50                	jne    802278 <__umoddi3+0xa8>
  802228:	39 d8                	cmp    %ebx,%eax
  80222a:	0f 82 e0 00 00 00    	jb     802310 <__umoddi3+0x140>
  802230:	89 d9                	mov    %ebx,%ecx
  802232:	39 f7                	cmp    %esi,%edi
  802234:	0f 86 d6 00 00 00    	jbe    802310 <__umoddi3+0x140>
  80223a:	89 d0                	mov    %edx,%eax
  80223c:	89 ca                	mov    %ecx,%edx
  80223e:	83 c4 1c             	add    $0x1c,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
  802246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	89 fd                	mov    %edi,%ebp
  802252:	85 ff                	test   %edi,%edi
  802254:	75 0b                	jne    802261 <__umoddi3+0x91>
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f7                	div    %edi
  80225f:	89 c5                	mov    %eax,%ebp
  802261:	89 d8                	mov    %ebx,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f5                	div    %ebp
  802267:	89 f0                	mov    %esi,%eax
  802269:	f7 f5                	div    %ebp
  80226b:	89 d0                	mov    %edx,%eax
  80226d:	31 d2                	xor    %edx,%edx
  80226f:	eb 8c                	jmp    8021fd <__umoddi3+0x2d>
  802271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802278:	89 e9                	mov    %ebp,%ecx
  80227a:	ba 20 00 00 00       	mov    $0x20,%edx
  80227f:	29 ea                	sub    %ebp,%edx
  802281:	d3 e0                	shl    %cl,%eax
  802283:	89 44 24 08          	mov    %eax,0x8(%esp)
  802287:	89 d1                	mov    %edx,%ecx
  802289:	89 f8                	mov    %edi,%eax
  80228b:	d3 e8                	shr    %cl,%eax
  80228d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802291:	89 54 24 04          	mov    %edx,0x4(%esp)
  802295:	8b 54 24 04          	mov    0x4(%esp),%edx
  802299:	09 c1                	or     %eax,%ecx
  80229b:	89 d8                	mov    %ebx,%eax
  80229d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a1:	89 e9                	mov    %ebp,%ecx
  8022a3:	d3 e7                	shl    %cl,%edi
  8022a5:	89 d1                	mov    %edx,%ecx
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022af:	d3 e3                	shl    %cl,%ebx
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	89 d1                	mov    %edx,%ecx
  8022b5:	89 f0                	mov    %esi,%eax
  8022b7:	d3 e8                	shr    %cl,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	89 fa                	mov    %edi,%edx
  8022bd:	d3 e6                	shl    %cl,%esi
  8022bf:	09 d8                	or     %ebx,%eax
  8022c1:	f7 74 24 08          	divl   0x8(%esp)
  8022c5:	89 d1                	mov    %edx,%ecx
  8022c7:	89 f3                	mov    %esi,%ebx
  8022c9:	f7 64 24 0c          	mull   0xc(%esp)
  8022cd:	89 c6                	mov    %eax,%esi
  8022cf:	89 d7                	mov    %edx,%edi
  8022d1:	39 d1                	cmp    %edx,%ecx
  8022d3:	72 06                	jb     8022db <__umoddi3+0x10b>
  8022d5:	75 10                	jne    8022e7 <__umoddi3+0x117>
  8022d7:	39 c3                	cmp    %eax,%ebx
  8022d9:	73 0c                	jae    8022e7 <__umoddi3+0x117>
  8022db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022e3:	89 d7                	mov    %edx,%edi
  8022e5:	89 c6                	mov    %eax,%esi
  8022e7:	89 ca                	mov    %ecx,%edx
  8022e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ee:	29 f3                	sub    %esi,%ebx
  8022f0:	19 fa                	sbb    %edi,%edx
  8022f2:	89 d0                	mov    %edx,%eax
  8022f4:	d3 e0                	shl    %cl,%eax
  8022f6:	89 e9                	mov    %ebp,%ecx
  8022f8:	d3 eb                	shr    %cl,%ebx
  8022fa:	d3 ea                	shr    %cl,%edx
  8022fc:	09 d8                	or     %ebx,%eax
  8022fe:	83 c4 1c             	add    $0x1c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	29 fe                	sub    %edi,%esi
  802312:	19 c3                	sbb    %eax,%ebx
  802314:	89 f2                	mov    %esi,%edx
  802316:	89 d9                	mov    %ebx,%ecx
  802318:	e9 1d ff ff ff       	jmp    80223a <__umoddi3+0x6a>
