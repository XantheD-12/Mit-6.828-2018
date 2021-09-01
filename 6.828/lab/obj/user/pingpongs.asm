
obj/user/pingpongs.debug：     文件格式 elf32-i386


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
  80002c:	e8 d6 00 00 00       	call   800107 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  800040:	e8 26 11 00 00       	call   80116b <sfork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 74                	jne    8000c0 <umain+0x8d>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 00                	push   $0x0
  800051:	6a 00                	push   $0x0
  800053:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 2d 11 00 00       	call   801189 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80005c:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800062:	8b 7b 48             	mov    0x48(%ebx),%edi
  800065:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800068:	a1 04 40 80 00       	mov    0x804004,%eax
  80006d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800070:	e8 9d 0b 00 00       	call   800c12 <sys_getenvid>
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	57                   	push   %edi
  800079:	53                   	push   %ebx
  80007a:	56                   	push   %esi
  80007b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 90 23 80 00       	push   $0x802390
  800084:	e8 83 01 00 00       	call   80020c <cprintf>
		if (val == 10)
  800089:	a1 04 40 80 00       	mov    0x804004,%eax
  80008e:	83 c4 20             	add    $0x20,%esp
  800091:	83 f8 0a             	cmp    $0xa,%eax
  800094:	74 22                	je     8000b8 <umain+0x85>
			return;
		++val;
  800096:	83 c0 01             	add    $0x1,%eax
  800099:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	6a 00                	push   $0x0
  8000a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a7:	e8 4a 11 00 00       	call   8011f6 <ipc_send>
		if (val == 10)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  8000b6:	75 94                	jne    80004c <umain+0x19>
			return;
	}

}
  8000b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000c0:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c6:	e8 47 0b 00 00       	call   800c12 <sys_getenvid>
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	53                   	push   %ebx
  8000cf:	50                   	push   %eax
  8000d0:	68 60 23 80 00       	push   $0x802360
  8000d5:	e8 32 01 00 00       	call   80020c <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000dd:	e8 30 0b 00 00       	call   800c12 <sys_getenvid>
  8000e2:	83 c4 0c             	add    $0xc,%esp
  8000e5:	53                   	push   %ebx
  8000e6:	50                   	push   %eax
  8000e7:	68 7a 23 80 00       	push   $0x80237a
  8000ec:	e8 1b 01 00 00       	call   80020c <cprintf>
		ipc_send(who, 0, 0, 0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	6a 00                	push   $0x0
  8000f5:	6a 00                	push   $0x0
  8000f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fa:	e8 f7 10 00 00       	call   8011f6 <ipc_send>
  8000ff:	83 c4 20             	add    $0x20,%esp
  800102:	e9 45 ff ff ff       	jmp    80004c <umain+0x19>

00800107 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	56                   	push   %esi
  80010f:	53                   	push   %ebx
  800110:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800113:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800116:	e8 f7 0a 00 00       	call   800c12 <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800123:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800128:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 db                	test   %ebx,%ebx
  80012f:	7e 07                	jle    800138 <libmain+0x31>
		binaryname = argv[0];
  800131:	8b 06                	mov    (%esi),%eax
  800133:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
  80013d:	e8 f1 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800142:	e8 0a 00 00 00       	call   800151 <exit>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800151:	f3 0f 1e fb          	endbr32 
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015b:	e8 1c 13 00 00       	call   80147c <close_all>
	sys_env_destroy(0);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	6a 00                	push   $0x0
  800165:	e8 63 0a 00 00       	call   800bcd <sys_env_destroy>
}
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016f:	f3 0f 1e fb          	endbr32 
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017d:	8b 13                	mov    (%ebx),%edx
  80017f:	8d 42 01             	lea    0x1(%edx),%eax
  800182:	89 03                	mov    %eax,(%ebx)
  800184:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800187:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800190:	74 09                	je     80019b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800192:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800199:	c9                   	leave  
  80019a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	68 ff 00 00 00       	push   $0xff
  8001a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a6:	50                   	push   %eax
  8001a7:	e8 dc 09 00 00       	call   800b88 <sys_cputs>
		b->idx = 0;
  8001ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	eb db                	jmp    800192 <putch+0x23>

