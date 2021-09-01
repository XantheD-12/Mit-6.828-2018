
obj/user/stresssched.debug：     文件格式 elf32-i386


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
  80002c:	e8 b6 00 00 00       	call   8000e7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  80003c:	e8 fb 0b 00 00       	call   800c3c <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  800043:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800048:	e8 29 0f 00 00       	call   800f76 <fork>
  80004d:	85 c0                	test   %eax,%eax
  80004f:	74 0f                	je     800060 <umain+0x2d>
	for (i = 0; i < 20; i++)
  800051:	83 c3 01             	add    $0x1,%ebx
  800054:	83 fb 14             	cmp    $0x14,%ebx
  800057:	75 ef                	jne    800048 <umain+0x15>
			break;
	if (i == 20) {
		sys_yield();
  800059:	e8 01 0c 00 00       	call   800c5f <sys_yield>
		return;
  80005e:	eb 69                	jmp    8000c9 <umain+0x96>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800060:	89 f0                	mov    %esi,%eax
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	eb 02                	jmp    800073 <umain+0x40>
		asm volatile("pause");
  800071:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800073:	8b 50 54             	mov    0x54(%eax),%edx
  800076:	85 d2                	test   %edx,%edx
  800078:	75 f7                	jne    800071 <umain+0x3e>
  80007a:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007f:	e8 db 0b 00 00       	call   800c5f <sys_yield>
  800084:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800089:	a1 04 40 80 00       	mov    0x804004,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 04 40 80 00       	mov    %eax,0x804004
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b1:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 7b 23 80 00       	push   $0x80237b
  8000c1:	e8 70 01 00 00       	call   800236 <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 40 23 80 00       	push   $0x802340
  8000db:	6a 21                	push   $0x21
  8000dd:	68 68 23 80 00       	push   $0x802368
  8000e2:	e8 68 00 00 00       	call   80014f <_panic>

008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	e8 41 0b 00 00       	call   800c3c <sys_getenvid>
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 db                	test   %ebx,%ebx
  80010f:	7e 07                	jle    800118 <libmain+0x31>
		binaryname = argv[0];
  800111:	8b 06                	mov    (%esi),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
  80011d:	e8 11 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800122:	e8 0a 00 00 00       	call   800131 <exit>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013b:	e8 62 12 00 00       	call   8013a2 <close_all>
	sys_env_destroy(0);
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 00                	push   $0x0
  800145:	e8 ad 0a 00 00       	call   800bf7 <sys_env_destroy>
}
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800158:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800161:	e8 d6 0a 00 00       	call   800c3c <sys_getenvid>
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 0c             	pushl  0xc(%ebp)
  80016c:	ff 75 08             	pushl  0x8(%ebp)
  80016f:	56                   	push   %esi
  800170:	50                   	push   %eax
  800171:	68 a4 23 80 00       	push   $0x8023a4
  800176:	e8 bb 00 00 00       	call   800236 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017b:	83 c4 18             	add    $0x18,%esp
  80017e:	53                   	push   %ebx
  80017f:	ff 75 10             	pushl  0x10(%ebp)
  800182:	e8 5a 00 00 00       	call   8001e1 <vcprintf>
	cprintf("\n");
  800187:	c7 04 24 97 23 80 00 	movl   $0x802397,(%esp)
  80018e:	e8 a3 00 00 00       	call   800236 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800196:	cc                   	int3   
  800197:	eb fd                	jmp    800196 <_panic+0x47>

00800199 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800199:	f3 0f 1e fb          	endbr32 
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a7:	8b 13                	mov    (%ebx),%edx
  8001a9:	8d 42 01             	lea    0x1(%edx),%eax
  8001ac:	89 03                	mov    %eax,(%ebx)
  8001ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ba:	74 09                	je     8001c5 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	68 ff 00 00 00       	push   $0xff
  8001cd:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 dc 09 00 00       	call   800bb2 <sys_cputs>
		b->idx = 0;
  8001d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	eb db                	jmp    8001bc <putch+0x23>

