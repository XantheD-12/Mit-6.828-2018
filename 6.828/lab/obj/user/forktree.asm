
obj/user/forktree.debug：     文件格式 elf32-i386


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
  80002c:	e8 be 00 00 00       	call   8000ef <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  800041:	e8 b4 0b 00 00       	call   800bfa <sys_getenvid>
  800046:	83 ec 04             	sub    $0x4,%esp
  800049:	53                   	push   %ebx
  80004a:	50                   	push   %eax
  80004b:	68 60 23 80 00       	push   $0x802360
  800050:	e8 9f 01 00 00       	call   8001f4 <cprintf>

	forkchild(cur, '0');
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	6a 30                	push   $0x30
  80005a:	53                   	push   %ebx
  80005b:	e8 13 00 00 00       	call   800073 <forkchild>
	forkchild(cur, '1');
  800060:	83 c4 08             	add    $0x8,%esp
  800063:	6a 31                	push   $0x31
  800065:	53                   	push   %ebx
  800066:	e8 08 00 00 00       	call   800073 <forkchild>
}
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800071:	c9                   	leave  
  800072:	c3                   	ret    

00800073 <forkchild>:
{
  800073:	f3 0f 1e fb          	endbr32 
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	83 ec 1c             	sub    $0x1c,%esp
  80007f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800082:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  800085:	53                   	push   %ebx
  800086:	e8 30 07 00 00       	call   8007bb <strlen>
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 f8 02             	cmp    $0x2,%eax
  800091:	7e 07                	jle    80009a <forkchild+0x27>
}
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	89 f0                	mov    %esi,%eax
  80009f:	0f be f0             	movsbl %al,%esi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	68 71 23 80 00       	push   $0x802371
  8000a9:	6a 04                	push   $0x4
  8000ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 e9 06 00 00       	call   80079d <snprintf>
	if (fork() == 0) {
  8000b4:	83 c4 20             	add    $0x20,%esp
  8000b7:	e8 78 0e 00 00       	call   800f34 <fork>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	75 d3                	jne    800093 <forkchild+0x20>
		forktree(nxt);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 67 ff ff ff       	call   800033 <forktree>
		exit();
  8000cc:	e8 68 00 00 00       	call   800139 <exit>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	eb bd                	jmp    800093 <forkchild+0x20>

008000d6 <umain>:

void
umain(int argc, char **argv)
{
  8000d6:	f3 0f 1e fb          	endbr32 
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000e0:	68 70 23 80 00       	push   $0x802370
  8000e5:	e8 49 ff ff ff       	call   800033 <forktree>
}
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    

008000ef <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000fe:	e8 f7 0a 00 00       	call   800bfa <sys_getenvid>
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800115:	85 db                	test   %ebx,%ebx
  800117:	7e 07                	jle    800120 <libmain+0x31>
		binaryname = argv[0];
  800119:	8b 06                	mov    (%esi),%eax
  80011b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	56                   	push   %esi
  800124:	53                   	push   %ebx
  800125:	e8 ac ff ff ff       	call   8000d6 <umain>

	// exit gracefully
	exit();
  80012a:	e8 0a 00 00 00       	call   800139 <exit>
}
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800135:	5b                   	pop    %ebx
  800136:	5e                   	pop    %esi
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    

00800139 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800139:	f3 0f 1e fb          	endbr32 
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800143:	e8 18 12 00 00       	call   801360 <close_all>
	sys_env_destroy(0);
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	6a 00                	push   $0x0
  80014d:	e8 63 0a 00 00       	call   800bb5 <sys_env_destroy>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 dc 09 00 00       	call   800b70 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x23>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	f3 0f 1e fb          	endbr32 
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b3:	00 00 00 
	b.cnt = 0;
  8001b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	ff 75 08             	pushl  0x8(%ebp)
  8001c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cc:	50                   	push   %eax
  8001cd:	68 57 01 80 00       	push   $0x800157
  8001d2:	e8 20 01 00 00       	call   8002f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	83 c4 08             	add    $0x8,%esp
  8001da:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 84 09 00 00       	call   800b70 <sys_cputs>

	return b.cnt;
}
  8001ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f4:	f3 0f 1e fb          	endbr32 
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 95 ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 d1                	mov    %edx,%ecx
  800221:	89 c2                	mov    %eax,%edx
  800223:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800226:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800229:	8b 45 10             	mov    0x10(%ebp),%eax
  80022c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800232:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80023e:	72 3e                	jb     80027e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 18             	pushl  0x18(%ebp)
  800246:	83 eb 01             	sub    $0x1,%ebx
  800249:	53                   	push   %ebx
  80024a:	50                   	push   %eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800251:	ff 75 e0             	pushl  -0x20(%ebp)
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	e8 91 1e 00 00       	call   8020f0 <__udivdi3>
  80025f:	83 c4 18             	add    $0x18,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	89 f2                	mov    %esi,%edx
  800266:	89 f8                	mov    %edi,%eax
  800268:	e8 9f ff ff ff       	call   80020c <printnum>
  80026d:	83 c4 20             	add    $0x20,%esp
  800270:	eb 13                	jmp    800285 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	56                   	push   %esi
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	ff d7                	call   *%edi
  80027b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	85 db                	test   %ebx,%ebx
  800283:	7f ed                	jg     800272 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	56                   	push   %esi
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028f:	ff 75 e0             	pushl  -0x20(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	ff 75 d8             	pushl  -0x28(%ebp)
  800298:	e8 63 1f 00 00       	call   802200 <__umoddi3>
  80029d:	83 c4 14             	add    $0x14,%esp
  8002a0:	0f be 80 80 23 80 00 	movsbl 0x802380(%eax),%eax
  8002a7:	50                   	push   %eax
  8002a8:	ff d7                	call   *%edi
}
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b5:	f3 0f 1e fb          	endbr32 
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c3:	8b 10                	mov    (%eax),%edx
  8002c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c8:	73 0a                	jae    8002d4 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cd:	89 08                	mov    %ecx,(%eax)
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	88 02                	mov    %al,(%edx)
}
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    