008001b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b7:	f3 0f 1e fb          	endbr32 
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cb:	00 00 00 
	b.cnt = 0;
  8001ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	68 6f 01 80 00       	push   $0x80016f
  8001ea:	e8 20 01 00 00       	call   80030f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 84 09 00 00       	call   800b88 <sys_cputs>

	return b.cnt;
}
  800204:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800216:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800219:	50                   	push   %eax
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 95 ff ff ff       	call   8001b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	57                   	push   %edi
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
  80022a:	83 ec 1c             	sub    $0x1c,%esp
  80022d:	89 c7                	mov    %eax,%edi
  80022f:	89 d6                	mov    %edx,%esi
  800231:	8b 45 08             	mov    0x8(%ebp),%eax
  800234:	8b 55 0c             	mov    0xc(%ebp),%edx
  800237:	89 d1                	mov    %edx,%ecx
  800239:	89 c2                	mov    %eax,%edx
  80023b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800241:	8b 45 10             	mov    0x10(%ebp),%eax
  800244:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800251:	39 c2                	cmp    %eax,%edx
  800253:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800256:	72 3e                	jb     800296 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	ff 75 18             	pushl  0x18(%ebp)
  80025e:	83 eb 01             	sub    $0x1,%ebx
  800261:	53                   	push   %ebx
  800262:	50                   	push   %eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 89 1e 00 00       	call   802100 <__udivdi3>
  800277:	83 c4 18             	add    $0x18,%esp
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	89 f2                	mov    %esi,%edx
  80027e:	89 f8                	mov    %edi,%eax
  800280:	e8 9f ff ff ff       	call   800224 <printnum>
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	eb 13                	jmp    80029d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	ff 75 18             	pushl  0x18(%ebp)
  800291:	ff d7                	call   *%edi
  800293:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800296:	83 eb 01             	sub    $0x1,%ebx
  800299:	85 db                	test   %ebx,%ebx
  80029b:	7f ed                	jg     80028a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	56                   	push   %esi
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	e8 5b 1f 00 00       	call   802210 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 c0 23 80 00 	movsbl 0x8023c0(%eax),%eax
  8002bf:	50                   	push   %eax
  8002c0:	ff d7                	call   *%edi
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cd:	f3 0f 1e fb          	endbr32 
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x1f>
		*b->buf++ = ch;
  8002e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	88 02                	mov    %al,(%edx)
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <printfmt>:
{
  8002ee:	f3 0f 1e fb          	endbr32 
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	e8 05 00 00 00       	call   80030f <vprintfmt>
}
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <vprintfmt>:
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 3c             	sub    $0x3c,%esp
  80031c:	8b 75 08             	mov    0x8(%ebp),%esi
  80031f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800322:	8b 7d 10             	mov    0x10(%ebp),%edi
  800325:	e9 8e 03 00 00       	jmp    8006b8 <vprintfmt+0x3a9>
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 df 03 00 00    	ja     80073b <vprintfmt+0x42c>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	3e ff 24 85 00 25 80 	notrack jmp *0x802500(,%eax,4)
  800366:	00 
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036e:	eb d8                	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800373:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800377:	eb cf                	jmp    800348 <vprintfmt+0x39>
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 90                	jns    800348 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c5:	eb 81                	jmp    800348 <vprintfmt+0x39>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003da:	e9 69 ff ff ff       	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e9:	e9 5a ff ff ff       	jmp    800348 <vprintfmt+0x39>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0xa3>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 47 ff ff ff       	jmp    800348 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 9b 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x140>
  80042c:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 31 29 80 00       	push   $0x802931
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 d8 23 80 00       	push   $0x8023d8
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 92 fe ff ff       	call   8002ee <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 4e 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800475:	85 d2                	test   %edx,%edx
  800477:	b8 d1 23 80 00       	mov    $0x8023d1,%eax
  80047c:	0f 45 c2             	cmovne %edx,%eax
  80047f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800482:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800486:	7e 06                	jle    80048e <vprintfmt+0x17f>
  800488:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048c:	75 0d                	jne    80049b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800491:	89 c7                	mov    %eax,%edi
  800493:	03 45 e0             	add    -0x20(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	eb 55                	jmp    8004f0 <vprintfmt+0x1e1>
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a1:	ff 75 cc             	pushl  -0x34(%ebp)
  8004a4:	e8 46 03 00 00       	call   8007ef <strnlen>
  8004a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ac:	29 c2                	sub    %eax,%edx
  8004ae:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	85 ff                	test   %edi,%edi
  8004bf:	7e 11                	jle    8004d2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	eb eb                	jmp    8004bd <vprintfmt+0x1ae>
  8004d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	0f 49 c2             	cmovns %edx,%eax
  8004df:	29 c2                	sub    %eax,%edx
  8004e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e4:	eb a8                	jmp    80048e <vprintfmt+0x17f>
					putch(ch, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	52                   	push   %edx
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 c7 01             	add    $0x1,%edi
  8004f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fc:	0f be d0             	movsbl %al,%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 4b                	je     80054e <vprintfmt+0x23f>
  800503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800507:	78 06                	js     80050f <vprintfmt+0x200>
  800509:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050d:	78 1e                	js     80052d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800513:	74 d1                	je     8004e6 <vprintfmt+0x1d7>
  800515:	0f be c0             	movsbl %al,%eax
  800518:	83 e8 20             	sub    $0x20,%eax
  80051b:	83 f8 5e             	cmp    $0x5e,%eax
  80051e:	76 c6                	jbe    8004e6 <vprintfmt+0x1d7>
					putch('?', putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	6a 3f                	push   $0x3f
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb c3                	jmp    8004f0 <vprintfmt+0x1e1>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb 0e                	jmp    80053f <vprintfmt+0x230>
				putch(' ', putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	6a 20                	push   $0x20
  800537:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ee                	jg     800531 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800543:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	e9 67 01 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
  80054e:	89 cf                	mov    %ecx,%edi
  800550:	eb ed                	jmp    80053f <vprintfmt+0x230>
	if (lflag >= 2)
  800552:	83 f9 01             	cmp    $0x1,%ecx
  800555:	7f 1b                	jg     800572 <vprintfmt+0x263>
	else if (lflag)
  800557:	85 c9                	test   %ecx,%ecx
  800559:	74 63                	je     8005be <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	99                   	cltd   
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	eb 17                	jmp    800589 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 50 04             	mov    0x4(%eax),%edx
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 40 08             	lea    0x8(%eax),%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800589:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80058f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800594:	85 c9                	test   %ecx,%ecx
  800596:	0f 89 ff 00 00 00    	jns    80069b <vprintfmt+0x38c>
				putch('-', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 2d                	push   $0x2d
  8005a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005aa:	f7 da                	neg    %edx
  8005ac:	83 d1 00             	adc    $0x0,%ecx
  8005af:	f7 d9                	neg    %ecx
  8005b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b9:	e9 dd 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	99                   	cltd   
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	eb b4                	jmp    800589 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005d5:	83 f9 01             	cmp    $0x1,%ecx
  8005d8:	7f 1e                	jg     8005f8 <vprintfmt+0x2e9>
	else if (lflag)
  8005da:	85 c9                	test   %ecx,%ecx
  8005dc:	74 32                	je     800610 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005f3:	e9 a3 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80060b:	e9 8b 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800625:	eb 74                	jmp    80069b <vprintfmt+0x38c>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x338>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800640:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800645:	eb 54                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80065a:	eb 3f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800671:	eb 28                	jmp    80069b <vprintfmt+0x38c>
			putch('0', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 30                	push   $0x30
  800679:	ff d6                	call   *%esi
			putch('x', putdat);
  80067b:	83 c4 08             	add    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 78                	push   $0x78
  800681:	ff d6                	call   *%esi
			num = (unsigned long long)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800696:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006a2:	57                   	push   %edi
  8006a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a6:	50                   	push   %eax
  8006a7:	51                   	push   %ecx
  8006a8:	52                   	push   %edx
  8006a9:	89 da                	mov    %ebx,%edx
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	e8 72 fb ff ff       	call   800224 <printnum>
			break;
  8006b2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b8:	83 c7 01             	add    $0x1,%edi
  8006bb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bf:	83 f8 25             	cmp    $0x25,%eax
  8006c2:	0f 84 62 fc ff ff    	je     80032a <vprintfmt+0x1b>
			if (ch == '\0')
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	0f 84 8b 00 00 00    	je     80075b <vprintfmt+0x44c>
			putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	50                   	push   %eax
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	eb dc                	jmp    8006b8 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	7f 1b                	jg     8006fc <vprintfmt+0x3ed>
	else if (lflag)
  8006e1:	85 c9                	test   %ecx,%ecx
  8006e3:	74 2c                	je     800711 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006fa:	eb 9f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80070f:	eb 8a                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800726:	e9 70 ff ff ff       	jmp    80069b <vprintfmt+0x38c>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 25                	push   $0x25
  800731:	ff d6                	call   *%esi
			break;
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	e9 7a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
			putch('%', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 25                	push   $0x25
  800741:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 f8                	mov    %edi,%eax
  800748:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074c:	74 05                	je     800753 <vprintfmt+0x444>
  80074e:	83 e8 01             	sub    $0x1,%eax
  800751:	eb f5                	jmp    800748 <vprintfmt+0x439>
  800753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800756:	e9 5a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
}
  80075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075e:	5b                   	pop    %ebx
  80075f:	5e                   	pop    %esi
  800760:	5f                   	pop    %edi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    

00800763 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800763:	f3 0f 1e fb          	endbr32 
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 18             	sub    $0x18,%esp
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800776:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800784:	85 c0                	test   %eax,%eax
  800786:	74 26                	je     8007ae <vsnprintf+0x4b>
  800788:	85 d2                	test   %edx,%edx
  80078a:	7e 22                	jle    8007ae <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078c:	ff 75 14             	pushl  0x14(%ebp)
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	68 cd 02 80 00       	push   $0x8002cd
  80079b:	e8 6f fb ff ff       	call   80030f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    
		return -E_INVAL;
  8007ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b3:	eb f7                	jmp    8007ac <vsnprintf+0x49>

008007b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b5:	f3 0f 1e fb          	endbr32 
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 10             	pushl  0x10(%ebp)
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 92 ff ff ff       	call   800763 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e6:	74 05                	je     8007ed <strlen+0x1a>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
  8007eb:	eb f5                	jmp    8007e2 <strlen+0xf>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ef:	f3 0f 1e fb          	endbr32 
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800801:	39 d0                	cmp    %edx,%eax
  800803:	74 0d                	je     800812 <strnlen+0x23>
  800805:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800809:	74 05                	je     800810 <strnlen+0x21>
		n++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	eb f1                	jmp    800801 <strnlen+0x12>
  800810:	89 c2                	mov    %eax,%edx
	return n;
}
  800812:	89 d0                	mov    %edx,%eax
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800816:	f3 0f 1e fb          	endbr32 
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80082d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800830:	83 c0 01             	add    $0x1,%eax
  800833:	84 d2                	test   %dl,%dl
  800835:	75 f2                	jne    800829 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800837:	89 c8                	mov    %ecx,%eax
  800839:	5b                   	pop    %ebx
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083c:	f3 0f 1e fb          	endbr32 
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 10             	sub    $0x10,%esp
  800847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084a:	53                   	push   %ebx
  80084b:	e8 83 ff ff ff       	call   8007d3 <strlen>
  800850:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	01 d8                	add    %ebx,%eax
  800858:	50                   	push   %eax
  800859:	e8 b8 ff ff ff       	call   800816 <strcpy>
	return dst;
}
  80085e:	89 d8                	mov    %ebx,%eax
  800860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800865:	f3 0f 1e fb          	endbr32 
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	56                   	push   %esi
  80086d:	53                   	push   %ebx
  80086e:	8b 75 08             	mov    0x8(%ebp),%esi
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
  800874:	89 f3                	mov    %esi,%ebx
  800876:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800879:	89 f0                	mov    %esi,%eax
  80087b:	39 d8                	cmp    %ebx,%eax
  80087d:	74 11                	je     800890 <strncpy+0x2b>
		*dst++ = *src;
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 0a             	movzbl (%edx),%ecx
  800885:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800888:	80 f9 01             	cmp    $0x1,%cl
  80088b:	83 da ff             	sbb    $0xffffffff,%edx
  80088e:	eb eb                	jmp    80087b <strncpy+0x16>
	}
	return ret;
}
  800890:	89 f0                	mov    %esi,%eax
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	56                   	push   %esi
  80089e:	53                   	push   %ebx
  80089f:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a5:	8b 55 10             	mov    0x10(%ebp),%edx
  8008a8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	74 21                	je     8008cf <strlcpy+0x39>
  8008ae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008b2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	74 14                	je     8008cc <strlcpy+0x36>
  8008b8:	0f b6 19             	movzbl (%ecx),%ebx
  8008bb:	84 db                	test   %bl,%bl
  8008bd:	74 0b                	je     8008ca <strlcpy+0x34>
			*dst++ = *src++;
  8008bf:	83 c1 01             	add    $0x1,%ecx
  8008c2:	83 c2 01             	add    $0x1,%edx
  8008c5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c8:	eb ea                	jmp    8008b4 <strlcpy+0x1e>
  8008ca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008cf:	29 f0                	sub    %esi,%eax
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e2:	0f b6 01             	movzbl (%ecx),%eax
  8008e5:	84 c0                	test   %al,%al
  8008e7:	74 0c                	je     8008f5 <strcmp+0x20>
  8008e9:	3a 02                	cmp    (%edx),%al
  8008eb:	75 08                	jne    8008f5 <strcmp+0x20>
		p++, q++;
  8008ed:	83 c1 01             	add    $0x1,%ecx
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb ed                	jmp    8008e2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f5:	0f b6 c0             	movzbl %al,%eax
  8008f8:	0f b6 12             	movzbl (%edx),%edx
  8008fb:	29 d0                	sub    %edx,%eax
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090d:	89 c3                	mov    %eax,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800912:	eb 06                	jmp    80091a <strncmp+0x1b>
		n--, p++, q++;
  800914:	83 c0 01             	add    $0x1,%eax
  800917:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80091a:	39 d8                	cmp    %ebx,%eax
  80091c:	74 16                	je     800934 <strncmp+0x35>
  80091e:	0f b6 08             	movzbl (%eax),%ecx
  800921:	84 c9                	test   %cl,%cl
  800923:	74 04                	je     800929 <strncmp+0x2a>
  800925:	3a 0a                	cmp    (%edx),%cl
  800927:	74 eb                	je     800914 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800929:	0f b6 00             	movzbl (%eax),%eax
  80092c:	0f b6 12             	movzbl (%edx),%edx
  80092f:	29 d0                	sub    %edx,%eax
}
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    
		return 0;
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	eb f6                	jmp    800931 <strncmp+0x32>

0080093b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093b:	f3 0f 1e fb          	endbr32 
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800949:	0f b6 10             	movzbl (%eax),%edx
  80094c:	84 d2                	test   %dl,%dl
  80094e:	74 09                	je     800959 <strchr+0x1e>
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 0a                	je     80095e <strchr+0x23>
	for (; *s; s++)
  800954:	83 c0 01             	add    $0x1,%eax
  800957:	eb f0                	jmp    800949 <strchr+0xe>
			return (char *) s;
	return 0;
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800960:	f3 0f 1e fb          	endbr32 
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 09                	je     80097e <strfind+0x1e>
  800975:	84 d2                	test   %dl,%dl
  800977:	74 05                	je     80097e <strfind+0x1e>
	for (; *s; s++)
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	eb f0                	jmp    80096e <strfind+0xe>
			break;
	return (char *) s;
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	57                   	push   %edi
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800990:	85 c9                	test   %ecx,%ecx
  800992:	74 31                	je     8009c5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800994:	89 f8                	mov    %edi,%eax
  800996:	09 c8                	or     %ecx,%eax
  800998:	a8 03                	test   $0x3,%al
  80099a:	75 23                	jne    8009bf <memset+0x3f>
		c &= 0xFF;
  80099c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a0:	89 d3                	mov    %edx,%ebx
  8009a2:	c1 e3 08             	shl    $0x8,%ebx
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	c1 e0 18             	shl    $0x18,%eax
  8009aa:	89 d6                	mov    %edx,%esi
  8009ac:	c1 e6 10             	shl    $0x10,%esi
  8009af:	09 f0                	or     %esi,%eax
  8009b1:	09 c2                	or     %eax,%edx
  8009b3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 ab                	rep stos %eax,%es:(%edi)
  8009bd:	eb 06                	jmp    8009c5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	fc                   	cld    
  8009c3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c5:	89 f8                	mov    %edi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	57                   	push   %edi
  8009d4:	56                   	push   %esi
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009de:	39 c6                	cmp    %eax,%esi
  8009e0:	73 32                	jae    800a14 <memmove+0x48>
  8009e2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e5:	39 c2                	cmp    %eax,%edx
  8009e7:	76 2b                	jbe    800a14 <memmove+0x48>
		s += n;
		d += n;
  8009e9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 fe                	mov    %edi,%esi
  8009ee:	09 ce                	or     %ecx,%esi
  8009f0:	09 d6                	or     %edx,%esi
  8009f2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f8:	75 0e                	jne    800a08 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fa:	83 ef 04             	sub    $0x4,%edi
  8009fd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a03:	fd                   	std    
  800a04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a06:	eb 09                	jmp    800a11 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a08:	83 ef 01             	sub    $0x1,%edi
  800a0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a11:	fc                   	cld    
  800a12:	eb 1a                	jmp    800a2e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	09 ca                	or     %ecx,%edx
  800a18:	09 f2                	or     %esi,%edx
  800a1a:	f6 c2 03             	test   $0x3,%dl
  800a1d:	75 0a                	jne    800a29 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a22:	89 c7                	mov    %eax,%edi
  800a24:	fc                   	cld    
  800a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a27:	eb 05                	jmp    800a2e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a32:	f3 0f 1e fb          	endbr32 
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a3c:	ff 75 10             	pushl  0x10(%ebp)
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	e8 82 ff ff ff       	call   8009cc <memmove>
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 c6                	mov    %eax,%esi
  800a5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a60:	39 f0                	cmp    %esi,%eax
  800a62:	74 1c                	je     800a80 <memcmp+0x34>
		if (*s1 != *s2)
  800a64:	0f b6 08             	movzbl (%eax),%ecx
  800a67:	0f b6 1a             	movzbl (%edx),%ebx
  800a6a:	38 d9                	cmp    %bl,%cl
  800a6c:	75 08                	jne    800a76 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	eb ea                	jmp    800a60 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a76:	0f b6 c1             	movzbl %cl,%eax
  800a79:	0f b6 db             	movzbl %bl,%ebx
  800a7c:	29 d8                	sub    %ebx,%eax
  800a7e:	eb 05                	jmp    800a85 <memcmp+0x39>
	}

	return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a96:	89 c2                	mov    %eax,%edx
  800a98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 09                	jae    800aa8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9f:	38 08                	cmp    %cl,(%eax)
  800aa1:	74 05                	je     800aa8 <memfind+0x1f>
	for (; s < ends; s++)
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	eb f3                	jmp    800a9b <memfind+0x12>
			break;
	return (void *) s;
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aba:	eb 03                	jmp    800abf <strtol+0x15>
		s++;
  800abc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abf:	0f b6 01             	movzbl (%ecx),%eax
  800ac2:	3c 20                	cmp    $0x20,%al
  800ac4:	74 f6                	je     800abc <strtol+0x12>
  800ac6:	3c 09                	cmp    $0x9,%al
  800ac8:	74 f2                	je     800abc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aca:	3c 2b                	cmp    $0x2b,%al
  800acc:	74 2a                	je     800af8 <strtol+0x4e>
	int neg = 0;
  800ace:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad3:	3c 2d                	cmp    $0x2d,%al
  800ad5:	74 2b                	je     800b02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800add:	75 0f                	jne    800aee <strtol+0x44>
  800adf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae2:	74 28                	je     800b0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aeb:	0f 44 d8             	cmove  %eax,%ebx
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af6:	eb 46                	jmp    800b3e <strtol+0x94>
		s++;
  800af8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afb:	bf 00 00 00 00       	mov    $0x0,%edi
  800b00:	eb d5                	jmp    800ad7 <strtol+0x2d>
		s++, neg = 1;
  800b02:	83 c1 01             	add    $0x1,%ecx
  800b05:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0a:	eb cb                	jmp    800ad7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b10:	74 0e                	je     800b20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b12:	85 db                	test   %ebx,%ebx
  800b14:	75 d8                	jne    800aee <strtol+0x44>
		s++, base = 8;
  800b16:	83 c1 01             	add    $0x1,%ecx
  800b19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1e:	eb ce                	jmp    800aee <strtol+0x44>
		s += 2, base = 16;
  800b20:	83 c1 02             	add    $0x2,%ecx
  800b23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b28:	eb c4                	jmp    800aee <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b2a:	0f be d2             	movsbl %dl,%edx
  800b2d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b33:	7d 3a                	jge    800b6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b35:	83 c1 01             	add    $0x1,%ecx
  800b38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3e:	0f b6 11             	movzbl (%ecx),%edx
  800b41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b44:	89 f3                	mov    %esi,%ebx
  800b46:	80 fb 09             	cmp    $0x9,%bl
  800b49:	76 df                	jbe    800b2a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b4b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4e:	89 f3                	mov    %esi,%ebx
  800b50:	80 fb 19             	cmp    $0x19,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b55:	0f be d2             	movsbl %dl,%edx
  800b58:	83 ea 57             	sub    $0x57,%edx
  800b5b:	eb d3                	jmp    800b30 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 37             	sub    $0x37,%edx
  800b6d:	eb c1                	jmp    800b30 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xd0>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	f7 da                	neg    %edx
  800b7e:	85 ff                	test   %edi,%edi
  800b80:	0f 45 c2             	cmovne %edx,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 c3                	mov    %eax,%ebx
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cgetc>:

int
sys_cgetc(void)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	b8 03 00 00 00       	mov    $0x3,%eax
  800be7:	89 cb                	mov    %ecx,%ebx
  800be9:	89 cf                	mov    %ecx,%edi
  800beb:	89 ce                	mov    %ecx,%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 03                	push   $0x3
  800c01:	68 bf 26 80 00       	push   $0x8026bf
  800c06:	6a 23                	push   $0x23
  800c08:	68 dc 26 80 00       	push   $0x8026dc
  800c0d:	e8 c0 13 00 00       	call   801fd2 <_panic>

00800c12 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c12:	f3 0f 1e fb          	endbr32 
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 02 00 00 00       	mov    $0x2,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_yield>:

void
sys_yield(void)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c58:	f3 0f 1e fb          	endbr32 
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	be 00 00 00 00       	mov    $0x0,%esi
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	b8 04 00 00 00       	mov    $0x4,%eax
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c78:	89 f7                	mov    %esi,%edi
  800c7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	7f 08                	jg     800c88 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c88:	83 ec 0c             	sub    $0xc,%esp
  800c8b:	50                   	push   %eax
  800c8c:	6a 04                	push   $0x4
  800c8e:	68 bf 26 80 00       	push   $0x8026bf
  800c93:	6a 23                	push   $0x23
  800c95:	68 dc 26 80 00       	push   $0x8026dc
  800c9a:	e8 33 13 00 00       	call   801fd2 <_panic>

00800c9f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbd:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 05                	push   $0x5
  800cd4:	68 bf 26 80 00       	push   $0x8026bf
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 dc 26 80 00       	push   $0x8026dc
  800ce0:	e8 ed 12 00 00       	call   801fd2 <_panic>

00800ce5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce5:	f3 0f 1e fb          	endbr32 
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	89 de                	mov    %ebx,%esi
  800d06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	7f 08                	jg     800d14 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	83 ec 0c             	sub    $0xc,%esp
  800d17:	50                   	push   %eax
  800d18:	6a 06                	push   $0x6
  800d1a:	68 bf 26 80 00       	push   $0x8026bf
  800d1f:	6a 23                	push   $0x23
  800d21:	68 dc 26 80 00       	push   $0x8026dc
  800d26:	e8 a7 12 00 00       	call   801fd2 <_panic>

00800d2b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 08 00 00 00       	mov    $0x8,%eax
  800d48:	89 df                	mov    %ebx,%edi
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 08                	push   $0x8
  800d60:	68 bf 26 80 00       	push   $0x8026bf
  800d65:	6a 23                	push   $0x23
  800d67:	68 dc 26 80 00       	push   $0x8026dc
  800d6c:	e8 61 12 00 00       	call   801fd2 <_panic>

00800d71 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 09                	push   $0x9
  800da6:	68 bf 26 80 00       	push   $0x8026bf
  800dab:	6a 23                	push   $0x23
  800dad:	68 dc 26 80 00       	push   $0x8026dc
  800db2:	e8 1b 12 00 00       	call   801fd2 <_panic>

00800db7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db7:	f3 0f 1e fb          	endbr32 
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 0a                	push   $0xa
  800dec:	68 bf 26 80 00       	push   $0x8026bf
  800df1:	6a 23                	push   $0x23
  800df3:	68 dc 26 80 00       	push   $0x8026dc
  800df8:	e8 d5 11 00 00       	call   801fd2 <_panic>

00800dfd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e12:	be 00 00 00 00       	mov    $0x0,%esi
  800e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e24:	f3 0f 1e fb          	endbr32 
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3e:	89 cb                	mov    %ecx,%ebx
  800e40:	89 cf                	mov    %ecx,%edi
  800e42:	89 ce                	mov    %ecx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 0d                	push   $0xd
  800e58:	68 bf 26 80 00       	push   $0x8026bf
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 dc 26 80 00       	push   $0x8026dc
  800e64:	e8 69 11 00 00       	call   801fd2 <_panic>

00800e69 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e75:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800e77:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e7b:	74 7f                	je     800efc <pgfault+0x93>
  800e7d:	89 f0                	mov    %esi,%eax
  800e7f:	c1 e8 0c             	shr    $0xc,%eax
  800e82:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e89:	f6 c4 08             	test   $0x8,%ah
  800e8c:	74 6e                	je     800efc <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800e8e:	e8 7f fd ff ff       	call   800c12 <sys_getenvid>
  800e93:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800e95:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800e9b:	83 ec 04             	sub    $0x4,%esp
  800e9e:	6a 07                	push   $0x7
  800ea0:	68 00 f0 7f 00       	push   $0x7ff000
  800ea5:	50                   	push   %eax
  800ea6:	e8 ad fd ff ff       	call   800c58 <sys_page_alloc>
  800eab:	83 c4 10             	add    $0x10,%esp
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	78 5e                	js     800f10 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	68 00 10 00 00       	push   $0x1000
  800eba:	56                   	push   %esi
  800ebb:	68 00 f0 7f 00       	push   $0x7ff000
  800ec0:	e8 6d fb ff ff       	call   800a32 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800ec5:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
  800ece:	68 00 f0 7f 00       	push   $0x7ff000
  800ed3:	53                   	push   %ebx
  800ed4:	e8 c6 fd ff ff       	call   800c9f <sys_page_map>
  800ed9:	83 c4 20             	add    $0x20,%esp
  800edc:	85 c0                	test   %eax,%eax
  800ede:	78 44                	js     800f24 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	68 00 f0 7f 00       	push   $0x7ff000
  800ee8:	53                   	push   %ebx
  800ee9:	e8 f7 fd ff ff       	call   800ce5 <sys_page_unmap>
  800eee:	83 c4 10             	add    $0x10,%esp
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	78 43                	js     800f38 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800efc:	83 ec 04             	sub    $0x4,%esp
  800eff:	68 ea 26 80 00       	push   $0x8026ea
  800f04:	6a 1e                	push   $0x1e
  800f06:	68 07 27 80 00       	push   $0x802707
  800f0b:	e8 c2 10 00 00       	call   801fd2 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800f10:	83 ec 04             	sub    $0x4,%esp
  800f13:	68 98 27 80 00       	push   $0x802798
  800f18:	6a 2b                	push   $0x2b
  800f1a:	68 07 27 80 00       	push   $0x802707
  800f1f:	e8 ae 10 00 00       	call   801fd2 <_panic>
		panic("pgfault: sys_page_map Failed!");
  800f24:	83 ec 04             	sub    $0x4,%esp
  800f27:	68 12 27 80 00       	push   $0x802712
  800f2c:	6a 2f                	push   $0x2f
  800f2e:	68 07 27 80 00       	push   $0x802707
  800f33:	e8 9a 10 00 00       	call   801fd2 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	68 b8 27 80 00       	push   $0x8027b8
  800f40:	6a 32                	push   $0x32
  800f42:	68 07 27 80 00       	push   $0x802707
  800f47:	e8 86 10 00 00       	call   801fd2 <_panic>

