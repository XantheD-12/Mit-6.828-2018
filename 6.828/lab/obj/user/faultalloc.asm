
obj/user/faultalloc.debug：     文件格式 elf32-i386


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
  80002c:	e8 a1 00 00 00       	call   8000d2 <libmain>
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
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003e:	8b 45 08             	mov    0x8(%ebp),%eax
  800041:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800043:	53                   	push   %ebx
  800044:	68 20 20 80 00       	push   $0x802020
  800049:	e8 d3 01 00 00       	call   800221 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 0b 0c 00 00       	call   800c6d <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 6c 20 80 00       	push   $0x80206c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 53 07 00 00       	call   8007ca <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 40 20 80 00       	push   $0x802040
  800089:	6a 0e                	push   $0xe
  80008b:	68 2a 20 80 00       	push   $0x80202a
  800090:	e8 a5 00 00 00       	call   80013a <_panic>

00800095 <umain>:

void
umain(int argc, char **argv)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80009f:	68 33 00 80 00       	push   $0x800033
  8000a4:	e8 d5 0d 00 00       	call   800e7e <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	68 ef be ad de       	push   $0xdeadbeef
  8000b1:	68 3c 20 80 00       	push   $0x80203c
  8000b6:	e8 66 01 00 00       	call   800221 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	68 fe bf fe ca       	push   $0xcafebffe
  8000c3:	68 3c 20 80 00       	push   $0x80203c
  8000c8:	e8 54 01 00 00       	call   800221 <cprintf>
}
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	c9                   	leave  
  8000d1:	c3                   	ret    

008000d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e1:	e8 41 0b 00 00       	call   800c27 <sys_getenvid>
  8000e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f8:	85 db                	test   %ebx,%ebx
  8000fa:	7e 07                	jle    800103 <libmain+0x31>
		binaryname = argv[0];
  8000fc:	8b 06                	mov    (%esi),%eax
  8000fe:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	e8 88 ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  80010d:	e8 0a 00 00 00       	call   80011c <exit>
}
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5d                   	pop    %ebp
  80011b:	c3                   	ret    

0080011c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011c:	f3 0f 1e fb          	endbr32 
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800126:	e8 e2 0f 00 00       	call   80110d <close_all>
	sys_env_destroy(0);
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	6a 00                	push   $0x0
  800130:	e8 ad 0a 00 00       	call   800be2 <sys_env_destroy>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	c9                   	leave  
  800139:	c3                   	ret    

0080013a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013a:	f3 0f 1e fb          	endbr32 
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800143:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800146:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014c:	e8 d6 0a 00 00       	call   800c27 <sys_getenvid>
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	ff 75 0c             	pushl  0xc(%ebp)
  800157:	ff 75 08             	pushl  0x8(%ebp)
  80015a:	56                   	push   %esi
  80015b:	50                   	push   %eax
  80015c:	68 98 20 80 00       	push   $0x802098
  800161:	e8 bb 00 00 00       	call   800221 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800166:	83 c4 18             	add    $0x18,%esp
  800169:	53                   	push   %ebx
  80016a:	ff 75 10             	pushl  0x10(%ebp)
  80016d:	e8 5a 00 00 00       	call   8001cc <vcprintf>
	cprintf("\n");
  800172:	c7 04 24 37 25 80 00 	movl   $0x802537,(%esp)
  800179:	e8 a3 00 00 00       	call   800221 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800181:	cc                   	int3   
  800182:	eb fd                	jmp    800181 <_panic+0x47>

00800184 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800184:	f3 0f 1e fb          	endbr32 
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	53                   	push   %ebx
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800192:	8b 13                	mov    (%ebx),%edx
  800194:	8d 42 01             	lea    0x1(%edx),%eax
  800197:	89 03                	mov    %eax,(%ebx)
  800199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a5:	74 09                	je     8001b0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	68 ff 00 00 00       	push   $0xff
  8001b8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 dc 09 00 00       	call   800b9d <sys_cputs>
		b->idx = 0;
  8001c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb db                	jmp    8001a7 <putch+0x23>