008001e1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e1:	f3 0f 1e fb          	endbr32 
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f5:	00 00 00 
	b.cnt = 0;
  8001f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800202:	ff 75 0c             	pushl  0xc(%ebp)
  800205:	ff 75 08             	pushl  0x8(%ebp)
  800208:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	68 99 01 80 00       	push   $0x800199
  800214:	e8 20 01 00 00       	call   800339 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800219:	83 c4 08             	add    $0x8,%esp
  80021c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800222:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800228:	50                   	push   %eax
  800229:	e8 84 09 00 00       	call   800bb2 <sys_cputs>

	return b.cnt;
}
  80022e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800236:	f3 0f 1e fb          	endbr32 
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800240:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800243:	50                   	push   %eax
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	e8 95 ff ff ff       	call   8001e1 <vcprintf>
	va_end(ap);

	return cnt;
}
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	57                   	push   %edi
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
  800254:	83 ec 1c             	sub    $0x1c,%esp
  800257:	89 c7                	mov    %eax,%edi
  800259:	89 d6                	mov    %edx,%esi
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	89 d1                	mov    %edx,%ecx
  800263:	89 c2                	mov    %eax,%edx
  800265:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800268:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80026b:	8b 45 10             	mov    0x10(%ebp),%eax
  80026e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80027b:	39 c2                	cmp    %eax,%edx
  80027d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800280:	72 3e                	jb     8002c0 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	ff 75 18             	pushl  0x18(%ebp)
  800288:	83 eb 01             	sub    $0x1,%ebx
  80028b:	53                   	push   %ebx
  80028c:	50                   	push   %eax
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	ff 75 e4             	pushl  -0x1c(%ebp)
  800293:	ff 75 e0             	pushl  -0x20(%ebp)
  800296:	ff 75 dc             	pushl  -0x24(%ebp)
  800299:	ff 75 d8             	pushl  -0x28(%ebp)
  80029c:	e8 3f 1e 00 00       	call   8020e0 <__udivdi3>
  8002a1:	83 c4 18             	add    $0x18,%esp
  8002a4:	52                   	push   %edx
  8002a5:	50                   	push   %eax
  8002a6:	89 f2                	mov    %esi,%edx
  8002a8:	89 f8                	mov    %edi,%eax
  8002aa:	e8 9f ff ff ff       	call   80024e <printnum>
  8002af:	83 c4 20             	add    $0x20,%esp
  8002b2:	eb 13                	jmp    8002c7 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	56                   	push   %esi
  8002b8:	ff 75 18             	pushl  0x18(%ebp)
  8002bb:	ff d7                	call   *%edi
  8002bd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002c0:	83 eb 01             	sub    $0x1,%ebx
  8002c3:	85 db                	test   %ebx,%ebx
  8002c5:	7f ed                	jg     8002b4 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	56                   	push   %esi
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002da:	e8 11 1f 00 00       	call   8021f0 <__umoddi3>
  8002df:	83 c4 14             	add    $0x14,%esp
  8002e2:	0f be 80 c7 23 80 00 	movsbl 0x8023c7(%eax),%eax
  8002e9:	50                   	push   %eax
  8002ea:	ff d7                	call   *%edi
}
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800301:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800305:	8b 10                	mov    (%eax),%edx
  800307:	3b 50 04             	cmp    0x4(%eax),%edx
  80030a:	73 0a                	jae    800316 <sprintputch+0x1f>
		*b->buf++ = ch;
  80030c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030f:	89 08                	mov    %ecx,(%eax)
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	88 02                	mov    %al,(%edx)
}
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <printfmt>:
{
  800318:	f3 0f 1e fb          	endbr32 
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800322:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800325:	50                   	push   %eax
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	ff 75 0c             	pushl  0xc(%ebp)
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 05 00 00 00       	call   800339 <vprintfmt>
}
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <vprintfmt>:
{
  800339:	f3 0f 1e fb          	endbr32 
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 3c             	sub    $0x3c,%esp
  800346:	8b 75 08             	mov    0x8(%ebp),%esi
  800349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80034f:	e9 8e 03 00 00       	jmp    8006e2 <vprintfmt+0x3a9>
		padc = ' ';
  800354:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800358:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80035f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800366:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8d 47 01             	lea    0x1(%edi),%eax
  800375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800378:	0f b6 17             	movzbl (%edi),%edx
  80037b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037e:	3c 55                	cmp    $0x55,%al
  800380:	0f 87 df 03 00 00    	ja     800765 <vprintfmt+0x42c>
  800386:	0f b6 c0             	movzbl %al,%eax
  800389:	3e ff 24 85 00 25 80 	notrack jmp *0x802500(,%eax,4)
  800390:	00 
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800394:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800398:	eb d8                	jmp    800372 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003a1:	eb cf                	jmp    800372 <vprintfmt+0x39>
  8003a3:	0f b6 d2             	movzbl %dl,%edx
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003b1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003bb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003be:	83 f9 09             	cmp    $0x9,%ecx
  8003c1:	77 55                	ja     800418 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003c3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c6:	eb e9                	jmp    8003b1 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8d 40 04             	lea    0x4(%eax),%eax
  8003d6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e0:	79 90                	jns    800372 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ef:	eb 81                	jmp    800372 <vprintfmt+0x39>
  8003f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fb:	0f 49 d0             	cmovns %eax,%edx
  8003fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800404:	e9 69 ff ff ff       	jmp    800372 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80040c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800413:	e9 5a ff ff ff       	jmp    800372 <vprintfmt+0x39>
  800418:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80041b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041e:	eb bc                	jmp    8003dc <vprintfmt+0xa3>
			lflag++;
  800420:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800426:	e9 47 ff ff ff       	jmp    800372 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 78 04             	lea    0x4(%eax),%edi
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	ff 30                	pushl  (%eax)
  800437:	ff d6                	call   *%esi
			break;
  800439:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043f:	e9 9b 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 78 04             	lea    0x4(%eax),%edi
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	99                   	cltd   
  80044d:	31 d0                	xor    %edx,%eax
  80044f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800451:	83 f8 0f             	cmp    $0xf,%eax
  800454:	7f 23                	jg     800479 <vprintfmt+0x140>
  800456:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	74 18                	je     800479 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800461:	52                   	push   %edx
  800462:	68 11 29 80 00       	push   $0x802911
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 aa fe ff ff       	call   800318 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
  800474:	e9 66 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800479:	50                   	push   %eax
  80047a:	68 df 23 80 00       	push   $0x8023df
  80047f:	53                   	push   %ebx
  800480:	56                   	push   %esi
  800481:	e8 92 fe ff ff       	call   800318 <printfmt>
  800486:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048c:	e9 4e 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80049f:	85 d2                	test   %edx,%edx
  8004a1:	b8 d8 23 80 00       	mov    $0x8023d8,%eax
  8004a6:	0f 45 c2             	cmovne %edx,%eax
  8004a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b0:	7e 06                	jle    8004b8 <vprintfmt+0x17f>
  8004b2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b6:	75 0d                	jne    8004c5 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004bb:	89 c7                	mov    %eax,%edi
  8004bd:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c3:	eb 55                	jmp    80051a <vprintfmt+0x1e1>
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cb:	ff 75 cc             	pushl  -0x34(%ebp)
  8004ce:	e8 46 03 00 00       	call   800819 <strnlen>
  8004d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d6:	29 c2                	sub    %eax,%edx
  8004d8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004e0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	85 ff                	test   %edi,%edi
  8004e9:	7e 11                	jle    8004fc <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	53                   	push   %ebx
  8004ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f4:	83 ef 01             	sub    $0x1,%edi
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	eb eb                	jmp    8004e7 <vprintfmt+0x1ae>
  8004fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	0f 49 c2             	cmovns %edx,%eax
  800509:	29 c2                	sub    %eax,%edx
  80050b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050e:	eb a8                	jmp    8004b8 <vprintfmt+0x17f>
					putch(ch, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	52                   	push   %edx
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 c7 01             	add    $0x1,%edi
  800522:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800526:	0f be d0             	movsbl %al,%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 4b                	je     800578 <vprintfmt+0x23f>
  80052d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800531:	78 06                	js     800539 <vprintfmt+0x200>
  800533:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800537:	78 1e                	js     800557 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800539:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80053d:	74 d1                	je     800510 <vprintfmt+0x1d7>
  80053f:	0f be c0             	movsbl %al,%eax
  800542:	83 e8 20             	sub    $0x20,%eax
  800545:	83 f8 5e             	cmp    $0x5e,%eax
  800548:	76 c6                	jbe    800510 <vprintfmt+0x1d7>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 3f                	push   $0x3f
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb c3                	jmp    80051a <vprintfmt+0x1e1>
  800557:	89 cf                	mov    %ecx,%edi
  800559:	eb 0e                	jmp    800569 <vprintfmt+0x230>
				putch(' ', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	85 ff                	test   %edi,%edi
  80056b:	7f ee                	jg     80055b <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	e9 67 01 00 00       	jmp    8006df <vprintfmt+0x3a6>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb ed                	jmp    800569 <vprintfmt+0x230>
	if (lflag >= 2)
  80057c:	83 f9 01             	cmp    $0x1,%ecx
  80057f:	7f 1b                	jg     80059c <vprintfmt+0x263>
	else if (lflag)
  800581:	85 c9                	test   %ecx,%ecx
  800583:	74 63                	je     8005e8 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058d:	99                   	cltd   
  80058e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005be:	85 c9                	test   %ecx,%ecx
  8005c0:	0f 89 ff 00 00 00    	jns    8006c5 <vprintfmt+0x38c>
				putch('-', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 2d                	push   $0x2d
  8005cc:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d4:	f7 da                	neg    %edx
  8005d6:	83 d1 00             	adc    $0x0,%ecx
  8005d9:	f7 d9                	neg    %ecx
  8005db:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e3:	e9 dd 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	99                   	cltd   
  8005f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb b4                	jmp    8005b3 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005ff:	83 f9 01             	cmp    $0x1,%ecx
  800602:	7f 1e                	jg     800622 <vprintfmt+0x2e9>
	else if (lflag)
  800604:	85 c9                	test   %ecx,%ecx
  800606:	74 32                	je     80063a <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80061d:	e9 a3 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	8b 48 04             	mov    0x4(%eax),%ecx
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800635:	e9 8b 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80064f:	eb 74                	jmp    8006c5 <vprintfmt+0x38c>
	if (lflag >= 2)
  800651:	83 f9 01             	cmp    $0x1,%ecx
  800654:	7f 1b                	jg     800671 <vprintfmt+0x338>
	else if (lflag)
  800656:	85 c9                	test   %ecx,%ecx
  800658:	74 2c                	je     800686 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80066f:	eb 54                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	8b 48 04             	mov    0x4(%eax),%ecx
  800679:	8d 40 08             	lea    0x8(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80067f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800684:	eb 3f                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80069b:	eb 28                	jmp    8006c5 <vprintfmt+0x38c>
			putch('0', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 30                	push   $0x30
  8006a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a5:	83 c4 08             	add    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 78                	push   $0x78
  8006ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006cc:	57                   	push   %edi
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	89 da                	mov    %ebx,%edx
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	e8 72 fb ff ff       	call   80024e <printnum>
			break;
  8006dc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	83 c7 01             	add    $0x1,%edi
  8006e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e9:	83 f8 25             	cmp    $0x25,%eax
  8006ec:	0f 84 62 fc ff ff    	je     800354 <vprintfmt+0x1b>
			if (ch == '\0')
  8006f2:	85 c0                	test   %eax,%eax
  8006f4:	0f 84 8b 00 00 00    	je     800785 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	50                   	push   %eax
  8006ff:	ff d6                	call   *%esi
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	eb dc                	jmp    8006e2 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x3ed>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800724:	eb 9f                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800734:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800739:	eb 8a                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800750:	e9 70 ff ff ff       	jmp    8006c5 <vprintfmt+0x38c>
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 25                	push   $0x25
  80075b:	ff d6                	call   *%esi
			break;
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	e9 7a ff ff ff       	jmp    8006df <vprintfmt+0x3a6>
			putch('%', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	6a 25                	push   $0x25
  80076b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 f8                	mov    %edi,%eax
  800772:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800776:	74 05                	je     80077d <vprintfmt+0x444>
  800778:	83 e8 01             	sub    $0x1,%eax
  80077b:	eb f5                	jmp    800772 <vprintfmt+0x439>
  80077d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800780:	e9 5a ff ff ff       	jmp    8006df <vprintfmt+0x3a6>
}
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	74 26                	je     8007d8 <vsnprintf+0x4b>
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	7e 22                	jle    8007d8 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b6:	ff 75 14             	pushl  0x14(%ebp)
  8007b9:	ff 75 10             	pushl  0x10(%ebp)
  8007bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	68 f7 02 80 00       	push   $0x8002f7
  8007c5:	e8 6f fb ff ff       	call   800339 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    
		return -E_INVAL;
  8007d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007dd:	eb f7                	jmp    8007d6 <vsnprintf+0x49>

008007df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007df:	f3 0f 1e fb          	endbr32 
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ec:	50                   	push   %eax
  8007ed:	ff 75 10             	pushl  0x10(%ebp)
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 92 ff ff ff       	call   80078d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800810:	74 05                	je     800817 <strlen+0x1a>
		n++;
  800812:	83 c0 01             	add    $0x1,%eax
  800815:	eb f5                	jmp    80080c <strlen+0xf>
	return n;
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800819:	f3 0f 1e fb          	endbr32 
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	39 d0                	cmp    %edx,%eax
  80082d:	74 0d                	je     80083c <strnlen+0x23>
  80082f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800833:	74 05                	je     80083a <strnlen+0x21>
		n++;
  800835:	83 c0 01             	add    $0x1,%eax
  800838:	eb f1                	jmp    80082b <strnlen+0x12>
  80083a:	89 c2                	mov    %eax,%edx
	return n;
}
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800840:	f3 0f 1e fb          	endbr32 
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800857:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80085a:	83 c0 01             	add    $0x1,%eax
  80085d:	84 d2                	test   %dl,%dl
  80085f:	75 f2                	jne    800853 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800861:	89 c8                	mov    %ecx,%eax
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800866:	f3 0f 1e fb          	endbr32 
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	83 ec 10             	sub    $0x10,%esp
  800871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800874:	53                   	push   %ebx
  800875:	e8 83 ff ff ff       	call   8007fd <strlen>
  80087a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	01 d8                	add    %ebx,%eax
  800882:	50                   	push   %eax
  800883:	e8 b8 ff ff ff       	call   800840 <strcpy>
	return dst;
}
  800888:	89 d8                	mov    %ebx,%eax
  80088a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	56                   	push   %esi
  800897:	53                   	push   %ebx
  800898:	8b 75 08             	mov    0x8(%ebp),%esi
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089e:	89 f3                	mov    %esi,%ebx
  8008a0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a3:	89 f0                	mov    %esi,%eax
  8008a5:	39 d8                	cmp    %ebx,%eax
  8008a7:	74 11                	je     8008ba <strncpy+0x2b>
		*dst++ = *src;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	0f b6 0a             	movzbl (%edx),%ecx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 f9 01             	cmp    $0x1,%cl
  8008b5:	83 da ff             	sbb    $0xffffffff,%edx
  8008b8:	eb eb                	jmp    8008a5 <strncpy+0x16>
	}
	return ret;
}
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c0:	f3 0f 1e fb          	endbr32 
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	56                   	push   %esi
  8008c8:	53                   	push   %ebx
  8008c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cf:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	74 21                	je     8008f9 <strlcpy+0x39>
  8008d8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008dc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008de:	39 c2                	cmp    %eax,%edx
  8008e0:	74 14                	je     8008f6 <strlcpy+0x36>
  8008e2:	0f b6 19             	movzbl (%ecx),%ebx
  8008e5:	84 db                	test   %bl,%bl
  8008e7:	74 0b                	je     8008f4 <strlcpy+0x34>
			*dst++ = *src++;
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f2:	eb ea                	jmp    8008de <strlcpy+0x1e>
  8008f4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f9:	29 f0                	sub    %esi,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090c:	0f b6 01             	movzbl (%ecx),%eax
  80090f:	84 c0                	test   %al,%al
  800911:	74 0c                	je     80091f <strcmp+0x20>
  800913:	3a 02                	cmp    (%edx),%al
  800915:	75 08                	jne    80091f <strcmp+0x20>
		p++, q++;
  800917:	83 c1 01             	add    $0x1,%ecx
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	eb ed                	jmp    80090c <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	0f b6 12             	movzbl (%edx),%edx
  800925:	29 d0                	sub    %edx,%eax
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800929:	f3 0f 1e fb          	endbr32 
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 c3                	mov    %eax,%ebx
  800939:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80093c:	eb 06                	jmp    800944 <strncmp+0x1b>
		n--, p++, q++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800944:	39 d8                	cmp    %ebx,%eax
  800946:	74 16                	je     80095e <strncmp+0x35>
  800948:	0f b6 08             	movzbl (%eax),%ecx
  80094b:	84 c9                	test   %cl,%cl
  80094d:	74 04                	je     800953 <strncmp+0x2a>
  80094f:	3a 0a                	cmp    (%edx),%cl
  800951:	74 eb                	je     80093e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800953:	0f b6 00             	movzbl (%eax),%eax
  800956:	0f b6 12             	movzbl (%edx),%edx
  800959:	29 d0                	sub    %edx,%eax
}
  80095b:	5b                   	pop    %ebx
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    
		return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb f6                	jmp    80095b <strncmp+0x32>

00800965 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800965:	f3 0f 1e fb          	endbr32 
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800973:	0f b6 10             	movzbl (%eax),%edx
  800976:	84 d2                	test   %dl,%dl
  800978:	74 09                	je     800983 <strchr+0x1e>
		if (*s == c)
  80097a:	38 ca                	cmp    %cl,%dl
  80097c:	74 0a                	je     800988 <strchr+0x23>
	for (; *s; s++)
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	eb f0                	jmp    800973 <strchr+0xe>
			return (char *) s;
	return 0;
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098a:	f3 0f 1e fb          	endbr32 
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	74 09                	je     8009a8 <strfind+0x1e>
  80099f:	84 d2                	test   %dl,%dl
  8009a1:	74 05                	je     8009a8 <strfind+0x1e>
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f0                	jmp    800998 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009aa:	f3 0f 1e fb          	endbr32 
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	57                   	push   %edi
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ba:	85 c9                	test   %ecx,%ecx
  8009bc:	74 31                	je     8009ef <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009be:	89 f8                	mov    %edi,%eax
  8009c0:	09 c8                	or     %ecx,%eax
  8009c2:	a8 03                	test   $0x3,%al
  8009c4:	75 23                	jne    8009e9 <memset+0x3f>
		c &= 0xFF;
  8009c6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ca:	89 d3                	mov    %edx,%ebx
  8009cc:	c1 e3 08             	shl    $0x8,%ebx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	c1 e0 18             	shl    $0x18,%eax
  8009d4:	89 d6                	mov    %edx,%esi
  8009d6:	c1 e6 10             	shl    $0x10,%esi
  8009d9:	09 f0                	or     %esi,%eax
  8009db:	09 c2                	or     %eax,%edx
  8009dd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009df:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e7:	eb 06                	jmp    8009ef <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	fc                   	cld    
  8009ed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ef:	89 f8                	mov    %edi,%eax
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5f                   	pop    %edi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	57                   	push   %edi
  8009fe:	56                   	push   %esi
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a08:	39 c6                	cmp    %eax,%esi
  800a0a:	73 32                	jae    800a3e <memmove+0x48>
  800a0c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0f:	39 c2                	cmp    %eax,%edx
  800a11:	76 2b                	jbe    800a3e <memmove+0x48>
		s += n;
		d += n;
  800a13:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a16:	89 fe                	mov    %edi,%esi
  800a18:	09 ce                	or     %ecx,%esi
  800a1a:	09 d6                	or     %edx,%esi
  800a1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a22:	75 0e                	jne    800a32 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a24:	83 ef 04             	sub    $0x4,%edi
  800a27:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2d:	fd                   	std    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb 09                	jmp    800a3b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a32:	83 ef 01             	sub    $0x1,%edi
  800a35:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a38:	fd                   	std    
  800a39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3b:	fc                   	cld    
  800a3c:	eb 1a                	jmp    800a58 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	09 ca                	or     %ecx,%edx
  800a42:	09 f2                	or     %esi,%edx
  800a44:	f6 c2 03             	test   $0x3,%dl
  800a47:	75 0a                	jne    800a53 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 05                	jmp    800a58 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a53:	89 c7                	mov    %eax,%edi
  800a55:	fc                   	cld    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a66:	ff 75 10             	pushl  0x10(%ebp)
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	e8 82 ff ff ff       	call   8009f6 <memmove>
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a76:	f3 0f 1e fb          	endbr32 
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	89 c6                	mov    %eax,%esi
  800a87:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8a:	39 f0                	cmp    %esi,%eax
  800a8c:	74 1c                	je     800aaa <memcmp+0x34>
		if (*s1 != *s2)
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	0f b6 1a             	movzbl (%edx),%ebx
  800a94:	38 d9                	cmp    %bl,%cl
  800a96:	75 08                	jne    800aa0 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	eb ea                	jmp    800a8a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aa0:	0f b6 c1             	movzbl %cl,%eax
  800aa3:	0f b6 db             	movzbl %bl,%ebx
  800aa6:	29 d8                	sub    %ebx,%eax
  800aa8:	eb 05                	jmp    800aaf <memcmp+0x39>
	}

	return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac5:	39 d0                	cmp    %edx,%eax
  800ac7:	73 09                	jae    800ad2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac9:	38 08                	cmp    %cl,(%eax)
  800acb:	74 05                	je     800ad2 <memfind+0x1f>
	for (; s < ends; s++)
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	eb f3                	jmp    800ac5 <memfind+0x12>
			break;
	return (void *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad4:	f3 0f 1e fb          	endbr32 
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae4:	eb 03                	jmp    800ae9 <strtol+0x15>
		s++;
  800ae6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae9:	0f b6 01             	movzbl (%ecx),%eax
  800aec:	3c 20                	cmp    $0x20,%al
  800aee:	74 f6                	je     800ae6 <strtol+0x12>
  800af0:	3c 09                	cmp    $0x9,%al
  800af2:	74 f2                	je     800ae6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800af4:	3c 2b                	cmp    $0x2b,%al
  800af6:	74 2a                	je     800b22 <strtol+0x4e>
	int neg = 0;
  800af8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afd:	3c 2d                	cmp    $0x2d,%al
  800aff:	74 2b                	je     800b2c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b07:	75 0f                	jne    800b18 <strtol+0x44>
  800b09:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0c:	74 28                	je     800b36 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b15:	0f 44 d8             	cmove  %eax,%ebx
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b20:	eb 46                	jmp    800b68 <strtol+0x94>
		s++;
  800b22:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b25:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2a:	eb d5                	jmp    800b01 <strtol+0x2d>
		s++, neg = 1;
  800b2c:	83 c1 01             	add    $0x1,%ecx
  800b2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b34:	eb cb                	jmp    800b01 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b36:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3a:	74 0e                	je     800b4a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	75 d8                	jne    800b18 <strtol+0x44>
		s++, base = 8;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b48:	eb ce                	jmp    800b18 <strtol+0x44>
		s += 2, base = 16;
  800b4a:	83 c1 02             	add    $0x2,%ecx
  800b4d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b52:	eb c4                	jmp    800b18 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b54:	0f be d2             	movsbl %dl,%edx
  800b57:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5d:	7d 3a                	jge    800b99 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b68:	0f b6 11             	movzbl (%ecx),%edx
  800b6b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b6e:	89 f3                	mov    %esi,%ebx
  800b70:	80 fb 09             	cmp    $0x9,%bl
  800b73:	76 df                	jbe    800b54 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	80 fb 19             	cmp    $0x19,%bl
  800b7d:	77 08                	ja     800b87 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b7f:	0f be d2             	movsbl %dl,%edx
  800b82:	83 ea 57             	sub    $0x57,%edx
  800b85:	eb d3                	jmp    800b5a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b87:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 08                	ja     800b99 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 37             	sub    $0x37,%edx
  800b97:	eb c1                	jmp    800b5a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	74 05                	je     800ba4 <strtol+0xd0>
		*endptr = (char *) s;
  800b9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	f7 da                	neg    %edx
  800ba8:	85 ff                	test   %edi,%edi
  800baa:	0f 45 c2             	cmovne %edx,%eax
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb2:	f3 0f 1e fb          	endbr32 
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 01 00 00 00       	mov    $0x1,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf7:	f3 0f 1e fb          	endbr32 
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c11:	89 cb                	mov    %ecx,%ebx
  800c13:	89 cf                	mov    %ecx,%edi
  800c15:	89 ce                	mov    %ecx,%esi
  800c17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c19:	85 c0                	test   %eax,%eax
  800c1b:	7f 08                	jg     800c25 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	50                   	push   %eax
  800c29:	6a 03                	push   $0x3
  800c2b:	68 bf 26 80 00       	push   $0x8026bf
  800c30:	6a 23                	push   $0x23
  800c32:	68 dc 26 80 00       	push   $0x8026dc
  800c37:	e8 13 f5 ff ff       	call   80014f <_panic>

00800c3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c3c:	f3 0f 1e fb          	endbr32 
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c50:	89 d1                	mov    %edx,%ecx
  800c52:	89 d3                	mov    %edx,%ebx
  800c54:	89 d7                	mov    %edx,%edi
  800c56:	89 d6                	mov    %edx,%esi
  800c58:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <sys_yield>:

void
sys_yield(void)
{
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c82:	f3 0f 1e fb          	endbr32 
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8f:	be 00 00 00 00       	mov    $0x0,%esi
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	89 f7                	mov    %esi,%edi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800cb6:	6a 04                	push   $0x4
  800cb8:	68 bf 26 80 00       	push   $0x8026bf
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 dc 26 80 00       	push   $0x8026dc
  800cc4:	e8 86 f4 ff ff       	call   80014f <_panic>

00800cc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800cfc:	6a 05                	push   $0x5
  800cfe:	68 bf 26 80 00       	push   $0x8026bf
  800d03:	6a 23                	push   $0x23
  800d05:	68 dc 26 80 00       	push   $0x8026dc
  800d0a:	e8 40 f4 ff ff       	call   80014f <_panic>

00800d0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d27:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d42:	6a 06                	push   $0x6
  800d44:	68 bf 26 80 00       	push   $0x8026bf
  800d49:	6a 23                	push   $0x23
  800d4b:	68 dc 26 80 00       	push   $0x8026dc
  800d50:	e8 fa f3 ff ff       	call   80014f <_panic>

00800d55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800d6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d88:	6a 08                	push   $0x8
  800d8a:	68 bf 26 80 00       	push   $0x8026bf
  800d8f:	6a 23                	push   $0x23
  800d91:	68 dc 26 80 00       	push   $0x8026dc
  800d96:	e8 b4 f3 ff ff       	call   80014f <_panic>

00800d9b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	b8 09 00 00 00       	mov    $0x9,%eax
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	89 de                	mov    %ebx,%esi
  800dbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7f 08                	jg     800dca <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 09                	push   $0x9
  800dd0:	68 bf 26 80 00       	push   $0x8026bf
  800dd5:	6a 23                	push   $0x23
  800dd7:	68 dc 26 80 00       	push   $0x8026dc
  800ddc:	e8 6e f3 ff ff       	call   80014f <_panic>

00800de1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de1:	f3 0f 1e fb          	endbr32 
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfe:	89 df                	mov    %ebx,%edi
  800e00:	89 de                	mov    %ebx,%esi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 0a                	push   $0xa
  800e16:	68 bf 26 80 00       	push   $0x8026bf
  800e1b:	6a 23                	push   $0x23
  800e1d:	68 dc 26 80 00       	push   $0x8026dc
  800e22:	e8 28 f3 ff ff       	call   80014f <_panic>

00800e27 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e27:	f3 0f 1e fb          	endbr32 
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3c:	be 00 00 00 00       	mov    $0x0,%esi
  800e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e47:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e68:	89 cb                	mov    %ecx,%ebx
  800e6a:	89 cf                	mov    %ecx,%edi
  800e6c:	89 ce                	mov    %ecx,%esi
  800e6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 0d                	push   $0xd
  800e82:	68 bf 26 80 00       	push   $0x8026bf
  800e87:	6a 23                	push   $0x23
  800e89:	68 dc 26 80 00       	push   $0x8026dc
  800e8e:	e8 bc f2 ff ff       	call   80014f <_panic>

00800e93 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800e93:	f3 0f 1e fb          	endbr32 
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e9f:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800ea1:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ea5:	74 7f                	je     800f26 <pgfault+0x93>
  800ea7:	89 f0                	mov    %esi,%eax
  800ea9:	c1 e8 0c             	shr    $0xc,%eax
  800eac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eb3:	f6 c4 08             	test   $0x8,%ah
  800eb6:	74 6e                	je     800f26 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800eb8:	e8 7f fd ff ff       	call   800c3c <sys_getenvid>
  800ebd:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800ebf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	6a 07                	push   $0x7
  800eca:	68 00 f0 7f 00       	push   $0x7ff000
  800ecf:	50                   	push   %eax
  800ed0:	e8 ad fd ff ff       	call   800c82 <sys_page_alloc>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	78 5e                	js     800f3a <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800edc:	83 ec 04             	sub    $0x4,%esp
  800edf:	68 00 10 00 00       	push   $0x1000
  800ee4:	56                   	push   %esi
  800ee5:	68 00 f0 7f 00       	push   $0x7ff000
  800eea:	e8 6d fb ff ff       	call   800a5c <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800eef:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	68 00 f0 7f 00       	push   $0x7ff000
  800efd:	53                   	push   %ebx
  800efe:	e8 c6 fd ff ff       	call   800cc9 <sys_page_map>
  800f03:	83 c4 20             	add    $0x20,%esp
  800f06:	85 c0                	test   %eax,%eax
  800f08:	78 44                	js     800f4e <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	68 00 f0 7f 00       	push   $0x7ff000
  800f12:	53                   	push   %ebx
  800f13:	e8 f7 fd ff ff       	call   800d0f <sys_page_unmap>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	78 43                	js     800f62 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800f26:	83 ec 04             	sub    $0x4,%esp
  800f29:	68 ea 26 80 00       	push   $0x8026ea
  800f2e:	6a 1e                	push   $0x1e
  800f30:	68 07 27 80 00       	push   $0x802707
  800f35:	e8 15 f2 ff ff       	call   80014f <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 98 27 80 00       	push   $0x802798
  800f42:	6a 2b                	push   $0x2b
  800f44:	68 07 27 80 00       	push   $0x802707
  800f49:	e8 01 f2 ff ff       	call   80014f <_panic>
		panic("pgfault: sys_page_map Failed!");
  800f4e:	83 ec 04             	sub    $0x4,%esp
  800f51:	68 12 27 80 00       	push   $0x802712
  800f56:	6a 2f                	push   $0x2f
  800f58:	68 07 27 80 00       	push   $0x802707
  800f5d:	e8 ed f1 ff ff       	call   80014f <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800f62:	83 ec 04             	sub    $0x4,%esp
  800f65:	68 b8 27 80 00       	push   $0x8027b8
  800f6a:	6a 32                	push   $0x32
  800f6c:	68 07 27 80 00       	push   $0x802707
  800f71:	e8 d9 f1 ff ff       	call   80014f <_panic>

00800f76 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f76:	f3 0f 1e fb          	endbr32 
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f83:	68 93 0e 80 00       	push   $0x800e93
  800f88:	e8 6b 0f 00 00       	call   801ef8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f8d:	b8 07 00 00 00       	mov    $0x7,%eax
  800f92:	cd 30                	int    $0x30
  800f94:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f97:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	78 2b                	js     800fcc <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  800fa6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800faa:	0f 85 ba 00 00 00    	jne    80106a <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  800fb0:	e8 87 fc ff ff       	call   800c3c <sys_getenvid>
  800fb5:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fbd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fc2:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800fc7:	e9 90 01 00 00       	jmp    80115c <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	68 30 27 80 00       	push   $0x802730
  800fd4:	6a 76                	push   $0x76
  800fd6:	68 07 27 80 00       	push   $0x802707
  800fdb:	e8 6f f1 ff ff       	call   80014f <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  800fe0:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  800fe7:	e8 50 fc ff ff       	call   800c3c <sys_getenvid>
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800ff5:	56                   	push   %esi
  800ff6:	57                   	push   %edi
  800ff7:	ff 75 e0             	pushl  -0x20(%ebp)
  800ffa:	57                   	push   %edi
  800ffb:	50                   	push   %eax
  800ffc:	e8 c8 fc ff ff       	call   800cc9 <sys_page_map>
  801001:	83 c4 20             	add    $0x20,%esp
  801004:	85 c0                	test   %eax,%eax
  801006:	79 50                	jns    801058 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	68 49 27 80 00       	push   $0x802749
  801010:	6a 4b                	push   $0x4b
  801012:	68 07 27 80 00       	push   $0x802707
  801017:	e8 33 f1 ff ff       	call   80014f <_panic>
			panic("duppage:child sys_page_map Failed!");
  80101c:	83 ec 04             	sub    $0x4,%esp
  80101f:	68 d8 27 80 00       	push   $0x8027d8
  801024:	6a 50                	push   $0x50
  801026:	68 07 27 80 00       	push   $0x802707
  80102b:	e8 1f f1 ff ff       	call   80014f <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  801030:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	25 07 0e 00 00       	and    $0xe07,%eax
  80103f:	50                   	push   %eax
  801040:	57                   	push   %edi
  801041:	ff 75 e0             	pushl  -0x20(%ebp)
  801044:	57                   	push   %edi
  801045:	ff 75 e4             	pushl  -0x1c(%ebp)
  801048:	e8 7c fc ff ff       	call   800cc9 <sys_page_map>
  80104d:	83 c4 20             	add    $0x20,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	0f 88 b4 00 00 00    	js     80110c <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801058:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80105e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801064:	0f 84 b6 00 00 00    	je     801120 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  80106a:	89 d8                	mov    %ebx,%eax
  80106c:	c1 e8 16             	shr    $0x16,%eax
  80106f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801076:	a8 01                	test   $0x1,%al
  801078:	74 de                	je     801058 <fork+0xe2>
  80107a:	89 de                	mov    %ebx,%esi
  80107c:	c1 ee 0c             	shr    $0xc,%esi
  80107f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801086:	a8 01                	test   $0x1,%al
  801088:	74 ce                	je     801058 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  80108a:	e8 ad fb ff ff       	call   800c3c <sys_getenvid>
  80108f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801092:	89 f7                	mov    %esi,%edi
  801094:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  801097:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80109e:	f6 c4 04             	test   $0x4,%ah
  8010a1:	0f 85 39 ff ff ff    	jne    800fe0 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  8010a7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010ae:	a9 02 08 00 00       	test   $0x802,%eax
  8010b3:	0f 84 77 ff ff ff    	je     801030 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	68 05 08 00 00       	push   $0x805
  8010c1:	57                   	push   %edi
  8010c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8010c5:	57                   	push   %edi
  8010c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010c9:	e8 fb fb ff ff       	call   800cc9 <sys_page_map>
  8010ce:	83 c4 20             	add    $0x20,%esp
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	0f 88 43 ff ff ff    	js     80101c <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8010d9:	83 ec 0c             	sub    $0xc,%esp
  8010dc:	68 05 08 00 00       	push   $0x805
  8010e1:	57                   	push   %edi
  8010e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010e5:	50                   	push   %eax
  8010e6:	57                   	push   %edi
  8010e7:	50                   	push   %eax
  8010e8:	e8 dc fb ff ff       	call   800cc9 <sys_page_map>
  8010ed:	83 c4 20             	add    $0x20,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	0f 89 60 ff ff ff    	jns    801058 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	68 fc 27 80 00       	push   $0x8027fc
  801100:	6a 52                	push   $0x52
  801102:	68 07 27 80 00       	push   $0x802707
  801107:	e8 43 f0 ff ff       	call   80014f <_panic>
			panic("duppage: single sys_page_map Failed!");
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	68 20 28 80 00       	push   $0x802820
  801114:	6a 56                	push   $0x56
  801116:	68 07 27 80 00       	push   $0x802707
  80111b:	e8 2f f0 ff ff       	call   80014f <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801120:	83 ec 04             	sub    $0x4,%esp
  801123:	6a 07                	push   $0x7
  801125:	68 00 f0 bf ee       	push   $0xeebff000
  80112a:	ff 75 dc             	pushl  -0x24(%ebp)
  80112d:	e8 50 fb ff ff       	call   800c82 <sys_page_alloc>
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	78 2e                	js     801167 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	68 74 1f 80 00       	push   $0x801f74
  801141:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801144:	57                   	push   %edi
  801145:	e8 97 fc ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  80114a:	83 c4 08             	add    $0x8,%esp
  80114d:	6a 02                	push   $0x2
  80114f:	57                   	push   %edi
  801150:	e8 00 fc ff ff       	call   800d55 <sys_env_set_status>
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	78 22                	js     80117e <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  80115c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80115f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5f                   	pop    %edi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	68 66 27 80 00       	push   $0x802766
  80116f:	68 83 00 00 00       	push   $0x83
  801174:	68 07 27 80 00       	push   $0x802707
  801179:	e8 d1 ef ff ff       	call   80014f <_panic>
		panic("fork: sys_env_set_status Failed!");
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 48 28 80 00       	push   $0x802848
  801186:	68 89 00 00 00       	push   $0x89
  80118b:	68 07 27 80 00       	push   $0x802707
  801190:	e8 ba ef ff ff       	call   80014f <_panic>

00801195 <sfork>:

// Challenge!
int
sfork(void)
{
  801195:	f3 0f 1e fb          	endbr32 
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80119f:	68 82 27 80 00       	push   $0x802782
  8011a4:	68 93 00 00 00       	push   $0x93
  8011a9:	68 07 27 80 00       	push   $0x802707
  8011ae:	e8 9c ef ff ff       	call   80014f <_panic>

008011b3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b3:	f3 0f 1e fb          	endbr32 
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	05 00 00 00 30       	add    $0x30000000,%eax
  8011c2:	c1 e8 0c             	shr    $0xc,%eax
}
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c7:	f3 0f 1e fb          	endbr32 
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011db:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    

008011e2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011e2:	f3 0f 1e fb          	endbr32 
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ee:	89 c2                	mov    %eax,%edx
  8011f0:	c1 ea 16             	shr    $0x16,%edx
  8011f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011fa:	f6 c2 01             	test   $0x1,%dl
  8011fd:	74 2d                	je     80122c <fd_alloc+0x4a>
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	c1 ea 0c             	shr    $0xc,%edx
  801204:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80120b:	f6 c2 01             	test   $0x1,%dl
  80120e:	74 1c                	je     80122c <fd_alloc+0x4a>
  801210:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801215:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80121a:	75 d2                	jne    8011ee <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801225:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80122a:	eb 0a                	jmp    801236 <fd_alloc+0x54>
			*fd_store = fd;
  80122c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801238:	f3 0f 1e fb          	endbr32 
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801242:	83 f8 1f             	cmp    $0x1f,%eax
  801245:	77 30                	ja     801277 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801247:	c1 e0 0c             	shl    $0xc,%eax
  80124a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80124f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801255:	f6 c2 01             	test   $0x1,%dl
  801258:	74 24                	je     80127e <fd_lookup+0x46>
  80125a:	89 c2                	mov    %eax,%edx
  80125c:	c1 ea 0c             	shr    $0xc,%edx
  80125f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801266:	f6 c2 01             	test   $0x1,%dl
  801269:	74 1a                	je     801285 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80126b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126e:	89 02                	mov    %eax,(%edx)
	return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    
		return -E_INVAL;
  801277:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127c:	eb f7                	jmp    801275 <fd_lookup+0x3d>
		return -E_INVAL;
  80127e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801283:	eb f0                	jmp    801275 <fd_lookup+0x3d>
  801285:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128a:	eb e9                	jmp    801275 <fd_lookup+0x3d>

0080128c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80128c:	f3 0f 1e fb          	endbr32 
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801299:	ba e8 28 80 00       	mov    $0x8028e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80129e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a3:	39 08                	cmp    %ecx,(%eax)
  8012a5:	74 33                	je     8012da <dev_lookup+0x4e>
  8012a7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012aa:	8b 02                	mov    (%edx),%eax
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	75 f3                	jne    8012a3 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b5:	8b 40 48             	mov    0x48(%eax),%eax
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	51                   	push   %ecx
  8012bc:	50                   	push   %eax
  8012bd:	68 6c 28 80 00       	push   $0x80286c
  8012c2:	e8 6f ef ff ff       	call   800236 <cprintf>
	*dev = 0;
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    
			*dev = devtab[i];
  8012da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012df:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e4:	eb f2                	jmp    8012d8 <dev_lookup+0x4c>

008012e6 <fd_close>:
{
  8012e6:	f3 0f 1e fb          	endbr32 
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 24             	sub    $0x24,%esp
  8012f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012fc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012fd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801303:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801306:	50                   	push   %eax
  801307:	e8 2c ff ff ff       	call   801238 <fd_lookup>
  80130c:	89 c3                	mov    %eax,%ebx
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 05                	js     80131a <fd_close+0x34>
	    || fd != fd2)
  801315:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801318:	74 16                	je     801330 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80131a:	89 f8                	mov    %edi,%eax
  80131c:	84 c0                	test   %al,%al
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
  801323:	0f 44 d8             	cmove  %eax,%ebx
}
  801326:	89 d8                	mov    %ebx,%eax
  801328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132b:	5b                   	pop    %ebx
  80132c:	5e                   	pop    %esi
  80132d:	5f                   	pop    %edi
  80132e:	5d                   	pop    %ebp
  80132f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801330:	83 ec 08             	sub    $0x8,%esp
  801333:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801336:	50                   	push   %eax
  801337:	ff 36                	pushl  (%esi)
  801339:	e8 4e ff ff ff       	call   80128c <dev_lookup>
  80133e:	89 c3                	mov    %eax,%ebx
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	78 1a                	js     801361 <fd_close+0x7b>
		if (dev->dev_close)
  801347:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80134d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801352:	85 c0                	test   %eax,%eax
  801354:	74 0b                	je     801361 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	56                   	push   %esi
  80135a:	ff d0                	call   *%eax
  80135c:	89 c3                	mov    %eax,%ebx
  80135e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801361:	83 ec 08             	sub    $0x8,%esp
  801364:	56                   	push   %esi
  801365:	6a 00                	push   $0x0
  801367:	e8 a3 f9 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  80136c:	83 c4 10             	add    $0x10,%esp
  80136f:	eb b5                	jmp    801326 <fd_close+0x40>

00801371 <close>:

int
close(int fdnum)
{
  801371:	f3 0f 1e fb          	endbr32 
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 b1 fe ff ff       	call   801238 <fd_lookup>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	79 02                	jns    801390 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    
		return fd_close(fd, 1);
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	6a 01                	push   $0x1
  801395:	ff 75 f4             	pushl  -0xc(%ebp)
  801398:	e8 49 ff ff ff       	call   8012e6 <fd_close>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	eb ec                	jmp    80138e <close+0x1d>

008013a2 <close_all>:

void
close_all(void)
{
  8013a2:	f3 0f 1e fb          	endbr32 
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	53                   	push   %ebx
  8013b6:	e8 b6 ff ff ff       	call   801371 <close>
	for (i = 0; i < MAXFD; i++)
  8013bb:	83 c3 01             	add    $0x1,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	83 fb 20             	cmp    $0x20,%ebx
  8013c4:	75 ec                	jne    8013b2 <close_all+0x10>
}
  8013c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013cb:	f3 0f 1e fb          	endbr32 
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	57                   	push   %edi
  8013d3:	56                   	push   %esi
  8013d4:	53                   	push   %ebx
  8013d5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013db:	50                   	push   %eax
  8013dc:	ff 75 08             	pushl  0x8(%ebp)
  8013df:	e8 54 fe ff ff       	call   801238 <fd_lookup>
  8013e4:	89 c3                	mov    %eax,%ebx
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	0f 88 81 00 00 00    	js     801472 <dup+0xa7>
		return r;
	close(newfdnum);
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 75 ff ff ff       	call   801371 <close>

	newfd = INDEX2FD(newfdnum);
  8013fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ff:	c1 e6 0c             	shl    $0xc,%esi
  801402:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801408:	83 c4 04             	add    $0x4,%esp
  80140b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80140e:	e8 b4 fd ff ff       	call   8011c7 <fd2data>
  801413:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801415:	89 34 24             	mov    %esi,(%esp)
  801418:	e8 aa fd ff ff       	call   8011c7 <fd2data>
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801422:	89 d8                	mov    %ebx,%eax
  801424:	c1 e8 16             	shr    $0x16,%eax
  801427:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80142e:	a8 01                	test   $0x1,%al
  801430:	74 11                	je     801443 <dup+0x78>
  801432:	89 d8                	mov    %ebx,%eax
  801434:	c1 e8 0c             	shr    $0xc,%eax
  801437:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80143e:	f6 c2 01             	test   $0x1,%dl
  801441:	75 39                	jne    80147c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801443:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801446:	89 d0                	mov    %edx,%eax
  801448:	c1 e8 0c             	shr    $0xc,%eax
  80144b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801452:	83 ec 0c             	sub    $0xc,%esp
  801455:	25 07 0e 00 00       	and    $0xe07,%eax
  80145a:	50                   	push   %eax
  80145b:	56                   	push   %esi
  80145c:	6a 00                	push   $0x0
  80145e:	52                   	push   %edx
  80145f:	6a 00                	push   $0x0
  801461:	e8 63 f8 ff ff       	call   800cc9 <sys_page_map>
  801466:	89 c3                	mov    %eax,%ebx
  801468:	83 c4 20             	add    $0x20,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 31                	js     8014a0 <dup+0xd5>
		goto err;

	return newfdnum;
  80146f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801472:	89 d8                	mov    %ebx,%eax
  801474:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801477:	5b                   	pop    %ebx
  801478:	5e                   	pop    %esi
  801479:	5f                   	pop    %edi
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80147c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801483:	83 ec 0c             	sub    $0xc,%esp
  801486:	25 07 0e 00 00       	and    $0xe07,%eax
  80148b:	50                   	push   %eax
  80148c:	57                   	push   %edi
  80148d:	6a 00                	push   $0x0
  80148f:	53                   	push   %ebx
  801490:	6a 00                	push   $0x0
  801492:	e8 32 f8 ff ff       	call   800cc9 <sys_page_map>
  801497:	89 c3                	mov    %eax,%ebx
  801499:	83 c4 20             	add    $0x20,%esp
  80149c:	85 c0                	test   %eax,%eax
  80149e:	79 a3                	jns    801443 <dup+0x78>
	sys_page_unmap(0, newfd);
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	56                   	push   %esi
  8014a4:	6a 00                	push   $0x0
  8014a6:	e8 64 f8 ff ff       	call   800d0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ab:	83 c4 08             	add    $0x8,%esp
  8014ae:	57                   	push   %edi
  8014af:	6a 00                	push   $0x0
  8014b1:	e8 59 f8 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	eb b7                	jmp    801472 <dup+0xa7>

008014bb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014bb:	f3 0f 1e fb          	endbr32 
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	53                   	push   %ebx
  8014c3:	83 ec 1c             	sub    $0x1c,%esp
  8014c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	53                   	push   %ebx
  8014ce:	e8 65 fd ff ff       	call   801238 <fd_lookup>
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 3f                	js     801519 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014da:	83 ec 08             	sub    $0x8,%esp
  8014dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	ff 30                	pushl  (%eax)
  8014e6:	e8 a1 fd ff ff       	call   80128c <dev_lookup>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 27                	js     801519 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f5:	8b 42 08             	mov    0x8(%edx),%eax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	83 f8 01             	cmp    $0x1,%eax
  8014fe:	74 1e                	je     80151e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	8b 40 08             	mov    0x8(%eax),%eax
  801506:	85 c0                	test   %eax,%eax
  801508:	74 35                	je     80153f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	ff 75 10             	pushl  0x10(%ebp)
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	52                   	push   %edx
  801514:	ff d0                	call   *%eax
  801516:	83 c4 10             	add    $0x10,%esp
}
  801519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80151e:	a1 08 40 80 00       	mov    0x804008,%eax
  801523:	8b 40 48             	mov    0x48(%eax),%eax
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	53                   	push   %ebx
  80152a:	50                   	push   %eax
  80152b:	68 ad 28 80 00       	push   $0x8028ad
  801530:	e8 01 ed ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80153d:	eb da                	jmp    801519 <read+0x5e>
		return -E_NOT_SUPP;
  80153f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801544:	eb d3                	jmp    801519 <read+0x5e>

00801546 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801546:	f3 0f 1e fb          	endbr32 
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	57                   	push   %edi
  80154e:	56                   	push   %esi
  80154f:	53                   	push   %ebx
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	8b 7d 08             	mov    0x8(%ebp),%edi
  801556:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801559:	bb 00 00 00 00       	mov    $0x0,%ebx
  80155e:	eb 02                	jmp    801562 <readn+0x1c>
  801560:	01 c3                	add    %eax,%ebx
  801562:	39 f3                	cmp    %esi,%ebx
  801564:	73 21                	jae    801587 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	89 f0                	mov    %esi,%eax
  80156b:	29 d8                	sub    %ebx,%eax
  80156d:	50                   	push   %eax
  80156e:	89 d8                	mov    %ebx,%eax
  801570:	03 45 0c             	add    0xc(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	57                   	push   %edi
  801575:	e8 41 ff ff ff       	call   8014bb <read>
		if (m < 0)
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 04                	js     801585 <readn+0x3f>
			return m;
		if (m == 0)
  801581:	75 dd                	jne    801560 <readn+0x1a>
  801583:	eb 02                	jmp    801587 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801585:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801587:	89 d8                	mov    %ebx,%eax
  801589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    

00801591 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801591:	f3 0f 1e fb          	endbr32 
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 1c             	sub    $0x1c,%esp
  80159c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80159f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a2:	50                   	push   %eax
  8015a3:	53                   	push   %ebx
  8015a4:	e8 8f fc ff ff       	call   801238 <fd_lookup>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 3a                	js     8015ea <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	ff 30                	pushl  (%eax)
  8015bc:	e8 cb fc ff ff       	call   80128c <dev_lookup>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 22                	js     8015ea <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015cf:	74 1e                	je     8015ef <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d7:	85 d2                	test   %edx,%edx
  8015d9:	74 35                	je     801610 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	ff 75 10             	pushl  0x10(%ebp)
  8015e1:	ff 75 0c             	pushl  0xc(%ebp)
  8015e4:	50                   	push   %eax
  8015e5:	ff d2                	call   *%edx
  8015e7:	83 c4 10             	add    $0x10,%esp
}
  8015ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8015f4:	8b 40 48             	mov    0x48(%eax),%eax
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	53                   	push   %ebx
  8015fb:	50                   	push   %eax
  8015fc:	68 c9 28 80 00       	push   $0x8028c9
  801601:	e8 30 ec ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160e:	eb da                	jmp    8015ea <write+0x59>
		return -E_NOT_SUPP;
  801610:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801615:	eb d3                	jmp    8015ea <write+0x59>

00801617 <seek>:

int
seek(int fdnum, off_t offset)
{
  801617:	f3 0f 1e fb          	endbr32 
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801621:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801624:	50                   	push   %eax
  801625:	ff 75 08             	pushl  0x8(%ebp)
  801628:	e8 0b fc ff ff       	call   801238 <fd_lookup>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 0e                	js     801642 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801634:	8b 55 0c             	mov    0xc(%ebp),%edx
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801644:	f3 0f 1e fb          	endbr32 
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	53                   	push   %ebx
  80164c:	83 ec 1c             	sub    $0x1c,%esp
  80164f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801652:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	53                   	push   %ebx
  801657:	e8 dc fb ff ff       	call   801238 <fd_lookup>
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 37                	js     80169a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	ff 30                	pushl  (%eax)
  80166f:	e8 18 fc ff ff       	call   80128c <dev_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 1f                	js     80169a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801682:	74 1b                	je     80169f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801687:	8b 52 18             	mov    0x18(%edx),%edx
  80168a:	85 d2                	test   %edx,%edx
  80168c:	74 32                	je     8016c0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	50                   	push   %eax
  801695:	ff d2                	call   *%edx
  801697:	83 c4 10             	add    $0x10,%esp
}
  80169a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80169f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016a4:	8b 40 48             	mov    0x48(%eax),%eax
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	53                   	push   %ebx
  8016ab:	50                   	push   %eax
  8016ac:	68 8c 28 80 00       	push   $0x80288c
  8016b1:	e8 80 eb ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016be:	eb da                	jmp    80169a <ftruncate+0x56>
		return -E_NOT_SUPP;
  8016c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c5:	eb d3                	jmp    80169a <ftruncate+0x56>

008016c7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016c7:	f3 0f 1e fb          	endbr32 
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	53                   	push   %ebx
  8016cf:	83 ec 1c             	sub    $0x1c,%esp
  8016d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d8:	50                   	push   %eax
  8016d9:	ff 75 08             	pushl  0x8(%ebp)
  8016dc:	e8 57 fb ff ff       	call   801238 <fd_lookup>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 4b                	js     801733 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ee:	50                   	push   %eax
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	ff 30                	pushl  (%eax)
  8016f4:	e8 93 fb ff ff       	call   80128c <dev_lookup>
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	78 33                	js     801733 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801707:	74 2f                	je     801738 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801709:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80170c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801713:	00 00 00 
	stat->st_isdir = 0;
  801716:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80171d:	00 00 00 
	stat->st_dev = dev;
  801720:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801726:	83 ec 08             	sub    $0x8,%esp
  801729:	53                   	push   %ebx
  80172a:	ff 75 f0             	pushl  -0x10(%ebp)
  80172d:	ff 50 14             	call   *0x14(%eax)
  801730:	83 c4 10             	add    $0x10,%esp
}
  801733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801736:	c9                   	leave  
  801737:	c3                   	ret    
		return -E_NOT_SUPP;
  801738:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173d:	eb f4                	jmp    801733 <fstat+0x6c>