00800f4c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f4c:	f3 0f 1e fb          	endbr32 
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f59:	68 69 0e 80 00       	push   $0x800e69
  800f5e:	e8 b9 10 00 00       	call   80201c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f63:	b8 07 00 00 00       	mov    $0x7,%eax
  800f68:	cd 30                	int    $0x30
  800f6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	85 c0                	test   %eax,%eax
  800f75:	78 2b                	js     800fa2 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800f77:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  800f7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f80:	0f 85 ba 00 00 00    	jne    801040 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  800f86:	e8 87 fc ff ff       	call   800c12 <sys_getenvid>
  800f8b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f90:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f93:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f98:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800f9d:	e9 90 01 00 00       	jmp    801132 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	68 30 27 80 00       	push   $0x802730
  800faa:	6a 76                	push   $0x76
  800fac:	68 07 27 80 00       	push   $0x802707
  800fb1:	e8 1c 10 00 00       	call   801fd2 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  800fb6:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  800fbd:	e8 50 fc ff ff       	call   800c12 <sys_getenvid>
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800fcb:	56                   	push   %esi
  800fcc:	57                   	push   %edi
  800fcd:	ff 75 e0             	pushl  -0x20(%ebp)
  800fd0:	57                   	push   %edi
  800fd1:	50                   	push   %eax
  800fd2:	e8 c8 fc ff ff       	call   800c9f <sys_page_map>
  800fd7:	83 c4 20             	add    $0x20,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	79 50                	jns    80102e <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  800fde:	83 ec 04             	sub    $0x4,%esp
  800fe1:	68 49 27 80 00       	push   $0x802749
  800fe6:	6a 4b                	push   $0x4b
  800fe8:	68 07 27 80 00       	push   $0x802707
  800fed:	e8 e0 0f 00 00       	call   801fd2 <_panic>
			panic("duppage:child sys_page_map Failed!");
  800ff2:	83 ec 04             	sub    $0x4,%esp
  800ff5:	68 d8 27 80 00       	push   $0x8027d8
  800ffa:	6a 50                	push   $0x50
  800ffc:	68 07 27 80 00       	push   $0x802707
  801001:	e8 cc 0f 00 00       	call   801fd2 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  801006:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80100d:	83 ec 0c             	sub    $0xc,%esp
  801010:	25 07 0e 00 00       	and    $0xe07,%eax
  801015:	50                   	push   %eax
  801016:	57                   	push   %edi
  801017:	ff 75 e0             	pushl  -0x20(%ebp)
  80101a:	57                   	push   %edi
  80101b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101e:	e8 7c fc ff ff       	call   800c9f <sys_page_map>
  801023:	83 c4 20             	add    $0x20,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	0f 88 b4 00 00 00    	js     8010e2 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  80102e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801034:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80103a:	0f 84 b6 00 00 00    	je     8010f6 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801040:	89 d8                	mov    %ebx,%eax
  801042:	c1 e8 16             	shr    $0x16,%eax
  801045:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80104c:	a8 01                	test   $0x1,%al
  80104e:	74 de                	je     80102e <fork+0xe2>
  801050:	89 de                	mov    %ebx,%esi
  801052:	c1 ee 0c             	shr    $0xc,%esi
  801055:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80105c:	a8 01                	test   $0x1,%al
  80105e:	74 ce                	je     80102e <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801060:	e8 ad fb ff ff       	call   800c12 <sys_getenvid>
  801065:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801068:	89 f7                	mov    %esi,%edi
  80106a:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80106d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801074:	f6 c4 04             	test   $0x4,%ah
  801077:	0f 85 39 ff ff ff    	jne    800fb6 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80107d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801084:	a9 02 08 00 00       	test   $0x802,%eax
  801089:	0f 84 77 ff ff ff    	je     801006 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  80108f:	83 ec 0c             	sub    $0xc,%esp
  801092:	68 05 08 00 00       	push   $0x805
  801097:	57                   	push   %edi
  801098:	ff 75 e0             	pushl  -0x20(%ebp)
  80109b:	57                   	push   %edi
  80109c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109f:	e8 fb fb ff ff       	call   800c9f <sys_page_map>
  8010a4:	83 c4 20             	add    $0x20,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	0f 88 43 ff ff ff    	js     800ff2 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	68 05 08 00 00       	push   $0x805
  8010b7:	57                   	push   %edi
  8010b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010bb:	50                   	push   %eax
  8010bc:	57                   	push   %edi
  8010bd:	50                   	push   %eax
  8010be:	e8 dc fb ff ff       	call   800c9f <sys_page_map>
  8010c3:	83 c4 20             	add    $0x20,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	0f 89 60 ff ff ff    	jns    80102e <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	68 fc 27 80 00       	push   $0x8027fc
  8010d6:	6a 52                	push   $0x52
  8010d8:	68 07 27 80 00       	push   $0x802707
  8010dd:	e8 f0 0e 00 00       	call   801fd2 <_panic>
			panic("duppage: single sys_page_map Failed!");
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	68 20 28 80 00       	push   $0x802820
  8010ea:	6a 56                	push   $0x56
  8010ec:	68 07 27 80 00       	push   $0x802707
  8010f1:	e8 dc 0e 00 00       	call   801fd2 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8010f6:	83 ec 04             	sub    $0x4,%esp
  8010f9:	6a 07                	push   $0x7
  8010fb:	68 00 f0 bf ee       	push   $0xeebff000
  801100:	ff 75 dc             	pushl  -0x24(%ebp)
  801103:	e8 50 fb ff ff       	call   800c58 <sys_page_alloc>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 2e                	js     80113d <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80110f:	83 ec 08             	sub    $0x8,%esp
  801112:	68 98 20 80 00       	push   $0x802098
  801117:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80111a:	57                   	push   %edi
  80111b:	e8 97 fc ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801120:	83 c4 08             	add    $0x8,%esp
  801123:	6a 02                	push   $0x2
  801125:	57                   	push   %edi
  801126:	e8 00 fc ff ff       	call   800d2b <sys_env_set_status>
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	78 22                	js     801154 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801132:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801135:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	5f                   	pop    %edi
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	68 66 27 80 00       	push   $0x802766
  801145:	68 83 00 00 00       	push   $0x83
  80114a:	68 07 27 80 00       	push   $0x802707
  80114f:	e8 7e 0e 00 00       	call   801fd2 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801154:	83 ec 04             	sub    $0x4,%esp
  801157:	68 48 28 80 00       	push   $0x802848
  80115c:	68 89 00 00 00       	push   $0x89
  801161:	68 07 27 80 00       	push   $0x802707
  801166:	e8 67 0e 00 00       	call   801fd2 <_panic>

0080116b <sfork>:

// Challenge!
int
sfork(void)
{
  80116b:	f3 0f 1e fb          	endbr32 
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801175:	68 82 27 80 00       	push   $0x802782
  80117a:	68 93 00 00 00       	push   $0x93
  80117f:	68 07 27 80 00       	push   $0x802707
  801184:	e8 49 0e 00 00       	call   801fd2 <_panic>

00801189 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801189:	f3 0f 1e fb          	endbr32 
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	56                   	push   %esi
  801191:	53                   	push   %ebx
  801192:	8b 75 08             	mov    0x8(%ebp),%esi
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80119b:	85 c0                	test   %eax,%eax
  80119d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8011a2:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8011a5:	83 ec 0c             	sub    $0xc,%esp
  8011a8:	50                   	push   %eax
  8011a9:	e8 76 fc ff ff       	call   800e24 <sys_ipc_recv>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	78 2b                	js     8011e0 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8011b5:	85 f6                	test   %esi,%esi
  8011b7:	74 0a                	je     8011c3 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  8011b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8011be:	8b 40 74             	mov    0x74(%eax),%eax
  8011c1:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  8011c3:	85 db                	test   %ebx,%ebx
  8011c5:	74 0a                	je     8011d1 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  8011c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8011cc:	8b 40 78             	mov    0x78(%eax),%eax
  8011cf:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8011d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8011d6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8011d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011dc:	5b                   	pop    %ebx
  8011dd:	5e                   	pop    %esi
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    
		if(from_env_store)
  8011e0:	85 f6                	test   %esi,%esi
  8011e2:	74 06                	je     8011ea <ipc_recv+0x61>
			*from_env_store=0;
  8011e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8011ea:	85 db                	test   %ebx,%ebx
  8011ec:	74 eb                	je     8011d9 <ipc_recv+0x50>
			*perm_store=0;
  8011ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011f4:	eb e3                	jmp    8011d9 <ipc_recv+0x50>

008011f6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011f6:	f3 0f 1e fb          	endbr32 
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	57                   	push   %edi
  8011fe:	56                   	push   %esi
  8011ff:	53                   	push   %ebx
  801200:	83 ec 0c             	sub    $0xc,%esp
  801203:	8b 7d 08             	mov    0x8(%ebp),%edi
  801206:	8b 75 0c             	mov    0xc(%ebp),%esi
  801209:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80120c:	85 db                	test   %ebx,%ebx
  80120e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801213:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801216:	ff 75 14             	pushl  0x14(%ebp)
  801219:	53                   	push   %ebx
  80121a:	56                   	push   %esi
  80121b:	57                   	push   %edi
  80121c:	e8 dc fb ff ff       	call   800dfd <sys_ipc_try_send>
		if(!res)
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	85 c0                	test   %eax,%eax
  801226:	74 20                	je     801248 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  801228:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80122b:	75 07                	jne    801234 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80122d:	e8 03 fa ff ff       	call   800c35 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801232:	eb e2                	jmp    801216 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  801234:	83 ec 04             	sub    $0x4,%esp
  801237:	68 69 28 80 00       	push   $0x802869
  80123c:	6a 3f                	push   $0x3f
  80123e:	68 81 28 80 00       	push   $0x802881
  801243:	e8 8a 0d 00 00       	call   801fd2 <_panic>
	}
}
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801250:	f3 0f 1e fb          	endbr32 
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80125f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801262:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801268:	8b 52 50             	mov    0x50(%edx),%edx
  80126b:	39 ca                	cmp    %ecx,%edx
  80126d:	74 11                	je     801280 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80126f:	83 c0 01             	add    $0x1,%eax
  801272:	3d 00 04 00 00       	cmp    $0x400,%eax
  801277:	75 e6                	jne    80125f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
  80127e:	eb 0b                	jmp    80128b <ipc_find_env+0x3b>
			return envs[i].env_id;
  801280:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801283:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801288:	8b 40 48             	mov    0x48(%eax),%eax
}
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80128d:	f3 0f 1e fb          	endbr32 
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	05 00 00 00 30       	add    $0x30000000,%eax
  80129c:	c1 e8 0c             	shr    $0xc,%eax
}
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    

008012a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012a1:	f3 0f 1e fb          	endbr32 
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012bc:	f3 0f 1e fb          	endbr32 
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012c8:	89 c2                	mov    %eax,%edx
  8012ca:	c1 ea 16             	shr    $0x16,%edx
  8012cd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012d4:	f6 c2 01             	test   $0x1,%dl
  8012d7:	74 2d                	je     801306 <fd_alloc+0x4a>
  8012d9:	89 c2                	mov    %eax,%edx
  8012db:	c1 ea 0c             	shr    $0xc,%edx
  8012de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e5:	f6 c2 01             	test   $0x1,%dl
  8012e8:	74 1c                	je     801306 <fd_alloc+0x4a>
  8012ea:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012ef:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012f4:	75 d2                	jne    8012c8 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801304:	eb 0a                	jmp    801310 <fd_alloc+0x54>
			*fd_store = fd;
  801306:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801309:	89 01                	mov    %eax,(%ecx)
			return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    

00801312 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801312:	f3 0f 1e fb          	endbr32 
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80131c:	83 f8 1f             	cmp    $0x1f,%eax
  80131f:	77 30                	ja     801351 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801321:	c1 e0 0c             	shl    $0xc,%eax
  801324:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801329:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80132f:	f6 c2 01             	test   $0x1,%dl
  801332:	74 24                	je     801358 <fd_lookup+0x46>
  801334:	89 c2                	mov    %eax,%edx
  801336:	c1 ea 0c             	shr    $0xc,%edx
  801339:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801340:	f6 c2 01             	test   $0x1,%dl
  801343:	74 1a                	je     80135f <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	89 02                	mov    %eax,(%edx)
	return 0;
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    
		return -E_INVAL;
  801351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801356:	eb f7                	jmp    80134f <fd_lookup+0x3d>
		return -E_INVAL;
  801358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135d:	eb f0                	jmp    80134f <fd_lookup+0x3d>
  80135f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801364:	eb e9                	jmp    80134f <fd_lookup+0x3d>

00801366 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801366:	f3 0f 1e fb          	endbr32 
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 08             	sub    $0x8,%esp
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	ba 08 29 80 00       	mov    $0x802908,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801378:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80137d:	39 08                	cmp    %ecx,(%eax)
  80137f:	74 33                	je     8013b4 <dev_lookup+0x4e>
  801381:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801384:	8b 02                	mov    (%edx),%eax
  801386:	85 c0                	test   %eax,%eax
  801388:	75 f3                	jne    80137d <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80138a:	a1 08 40 80 00       	mov    0x804008,%eax
  80138f:	8b 40 48             	mov    0x48(%eax),%eax
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	51                   	push   %ecx
  801396:	50                   	push   %eax
  801397:	68 8c 28 80 00       	push   $0x80288c
  80139c:	e8 6b ee ff ff       	call   80020c <cprintf>
	*dev = 0;
  8013a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    
			*dev = devtab[i];
  8013b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	eb f2                	jmp    8013b2 <dev_lookup+0x4c>

008013c0 <fd_close>:
{
  8013c0:	f3 0f 1e fb          	endbr32 
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	57                   	push   %edi
  8013c8:	56                   	push   %esi
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 24             	sub    $0x24,%esp
  8013cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013dd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e0:	50                   	push   %eax
  8013e1:	e8 2c ff ff ff       	call   801312 <fd_lookup>
  8013e6:	89 c3                	mov    %eax,%ebx
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 05                	js     8013f4 <fd_close+0x34>
	    || fd != fd2)
  8013ef:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013f2:	74 16                	je     80140a <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013f4:	89 f8                	mov    %edi,%eax
  8013f6:	84 c0                	test   %al,%al
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fd:	0f 44 d8             	cmove  %eax,%ebx
}
  801400:	89 d8                	mov    %ebx,%eax
  801402:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5f                   	pop    %edi
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801410:	50                   	push   %eax
  801411:	ff 36                	pushl  (%esi)
  801413:	e8 4e ff ff ff       	call   801366 <dev_lookup>
  801418:	89 c3                	mov    %eax,%ebx
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 1a                	js     80143b <fd_close+0x7b>
		if (dev->dev_close)
  801421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801424:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801427:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80142c:	85 c0                	test   %eax,%eax
  80142e:	74 0b                	je     80143b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	56                   	push   %esi
  801434:	ff d0                	call   *%eax
  801436:	89 c3                	mov    %eax,%ebx
  801438:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	56                   	push   %esi
  80143f:	6a 00                	push   $0x0
  801441:	e8 9f f8 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	eb b5                	jmp    801400 <fd_close+0x40>

0080144b <close>:

int
close(int fdnum)
{
  80144b:	f3 0f 1e fb          	endbr32 
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	e8 b1 fe ff ff       	call   801312 <fd_lookup>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	79 02                	jns    80146a <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    
		return fd_close(fd, 1);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	6a 01                	push   $0x1
  80146f:	ff 75 f4             	pushl  -0xc(%ebp)
  801472:	e8 49 ff ff ff       	call   8013c0 <fd_close>
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	eb ec                	jmp    801468 <close+0x1d>

0080147c <close_all>:

void
close_all(void)
{
  80147c:	f3 0f 1e fb          	endbr32 
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	53                   	push   %ebx
  801484:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801487:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	53                   	push   %ebx
  801490:	e8 b6 ff ff ff       	call   80144b <close>
	for (i = 0; i < MAXFD; i++)
  801495:	83 c3 01             	add    $0x1,%ebx
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	83 fb 20             	cmp    $0x20,%ebx
  80149e:	75 ec                	jne    80148c <close_all+0x10>
}
  8014a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014a5:	f3 0f 1e fb          	endbr32 
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	57                   	push   %edi
  8014ad:	56                   	push   %esi
  8014ae:	53                   	push   %ebx
  8014af:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014b5:	50                   	push   %eax
  8014b6:	ff 75 08             	pushl  0x8(%ebp)
  8014b9:	e8 54 fe ff ff       	call   801312 <fd_lookup>
  8014be:	89 c3                	mov    %eax,%ebx
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	0f 88 81 00 00 00    	js     80154c <dup+0xa7>
		return r;
	close(newfdnum);
  8014cb:	83 ec 0c             	sub    $0xc,%esp
  8014ce:	ff 75 0c             	pushl  0xc(%ebp)
  8014d1:	e8 75 ff ff ff       	call   80144b <close>

	newfd = INDEX2FD(newfdnum);
  8014d6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014d9:	c1 e6 0c             	shl    $0xc,%esi
  8014dc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014e2:	83 c4 04             	add    $0x4,%esp
  8014e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e8:	e8 b4 fd ff ff       	call   8012a1 <fd2data>
  8014ed:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014ef:	89 34 24             	mov    %esi,(%esp)
  8014f2:	e8 aa fd ff ff       	call   8012a1 <fd2data>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014fc:	89 d8                	mov    %ebx,%eax
  8014fe:	c1 e8 16             	shr    $0x16,%eax
  801501:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801508:	a8 01                	test   $0x1,%al
  80150a:	74 11                	je     80151d <dup+0x78>
  80150c:	89 d8                	mov    %ebx,%eax
  80150e:	c1 e8 0c             	shr    $0xc,%eax
  801511:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801518:	f6 c2 01             	test   $0x1,%dl
  80151b:	75 39                	jne    801556 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80151d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801520:	89 d0                	mov    %edx,%eax
  801522:	c1 e8 0c             	shr    $0xc,%eax
  801525:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	25 07 0e 00 00       	and    $0xe07,%eax
  801534:	50                   	push   %eax
  801535:	56                   	push   %esi
  801536:	6a 00                	push   $0x0
  801538:	52                   	push   %edx
  801539:	6a 00                	push   $0x0
  80153b:	e8 5f f7 ff ff       	call   800c9f <sys_page_map>
  801540:	89 c3                	mov    %eax,%ebx
  801542:	83 c4 20             	add    $0x20,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 31                	js     80157a <dup+0xd5>
		goto err;

	return newfdnum;
  801549:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80154c:	89 d8                	mov    %ebx,%eax
  80154e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801551:	5b                   	pop    %ebx
  801552:	5e                   	pop    %esi
  801553:	5f                   	pop    %edi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801556:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	25 07 0e 00 00       	and    $0xe07,%eax
  801565:	50                   	push   %eax
  801566:	57                   	push   %edi
  801567:	6a 00                	push   $0x0
  801569:	53                   	push   %ebx
  80156a:	6a 00                	push   $0x0
  80156c:	e8 2e f7 ff ff       	call   800c9f <sys_page_map>
  801571:	89 c3                	mov    %eax,%ebx
  801573:	83 c4 20             	add    $0x20,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	79 a3                	jns    80151d <dup+0x78>
	sys_page_unmap(0, newfd);
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	56                   	push   %esi
  80157e:	6a 00                	push   $0x0
  801580:	e8 60 f7 ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801585:	83 c4 08             	add    $0x8,%esp
  801588:	57                   	push   %edi
  801589:	6a 00                	push   $0x0
  80158b:	e8 55 f7 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	eb b7                	jmp    80154c <dup+0xa7>

00801595 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801595:	f3 0f 1e fb          	endbr32 
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	53                   	push   %ebx
  80159d:	83 ec 1c             	sub    $0x1c,%esp
  8015a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	53                   	push   %ebx
  8015a8:	e8 65 fd ff ff       	call   801312 <fd_lookup>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 3f                	js     8015f3 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	ff 30                	pushl  (%eax)
  8015c0:	e8 a1 fd ff ff       	call   801366 <dev_lookup>
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 27                	js     8015f3 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cf:	8b 42 08             	mov    0x8(%edx),%eax
  8015d2:	83 e0 03             	and    $0x3,%eax
  8015d5:	83 f8 01             	cmp    $0x1,%eax
  8015d8:	74 1e                	je     8015f8 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dd:	8b 40 08             	mov    0x8(%eax),%eax
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	74 35                	je     801619 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	ff 75 10             	pushl  0x10(%ebp)
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	52                   	push   %edx
  8015ee:	ff d0                	call   *%eax
  8015f0:	83 c4 10             	add    $0x10,%esp
}
  8015f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f8:	a1 08 40 80 00       	mov    0x804008,%eax
  8015fd:	8b 40 48             	mov    0x48(%eax),%eax
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	53                   	push   %ebx
  801604:	50                   	push   %eax
  801605:	68 cd 28 80 00       	push   $0x8028cd
  80160a:	e8 fd eb ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801617:	eb da                	jmp    8015f3 <read+0x5e>
		return -E_NOT_SUPP;
  801619:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161e:	eb d3                	jmp    8015f3 <read+0x5e>

00801620 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801620:	f3 0f 1e fb          	endbr32 
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	57                   	push   %edi
  801628:	56                   	push   %esi
  801629:	53                   	push   %ebx
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801630:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801633:	bb 00 00 00 00       	mov    $0x0,%ebx
  801638:	eb 02                	jmp    80163c <readn+0x1c>
  80163a:	01 c3                	add    %eax,%ebx
  80163c:	39 f3                	cmp    %esi,%ebx
  80163e:	73 21                	jae    801661 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	89 f0                	mov    %esi,%eax
  801645:	29 d8                	sub    %ebx,%eax
  801647:	50                   	push   %eax
  801648:	89 d8                	mov    %ebx,%eax
  80164a:	03 45 0c             	add    0xc(%ebp),%eax
  80164d:	50                   	push   %eax
  80164e:	57                   	push   %edi
  80164f:	e8 41 ff ff ff       	call   801595 <read>
		if (m < 0)
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 04                	js     80165f <readn+0x3f>
			return m;
		if (m == 0)
  80165b:	75 dd                	jne    80163a <readn+0x1a>
  80165d:	eb 02                	jmp    801661 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80165f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801661:	89 d8                	mov    %ebx,%eax
  801663:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801666:	5b                   	pop    %ebx
  801667:	5e                   	pop    %esi
  801668:	5f                   	pop    %edi
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    

0080166b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80166b:	f3 0f 1e fb          	endbr32 
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	53                   	push   %ebx
  801673:	83 ec 1c             	sub    $0x1c,%esp
  801676:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801679:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	53                   	push   %ebx
  80167e:	e8 8f fc ff ff       	call   801312 <fd_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 3a                	js     8016c4 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80168a:	83 ec 08             	sub    $0x8,%esp
  80168d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801690:	50                   	push   %eax
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	ff 30                	pushl  (%eax)
  801696:	e8 cb fc ff ff       	call   801366 <dev_lookup>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 22                	js     8016c4 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016a9:	74 1e                	je     8016c9 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8016b1:	85 d2                	test   %edx,%edx
  8016b3:	74 35                	je     8016ea <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	ff 75 10             	pushl  0x10(%ebp)
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	50                   	push   %eax
  8016bf:	ff d2                	call   *%edx
  8016c1:	83 c4 10             	add    $0x10,%esp
}
  8016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c9:	a1 08 40 80 00       	mov    0x804008,%eax
  8016ce:	8b 40 48             	mov    0x48(%eax),%eax
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	53                   	push   %ebx
  8016d5:	50                   	push   %eax
  8016d6:	68 e9 28 80 00       	push   $0x8028e9
  8016db:	e8 2c eb ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e8:	eb da                	jmp    8016c4 <write+0x59>
		return -E_NOT_SUPP;
  8016ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ef:	eb d3                	jmp    8016c4 <write+0x59>

008016f1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016f1:	f3 0f 1e fb          	endbr32 
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fe:	50                   	push   %eax
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	e8 0b fc ff ff       	call   801312 <fd_lookup>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 0e                	js     80171c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80170e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801714:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80171e:	f3 0f 1e fb          	endbr32 
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	53                   	push   %ebx
  801726:	83 ec 1c             	sub    $0x1c,%esp
  801729:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80172f:	50                   	push   %eax
  801730:	53                   	push   %ebx
  801731:	e8 dc fb ff ff       	call   801312 <fd_lookup>
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 37                	js     801774 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173d:	83 ec 08             	sub    $0x8,%esp
  801740:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	ff 30                	pushl  (%eax)
  801749:	e8 18 fc ff ff       	call   801366 <dev_lookup>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	78 1f                	js     801774 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80175c:	74 1b                	je     801779 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80175e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801761:	8b 52 18             	mov    0x18(%edx),%edx
  801764:	85 d2                	test   %edx,%edx
  801766:	74 32                	je     80179a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801768:	83 ec 08             	sub    $0x8,%esp
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	50                   	push   %eax
  80176f:	ff d2                	call   *%edx
  801771:	83 c4 10             	add    $0x10,%esp
}
  801774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801777:	c9                   	leave  
  801778:	c3                   	ret    
			thisenv->env_id, fdnum);
  801779:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80177e:	8b 40 48             	mov    0x48(%eax),%eax
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	53                   	push   %ebx
  801785:	50                   	push   %eax
  801786:	68 ac 28 80 00       	push   $0x8028ac
  80178b:	e8 7c ea ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801798:	eb da                	jmp    801774 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80179a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179f:	eb d3                	jmp    801774 <ftruncate+0x56>

008017a1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017a1:	f3 0f 1e fb          	endbr32 
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 1c             	sub    $0x1c,%esp
  8017ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b2:	50                   	push   %eax
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	e8 57 fb ff ff       	call   801312 <fd_lookup>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 4b                	js     80180d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c8:	50                   	push   %eax
  8017c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cc:	ff 30                	pushl  (%eax)
  8017ce:	e8 93 fb ff ff       	call   801366 <dev_lookup>
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 33                	js     80180d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017dd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017e1:	74 2f                	je     801812 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017e3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017e6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017ed:	00 00 00 
	stat->st_isdir = 0;
  8017f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017f7:	00 00 00 
	stat->st_dev = dev;
  8017fa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	53                   	push   %ebx
  801804:	ff 75 f0             	pushl  -0x10(%ebp)
  801807:	ff 50 14             	call   *0x14(%eax)
  80180a:	83 c4 10             	add    $0x10,%esp
}
  80180d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801810:	c9                   	leave  
  801811:	c3                   	ret    
		return -E_NOT_SUPP;
  801812:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801817:	eb f4                	jmp    80180d <fstat+0x6c>