008001cc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cc:	f3 0f 1e fb          	endbr32 
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e0:	00 00 00 
	b.cnt = 0;
  8001e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ed:	ff 75 0c             	pushl  0xc(%ebp)
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	68 84 01 80 00       	push   $0x800184
  8001ff:	e8 20 01 00 00       	call   800324 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800204:	83 c4 08             	add    $0x8,%esp
  800207:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	e8 84 09 00 00       	call   800b9d <sys_cputs>

	return b.cnt;
}
  800219:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800221:	f3 0f 1e fb          	endbr32 
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022e:	50                   	push   %eax
  80022f:	ff 75 08             	pushl  0x8(%ebp)
  800232:	e8 95 ff ff ff       	call   8001cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	57                   	push   %edi
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
  80023f:	83 ec 1c             	sub    $0x1c,%esp
  800242:	89 c7                	mov    %eax,%edi
  800244:	89 d6                	mov    %edx,%esi
  800246:	8b 45 08             	mov    0x8(%ebp),%eax
  800249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024c:	89 d1                	mov    %edx,%ecx
  80024e:	89 c2                	mov    %eax,%edx
  800250:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800253:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800256:	8b 45 10             	mov    0x10(%ebp),%eax
  800259:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800266:	39 c2                	cmp    %eax,%edx
  800268:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80026b:	72 3e                	jb     8002ab <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	ff 75 18             	pushl  0x18(%ebp)
  800273:	83 eb 01             	sub    $0x1,%ebx
  800276:	53                   	push   %ebx
  800277:	50                   	push   %eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	ff 75 d8             	pushl  -0x28(%ebp)
  800287:	e8 24 1b 00 00       	call   801db0 <__udivdi3>
  80028c:	83 c4 18             	add    $0x18,%esp
  80028f:	52                   	push   %edx
  800290:	50                   	push   %eax
  800291:	89 f2                	mov    %esi,%edx
  800293:	89 f8                	mov    %edi,%eax
  800295:	e8 9f ff ff ff       	call   800239 <printnum>
  80029a:	83 c4 20             	add    $0x20,%esp
  80029d:	eb 13                	jmp    8002b2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	56                   	push   %esi
  8002a3:	ff 75 18             	pushl  0x18(%ebp)
  8002a6:	ff d7                	call   *%edi
  8002a8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	85 db                	test   %ebx,%ebx
  8002b0:	7f ed                	jg     80029f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	56                   	push   %esi
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c5:	e8 f6 1b 00 00       	call   801ec0 <__umoddi3>
  8002ca:	83 c4 14             	add    $0x14,%esp
  8002cd:	0f be 80 bb 20 80 00 	movsbl 0x8020bb(%eax),%eax
  8002d4:	50                   	push   %eax
  8002d5:	ff d7                	call   *%edi
}
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dd:	5b                   	pop    %ebx
  8002de:	5e                   	pop    %esi
  8002df:	5f                   	pop    %edi
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e2:	f3 0f 1e fb          	endbr32 
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	f3 0f 1e fb          	endbr32 
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 05 00 00 00       	call   800324 <vprintfmt>
}
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <vprintfmt>:
{
  800324:	f3 0f 1e fb          	endbr32 
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 3c             	sub    $0x3c,%esp
  800331:	8b 75 08             	mov    0x8(%ebp),%esi
  800334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800337:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033a:	e9 8e 03 00 00       	jmp    8006cd <vprintfmt+0x3a9>
		padc = ' ';
  80033f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800343:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80034a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800351:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8d 47 01             	lea    0x1(%edi),%eax
  800360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800363:	0f b6 17             	movzbl (%edi),%edx
  800366:	8d 42 dd             	lea    -0x23(%edx),%eax
  800369:	3c 55                	cmp    $0x55,%al
  80036b:	0f 87 df 03 00 00    	ja     800750 <vprintfmt+0x42c>
  800371:	0f b6 c0             	movzbl %al,%eax
  800374:	3e ff 24 85 00 22 80 	notrack jmp *0x802200(,%eax,4)
  80037b:	00 
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800383:	eb d8                	jmp    80035d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800388:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80038c:	eb cf                	jmp    80035d <vprintfmt+0x39>
  80038e:	0f b6 d2             	movzbl %dl,%edx
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a9:	83 f9 09             	cmp    $0x9,%ecx
  8003ac:	77 55                	ja     800403 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003ae:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b1:	eb e9                	jmp    80039c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8d 40 04             	lea    0x4(%eax),%eax
  8003c1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003cb:	79 90                	jns    80035d <vprintfmt+0x39>
				width = precision, precision = -1;
  8003cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003da:	eb 81                	jmp    80035d <vprintfmt+0x39>
  8003dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	0f 49 d0             	cmovns %eax,%edx
  8003e9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ef:	e9 69 ff ff ff       	jmp    80035d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003fe:	e9 5a ff ff ff       	jmp    80035d <vprintfmt+0x39>
  800403:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800406:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800409:	eb bc                	jmp    8003c7 <vprintfmt+0xa3>
			lflag++;
  80040b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800411:	e9 47 ff ff ff       	jmp    80035d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8d 78 04             	lea    0x4(%eax),%edi
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	53                   	push   %ebx
  800420:	ff 30                	pushl  (%eax)
  800422:	ff d6                	call   *%esi
			break;
  800424:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800427:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042a:	e9 9b 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	8d 78 04             	lea    0x4(%eax),%edi
  800435:	8b 00                	mov    (%eax),%eax
  800437:	99                   	cltd   
  800438:	31 d0                	xor    %edx,%eax
  80043a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043c:	83 f8 0f             	cmp    $0xf,%eax
  80043f:	7f 23                	jg     800464 <vprintfmt+0x140>
  800441:	8b 14 85 60 23 80 00 	mov    0x802360(,%eax,4),%edx
  800448:	85 d2                	test   %edx,%edx
  80044a:	74 18                	je     800464 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80044c:	52                   	push   %edx
  80044d:	68 05 25 80 00       	push   $0x802505
  800452:	53                   	push   %ebx
  800453:	56                   	push   %esi
  800454:	e8 aa fe ff ff       	call   800303 <printfmt>
  800459:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045f:	e9 66 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800464:	50                   	push   %eax
  800465:	68 d3 20 80 00       	push   $0x8020d3
  80046a:	53                   	push   %ebx
  80046b:	56                   	push   %esi
  80046c:	e8 92 fe ff ff       	call   800303 <printfmt>
  800471:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800477:	e9 4e 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	83 c0 04             	add    $0x4,%eax
  800482:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80048a:	85 d2                	test   %edx,%edx
  80048c:	b8 cc 20 80 00       	mov    $0x8020cc,%eax
  800491:	0f 45 c2             	cmovne %edx,%eax
  800494:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800497:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049b:	7e 06                	jle    8004a3 <vprintfmt+0x17f>
  80049d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004a1:	75 0d                	jne    8004b0 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	eb 55                	jmp    800505 <vprintfmt+0x1e1>
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b6:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b9:	e8 46 03 00 00       	call   800804 <strnlen>
  8004be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c1:	29 c2                	sub    %eax,%edx
  8004c3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004cb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7e 11                	jle    8004e7 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	53                   	push   %ebx
  8004da:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	83 ef 01             	sub    $0x1,%edi
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	eb eb                	jmp    8004d2 <vprintfmt+0x1ae>
  8004e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ea:	85 d2                	test   %edx,%edx
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	0f 49 c2             	cmovns %edx,%eax
  8004f4:	29 c2                	sub    %eax,%edx
  8004f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f9:	eb a8                	jmp    8004a3 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	52                   	push   %edx
  800500:	ff d6                	call   *%esi
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800508:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800511:	0f be d0             	movsbl %al,%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	74 4b                	je     800563 <vprintfmt+0x23f>
  800518:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051c:	78 06                	js     800524 <vprintfmt+0x200>
  80051e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800522:	78 1e                	js     800542 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800528:	74 d1                	je     8004fb <vprintfmt+0x1d7>
  80052a:	0f be c0             	movsbl %al,%eax
  80052d:	83 e8 20             	sub    $0x20,%eax
  800530:	83 f8 5e             	cmp    $0x5e,%eax
  800533:	76 c6                	jbe    8004fb <vprintfmt+0x1d7>
					putch('?', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 3f                	push   $0x3f
  80053b:	ff d6                	call   *%esi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	eb c3                	jmp    800505 <vprintfmt+0x1e1>
  800542:	89 cf                	mov    %ecx,%edi
  800544:	eb 0e                	jmp    800554 <vprintfmt+0x230>
				putch(' ', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 20                	push   $0x20
  80054c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ee                	jg     800546 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800558:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	e9 67 01 00 00       	jmp    8006ca <vprintfmt+0x3a6>
  800563:	89 cf                	mov    %ecx,%edi
  800565:	eb ed                	jmp    800554 <vprintfmt+0x230>
	if (lflag >= 2)
  800567:	83 f9 01             	cmp    $0x1,%ecx
  80056a:	7f 1b                	jg     800587 <vprintfmt+0x263>
	else if (lflag)
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	74 63                	je     8005d3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb 17                	jmp    80059e <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 50 04             	mov    0x4(%eax),%edx
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 08             	lea    0x8(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a9:	85 c9                	test   %ecx,%ecx
  8005ab:	0f 89 ff 00 00 00    	jns    8006b0 <vprintfmt+0x38c>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2d                	push   $0x2d
  8005b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bf:	f7 da                	neg    %edx
  8005c1:	83 d1 00             	adc    $0x0,%ecx
  8005c4:	f7 d9                	neg    %ecx
  8005c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 dd 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	99                   	cltd   
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb b4                	jmp    80059e <vprintfmt+0x27a>
	if (lflag >= 2)
  8005ea:	83 f9 01             	cmp    $0x1,%ecx
  8005ed:	7f 1e                	jg     80060d <vprintfmt+0x2e9>
	else if (lflag)
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	74 32                	je     800625 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800608:	e9 a3 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 10                	mov    (%eax),%edx
  800612:	8b 48 04             	mov    0x4(%eax),%ecx
  800615:	8d 40 08             	lea    0x8(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800620:	e9 8b 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 10                	mov    (%eax),%edx
  80062a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80063a:	eb 74                	jmp    8006b0 <vprintfmt+0x38c>
	if (lflag >= 2)
  80063c:	83 f9 01             	cmp    $0x1,%ecx
  80063f:	7f 1b                	jg     80065c <vprintfmt+0x338>
	else if (lflag)
  800641:	85 c9                	test   %ecx,%ecx
  800643:	74 2c                	je     800671 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 10                	mov    (%eax),%edx
  80064a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80065a:	eb 54                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 48 04             	mov    0x4(%eax),%ecx
  800664:	8d 40 08             	lea    0x8(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80066f:	eb 3f                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800686:	eb 28                	jmp    8006b0 <vprintfmt+0x38c>
			putch('0', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 30                	push   $0x30
  80068e:	ff d6                	call   *%esi
			putch('x', putdat);
  800690:	83 c4 08             	add    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 78                	push   $0x78
  800696:	ff d6                	call   *%esi
			num = (unsigned long long)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b0:	83 ec 0c             	sub    $0xc,%esp
  8006b3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006b7:	57                   	push   %edi
  8006b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	51                   	push   %ecx
  8006bd:	52                   	push   %edx
  8006be:	89 da                	mov    %ebx,%edx
  8006c0:	89 f0                	mov    %esi,%eax
  8006c2:	e8 72 fb ff ff       	call   800239 <printnum>
			break;
  8006c7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cd:	83 c7 01             	add    $0x1,%edi
  8006d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d4:	83 f8 25             	cmp    $0x25,%eax
  8006d7:	0f 84 62 fc ff ff    	je     80033f <vprintfmt+0x1b>
			if (ch == '\0')
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	0f 84 8b 00 00 00    	je     800770 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	50                   	push   %eax
  8006ea:	ff d6                	call   *%esi
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb dc                	jmp    8006cd <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7f 1b                	jg     800711 <vprintfmt+0x3ed>
	else if (lflag)
  8006f6:	85 c9                	test   %ecx,%ecx
  8006f8:	74 2c                	je     800726 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 10                	mov    (%eax),%edx
  8006ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80070f:	eb 9f                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	8b 48 04             	mov    0x4(%eax),%ecx
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800724:	eb 8a                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80073b:	e9 70 ff ff ff       	jmp    8006b0 <vprintfmt+0x38c>
			putch(ch, putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 25                	push   $0x25
  800746:	ff d6                	call   *%esi
			break;
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	e9 7a ff ff ff       	jmp    8006ca <vprintfmt+0x3a6>
			putch('%', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 25                	push   $0x25
  800756:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 f8                	mov    %edi,%eax
  80075d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800761:	74 05                	je     800768 <vprintfmt+0x444>
  800763:	83 e8 01             	sub    $0x1,%eax
  800766:	eb f5                	jmp    80075d <vprintfmt+0x439>
  800768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076b:	e9 5a ff ff ff       	jmp    8006ca <vprintfmt+0x3a6>
}
  800770:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800773:	5b                   	pop    %ebx
  800774:	5e                   	pop    %esi
  800775:	5f                   	pop    %edi
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800778:	f3 0f 1e fb          	endbr32 
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800799:	85 c0                	test   %eax,%eax
  80079b:	74 26                	je     8007c3 <vsnprintf+0x4b>
  80079d:	85 d2                	test   %edx,%edx
  80079f:	7e 22                	jle    8007c3 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a1:	ff 75 14             	pushl  0x14(%ebp)
  8007a4:	ff 75 10             	pushl  0x10(%ebp)
  8007a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	68 e2 02 80 00       	push   $0x8002e2
  8007b0:	e8 6f fb ff ff       	call   800324 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007be:	83 c4 10             	add    $0x10,%esp
}
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    
		return -E_INVAL;
  8007c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c8:	eb f7                	jmp    8007c1 <vsnprintf+0x49>

008007ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ca:	f3 0f 1e fb          	endbr32 
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d7:	50                   	push   %eax
  8007d8:	ff 75 10             	pushl  0x10(%ebp)
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	ff 75 08             	pushl  0x8(%ebp)
  8007e1:	e8 92 ff ff ff       	call   800778 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e8:	f3 0f 1e fb          	endbr32 
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fb:	74 05                	je     800802 <strlen+0x1a>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
  800800:	eb f5                	jmp    8007f7 <strlen+0xf>
	return n;
}
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800804:	f3 0f 1e fb          	endbr32 
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	39 d0                	cmp    %edx,%eax
  800818:	74 0d                	je     800827 <strnlen+0x23>
  80081a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081e:	74 05                	je     800825 <strnlen+0x21>
		n++;
  800820:	83 c0 01             	add    $0x1,%eax
  800823:	eb f1                	jmp    800816 <strnlen+0x12>
  800825:	89 c2                	mov    %eax,%edx
	return n;
}
  800827:	89 d0                	mov    %edx,%eax
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082b:	f3 0f 1e fb          	endbr32 
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	53                   	push   %ebx
  800833:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800836:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800842:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800845:	83 c0 01             	add    $0x1,%eax
  800848:	84 d2                	test   %dl,%dl
  80084a:	75 f2                	jne    80083e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80084c:	89 c8                	mov    %ecx,%eax
  80084e:	5b                   	pop    %ebx
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800851:	f3 0f 1e fb          	endbr32 
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 10             	sub    $0x10,%esp
  80085c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085f:	53                   	push   %ebx
  800860:	e8 83 ff ff ff       	call   8007e8 <strlen>
  800865:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	50                   	push   %eax
  80086e:	e8 b8 ff ff ff       	call   80082b <strcpy>
	return dst;
}
  800873:	89 d8                	mov    %ebx,%eax
  800875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	8b 75 08             	mov    0x8(%ebp),%esi
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
  800889:	89 f3                	mov    %esi,%ebx
  80088b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088e:	89 f0                	mov    %esi,%eax
  800890:	39 d8                	cmp    %ebx,%eax
  800892:	74 11                	je     8008a5 <strncpy+0x2b>
		*dst++ = *src;
  800894:	83 c0 01             	add    $0x1,%eax
  800897:	0f b6 0a             	movzbl (%edx),%ecx
  80089a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089d:	80 f9 01             	cmp    $0x1,%cl
  8008a0:	83 da ff             	sbb    $0xffffffff,%edx
  8008a3:	eb eb                	jmp    800890 <strncpy+0x16>
	}
	return ret;
}
  8008a5:	89 f0                	mov    %esi,%eax
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ab:	f3 0f 1e fb          	endbr32 
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ba:	8b 55 10             	mov    0x10(%ebp),%edx
  8008bd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	74 21                	je     8008e4 <strlcpy+0x39>
  8008c3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 14                	je     8008e1 <strlcpy+0x36>
  8008cd:	0f b6 19             	movzbl (%ecx),%ebx
  8008d0:	84 db                	test   %bl,%bl
  8008d2:	74 0b                	je     8008df <strlcpy+0x34>
			*dst++ = *src++;
  8008d4:	83 c1 01             	add    $0x1,%ecx
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008dd:	eb ea                	jmp    8008c9 <strlcpy+0x1e>
  8008df:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e4:	29 f0                	sub    %esi,%eax
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f7:	0f b6 01             	movzbl (%ecx),%eax
  8008fa:	84 c0                	test   %al,%al
  8008fc:	74 0c                	je     80090a <strcmp+0x20>
  8008fe:	3a 02                	cmp    (%edx),%al
  800900:	75 08                	jne    80090a <strcmp+0x20>
		p++, q++;
  800902:	83 c1 01             	add    $0x1,%ecx
  800905:	83 c2 01             	add    $0x1,%edx
  800908:	eb ed                	jmp    8008f7 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090a:	0f b6 c0             	movzbl %al,%eax
  80090d:	0f b6 12             	movzbl (%edx),%edx
  800910:	29 d0                	sub    %edx,%eax
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	53                   	push   %ebx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	89 c3                	mov    %eax,%ebx
  800924:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800927:	eb 06                	jmp    80092f <strncmp+0x1b>
		n--, p++, q++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092f:	39 d8                	cmp    %ebx,%eax
  800931:	74 16                	je     800949 <strncmp+0x35>
  800933:	0f b6 08             	movzbl (%eax),%ecx
  800936:	84 c9                	test   %cl,%cl
  800938:	74 04                	je     80093e <strncmp+0x2a>
  80093a:	3a 0a                	cmp    (%edx),%cl
  80093c:	74 eb                	je     800929 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093e:	0f b6 00             	movzbl (%eax),%eax
  800941:	0f b6 12             	movzbl (%edx),%edx
  800944:	29 d0                	sub    %edx,%eax
}
  800946:	5b                   	pop    %ebx
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
		return 0;
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
  80094e:	eb f6                	jmp    800946 <strncmp+0x32>

00800950 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	74 09                	je     80096e <strchr+0x1e>
		if (*s == c)
  800965:	38 ca                	cmp    %cl,%dl
  800967:	74 0a                	je     800973 <strchr+0x23>
	for (; *s; s++)
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	eb f0                	jmp    80095e <strchr+0xe>
			return (char *) s;
	return 0;
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800983:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 09                	je     800993 <strfind+0x1e>
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 05                	je     800993 <strfind+0x1e>
	for (; *s; s++)
  80098e:	83 c0 01             	add    $0x1,%eax
  800991:	eb f0                	jmp    800983 <strfind+0xe>
			break;
	return (char *) s;
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800995:	f3 0f 1e fb          	endbr32 
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	57                   	push   %edi
  80099d:	56                   	push   %esi
  80099e:	53                   	push   %ebx
  80099f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a5:	85 c9                	test   %ecx,%ecx
  8009a7:	74 31                	je     8009da <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a9:	89 f8                	mov    %edi,%eax
  8009ab:	09 c8                	or     %ecx,%eax
  8009ad:	a8 03                	test   $0x3,%al
  8009af:	75 23                	jne    8009d4 <memset+0x3f>
		c &= 0xFF;
  8009b1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b5:	89 d3                	mov    %edx,%ebx
  8009b7:	c1 e3 08             	shl    $0x8,%ebx
  8009ba:	89 d0                	mov    %edx,%eax
  8009bc:	c1 e0 18             	shl    $0x18,%eax
  8009bf:	89 d6                	mov    %edx,%esi
  8009c1:	c1 e6 10             	shl    $0x10,%esi
  8009c4:	09 f0                	or     %esi,%eax
  8009c6:	09 c2                	or     %eax,%edx
  8009c8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	fc                   	cld    
  8009d0:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d2:	eb 06                	jmp    8009da <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	fc                   	cld    
  8009d8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009da:	89 f8                	mov    %edi,%eax
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5f                   	pop    %edi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	57                   	push   %edi
  8009e9:	56                   	push   %esi
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f3:	39 c6                	cmp    %eax,%esi
  8009f5:	73 32                	jae    800a29 <memmove+0x48>
  8009f7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fa:	39 c2                	cmp    %eax,%edx
  8009fc:	76 2b                	jbe    800a29 <memmove+0x48>
		s += n;
		d += n;
  8009fe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a01:	89 fe                	mov    %edi,%esi
  800a03:	09 ce                	or     %ecx,%esi
  800a05:	09 d6                	or     %edx,%esi
  800a07:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0d:	75 0e                	jne    800a1d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0f:	83 ef 04             	sub    $0x4,%edi
  800a12:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a18:	fd                   	std    
  800a19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1b:	eb 09                	jmp    800a26 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1d:	83 ef 01             	sub    $0x1,%edi
  800a20:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a23:	fd                   	std    
  800a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a26:	fc                   	cld    
  800a27:	eb 1a                	jmp    800a43 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	09 ca                	or     %ecx,%edx
  800a2d:	09 f2                	or     %esi,%edx
  800a2f:	f6 c2 03             	test   $0x3,%dl
  800a32:	75 0a                	jne    800a3e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a34:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a37:	89 c7                	mov    %eax,%edi
  800a39:	fc                   	cld    
  800a3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3c:	eb 05                	jmp    800a43 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a3e:	89 c7                	mov    %eax,%edi
  800a40:	fc                   	cld    
  800a41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a51:	ff 75 10             	pushl  0x10(%ebp)
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	ff 75 08             	pushl  0x8(%ebp)
  800a5a:	e8 82 ff ff ff       	call   8009e1 <memmove>
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a61:	f3 0f 1e fb          	endbr32 
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a70:	89 c6                	mov    %eax,%esi
  800a72:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a75:	39 f0                	cmp    %esi,%eax
  800a77:	74 1c                	je     800a95 <memcmp+0x34>
		if (*s1 != *s2)
  800a79:	0f b6 08             	movzbl (%eax),%ecx
  800a7c:	0f b6 1a             	movzbl (%edx),%ebx
  800a7f:	38 d9                	cmp    %bl,%cl
  800a81:	75 08                	jne    800a8b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	eb ea                	jmp    800a75 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a8b:	0f b6 c1             	movzbl %cl,%eax
  800a8e:	0f b6 db             	movzbl %bl,%ebx
  800a91:	29 d8                	sub    %ebx,%eax
  800a93:	eb 05                	jmp    800a9a <memcmp+0x39>
	}

	return 0;
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9e:	f3 0f 1e fb          	endbr32 
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab0:	39 d0                	cmp    %edx,%eax
  800ab2:	73 09                	jae    800abd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab4:	38 08                	cmp    %cl,(%eax)
  800ab6:	74 05                	je     800abd <memfind+0x1f>
	for (; s < ends; s++)
  800ab8:	83 c0 01             	add    $0x1,%eax
  800abb:	eb f3                	jmp    800ab0 <memfind+0x12>
			break;
	return (void *) s;
}
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abf:	f3 0f 1e fb          	endbr32 
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	57                   	push   %edi
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acf:	eb 03                	jmp    800ad4 <strtol+0x15>
		s++;
  800ad1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad4:	0f b6 01             	movzbl (%ecx),%eax
  800ad7:	3c 20                	cmp    $0x20,%al
  800ad9:	74 f6                	je     800ad1 <strtol+0x12>
  800adb:	3c 09                	cmp    $0x9,%al
  800add:	74 f2                	je     800ad1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800adf:	3c 2b                	cmp    $0x2b,%al
  800ae1:	74 2a                	je     800b0d <strtol+0x4e>
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae8:	3c 2d                	cmp    $0x2d,%al
  800aea:	74 2b                	je     800b17 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aec:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af2:	75 0f                	jne    800b03 <strtol+0x44>
  800af4:	80 39 30             	cmpb   $0x30,(%ecx)
  800af7:	74 28                	je     800b21 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af9:	85 db                	test   %ebx,%ebx
  800afb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b00:	0f 44 d8             	cmove  %eax,%ebx
  800b03:	b8 00 00 00 00       	mov    $0x0,%eax
  800b08:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b0b:	eb 46                	jmp    800b53 <strtol+0x94>
		s++;
  800b0d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
  800b15:	eb d5                	jmp    800aec <strtol+0x2d>
		s++, neg = 1;
  800b17:	83 c1 01             	add    $0x1,%ecx
  800b1a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1f:	eb cb                	jmp    800aec <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b25:	74 0e                	je     800b35 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b27:	85 db                	test   %ebx,%ebx
  800b29:	75 d8                	jne    800b03 <strtol+0x44>
		s++, base = 8;
  800b2b:	83 c1 01             	add    $0x1,%ecx
  800b2e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b33:	eb ce                	jmp    800b03 <strtol+0x44>
		s += 2, base = 16;
  800b35:	83 c1 02             	add    $0x2,%ecx
  800b38:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3d:	eb c4                	jmp    800b03 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b3f:	0f be d2             	movsbl %dl,%edx
  800b42:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b45:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b48:	7d 3a                	jge    800b84 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b4a:	83 c1 01             	add    $0x1,%ecx
  800b4d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b53:	0f b6 11             	movzbl (%ecx),%edx
  800b56:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b59:	89 f3                	mov    %esi,%ebx
  800b5b:	80 fb 09             	cmp    $0x9,%bl
  800b5e:	76 df                	jbe    800b3f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b60:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b63:	89 f3                	mov    %esi,%ebx
  800b65:	80 fb 19             	cmp    $0x19,%bl
  800b68:	77 08                	ja     800b72 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b6a:	0f be d2             	movsbl %dl,%edx
  800b6d:	83 ea 57             	sub    $0x57,%edx
  800b70:	eb d3                	jmp    800b45 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b72:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b75:	89 f3                	mov    %esi,%ebx
  800b77:	80 fb 19             	cmp    $0x19,%bl
  800b7a:	77 08                	ja     800b84 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b7c:	0f be d2             	movsbl %dl,%edx
  800b7f:	83 ea 37             	sub    $0x37,%edx
  800b82:	eb c1                	jmp    800b45 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b88:	74 05                	je     800b8f <strtol+0xd0>
		*endptr = (char *) s;
  800b8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8f:	89 c2                	mov    %eax,%edx
  800b91:	f7 da                	neg    %edx
  800b93:	85 ff                	test   %edi,%edi
  800b95:	0f 45 c2             	cmovne %edx,%eax
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5f                   	pop    %edi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b9d:	f3 0f 1e fb          	endbr32 
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb2:	89 c3                	mov    %eax,%ebx
  800bb4:	89 c7                	mov    %eax,%edi
  800bb6:	89 c6                	mov    %eax,%esi
  800bb8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5f                   	pop    %edi
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <sys_cgetc>:

int
sys_cgetc(void)
{
  800bbf:	f3 0f 1e fb          	endbr32 
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bce:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd3:	89 d1                	mov    %edx,%ecx
  800bd5:	89 d3                	mov    %edx,%ebx
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	89 d6                	mov    %edx,%esi
  800bdb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be2:	f3 0f 1e fb          	endbr32 
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfc:	89 cb                	mov    %ecx,%ebx
  800bfe:	89 cf                	mov    %ecx,%edi
  800c00:	89 ce                	mov    %ecx,%esi
  800c02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c04:	85 c0                	test   %eax,%eax
  800c06:	7f 08                	jg     800c10 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	6a 03                	push   $0x3
  800c16:	68 bf 23 80 00       	push   $0x8023bf
  800c1b:	6a 23                	push   $0x23
  800c1d:	68 dc 23 80 00       	push   $0x8023dc
  800c22:	e8 13 f5 ff ff       	call   80013a <_panic>

00800c27 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c27:	f3 0f 1e fb          	endbr32 
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	b8 02 00 00 00       	mov    $0x2,%eax
  800c3b:	89 d1                	mov    %edx,%ecx
  800c3d:	89 d3                	mov    %edx,%ebx
  800c3f:	89 d7                	mov    %edx,%edi
  800c41:	89 d6                	mov    %edx,%esi
  800c43:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_yield>:

void
sys_yield(void)
{
  800c4a:	f3 0f 1e fb          	endbr32 
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5e:	89 d1                	mov    %edx,%ecx
  800c60:	89 d3                	mov    %edx,%ebx
  800c62:	89 d7                	mov    %edx,%edi
  800c64:	89 d6                	mov    %edx,%esi
  800c66:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6d:	f3 0f 1e fb          	endbr32 
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	be 00 00 00 00       	mov    $0x0,%esi
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c85:	b8 04 00 00 00       	mov    $0x4,%eax
  800c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8d:	89 f7                	mov    %esi,%edi
  800c8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7f 08                	jg     800c9d <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	50                   	push   %eax
  800ca1:	6a 04                	push   $0x4
  800ca3:	68 bf 23 80 00       	push   $0x8023bf
  800ca8:	6a 23                	push   $0x23
  800caa:	68 dc 23 80 00       	push   $0x8023dc
  800caf:	e8 86 f4 ff ff       	call   80013a <_panic>

00800cb4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb4:	f3 0f 1e fb          	endbr32 
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	b8 05 00 00 00       	mov    $0x5,%eax
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd2:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 05                	push   $0x5
  800ce9:	68 bf 23 80 00       	push   $0x8023bf
  800cee:	6a 23                	push   $0x23
  800cf0:	68 dc 23 80 00       	push   $0x8023dc
  800cf5:	e8 40 f4 ff ff       	call   80013a <_panic>

00800cfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cfa:	f3 0f 1e fb          	endbr32 
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	b8 06 00 00 00       	mov    $0x6,%eax
  800d17:	89 df                	mov    %ebx,%edi
  800d19:	89 de                	mov    %ebx,%esi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 06                	push   $0x6
  800d2f:	68 bf 23 80 00       	push   $0x8023bf
  800d34:	6a 23                	push   $0x23
  800d36:	68 dc 23 80 00       	push   $0x8023dc
  800d3b:	e8 fa f3 ff ff       	call   80013a <_panic>

00800d40 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5d:	89 df                	mov    %ebx,%edi
  800d5f:	89 de                	mov    %ebx,%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 08                	push   $0x8
  800d75:	68 bf 23 80 00       	push   $0x8023bf
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 dc 23 80 00       	push   $0x8023dc
  800d81:	e8 b4 f3 ff ff       	call   80013a <_panic>

00800d86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d86:	f3 0f 1e fb          	endbr32 
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 09                	push   $0x9
  800dbb:	68 bf 23 80 00       	push   $0x8023bf
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 dc 23 80 00       	push   $0x8023dc
  800dc7:	e8 6e f3 ff ff       	call   80013a <_panic>

00800dcc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dcc:	f3 0f 1e fb          	endbr32 
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 0a                	push   $0xa
  800e01:	68 bf 23 80 00       	push   $0x8023bf
  800e06:	6a 23                	push   $0x23
  800e08:	68 dc 23 80 00       	push   $0x8023dc
  800e0d:	e8 28 f3 ff ff       	call   80013a <_panic>

00800e12 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e27:	be 00 00 00 00       	mov    $0x0,%esi
  800e2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e32:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e39:	f3 0f 1e fb          	endbr32 
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e53:	89 cb                	mov    %ecx,%ebx
  800e55:	89 cf                	mov    %ecx,%edi
  800e57:	89 ce                	mov    %ecx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 0d                	push   $0xd
  800e6d:	68 bf 23 80 00       	push   $0x8023bf
  800e72:	6a 23                	push   $0x23
  800e74:	68 dc 23 80 00       	push   $0x8023dc
  800e79:	e8 bc f2 ff ff       	call   80013a <_panic>

00800e7e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e7e:	f3 0f 1e fb          	endbr32 
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	53                   	push   %ebx
  800e86:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e89:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800e90:	74 0d                	je     800e9f <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800e9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e9d:	c9                   	leave  
  800e9e:	c3                   	ret    
		envid_t envid=sys_getenvid();
  800e9f:	e8 83 fd ff ff       	call   800c27 <sys_getenvid>
  800ea4:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  800ea6:	83 ec 04             	sub    $0x4,%esp
  800ea9:	6a 07                	push   $0x7
  800eab:	68 00 f0 bf ee       	push   $0xeebff000
  800eb0:	50                   	push   %eax
  800eb1:	e8 b7 fd ff ff       	call   800c6d <sys_page_alloc>
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	78 29                	js     800ee6 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	68 fa 0e 80 00       	push   $0x800efa
  800ec5:	53                   	push   %ebx
  800ec6:	e8 01 ff ff ff       	call   800dcc <sys_env_set_pgfault_upcall>
  800ecb:	83 c4 10             	add    $0x10,%esp
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	79 c0                	jns    800e92 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	68 18 24 80 00       	push   $0x802418
  800eda:	6a 24                	push   $0x24
  800edc:	68 4f 24 80 00       	push   $0x80244f
  800ee1:	e8 54 f2 ff ff       	call   80013a <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  800ee6:	83 ec 04             	sub    $0x4,%esp
  800ee9:	68 ec 23 80 00       	push   $0x8023ec
  800eee:	6a 22                	push   $0x22
  800ef0:	68 4f 24 80 00       	push   $0x80244f
  800ef5:	e8 40 f2 ff ff       	call   80013a <_panic>

00800efa <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800efa:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800efb:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800f00:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f02:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  800f05:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  800f08:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  800f0c:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  800f11:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  800f15:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800f17:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800f18:	83 c4 04             	add    $0x4,%esp
	popfl
  800f1b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800f1c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800f1d:	c3                   	ret    

00800f1e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f1e:	f3 0f 1e fb          	endbr32 
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	05 00 00 00 30       	add    $0x30000000,%eax
  800f2d:	c1 e8 0c             	shr    $0xc,%eax
}
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f46:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f4d:	f3 0f 1e fb          	endbr32 
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	c1 ea 16             	shr    $0x16,%edx
  800f5e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f65:	f6 c2 01             	test   $0x1,%dl
  800f68:	74 2d                	je     800f97 <fd_alloc+0x4a>
  800f6a:	89 c2                	mov    %eax,%edx
  800f6c:	c1 ea 0c             	shr    $0xc,%edx
  800f6f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f76:	f6 c2 01             	test   $0x1,%dl
  800f79:	74 1c                	je     800f97 <fd_alloc+0x4a>
  800f7b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f80:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f85:	75 d2                	jne    800f59 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f90:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f95:	eb 0a                	jmp    800fa1 <fd_alloc+0x54>
			*fd_store = fd;
  800f97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f9a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fa3:	f3 0f 1e fb          	endbr32 
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fad:	83 f8 1f             	cmp    $0x1f,%eax
  800fb0:	77 30                	ja     800fe2 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb2:	c1 e0 0c             	shl    $0xc,%eax
  800fb5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fba:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fc0:	f6 c2 01             	test   $0x1,%dl
  800fc3:	74 24                	je     800fe9 <fd_lookup+0x46>
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	c1 ea 0c             	shr    $0xc,%edx
  800fca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd1:	f6 c2 01             	test   $0x1,%dl
  800fd4:	74 1a                	je     800ff0 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd9:	89 02                	mov    %eax,(%edx)
	return 0;
  800fdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    
		return -E_INVAL;
  800fe2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe7:	eb f7                	jmp    800fe0 <fd_lookup+0x3d>
		return -E_INVAL;
  800fe9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fee:	eb f0                	jmp    800fe0 <fd_lookup+0x3d>
  800ff0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff5:	eb e9                	jmp    800fe0 <fd_lookup+0x3d>

00800ff7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ff7:	f3 0f 1e fb          	endbr32 
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801004:	ba dc 24 80 00       	mov    $0x8024dc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801009:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80100e:	39 08                	cmp    %ecx,(%eax)
  801010:	74 33                	je     801045 <dev_lookup+0x4e>
  801012:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801015:	8b 02                	mov    (%edx),%eax
  801017:	85 c0                	test   %eax,%eax
  801019:	75 f3                	jne    80100e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80101b:	a1 04 40 80 00       	mov    0x804004,%eax
  801020:	8b 40 48             	mov    0x48(%eax),%eax
  801023:	83 ec 04             	sub    $0x4,%esp
  801026:	51                   	push   %ecx
  801027:	50                   	push   %eax
  801028:	68 60 24 80 00       	push   $0x802460
  80102d:	e8 ef f1 ff ff       	call   800221 <cprintf>
	*dev = 0;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80103b:	83 c4 10             	add    $0x10,%esp
  80103e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    
			*dev = devtab[i];
  801045:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801048:	89 01                	mov    %eax,(%ecx)
			return 0;
  80104a:	b8 00 00 00 00       	mov    $0x0,%eax
  80104f:	eb f2                	jmp    801043 <dev_lookup+0x4c>

00801051 <fd_close>:
{
  801051:	f3 0f 1e fb          	endbr32 
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	57                   	push   %edi
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
  80105b:	83 ec 24             	sub    $0x24,%esp
  80105e:	8b 75 08             	mov    0x8(%ebp),%esi
  801061:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801064:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801067:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801068:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80106e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801071:	50                   	push   %eax
  801072:	e8 2c ff ff ff       	call   800fa3 <fd_lookup>
  801077:	89 c3                	mov    %eax,%ebx
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	85 c0                	test   %eax,%eax
  80107e:	78 05                	js     801085 <fd_close+0x34>
	    || fd != fd2)
  801080:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801083:	74 16                	je     80109b <fd_close+0x4a>
		return (must_exist ? r : 0);
  801085:	89 f8                	mov    %edi,%eax
  801087:	84 c0                	test   %al,%al
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
  80108e:	0f 44 d8             	cmove  %eax,%ebx
}
  801091:	89 d8                	mov    %ebx,%eax
  801093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109b:	83 ec 08             	sub    $0x8,%esp
  80109e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a1:	50                   	push   %eax
  8010a2:	ff 36                	pushl  (%esi)
  8010a4:	e8 4e ff ff ff       	call   800ff7 <dev_lookup>
  8010a9:	89 c3                	mov    %eax,%ebx
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	78 1a                	js     8010cc <fd_close+0x7b>
		if (dev->dev_close)
  8010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010b8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	74 0b                	je     8010cc <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	56                   	push   %esi
  8010c5:	ff d0                	call   *%eax
  8010c7:	89 c3                	mov    %eax,%ebx
  8010c9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	56                   	push   %esi
  8010d0:	6a 00                	push   $0x0
  8010d2:	e8 23 fc ff ff       	call   800cfa <sys_page_unmap>
	return r;
  8010d7:	83 c4 10             	add    $0x10,%esp
  8010da:	eb b5                	jmp    801091 <fd_close+0x40>