008002d6 <printfmt>:
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 10             	pushl  0x10(%ebp)
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 05 00 00 00       	call   8002f7 <vprintfmt>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <vprintfmt>:
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	57                   	push   %edi
  8002ff:	56                   	push   %esi
  800300:	53                   	push   %ebx
  800301:	83 ec 3c             	sub    $0x3c,%esp
  800304:	8b 75 08             	mov    0x8(%ebp),%esi
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030d:	e9 8e 03 00 00       	jmp    8006a0 <vprintfmt+0x3a9>
		padc = ' ';
  800312:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800316:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80031d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8d 47 01             	lea    0x1(%edi),%eax
  800333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800336:	0f b6 17             	movzbl (%edi),%edx
  800339:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033c:	3c 55                	cmp    $0x55,%al
  80033e:	0f 87 df 03 00 00    	ja     800723 <vprintfmt+0x42c>
  800344:	0f b6 c0             	movzbl %al,%eax
  800347:	3e ff 24 85 c0 24 80 	notrack jmp *0x8024c0(,%eax,4)
  80034e:	00 
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800352:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800356:	eb d8                	jmp    800330 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80035b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80035f:	eb cf                	jmp    800330 <vprintfmt+0x39>
  800361:	0f b6 d2             	movzbl %dl,%edx
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
  80036c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800372:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800376:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037c:	83 f9 09             	cmp    $0x9,%ecx
  80037f:	77 55                	ja     8003d6 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800381:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800384:	eb e9                	jmp    80036f <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 40 04             	lea    0x4(%eax),%eax
  800394:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80039a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039e:	79 90                	jns    800330 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ad:	eb 81                	jmp    800330 <vprintfmt+0x39>
  8003af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b9:	0f 49 d0             	cmovns %eax,%edx
  8003bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c2:	e9 69 ff ff ff       	jmp    800330 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d1:	e9 5a ff ff ff       	jmp    800330 <vprintfmt+0x39>
  8003d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003dc:	eb bc                	jmp    80039a <vprintfmt+0xa3>
			lflag++;
  8003de:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e4:	e9 47 ff ff ff       	jmp    800330 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8d 78 04             	lea    0x4(%eax),%edi
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	53                   	push   %ebx
  8003f3:	ff 30                	pushl  (%eax)
  8003f5:	ff d6                	call   *%esi
			break;
  8003f7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003fa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fd:	e9 9b 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 78 04             	lea    0x4(%eax),%edi
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	99                   	cltd   
  80040b:	31 d0                	xor    %edx,%eax
  80040d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040f:	83 f8 0f             	cmp    $0xf,%eax
  800412:	7f 23                	jg     800437 <vprintfmt+0x140>
  800414:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 18                	je     800437 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80041f:	52                   	push   %edx
  800420:	68 d1 28 80 00       	push   $0x8028d1
  800425:	53                   	push   %ebx
  800426:	56                   	push   %esi
  800427:	e8 aa fe ff ff       	call   8002d6 <printfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800432:	e9 66 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800437:	50                   	push   %eax
  800438:	68 98 23 80 00       	push   $0x802398
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 92 fe ff ff       	call   8002d6 <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80044a:	e9 4e 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	83 c0 04             	add    $0x4,%eax
  800455:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80045d:	85 d2                	test   %edx,%edx
  80045f:	b8 91 23 80 00       	mov    $0x802391,%eax
  800464:	0f 45 c2             	cmovne %edx,%eax
  800467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80046a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046e:	7e 06                	jle    800476 <vprintfmt+0x17f>
  800470:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800474:	75 0d                	jne    800483 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800479:	89 c7                	mov    %eax,%edi
  80047b:	03 45 e0             	add    -0x20(%ebp),%eax
  80047e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800481:	eb 55                	jmp    8004d8 <vprintfmt+0x1e1>
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 d8             	pushl  -0x28(%ebp)
  800489:	ff 75 cc             	pushl  -0x34(%ebp)
  80048c:	e8 46 03 00 00       	call   8007d7 <strnlen>
  800491:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800494:	29 c2                	sub    %eax,%edx
  800496:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80049e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a5:	85 ff                	test   %edi,%edi
  8004a7:	7e 11                	jle    8004ba <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	53                   	push   %ebx
  8004ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b2:	83 ef 01             	sub    $0x1,%edi
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	eb eb                	jmp    8004a5 <vprintfmt+0x1ae>
  8004ba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c2             	cmovns %edx,%eax
  8004c7:	29 c2                	sub    %eax,%edx
  8004c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004cc:	eb a8                	jmp    800476 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	52                   	push   %edx
  8004d3:	ff d6                	call   *%esi
  8004d5:	83 c4 10             	add    $0x10,%esp
  8004d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004db:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004dd:	83 c7 01             	add    $0x1,%edi
  8004e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e4:	0f be d0             	movsbl %al,%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	74 4b                	je     800536 <vprintfmt+0x23f>
  8004eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ef:	78 06                	js     8004f7 <vprintfmt+0x200>
  8004f1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f5:	78 1e                	js     800515 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004fb:	74 d1                	je     8004ce <vprintfmt+0x1d7>
  8004fd:	0f be c0             	movsbl %al,%eax
  800500:	83 e8 20             	sub    $0x20,%eax
  800503:	83 f8 5e             	cmp    $0x5e,%eax
  800506:	76 c6                	jbe    8004ce <vprintfmt+0x1d7>
					putch('?', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 3f                	push   $0x3f
  80050e:	ff d6                	call   *%esi
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	eb c3                	jmp    8004d8 <vprintfmt+0x1e1>
  800515:	89 cf                	mov    %ecx,%edi
  800517:	eb 0e                	jmp    800527 <vprintfmt+0x230>
				putch(' ', putdat);
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	53                   	push   %ebx
  80051d:	6a 20                	push   $0x20
  80051f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800521:	83 ef 01             	sub    $0x1,%edi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	85 ff                	test   %edi,%edi
  800529:	7f ee                	jg     800519 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80052b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052e:	89 45 14             	mov    %eax,0x14(%ebp)
  800531:	e9 67 01 00 00       	jmp    80069d <vprintfmt+0x3a6>
  800536:	89 cf                	mov    %ecx,%edi
  800538:	eb ed                	jmp    800527 <vprintfmt+0x230>
	if (lflag >= 2)
  80053a:	83 f9 01             	cmp    $0x1,%ecx
  80053d:	7f 1b                	jg     80055a <vprintfmt+0x263>
	else if (lflag)
  80053f:	85 c9                	test   %ecx,%ecx
  800541:	74 63                	je     8005a6 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054b:	99                   	cltd   
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 04             	lea    0x4(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	eb 17                	jmp    800571 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 50 04             	mov    0x4(%eax),%edx
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 08             	lea    0x8(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800577:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	0f 89 ff 00 00 00    	jns    800683 <vprintfmt+0x38c>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800592:	f7 da                	neg    %edx
  800594:	83 d1 00             	adc    $0x0,%ecx
  800597:	f7 d9                	neg    %ecx
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a1:	e9 dd 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	99                   	cltd   
  8005af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb b4                	jmp    800571 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 1e                	jg     8005e0 <vprintfmt+0x2e9>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	74 32                	je     8005f8 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005db:	e9 a3 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e8:	8d 40 08             	lea    0x8(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005f3:	e9 8b 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80060d:	eb 74                	jmp    800683 <vprintfmt+0x38c>
	if (lflag >= 2)
  80060f:	83 f9 01             	cmp    $0x1,%ecx
  800612:	7f 1b                	jg     80062f <vprintfmt+0x338>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	74 2c                	je     800644 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800628:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80062d:	eb 54                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 10                	mov    (%eax),%edx
  800634:	8b 48 04             	mov    0x4(%eax),%ecx
  800637:	8d 40 08             	lea    0x8(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80063d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800642:	eb 3f                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 10                	mov    (%eax),%edx
  800649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800654:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800659:	eb 28                	jmp    800683 <vprintfmt+0x38c>
			putch('0', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 30                	push   $0x30
  800661:	ff d6                	call   *%esi
			putch('x', putdat);
  800663:	83 c4 08             	add    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	6a 78                	push   $0x78
  800669:	ff d6                	call   *%esi
			num = (unsigned long long)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 10                	mov    (%eax),%edx
  800670:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800675:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800683:	83 ec 0c             	sub    $0xc,%esp
  800686:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80068a:	57                   	push   %edi
  80068b:	ff 75 e0             	pushl  -0x20(%ebp)
  80068e:	50                   	push   %eax
  80068f:	51                   	push   %ecx
  800690:	52                   	push   %edx
  800691:	89 da                	mov    %ebx,%edx
  800693:	89 f0                	mov    %esi,%eax
  800695:	e8 72 fb ff ff       	call   80020c <printnum>
			break;
  80069a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80069d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a0:	83 c7 01             	add    $0x1,%edi
  8006a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a7:	83 f8 25             	cmp    $0x25,%eax
  8006aa:	0f 84 62 fc ff ff    	je     800312 <vprintfmt+0x1b>
			if (ch == '\0')
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	0f 84 8b 00 00 00    	je     800743 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	ff d6                	call   *%esi
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb dc                	jmp    8006a0 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006c4:	83 f9 01             	cmp    $0x1,%ecx
  8006c7:	7f 1b                	jg     8006e4 <vprintfmt+0x3ed>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 2c                	je     8006f9 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006e2:	eb 9f                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006f7:	eb 8a                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800709:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80070e:	e9 70 ff ff ff       	jmp    800683 <vprintfmt+0x38c>
			putch(ch, putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	6a 25                	push   $0x25
  800719:	ff d6                	call   *%esi
			break;
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	e9 7a ff ff ff       	jmp    80069d <vprintfmt+0x3a6>
			putch('%', putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 25                	push   $0x25
  800729:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	89 f8                	mov    %edi,%eax
  800730:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800734:	74 05                	je     80073b <vprintfmt+0x444>
  800736:	83 e8 01             	sub    $0x1,%eax
  800739:	eb f5                	jmp    800730 <vprintfmt+0x439>
  80073b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073e:	e9 5a ff ff ff       	jmp    80069d <vprintfmt+0x3a6>
}
  800743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800746:	5b                   	pop    %ebx
  800747:	5e                   	pop    %esi
  800748:	5f                   	pop    %edi
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80074b:	f3 0f 1e fb          	endbr32 
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800762:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076c:	85 c0                	test   %eax,%eax
  80076e:	74 26                	je     800796 <vsnprintf+0x4b>
  800770:	85 d2                	test   %edx,%edx
  800772:	7e 22                	jle    800796 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800774:	ff 75 14             	pushl  0x14(%ebp)
  800777:	ff 75 10             	pushl  0x10(%ebp)
  80077a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	68 b5 02 80 00       	push   $0x8002b5
  800783:	e8 6f fb ff ff       	call   8002f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800791:	83 c4 10             	add    $0x10,%esp
}
  800794:	c9                   	leave  
  800795:	c3                   	ret    
		return -E_INVAL;
  800796:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079b:	eb f7                	jmp    800794 <vsnprintf+0x49>

0080079d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079d:	f3 0f 1e fb          	endbr32 
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 10             	pushl  0x10(%ebp)
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 92 ff ff ff       	call   80074b <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007bb:	f3 0f 1e fb          	endbr32 
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ce:	74 05                	je     8007d5 <strlen+0x1a>
		n++;
  8007d0:	83 c0 01             	add    $0x1,%eax
  8007d3:	eb f5                	jmp    8007ca <strlen+0xf>
	return n;
}
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d7:	f3 0f 1e fb          	endbr32 
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e9:	39 d0                	cmp    %edx,%eax
  8007eb:	74 0d                	je     8007fa <strnlen+0x23>
  8007ed:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f1:	74 05                	je     8007f8 <strnlen+0x21>
		n++;
  8007f3:	83 c0 01             	add    $0x1,%eax
  8007f6:	eb f1                	jmp    8007e9 <strnlen+0x12>
  8007f8:	89 c2                	mov    %eax,%edx
	return n;
}
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fe:	f3 0f 1e fb          	endbr32 
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800809:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080c:	b8 00 00 00 00       	mov    $0x0,%eax
  800811:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800815:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800818:	83 c0 01             	add    $0x1,%eax
  80081b:	84 d2                	test   %dl,%dl
  80081d:	75 f2                	jne    800811 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80081f:	89 c8                	mov    %ecx,%eax
  800821:	5b                   	pop    %ebx
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800824:	f3 0f 1e fb          	endbr32 
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	53                   	push   %ebx
  80082c:	83 ec 10             	sub    $0x10,%esp
  80082f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800832:	53                   	push   %ebx
  800833:	e8 83 ff ff ff       	call   8007bb <strlen>
  800838:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	01 d8                	add    %ebx,%eax
  800840:	50                   	push   %eax
  800841:	e8 b8 ff ff ff       	call   8007fe <strcpy>
	return dst;
}
  800846:	89 d8                	mov    %ebx,%eax
  800848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084d:	f3 0f 1e fb          	endbr32 
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 f3                	mov    %esi,%ebx
  80085e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800861:	89 f0                	mov    %esi,%eax
  800863:	39 d8                	cmp    %ebx,%eax
  800865:	74 11                	je     800878 <strncpy+0x2b>
		*dst++ = *src;
  800867:	83 c0 01             	add    $0x1,%eax
  80086a:	0f b6 0a             	movzbl (%edx),%ecx
  80086d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800870:	80 f9 01             	cmp    $0x1,%cl
  800873:	83 da ff             	sbb    $0xffffffff,%edx
  800876:	eb eb                	jmp    800863 <strncpy+0x16>
	}
	return ret;
}
  800878:	89 f0                	mov    %esi,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087e:	f3 0f 1e fb          	endbr32 
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	8b 75 08             	mov    0x8(%ebp),%esi
  80088a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088d:	8b 55 10             	mov    0x10(%ebp),%edx
  800890:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800892:	85 d2                	test   %edx,%edx
  800894:	74 21                	je     8008b7 <strlcpy+0x39>
  800896:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80089a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80089c:	39 c2                	cmp    %eax,%edx
  80089e:	74 14                	je     8008b4 <strlcpy+0x36>
  8008a0:	0f b6 19             	movzbl (%ecx),%ebx
  8008a3:	84 db                	test   %bl,%bl
  8008a5:	74 0b                	je     8008b2 <strlcpy+0x34>
			*dst++ = *src++;
  8008a7:	83 c1 01             	add    $0x1,%ecx
  8008aa:	83 c2 01             	add    $0x1,%edx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	eb ea                	jmp    80089c <strlcpy+0x1e>
  8008b2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b7:	29 f0                	sub    %esi,%eax
}
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bd:	f3 0f 1e fb          	endbr32 
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ca:	0f b6 01             	movzbl (%ecx),%eax
  8008cd:	84 c0                	test   %al,%al
  8008cf:	74 0c                	je     8008dd <strcmp+0x20>
  8008d1:	3a 02                	cmp    (%edx),%al
  8008d3:	75 08                	jne    8008dd <strcmp+0x20>
		p++, q++;
  8008d5:	83 c1 01             	add    $0x1,%ecx
  8008d8:	83 c2 01             	add    $0x1,%edx
  8008db:	eb ed                	jmp    8008ca <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008dd:	0f b6 c0             	movzbl %al,%eax
  8008e0:	0f b6 12             	movzbl (%edx),%edx
  8008e3:	29 d0                	sub    %edx,%eax
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e7:	f3 0f 1e fb          	endbr32 
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	53                   	push   %ebx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f5:	89 c3                	mov    %eax,%ebx
  8008f7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008fa:	eb 06                	jmp    800902 <strncmp+0x1b>
		n--, p++, q++;
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 16                	je     80091c <strncmp+0x35>
  800906:	0f b6 08             	movzbl (%eax),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	74 04                	je     800911 <strncmp+0x2a>
  80090d:	3a 0a                	cmp    (%edx),%cl
  80090f:	74 eb                	je     8008fc <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800911:	0f b6 00             	movzbl (%eax),%eax
  800914:	0f b6 12             	movzbl (%edx),%edx
  800917:	29 d0                	sub    %edx,%eax
}
  800919:	5b                   	pop    %ebx
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    
		return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb f6                	jmp    800919 <strncmp+0x32>