00801819 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801819:	f3 0f 1e fb          	endbr32 
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	6a 00                	push   $0x0
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	e8 fb 01 00 00       	call   801a2a <open>
  80182f:	89 c3                	mov    %eax,%ebx
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	78 1b                	js     801853 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	50                   	push   %eax
  80183f:	e8 5d ff ff ff       	call   8017a1 <fstat>
  801844:	89 c6                	mov    %eax,%esi
	close(fd);
  801846:	89 1c 24             	mov    %ebx,(%esp)
  801849:	e8 fd fb ff ff       	call   80144b <close>
	return r;
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	89 f3                	mov    %esi,%ebx
}
  801853:	89 d8                	mov    %ebx,%eax
  801855:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	56                   	push   %esi
  801860:	53                   	push   %ebx
  801861:	89 c6                	mov    %eax,%esi
  801863:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801865:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80186c:	74 27                	je     801895 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80186e:	6a 07                	push   $0x7
  801870:	68 00 50 80 00       	push   $0x805000
  801875:	56                   	push   %esi
  801876:	ff 35 00 40 80 00    	pushl  0x804000
  80187c:	e8 75 f9 ff ff       	call   8011f6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801881:	83 c4 0c             	add    $0xc,%esp
  801884:	6a 00                	push   $0x0
  801886:	53                   	push   %ebx
  801887:	6a 00                	push   $0x0
  801889:	e8 fb f8 ff ff       	call   801189 <ipc_recv>
}
  80188e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	6a 01                	push   $0x1
  80189a:	e8 b1 f9 ff ff       	call   801250 <ipc_find_env>
  80189f:	a3 00 40 80 00       	mov    %eax,0x804000
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	eb c5                	jmp    80186e <fsipc+0x12>

008018a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018a9:	f3 0f 1e fb          	endbr32 
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8018d0:	e8 87 ff ff ff       	call   80185c <fsipc>
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <devfile_flush>:
{
  8018d7:	f3 0f 1e fb          	endbr32 
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f1:	b8 06 00 00 00       	mov    $0x6,%eax
  8018f6:	e8 61 ff ff ff       	call   80185c <fsipc>
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <devfile_stat>:
{
  8018fd:	f3 0f 1e fb          	endbr32 
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	53                   	push   %ebx
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8b 40 0c             	mov    0xc(%eax),%eax
  801911:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801916:	ba 00 00 00 00       	mov    $0x0,%edx
  80191b:	b8 05 00 00 00       	mov    $0x5,%eax
  801920:	e8 37 ff ff ff       	call   80185c <fsipc>
  801925:	85 c0                	test   %eax,%eax
  801927:	78 2c                	js     801955 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	68 00 50 80 00       	push   $0x805000
  801931:	53                   	push   %ebx
  801932:	e8 df ee ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801937:	a1 80 50 80 00       	mov    0x805080,%eax
  80193c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801942:	a1 84 50 80 00       	mov    0x805084,%eax
  801947:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <devfile_write>:
{
  80195a:	f3 0f 1e fb          	endbr32 
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 0c             	sub    $0xc,%esp
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80196c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801971:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801974:	8b 55 08             	mov    0x8(%ebp),%edx
  801977:	8b 52 0c             	mov    0xc(%edx),%edx
  80197a:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801980:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801985:	50                   	push   %eax
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	68 08 50 80 00       	push   $0x805008
  80198e:	e8 39 f0 ff ff       	call   8009cc <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801993:	ba 00 00 00 00       	mov    $0x0,%edx
  801998:	b8 04 00 00 00       	mov    $0x4,%eax
  80199d:	e8 ba fe ff ff       	call   80185c <fsipc>
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <devfile_read>:
{
  8019a4:	f3 0f 1e fb          	endbr32 
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	56                   	push   %esi
  8019ac:	53                   	push   %ebx
  8019ad:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019bb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8019cb:	e8 8c fe ff ff       	call   80185c <fsipc>
  8019d0:	89 c3                	mov    %eax,%ebx
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	78 1f                	js     8019f5 <devfile_read+0x51>
	assert(r <= n);
  8019d6:	39 f0                	cmp    %esi,%eax
  8019d8:	77 24                	ja     8019fe <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019da:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019df:	7f 33                	jg     801a14 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	50                   	push   %eax
  8019e5:	68 00 50 80 00       	push   $0x805000
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	e8 da ef ff ff       	call   8009cc <memmove>
	return r;
  8019f2:	83 c4 10             	add    $0x10,%esp
}
  8019f5:	89 d8                	mov    %ebx,%eax
  8019f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
	assert(r <= n);
  8019fe:	68 18 29 80 00       	push   $0x802918
  801a03:	68 1f 29 80 00       	push   $0x80291f
  801a08:	6a 7d                	push   $0x7d
  801a0a:	68 34 29 80 00       	push   $0x802934
  801a0f:	e8 be 05 00 00       	call   801fd2 <_panic>
	assert(r <= PGSIZE);
  801a14:	68 3f 29 80 00       	push   $0x80293f
  801a19:	68 1f 29 80 00       	push   $0x80291f
  801a1e:	6a 7e                	push   $0x7e
  801a20:	68 34 29 80 00       	push   $0x802934
  801a25:	e8 a8 05 00 00       	call   801fd2 <_panic>

00801a2a <open>:
{
  801a2a:	f3 0f 1e fb          	endbr32 
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
  801a33:	83 ec 1c             	sub    $0x1c,%esp
  801a36:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a39:	56                   	push   %esi
  801a3a:	e8 94 ed ff ff       	call   8007d3 <strlen>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a47:	7f 6c                	jg     801ab5 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a49:	83 ec 0c             	sub    $0xc,%esp
  801a4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4f:	50                   	push   %eax
  801a50:	e8 67 f8 ff ff       	call   8012bc <fd_alloc>
  801a55:	89 c3                	mov    %eax,%ebx
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 3c                	js     801a9a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	56                   	push   %esi
  801a62:	68 00 50 80 00       	push   $0x805000
  801a67:	e8 aa ed ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a77:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7c:	e8 db fd ff ff       	call   80185c <fsipc>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 19                	js     801aa3 <open+0x79>
	return fd2num(fd);
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a90:	e8 f8 f7 ff ff       	call   80128d <fd2num>
  801a95:	89 c3                	mov    %eax,%ebx
  801a97:	83 c4 10             	add    $0x10,%esp
}
  801a9a:	89 d8                	mov    %ebx,%eax
  801a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    
		fd_close(fd, 0);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801aab:	e8 10 f9 ff ff       	call   8013c0 <fd_close>
		return r;
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	eb e5                	jmp    801a9a <open+0x70>
		return -E_BAD_PATH;
  801ab5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aba:	eb de                	jmp    801a9a <open+0x70>

00801abc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801abc:	f3 0f 1e fb          	endbr32 
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ac6:	ba 00 00 00 00       	mov    $0x0,%edx
  801acb:	b8 08 00 00 00       	mov    $0x8,%eax
  801ad0:	e8 87 fd ff ff       	call   80185c <fsipc>
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ad7:	f3 0f 1e fb          	endbr32 
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	e8 b3 f7 ff ff       	call   8012a1 <fd2data>
  801aee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	68 4b 29 80 00       	push   $0x80294b
  801af8:	53                   	push   %ebx
  801af9:	e8 18 ed ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801afe:	8b 46 04             	mov    0x4(%esi),%eax
  801b01:	2b 06                	sub    (%esi),%eax
  801b03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b09:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b10:	00 00 00 
	stat->st_dev = &devpipe;
  801b13:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b1a:	30 80 00 
	return 0;
}
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b25:	5b                   	pop    %ebx
  801b26:	5e                   	pop    %esi
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    

00801b29 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b29:	f3 0f 1e fb          	endbr32 
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	53                   	push   %ebx
  801b31:	83 ec 0c             	sub    $0xc,%esp
  801b34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b37:	53                   	push   %ebx
  801b38:	6a 00                	push   $0x0
  801b3a:	e8 a6 f1 ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b3f:	89 1c 24             	mov    %ebx,(%esp)
  801b42:	e8 5a f7 ff ff       	call   8012a1 <fd2data>
  801b47:	83 c4 08             	add    $0x8,%esp
  801b4a:	50                   	push   %eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	e8 93 f1 ff ff       	call   800ce5 <sys_page_unmap>
}
  801b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <_pipeisclosed>:
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	57                   	push   %edi
  801b5b:	56                   	push   %esi
  801b5c:	53                   	push   %ebx
  801b5d:	83 ec 1c             	sub    $0x1c,%esp
  801b60:	89 c7                	mov    %eax,%edi
  801b62:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b64:	a1 08 40 80 00       	mov    0x804008,%eax
  801b69:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b6c:	83 ec 0c             	sub    $0xc,%esp
  801b6f:	57                   	push   %edi
  801b70:	e8 47 05 00 00       	call   8020bc <pageref>
  801b75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b78:	89 34 24             	mov    %esi,(%esp)
  801b7b:	e8 3c 05 00 00       	call   8020bc <pageref>
		nn = thisenv->env_runs;
  801b80:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b86:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	39 cb                	cmp    %ecx,%ebx
  801b8e:	74 1b                	je     801bab <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b90:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b93:	75 cf                	jne    801b64 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b95:	8b 42 58             	mov    0x58(%edx),%eax
  801b98:	6a 01                	push   $0x1
  801b9a:	50                   	push   %eax
  801b9b:	53                   	push   %ebx
  801b9c:	68 52 29 80 00       	push   $0x802952
  801ba1:	e8 66 e6 ff ff       	call   80020c <cprintf>
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	eb b9                	jmp    801b64 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bae:	0f 94 c0             	sete   %al
  801bb1:	0f b6 c0             	movzbl %al,%eax
}
  801bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    