008010dc <close>:

int
close(int fdnum)
{
  8010dc:	f3 0f 1e fb          	endbr32 
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e9:	50                   	push   %eax
  8010ea:	ff 75 08             	pushl  0x8(%ebp)
  8010ed:	e8 b1 fe ff ff       	call   800fa3 <fd_lookup>
  8010f2:	83 c4 10             	add    $0x10,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	79 02                	jns    8010fb <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    
		return fd_close(fd, 1);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	6a 01                	push   $0x1
  801100:	ff 75 f4             	pushl  -0xc(%ebp)
  801103:	e8 49 ff ff ff       	call   801051 <fd_close>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	eb ec                	jmp    8010f9 <close+0x1d>

0080110d <close_all>:

void
close_all(void)
{
  80110d:	f3 0f 1e fb          	endbr32 
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	53                   	push   %ebx
  801115:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801118:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80111d:	83 ec 0c             	sub    $0xc,%esp
  801120:	53                   	push   %ebx
  801121:	e8 b6 ff ff ff       	call   8010dc <close>
	for (i = 0; i < MAXFD; i++)
  801126:	83 c3 01             	add    $0x1,%ebx
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	83 fb 20             	cmp    $0x20,%ebx
  80112f:	75 ec                	jne    80111d <close_all+0x10>
}
  801131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801136:	f3 0f 1e fb          	endbr32 
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
  801140:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801143:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 54 fe ff ff       	call   800fa3 <fd_lookup>
  80114f:	89 c3                	mov    %eax,%ebx
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	0f 88 81 00 00 00    	js     8011dd <dup+0xa7>
		return r;
	close(newfdnum);
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 75 ff ff ff       	call   8010dc <close>

	newfd = INDEX2FD(newfdnum);
  801167:	8b 75 0c             	mov    0xc(%ebp),%esi
  80116a:	c1 e6 0c             	shl    $0xc,%esi
  80116d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801173:	83 c4 04             	add    $0x4,%esp
  801176:	ff 75 e4             	pushl  -0x1c(%ebp)
  801179:	e8 b4 fd ff ff       	call   800f32 <fd2data>
  80117e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801180:	89 34 24             	mov    %esi,(%esp)
  801183:	e8 aa fd ff ff       	call   800f32 <fd2data>
  801188:	83 c4 10             	add    $0x10,%esp
  80118b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80118d:	89 d8                	mov    %ebx,%eax
  80118f:	c1 e8 16             	shr    $0x16,%eax
  801192:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801199:	a8 01                	test   $0x1,%al
  80119b:	74 11                	je     8011ae <dup+0x78>
  80119d:	89 d8                	mov    %ebx,%eax
  80119f:	c1 e8 0c             	shr    $0xc,%eax
  8011a2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a9:	f6 c2 01             	test   $0x1,%dl
  8011ac:	75 39                	jne    8011e7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	c1 e8 0c             	shr    $0xc,%eax
  8011b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8011c5:	50                   	push   %eax
  8011c6:	56                   	push   %esi
  8011c7:	6a 00                	push   $0x0
  8011c9:	52                   	push   %edx
  8011ca:	6a 00                	push   $0x0
  8011cc:	e8 e3 fa ff ff       	call   800cb4 <sys_page_map>
  8011d1:	89 c3                	mov    %eax,%ebx
  8011d3:	83 c4 20             	add    $0x20,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	78 31                	js     80120b <dup+0xd5>
		goto err;

	return newfdnum;
  8011da:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011dd:	89 d8                	mov    %ebx,%eax
  8011df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e2:	5b                   	pop    %ebx
  8011e3:	5e                   	pop    %esi
  8011e4:	5f                   	pop    %edi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8011f6:	50                   	push   %eax
  8011f7:	57                   	push   %edi
  8011f8:	6a 00                	push   $0x0
  8011fa:	53                   	push   %ebx
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 b2 fa ff ff       	call   800cb4 <sys_page_map>
  801202:	89 c3                	mov    %eax,%ebx
  801204:	83 c4 20             	add    $0x20,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	79 a3                	jns    8011ae <dup+0x78>
	sys_page_unmap(0, newfd);
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	56                   	push   %esi
  80120f:	6a 00                	push   $0x0
  801211:	e8 e4 fa ff ff       	call   800cfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801216:	83 c4 08             	add    $0x8,%esp
  801219:	57                   	push   %edi
  80121a:	6a 00                	push   $0x0
  80121c:	e8 d9 fa ff ff       	call   800cfa <sys_page_unmap>
	return r;
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	eb b7                	jmp    8011dd <dup+0xa7>

00801226 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801226:	f3 0f 1e fb          	endbr32 
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	53                   	push   %ebx
  80122e:	83 ec 1c             	sub    $0x1c,%esp
  801231:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801234:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	53                   	push   %ebx
  801239:	e8 65 fd ff ff       	call   800fa3 <fd_lookup>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 3f                	js     801284 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801245:	83 ec 08             	sub    $0x8,%esp
  801248:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124b:	50                   	push   %eax
  80124c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124f:	ff 30                	pushl  (%eax)
  801251:	e8 a1 fd ff ff       	call   800ff7 <dev_lookup>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 27                	js     801284 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80125d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801260:	8b 42 08             	mov    0x8(%edx),%eax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	83 f8 01             	cmp    $0x1,%eax
  801269:	74 1e                	je     801289 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80126b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126e:	8b 40 08             	mov    0x8(%eax),%eax
  801271:	85 c0                	test   %eax,%eax
  801273:	74 35                	je     8012aa <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	ff 75 10             	pushl  0x10(%ebp)
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	52                   	push   %edx
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801287:	c9                   	leave  
  801288:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801289:	a1 04 40 80 00       	mov    0x804004,%eax
  80128e:	8b 40 48             	mov    0x48(%eax),%eax
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	53                   	push   %ebx
  801295:	50                   	push   %eax
  801296:	68 a1 24 80 00       	push   $0x8024a1
  80129b:	e8 81 ef ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a8:	eb da                	jmp    801284 <read+0x5e>
		return -E_NOT_SUPP;
  8012aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012af:	eb d3                	jmp    801284 <read+0x5e>

008012b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012b1:	f3 0f 1e fb          	endbr32 
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c9:	eb 02                	jmp    8012cd <readn+0x1c>
  8012cb:	01 c3                	add    %eax,%ebx
  8012cd:	39 f3                	cmp    %esi,%ebx
  8012cf:	73 21                	jae    8012f2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	89 f0                	mov    %esi,%eax
  8012d6:	29 d8                	sub    %ebx,%eax
  8012d8:	50                   	push   %eax
  8012d9:	89 d8                	mov    %ebx,%eax
  8012db:	03 45 0c             	add    0xc(%ebp),%eax
  8012de:	50                   	push   %eax
  8012df:	57                   	push   %edi
  8012e0:	e8 41 ff ff ff       	call   801226 <read>
		if (m < 0)
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	78 04                	js     8012f0 <readn+0x3f>
			return m;
		if (m == 0)
  8012ec:	75 dd                	jne    8012cb <readn+0x1a>
  8012ee:	eb 02                	jmp    8012f2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012f0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012f2:	89 d8                	mov    %ebx,%eax
  8012f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f7:	5b                   	pop    %ebx
  8012f8:	5e                   	pop    %esi
  8012f9:	5f                   	pop    %edi
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012fc:	f3 0f 1e fb          	endbr32 
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	53                   	push   %ebx
  801304:	83 ec 1c             	sub    $0x1c,%esp
  801307:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80130a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	53                   	push   %ebx
  80130f:	e8 8f fc ff ff       	call   800fa3 <fd_lookup>
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 3a                	js     801355 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801321:	50                   	push   %eax
  801322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801325:	ff 30                	pushl  (%eax)
  801327:	e8 cb fc ff ff       	call   800ff7 <dev_lookup>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 22                	js     801355 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801336:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80133a:	74 1e                	je     80135a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80133c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133f:	8b 52 0c             	mov    0xc(%edx),%edx
  801342:	85 d2                	test   %edx,%edx
  801344:	74 35                	je     80137b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	ff 75 10             	pushl  0x10(%ebp)
  80134c:	ff 75 0c             	pushl  0xc(%ebp)
  80134f:	50                   	push   %eax
  801350:	ff d2                	call   *%edx
  801352:	83 c4 10             	add    $0x10,%esp
}
  801355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801358:	c9                   	leave  
  801359:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80135a:	a1 04 40 80 00       	mov    0x804004,%eax
  80135f:	8b 40 48             	mov    0x48(%eax),%eax
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	53                   	push   %ebx
  801366:	50                   	push   %eax
  801367:	68 bd 24 80 00       	push   $0x8024bd
  80136c:	e8 b0 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801379:	eb da                	jmp    801355 <write+0x59>
		return -E_NOT_SUPP;
  80137b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801380:	eb d3                	jmp    801355 <write+0x59>