0080173f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80173f:	f3 0f 1e fb          	endbr32 
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	6a 00                	push   $0x0
  80174d:	ff 75 08             	pushl  0x8(%ebp)
  801750:	e8 fb 01 00 00       	call   801950 <open>
  801755:	89 c3                	mov    %eax,%ebx
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	85 c0                	test   %eax,%eax
  80175c:	78 1b                	js     801779 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80175e:	83 ec 08             	sub    $0x8,%esp
  801761:	ff 75 0c             	pushl  0xc(%ebp)
  801764:	50                   	push   %eax
  801765:	e8 5d ff ff ff       	call   8016c7 <fstat>
  80176a:	89 c6                	mov    %eax,%esi
	close(fd);
  80176c:	89 1c 24             	mov    %ebx,(%esp)
  80176f:	e8 fd fb ff ff       	call   801371 <close>
	return r;
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 f3                	mov    %esi,%ebx
}
  801779:	89 d8                	mov    %ebx,%eax
  80177b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177e:	5b                   	pop    %ebx
  80177f:	5e                   	pop    %esi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	89 c6                	mov    %eax,%esi
  801789:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80178b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801792:	74 27                	je     8017bb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801794:	6a 07                	push   $0x7
  801796:	68 00 50 80 00       	push   $0x805000
  80179b:	56                   	push   %esi
  80179c:	ff 35 00 40 80 00    	pushl  0x804000
  8017a2:	e8 5e 08 00 00       	call   802005 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017a7:	83 c4 0c             	add    $0xc,%esp
  8017aa:	6a 00                	push   $0x0
  8017ac:	53                   	push   %ebx
  8017ad:	6a 00                	push   $0x0
  8017af:	e8 e4 07 00 00       	call   801f98 <ipc_recv>
}
  8017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5d                   	pop    %ebp
  8017ba:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017bb:	83 ec 0c             	sub    $0xc,%esp
  8017be:	6a 01                	push   $0x1
  8017c0:	e8 9a 08 00 00       	call   80205f <ipc_find_env>
  8017c5:	a3 00 40 80 00       	mov    %eax,0x804000
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	eb c5                	jmp    801794 <fsipc+0x12>