00800923 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	f3 0f 1e fb          	endbr32 
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800931:	0f b6 10             	movzbl (%eax),%edx
  800934:	84 d2                	test   %dl,%dl
  800936:	74 09                	je     800941 <strchr+0x1e>
		if (*s == c)
  800938:	38 ca                	cmp    %cl,%dl
  80093a:	74 0a                	je     800946 <strchr+0x23>
	for (; *s; s++)
  80093c:	83 c0 01             	add    $0x1,%eax
  80093f:	eb f0                	jmp    800931 <strchr+0xe>
			return (char *) s;
	return 0;
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800948:	f3 0f 1e fb          	endbr32 
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800956:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800959:	38 ca                	cmp    %cl,%dl
  80095b:	74 09                	je     800966 <strfind+0x1e>
  80095d:	84 d2                	test   %dl,%dl
  80095f:	74 05                	je     800966 <strfind+0x1e>
	for (; *s; s++)
  800961:	83 c0 01             	add    $0x1,%eax
  800964:	eb f0                	jmp    800956 <strfind+0xe>
			break;
	return (char *) s;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800968:	f3 0f 1e fb          	endbr32 
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	57                   	push   %edi
  800970:	56                   	push   %esi
  800971:	53                   	push   %ebx
  800972:	8b 7d 08             	mov    0x8(%ebp),%edi
  800975:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800978:	85 c9                	test   %ecx,%ecx
  80097a:	74 31                	je     8009ad <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097c:	89 f8                	mov    %edi,%eax
  80097e:	09 c8                	or     %ecx,%eax
  800980:	a8 03                	test   $0x3,%al
  800982:	75 23                	jne    8009a7 <memset+0x3f>
		c &= 0xFF;
  800984:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 08             	shl    $0x8,%ebx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	c1 e0 18             	shl    $0x18,%eax
  800992:	89 d6                	mov    %edx,%esi
  800994:	c1 e6 10             	shl    $0x10,%esi
  800997:	09 f0                	or     %esi,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80099d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a0:	89 d0                	mov    %edx,%eax
  8009a2:	fc                   	cld    
  8009a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a5:	eb 06                	jmp    8009ad <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	57                   	push   %edi
  8009bc:	56                   	push   %esi
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c6:	39 c6                	cmp    %eax,%esi
  8009c8:	73 32                	jae    8009fc <memmove+0x48>
  8009ca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cd:	39 c2                	cmp    %eax,%edx
  8009cf:	76 2b                	jbe    8009fc <memmove+0x48>
		s += n;
		d += n;
  8009d1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	89 fe                	mov    %edi,%esi
  8009d6:	09 ce                	or     %ecx,%esi
  8009d8:	09 d6                	or     %edx,%esi
  8009da:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e0:	75 0e                	jne    8009f0 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e2:	83 ef 04             	sub    $0x4,%edi
  8009e5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009eb:	fd                   	std    
  8009ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ee:	eb 09                	jmp    8009f9 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f0:	83 ef 01             	sub    $0x1,%edi
  8009f3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f6:	fd                   	std    
  8009f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f9:	fc                   	cld    
  8009fa:	eb 1a                	jmp    800a16 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	89 c2                	mov    %eax,%edx
  8009fe:	09 ca                	or     %ecx,%edx
  800a00:	09 f2                	or     %esi,%edx
  800a02:	f6 c2 03             	test   $0x3,%dl
  800a05:	75 0a                	jne    800a11 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0a:	89 c7                	mov    %eax,%edi
  800a0c:	fc                   	cld    
  800a0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0f:	eb 05                	jmp    800a16 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a11:	89 c7                	mov    %eax,%edi
  800a13:	fc                   	cld    
  800a14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a16:	5e                   	pop    %esi
  800a17:	5f                   	pop    %edi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a24:	ff 75 10             	pushl  0x10(%ebp)
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 82 ff ff ff       	call   8009b4 <memmove>
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	89 c6                	mov    %eax,%esi
  800a45:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a48:	39 f0                	cmp    %esi,%eax
  800a4a:	74 1c                	je     800a68 <memcmp+0x34>
		if (*s1 != *s2)
  800a4c:	0f b6 08             	movzbl (%eax),%ecx
  800a4f:	0f b6 1a             	movzbl (%edx),%ebx
  800a52:	38 d9                	cmp    %bl,%cl
  800a54:	75 08                	jne    800a5e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a56:	83 c0 01             	add    $0x1,%eax
  800a59:	83 c2 01             	add    $0x1,%edx
  800a5c:	eb ea                	jmp    800a48 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a5e:	0f b6 c1             	movzbl %cl,%eax
  800a61:	0f b6 db             	movzbl %bl,%ebx
  800a64:	29 d8                	sub    %ebx,%eax
  800a66:	eb 05                	jmp    800a6d <memcmp+0x39>
	}

	return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7e:	89 c2                	mov    %eax,%edx
  800a80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a83:	39 d0                	cmp    %edx,%eax
  800a85:	73 09                	jae    800a90 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a87:	38 08                	cmp    %cl,(%eax)
  800a89:	74 05                	je     800a90 <memfind+0x1f>
	for (; s < ends; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	eb f3                	jmp    800a83 <memfind+0x12>
			break;
	return (void *) s;
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a92:	f3 0f 1e fb          	endbr32 
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa2:	eb 03                	jmp    800aa7 <strtol+0x15>
		s++;
  800aa4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aa7:	0f b6 01             	movzbl (%ecx),%eax
  800aaa:	3c 20                	cmp    $0x20,%al
  800aac:	74 f6                	je     800aa4 <strtol+0x12>
  800aae:	3c 09                	cmp    $0x9,%al
  800ab0:	74 f2                	je     800aa4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ab2:	3c 2b                	cmp    $0x2b,%al
  800ab4:	74 2a                	je     800ae0 <strtol+0x4e>
	int neg = 0;
  800ab6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800abb:	3c 2d                	cmp    $0x2d,%al
  800abd:	74 2b                	je     800aea <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac5:	75 0f                	jne    800ad6 <strtol+0x44>
  800ac7:	80 39 30             	cmpb   $0x30,(%ecx)
  800aca:	74 28                	je     800af4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acc:	85 db                	test   %ebx,%ebx
  800ace:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad3:	0f 44 d8             	cmove  %eax,%ebx
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  800adb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ade:	eb 46                	jmp    800b26 <strtol+0x94>
		s++;
  800ae0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae8:	eb d5                	jmp    800abf <strtol+0x2d>
		s++, neg = 1;
  800aea:	83 c1 01             	add    $0x1,%ecx
  800aed:	bf 01 00 00 00       	mov    $0x1,%edi
  800af2:	eb cb                	jmp    800abf <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af8:	74 0e                	je     800b08 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	75 d8                	jne    800ad6 <strtol+0x44>
		s++, base = 8;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b06:	eb ce                	jmp    800ad6 <strtol+0x44>
		s += 2, base = 16;
  800b08:	83 c1 02             	add    $0x2,%ecx
  800b0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b10:	eb c4                	jmp    800ad6 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1b:	7d 3a                	jge    800b57 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b26:	0f b6 11             	movzbl (%ecx),%edx
  800b29:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 09             	cmp    $0x9,%bl
  800b31:	76 df                	jbe    800b12 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b36:	89 f3                	mov    %esi,%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 08                	ja     800b45 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3d:	0f be d2             	movsbl %dl,%edx
  800b40:	83 ea 57             	sub    $0x57,%edx
  800b43:	eb d3                	jmp    800b18 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b45:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 19             	cmp    $0x19,%bl
  800b4d:	77 08                	ja     800b57 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b4f:	0f be d2             	movsbl %dl,%edx
  800b52:	83 ea 37             	sub    $0x37,%edx
  800b55:	eb c1                	jmp    800b18 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 05                	je     800b62 <strtol+0xd0>
		*endptr = (char *) s;
  800b5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b60:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	f7 da                	neg    %edx
  800b66:	85 ff                	test   %edi,%edi
  800b68:	0f 45 c2             	cmovne %edx,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b70:	f3 0f 1e fb          	endbr32 
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b85:	89 c3                	mov    %eax,%ebx
  800b87:	89 c7                	mov    %eax,%edi
  800b89:	89 c6                	mov    %eax,%esi
  800b8b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b92:	f3 0f 1e fb          	endbr32 
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba6:	89 d1                	mov    %edx,%ecx
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	89 d7                	mov    %edx,%edi
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb5:	f3 0f 1e fb          	endbr32 
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	89 cb                	mov    %ecx,%ebx
  800bd1:	89 cf                	mov    %ecx,%edi
  800bd3:	89 ce                	mov    %ecx,%esi
  800bd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	7f 08                	jg     800be3 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	50                   	push   %eax
  800be7:	6a 03                	push   $0x3
  800be9:	68 7f 26 80 00       	push   $0x80267f
  800bee:	6a 23                	push   $0x23
  800bf0:	68 9c 26 80 00       	push   $0x80269c
  800bf5:	e8 bc 12 00 00       	call   801eb6 <_panic>

00800bfa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bfa:	f3 0f 1e fb          	endbr32 
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_yield>:

void
sys_yield(void)
{
  800c1d:	f3 0f 1e fb          	endbr32 
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c31:	89 d1                	mov    %edx,%ecx
  800c33:	89 d3                	mov    %edx,%ebx
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	89 d6                	mov    %edx,%esi
  800c39:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	be 00 00 00 00       	mov    $0x0,%esi
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 04 00 00 00       	mov    $0x4,%eax
  800c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c60:	89 f7                	mov    %esi,%edi
  800c62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	7f 08                	jg     800c70 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	6a 04                	push   $0x4
  800c76:	68 7f 26 80 00       	push   $0x80267f
  800c7b:	6a 23                	push   $0x23
  800c7d:	68 9c 26 80 00       	push   $0x80269c
  800c82:	e8 2f 12 00 00       	call   801eb6 <_panic>

00800c87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 05                	push   $0x5
  800cbc:	68 7f 26 80 00       	push   $0x80267f
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 9c 26 80 00       	push   $0x80269c
  800cc8:	e8 e9 11 00 00       	call   801eb6 <_panic>

00800ccd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccd:	f3 0f 1e fb          	endbr32 
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cea:	89 df                	mov    %ebx,%edi
  800cec:	89 de                	mov    %ebx,%esi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 06                	push   $0x6
  800d02:	68 7f 26 80 00       	push   $0x80267f
  800d07:	6a 23                	push   $0x23
  800d09:	68 9c 26 80 00       	push   $0x80269c
  800d0e:	e8 a3 11 00 00       	call   801eb6 <_panic>

00800d13 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d13:	f3 0f 1e fb          	endbr32 
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d30:	89 df                	mov    %ebx,%edi
  800d32:	89 de                	mov    %ebx,%esi
  800d34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7f 08                	jg     800d42 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	50                   	push   %eax
  800d46:	6a 08                	push   $0x8
  800d48:	68 7f 26 80 00       	push   $0x80267f
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 9c 26 80 00       	push   $0x80269c
  800d54:	e8 5d 11 00 00       	call   801eb6 <_panic>

00800d59 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d59:	f3 0f 1e fb          	endbr32 
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 09 00 00 00       	mov    $0x9,%eax
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	89 de                	mov    %ebx,%esi
  800d7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7f 08                	jg     800d88 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 09                	push   $0x9
  800d8e:	68 7f 26 80 00       	push   $0x80267f
  800d93:	6a 23                	push   $0x23
  800d95:	68 9c 26 80 00       	push   $0x80269c
  800d9a:	e8 17 11 00 00       	call   801eb6 <_panic>

00800d9f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d9f:	f3 0f 1e fb          	endbr32 
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	89 de                	mov    %ebx,%esi
  800dc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	7f 08                	jg     800dce <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dce:	83 ec 0c             	sub    $0xc,%esp
  800dd1:	50                   	push   %eax
  800dd2:	6a 0a                	push   $0xa
  800dd4:	68 7f 26 80 00       	push   $0x80267f
  800dd9:	6a 23                	push   $0x23
  800ddb:	68 9c 26 80 00       	push   $0x80269c
  800de0:	e8 d1 10 00 00       	call   801eb6 <_panic>

00800de5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800de5:	f3 0f 1e fb          	endbr32 
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dfa:	be 00 00 00 00       	mov    $0x0,%esi
  800dff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e02:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e05:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e0c:	f3 0f 1e fb          	endbr32 
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e26:	89 cb                	mov    %ecx,%ebx
  800e28:	89 cf                	mov    %ecx,%edi
  800e2a:	89 ce                	mov    %ecx,%esi
  800e2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7f 08                	jg     800e3a <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	50                   	push   %eax
  800e3e:	6a 0d                	push   $0xd
  800e40:	68 7f 26 80 00       	push   $0x80267f
  800e45:	6a 23                	push   $0x23
  800e47:	68 9c 26 80 00       	push   $0x80269c
  800e4c:	e8 65 10 00 00       	call   801eb6 <_panic>

00800e51 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800e51:	f3 0f 1e fb          	endbr32 
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e5d:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800e5f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e63:	74 7f                	je     800ee4 <pgfault+0x93>
  800e65:	89 f0                	mov    %esi,%eax
  800e67:	c1 e8 0c             	shr    $0xc,%eax
  800e6a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e71:	f6 c4 08             	test   $0x8,%ah
  800e74:	74 6e                	je     800ee4 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800e76:	e8 7f fd ff ff       	call   800bfa <sys_getenvid>
  800e7b:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800e7d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800e83:	83 ec 04             	sub    $0x4,%esp
  800e86:	6a 07                	push   $0x7
  800e88:	68 00 f0 7f 00       	push   $0x7ff000
  800e8d:	50                   	push   %eax
  800e8e:	e8 ad fd ff ff       	call   800c40 <sys_page_alloc>
  800e93:	83 c4 10             	add    $0x10,%esp
  800e96:	85 c0                	test   %eax,%eax
  800e98:	78 5e                	js     800ef8 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	68 00 10 00 00       	push   $0x1000
  800ea2:	56                   	push   %esi
  800ea3:	68 00 f0 7f 00       	push   $0x7ff000
  800ea8:	e8 6d fb ff ff       	call   800a1a <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800ead:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	68 00 f0 7f 00       	push   $0x7ff000
  800ebb:	53                   	push   %ebx
  800ebc:	e8 c6 fd ff ff       	call   800c87 <sys_page_map>
  800ec1:	83 c4 20             	add    $0x20,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	78 44                	js     800f0c <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800ec8:	83 ec 08             	sub    $0x8,%esp
  800ecb:	68 00 f0 7f 00       	push   $0x7ff000
  800ed0:	53                   	push   %ebx
  800ed1:	e8 f7 fd ff ff       	call   800ccd <sys_page_unmap>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	78 43                	js     800f20 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800edd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	68 aa 26 80 00       	push   $0x8026aa
  800eec:	6a 1e                	push   $0x1e
  800eee:	68 c7 26 80 00       	push   $0x8026c7
  800ef3:	e8 be 0f 00 00       	call   801eb6 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800ef8:	83 ec 04             	sub    $0x4,%esp
  800efb:	68 58 27 80 00       	push   $0x802758
  800f00:	6a 2b                	push   $0x2b
  800f02:	68 c7 26 80 00       	push   $0x8026c7
  800f07:	e8 aa 0f 00 00       	call   801eb6 <_panic>
		panic("pgfault: sys_page_map Failed!");
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	68 d2 26 80 00       	push   $0x8026d2
  800f14:	6a 2f                	push   $0x2f
  800f16:	68 c7 26 80 00       	push   $0x8026c7
  800f1b:	e8 96 0f 00 00       	call   801eb6 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800f20:	83 ec 04             	sub    $0x4,%esp
  800f23:	68 78 27 80 00       	push   $0x802778
  800f28:	6a 32                	push   $0x32
  800f2a:	68 c7 26 80 00       	push   $0x8026c7
  800f2f:	e8 82 0f 00 00       	call   801eb6 <_panic>

00800f34 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f34:	f3 0f 1e fb          	endbr32 
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f41:	68 51 0e 80 00       	push   $0x800e51
  800f46:	e8 b5 0f 00 00       	call   801f00 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f4b:	b8 07 00 00 00       	mov    $0x7,%eax
  800f50:	cd 30                	int    $0x30
  800f52:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	78 2b                	js     800f8a <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800f5f:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  800f64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f68:	0f 85 ba 00 00 00    	jne    801028 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  800f6e:	e8 87 fc ff ff       	call   800bfa <sys_getenvid>
  800f73:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f78:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f7b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f80:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f85:	e9 90 01 00 00       	jmp    80111a <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	68 f0 26 80 00       	push   $0x8026f0
  800f92:	6a 76                	push   $0x76
  800f94:	68 c7 26 80 00       	push   $0x8026c7
  800f99:	e8 18 0f 00 00       	call   801eb6 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  800f9e:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  800fa5:	e8 50 fc ff ff       	call   800bfa <sys_getenvid>
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800fb3:	56                   	push   %esi
  800fb4:	57                   	push   %edi
  800fb5:	ff 75 e0             	pushl  -0x20(%ebp)
  800fb8:	57                   	push   %edi
  800fb9:	50                   	push   %eax
  800fba:	e8 c8 fc ff ff       	call   800c87 <sys_page_map>
  800fbf:	83 c4 20             	add    $0x20,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	79 50                	jns    801016 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  800fc6:	83 ec 04             	sub    $0x4,%esp
  800fc9:	68 09 27 80 00       	push   $0x802709
  800fce:	6a 4b                	push   $0x4b
  800fd0:	68 c7 26 80 00       	push   $0x8026c7
  800fd5:	e8 dc 0e 00 00       	call   801eb6 <_panic>
			panic("duppage:child sys_page_map Failed!");
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	68 98 27 80 00       	push   $0x802798
  800fe2:	6a 50                	push   $0x50
  800fe4:	68 c7 26 80 00       	push   $0x8026c7
  800fe9:	e8 c8 0e 00 00       	call   801eb6 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  800fee:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	25 07 0e 00 00       	and    $0xe07,%eax
  800ffd:	50                   	push   %eax
  800ffe:	57                   	push   %edi
  800fff:	ff 75 e0             	pushl  -0x20(%ebp)
  801002:	57                   	push   %edi
  801003:	ff 75 e4             	pushl  -0x1c(%ebp)
  801006:	e8 7c fc ff ff       	call   800c87 <sys_page_map>
  80100b:	83 c4 20             	add    $0x20,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	0f 88 b4 00 00 00    	js     8010ca <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801016:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80101c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801022:	0f 84 b6 00 00 00    	je     8010de <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801028:	89 d8                	mov    %ebx,%eax
  80102a:	c1 e8 16             	shr    $0x16,%eax
  80102d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801034:	a8 01                	test   $0x1,%al
  801036:	74 de                	je     801016 <fork+0xe2>
  801038:	89 de                	mov    %ebx,%esi
  80103a:	c1 ee 0c             	shr    $0xc,%esi
  80103d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801044:	a8 01                	test   $0x1,%al
  801046:	74 ce                	je     801016 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801048:	e8 ad fb ff ff       	call   800bfa <sys_getenvid>
  80104d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801050:	89 f7                	mov    %esi,%edi
  801052:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  801055:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80105c:	f6 c4 04             	test   $0x4,%ah
  80105f:	0f 85 39 ff ff ff    	jne    800f9e <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  801065:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80106c:	a9 02 08 00 00       	test   $0x802,%eax
  801071:	0f 84 77 ff ff ff    	je     800fee <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	68 05 08 00 00       	push   $0x805
  80107f:	57                   	push   %edi
  801080:	ff 75 e0             	pushl  -0x20(%ebp)
  801083:	57                   	push   %edi
  801084:	ff 75 e4             	pushl  -0x1c(%ebp)
  801087:	e8 fb fb ff ff       	call   800c87 <sys_page_map>
  80108c:	83 c4 20             	add    $0x20,%esp
  80108f:	85 c0                	test   %eax,%eax
  801091:	0f 88 43 ff ff ff    	js     800fda <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	68 05 08 00 00       	push   $0x805
  80109f:	57                   	push   %edi
  8010a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010a3:	50                   	push   %eax
  8010a4:	57                   	push   %edi
  8010a5:	50                   	push   %eax
  8010a6:	e8 dc fb ff ff       	call   800c87 <sys_page_map>
  8010ab:	83 c4 20             	add    $0x20,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	0f 89 60 ff ff ff    	jns    801016 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8010b6:	83 ec 04             	sub    $0x4,%esp
  8010b9:	68 bc 27 80 00       	push   $0x8027bc
  8010be:	6a 52                	push   $0x52
  8010c0:	68 c7 26 80 00       	push   $0x8026c7
  8010c5:	e8 ec 0d 00 00       	call   801eb6 <_panic>
			panic("duppage: single sys_page_map Failed!");
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	68 e0 27 80 00       	push   $0x8027e0
  8010d2:	6a 56                	push   $0x56
  8010d4:	68 c7 26 80 00       	push   $0x8026c7
  8010d9:	e8 d8 0d 00 00       	call   801eb6 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	6a 07                	push   $0x7
  8010e3:	68 00 f0 bf ee       	push   $0xeebff000
  8010e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8010eb:	e8 50 fb ff ff       	call   800c40 <sys_page_alloc>
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 2e                	js     801125 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8010f7:	83 ec 08             	sub    $0x8,%esp
  8010fa:	68 7c 1f 80 00       	push   $0x801f7c
  8010ff:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801102:	57                   	push   %edi
  801103:	e8 97 fc ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801108:	83 c4 08             	add    $0x8,%esp
  80110b:	6a 02                	push   $0x2
  80110d:	57                   	push   %edi
  80110e:	e8 00 fc ff ff       	call   800d13 <sys_env_set_status>
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	78 22                	js     80113c <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  80111a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80111d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801120:	5b                   	pop    %ebx
  801121:	5e                   	pop    %esi
  801122:	5f                   	pop    %edi
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  801125:	83 ec 04             	sub    $0x4,%esp
  801128:	68 26 27 80 00       	push   $0x802726
  80112d:	68 83 00 00 00       	push   $0x83
  801132:	68 c7 26 80 00       	push   $0x8026c7
  801137:	e8 7a 0d 00 00       	call   801eb6 <_panic>
		panic("fork: sys_env_set_status Failed!");
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	68 08 28 80 00       	push   $0x802808
  801144:	68 89 00 00 00       	push   $0x89
  801149:	68 c7 26 80 00       	push   $0x8026c7
  80114e:	e8 63 0d 00 00       	call   801eb6 <_panic>

00801153 <sfork>:

// Challenge!
int
sfork(void)
{
  801153:	f3 0f 1e fb          	endbr32 
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80115d:	68 42 27 80 00       	push   $0x802742
  801162:	68 93 00 00 00       	push   $0x93
  801167:	68 c7 26 80 00       	push   $0x8026c7
  80116c:	e8 45 0d 00 00       	call   801eb6 <_panic>

00801171 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801171:	f3 0f 1e fb          	endbr32 
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	05 00 00 00 30       	add    $0x30000000,%eax
  801180:	c1 e8 0c             	shr    $0xc,%eax
}
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801185:	f3 0f 1e fb          	endbr32 
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801194:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801199:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a0:	f3 0f 1e fb          	endbr32 
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ac:	89 c2                	mov    %eax,%edx
  8011ae:	c1 ea 16             	shr    $0x16,%edx
  8011b1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b8:	f6 c2 01             	test   $0x1,%dl
  8011bb:	74 2d                	je     8011ea <fd_alloc+0x4a>
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	c1 ea 0c             	shr    $0xc,%edx
  8011c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c9:	f6 c2 01             	test   $0x1,%dl
  8011cc:	74 1c                	je     8011ea <fd_alloc+0x4a>
  8011ce:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011d3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d8:	75 d2                	jne    8011ac <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e8:	eb 0a                	jmp    8011f4 <fd_alloc+0x54>
			*fd_store = fd;
  8011ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ed:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f6:	f3 0f 1e fb          	endbr32 
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801200:	83 f8 1f             	cmp    $0x1f,%eax
  801203:	77 30                	ja     801235 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801205:	c1 e0 0c             	shl    $0xc,%eax
  801208:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80120d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801213:	f6 c2 01             	test   $0x1,%dl
  801216:	74 24                	je     80123c <fd_lookup+0x46>
  801218:	89 c2                	mov    %eax,%edx
  80121a:	c1 ea 0c             	shr    $0xc,%edx
  80121d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801224:	f6 c2 01             	test   $0x1,%dl
  801227:	74 1a                	je     801243 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122c:	89 02                	mov    %eax,(%edx)
	return 0;
  80122e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    
		return -E_INVAL;
  801235:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123a:	eb f7                	jmp    801233 <fd_lookup+0x3d>
		return -E_INVAL;
  80123c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801241:	eb f0                	jmp    801233 <fd_lookup+0x3d>
  801243:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801248:	eb e9                	jmp    801233 <fd_lookup+0x3d>

0080124a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801257:	ba a8 28 80 00       	mov    $0x8028a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80125c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801261:	39 08                	cmp    %ecx,(%eax)
  801263:	74 33                	je     801298 <dev_lookup+0x4e>
  801265:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801268:	8b 02                	mov    (%edx),%eax
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 f3                	jne    801261 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126e:	a1 04 40 80 00       	mov    0x804004,%eax
  801273:	8b 40 48             	mov    0x48(%eax),%eax
  801276:	83 ec 04             	sub    $0x4,%esp
  801279:	51                   	push   %ecx
  80127a:	50                   	push   %eax
  80127b:	68 2c 28 80 00       	push   $0x80282c
  801280:	e8 6f ef ff ff       	call   8001f4 <cprintf>
	*dev = 0;
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    
			*dev = devtab[i];
  801298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb f2                	jmp    801296 <dev_lookup+0x4c>

008012a4 <fd_close>:
{
  8012a4:	f3 0f 1e fb          	endbr32 
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 24             	sub    $0x24,%esp
  8012b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ba:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c4:	50                   	push   %eax
  8012c5:	e8 2c ff ff ff       	call   8011f6 <fd_lookup>
  8012ca:	89 c3                	mov    %eax,%ebx
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	78 05                	js     8012d8 <fd_close+0x34>
	    || fd != fd2)
  8012d3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012d6:	74 16                	je     8012ee <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012d8:	89 f8                	mov    %edi,%eax
  8012da:	84 c0                	test   %al,%al
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e1:	0f 44 d8             	cmove  %eax,%ebx
}
  8012e4:	89 d8                	mov    %ebx,%eax
  8012e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5e                   	pop    %esi
  8012eb:	5f                   	pop    %edi
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012ee:	83 ec 08             	sub    $0x8,%esp
  8012f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012f4:	50                   	push   %eax
  8012f5:	ff 36                	pushl  (%esi)
  8012f7:	e8 4e ff ff ff       	call   80124a <dev_lookup>
  8012fc:	89 c3                	mov    %eax,%ebx
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	78 1a                	js     80131f <fd_close+0x7b>
		if (dev->dev_close)
  801305:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801308:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80130b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801310:	85 c0                	test   %eax,%eax
  801312:	74 0b                	je     80131f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801314:	83 ec 0c             	sub    $0xc,%esp
  801317:	56                   	push   %esi
  801318:	ff d0                	call   *%eax
  80131a:	89 c3                	mov    %eax,%ebx
  80131c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80131f:	83 ec 08             	sub    $0x8,%esp
  801322:	56                   	push   %esi
  801323:	6a 00                	push   $0x0
  801325:	e8 a3 f9 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	eb b5                	jmp    8012e4 <fd_close+0x40>

0080132f <close>:

int
close(int fdnum)
{
  80132f:	f3 0f 1e fb          	endbr32 
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801339:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 b1 fe ff ff       	call   8011f6 <fd_lookup>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	79 02                	jns    80134e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    
		return fd_close(fd, 1);
  80134e:	83 ec 08             	sub    $0x8,%esp
  801351:	6a 01                	push   $0x1
  801353:	ff 75 f4             	pushl  -0xc(%ebp)
  801356:	e8 49 ff ff ff       	call   8012a4 <fd_close>
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	eb ec                	jmp    80134c <close+0x1d>

00801360 <close_all>:

void
close_all(void)
{
  801360:	f3 0f 1e fb          	endbr32 
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	53                   	push   %ebx
  801368:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80136b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	53                   	push   %ebx
  801374:	e8 b6 ff ff ff       	call   80132f <close>
	for (i = 0; i < MAXFD; i++)
  801379:	83 c3 01             	add    $0x1,%ebx
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	83 fb 20             	cmp    $0x20,%ebx
  801382:	75 ec                	jne    801370 <close_all+0x10>
}
  801384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801389:	f3 0f 1e fb          	endbr32 
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	57                   	push   %edi
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
  801393:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801396:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801399:	50                   	push   %eax
  80139a:	ff 75 08             	pushl  0x8(%ebp)
  80139d:	e8 54 fe ff ff       	call   8011f6 <fd_lookup>
  8013a2:	89 c3                	mov    %eax,%ebx
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	0f 88 81 00 00 00    	js     801430 <dup+0xa7>
		return r;
	close(newfdnum);
  8013af:	83 ec 0c             	sub    $0xc,%esp
  8013b2:	ff 75 0c             	pushl  0xc(%ebp)
  8013b5:	e8 75 ff ff ff       	call   80132f <close>

	newfd = INDEX2FD(newfdnum);
  8013ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013bd:	c1 e6 0c             	shl    $0xc,%esi
  8013c0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013cc:	e8 b4 fd ff ff       	call   801185 <fd2data>
  8013d1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013d3:	89 34 24             	mov    %esi,(%esp)
  8013d6:	e8 aa fd ff ff       	call   801185 <fd2data>
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013e0:	89 d8                	mov    %ebx,%eax
  8013e2:	c1 e8 16             	shr    $0x16,%eax
  8013e5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ec:	a8 01                	test   $0x1,%al
  8013ee:	74 11                	je     801401 <dup+0x78>
  8013f0:	89 d8                	mov    %ebx,%eax
  8013f2:	c1 e8 0c             	shr    $0xc,%eax
  8013f5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013fc:	f6 c2 01             	test   $0x1,%dl
  8013ff:	75 39                	jne    80143a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801401:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801404:	89 d0                	mov    %edx,%eax
  801406:	c1 e8 0c             	shr    $0xc,%eax
  801409:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801410:	83 ec 0c             	sub    $0xc,%esp
  801413:	25 07 0e 00 00       	and    $0xe07,%eax
  801418:	50                   	push   %eax
  801419:	56                   	push   %esi
  80141a:	6a 00                	push   $0x0
  80141c:	52                   	push   %edx
  80141d:	6a 00                	push   $0x0
  80141f:	e8 63 f8 ff ff       	call   800c87 <sys_page_map>
  801424:	89 c3                	mov    %eax,%ebx
  801426:	83 c4 20             	add    $0x20,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 31                	js     80145e <dup+0xd5>
		goto err;

	return newfdnum;
  80142d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801430:	89 d8                	mov    %ebx,%eax
  801432:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80143a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	25 07 0e 00 00       	and    $0xe07,%eax
  801449:	50                   	push   %eax
  80144a:	57                   	push   %edi
  80144b:	6a 00                	push   $0x0
  80144d:	53                   	push   %ebx
  80144e:	6a 00                	push   $0x0
  801450:	e8 32 f8 ff ff       	call   800c87 <sys_page_map>
  801455:	89 c3                	mov    %eax,%ebx
  801457:	83 c4 20             	add    $0x20,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	79 a3                	jns    801401 <dup+0x78>
	sys_page_unmap(0, newfd);
  80145e:	83 ec 08             	sub    $0x8,%esp
  801461:	56                   	push   %esi
  801462:	6a 00                	push   $0x0
  801464:	e8 64 f8 ff ff       	call   800ccd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801469:	83 c4 08             	add    $0x8,%esp
  80146c:	57                   	push   %edi
  80146d:	6a 00                	push   $0x0
  80146f:	e8 59 f8 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	eb b7                	jmp    801430 <dup+0xa7>

00801479 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801479:	f3 0f 1e fb          	endbr32 
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	53                   	push   %ebx
  801481:	83 ec 1c             	sub    $0x1c,%esp
  801484:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801487:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148a:	50                   	push   %eax
  80148b:	53                   	push   %ebx
  80148c:	e8 65 fd ff ff       	call   8011f6 <fd_lookup>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 3f                	js     8014d7 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a2:	ff 30                	pushl  (%eax)
  8014a4:	e8 a1 fd ff ff       	call   80124a <dev_lookup>
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 27                	js     8014d7 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014b3:	8b 42 08             	mov    0x8(%edx),%eax
  8014b6:	83 e0 03             	and    $0x3,%eax
  8014b9:	83 f8 01             	cmp    $0x1,%eax
  8014bc:	74 1e                	je     8014dc <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	8b 40 08             	mov    0x8(%eax),%eax
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	74 35                	je     8014fd <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	ff 75 10             	pushl  0x10(%ebp)
  8014ce:	ff 75 0c             	pushl  0xc(%ebp)
  8014d1:	52                   	push   %edx
  8014d2:	ff d0                	call   *%eax
  8014d4:	83 c4 10             	add    $0x10,%esp
}
  8014d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014dc:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e1:	8b 40 48             	mov    0x48(%eax),%eax
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	53                   	push   %ebx
  8014e8:	50                   	push   %eax
  8014e9:	68 6d 28 80 00       	push   $0x80286d
  8014ee:	e8 01 ed ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fb:	eb da                	jmp    8014d7 <read+0x5e>
		return -E_NOT_SUPP;
  8014fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801502:	eb d3                	jmp    8014d7 <read+0x5e>

00801504 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801504:	f3 0f 1e fb          	endbr32 
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	57                   	push   %edi
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	8b 7d 08             	mov    0x8(%ebp),%edi
  801514:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801517:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151c:	eb 02                	jmp    801520 <readn+0x1c>
  80151e:	01 c3                	add    %eax,%ebx
  801520:	39 f3                	cmp    %esi,%ebx
  801522:	73 21                	jae    801545 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	89 f0                	mov    %esi,%eax
  801529:	29 d8                	sub    %ebx,%eax
  80152b:	50                   	push   %eax
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	03 45 0c             	add    0xc(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	57                   	push   %edi
  801533:	e8 41 ff ff ff       	call   801479 <read>
		if (m < 0)
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 04                	js     801543 <readn+0x3f>
			return m;
		if (m == 0)
  80153f:	75 dd                	jne    80151e <readn+0x1a>
  801541:	eb 02                	jmp    801545 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801543:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801545:	89 d8                	mov    %ebx,%eax
  801547:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154a:	5b                   	pop    %ebx
  80154b:	5e                   	pop    %esi
  80154c:	5f                   	pop    %edi
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    

0080154f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80154f:	f3 0f 1e fb          	endbr32 
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	53                   	push   %ebx
  801557:	83 ec 1c             	sub    $0x1c,%esp
  80155a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	53                   	push   %ebx
  801562:	e8 8f fc ff ff       	call   8011f6 <fd_lookup>
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 3a                	js     8015a8 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801574:	50                   	push   %eax
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801578:	ff 30                	pushl  (%eax)
  80157a:	e8 cb fc ff ff       	call   80124a <dev_lookup>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	85 c0                	test   %eax,%eax
  801584:	78 22                	js     8015a8 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80158d:	74 1e                	je     8015ad <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80158f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801592:	8b 52 0c             	mov    0xc(%edx),%edx
  801595:	85 d2                	test   %edx,%edx
  801597:	74 35                	je     8015ce <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	ff 75 10             	pushl  0x10(%ebp)
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	50                   	push   %eax
  8015a3:	ff d2                	call   *%edx
  8015a5:	83 c4 10             	add    $0x10,%esp
}
  8015a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ad:	a1 04 40 80 00       	mov    0x804004,%eax
  8015b2:	8b 40 48             	mov    0x48(%eax),%eax
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	53                   	push   %ebx
  8015b9:	50                   	push   %eax
  8015ba:	68 89 28 80 00       	push   $0x802889
  8015bf:	e8 30 ec ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cc:	eb da                	jmp    8015a8 <write+0x59>
		return -E_NOT_SUPP;
  8015ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d3:	eb d3                	jmp    8015a8 <write+0x59>

008015d5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015d5:	f3 0f 1e fb          	endbr32 
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e2:	50                   	push   %eax
  8015e3:	ff 75 08             	pushl  0x8(%ebp)
  8015e6:	e8 0b fc ff ff       	call   8011f6 <fd_lookup>
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 0e                	js     801600 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801602:	f3 0f 1e fb          	endbr32 
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	53                   	push   %ebx
  80160a:	83 ec 1c             	sub    $0x1c,%esp
  80160d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801610:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	53                   	push   %ebx
  801615:	e8 dc fb ff ff       	call   8011f6 <fd_lookup>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 37                	js     801658 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	ff 30                	pushl  (%eax)
  80162d:	e8 18 fc ff ff       	call   80124a <dev_lookup>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 1f                	js     801658 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801640:	74 1b                	je     80165d <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801645:	8b 52 18             	mov    0x18(%edx),%edx
  801648:	85 d2                	test   %edx,%edx
  80164a:	74 32                	je     80167e <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	50                   	push   %eax
  801653:	ff d2                	call   *%edx
  801655:	83 c4 10             	add    $0x10,%esp
}
  801658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80165d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801662:	8b 40 48             	mov    0x48(%eax),%eax
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	53                   	push   %ebx
  801669:	50                   	push   %eax
  80166a:	68 4c 28 80 00       	push   $0x80284c
  80166f:	e8 80 eb ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb da                	jmp    801658 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80167e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801683:	eb d3                	jmp    801658 <ftruncate+0x56>