00801382 <seek>:

int
seek(int fdnum, off_t offset)
{
  801382:	f3 0f 1e fb          	endbr32 
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80138c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138f:	50                   	push   %eax
  801390:	ff 75 08             	pushl  0x8(%ebp)
  801393:	e8 0b fc ff ff       	call   800fa3 <fd_lookup>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 0e                	js     8013ad <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80139f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013af:	f3 0f 1e fb          	endbr32 
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	53                   	push   %ebx
  8013b7:	83 ec 1c             	sub    $0x1c,%esp
  8013ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c0:	50                   	push   %eax
  8013c1:	53                   	push   %ebx
  8013c2:	e8 dc fb ff ff       	call   800fa3 <fd_lookup>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	78 37                	js     801405 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d8:	ff 30                	pushl  (%eax)
  8013da:	e8 18 fc ff ff       	call   800ff7 <dev_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 1f                	js     801405 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ed:	74 1b                	je     80140a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f2:	8b 52 18             	mov    0x18(%edx),%edx
  8013f5:	85 d2                	test   %edx,%edx
  8013f7:	74 32                	je     80142b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	ff 75 0c             	pushl  0xc(%ebp)
  8013ff:	50                   	push   %eax
  801400:	ff d2                	call   *%edx
  801402:	83 c4 10             	add    $0x10,%esp
}
  801405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801408:	c9                   	leave  
  801409:	c3                   	ret    
			thisenv->env_id, fdnum);
  80140a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80140f:	8b 40 48             	mov    0x48(%eax),%eax
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	53                   	push   %ebx
  801416:	50                   	push   %eax
  801417:	68 80 24 80 00       	push   $0x802480
  80141c:	e8 00 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801429:	eb da                	jmp    801405 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80142b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801430:	eb d3                	jmp    801405 <ftruncate+0x56>

00801432 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801432:	f3 0f 1e fb          	endbr32 
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	53                   	push   %ebx
  80143a:	83 ec 1c             	sub    $0x1c,%esp
  80143d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801440:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801443:	50                   	push   %eax
  801444:	ff 75 08             	pushl  0x8(%ebp)
  801447:	e8 57 fb ff ff       	call   800fa3 <fd_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 4b                	js     80149e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145d:	ff 30                	pushl  (%eax)
  80145f:	e8 93 fb ff ff       	call   800ff7 <dev_lookup>
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 33                	js     80149e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801472:	74 2f                	je     8014a3 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801474:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801477:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80147e:	00 00 00 
	stat->st_isdir = 0;
  801481:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801488:	00 00 00 
	stat->st_dev = dev;
  80148b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	53                   	push   %ebx
  801495:	ff 75 f0             	pushl  -0x10(%ebp)
  801498:	ff 50 14             	call   *0x14(%eax)
  80149b:	83 c4 10             	add    $0x10,%esp
}
  80149e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    
		return -E_NOT_SUPP;
  8014a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a8:	eb f4                	jmp    80149e <fstat+0x6c>

008014aa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014aa:	f3 0f 1e fb          	endbr32 
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	56                   	push   %esi
  8014b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	6a 00                	push   $0x0
  8014b8:	ff 75 08             	pushl  0x8(%ebp)
  8014bb:	e8 fb 01 00 00       	call   8016bb <open>
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 1b                	js     8014e4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	50                   	push   %eax
  8014d0:	e8 5d ff ff ff       	call   801432 <fstat>
  8014d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8014d7:	89 1c 24             	mov    %ebx,(%esp)
  8014da:	e8 fd fb ff ff       	call   8010dc <close>
	return r;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	89 f3                	mov    %esi,%ebx
}
  8014e4:	89 d8                	mov    %ebx,%eax
  8014e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5d                   	pop    %ebp
  8014ec:	c3                   	ret    

008014ed <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	89 c6                	mov    %eax,%esi
  8014f4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014f6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014fd:	74 27                	je     801526 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ff:	6a 07                	push   $0x7
  801501:	68 00 50 80 00       	push   $0x805000
  801506:	56                   	push   %esi
  801507:	ff 35 00 40 80 00    	pushl  0x804000
  80150d:	e8 be 07 00 00       	call   801cd0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801512:	83 c4 0c             	add    $0xc,%esp
  801515:	6a 00                	push   $0x0
  801517:	53                   	push   %ebx
  801518:	6a 00                	push   $0x0
  80151a:	e8 44 07 00 00       	call   801c63 <ipc_recv>
}
  80151f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	6a 01                	push   $0x1
  80152b:	e8 fa 07 00 00       	call   801d2a <ipc_find_env>
  801530:	a3 00 40 80 00       	mov    %eax,0x804000
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	eb c5                	jmp    8014ff <fsipc+0x12>