008017cf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017cf:	f3 0f 1e fb          	endbr32 
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f6:	e8 87 ff ff ff       	call   801782 <fsipc>
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <devfile_flush>:
{
  8017fd:	f3 0f 1e fb          	endbr32 
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 40 0c             	mov    0xc(%eax),%eax
  80180d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801812:	ba 00 00 00 00       	mov    $0x0,%edx
  801817:	b8 06 00 00 00       	mov    $0x6,%eax
  80181c:	e8 61 ff ff ff       	call   801782 <fsipc>
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <devfile_stat>:
{
  801823:	f3 0f 1e fb          	endbr32 
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	8b 40 0c             	mov    0xc(%eax),%eax
  801837:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80183c:	ba 00 00 00 00       	mov    $0x0,%edx
  801841:	b8 05 00 00 00       	mov    $0x5,%eax
  801846:	e8 37 ff ff ff       	call   801782 <fsipc>
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 2c                	js     80187b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	68 00 50 80 00       	push   $0x805000
  801857:	53                   	push   %ebx
  801858:	e8 e3 ef ff ff       	call   800840 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80185d:	a1 80 50 80 00       	mov    0x805080,%eax
  801862:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801868:	a1 84 50 80 00       	mov    0x805084,%eax
  80186d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <devfile_write>:
{
  801880:	f3 0f 1e fb          	endbr32 
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	8b 45 10             	mov    0x10(%ebp),%eax
  80188d:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801892:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801897:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80189a:	8b 55 08             	mov    0x8(%ebp),%edx
  80189d:	8b 52 0c             	mov    0xc(%edx),%edx
  8018a0:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8018a6:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  8018ab:	50                   	push   %eax
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	68 08 50 80 00       	push   $0x805008
  8018b4:	e8 3d f1 ff ff       	call   8009f6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018be:	b8 04 00 00 00       	mov    $0x4,%eax
  8018c3:	e8 ba fe ff ff       	call   801782 <fsipc>
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <devfile_read>:
{
  8018ca:	f3 0f 1e fb          	endbr32 
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	56                   	push   %esi
  8018d2:	53                   	push   %ebx
  8018d3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018e1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8018f1:	e8 8c fe ff ff       	call   801782 <fsipc>
  8018f6:	89 c3                	mov    %eax,%ebx
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	78 1f                	js     80191b <devfile_read+0x51>
	assert(r <= n);
  8018fc:	39 f0                	cmp    %esi,%eax
  8018fe:	77 24                	ja     801924 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801900:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801905:	7f 33                	jg     80193a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	50                   	push   %eax
  80190b:	68 00 50 80 00       	push   $0x805000
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	e8 de f0 ff ff       	call   8009f6 <memmove>
	return r;
  801918:	83 c4 10             	add    $0x10,%esp
}
  80191b:	89 d8                	mov    %ebx,%eax
  80191d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801920:	5b                   	pop    %ebx
  801921:	5e                   	pop    %esi
  801922:	5d                   	pop    %ebp
  801923:	c3                   	ret    
	assert(r <= n);
  801924:	68 f8 28 80 00       	push   $0x8028f8
  801929:	68 ff 28 80 00       	push   $0x8028ff
  80192e:	6a 7d                	push   $0x7d
  801930:	68 14 29 80 00       	push   $0x802914
  801935:	e8 15 e8 ff ff       	call   80014f <_panic>
	assert(r <= PGSIZE);
  80193a:	68 1f 29 80 00       	push   $0x80291f
  80193f:	68 ff 28 80 00       	push   $0x8028ff
  801944:	6a 7e                	push   $0x7e
  801946:	68 14 29 80 00       	push   $0x802914
  80194b:	e8 ff e7 ff ff       	call   80014f <_panic>

00801950 <open>:
{
  801950:	f3 0f 1e fb          	endbr32 
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	56                   	push   %esi
  801958:	53                   	push   %ebx
  801959:	83 ec 1c             	sub    $0x1c,%esp
  80195c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80195f:	56                   	push   %esi
  801960:	e8 98 ee ff ff       	call   8007fd <strlen>
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80196d:	7f 6c                	jg     8019db <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80196f:	83 ec 0c             	sub    $0xc,%esp
  801972:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801975:	50                   	push   %eax
  801976:	e8 67 f8 ff ff       	call   8011e2 <fd_alloc>
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	78 3c                	js     8019c0 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	56                   	push   %esi
  801988:	68 00 50 80 00       	push   $0x805000
  80198d:	e8 ae ee ff ff       	call   800840 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801992:	8b 45 0c             	mov    0xc(%ebp),%eax
  801995:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80199a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199d:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a2:	e8 db fd ff ff       	call   801782 <fsipc>
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 19                	js     8019c9 <open+0x79>
	return fd2num(fd);
  8019b0:	83 ec 0c             	sub    $0xc,%esp
  8019b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b6:	e8 f8 f7 ff ff       	call   8011b3 <fd2num>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	83 c4 10             	add    $0x10,%esp
}
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    
		fd_close(fd, 0);
  8019c9:	83 ec 08             	sub    $0x8,%esp
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d1:	e8 10 f9 ff ff       	call   8012e6 <fd_close>
		return r;
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	eb e5                	jmp    8019c0 <open+0x70>
		return -E_BAD_PATH;
  8019db:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019e0:	eb de                	jmp    8019c0 <open+0x70>

008019e2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019e2:	f3 0f 1e fb          	endbr32 
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f6:	e8 87 fd ff ff       	call   801782 <fsipc>
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019fd:	f3 0f 1e fb          	endbr32 
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	56                   	push   %esi
  801a05:	53                   	push   %ebx
  801a06:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	e8 b3 f7 ff ff       	call   8011c7 <fd2data>
  801a14:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a16:	83 c4 08             	add    $0x8,%esp
  801a19:	68 2b 29 80 00       	push   $0x80292b
  801a1e:	53                   	push   %ebx
  801a1f:	e8 1c ee ff ff       	call   800840 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a24:	8b 46 04             	mov    0x4(%esi),%eax
  801a27:	2b 06                	sub    (%esi),%eax
  801a29:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a2f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a36:	00 00 00 
	stat->st_dev = &devpipe;
  801a39:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a40:	30 80 00 
	return 0;
}
  801a43:	b8 00 00 00 00       	mov    $0x0,%eax
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a4f:	f3 0f 1e fb          	endbr32 
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	53                   	push   %ebx
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a5d:	53                   	push   %ebx
  801a5e:	6a 00                	push   $0x0
  801a60:	e8 aa f2 ff ff       	call   800d0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a65:	89 1c 24             	mov    %ebx,(%esp)
  801a68:	e8 5a f7 ff ff       	call   8011c7 <fd2data>
  801a6d:	83 c4 08             	add    $0x8,%esp
  801a70:	50                   	push   %eax
  801a71:	6a 00                	push   $0x0
  801a73:	e8 97 f2 ff ff       	call   800d0f <sys_page_unmap>
}
  801a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <_pipeisclosed>:
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	57                   	push   %edi
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	83 ec 1c             	sub    $0x1c,%esp
  801a86:	89 c7                	mov    %eax,%edi
  801a88:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a8a:	a1 08 40 80 00       	mov    0x804008,%eax
  801a8f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a92:	83 ec 0c             	sub    $0xc,%esp
  801a95:	57                   	push   %edi
  801a96:	e8 01 06 00 00       	call   80209c <pageref>
  801a9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a9e:	89 34 24             	mov    %esi,(%esp)
  801aa1:	e8 f6 05 00 00       	call   80209c <pageref>
		nn = thisenv->env_runs;
  801aa6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801aac:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	39 cb                	cmp    %ecx,%ebx
  801ab4:	74 1b                	je     801ad1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ab6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ab9:	75 cf                	jne    801a8a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801abb:	8b 42 58             	mov    0x58(%edx),%eax
  801abe:	6a 01                	push   $0x1
  801ac0:	50                   	push   %eax
  801ac1:	53                   	push   %ebx
  801ac2:	68 32 29 80 00       	push   $0x802932
  801ac7:	e8 6a e7 ff ff       	call   800236 <cprintf>
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	eb b9                	jmp    801a8a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ad1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ad4:	0f 94 c0             	sete   %al
  801ad7:	0f b6 c0             	movzbl %al,%eax
}
  801ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801add:	5b                   	pop    %ebx
  801ade:	5e                   	pop    %esi
  801adf:	5f                   	pop    %edi
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    