00801685 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801685:	f3 0f 1e fb          	endbr32 
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	53                   	push   %ebx
  80168d:	83 ec 1c             	sub    $0x1c,%esp
  801690:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801693:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801696:	50                   	push   %eax
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 57 fb ff ff       	call   8011f6 <fd_lookup>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 4b                	js     8016f1 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	ff 30                	pushl  (%eax)
  8016b2:	e8 93 fb ff ff       	call   80124a <dev_lookup>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 33                	js     8016f1 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c5:	74 2f                	je     8016f6 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016d1:	00 00 00 
	stat->st_isdir = 0;
  8016d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016db:	00 00 00 
	stat->st_dev = dev;
  8016de:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016eb:	ff 50 14             	call   *0x14(%eax)
  8016ee:	83 c4 10             	add    $0x10,%esp
}
  8016f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fb:	eb f4                	jmp    8016f1 <fstat+0x6c>

008016fd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016fd:	f3 0f 1e fb          	endbr32 
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	56                   	push   %esi
  801705:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	6a 00                	push   $0x0
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 fb 01 00 00       	call   80190e <open>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 1b                	js     801737 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	50                   	push   %eax
  801723:	e8 5d ff ff ff       	call   801685 <fstat>
  801728:	89 c6                	mov    %eax,%esi
	close(fd);
  80172a:	89 1c 24             	mov    %ebx,(%esp)
  80172d:	e8 fd fb ff ff       	call   80132f <close>
	return r;
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	89 f3                	mov    %esi,%ebx
}
  801737:	89 d8                	mov    %ebx,%eax
  801739:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173c:	5b                   	pop    %ebx
  80173d:	5e                   	pop    %esi
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	89 c6                	mov    %eax,%esi
  801747:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801749:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801750:	74 27                	je     801779 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801752:	6a 07                	push   $0x7
  801754:	68 00 50 80 00       	push   $0x805000
  801759:	56                   	push   %esi
  80175a:	ff 35 00 40 80 00    	pushl  0x804000
  801760:	e8 a8 08 00 00       	call   80200d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801765:	83 c4 0c             	add    $0xc,%esp
  801768:	6a 00                	push   $0x0
  80176a:	53                   	push   %ebx
  80176b:	6a 00                	push   $0x0
  80176d:	e8 2e 08 00 00       	call   801fa0 <ipc_recv>
}
  801772:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	6a 01                	push   $0x1
  80177e:	e8 e4 08 00 00       	call   802067 <ipc_find_env>
  801783:	a3 00 40 80 00       	mov    %eax,0x804000
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	eb c5                	jmp    801752 <fsipc+0x12>