0080153a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80153a:	f3 0f 1e fb          	endbr32 
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8b 40 0c             	mov    0xc(%eax),%eax
  80154a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801557:	ba 00 00 00 00       	mov    $0x0,%edx
  80155c:	b8 02 00 00 00       	mov    $0x2,%eax
  801561:	e8 87 ff ff ff       	call   8014ed <fsipc>
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <devfile_flush>:
{
  801568:	f3 0f 1e fb          	endbr32 
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8b 40 0c             	mov    0xc(%eax),%eax
  801578:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80157d:	ba 00 00 00 00       	mov    $0x0,%edx
  801582:	b8 06 00 00 00       	mov    $0x6,%eax
  801587:	e8 61 ff ff ff       	call   8014ed <fsipc>
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <devfile_stat>:
{
  80158e:	f3 0f 1e fb          	endbr32 
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	53                   	push   %ebx
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8015b1:	e8 37 ff ff ff       	call   8014ed <fsipc>
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 2c                	js     8015e6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	68 00 50 80 00       	push   $0x805000
  8015c2:	53                   	push   %ebx
  8015c3:	e8 63 f2 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015c8:	a1 80 50 80 00       	mov    0x805080,%eax
  8015cd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015d3:	a1 84 50 80 00       	mov    0x805084,%eax
  8015d8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <devfile_write>:
{
  8015eb:	f3 0f 1e fb          	endbr32 
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 0c             	sub    $0xc,%esp
  8015f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015fd:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801602:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	8b 52 0c             	mov    0xc(%edx),%edx
  80160b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801611:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801616:	50                   	push   %eax
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	68 08 50 80 00       	push   $0x805008
  80161f:	e8 bd f3 ff ff       	call   8009e1 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801624:	ba 00 00 00 00       	mov    $0x0,%edx
  801629:	b8 04 00 00 00       	mov    $0x4,%eax
  80162e:	e8 ba fe ff ff       	call   8014ed <fsipc>
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <devfile_read>:
{
  801635:	f3 0f 1e fb          	endbr32 
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	56                   	push   %esi
  80163d:	53                   	push   %ebx
  80163e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	8b 40 0c             	mov    0xc(%eax),%eax
  801647:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80164c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801652:	ba 00 00 00 00       	mov    $0x0,%edx
  801657:	b8 03 00 00 00       	mov    $0x3,%eax
  80165c:	e8 8c fe ff ff       	call   8014ed <fsipc>
  801661:	89 c3                	mov    %eax,%ebx
  801663:	85 c0                	test   %eax,%eax
  801665:	78 1f                	js     801686 <devfile_read+0x51>
	assert(r <= n);
  801667:	39 f0                	cmp    %esi,%eax
  801669:	77 24                	ja     80168f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80166b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801670:	7f 33                	jg     8016a5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	50                   	push   %eax
  801676:	68 00 50 80 00       	push   $0x805000
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	e8 5e f3 ff ff       	call   8009e1 <memmove>
	return r;
  801683:	83 c4 10             	add    $0x10,%esp
}
  801686:	89 d8                	mov    %ebx,%eax
  801688:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168b:	5b                   	pop    %ebx
  80168c:	5e                   	pop    %esi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    
	assert(r <= n);
  80168f:	68 ec 24 80 00       	push   $0x8024ec
  801694:	68 f3 24 80 00       	push   $0x8024f3
  801699:	6a 7d                	push   $0x7d
  80169b:	68 08 25 80 00       	push   $0x802508
  8016a0:	e8 95 ea ff ff       	call   80013a <_panic>
	assert(r <= PGSIZE);
  8016a5:	68 13 25 80 00       	push   $0x802513
  8016aa:	68 f3 24 80 00       	push   $0x8024f3
  8016af:	6a 7e                	push   $0x7e
  8016b1:	68 08 25 80 00       	push   $0x802508
  8016b6:	e8 7f ea ff ff       	call   80013a <_panic>

008016bb <open>:
{
  8016bb:	f3 0f 1e fb          	endbr32 
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
  8016c4:	83 ec 1c             	sub    $0x1c,%esp
  8016c7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016ca:	56                   	push   %esi
  8016cb:	e8 18 f1 ff ff       	call   8007e8 <strlen>
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016d8:	7f 6c                	jg     801746 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e0:	50                   	push   %eax
  8016e1:	e8 67 f8 ff ff       	call   800f4d <fd_alloc>
  8016e6:	89 c3                	mov    %eax,%ebx
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 3c                	js     80172b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	56                   	push   %esi
  8016f3:	68 00 50 80 00       	push   $0x805000
  8016f8:	e8 2e f1 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801708:	b8 01 00 00 00       	mov    $0x1,%eax
  80170d:	e8 db fd ff ff       	call   8014ed <fsipc>
  801712:	89 c3                	mov    %eax,%ebx
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	78 19                	js     801734 <open+0x79>
	return fd2num(fd);
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	ff 75 f4             	pushl  -0xc(%ebp)
  801721:	e8 f8 f7 ff ff       	call   800f1e <fd2num>
  801726:	89 c3                	mov    %eax,%ebx
  801728:	83 c4 10             	add    $0x10,%esp
}
  80172b:	89 d8                	mov    %ebx,%eax
  80172d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    
		fd_close(fd, 0);
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	6a 00                	push   $0x0
  801739:	ff 75 f4             	pushl  -0xc(%ebp)
  80173c:	e8 10 f9 ff ff       	call   801051 <fd_close>
		return r;
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	eb e5                	jmp    80172b <open+0x70>
		return -E_BAD_PATH;
  801746:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80174b:	eb de                	jmp    80172b <open+0x70>

0080174d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80174d:	f3 0f 1e fb          	endbr32 
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	b8 08 00 00 00       	mov    $0x8,%eax
  801761:	e8 87 fd ff ff       	call   8014ed <fsipc>
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801768:	f3 0f 1e fb          	endbr32 
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	e8 b3 f7 ff ff       	call   800f32 <fd2data>
  80177f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801781:	83 c4 08             	add    $0x8,%esp
  801784:	68 1f 25 80 00       	push   $0x80251f
  801789:	53                   	push   %ebx
  80178a:	e8 9c f0 ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80178f:	8b 46 04             	mov    0x4(%esi),%eax
  801792:	2b 06                	sub    (%esi),%eax
  801794:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80179a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017a1:	00 00 00 
	stat->st_dev = &devpipe;
  8017a4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017ab:	30 80 00 
	return 0;
}
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017ba:	f3 0f 1e fb          	endbr32 
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017c8:	53                   	push   %ebx
  8017c9:	6a 00                	push   $0x0
  8017cb:	e8 2a f5 ff ff       	call   800cfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017d0:	89 1c 24             	mov    %ebx,(%esp)
  8017d3:	e8 5a f7 ff ff       	call   800f32 <fd2data>
  8017d8:	83 c4 08             	add    $0x8,%esp
  8017db:	50                   	push   %eax
  8017dc:	6a 00                	push   $0x0
  8017de:	e8 17 f5 ff ff       	call   800cfa <sys_page_unmap>
}
  8017e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <_pipeisclosed>:
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	57                   	push   %edi
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 1c             	sub    $0x1c,%esp
  8017f1:	89 c7                	mov    %eax,%edi
  8017f3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8017fa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017fd:	83 ec 0c             	sub    $0xc,%esp
  801800:	57                   	push   %edi
  801801:	e8 61 05 00 00       	call   801d67 <pageref>
  801806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801809:	89 34 24             	mov    %esi,(%esp)
  80180c:	e8 56 05 00 00       	call   801d67 <pageref>
		nn = thisenv->env_runs;
  801811:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801817:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	39 cb                	cmp    %ecx,%ebx
  80181f:	74 1b                	je     80183c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801821:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801824:	75 cf                	jne    8017f5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801826:	8b 42 58             	mov    0x58(%edx),%eax
  801829:	6a 01                	push   $0x1
  80182b:	50                   	push   %eax
  80182c:	53                   	push   %ebx
  80182d:	68 26 25 80 00       	push   $0x802526
  801832:	e8 ea e9 ff ff       	call   800221 <cprintf>
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	eb b9                	jmp    8017f5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80183c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80183f:	0f 94 c0             	sete   %al
  801842:	0f b6 c0             	movzbl %al,%eax
}
  801845:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5f                   	pop    %edi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <devpipe_write>:
{
  80184d:	f3 0f 1e fb          	endbr32 
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	57                   	push   %edi
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
  801857:	83 ec 28             	sub    $0x28,%esp
  80185a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80185d:	56                   	push   %esi
  80185e:	e8 cf f6 ff ff       	call   800f32 <fd2data>
  801863:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	bf 00 00 00 00       	mov    $0x0,%edi
  80186d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801870:	74 4f                	je     8018c1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801872:	8b 43 04             	mov    0x4(%ebx),%eax
  801875:	8b 0b                	mov    (%ebx),%ecx
  801877:	8d 51 20             	lea    0x20(%ecx),%edx
  80187a:	39 d0                	cmp    %edx,%eax
  80187c:	72 14                	jb     801892 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80187e:	89 da                	mov    %ebx,%edx
  801880:	89 f0                	mov    %esi,%eax
  801882:	e8 61 ff ff ff       	call   8017e8 <_pipeisclosed>
  801887:	85 c0                	test   %eax,%eax
  801889:	75 3b                	jne    8018c6 <devpipe_write+0x79>
			sys_yield();
  80188b:	e8 ba f3 ff ff       	call   800c4a <sys_yield>
  801890:	eb e0                	jmp    801872 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801892:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801895:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801899:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80189c:	89 c2                	mov    %eax,%edx
  80189e:	c1 fa 1f             	sar    $0x1f,%edx
  8018a1:	89 d1                	mov    %edx,%ecx
  8018a3:	c1 e9 1b             	shr    $0x1b,%ecx
  8018a6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018a9:	83 e2 1f             	and    $0x1f,%edx
  8018ac:	29 ca                	sub    %ecx,%edx
  8018ae:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018b6:	83 c0 01             	add    $0x1,%eax
  8018b9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018bc:	83 c7 01             	add    $0x1,%edi
  8018bf:	eb ac                	jmp    80186d <devpipe_write+0x20>
	return i;
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	eb 05                	jmp    8018cb <devpipe_write+0x7e>
				return 0;
  8018c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5e                   	pop    %esi
  8018d0:	5f                   	pop    %edi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    

008018d3 <devpipe_read>:
{
  8018d3:	f3 0f 1e fb          	endbr32 
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	57                   	push   %edi
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 18             	sub    $0x18,%esp
  8018e0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018e3:	57                   	push   %edi
  8018e4:	e8 49 f6 ff ff       	call   800f32 <fd2data>
  8018e9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	be 00 00 00 00       	mov    $0x0,%esi
  8018f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018f6:	75 14                	jne    80190c <devpipe_read+0x39>
	return i;
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	eb 02                	jmp    8018ff <devpipe_read+0x2c>
				return i;
  8018fd:	89 f0                	mov    %esi,%eax
}
  8018ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5f                   	pop    %edi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    
			sys_yield();
  801907:	e8 3e f3 ff ff       	call   800c4a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80190c:	8b 03                	mov    (%ebx),%eax
  80190e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801911:	75 18                	jne    80192b <devpipe_read+0x58>
			if (i > 0)
  801913:	85 f6                	test   %esi,%esi
  801915:	75 e6                	jne    8018fd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801917:	89 da                	mov    %ebx,%edx
  801919:	89 f8                	mov    %edi,%eax
  80191b:	e8 c8 fe ff ff       	call   8017e8 <_pipeisclosed>
  801920:	85 c0                	test   %eax,%eax
  801922:	74 e3                	je     801907 <devpipe_read+0x34>
				return 0;
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
  801929:	eb d4                	jmp    8018ff <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80192b:	99                   	cltd   
  80192c:	c1 ea 1b             	shr    $0x1b,%edx
  80192f:	01 d0                	add    %edx,%eax
  801931:	83 e0 1f             	and    $0x1f,%eax
  801934:	29 d0                	sub    %edx,%eax
  801936:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80193b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80193e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801941:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801944:	83 c6 01             	add    $0x1,%esi
  801947:	eb aa                	jmp    8018f3 <devpipe_read+0x20>

00801949 <pipe>:
{
  801949:	f3 0f 1e fb          	endbr32 
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801955:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801958:	50                   	push   %eax
  801959:	e8 ef f5 ff ff       	call   800f4d <fd_alloc>
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	85 c0                	test   %eax,%eax
  801965:	0f 88 23 01 00 00    	js     801a8e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	68 07 04 00 00       	push   $0x407
  801973:	ff 75 f4             	pushl  -0xc(%ebp)
  801976:	6a 00                	push   $0x0
  801978:	e8 f0 f2 ff ff       	call   800c6d <sys_page_alloc>
  80197d:	89 c3                	mov    %eax,%ebx
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	85 c0                	test   %eax,%eax
  801984:	0f 88 04 01 00 00    	js     801a8e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80198a:	83 ec 0c             	sub    $0xc,%esp
  80198d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801990:	50                   	push   %eax
  801991:	e8 b7 f5 ff ff       	call   800f4d <fd_alloc>
  801996:	89 c3                	mov    %eax,%ebx
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	0f 88 db 00 00 00    	js     801a7e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	68 07 04 00 00       	push   $0x407
  8019ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ae:	6a 00                	push   $0x0
  8019b0:	e8 b8 f2 ff ff       	call   800c6d <sys_page_alloc>
  8019b5:	89 c3                	mov    %eax,%ebx
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	0f 88 bc 00 00 00    	js     801a7e <pipe+0x135>
	va = fd2data(fd0);
  8019c2:	83 ec 0c             	sub    $0xc,%esp
  8019c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c8:	e8 65 f5 ff ff       	call   800f32 <fd2data>
  8019cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019cf:	83 c4 0c             	add    $0xc,%esp
  8019d2:	68 07 04 00 00       	push   $0x407
  8019d7:	50                   	push   %eax
  8019d8:	6a 00                	push   $0x0
  8019da:	e8 8e f2 ff ff       	call   800c6d <sys_page_alloc>
  8019df:	89 c3                	mov    %eax,%ebx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	0f 88 82 00 00 00    	js     801a6e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f2:	e8 3b f5 ff ff       	call   800f32 <fd2data>
  8019f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019fe:	50                   	push   %eax
  8019ff:	6a 00                	push   $0x0
  801a01:	56                   	push   %esi
  801a02:	6a 00                	push   $0x0
  801a04:	e8 ab f2 ff ff       	call   800cb4 <sys_page_map>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 20             	add    $0x20,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 4e                	js     801a60 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801a12:	a1 20 30 80 00       	mov    0x803020,%eax
  801a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801a26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a29:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3b:	e8 de f4 ff ff       	call   800f1e <fd2num>
  801a40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a43:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a45:	83 c4 04             	add    $0x4,%esp
  801a48:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4b:	e8 ce f4 ff ff       	call   800f1e <fd2num>
  801a50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a53:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a5e:	eb 2e                	jmp    801a8e <pipe+0x145>
	sys_page_unmap(0, va);
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	56                   	push   %esi
  801a64:	6a 00                	push   $0x0
  801a66:	e8 8f f2 ff ff       	call   800cfa <sys_page_unmap>
  801a6b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a6e:	83 ec 08             	sub    $0x8,%esp
  801a71:	ff 75 f0             	pushl  -0x10(%ebp)
  801a74:	6a 00                	push   $0x0
  801a76:	e8 7f f2 ff ff       	call   800cfa <sys_page_unmap>
  801a7b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	ff 75 f4             	pushl  -0xc(%ebp)
  801a84:	6a 00                	push   $0x0
  801a86:	e8 6f f2 ff ff       	call   800cfa <sys_page_unmap>
  801a8b:	83 c4 10             	add    $0x10,%esp
}
  801a8e:	89 d8                	mov    %ebx,%eax
  801a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    

00801a97 <pipeisclosed>:
{
  801a97:	f3 0f 1e fb          	endbr32 
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	e8 f6 f4 ff ff       	call   800fa3 <fd_lookup>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 18                	js     801acc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ab4:	83 ec 0c             	sub    $0xc,%esp
  801ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aba:	e8 73 f4 ff ff       	call   800f32 <fd2data>
  801abf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	e8 1f fd ff ff       	call   8017e8 <_pipeisclosed>
  801ac9:	83 c4 10             	add    $0x10,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ace:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad7:	c3                   	ret    

00801ad8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ad8:	f3 0f 1e fb          	endbr32 
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ae2:	68 3e 25 80 00       	push   $0x80253e
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	e8 3c ed ff ff       	call   80082b <strcpy>
	return 0;
}
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <devcons_write>:
{
  801af6:	f3 0f 1e fb          	endbr32 
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	57                   	push   %edi
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b06:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b0b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b11:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b14:	73 31                	jae    801b47 <devcons_write+0x51>
		m = n - tot;
  801b16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b19:	29 f3                	sub    %esi,%ebx
  801b1b:	83 fb 7f             	cmp    $0x7f,%ebx
  801b1e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b23:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	53                   	push   %ebx
  801b2a:	89 f0                	mov    %esi,%eax
  801b2c:	03 45 0c             	add    0xc(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	57                   	push   %edi
  801b31:	e8 ab ee ff ff       	call   8009e1 <memmove>
		sys_cputs(buf, m);
  801b36:	83 c4 08             	add    $0x8,%esp
  801b39:	53                   	push   %ebx
  801b3a:	57                   	push   %edi
  801b3b:	e8 5d f0 ff ff       	call   800b9d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b40:	01 de                	add    %ebx,%esi
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	eb ca                	jmp    801b11 <devcons_write+0x1b>
}
  801b47:	89 f0                	mov    %esi,%eax
  801b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5f                   	pop    %edi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <devcons_read>:
{
  801b51:	f3 0f 1e fb          	endbr32 
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b64:	74 21                	je     801b87 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801b66:	e8 54 f0 ff ff       	call   800bbf <sys_cgetc>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 07                	jne    801b76 <devcons_read+0x25>
		sys_yield();
  801b6f:	e8 d6 f0 ff ff       	call   800c4a <sys_yield>
  801b74:	eb f0                	jmp    801b66 <devcons_read+0x15>
	if (c < 0)
  801b76:	78 0f                	js     801b87 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801b78:	83 f8 04             	cmp    $0x4,%eax
  801b7b:	74 0c                	je     801b89 <devcons_read+0x38>
	*(char*)vbuf = c;
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	88 02                	mov    %al,(%edx)
	return 1;
  801b82:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
		return 0;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8e:	eb f7                	jmp    801b87 <devcons_read+0x36>

00801b90 <cputchar>:
{
  801b90:	f3 0f 1e fb          	endbr32 
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ba0:	6a 01                	push   $0x1
  801ba2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ba5:	50                   	push   %eax
  801ba6:	e8 f2 ef ff ff       	call   800b9d <sys_cputs>
}
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <getchar>:
{
  801bb0:	f3 0f 1e fb          	endbr32 
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801bba:	6a 01                	push   $0x1
  801bbc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bbf:	50                   	push   %eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	e8 5f f6 ff ff       	call   801226 <read>
	if (r < 0)
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 06                	js     801bd4 <getchar+0x24>
	if (r < 1)
  801bce:	74 06                	je     801bd6 <getchar+0x26>
	return c;
  801bd0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    
		return -E_EOF;
  801bd6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bdb:	eb f7                	jmp    801bd4 <getchar+0x24>

00801bdd <iscons>:
{
  801bdd:	f3 0f 1e fb          	endbr32 
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bea:	50                   	push   %eax
  801beb:	ff 75 08             	pushl  0x8(%ebp)
  801bee:	e8 b0 f3 ff ff       	call   800fa3 <fd_lookup>
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	78 11                	js     801c0b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c03:	39 10                	cmp    %edx,(%eax)
  801c05:	0f 94 c0             	sete   %al
  801c08:	0f b6 c0             	movzbl %al,%eax
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <opencons>:
{
  801c0d:	f3 0f 1e fb          	endbr32 
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1a:	50                   	push   %eax
  801c1b:	e8 2d f3 ff ff       	call   800f4d <fd_alloc>
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 3a                	js     801c61 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	68 07 04 00 00       	push   $0x407
  801c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c32:	6a 00                	push   $0x0
  801c34:	e8 34 f0 ff ff       	call   800c6d <sys_page_alloc>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 21                	js     801c61 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c43:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c49:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c55:	83 ec 0c             	sub    $0xc,%esp
  801c58:	50                   	push   %eax
  801c59:	e8 c0 f2 ff ff       	call   800f1e <fd2num>
  801c5e:	83 c4 10             	add    $0x10,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c63:	f3 0f 1e fb          	endbr32 
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	8b 75 08             	mov    0x8(%ebp),%esi
  801c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801c75:	85 c0                	test   %eax,%eax
  801c77:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c7c:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801c7f:	83 ec 0c             	sub    $0xc,%esp
  801c82:	50                   	push   %eax
  801c83:	e8 b1 f1 ff ff       	call   800e39 <sys_ipc_recv>
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	78 2b                	js     801cba <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801c8f:	85 f6                	test   %esi,%esi
  801c91:	74 0a                	je     801c9d <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  801c93:	a1 04 40 80 00       	mov    0x804004,%eax
  801c98:	8b 40 74             	mov    0x74(%eax),%eax
  801c9b:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801c9d:	85 db                	test   %ebx,%ebx
  801c9f:	74 0a                	je     801cab <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801ca1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca6:	8b 40 78             	mov    0x78(%eax),%eax
  801ca9:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801cab:	a1 04 40 80 00       	mov    0x804004,%eax
  801cb0:	8b 40 70             	mov    0x70(%eax),%eax
}
  801cb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb6:	5b                   	pop    %ebx
  801cb7:	5e                   	pop    %esi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    
		if(from_env_store)
  801cba:	85 f6                	test   %esi,%esi
  801cbc:	74 06                	je     801cc4 <ipc_recv+0x61>
			*from_env_store=0;
  801cbe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801cc4:	85 db                	test   %ebx,%ebx
  801cc6:	74 eb                	je     801cb3 <ipc_recv+0x50>
			*perm_store=0;
  801cc8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801cce:	eb e3                	jmp    801cb3 <ipc_recv+0x50>

00801cd0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801cd0:	f3 0f 1e fb          	endbr32 
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	57                   	push   %edi
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ce0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ce3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  801ce6:	85 db                	test   %ebx,%ebx
  801ce8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ced:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801cf0:	ff 75 14             	pushl  0x14(%ebp)
  801cf3:	53                   	push   %ebx
  801cf4:	56                   	push   %esi
  801cf5:	57                   	push   %edi
  801cf6:	e8 17 f1 ff ff       	call   800e12 <sys_ipc_try_send>
		if(!res)
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	74 20                	je     801d22 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  801d02:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d05:	75 07                	jne    801d0e <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  801d07:	e8 3e ef ff ff       	call   800c4a <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801d0c:	eb e2                	jmp    801cf0 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	68 4a 25 80 00       	push   $0x80254a
  801d16:	6a 3f                	push   $0x3f
  801d18:	68 62 25 80 00       	push   $0x802562
  801d1d:	e8 18 e4 ff ff       	call   80013a <_panic>
	}
}
  801d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d2a:	f3 0f 1e fb          	endbr32 
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d39:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d3c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d42:	8b 52 50             	mov    0x50(%edx),%edx
  801d45:	39 ca                	cmp    %ecx,%edx
  801d47:	74 11                	je     801d5a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801d49:	83 c0 01             	add    $0x1,%eax
  801d4c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d51:	75 e6                	jne    801d39 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
  801d58:	eb 0b                	jmp    801d65 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801d5a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d5d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d62:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    

00801d67 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d67:	f3 0f 1e fb          	endbr32 
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d71:	89 c2                	mov    %eax,%edx
  801d73:	c1 ea 16             	shr    $0x16,%edx
  801d76:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801d7d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801d82:	f6 c1 01             	test   $0x1,%cl
  801d85:	74 1c                	je     801da3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801d87:	c1 e8 0c             	shr    $0xc,%eax
  801d8a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d91:	a8 01                	test   $0x1,%al
  801d93:	74 0e                	je     801da3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d95:	c1 e8 0c             	shr    $0xc,%eax
  801d98:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801d9f:	ef 
  801da0:	0f b7 d2             	movzwl %dx,%edx
}
  801da3:	89 d0                	mov    %edx,%eax
  801da5:	5d                   	pop    %ebp
  801da6:	c3                   	ret    
  801da7:	66 90                	xchg   %ax,%ax
  801da9:	66 90                	xchg   %ax,%ax
  801dab:	66 90                	xchg   %ax,%ax
  801dad:	66 90                	xchg   %ax,%ax
  801daf:	90                   	nop

00801db0 <__udivdi3>:
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801dbf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dc7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801dcb:	85 d2                	test   %edx,%edx
  801dcd:	75 19                	jne    801de8 <__udivdi3+0x38>
  801dcf:	39 f3                	cmp    %esi,%ebx
  801dd1:	76 4d                	jbe    801e20 <__udivdi3+0x70>
  801dd3:	31 ff                	xor    %edi,%edi
  801dd5:	89 e8                	mov    %ebp,%eax
  801dd7:	89 f2                	mov    %esi,%edx
  801dd9:	f7 f3                	div    %ebx
  801ddb:	89 fa                	mov    %edi,%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	39 f2                	cmp    %esi,%edx
  801dea:	76 14                	jbe    801e00 <__udivdi3+0x50>
  801dec:	31 ff                	xor    %edi,%edi
  801dee:	31 c0                	xor    %eax,%eax
  801df0:	89 fa                	mov    %edi,%edx
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
  801dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e00:	0f bd fa             	bsr    %edx,%edi
  801e03:	83 f7 1f             	xor    $0x1f,%edi
  801e06:	75 48                	jne    801e50 <__udivdi3+0xa0>
  801e08:	39 f2                	cmp    %esi,%edx
  801e0a:	72 06                	jb     801e12 <__udivdi3+0x62>
  801e0c:	31 c0                	xor    %eax,%eax
  801e0e:	39 eb                	cmp    %ebp,%ebx
  801e10:	77 de                	ja     801df0 <__udivdi3+0x40>
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	eb d7                	jmp    801df0 <__udivdi3+0x40>
  801e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e20:	89 d9                	mov    %ebx,%ecx
  801e22:	85 db                	test   %ebx,%ebx
  801e24:	75 0b                	jne    801e31 <__udivdi3+0x81>
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f3                	div    %ebx
  801e2f:	89 c1                	mov    %eax,%ecx
  801e31:	31 d2                	xor    %edx,%edx
  801e33:	89 f0                	mov    %esi,%eax
  801e35:	f7 f1                	div    %ecx
  801e37:	89 c6                	mov    %eax,%esi
  801e39:	89 e8                	mov    %ebp,%eax
  801e3b:	89 f7                	mov    %esi,%edi
  801e3d:	f7 f1                	div    %ecx
  801e3f:	89 fa                	mov    %edi,%edx
  801e41:	83 c4 1c             	add    $0x1c,%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5f                   	pop    %edi
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    
  801e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e50:	89 f9                	mov    %edi,%ecx
  801e52:	b8 20 00 00 00       	mov    $0x20,%eax
  801e57:	29 f8                	sub    %edi,%eax
  801e59:	d3 e2                	shl    %cl,%edx
  801e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5f:	89 c1                	mov    %eax,%ecx
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	d3 ea                	shr    %cl,%edx
  801e65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e69:	09 d1                	or     %edx,%ecx
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e71:	89 f9                	mov    %edi,%ecx
  801e73:	d3 e3                	shl    %cl,%ebx
  801e75:	89 c1                	mov    %eax,%ecx
  801e77:	d3 ea                	shr    %cl,%edx
  801e79:	89 f9                	mov    %edi,%ecx
  801e7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e7f:	89 eb                	mov    %ebp,%ebx
  801e81:	d3 e6                	shl    %cl,%esi
  801e83:	89 c1                	mov    %eax,%ecx
  801e85:	d3 eb                	shr    %cl,%ebx
  801e87:	09 de                	or     %ebx,%esi
  801e89:	89 f0                	mov    %esi,%eax
  801e8b:	f7 74 24 08          	divl   0x8(%esp)
  801e8f:	89 d6                	mov    %edx,%esi
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	f7 64 24 0c          	mull   0xc(%esp)
  801e97:	39 d6                	cmp    %edx,%esi
  801e99:	72 15                	jb     801eb0 <__udivdi3+0x100>
  801e9b:	89 f9                	mov    %edi,%ecx
  801e9d:	d3 e5                	shl    %cl,%ebp
  801e9f:	39 c5                	cmp    %eax,%ebp
  801ea1:	73 04                	jae    801ea7 <__udivdi3+0xf7>
  801ea3:	39 d6                	cmp    %edx,%esi
  801ea5:	74 09                	je     801eb0 <__udivdi3+0x100>
  801ea7:	89 d8                	mov    %ebx,%eax
  801ea9:	31 ff                	xor    %edi,%edi
  801eab:	e9 40 ff ff ff       	jmp    801df0 <__udivdi3+0x40>
  801eb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eb3:	31 ff                	xor    %edi,%edi
  801eb5:	e9 36 ff ff ff       	jmp    801df0 <__udivdi3+0x40>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	66 90                	xchg   %ax,%ax
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <__umoddi3>:
  801ec0:	f3 0f 1e fb          	endbr32 
  801ec4:	55                   	push   %ebp
  801ec5:	57                   	push   %edi
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 1c             	sub    $0x1c,%esp
  801ecb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ecf:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ed3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801edb:	85 c0                	test   %eax,%eax
  801edd:	75 19                	jne    801ef8 <__umoddi3+0x38>
  801edf:	39 df                	cmp    %ebx,%edi
  801ee1:	76 5d                	jbe    801f40 <__umoddi3+0x80>
  801ee3:	89 f0                	mov    %esi,%eax
  801ee5:	89 da                	mov    %ebx,%edx
  801ee7:	f7 f7                	div    %edi
  801ee9:	89 d0                	mov    %edx,%eax
  801eeb:	31 d2                	xor    %edx,%edx
  801eed:	83 c4 1c             	add    $0x1c,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
  801ef5:	8d 76 00             	lea    0x0(%esi),%esi
  801ef8:	89 f2                	mov    %esi,%edx
  801efa:	39 d8                	cmp    %ebx,%eax
  801efc:	76 12                	jbe    801f10 <__umoddi3+0x50>
  801efe:	89 f0                	mov    %esi,%eax
  801f00:	89 da                	mov    %ebx,%edx
  801f02:	83 c4 1c             	add    $0x1c,%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    
  801f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f10:	0f bd e8             	bsr    %eax,%ebp
  801f13:	83 f5 1f             	xor    $0x1f,%ebp
  801f16:	75 50                	jne    801f68 <__umoddi3+0xa8>
  801f18:	39 d8                	cmp    %ebx,%eax
  801f1a:	0f 82 e0 00 00 00    	jb     802000 <__umoddi3+0x140>
  801f20:	89 d9                	mov    %ebx,%ecx
  801f22:	39 f7                	cmp    %esi,%edi
  801f24:	0f 86 d6 00 00 00    	jbe    802000 <__umoddi3+0x140>
  801f2a:	89 d0                	mov    %edx,%eax
  801f2c:	89 ca                	mov    %ecx,%edx
  801f2e:	83 c4 1c             	add    $0x1c,%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
  801f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f3d:	8d 76 00             	lea    0x0(%esi),%esi
  801f40:	89 fd                	mov    %edi,%ebp
  801f42:	85 ff                	test   %edi,%edi
  801f44:	75 0b                	jne    801f51 <__umoddi3+0x91>
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	31 d2                	xor    %edx,%edx
  801f4d:	f7 f7                	div    %edi
  801f4f:	89 c5                	mov    %eax,%ebp
  801f51:	89 d8                	mov    %ebx,%eax
  801f53:	31 d2                	xor    %edx,%edx
  801f55:	f7 f5                	div    %ebp
  801f57:	89 f0                	mov    %esi,%eax
  801f59:	f7 f5                	div    %ebp
  801f5b:	89 d0                	mov    %edx,%eax
  801f5d:	31 d2                	xor    %edx,%edx
  801f5f:	eb 8c                	jmp    801eed <__umoddi3+0x2d>
  801f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f68:	89 e9                	mov    %ebp,%ecx
  801f6a:	ba 20 00 00 00       	mov    $0x20,%edx
  801f6f:	29 ea                	sub    %ebp,%edx
  801f71:	d3 e0                	shl    %cl,%eax
  801f73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f77:	89 d1                	mov    %edx,%ecx
  801f79:	89 f8                	mov    %edi,%eax
  801f7b:	d3 e8                	shr    %cl,%eax
  801f7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f85:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f89:	09 c1                	or     %eax,%ecx
  801f8b:	89 d8                	mov    %ebx,%eax
  801f8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f91:	89 e9                	mov    %ebp,%ecx
  801f93:	d3 e7                	shl    %cl,%edi
  801f95:	89 d1                	mov    %edx,%ecx
  801f97:	d3 e8                	shr    %cl,%eax
  801f99:	89 e9                	mov    %ebp,%ecx
  801f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f9f:	d3 e3                	shl    %cl,%ebx
  801fa1:	89 c7                	mov    %eax,%edi
  801fa3:	89 d1                	mov    %edx,%ecx
  801fa5:	89 f0                	mov    %esi,%eax
  801fa7:	d3 e8                	shr    %cl,%eax
  801fa9:	89 e9                	mov    %ebp,%ecx
  801fab:	89 fa                	mov    %edi,%edx
  801fad:	d3 e6                	shl    %cl,%esi
  801faf:	09 d8                	or     %ebx,%eax
  801fb1:	f7 74 24 08          	divl   0x8(%esp)
  801fb5:	89 d1                	mov    %edx,%ecx
  801fb7:	89 f3                	mov    %esi,%ebx
  801fb9:	f7 64 24 0c          	mull   0xc(%esp)
  801fbd:	89 c6                	mov    %eax,%esi
  801fbf:	89 d7                	mov    %edx,%edi
  801fc1:	39 d1                	cmp    %edx,%ecx
  801fc3:	72 06                	jb     801fcb <__umoddi3+0x10b>
  801fc5:	75 10                	jne    801fd7 <__umoddi3+0x117>
  801fc7:	39 c3                	cmp    %eax,%ebx
  801fc9:	73 0c                	jae    801fd7 <__umoddi3+0x117>
  801fcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  801fcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801fd3:	89 d7                	mov    %edx,%edi
  801fd5:	89 c6                	mov    %eax,%esi
  801fd7:	89 ca                	mov    %ecx,%edx
  801fd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fde:	29 f3                	sub    %esi,%ebx
  801fe0:	19 fa                	sbb    %edi,%edx
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	d3 e0                	shl    %cl,%eax
  801fe6:	89 e9                	mov    %ebp,%ecx
  801fe8:	d3 eb                	shr    %cl,%ebx
  801fea:	d3 ea                	shr    %cl,%edx
  801fec:	09 d8                	or     %ebx,%eax
  801fee:	83 c4 1c             	add    $0x1c,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
  801ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ffd:	8d 76 00             	lea    0x0(%esi),%esi
  802000:	29 fe                	sub    %edi,%esi
  802002:	19 c3                	sbb    %eax,%ebx
  802004:	89 f2                	mov    %esi,%edx
  802006:	89 d9                	mov    %ebx,%ecx
  802008:	e9 1d ff ff ff       	jmp    801f2a <__umoddi3+0x6a>