00801ae2 <devpipe_write>:
{
  801ae2:	f3 0f 1e fb          	endbr32 
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	57                   	push   %edi
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 28             	sub    $0x28,%esp
  801aef:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801af2:	56                   	push   %esi
  801af3:	e8 cf f6 ff ff       	call   8011c7 <fd2data>
  801af8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	bf 00 00 00 00       	mov    $0x0,%edi
  801b02:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b05:	74 4f                	je     801b56 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b07:	8b 43 04             	mov    0x4(%ebx),%eax
  801b0a:	8b 0b                	mov    (%ebx),%ecx
  801b0c:	8d 51 20             	lea    0x20(%ecx),%edx
  801b0f:	39 d0                	cmp    %edx,%eax
  801b11:	72 14                	jb     801b27 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801b13:	89 da                	mov    %ebx,%edx
  801b15:	89 f0                	mov    %esi,%eax
  801b17:	e8 61 ff ff ff       	call   801a7d <_pipeisclosed>
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	75 3b                	jne    801b5b <devpipe_write+0x79>
			sys_yield();
  801b20:	e8 3a f1 ff ff       	call   800c5f <sys_yield>
  801b25:	eb e0                	jmp    801b07 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b2a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b2e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b31:	89 c2                	mov    %eax,%edx
  801b33:	c1 fa 1f             	sar    $0x1f,%edx
  801b36:	89 d1                	mov    %edx,%ecx
  801b38:	c1 e9 1b             	shr    $0x1b,%ecx
  801b3b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b3e:	83 e2 1f             	and    $0x1f,%edx
  801b41:	29 ca                	sub    %ecx,%edx
  801b43:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b47:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b4b:	83 c0 01             	add    $0x1,%eax
  801b4e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b51:	83 c7 01             	add    $0x1,%edi
  801b54:	eb ac                	jmp    801b02 <devpipe_write+0x20>
	return i;
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
  801b59:	eb 05                	jmp    801b60 <devpipe_write+0x7e>
				return 0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5f                   	pop    %edi
  801b66:	5d                   	pop    %ebp
  801b67:	c3                   	ret    

00801b68 <devpipe_read>:
{
  801b68:	f3 0f 1e fb          	endbr32 
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	57                   	push   %edi
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
  801b72:	83 ec 18             	sub    $0x18,%esp
  801b75:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b78:	57                   	push   %edi
  801b79:	e8 49 f6 ff ff       	call   8011c7 <fd2data>
  801b7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	be 00 00 00 00       	mov    $0x0,%esi
  801b88:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b8b:	75 14                	jne    801ba1 <devpipe_read+0x39>
	return i;
  801b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b90:	eb 02                	jmp    801b94 <devpipe_read+0x2c>
				return i;
  801b92:	89 f0                	mov    %esi,%eax
}
  801b94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5f                   	pop    %edi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
			sys_yield();
  801b9c:	e8 be f0 ff ff       	call   800c5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ba1:	8b 03                	mov    (%ebx),%eax
  801ba3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ba6:	75 18                	jne    801bc0 <devpipe_read+0x58>
			if (i > 0)
  801ba8:	85 f6                	test   %esi,%esi
  801baa:	75 e6                	jne    801b92 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801bac:	89 da                	mov    %ebx,%edx
  801bae:	89 f8                	mov    %edi,%eax
  801bb0:	e8 c8 fe ff ff       	call   801a7d <_pipeisclosed>
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	74 e3                	je     801b9c <devpipe_read+0x34>
				return 0;
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbe:	eb d4                	jmp    801b94 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bc0:	99                   	cltd   
  801bc1:	c1 ea 1b             	shr    $0x1b,%edx
  801bc4:	01 d0                	add    %edx,%eax
  801bc6:	83 e0 1f             	and    $0x1f,%eax
  801bc9:	29 d0                	sub    %edx,%eax
  801bcb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bd6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bd9:	83 c6 01             	add    $0x1,%esi
  801bdc:	eb aa                	jmp    801b88 <devpipe_read+0x20>

00801bde <pipe>:
{
  801bde:	f3 0f 1e fb          	endbr32 
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
  801be7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bed:	50                   	push   %eax
  801bee:	e8 ef f5 ff ff       	call   8011e2 <fd_alloc>
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	0f 88 23 01 00 00    	js     801d23 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 07 04 00 00       	push   $0x407
  801c08:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0b:	6a 00                	push   $0x0
  801c0d:	e8 70 f0 ff ff       	call   800c82 <sys_page_alloc>
  801c12:	89 c3                	mov    %eax,%ebx
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	85 c0                	test   %eax,%eax
  801c19:	0f 88 04 01 00 00    	js     801d23 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c25:	50                   	push   %eax
  801c26:	e8 b7 f5 ff ff       	call   8011e2 <fd_alloc>
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	85 c0                	test   %eax,%eax
  801c32:	0f 88 db 00 00 00    	js     801d13 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	68 07 04 00 00       	push   $0x407
  801c40:	ff 75 f0             	pushl  -0x10(%ebp)
  801c43:	6a 00                	push   $0x0
  801c45:	e8 38 f0 ff ff       	call   800c82 <sys_page_alloc>
  801c4a:	89 c3                	mov    %eax,%ebx
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	0f 88 bc 00 00 00    	js     801d13 <pipe+0x135>
	va = fd2data(fd0);
  801c57:	83 ec 0c             	sub    $0xc,%esp
  801c5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5d:	e8 65 f5 ff ff       	call   8011c7 <fd2data>
  801c62:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c64:	83 c4 0c             	add    $0xc,%esp
  801c67:	68 07 04 00 00       	push   $0x407
  801c6c:	50                   	push   %eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	e8 0e f0 ff ff       	call   800c82 <sys_page_alloc>
  801c74:	89 c3                	mov    %eax,%ebx
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	0f 88 82 00 00 00    	js     801d03 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 f0             	pushl  -0x10(%ebp)
  801c87:	e8 3b f5 ff ff       	call   8011c7 <fd2data>
  801c8c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c93:	50                   	push   %eax
  801c94:	6a 00                	push   $0x0
  801c96:	56                   	push   %esi
  801c97:	6a 00                	push   $0x0
  801c99:	e8 2b f0 ff ff       	call   800cc9 <sys_page_map>
  801c9e:	89 c3                	mov    %eax,%ebx
  801ca0:	83 c4 20             	add    $0x20,%esp
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 4e                	js     801cf5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ca7:	a1 20 30 80 00       	mov    0x803020,%eax
  801cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801caf:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cb4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801cbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cbe:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd0:	e8 de f4 ff ff       	call   8011b3 <fd2num>
  801cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cda:	83 c4 04             	add    $0x4,%esp
  801cdd:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce0:	e8 ce f4 ff ff       	call   8011b3 <fd2num>
  801ce5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf3:	eb 2e                	jmp    801d23 <pipe+0x145>
	sys_page_unmap(0, va);
  801cf5:	83 ec 08             	sub    $0x8,%esp
  801cf8:	56                   	push   %esi
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 0f f0 ff ff       	call   800d0f <sys_page_unmap>
  801d00:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d03:	83 ec 08             	sub    $0x8,%esp
  801d06:	ff 75 f0             	pushl  -0x10(%ebp)
  801d09:	6a 00                	push   $0x0
  801d0b:	e8 ff ef ff ff       	call   800d0f <sys_page_unmap>
  801d10:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	ff 75 f4             	pushl  -0xc(%ebp)
  801d19:	6a 00                	push   $0x0
  801d1b:	e8 ef ef ff ff       	call   800d0f <sys_page_unmap>
  801d20:	83 c4 10             	add    $0x10,%esp
}
  801d23:	89 d8                	mov    %ebx,%eax
  801d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    

00801d2c <pipeisclosed>:
{
  801d2c:	f3 0f 1e fb          	endbr32 
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d39:	50                   	push   %eax
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	e8 f6 f4 ff ff       	call   801238 <fd_lookup>
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 18                	js     801d61 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4f:	e8 73 f4 ff ff       	call   8011c7 <fd2data>
  801d54:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	e8 1f fd ff ff       	call   801a7d <_pipeisclosed>
  801d5e:	83 c4 10             	add    $0x10,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d63:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6c:	c3                   	ret    

00801d6d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d6d:	f3 0f 1e fb          	endbr32 
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d77:	68 4a 29 80 00       	push   $0x80294a
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	e8 bc ea ff ff       	call   800840 <strcpy>
	return 0;
}
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <devcons_write>:
{
  801d8b:	f3 0f 1e fb          	endbr32 
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	57                   	push   %edi
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d9b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801da0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801da6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da9:	73 31                	jae    801ddc <devcons_write+0x51>
		m = n - tot;
  801dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dae:	29 f3                	sub    %esi,%ebx
  801db0:	83 fb 7f             	cmp    $0x7f,%ebx
  801db3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801db8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	53                   	push   %ebx
  801dbf:	89 f0                	mov    %esi,%eax
  801dc1:	03 45 0c             	add    0xc(%ebp),%eax
  801dc4:	50                   	push   %eax
  801dc5:	57                   	push   %edi
  801dc6:	e8 2b ec ff ff       	call   8009f6 <memmove>
		sys_cputs(buf, m);
  801dcb:	83 c4 08             	add    $0x8,%esp
  801dce:	53                   	push   %ebx
  801dcf:	57                   	push   %edi
  801dd0:	e8 dd ed ff ff       	call   800bb2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801dd5:	01 de                	add    %ebx,%esi
  801dd7:	83 c4 10             	add    $0x10,%esp
  801dda:	eb ca                	jmp    801da6 <devcons_write+0x1b>
}
  801ddc:	89 f0                	mov    %esi,%eax
  801dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5f                   	pop    %edi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <devcons_read>:
{
  801de6:	f3 0f 1e fb          	endbr32 
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801df5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df9:	74 21                	je     801e1c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801dfb:	e8 d4 ed ff ff       	call   800bd4 <sys_cgetc>
  801e00:	85 c0                	test   %eax,%eax
  801e02:	75 07                	jne    801e0b <devcons_read+0x25>
		sys_yield();
  801e04:	e8 56 ee ff ff       	call   800c5f <sys_yield>
  801e09:	eb f0                	jmp    801dfb <devcons_read+0x15>
	if (c < 0)
  801e0b:	78 0f                	js     801e1c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801e0d:	83 f8 04             	cmp    $0x4,%eax
  801e10:	74 0c                	je     801e1e <devcons_read+0x38>
	*(char*)vbuf = c;
  801e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e15:	88 02                	mov    %al,(%edx)
	return 1;
  801e17:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    
		return 0;
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e23:	eb f7                	jmp    801e1c <devcons_read+0x36>

00801e25 <cputchar>:
{
  801e25:	f3 0f 1e fb          	endbr32 
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e35:	6a 01                	push   $0x1
  801e37:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e3a:	50                   	push   %eax
  801e3b:	e8 72 ed ff ff       	call   800bb2 <sys_cputs>
}
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <getchar>:
{
  801e45:	f3 0f 1e fb          	endbr32 
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e4f:	6a 01                	push   $0x1
  801e51:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e54:	50                   	push   %eax
  801e55:	6a 00                	push   $0x0
  801e57:	e8 5f f6 ff ff       	call   8014bb <read>
	if (r < 0)
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	78 06                	js     801e69 <getchar+0x24>
	if (r < 1)
  801e63:	74 06                	je     801e6b <getchar+0x26>
	return c;
  801e65:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    
		return -E_EOF;
  801e6b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e70:	eb f7                	jmp    801e69 <getchar+0x24>

00801e72 <iscons>:
{
  801e72:	f3 0f 1e fb          	endbr32 
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e7f:	50                   	push   %eax
  801e80:	ff 75 08             	pushl  0x8(%ebp)
  801e83:	e8 b0 f3 ff ff       	call   801238 <fd_lookup>
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	78 11                	js     801ea0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e98:	39 10                	cmp    %edx,(%eax)
  801e9a:	0f 94 c0             	sete   %al
  801e9d:	0f b6 c0             	movzbl %al,%eax
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <opencons>:
{
  801ea2:	f3 0f 1e fb          	endbr32 
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eaf:	50                   	push   %eax
  801eb0:	e8 2d f3 ff ff       	call   8011e2 <fd_alloc>
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	78 3a                	js     801ef6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ebc:	83 ec 04             	sub    $0x4,%esp
  801ebf:	68 07 04 00 00       	push   $0x407
  801ec4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec7:	6a 00                	push   $0x0
  801ec9:	e8 b4 ed ff ff       	call   800c82 <sys_page_alloc>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	78 21                	js     801ef6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ede:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	50                   	push   %eax
  801eee:	e8 c0 f2 ff ff       	call   8011b3 <fd2num>
  801ef3:	83 c4 10             	add    $0x10,%esp
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ef8:	f3 0f 1e fb          	endbr32 
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	53                   	push   %ebx
  801f00:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f03:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f0a:	74 0d                	je     801f19 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    
		envid_t envid=sys_getenvid();
  801f19:	e8 1e ed ff ff       	call   800c3c <sys_getenvid>
  801f1e:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	6a 07                	push   $0x7
  801f25:	68 00 f0 bf ee       	push   $0xeebff000
  801f2a:	50                   	push   %eax
  801f2b:	e8 52 ed ff ff       	call   800c82 <sys_page_alloc>
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	78 29                	js     801f60 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  801f37:	83 ec 08             	sub    $0x8,%esp
  801f3a:	68 74 1f 80 00       	push   $0x801f74
  801f3f:	53                   	push   %ebx
  801f40:	e8 9c ee ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	79 c0                	jns    801f0c <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	68 84 29 80 00       	push   $0x802984
  801f54:	6a 24                	push   $0x24
  801f56:	68 bb 29 80 00       	push   $0x8029bb
  801f5b:	e8 ef e1 ff ff       	call   80014f <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	68 58 29 80 00       	push   $0x802958
  801f68:	6a 22                	push   $0x22
  801f6a:	68 bb 29 80 00       	push   $0x8029bb
  801f6f:	e8 db e1 ff ff       	call   80014f <_panic>

00801f74 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f74:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f75:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f7a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f7c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  801f7f:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  801f82:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  801f86:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  801f8b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  801f8f:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801f91:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  801f92:	83 c4 04             	add    $0x4,%esp
	popfl
  801f95:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f96:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801f97:	c3                   	ret    

00801f98 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f98:	f3 0f 1e fb          	endbr32 
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	56                   	push   %esi
  801fa0:	53                   	push   %ebx
  801fa1:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801faa:	85 c0                	test   %eax,%eax
  801fac:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fb1:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	50                   	push   %eax
  801fb8:	e8 91 ee ff ff       	call   800e4e <sys_ipc_recv>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 2b                	js     801fef <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801fc4:	85 f6                	test   %esi,%esi
  801fc6:	74 0a                	je     801fd2 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801fc8:	a1 08 40 80 00       	mov    0x804008,%eax
  801fcd:	8b 40 74             	mov    0x74(%eax),%eax
  801fd0:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801fd2:	85 db                	test   %ebx,%ebx
  801fd4:	74 0a                	je     801fe0 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801fd6:	a1 08 40 80 00       	mov    0x804008,%eax
  801fdb:	8b 40 78             	mov    0x78(%eax),%eax
  801fde:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801fe0:	a1 08 40 80 00       	mov    0x804008,%eax
  801fe5:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fe8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    
		if(from_env_store)
  801fef:	85 f6                	test   %esi,%esi
  801ff1:	74 06                	je     801ff9 <ipc_recv+0x61>
			*from_env_store=0;
  801ff3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801ff9:	85 db                	test   %ebx,%ebx
  801ffb:	74 eb                	je     801fe8 <ipc_recv+0x50>
			*perm_store=0;
  801ffd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802003:	eb e3                	jmp    801fe8 <ipc_recv+0x50>

00802005 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802005:	f3 0f 1e fb          	endbr32 
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	57                   	push   %edi
  80200d:	56                   	push   %esi
  80200e:	53                   	push   %ebx
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	8b 7d 08             	mov    0x8(%ebp),%edi
  802015:	8b 75 0c             	mov    0xc(%ebp),%esi
  802018:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80201b:	85 db                	test   %ebx,%ebx
  80201d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802022:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802025:	ff 75 14             	pushl  0x14(%ebp)
  802028:	53                   	push   %ebx
  802029:	56                   	push   %esi
  80202a:	57                   	push   %edi
  80202b:	e8 f7 ed ff ff       	call   800e27 <sys_ipc_try_send>
		if(!res)
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	85 c0                	test   %eax,%eax
  802035:	74 20                	je     802057 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802037:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80203a:	75 07                	jne    802043 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80203c:	e8 1e ec ff ff       	call   800c5f <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802041:	eb e2                	jmp    802025 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 c9 29 80 00       	push   $0x8029c9
  80204b:	6a 3f                	push   $0x3f
  80204d:	68 e1 29 80 00       	push   $0x8029e1
  802052:	e8 f8 e0 ff ff       	call   80014f <_panic>
	}
}
  802057:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205a:	5b                   	pop    %ebx
  80205b:	5e                   	pop    %esi
  80205c:	5f                   	pop    %edi
  80205d:	5d                   	pop    %ebp
  80205e:	c3                   	ret    

0080205f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80205f:	f3 0f 1e fb          	endbr32 
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80206e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802071:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802077:	8b 52 50             	mov    0x50(%edx),%edx
  80207a:	39 ca                	cmp    %ecx,%edx
  80207c:	74 11                	je     80208f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80207e:	83 c0 01             	add    $0x1,%eax
  802081:	3d 00 04 00 00       	cmp    $0x400,%eax
  802086:	75 e6                	jne    80206e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
  80208d:	eb 0b                	jmp    80209a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80208f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802092:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802097:	8b 40 48             	mov    0x48(%eax),%eax
}
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    

0080209c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80209c:	f3 0f 1e fb          	endbr32 
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020a6:	89 c2                	mov    %eax,%edx
  8020a8:	c1 ea 16             	shr    $0x16,%edx
  8020ab:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020b2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020b7:	f6 c1 01             	test   $0x1,%cl
  8020ba:	74 1c                	je     8020d8 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020bc:	c1 e8 0c             	shr    $0xc,%eax
  8020bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020c6:	a8 01                	test   $0x1,%al
  8020c8:	74 0e                	je     8020d8 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ca:	c1 e8 0c             	shr    $0xc,%eax
  8020cd:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020d4:	ef 
  8020d5:	0f b7 d2             	movzwl %dx,%edx
}
  8020d8:	89 d0                	mov    %edx,%eax
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    
  8020dc:	66 90                	xchg   %ax,%ax
  8020de:	66 90                	xchg   %ax,%ax

008020e0 <__udivdi3>:
  8020e0:	f3 0f 1e fb          	endbr32 
  8020e4:	55                   	push   %ebp
  8020e5:	57                   	push   %edi
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
  8020e8:	83 ec 1c             	sub    $0x1c,%esp
  8020eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020fb:	85 d2                	test   %edx,%edx
  8020fd:	75 19                	jne    802118 <__udivdi3+0x38>
  8020ff:	39 f3                	cmp    %esi,%ebx
  802101:	76 4d                	jbe    802150 <__udivdi3+0x70>
  802103:	31 ff                	xor    %edi,%edi
  802105:	89 e8                	mov    %ebp,%eax
  802107:	89 f2                	mov    %esi,%edx
  802109:	f7 f3                	div    %ebx
  80210b:	89 fa                	mov    %edi,%edx
  80210d:	83 c4 1c             	add    $0x1c,%esp
  802110:	5b                   	pop    %ebx
  802111:	5e                   	pop    %esi
  802112:	5f                   	pop    %edi
  802113:	5d                   	pop    %ebp
  802114:	c3                   	ret    
  802115:	8d 76 00             	lea    0x0(%esi),%esi
  802118:	39 f2                	cmp    %esi,%edx
  80211a:	76 14                	jbe    802130 <__udivdi3+0x50>
  80211c:	31 ff                	xor    %edi,%edi
  80211e:	31 c0                	xor    %eax,%eax
  802120:	89 fa                	mov    %edi,%edx
  802122:	83 c4 1c             	add    $0x1c,%esp
  802125:	5b                   	pop    %ebx
  802126:	5e                   	pop    %esi
  802127:	5f                   	pop    %edi
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    
  80212a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802130:	0f bd fa             	bsr    %edx,%edi
  802133:	83 f7 1f             	xor    $0x1f,%edi
  802136:	75 48                	jne    802180 <__udivdi3+0xa0>
  802138:	39 f2                	cmp    %esi,%edx
  80213a:	72 06                	jb     802142 <__udivdi3+0x62>
  80213c:	31 c0                	xor    %eax,%eax
  80213e:	39 eb                	cmp    %ebp,%ebx
  802140:	77 de                	ja     802120 <__udivdi3+0x40>
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	eb d7                	jmp    802120 <__udivdi3+0x40>
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	89 d9                	mov    %ebx,%ecx
  802152:	85 db                	test   %ebx,%ebx
  802154:	75 0b                	jne    802161 <__udivdi3+0x81>
  802156:	b8 01 00 00 00       	mov    $0x1,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	f7 f3                	div    %ebx
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	31 d2                	xor    %edx,%edx
  802163:	89 f0                	mov    %esi,%eax
  802165:	f7 f1                	div    %ecx
  802167:	89 c6                	mov    %eax,%esi
  802169:	89 e8                	mov    %ebp,%eax
  80216b:	89 f7                	mov    %esi,%edi
  80216d:	f7 f1                	div    %ecx
  80216f:	89 fa                	mov    %edi,%edx
  802171:	83 c4 1c             	add    $0x1c,%esp
  802174:	5b                   	pop    %ebx
  802175:	5e                   	pop    %esi
  802176:	5f                   	pop    %edi
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    
  802179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802180:	89 f9                	mov    %edi,%ecx
  802182:	b8 20 00 00 00       	mov    $0x20,%eax
  802187:	29 f8                	sub    %edi,%eax
  802189:	d3 e2                	shl    %cl,%edx
  80218b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80218f:	89 c1                	mov    %eax,%ecx
  802191:	89 da                	mov    %ebx,%edx
  802193:	d3 ea                	shr    %cl,%edx
  802195:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802199:	09 d1                	or     %edx,%ecx
  80219b:	89 f2                	mov    %esi,%edx
  80219d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021a1:	89 f9                	mov    %edi,%ecx
  8021a3:	d3 e3                	shl    %cl,%ebx
  8021a5:	89 c1                	mov    %eax,%ecx
  8021a7:	d3 ea                	shr    %cl,%edx
  8021a9:	89 f9                	mov    %edi,%ecx
  8021ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021af:	89 eb                	mov    %ebp,%ebx
  8021b1:	d3 e6                	shl    %cl,%esi
  8021b3:	89 c1                	mov    %eax,%ecx
  8021b5:	d3 eb                	shr    %cl,%ebx
  8021b7:	09 de                	or     %ebx,%esi
  8021b9:	89 f0                	mov    %esi,%eax
  8021bb:	f7 74 24 08          	divl   0x8(%esp)
  8021bf:	89 d6                	mov    %edx,%esi
  8021c1:	89 c3                	mov    %eax,%ebx
  8021c3:	f7 64 24 0c          	mull   0xc(%esp)
  8021c7:	39 d6                	cmp    %edx,%esi
  8021c9:	72 15                	jb     8021e0 <__udivdi3+0x100>
  8021cb:	89 f9                	mov    %edi,%ecx
  8021cd:	d3 e5                	shl    %cl,%ebp
  8021cf:	39 c5                	cmp    %eax,%ebp
  8021d1:	73 04                	jae    8021d7 <__udivdi3+0xf7>
  8021d3:	39 d6                	cmp    %edx,%esi
  8021d5:	74 09                	je     8021e0 <__udivdi3+0x100>
  8021d7:	89 d8                	mov    %ebx,%eax
  8021d9:	31 ff                	xor    %edi,%edi
  8021db:	e9 40 ff ff ff       	jmp    802120 <__udivdi3+0x40>
  8021e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021e3:	31 ff                	xor    %edi,%edi
  8021e5:	e9 36 ff ff ff       	jmp    802120 <__udivdi3+0x40>
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	f3 0f 1e fb          	endbr32 
  8021f4:	55                   	push   %ebp
  8021f5:	57                   	push   %edi
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	83 ec 1c             	sub    $0x1c,%esp
  8021fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802203:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802207:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80220b:	85 c0                	test   %eax,%eax
  80220d:	75 19                	jne    802228 <__umoddi3+0x38>
  80220f:	39 df                	cmp    %ebx,%edi
  802211:	76 5d                	jbe    802270 <__umoddi3+0x80>
  802213:	89 f0                	mov    %esi,%eax
  802215:	89 da                	mov    %ebx,%edx
  802217:	f7 f7                	div    %edi
  802219:	89 d0                	mov    %edx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	89 f2                	mov    %esi,%edx
  80222a:	39 d8                	cmp    %ebx,%eax
  80222c:	76 12                	jbe    802240 <__umoddi3+0x50>
  80222e:	89 f0                	mov    %esi,%eax
  802230:	89 da                	mov    %ebx,%edx
  802232:	83 c4 1c             	add    $0x1c,%esp
  802235:	5b                   	pop    %ebx
  802236:	5e                   	pop    %esi
  802237:	5f                   	pop    %edi
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    
  80223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802240:	0f bd e8             	bsr    %eax,%ebp
  802243:	83 f5 1f             	xor    $0x1f,%ebp
  802246:	75 50                	jne    802298 <__umoddi3+0xa8>
  802248:	39 d8                	cmp    %ebx,%eax
  80224a:	0f 82 e0 00 00 00    	jb     802330 <__umoddi3+0x140>
  802250:	89 d9                	mov    %ebx,%ecx
  802252:	39 f7                	cmp    %esi,%edi
  802254:	0f 86 d6 00 00 00    	jbe    802330 <__umoddi3+0x140>
  80225a:	89 d0                	mov    %edx,%eax
  80225c:	89 ca                	mov    %ecx,%edx
  80225e:	83 c4 1c             	add    $0x1c,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    
  802266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80226d:	8d 76 00             	lea    0x0(%esi),%esi
  802270:	89 fd                	mov    %edi,%ebp
  802272:	85 ff                	test   %edi,%edi
  802274:	75 0b                	jne    802281 <__umoddi3+0x91>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f7                	div    %edi
  80227f:	89 c5                	mov    %eax,%ebp
  802281:	89 d8                	mov    %ebx,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f5                	div    %ebp
  802287:	89 f0                	mov    %esi,%eax
  802289:	f7 f5                	div    %ebp
  80228b:	89 d0                	mov    %edx,%eax
  80228d:	31 d2                	xor    %edx,%edx
  80228f:	eb 8c                	jmp    80221d <__umoddi3+0x2d>
  802291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802298:	89 e9                	mov    %ebp,%ecx
  80229a:	ba 20 00 00 00       	mov    $0x20,%edx
  80229f:	29 ea                	sub    %ebp,%edx
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a7:	89 d1                	mov    %edx,%ecx
  8022a9:	89 f8                	mov    %edi,%eax
  8022ab:	d3 e8                	shr    %cl,%eax
  8022ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022b9:	09 c1                	or     %eax,%ecx
  8022bb:	89 d8                	mov    %ebx,%eax
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 e9                	mov    %ebp,%ecx
  8022c3:	d3 e7                	shl    %cl,%edi
  8022c5:	89 d1                	mov    %edx,%ecx
  8022c7:	d3 e8                	shr    %cl,%eax
  8022c9:	89 e9                	mov    %ebp,%ecx
  8022cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022cf:	d3 e3                	shl    %cl,%ebx
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	89 d1                	mov    %edx,%ecx
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	d3 e8                	shr    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	89 fa                	mov    %edi,%edx
  8022dd:	d3 e6                	shl    %cl,%esi
  8022df:	09 d8                	or     %ebx,%eax
  8022e1:	f7 74 24 08          	divl   0x8(%esp)
  8022e5:	89 d1                	mov    %edx,%ecx
  8022e7:	89 f3                	mov    %esi,%ebx
  8022e9:	f7 64 24 0c          	mull   0xc(%esp)
  8022ed:	89 c6                	mov    %eax,%esi
  8022ef:	89 d7                	mov    %edx,%edi
  8022f1:	39 d1                	cmp    %edx,%ecx
  8022f3:	72 06                	jb     8022fb <__umoddi3+0x10b>
  8022f5:	75 10                	jne    802307 <__umoddi3+0x117>
  8022f7:	39 c3                	cmp    %eax,%ebx
  8022f9:	73 0c                	jae    802307 <__umoddi3+0x117>
  8022fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802303:	89 d7                	mov    %edx,%edi
  802305:	89 c6                	mov    %eax,%esi
  802307:	89 ca                	mov    %ecx,%edx
  802309:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80230e:	29 f3                	sub    %esi,%ebx
  802310:	19 fa                	sbb    %edi,%edx
  802312:	89 d0                	mov    %edx,%eax
  802314:	d3 e0                	shl    %cl,%eax
  802316:	89 e9                	mov    %ebp,%ecx
  802318:	d3 eb                	shr    %cl,%ebx
  80231a:	d3 ea                	shr    %cl,%edx
  80231c:	09 d8                	or     %ebx,%eax
  80231e:	83 c4 1c             	add    $0x1c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80232d:	8d 76 00             	lea    0x0(%esi),%esi
  802330:	29 fe                	sub    %edi,%esi
  802332:	19 c3                	sbb    %eax,%ebx
  802334:	89 f2                	mov    %esi,%edx
  802336:	89 d9                	mov    %ebx,%ecx
  802338:	e9 1d ff ff ff       	jmp    80225a <__umoddi3+0x6a>