0080178d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80178d:	f3 0f 1e fb          	endbr32 
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	b8 02 00 00 00       	mov    $0x2,%eax
  8017b4:	e8 87 ff ff ff       	call   801740 <fsipc>
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <devfile_flush>:
{
  8017bb:	f3 0f 1e fb          	endbr32 
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017da:	e8 61 ff ff ff       	call   801740 <fsipc>
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <devfile_stat>:
{
  8017e1:	f3 0f 1e fb          	endbr32 
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	53                   	push   %ebx
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801804:	e8 37 ff ff ff       	call   801740 <fsipc>
  801809:	85 c0                	test   %eax,%eax
  80180b:	78 2c                	js     801839 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	68 00 50 80 00       	push   $0x805000
  801815:	53                   	push   %ebx
  801816:	e8 e3 ef ff ff       	call   8007fe <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80181b:	a1 80 50 80 00       	mov    0x805080,%eax
  801820:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801826:	a1 84 50 80 00       	mov    0x805084,%eax
  80182b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801839:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <devfile_write>:
{
  80183e:	f3 0f 1e fb          	endbr32 
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	8b 45 10             	mov    0x10(%ebp),%eax
  80184b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801850:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801855:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801858:	8b 55 08             	mov    0x8(%ebp),%edx
  80185b:	8b 52 0c             	mov    0xc(%edx),%edx
  80185e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801864:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801869:	50                   	push   %eax
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	68 08 50 80 00       	push   $0x805008
  801872:	e8 3d f1 ff ff       	call   8009b4 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
  80187c:	b8 04 00 00 00       	mov    $0x4,%eax
  801881:	e8 ba fe ff ff       	call   801740 <fsipc>
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <devfile_read>:
{
  801888:	f3 0f 1e fb          	endbr32 
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8b 40 0c             	mov    0xc(%eax),%eax
  80189a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80189f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	b8 03 00 00 00       	mov    $0x3,%eax
  8018af:	e8 8c fe ff ff       	call   801740 <fsipc>
  8018b4:	89 c3                	mov    %eax,%ebx
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 1f                	js     8018d9 <devfile_read+0x51>
	assert(r <= n);
  8018ba:	39 f0                	cmp    %esi,%eax
  8018bc:	77 24                	ja     8018e2 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8018be:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c3:	7f 33                	jg     8018f8 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	50                   	push   %eax
  8018c9:	68 00 50 80 00       	push   $0x805000
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	e8 de f0 ff ff       	call   8009b4 <memmove>
	return r;
  8018d6:	83 c4 10             	add    $0x10,%esp
}
  8018d9:	89 d8                	mov    %ebx,%eax
  8018db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    
	assert(r <= n);
  8018e2:	68 b8 28 80 00       	push   $0x8028b8
  8018e7:	68 bf 28 80 00       	push   $0x8028bf
  8018ec:	6a 7d                	push   $0x7d
  8018ee:	68 d4 28 80 00       	push   $0x8028d4
  8018f3:	e8 be 05 00 00       	call   801eb6 <_panic>
	assert(r <= PGSIZE);
  8018f8:	68 df 28 80 00       	push   $0x8028df
  8018fd:	68 bf 28 80 00       	push   $0x8028bf
  801902:	6a 7e                	push   $0x7e
  801904:	68 d4 28 80 00       	push   $0x8028d4
  801909:	e8 a8 05 00 00       	call   801eb6 <_panic>

0080190e <open>:
{
  80190e:	f3 0f 1e fb          	endbr32 
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
  801917:	83 ec 1c             	sub    $0x1c,%esp
  80191a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80191d:	56                   	push   %esi
  80191e:	e8 98 ee ff ff       	call   8007bb <strlen>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80192b:	7f 6c                	jg     801999 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80192d:	83 ec 0c             	sub    $0xc,%esp
  801930:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801933:	50                   	push   %eax
  801934:	e8 67 f8 ff ff       	call   8011a0 <fd_alloc>
  801939:	89 c3                	mov    %eax,%ebx
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 3c                	js     80197e <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	56                   	push   %esi
  801946:	68 00 50 80 00       	push   $0x805000
  80194b:	e8 ae ee ff ff       	call   8007fe <strcpy>
	fsipcbuf.open.req_omode = mode;
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195b:	b8 01 00 00 00       	mov    $0x1,%eax
  801960:	e8 db fd ff ff       	call   801740 <fsipc>
  801965:	89 c3                	mov    %eax,%ebx
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 19                	js     801987 <open+0x79>
	return fd2num(fd);
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	ff 75 f4             	pushl  -0xc(%ebp)
  801974:	e8 f8 f7 ff ff       	call   801171 <fd2num>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	83 c4 10             	add    $0x10,%esp
}
  80197e:	89 d8                	mov    %ebx,%eax
  801980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    
		fd_close(fd, 0);
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 f4             	pushl  -0xc(%ebp)
  80198f:	e8 10 f9 ff ff       	call   8012a4 <fd_close>
		return r;
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	eb e5                	jmp    80197e <open+0x70>
		return -E_BAD_PATH;
  801999:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80199e:	eb de                	jmp    80197e <open+0x70>

008019a0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019a0:	f3 0f 1e fb          	endbr32 
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 08 00 00 00       	mov    $0x8,%eax
  8019b4:	e8 87 fd ff ff       	call   801740 <fsipc>
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019bb:	f3 0f 1e fb          	endbr32 
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	e8 b3 f7 ff ff       	call   801185 <fd2data>
  8019d2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019d4:	83 c4 08             	add    $0x8,%esp
  8019d7:	68 eb 28 80 00       	push   $0x8028eb
  8019dc:	53                   	push   %ebx
  8019dd:	e8 1c ee ff ff       	call   8007fe <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019e2:	8b 46 04             	mov    0x4(%esi),%eax
  8019e5:	2b 06                	sub    (%esi),%eax
  8019e7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019f4:	00 00 00 
	stat->st_dev = &devpipe;
  8019f7:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019fe:	30 80 00 
	return 0;
}
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5e                   	pop    %esi
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    

00801a0d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a0d:	f3 0f 1e fb          	endbr32 
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	53                   	push   %ebx
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a1b:	53                   	push   %ebx
  801a1c:	6a 00                	push   $0x0
  801a1e:	e8 aa f2 ff ff       	call   800ccd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a23:	89 1c 24             	mov    %ebx,(%esp)
  801a26:	e8 5a f7 ff ff       	call   801185 <fd2data>
  801a2b:	83 c4 08             	add    $0x8,%esp
  801a2e:	50                   	push   %eax
  801a2f:	6a 00                	push   $0x0
  801a31:	e8 97 f2 ff ff       	call   800ccd <sys_page_unmap>
}
  801a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <_pipeisclosed>:
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	57                   	push   %edi
  801a3f:	56                   	push   %esi
  801a40:	53                   	push   %ebx
  801a41:	83 ec 1c             	sub    $0x1c,%esp
  801a44:	89 c7                	mov    %eax,%edi
  801a46:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a48:	a1 04 40 80 00       	mov    0x804004,%eax
  801a4d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	57                   	push   %edi
  801a54:	e8 4b 06 00 00       	call   8020a4 <pageref>
  801a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a5c:	89 34 24             	mov    %esi,(%esp)
  801a5f:	e8 40 06 00 00       	call   8020a4 <pageref>
		nn = thisenv->env_runs;
  801a64:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a6a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	39 cb                	cmp    %ecx,%ebx
  801a72:	74 1b                	je     801a8f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a74:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a77:	75 cf                	jne    801a48 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a79:	8b 42 58             	mov    0x58(%edx),%eax
  801a7c:	6a 01                	push   $0x1
  801a7e:	50                   	push   %eax
  801a7f:	53                   	push   %ebx
  801a80:	68 f2 28 80 00       	push   $0x8028f2
  801a85:	e8 6a e7 ff ff       	call   8001f4 <cprintf>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	eb b9                	jmp    801a48 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a92:	0f 94 c0             	sete   %al
  801a95:	0f b6 c0             	movzbl %al,%eax
}
  801a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5f                   	pop    %edi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <devpipe_write>:
{
  801aa0:	f3 0f 1e fb          	endbr32 
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	57                   	push   %edi
  801aa8:	56                   	push   %esi
  801aa9:	53                   	push   %ebx
  801aaa:	83 ec 28             	sub    $0x28,%esp
  801aad:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ab0:	56                   	push   %esi
  801ab1:	e8 cf f6 ff ff       	call   801185 <fd2data>
  801ab6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ac0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ac3:	74 4f                	je     801b14 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ac5:	8b 43 04             	mov    0x4(%ebx),%eax
  801ac8:	8b 0b                	mov    (%ebx),%ecx
  801aca:	8d 51 20             	lea    0x20(%ecx),%edx
  801acd:	39 d0                	cmp    %edx,%eax
  801acf:	72 14                	jb     801ae5 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ad1:	89 da                	mov    %ebx,%edx
  801ad3:	89 f0                	mov    %esi,%eax
  801ad5:	e8 61 ff ff ff       	call   801a3b <_pipeisclosed>
  801ada:	85 c0                	test   %eax,%eax
  801adc:	75 3b                	jne    801b19 <devpipe_write+0x79>
			sys_yield();
  801ade:	e8 3a f1 ff ff       	call   800c1d <sys_yield>
  801ae3:	eb e0                	jmp    801ac5 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801aec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801aef:	89 c2                	mov    %eax,%edx
  801af1:	c1 fa 1f             	sar    $0x1f,%edx
  801af4:	89 d1                	mov    %edx,%ecx
  801af6:	c1 e9 1b             	shr    $0x1b,%ecx
  801af9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801afc:	83 e2 1f             	and    $0x1f,%edx
  801aff:	29 ca                	sub    %ecx,%edx
  801b01:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b05:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b09:	83 c0 01             	add    $0x1,%eax
  801b0c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b0f:	83 c7 01             	add    $0x1,%edi
  801b12:	eb ac                	jmp    801ac0 <devpipe_write+0x20>
	return i;
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	eb 05                	jmp    801b1e <devpipe_write+0x7e>
				return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b21:	5b                   	pop    %ebx
  801b22:	5e                   	pop    %esi
  801b23:	5f                   	pop    %edi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <devpipe_read>:
{
  801b26:	f3 0f 1e fb          	endbr32 
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	57                   	push   %edi
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 18             	sub    $0x18,%esp
  801b33:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b36:	57                   	push   %edi
  801b37:	e8 49 f6 ff ff       	call   801185 <fd2data>
  801b3c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	be 00 00 00 00       	mov    $0x0,%esi
  801b46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b49:	75 14                	jne    801b5f <devpipe_read+0x39>
	return i;
  801b4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4e:	eb 02                	jmp    801b52 <devpipe_read+0x2c>
				return i;
  801b50:	89 f0                	mov    %esi,%eax
}
  801b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    
			sys_yield();
  801b5a:	e8 be f0 ff ff       	call   800c1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b5f:	8b 03                	mov    (%ebx),%eax
  801b61:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b64:	75 18                	jne    801b7e <devpipe_read+0x58>
			if (i > 0)
  801b66:	85 f6                	test   %esi,%esi
  801b68:	75 e6                	jne    801b50 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801b6a:	89 da                	mov    %ebx,%edx
  801b6c:	89 f8                	mov    %edi,%eax
  801b6e:	e8 c8 fe ff ff       	call   801a3b <_pipeisclosed>
  801b73:	85 c0                	test   %eax,%eax
  801b75:	74 e3                	je     801b5a <devpipe_read+0x34>
				return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb d4                	jmp    801b52 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b7e:	99                   	cltd   
  801b7f:	c1 ea 1b             	shr    $0x1b,%edx
  801b82:	01 d0                	add    %edx,%eax
  801b84:	83 e0 1f             	and    $0x1f,%eax
  801b87:	29 d0                	sub    %edx,%eax
  801b89:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b91:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b94:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b97:	83 c6 01             	add    $0x1,%esi
  801b9a:	eb aa                	jmp    801b46 <devpipe_read+0x20>

00801b9c <pipe>:
{
  801b9c:	f3 0f 1e fb          	endbr32 
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bab:	50                   	push   %eax
  801bac:	e8 ef f5 ff ff       	call   8011a0 <fd_alloc>
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	0f 88 23 01 00 00    	js     801ce1 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 07 04 00 00       	push   $0x407
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	6a 00                	push   $0x0
  801bcb:	e8 70 f0 ff ff       	call   800c40 <sys_page_alloc>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	0f 88 04 01 00 00    	js     801ce1 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be3:	50                   	push   %eax
  801be4:	e8 b7 f5 ff ff       	call   8011a0 <fd_alloc>
  801be9:	89 c3                	mov    %eax,%ebx
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	0f 88 db 00 00 00    	js     801cd1 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	68 07 04 00 00       	push   $0x407
  801bfe:	ff 75 f0             	pushl  -0x10(%ebp)
  801c01:	6a 00                	push   $0x0
  801c03:	e8 38 f0 ff ff       	call   800c40 <sys_page_alloc>
  801c08:	89 c3                	mov    %eax,%ebx
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	0f 88 bc 00 00 00    	js     801cd1 <pipe+0x135>
	va = fd2data(fd0);
  801c15:	83 ec 0c             	sub    $0xc,%esp
  801c18:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1b:	e8 65 f5 ff ff       	call   801185 <fd2data>
  801c20:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c22:	83 c4 0c             	add    $0xc,%esp
  801c25:	68 07 04 00 00       	push   $0x407
  801c2a:	50                   	push   %eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	e8 0e f0 ff ff       	call   800c40 <sys_page_alloc>
  801c32:	89 c3                	mov    %eax,%ebx
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	85 c0                	test   %eax,%eax
  801c39:	0f 88 82 00 00 00    	js     801cc1 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	ff 75 f0             	pushl  -0x10(%ebp)
  801c45:	e8 3b f5 ff ff       	call   801185 <fd2data>
  801c4a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c51:	50                   	push   %eax
  801c52:	6a 00                	push   $0x0
  801c54:	56                   	push   %esi
  801c55:	6a 00                	push   $0x0
  801c57:	e8 2b f0 ff ff       	call   800c87 <sys_page_map>
  801c5c:	89 c3                	mov    %eax,%ebx
  801c5e:	83 c4 20             	add    $0x20,%esp
  801c61:	85 c0                	test   %eax,%eax
  801c63:	78 4e                	js     801cb3 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801c65:	a1 20 30 80 00       	mov    0x803020,%eax
  801c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c6d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c72:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c7c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c81:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c88:	83 ec 0c             	sub    $0xc,%esp
  801c8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8e:	e8 de f4 ff ff       	call   801171 <fd2num>
  801c93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c96:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c98:	83 c4 04             	add    $0x4,%esp
  801c9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c9e:	e8 ce f4 ff ff       	call   801171 <fd2num>
  801ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb1:	eb 2e                	jmp    801ce1 <pipe+0x145>
	sys_page_unmap(0, va);
  801cb3:	83 ec 08             	sub    $0x8,%esp
  801cb6:	56                   	push   %esi
  801cb7:	6a 00                	push   $0x0
  801cb9:	e8 0f f0 ff ff       	call   800ccd <sys_page_unmap>
  801cbe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 ff ef ff ff       	call   800ccd <sys_page_unmap>
  801cce:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd7:	6a 00                	push   $0x0
  801cd9:	e8 ef ef ff ff       	call   800ccd <sys_page_unmap>
  801cde:	83 c4 10             	add    $0x10,%esp
}
  801ce1:	89 d8                	mov    %ebx,%eax
  801ce3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    

00801cea <pipeisclosed>:
{
  801cea:	f3 0f 1e fb          	endbr32 
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf7:	50                   	push   %eax
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	e8 f6 f4 ff ff       	call   8011f6 <fd_lookup>
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	85 c0                	test   %eax,%eax
  801d05:	78 18                	js     801d1f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801d07:	83 ec 0c             	sub    $0xc,%esp
  801d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0d:	e8 73 f4 ff ff       	call   801185 <fd2data>
  801d12:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d17:	e8 1f fd ff ff       	call   801a3b <_pipeisclosed>
  801d1c:	83 c4 10             	add    $0x10,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d21:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801d25:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2a:	c3                   	ret    

00801d2b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d2b:	f3 0f 1e fb          	endbr32 
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d35:	68 0a 29 80 00       	push   $0x80290a
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	e8 bc ea ff ff       	call   8007fe <strcpy>
	return 0;
}
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <devcons_write>:
{
  801d49:	f3 0f 1e fb          	endbr32 
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	57                   	push   %edi
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d59:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d5e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d64:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d67:	73 31                	jae    801d9a <devcons_write+0x51>
		m = n - tot;
  801d69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d6c:	29 f3                	sub    %esi,%ebx
  801d6e:	83 fb 7f             	cmp    $0x7f,%ebx
  801d71:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d76:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d79:	83 ec 04             	sub    $0x4,%esp
  801d7c:	53                   	push   %ebx
  801d7d:	89 f0                	mov    %esi,%eax
  801d7f:	03 45 0c             	add    0xc(%ebp),%eax
  801d82:	50                   	push   %eax
  801d83:	57                   	push   %edi
  801d84:	e8 2b ec ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  801d89:	83 c4 08             	add    $0x8,%esp
  801d8c:	53                   	push   %ebx
  801d8d:	57                   	push   %edi
  801d8e:	e8 dd ed ff ff       	call   800b70 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d93:	01 de                	add    %ebx,%esi
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	eb ca                	jmp    801d64 <devcons_write+0x1b>
}
  801d9a:	89 f0                	mov    %esi,%eax
  801d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <devcons_read>:
{
  801da4:	f3 0f 1e fb          	endbr32 
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 08             	sub    $0x8,%esp
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801db3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db7:	74 21                	je     801dda <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801db9:	e8 d4 ed ff ff       	call   800b92 <sys_cgetc>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 07                	jne    801dc9 <devcons_read+0x25>
		sys_yield();
  801dc2:	e8 56 ee ff ff       	call   800c1d <sys_yield>
  801dc7:	eb f0                	jmp    801db9 <devcons_read+0x15>
	if (c < 0)
  801dc9:	78 0f                	js     801dda <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801dcb:	83 f8 04             	cmp    $0x4,%eax
  801dce:	74 0c                	je     801ddc <devcons_read+0x38>
	*(char*)vbuf = c;
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	88 02                	mov    %al,(%edx)
	return 1;
  801dd5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    
		return 0;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  801de1:	eb f7                	jmp    801dda <devcons_read+0x36>

00801de3 <cputchar>:
{
  801de3:	f3 0f 1e fb          	endbr32 
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801df3:	6a 01                	push   $0x1
  801df5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801df8:	50                   	push   %eax
  801df9:	e8 72 ed ff ff       	call   800b70 <sys_cputs>
}
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <getchar>:
{
  801e03:	f3 0f 1e fb          	endbr32 
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e0d:	6a 01                	push   $0x1
  801e0f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e12:	50                   	push   %eax
  801e13:	6a 00                	push   $0x0
  801e15:	e8 5f f6 ff ff       	call   801479 <read>
	if (r < 0)
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 06                	js     801e27 <getchar+0x24>
	if (r < 1)
  801e21:	74 06                	je     801e29 <getchar+0x26>
	return c;
  801e23:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    
		return -E_EOF;
  801e29:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e2e:	eb f7                	jmp    801e27 <getchar+0x24>

00801e30 <iscons>:
{
  801e30:	f3 0f 1e fb          	endbr32 
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3d:	50                   	push   %eax
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	e8 b0 f3 ff ff       	call   8011f6 <fd_lookup>
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	78 11                	js     801e5e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e56:	39 10                	cmp    %edx,(%eax)
  801e58:	0f 94 c0             	sete   %al
  801e5b:	0f b6 c0             	movzbl %al,%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <opencons>:
{
  801e60:	f3 0f 1e fb          	endbr32 
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6d:	50                   	push   %eax
  801e6e:	e8 2d f3 ff ff       	call   8011a0 <fd_alloc>
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 3a                	js     801eb4 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	68 07 04 00 00       	push   $0x407
  801e82:	ff 75 f4             	pushl  -0xc(%ebp)
  801e85:	6a 00                	push   $0x0
  801e87:	e8 b4 ed ff ff       	call   800c40 <sys_page_alloc>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	78 21                	js     801eb4 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e9c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ea8:	83 ec 0c             	sub    $0xc,%esp
  801eab:	50                   	push   %eax
  801eac:	e8 c0 f2 ff ff       	call   801171 <fd2num>
  801eb1:	83 c4 10             	add    $0x10,%esp
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801eb6:	f3 0f 1e fb          	endbr32 
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	56                   	push   %esi
  801ebe:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ebf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ec2:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ec8:	e8 2d ed ff ff       	call   800bfa <sys_getenvid>
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	ff 75 0c             	pushl  0xc(%ebp)
  801ed3:	ff 75 08             	pushl  0x8(%ebp)
  801ed6:	56                   	push   %esi
  801ed7:	50                   	push   %eax
  801ed8:	68 18 29 80 00       	push   $0x802918
  801edd:	e8 12 e3 ff ff       	call   8001f4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ee2:	83 c4 18             	add    $0x18,%esp
  801ee5:	53                   	push   %ebx
  801ee6:	ff 75 10             	pushl  0x10(%ebp)
  801ee9:	e8 b1 e2 ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  801eee:	c7 04 24 6f 23 80 00 	movl   $0x80236f,(%esp)
  801ef5:	e8 fa e2 ff ff       	call   8001f4 <cprintf>
  801efa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801efd:	cc                   	int3   
  801efe:	eb fd                	jmp    801efd <_panic+0x47>

00801f00 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f00:	f3 0f 1e fb          	endbr32 
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	53                   	push   %ebx
  801f08:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f0b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f12:	74 0d                	je     801f21 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    
		envid_t envid=sys_getenvid();
  801f21:	e8 d4 ec ff ff       	call   800bfa <sys_getenvid>
  801f26:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	6a 07                	push   $0x7
  801f2d:	68 00 f0 bf ee       	push   $0xeebff000
  801f32:	50                   	push   %eax
  801f33:	e8 08 ed ff ff       	call   800c40 <sys_page_alloc>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	78 29                	js     801f68 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	68 7c 1f 80 00       	push   $0x801f7c
  801f47:	53                   	push   %ebx
  801f48:	e8 52 ee ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	79 c0                	jns    801f14 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  801f54:	83 ec 04             	sub    $0x4,%esp
  801f57:	68 68 29 80 00       	push   $0x802968
  801f5c:	6a 24                	push   $0x24
  801f5e:	68 9f 29 80 00       	push   $0x80299f
  801f63:	e8 4e ff ff ff       	call   801eb6 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	68 3c 29 80 00       	push   $0x80293c
  801f70:	6a 22                	push   $0x22
  801f72:	68 9f 29 80 00       	push   $0x80299f
  801f77:	e8 3a ff ff ff       	call   801eb6 <_panic>

00801f7c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f7c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f7d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f82:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f84:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  801f87:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  801f8a:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  801f8e:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  801f93:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  801f97:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801f99:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  801f9a:	83 c4 04             	add    $0x4,%esp
	popfl
  801f9d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f9e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801f9f:	c3                   	ret    

00801fa0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fa0:	f3 0f 1e fb          	endbr32 
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	56                   	push   %esi
  801fa8:	53                   	push   %ebx
  801fa9:	8b 75 08             	mov    0x8(%ebp),%esi
  801fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fb9:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801fbc:	83 ec 0c             	sub    $0xc,%esp
  801fbf:	50                   	push   %eax
  801fc0:	e8 47 ee ff ff       	call   800e0c <sys_ipc_recv>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 2b                	js     801ff7 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801fcc:	85 f6                	test   %esi,%esi
  801fce:	74 0a                	je     801fda <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801fd0:	a1 04 40 80 00       	mov    0x804004,%eax
  801fd5:	8b 40 74             	mov    0x74(%eax),%eax
  801fd8:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801fda:	85 db                	test   %ebx,%ebx
  801fdc:	74 0a                	je     801fe8 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801fde:	a1 04 40 80 00       	mov    0x804004,%eax
  801fe3:	8b 40 78             	mov    0x78(%eax),%eax
  801fe6:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801fe8:	a1 04 40 80 00       	mov    0x804004,%eax
  801fed:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ff0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff3:	5b                   	pop    %ebx
  801ff4:	5e                   	pop    %esi
  801ff5:	5d                   	pop    %ebp
  801ff6:	c3                   	ret    
		if(from_env_store)
  801ff7:	85 f6                	test   %esi,%esi
  801ff9:	74 06                	je     802001 <ipc_recv+0x61>
			*from_env_store=0;
  801ffb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802001:	85 db                	test   %ebx,%ebx
  802003:	74 eb                	je     801ff0 <ipc_recv+0x50>
			*perm_store=0;
  802005:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80200b:	eb e3                	jmp    801ff0 <ipc_recv+0x50>

0080200d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80200d:	f3 0f 1e fb          	endbr32 
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	57                   	push   %edi
  802015:	56                   	push   %esi
  802016:	53                   	push   %ebx
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80201d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802020:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802023:	85 db                	test   %ebx,%ebx
  802025:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80202a:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  80202d:	ff 75 14             	pushl  0x14(%ebp)
  802030:	53                   	push   %ebx
  802031:	56                   	push   %esi
  802032:	57                   	push   %edi
  802033:	e8 ad ed ff ff       	call   800de5 <sys_ipc_try_send>
		if(!res)
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	74 20                	je     80205f <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  80203f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802042:	75 07                	jne    80204b <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  802044:	e8 d4 eb ff ff       	call   800c1d <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802049:	eb e2                	jmp    80202d <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	68 ad 29 80 00       	push   $0x8029ad
  802053:	6a 3f                	push   $0x3f
  802055:	68 c5 29 80 00       	push   $0x8029c5
  80205a:	e8 57 fe ff ff       	call   801eb6 <_panic>
	}
}
  80205f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802062:	5b                   	pop    %ebx
  802063:	5e                   	pop    %esi
  802064:	5f                   	pop    %edi
  802065:	5d                   	pop    %ebp
  802066:	c3                   	ret    

00802067 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802067:	f3 0f 1e fb          	endbr32 
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802076:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802079:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80207f:	8b 52 50             	mov    0x50(%edx),%edx
  802082:	39 ca                	cmp    %ecx,%edx
  802084:	74 11                	je     802097 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802086:	83 c0 01             	add    $0x1,%eax
  802089:	3d 00 04 00 00       	cmp    $0x400,%eax
  80208e:	75 e6                	jne    802076 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
  802095:	eb 0b                	jmp    8020a2 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802097:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80209a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80209f:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    

008020a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020a4:	f3 0f 1e fb          	endbr32 
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020ae:	89 c2                	mov    %eax,%edx
  8020b0:	c1 ea 16             	shr    $0x16,%edx
  8020b3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020ba:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020bf:	f6 c1 01             	test   $0x1,%cl
  8020c2:	74 1c                	je     8020e0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020c4:	c1 e8 0c             	shr    $0xc,%eax
  8020c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020ce:	a8 01                	test   $0x1,%al
  8020d0:	74 0e                	je     8020e0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020d2:	c1 e8 0c             	shr    $0xc,%eax
  8020d5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020dc:	ef 
  8020dd:	0f b7 d2             	movzwl %dx,%edx
}
  8020e0:	89 d0                	mov    %edx,%eax
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    
  8020e4:	66 90                	xchg   %ax,%ax
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	66 90                	xchg   %ax,%ax
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <__udivdi3>:
  8020f0:	f3 0f 1e fb          	endbr32 
  8020f4:	55                   	push   %ebp
  8020f5:	57                   	push   %edi
  8020f6:	56                   	push   %esi
  8020f7:	53                   	push   %ebx
  8020f8:	83 ec 1c             	sub    $0x1c,%esp
  8020fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802103:	8b 74 24 34          	mov    0x34(%esp),%esi
  802107:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80210b:	85 d2                	test   %edx,%edx
  80210d:	75 19                	jne    802128 <__udivdi3+0x38>
  80210f:	39 f3                	cmp    %esi,%ebx
  802111:	76 4d                	jbe    802160 <__udivdi3+0x70>
  802113:	31 ff                	xor    %edi,%edi
  802115:	89 e8                	mov    %ebp,%eax
  802117:	89 f2                	mov    %esi,%edx
  802119:	f7 f3                	div    %ebx
  80211b:	89 fa                	mov    %edi,%edx
  80211d:	83 c4 1c             	add    $0x1c,%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5f                   	pop    %edi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
  802125:	8d 76 00             	lea    0x0(%esi),%esi
  802128:	39 f2                	cmp    %esi,%edx
  80212a:	76 14                	jbe    802140 <__udivdi3+0x50>
  80212c:	31 ff                	xor    %edi,%edi
  80212e:	31 c0                	xor    %eax,%eax
  802130:	89 fa                	mov    %edi,%edx
  802132:	83 c4 1c             	add    $0x1c,%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5f                   	pop    %edi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    
  80213a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802140:	0f bd fa             	bsr    %edx,%edi
  802143:	83 f7 1f             	xor    $0x1f,%edi
  802146:	75 48                	jne    802190 <__udivdi3+0xa0>
  802148:	39 f2                	cmp    %esi,%edx
  80214a:	72 06                	jb     802152 <__udivdi3+0x62>
  80214c:	31 c0                	xor    %eax,%eax
  80214e:	39 eb                	cmp    %ebp,%ebx
  802150:	77 de                	ja     802130 <__udivdi3+0x40>
  802152:	b8 01 00 00 00       	mov    $0x1,%eax
  802157:	eb d7                	jmp    802130 <__udivdi3+0x40>
  802159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802160:	89 d9                	mov    %ebx,%ecx
  802162:	85 db                	test   %ebx,%ebx
  802164:	75 0b                	jne    802171 <__udivdi3+0x81>
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f3                	div    %ebx
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	31 d2                	xor    %edx,%edx
  802173:	89 f0                	mov    %esi,%eax
  802175:	f7 f1                	div    %ecx
  802177:	89 c6                	mov    %eax,%esi
  802179:	89 e8                	mov    %ebp,%eax
  80217b:	89 f7                	mov    %esi,%edi
  80217d:	f7 f1                	div    %ecx
  80217f:	89 fa                	mov    %edi,%edx
  802181:	83 c4 1c             	add    $0x1c,%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	5f                   	pop    %edi
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    
  802189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802190:	89 f9                	mov    %edi,%ecx
  802192:	b8 20 00 00 00       	mov    $0x20,%eax
  802197:	29 f8                	sub    %edi,%eax
  802199:	d3 e2                	shl    %cl,%edx
  80219b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80219f:	89 c1                	mov    %eax,%ecx
  8021a1:	89 da                	mov    %ebx,%edx
  8021a3:	d3 ea                	shr    %cl,%edx
  8021a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021a9:	09 d1                	or     %edx,%ecx
  8021ab:	89 f2                	mov    %esi,%edx
  8021ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021b1:	89 f9                	mov    %edi,%ecx
  8021b3:	d3 e3                	shl    %cl,%ebx
  8021b5:	89 c1                	mov    %eax,%ecx
  8021b7:	d3 ea                	shr    %cl,%edx
  8021b9:	89 f9                	mov    %edi,%ecx
  8021bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021bf:	89 eb                	mov    %ebp,%ebx
  8021c1:	d3 e6                	shl    %cl,%esi
  8021c3:	89 c1                	mov    %eax,%ecx
  8021c5:	d3 eb                	shr    %cl,%ebx
  8021c7:	09 de                	or     %ebx,%esi
  8021c9:	89 f0                	mov    %esi,%eax
  8021cb:	f7 74 24 08          	divl   0x8(%esp)
  8021cf:	89 d6                	mov    %edx,%esi
  8021d1:	89 c3                	mov    %eax,%ebx
  8021d3:	f7 64 24 0c          	mull   0xc(%esp)
  8021d7:	39 d6                	cmp    %edx,%esi
  8021d9:	72 15                	jb     8021f0 <__udivdi3+0x100>
  8021db:	89 f9                	mov    %edi,%ecx
  8021dd:	d3 e5                	shl    %cl,%ebp
  8021df:	39 c5                	cmp    %eax,%ebp
  8021e1:	73 04                	jae    8021e7 <__udivdi3+0xf7>
  8021e3:	39 d6                	cmp    %edx,%esi
  8021e5:	74 09                	je     8021f0 <__udivdi3+0x100>
  8021e7:	89 d8                	mov    %ebx,%eax
  8021e9:	31 ff                	xor    %edi,%edi
  8021eb:	e9 40 ff ff ff       	jmp    802130 <__udivdi3+0x40>
  8021f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021f3:	31 ff                	xor    %edi,%edi
  8021f5:	e9 36 ff ff ff       	jmp    802130 <__udivdi3+0x40>
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__umoddi3>:
  802200:	f3 0f 1e fb          	endbr32 
  802204:	55                   	push   %ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 1c             	sub    $0x1c,%esp
  80220b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80220f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802213:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802217:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221b:	85 c0                	test   %eax,%eax
  80221d:	75 19                	jne    802238 <__umoddi3+0x38>
  80221f:	39 df                	cmp    %ebx,%edi
  802221:	76 5d                	jbe    802280 <__umoddi3+0x80>
  802223:	89 f0                	mov    %esi,%eax
  802225:	89 da                	mov    %ebx,%edx
  802227:	f7 f7                	div    %edi
  802229:	89 d0                	mov    %edx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	89 f2                	mov    %esi,%edx
  80223a:	39 d8                	cmp    %ebx,%eax
  80223c:	76 12                	jbe    802250 <__umoddi3+0x50>
  80223e:	89 f0                	mov    %esi,%eax
  802240:	89 da                	mov    %ebx,%edx
  802242:	83 c4 1c             	add    $0x1c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	0f bd e8             	bsr    %eax,%ebp
  802253:	83 f5 1f             	xor    $0x1f,%ebp
  802256:	75 50                	jne    8022a8 <__umoddi3+0xa8>
  802258:	39 d8                	cmp    %ebx,%eax
  80225a:	0f 82 e0 00 00 00    	jb     802340 <__umoddi3+0x140>
  802260:	89 d9                	mov    %ebx,%ecx
  802262:	39 f7                	cmp    %esi,%edi
  802264:	0f 86 d6 00 00 00    	jbe    802340 <__umoddi3+0x140>
  80226a:	89 d0                	mov    %edx,%eax
  80226c:	89 ca                	mov    %ecx,%edx
  80226e:	83 c4 1c             	add    $0x1c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    
  802276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80227d:	8d 76 00             	lea    0x0(%esi),%esi
  802280:	89 fd                	mov    %edi,%ebp
  802282:	85 ff                	test   %edi,%edi
  802284:	75 0b                	jne    802291 <__umoddi3+0x91>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f7                	div    %edi
  80228f:	89 c5                	mov    %eax,%ebp
  802291:	89 d8                	mov    %ebx,%eax
  802293:	31 d2                	xor    %edx,%edx
  802295:	f7 f5                	div    %ebp
  802297:	89 f0                	mov    %esi,%eax
  802299:	f7 f5                	div    %ebp
  80229b:	89 d0                	mov    %edx,%eax
  80229d:	31 d2                	xor    %edx,%edx
  80229f:	eb 8c                	jmp    80222d <__umoddi3+0x2d>
  8022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	89 e9                	mov    %ebp,%ecx
  8022aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8022af:	29 ea                	sub    %ebp,%edx
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b7:	89 d1                	mov    %edx,%ecx
  8022b9:	89 f8                	mov    %edi,%eax
  8022bb:	d3 e8                	shr    %cl,%eax
  8022bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022c9:	09 c1                	or     %eax,%ecx
  8022cb:	89 d8                	mov    %ebx,%eax
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 e9                	mov    %ebp,%ecx
  8022d3:	d3 e7                	shl    %cl,%edi
  8022d5:	89 d1                	mov    %edx,%ecx
  8022d7:	d3 e8                	shr    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022df:	d3 e3                	shl    %cl,%ebx
  8022e1:	89 c7                	mov    %eax,%edi
  8022e3:	89 d1                	mov    %edx,%ecx
  8022e5:	89 f0                	mov    %esi,%eax
  8022e7:	d3 e8                	shr    %cl,%eax
  8022e9:	89 e9                	mov    %ebp,%ecx
  8022eb:	89 fa                	mov    %edi,%edx
  8022ed:	d3 e6                	shl    %cl,%esi
  8022ef:	09 d8                	or     %ebx,%eax
  8022f1:	f7 74 24 08          	divl   0x8(%esp)
  8022f5:	89 d1                	mov    %edx,%ecx
  8022f7:	89 f3                	mov    %esi,%ebx
  8022f9:	f7 64 24 0c          	mull   0xc(%esp)
  8022fd:	89 c6                	mov    %eax,%esi
  8022ff:	89 d7                	mov    %edx,%edi
  802301:	39 d1                	cmp    %edx,%ecx
  802303:	72 06                	jb     80230b <__umoddi3+0x10b>
  802305:	75 10                	jne    802317 <__umoddi3+0x117>
  802307:	39 c3                	cmp    %eax,%ebx
  802309:	73 0c                	jae    802317 <__umoddi3+0x117>
  80230b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80230f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802313:	89 d7                	mov    %edx,%edi
  802315:	89 c6                	mov    %eax,%esi
  802317:	89 ca                	mov    %ecx,%edx
  802319:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80231e:	29 f3                	sub    %esi,%ebx
  802320:	19 fa                	sbb    %edi,%edx
  802322:	89 d0                	mov    %edx,%eax
  802324:	d3 e0                	shl    %cl,%eax
  802326:	89 e9                	mov    %ebp,%ecx
  802328:	d3 eb                	shr    %cl,%ebx
  80232a:	d3 ea                	shr    %cl,%edx
  80232c:	09 d8                	or     %ebx,%eax
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	29 fe                	sub    %edi,%esi
  802342:	19 c3                	sbb    %eax,%ebx
  802344:	89 f2                	mov    %esi,%edx
  802346:	89 d9                	mov    %ebx,%ecx
  802348:	e9 1d ff ff ff       	jmp    80226a <__umoddi3+0x6a>