00801bbc <devpipe_write>:
{
  801bbc:	f3 0f 1e fb          	endbr32 
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	57                   	push   %edi
  801bc4:	56                   	push   %esi
  801bc5:	53                   	push   %ebx
  801bc6:	83 ec 28             	sub    $0x28,%esp
  801bc9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bcc:	56                   	push   %esi
  801bcd:	e8 cf f6 ff ff       	call   8012a1 <fd2data>
  801bd2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bdf:	74 4f                	je     801c30 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801be1:	8b 43 04             	mov    0x4(%ebx),%eax
  801be4:	8b 0b                	mov    (%ebx),%ecx
  801be6:	8d 51 20             	lea    0x20(%ecx),%edx
  801be9:	39 d0                	cmp    %edx,%eax
  801beb:	72 14                	jb     801c01 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bed:	89 da                	mov    %ebx,%edx
  801bef:	89 f0                	mov    %esi,%eax
  801bf1:	e8 61 ff ff ff       	call   801b57 <_pipeisclosed>
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	75 3b                	jne    801c35 <devpipe_write+0x79>
			sys_yield();
  801bfa:	e8 36 f0 ff ff       	call   800c35 <sys_yield>
  801bff:	eb e0                	jmp    801be1 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c04:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c08:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c0b:	89 c2                	mov    %eax,%edx
  801c0d:	c1 fa 1f             	sar    $0x1f,%edx
  801c10:	89 d1                	mov    %edx,%ecx
  801c12:	c1 e9 1b             	shr    $0x1b,%ecx
  801c15:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c18:	83 e2 1f             	and    $0x1f,%edx
  801c1b:	29 ca                	sub    %ecx,%edx
  801c1d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c21:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c25:	83 c0 01             	add    $0x1,%eax
  801c28:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c2b:	83 c7 01             	add    $0x1,%edi
  801c2e:	eb ac                	jmp    801bdc <devpipe_write+0x20>
	return i;
  801c30:	8b 45 10             	mov    0x10(%ebp),%eax
  801c33:	eb 05                	jmp    801c3a <devpipe_write+0x7e>
				return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    

00801c42 <devpipe_read>:
{
  801c42:	f3 0f 1e fb          	endbr32 
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	57                   	push   %edi
  801c4a:	56                   	push   %esi
  801c4b:	53                   	push   %ebx
  801c4c:	83 ec 18             	sub    $0x18,%esp
  801c4f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c52:	57                   	push   %edi
  801c53:	e8 49 f6 ff ff       	call   8012a1 <fd2data>
  801c58:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	be 00 00 00 00       	mov    $0x0,%esi
  801c62:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c65:	75 14                	jne    801c7b <devpipe_read+0x39>
	return i;
  801c67:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6a:	eb 02                	jmp    801c6e <devpipe_read+0x2c>
				return i;
  801c6c:	89 f0                	mov    %esi,%eax
}
  801c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c71:	5b                   	pop    %ebx
  801c72:	5e                   	pop    %esi
  801c73:	5f                   	pop    %edi
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    
			sys_yield();
  801c76:	e8 ba ef ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c7b:	8b 03                	mov    (%ebx),%eax
  801c7d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c80:	75 18                	jne    801c9a <devpipe_read+0x58>
			if (i > 0)
  801c82:	85 f6                	test   %esi,%esi
  801c84:	75 e6                	jne    801c6c <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c86:	89 da                	mov    %ebx,%edx
  801c88:	89 f8                	mov    %edi,%eax
  801c8a:	e8 c8 fe ff ff       	call   801b57 <_pipeisclosed>
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	74 e3                	je     801c76 <devpipe_read+0x34>
				return 0;
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	eb d4                	jmp    801c6e <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c9a:	99                   	cltd   
  801c9b:	c1 ea 1b             	shr    $0x1b,%edx
  801c9e:	01 d0                	add    %edx,%eax
  801ca0:	83 e0 1f             	and    $0x1f,%eax
  801ca3:	29 d0                	sub    %edx,%eax
  801ca5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cad:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cb0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cb3:	83 c6 01             	add    $0x1,%esi
  801cb6:	eb aa                	jmp    801c62 <devpipe_read+0x20>

00801cb8 <pipe>:
{
  801cb8:	f3 0f 1e fb          	endbr32 
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc7:	50                   	push   %eax
  801cc8:	e8 ef f5 ff ff       	call   8012bc <fd_alloc>
  801ccd:	89 c3                	mov    %eax,%ebx
  801ccf:	83 c4 10             	add    $0x10,%esp
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	0f 88 23 01 00 00    	js     801dfd <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cda:	83 ec 04             	sub    $0x4,%esp
  801cdd:	68 07 04 00 00       	push   $0x407
  801ce2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce5:	6a 00                	push   $0x0
  801ce7:	e8 6c ef ff ff       	call   800c58 <sys_page_alloc>
  801cec:	89 c3                	mov    %eax,%ebx
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	0f 88 04 01 00 00    	js     801dfd <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cff:	50                   	push   %eax
  801d00:	e8 b7 f5 ff ff       	call   8012bc <fd_alloc>
  801d05:	89 c3                	mov    %eax,%ebx
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	0f 88 db 00 00 00    	js     801ded <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	68 07 04 00 00       	push   $0x407
  801d1a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 34 ef ff ff       	call   800c58 <sys_page_alloc>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	0f 88 bc 00 00 00    	js     801ded <pipe+0x135>
	va = fd2data(fd0);
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	ff 75 f4             	pushl  -0xc(%ebp)
  801d37:	e8 65 f5 ff ff       	call   8012a1 <fd2data>
  801d3c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d3e:	83 c4 0c             	add    $0xc,%esp
  801d41:	68 07 04 00 00       	push   $0x407
  801d46:	50                   	push   %eax
  801d47:	6a 00                	push   $0x0
  801d49:	e8 0a ef ff ff       	call   800c58 <sys_page_alloc>
  801d4e:	89 c3                	mov    %eax,%ebx
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	85 c0                	test   %eax,%eax
  801d55:	0f 88 82 00 00 00    	js     801ddd <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5b:	83 ec 0c             	sub    $0xc,%esp
  801d5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d61:	e8 3b f5 ff ff       	call   8012a1 <fd2data>
  801d66:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d6d:	50                   	push   %eax
  801d6e:	6a 00                	push   $0x0
  801d70:	56                   	push   %esi
  801d71:	6a 00                	push   $0x0
  801d73:	e8 27 ef ff ff       	call   800c9f <sys_page_map>
  801d78:	89 c3                	mov    %eax,%ebx
  801d7a:	83 c4 20             	add    $0x20,%esp
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	78 4e                	js     801dcf <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d81:	a1 20 30 80 00       	mov    0x803020,%eax
  801d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d89:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d98:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	ff 75 f4             	pushl  -0xc(%ebp)
  801daa:	e8 de f4 ff ff       	call   80128d <fd2num>
  801daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801db4:	83 c4 04             	add    $0x4,%esp
  801db7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dba:	e8 ce f4 ff ff       	call   80128d <fd2num>
  801dbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dcd:	eb 2e                	jmp    801dfd <pipe+0x145>
	sys_page_unmap(0, va);
  801dcf:	83 ec 08             	sub    $0x8,%esp
  801dd2:	56                   	push   %esi
  801dd3:	6a 00                	push   $0x0
  801dd5:	e8 0b ef ff ff       	call   800ce5 <sys_page_unmap>
  801dda:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ddd:	83 ec 08             	sub    $0x8,%esp
  801de0:	ff 75 f0             	pushl  -0x10(%ebp)
  801de3:	6a 00                	push   $0x0
  801de5:	e8 fb ee ff ff       	call   800ce5 <sys_page_unmap>
  801dea:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	ff 75 f4             	pushl  -0xc(%ebp)
  801df3:	6a 00                	push   $0x0
  801df5:	e8 eb ee ff ff       	call   800ce5 <sys_page_unmap>
  801dfa:	83 c4 10             	add    $0x10,%esp
}
  801dfd:	89 d8                	mov    %ebx,%eax
  801dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e02:	5b                   	pop    %ebx
  801e03:	5e                   	pop    %esi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    

00801e06 <pipeisclosed>:
{
  801e06:	f3 0f 1e fb          	endbr32 
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e13:	50                   	push   %eax
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	e8 f6 f4 ff ff       	call   801312 <fd_lookup>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 18                	js     801e3b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	ff 75 f4             	pushl  -0xc(%ebp)
  801e29:	e8 73 f4 ff ff       	call   8012a1 <fd2data>
  801e2e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	e8 1f fd ff ff       	call   801b57 <_pipeisclosed>
  801e38:	83 c4 10             	add    $0x10,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e3d:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
  801e46:	c3                   	ret    

00801e47 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e47:	f3 0f 1e fb          	endbr32 
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e51:	68 6a 29 80 00       	push   $0x80296a
  801e56:	ff 75 0c             	pushl  0xc(%ebp)
  801e59:	e8 b8 e9 ff ff       	call   800816 <strcpy>
	return 0;
}
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <devcons_write>:
{
  801e65:	f3 0f 1e fb          	endbr32 
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	57                   	push   %edi
  801e6d:	56                   	push   %esi
  801e6e:	53                   	push   %ebx
  801e6f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e75:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e7a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e80:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e83:	73 31                	jae    801eb6 <devcons_write+0x51>
		m = n - tot;
  801e85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e88:	29 f3                	sub    %esi,%ebx
  801e8a:	83 fb 7f             	cmp    $0x7f,%ebx
  801e8d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e92:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	53                   	push   %ebx
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	03 45 0c             	add    0xc(%ebp),%eax
  801e9e:	50                   	push   %eax
  801e9f:	57                   	push   %edi
  801ea0:	e8 27 eb ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  801ea5:	83 c4 08             	add    $0x8,%esp
  801ea8:	53                   	push   %ebx
  801ea9:	57                   	push   %edi
  801eaa:	e8 d9 ec ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801eaf:	01 de                	add    %ebx,%esi
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	eb ca                	jmp    801e80 <devcons_write+0x1b>
}
  801eb6:	89 f0                	mov    %esi,%eax
  801eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5f                   	pop    %edi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <devcons_read>:
{
  801ec0:	f3 0f 1e fb          	endbr32 
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 08             	sub    $0x8,%esp
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed3:	74 21                	je     801ef6 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801ed5:	e8 d0 ec ff ff       	call   800baa <sys_cgetc>
  801eda:	85 c0                	test   %eax,%eax
  801edc:	75 07                	jne    801ee5 <devcons_read+0x25>
		sys_yield();
  801ede:	e8 52 ed ff ff       	call   800c35 <sys_yield>
  801ee3:	eb f0                	jmp    801ed5 <devcons_read+0x15>
	if (c < 0)
  801ee5:	78 0f                	js     801ef6 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801ee7:	83 f8 04             	cmp    $0x4,%eax
  801eea:	74 0c                	je     801ef8 <devcons_read+0x38>
	*(char*)vbuf = c;
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	88 02                	mov    %al,(%edx)
	return 1;
  801ef1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    
		return 0;
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	eb f7                	jmp    801ef6 <devcons_read+0x36>

00801eff <cputchar>:
{
  801eff:	f3 0f 1e fb          	endbr32 
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f0f:	6a 01                	push   $0x1
  801f11:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f14:	50                   	push   %eax
  801f15:	e8 6e ec ff ff       	call   800b88 <sys_cputs>
}
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <getchar>:
{
  801f1f:	f3 0f 1e fb          	endbr32 
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f29:	6a 01                	push   $0x1
  801f2b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f2e:	50                   	push   %eax
  801f2f:	6a 00                	push   $0x0
  801f31:	e8 5f f6 ff ff       	call   801595 <read>
	if (r < 0)
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	78 06                	js     801f43 <getchar+0x24>
	if (r < 1)
  801f3d:	74 06                	je     801f45 <getchar+0x26>
	return c;
  801f3f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    
		return -E_EOF;
  801f45:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f4a:	eb f7                	jmp    801f43 <getchar+0x24>

00801f4c <iscons>:
{
  801f4c:	f3 0f 1e fb          	endbr32 
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f59:	50                   	push   %eax
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	e8 b0 f3 ff ff       	call   801312 <fd_lookup>
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 11                	js     801f7a <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f72:	39 10                	cmp    %edx,(%eax)
  801f74:	0f 94 c0             	sete   %al
  801f77:	0f b6 c0             	movzbl %al,%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <opencons>:
{
  801f7c:	f3 0f 1e fb          	endbr32 
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	50                   	push   %eax
  801f8a:	e8 2d f3 ff ff       	call   8012bc <fd_alloc>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 3a                	js     801fd0 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 07 04 00 00       	push   $0x407
  801f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 b0 ec ff ff       	call   800c58 <sys_page_alloc>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 21                	js     801fd0 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fb8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	50                   	push   %eax
  801fc8:	e8 c0 f2 ff ff       	call   80128d <fd2num>
  801fcd:	83 c4 10             	add    $0x10,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fd2:	f3 0f 1e fb          	endbr32 
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	56                   	push   %esi
  801fda:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801fdb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801fde:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801fe4:	e8 29 ec ff ff       	call   800c12 <sys_getenvid>
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	56                   	push   %esi
  801ff3:	50                   	push   %eax
  801ff4:	68 78 29 80 00       	push   $0x802978
  801ff9:	e8 0e e2 ff ff       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ffe:	83 c4 18             	add    $0x18,%esp
  802001:	53                   	push   %ebx
  802002:	ff 75 10             	pushl  0x10(%ebp)
  802005:	e8 ad e1 ff ff       	call   8001b7 <vcprintf>
	cprintf("\n");
  80200a:	c7 04 24 63 29 80 00 	movl   $0x802963,(%esp)
  802011:	e8 f6 e1 ff ff       	call   80020c <cprintf>
  802016:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802019:	cc                   	int3   
  80201a:	eb fd                	jmp    802019 <_panic+0x47>

0080201c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80201c:	f3 0f 1e fb          	endbr32 
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	53                   	push   %ebx
  802024:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802027:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80202e:	74 0d                	je     80203d <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802038:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    
		envid_t envid=sys_getenvid();
  80203d:	e8 d0 eb ff ff       	call   800c12 <sys_getenvid>
  802042:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  802044:	83 ec 04             	sub    $0x4,%esp
  802047:	6a 07                	push   $0x7
  802049:	68 00 f0 bf ee       	push   $0xeebff000
  80204e:	50                   	push   %eax
  80204f:	e8 04 ec ff ff       	call   800c58 <sys_page_alloc>
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	85 c0                	test   %eax,%eax
  802059:	78 29                	js     802084 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  80205b:	83 ec 08             	sub    $0x8,%esp
  80205e:	68 98 20 80 00       	push   $0x802098
  802063:	53                   	push   %ebx
  802064:	e8 4e ed ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	85 c0                	test   %eax,%eax
  80206e:	79 c0                	jns    802030 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	68 c8 29 80 00       	push   $0x8029c8
  802078:	6a 24                	push   $0x24
  80207a:	68 ff 29 80 00       	push   $0x8029ff
  80207f:	e8 4e ff ff ff       	call   801fd2 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	68 9c 29 80 00       	push   $0x80299c
  80208c:	6a 22                	push   $0x22
  80208e:	68 ff 29 80 00       	push   $0x8029ff
  802093:	e8 3a ff ff ff       	call   801fd2 <_panic>

00802098 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802098:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802099:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80209e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020a0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8020a3:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8020a6:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8020aa:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8020af:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8020b3:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8020b5:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8020b6:	83 c4 04             	add    $0x4,%esp
	popfl
  8020b9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020ba:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8020bb:	c3                   	ret    

008020bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020bc:	f3 0f 1e fb          	endbr32 
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020c6:	89 c2                	mov    %eax,%edx
  8020c8:	c1 ea 16             	shr    $0x16,%edx
  8020cb:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020d2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020d7:	f6 c1 01             	test   $0x1,%cl
  8020da:	74 1c                	je     8020f8 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020dc:	c1 e8 0c             	shr    $0xc,%eax
  8020df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020e6:	a8 01                	test   $0x1,%al
  8020e8:	74 0e                	je     8020f8 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ea:	c1 e8 0c             	shr    $0xc,%eax
  8020ed:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020f4:	ef 
  8020f5:	0f b7 d2             	movzwl %dx,%edx
}
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <__udivdi3>:
  802100:	f3 0f 1e fb          	endbr32 
  802104:	55                   	push   %ebp
  802105:	57                   	push   %edi
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
  802108:	83 ec 1c             	sub    $0x1c,%esp
  80210b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80210f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802113:	8b 74 24 34          	mov    0x34(%esp),%esi
  802117:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80211b:	85 d2                	test   %edx,%edx
  80211d:	75 19                	jne    802138 <__udivdi3+0x38>
  80211f:	39 f3                	cmp    %esi,%ebx
  802121:	76 4d                	jbe    802170 <__udivdi3+0x70>
  802123:	31 ff                	xor    %edi,%edi
  802125:	89 e8                	mov    %ebp,%eax
  802127:	89 f2                	mov    %esi,%edx
  802129:	f7 f3                	div    %ebx
  80212b:	89 fa                	mov    %edi,%edx
  80212d:	83 c4 1c             	add    $0x1c,%esp
  802130:	5b                   	pop    %ebx
  802131:	5e                   	pop    %esi
  802132:	5f                   	pop    %edi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    
  802135:	8d 76 00             	lea    0x0(%esi),%esi
  802138:	39 f2                	cmp    %esi,%edx
  80213a:	76 14                	jbe    802150 <__udivdi3+0x50>
  80213c:	31 ff                	xor    %edi,%edi
  80213e:	31 c0                	xor    %eax,%eax
  802140:	89 fa                	mov    %edi,%edx
  802142:	83 c4 1c             	add    $0x1c,%esp
  802145:	5b                   	pop    %ebx
  802146:	5e                   	pop    %esi
  802147:	5f                   	pop    %edi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    
  80214a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802150:	0f bd fa             	bsr    %edx,%edi
  802153:	83 f7 1f             	xor    $0x1f,%edi
  802156:	75 48                	jne    8021a0 <__udivdi3+0xa0>
  802158:	39 f2                	cmp    %esi,%edx
  80215a:	72 06                	jb     802162 <__udivdi3+0x62>
  80215c:	31 c0                	xor    %eax,%eax
  80215e:	39 eb                	cmp    %ebp,%ebx
  802160:	77 de                	ja     802140 <__udivdi3+0x40>
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	eb d7                	jmp    802140 <__udivdi3+0x40>
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 d9                	mov    %ebx,%ecx
  802172:	85 db                	test   %ebx,%ebx
  802174:	75 0b                	jne    802181 <__udivdi3+0x81>
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f3                	div    %ebx
  80217f:	89 c1                	mov    %eax,%ecx
  802181:	31 d2                	xor    %edx,%edx
  802183:	89 f0                	mov    %esi,%eax
  802185:	f7 f1                	div    %ecx
  802187:	89 c6                	mov    %eax,%esi
  802189:	89 e8                	mov    %ebp,%eax
  80218b:	89 f7                	mov    %esi,%edi
  80218d:	f7 f1                	div    %ecx
  80218f:	89 fa                	mov    %edi,%edx
  802191:	83 c4 1c             	add    $0x1c,%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    
  802199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	89 f9                	mov    %edi,%ecx
  8021a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021a7:	29 f8                	sub    %edi,%eax
  8021a9:	d3 e2                	shl    %cl,%edx
  8021ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021af:	89 c1                	mov    %eax,%ecx
  8021b1:	89 da                	mov    %ebx,%edx
  8021b3:	d3 ea                	shr    %cl,%edx
  8021b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021b9:	09 d1                	or     %edx,%ecx
  8021bb:	89 f2                	mov    %esi,%edx
  8021bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021c1:	89 f9                	mov    %edi,%ecx
  8021c3:	d3 e3                	shl    %cl,%ebx
  8021c5:	89 c1                	mov    %eax,%ecx
  8021c7:	d3 ea                	shr    %cl,%edx
  8021c9:	89 f9                	mov    %edi,%ecx
  8021cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021cf:	89 eb                	mov    %ebp,%ebx
  8021d1:	d3 e6                	shl    %cl,%esi
  8021d3:	89 c1                	mov    %eax,%ecx
  8021d5:	d3 eb                	shr    %cl,%ebx
  8021d7:	09 de                	or     %ebx,%esi
  8021d9:	89 f0                	mov    %esi,%eax
  8021db:	f7 74 24 08          	divl   0x8(%esp)
  8021df:	89 d6                	mov    %edx,%esi
  8021e1:	89 c3                	mov    %eax,%ebx
  8021e3:	f7 64 24 0c          	mull   0xc(%esp)
  8021e7:	39 d6                	cmp    %edx,%esi
  8021e9:	72 15                	jb     802200 <__udivdi3+0x100>
  8021eb:	89 f9                	mov    %edi,%ecx
  8021ed:	d3 e5                	shl    %cl,%ebp
  8021ef:	39 c5                	cmp    %eax,%ebp
  8021f1:	73 04                	jae    8021f7 <__udivdi3+0xf7>
  8021f3:	39 d6                	cmp    %edx,%esi
  8021f5:	74 09                	je     802200 <__udivdi3+0x100>
  8021f7:	89 d8                	mov    %ebx,%eax
  8021f9:	31 ff                	xor    %edi,%edi
  8021fb:	e9 40 ff ff ff       	jmp    802140 <__udivdi3+0x40>
  802200:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802203:	31 ff                	xor    %edi,%edi
  802205:	e9 36 ff ff ff       	jmp    802140 <__udivdi3+0x40>
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__umoddi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80221f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802223:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802227:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80222b:	85 c0                	test   %eax,%eax
  80222d:	75 19                	jne    802248 <__umoddi3+0x38>
  80222f:	39 df                	cmp    %ebx,%edi
  802231:	76 5d                	jbe    802290 <__umoddi3+0x80>
  802233:	89 f0                	mov    %esi,%eax
  802235:	89 da                	mov    %ebx,%edx
  802237:	f7 f7                	div    %edi
  802239:	89 d0                	mov    %edx,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	89 f2                	mov    %esi,%edx
  80224a:	39 d8                	cmp    %ebx,%eax
  80224c:	76 12                	jbe    802260 <__umoddi3+0x50>
  80224e:	89 f0                	mov    %esi,%eax
  802250:	89 da                	mov    %ebx,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802260:	0f bd e8             	bsr    %eax,%ebp
  802263:	83 f5 1f             	xor    $0x1f,%ebp
  802266:	75 50                	jne    8022b8 <__umoddi3+0xa8>
  802268:	39 d8                	cmp    %ebx,%eax
  80226a:	0f 82 e0 00 00 00    	jb     802350 <__umoddi3+0x140>
  802270:	89 d9                	mov    %ebx,%ecx
  802272:	39 f7                	cmp    %esi,%edi
  802274:	0f 86 d6 00 00 00    	jbe    802350 <__umoddi3+0x140>
  80227a:	89 d0                	mov    %edx,%eax
  80227c:	89 ca                	mov    %ecx,%edx
  80227e:	83 c4 1c             	add    $0x1c,%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5f                   	pop    %edi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    
  802286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80228d:	8d 76 00             	lea    0x0(%esi),%esi
  802290:	89 fd                	mov    %edi,%ebp
  802292:	85 ff                	test   %edi,%edi
  802294:	75 0b                	jne    8022a1 <__umoddi3+0x91>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f7                	div    %edi
  80229f:	89 c5                	mov    %eax,%ebp
  8022a1:	89 d8                	mov    %ebx,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	f7 f5                	div    %ebp
  8022a7:	89 f0                	mov    %esi,%eax
  8022a9:	f7 f5                	div    %ebp
  8022ab:	89 d0                	mov    %edx,%eax
  8022ad:	31 d2                	xor    %edx,%edx
  8022af:	eb 8c                	jmp    80223d <__umoddi3+0x2d>
  8022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	89 e9                	mov    %ebp,%ecx
  8022ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8022bf:	29 ea                	sub    %ebp,%edx
  8022c1:	d3 e0                	shl    %cl,%eax
  8022c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022c7:	89 d1                	mov    %edx,%ecx
  8022c9:	89 f8                	mov    %edi,%eax
  8022cb:	d3 e8                	shr    %cl,%eax
  8022cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022d9:	09 c1                	or     %eax,%ecx
  8022db:	89 d8                	mov    %ebx,%eax
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 e9                	mov    %ebp,%ecx
  8022e3:	d3 e7                	shl    %cl,%edi
  8022e5:	89 d1                	mov    %edx,%ecx
  8022e7:	d3 e8                	shr    %cl,%eax
  8022e9:	89 e9                	mov    %ebp,%ecx
  8022eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022ef:	d3 e3                	shl    %cl,%ebx
  8022f1:	89 c7                	mov    %eax,%edi
  8022f3:	89 d1                	mov    %edx,%ecx
  8022f5:	89 f0                	mov    %esi,%eax
  8022f7:	d3 e8                	shr    %cl,%eax
  8022f9:	89 e9                	mov    %ebp,%ecx
  8022fb:	89 fa                	mov    %edi,%edx
  8022fd:	d3 e6                	shl    %cl,%esi
  8022ff:	09 d8                	or     %ebx,%eax
  802301:	f7 74 24 08          	divl   0x8(%esp)
  802305:	89 d1                	mov    %edx,%ecx
  802307:	89 f3                	mov    %esi,%ebx
  802309:	f7 64 24 0c          	mull   0xc(%esp)
  80230d:	89 c6                	mov    %eax,%esi
  80230f:	89 d7                	mov    %edx,%edi
  802311:	39 d1                	cmp    %edx,%ecx
  802313:	72 06                	jb     80231b <__umoddi3+0x10b>
  802315:	75 10                	jne    802327 <__umoddi3+0x117>
  802317:	39 c3                	cmp    %eax,%ebx
  802319:	73 0c                	jae    802327 <__umoddi3+0x117>
  80231b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80231f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802323:	89 d7                	mov    %edx,%edi
  802325:	89 c6                	mov    %eax,%esi
  802327:	89 ca                	mov    %ecx,%edx
  802329:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80232e:	29 f3                	sub    %esi,%ebx
  802330:	19 fa                	sbb    %edi,%edx
  802332:	89 d0                	mov    %edx,%eax
  802334:	d3 e0                	shl    %cl,%eax
  802336:	89 e9                	mov    %ebp,%ecx
  802338:	d3 eb                	shr    %cl,%ebx
  80233a:	d3 ea                	shr    %cl,%edx
  80233c:	09 d8                	or     %ebx,%eax
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	29 fe                	sub    %edi,%esi
  802352:	19 c3                	sbb    %eax,%ebx
  802354:	89 f2                	mov    %esi,%edx
  802356:	89 d9                	mov    %ebx,%ecx
  802358:	e9 1d ff ff ff       	jmp    80227a <__umoddi3+0x6a>
