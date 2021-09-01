
obj/user/testpteshare.debug：     文件格式 elf32-i386


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
  80002c:	e8 6b 01 00 00       	call   80019c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  80003d:	ff 35 00 40 80 00    	pushl  0x804000
  800043:	68 00 00 00 a0       	push   $0xa0000000
  800048:	e8 a8 08 00 00       	call   8008f5 <strcpy>
	exit();
  80004d:	e8 94 01 00 00       	call   8001e6 <exit>
}
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	c9                   	leave  
  800056:	c3                   	ret    

00800057 <umain>:
{
  800057:	f3 0f 1e fb          	endbr32 
  80005b:	55                   	push   %ebp
  80005c:	89 e5                	mov    %esp,%ebp
  80005e:	53                   	push   %ebx
  80005f:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  800062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800066:	0f 85 d0 00 00 00    	jne    80013c <umain+0xe5>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	68 07 04 00 00       	push   $0x407
  800074:	68 00 00 00 a0       	push   $0xa0000000
  800079:	6a 00                	push   $0x0
  80007b:	e8 b7 0c 00 00       	call   800d37 <sys_page_alloc>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	85 c0                	test   %eax,%eax
  800085:	0f 88 bb 00 00 00    	js     800146 <umain+0xef>
	if ((r = fork()) < 0)
  80008b:	e8 9b 0f 00 00       	call   80102b <fork>
  800090:	89 c3                	mov    %eax,%ebx
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 88 be 00 00 00    	js     800158 <umain+0x101>
	if (r == 0) {
  80009a:	0f 84 ca 00 00 00    	je     80016a <umain+0x113>
	wait(r);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	53                   	push   %ebx
  8000a4:	e8 86 23 00 00       	call   80242f <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	ff 35 04 40 80 00    	pushl  0x804004
  8000b2:	68 00 00 00 a0       	push   $0xa0000000
  8000b7:	e8 f8 08 00 00       	call   8009b4 <strcmp>
  8000bc:	83 c4 08             	add    $0x8,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	b8 60 2a 80 00       	mov    $0x802a60,%eax
  8000c6:	ba 66 2a 80 00       	mov    $0x802a66,%edx
  8000cb:	0f 45 c2             	cmovne %edx,%eax
  8000ce:	50                   	push   %eax
  8000cf:	68 9c 2a 80 00       	push   $0x802a9c
  8000d4:	e8 12 02 00 00       	call   8002eb <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d9:	6a 00                	push   $0x0
  8000db:	68 b7 2a 80 00       	push   $0x802ab7
  8000e0:	68 bc 2a 80 00       	push   $0x802abc
  8000e5:	68 bb 2a 80 00       	push   $0x802abb
  8000ea:	e8 28 1f 00 00       	call   802017 <spawnl>
  8000ef:	83 c4 20             	add    $0x20,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	0f 88 90 00 00 00    	js     80018a <umain+0x133>
	wait(r);
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 2c 23 00 00       	call   80242f <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800103:	83 c4 08             	add    $0x8,%esp
  800106:	ff 35 00 40 80 00    	pushl  0x804000
  80010c:	68 00 00 00 a0       	push   $0xa0000000
  800111:	e8 9e 08 00 00       	call   8009b4 <strcmp>
  800116:	83 c4 08             	add    $0x8,%esp
  800119:	85 c0                	test   %eax,%eax
  80011b:	b8 60 2a 80 00       	mov    $0x802a60,%eax
  800120:	ba 66 2a 80 00       	mov    $0x802a66,%edx
  800125:	0f 45 c2             	cmovne %edx,%eax
  800128:	50                   	push   %eax
  800129:	68 d3 2a 80 00       	push   $0x802ad3
  80012e:	e8 b8 01 00 00       	call   8002eb <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800133:	cc                   	int3   
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    
		childofspawn();
  80013c:	e8 f2 fe ff ff       	call   800033 <childofspawn>
  800141:	e9 26 ff ff ff       	jmp    80006c <umain+0x15>
		panic("sys_page_alloc: %e", r);
  800146:	50                   	push   %eax
  800147:	68 6c 2a 80 00       	push   $0x802a6c
  80014c:	6a 13                	push   $0x13
  80014e:	68 7f 2a 80 00       	push   $0x802a7f
  800153:	e8 ac 00 00 00       	call   800204 <_panic>
		panic("fork: %e", r);
  800158:	50                   	push   %eax
  800159:	68 93 2a 80 00       	push   $0x802a93
  80015e:	6a 17                	push   $0x17
  800160:	68 7f 2a 80 00       	push   $0x802a7f
  800165:	e8 9a 00 00 00       	call   800204 <_panic>
		strcpy(VA, msg);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 35 04 40 80 00    	pushl  0x804004
  800173:	68 00 00 00 a0       	push   $0xa0000000
  800178:	e8 78 07 00 00       	call   8008f5 <strcpy>
		exit();
  80017d:	e8 64 00 00 00       	call   8001e6 <exit>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	e9 16 ff ff ff       	jmp    8000a0 <umain+0x49>
		panic("spawn: %e", r);
  80018a:	50                   	push   %eax
  80018b:	68 c9 2a 80 00       	push   $0x802ac9
  800190:	6a 21                	push   $0x21
  800192:	68 7f 2a 80 00       	push   $0x802a7f
  800197:	e8 68 00 00 00       	call   800204 <_panic>

0080019c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019c:	f3 0f 1e fb          	endbr32 
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	56                   	push   %esi
  8001a4:	53                   	push   %ebx
  8001a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ab:	e8 41 0b 00 00       	call   800cf1 <sys_getenvid>
  8001b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bd:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	85 db                	test   %ebx,%ebx
  8001c4:	7e 07                	jle    8001cd <libmain+0x31>
		binaryname = argv[0];
  8001c6:	8b 06                	mov    (%esi),%eax
  8001c8:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	56                   	push   %esi
  8001d1:	53                   	push   %ebx
  8001d2:	e8 80 fe ff ff       	call   800057 <umain>

	// exit gracefully
	exit();
  8001d7:	e8 0a 00 00 00       	call   8001e6 <exit>
}
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5d                   	pop    %ebp
  8001e5:	c3                   	ret    

008001e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e6:	f3 0f 1e fb          	endbr32 
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001f0:	e8 62 12 00 00       	call   801457 <close_all>
	sys_env_destroy(0);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	6a 00                	push   $0x0
  8001fa:	e8 ad 0a 00 00       	call   800cac <sys_env_destroy>
}
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800204:	f3 0f 1e fb          	endbr32 
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80020d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800210:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800216:	e8 d6 0a 00 00       	call   800cf1 <sys_getenvid>
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	ff 75 0c             	pushl  0xc(%ebp)
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	56                   	push   %esi
  800225:	50                   	push   %eax
  800226:	68 18 2b 80 00       	push   $0x802b18
  80022b:	e8 bb 00 00 00       	call   8002eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800230:	83 c4 18             	add    $0x18,%esp
  800233:	53                   	push   %ebx
  800234:	ff 75 10             	pushl  0x10(%ebp)
  800237:	e8 5a 00 00 00       	call   800296 <vcprintf>
	cprintf("\n");
  80023c:	c7 04 24 5e 31 80 00 	movl   $0x80315e,(%esp)
  800243:	e8 a3 00 00 00       	call   8002eb <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80024b:	cc                   	int3   
  80024c:	eb fd                	jmp    80024b <_panic+0x47>

0080024e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	53                   	push   %ebx
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80025c:	8b 13                	mov    (%ebx),%edx
  80025e:	8d 42 01             	lea    0x1(%edx),%eax
  800261:	89 03                	mov    %eax,(%ebx)
  800263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800266:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80026a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026f:	74 09                	je     80027a <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800271:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800278:	c9                   	leave  
  800279:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	68 ff 00 00 00       	push   $0xff
  800282:	8d 43 08             	lea    0x8(%ebx),%eax
  800285:	50                   	push   %eax
  800286:	e8 dc 09 00 00       	call   800c67 <sys_cputs>
		b->idx = 0;
  80028b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	eb db                	jmp    800271 <putch+0x23>

00800296 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800296:	f3 0f 1e fb          	endbr32 
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002aa:	00 00 00 
	b.cnt = 0;
  8002ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	68 4e 02 80 00       	push   $0x80024e
  8002c9:	e8 20 01 00 00       	call   8003ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ce:	83 c4 08             	add    $0x8,%esp
  8002d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002dd:	50                   	push   %eax
  8002de:	e8 84 09 00 00       	call   800c67 <sys_cputs>

	return b.cnt;
}
  8002e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002eb:	f3 0f 1e fb          	endbr32 
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f8:	50                   	push   %eax
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 95 ff ff ff       	call   800296 <vcprintf>
	va_end(ap);

	return cnt;
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 1c             	sub    $0x1c,%esp
  80030c:	89 c7                	mov    %eax,%edi
  80030e:	89 d6                	mov    %edx,%esi
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	8b 55 0c             	mov    0xc(%ebp),%edx
  800316:	89 d1                	mov    %edx,%ecx
  800318:	89 c2                	mov    %eax,%edx
  80031a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800320:	8b 45 10             	mov    0x10(%ebp),%eax
  800323:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800326:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800329:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800330:	39 c2                	cmp    %eax,%edx
  800332:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800335:	72 3e                	jb     800375 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	ff 75 18             	pushl  0x18(%ebp)
  80033d:	83 eb 01             	sub    $0x1,%ebx
  800340:	53                   	push   %ebx
  800341:	50                   	push   %eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	ff 75 dc             	pushl  -0x24(%ebp)
  80034e:	ff 75 d8             	pushl  -0x28(%ebp)
  800351:	e8 aa 24 00 00       	call   802800 <__udivdi3>
  800356:	83 c4 18             	add    $0x18,%esp
  800359:	52                   	push   %edx
  80035a:	50                   	push   %eax
  80035b:	89 f2                	mov    %esi,%edx
  80035d:	89 f8                	mov    %edi,%eax
  80035f:	e8 9f ff ff ff       	call   800303 <printnum>
  800364:	83 c4 20             	add    $0x20,%esp
  800367:	eb 13                	jmp    80037c <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	56                   	push   %esi
  80036d:	ff 75 18             	pushl  0x18(%ebp)
  800370:	ff d7                	call   *%edi
  800372:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800375:	83 eb 01             	sub    $0x1,%ebx
  800378:	85 db                	test   %ebx,%ebx
  80037a:	7f ed                	jg     800369 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	56                   	push   %esi
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	ff 75 e4             	pushl  -0x1c(%ebp)
  800386:	ff 75 e0             	pushl  -0x20(%ebp)
  800389:	ff 75 dc             	pushl  -0x24(%ebp)
  80038c:	ff 75 d8             	pushl  -0x28(%ebp)
  80038f:	e8 7c 25 00 00       	call   802910 <__umoddi3>
  800394:	83 c4 14             	add    $0x14,%esp
  800397:	0f be 80 3b 2b 80 00 	movsbl 0x802b3b(%eax),%eax
  80039e:	50                   	push   %eax
  80039f:	ff d7                	call   *%edi
}
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a7:	5b                   	pop    %ebx
  8003a8:	5e                   	pop    %esi
  8003a9:	5f                   	pop    %edi
  8003aa:	5d                   	pop    %ebp
  8003ab:	c3                   	ret    

008003ac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ac:	f3 0f 1e fb          	endbr32 
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ba:	8b 10                	mov    (%eax),%edx
  8003bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003bf:	73 0a                	jae    8003cb <sprintputch+0x1f>
		*b->buf++ = ch;
  8003c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	88 02                	mov    %al,(%edx)
}
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <printfmt>:
{
  8003cd:	f3 0f 1e fb          	endbr32 
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003d7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003da:	50                   	push   %eax
  8003db:	ff 75 10             	pushl  0x10(%ebp)
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	ff 75 08             	pushl  0x8(%ebp)
  8003e4:	e8 05 00 00 00       	call   8003ee <vprintfmt>
}
  8003e9:	83 c4 10             	add    $0x10,%esp
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <vprintfmt>:
{
  8003ee:	f3 0f 1e fb          	endbr32 
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	57                   	push   %edi
  8003f6:	56                   	push   %esi
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 3c             	sub    $0x3c,%esp
  8003fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800401:	8b 7d 10             	mov    0x10(%ebp),%edi
  800404:	e9 8e 03 00 00       	jmp    800797 <vprintfmt+0x3a9>
		padc = ' ';
  800409:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80040d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800414:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80041b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800422:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8d 47 01             	lea    0x1(%edi),%eax
  80042a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042d:	0f b6 17             	movzbl (%edi),%edx
  800430:	8d 42 dd             	lea    -0x23(%edx),%eax
  800433:	3c 55                	cmp    $0x55,%al
  800435:	0f 87 df 03 00 00    	ja     80081a <vprintfmt+0x42c>
  80043b:	0f b6 c0             	movzbl %al,%eax
  80043e:	3e ff 24 85 80 2c 80 	notrack jmp *0x802c80(,%eax,4)
  800445:	00 
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800449:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80044d:	eb d8                	jmp    800427 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800452:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800456:	eb cf                	jmp    800427 <vprintfmt+0x39>
  800458:	0f b6 d2             	movzbl %dl,%edx
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
  800463:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800466:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800469:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800470:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800473:	83 f9 09             	cmp    $0x9,%ecx
  800476:	77 55                	ja     8004cd <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800478:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80047b:	eb e9                	jmp    800466 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8d 40 04             	lea    0x4(%eax),%eax
  80048b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800491:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800495:	79 90                	jns    800427 <vprintfmt+0x39>
				width = precision, precision = -1;
  800497:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a4:	eb 81                	jmp    800427 <vprintfmt+0x39>
  8004a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b0:	0f 49 d0             	cmovns %eax,%edx
  8004b3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b9:	e9 69 ff ff ff       	jmp    800427 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004c8:	e9 5a ff ff ff       	jmp    800427 <vprintfmt+0x39>
  8004cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d3:	eb bc                	jmp    800491 <vprintfmt+0xa3>
			lflag++;
  8004d5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004db:	e9 47 ff ff ff       	jmp    800427 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 78 04             	lea    0x4(%eax),%edi
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 30                	pushl  (%eax)
  8004ec:	ff d6                	call   *%esi
			break;
  8004ee:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004f1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f4:	e9 9b 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 78 04             	lea    0x4(%eax),%edi
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	99                   	cltd   
  800502:	31 d0                	xor    %edx,%eax
  800504:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800506:	83 f8 0f             	cmp    $0xf,%eax
  800509:	7f 23                	jg     80052e <vprintfmt+0x140>
  80050b:	8b 14 85 e0 2d 80 00 	mov    0x802de0(,%eax,4),%edx
  800512:	85 d2                	test   %edx,%edx
  800514:	74 18                	je     80052e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800516:	52                   	push   %edx
  800517:	68 91 30 80 00       	push   $0x803091
  80051c:	53                   	push   %ebx
  80051d:	56                   	push   %esi
  80051e:	e8 aa fe ff ff       	call   8003cd <printfmt>
  800523:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
  800529:	e9 66 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80052e:	50                   	push   %eax
  80052f:	68 53 2b 80 00       	push   $0x802b53
  800534:	53                   	push   %ebx
  800535:	56                   	push   %esi
  800536:	e8 92 fe ff ff       	call   8003cd <printfmt>
  80053b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800541:	e9 4e 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	83 c0 04             	add    $0x4,%eax
  80054c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800554:	85 d2                	test   %edx,%edx
  800556:	b8 4c 2b 80 00       	mov    $0x802b4c,%eax
  80055b:	0f 45 c2             	cmovne %edx,%eax
  80055e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800565:	7e 06                	jle    80056d <vprintfmt+0x17f>
  800567:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80056b:	75 0d                	jne    80057a <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800570:	89 c7                	mov    %eax,%edi
  800572:	03 45 e0             	add    -0x20(%ebp),%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800578:	eb 55                	jmp    8005cf <vprintfmt+0x1e1>
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 d8             	pushl  -0x28(%ebp)
  800580:	ff 75 cc             	pushl  -0x34(%ebp)
  800583:	e8 46 03 00 00       	call   8008ce <strnlen>
  800588:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058b:	29 c2                	sub    %eax,%edx
  80058d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800595:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800599:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80059c:	85 ff                	test   %edi,%edi
  80059e:	7e 11                	jle    8005b1 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	53                   	push   %ebx
  8005a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a9:	83 ef 01             	sub    $0x1,%edi
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb eb                	jmp    80059c <vprintfmt+0x1ae>
  8005b1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005b4:	85 d2                	test   %edx,%edx
  8005b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bb:	0f 49 c2             	cmovns %edx,%eax
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005c3:	eb a8                	jmp    80056d <vprintfmt+0x17f>
					putch(ch, putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	52                   	push   %edx
  8005ca:	ff d6                	call   *%esi
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d4:	83 c7 01             	add    $0x1,%edi
  8005d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005db:	0f be d0             	movsbl %al,%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	74 4b                	je     80062d <vprintfmt+0x23f>
  8005e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e6:	78 06                	js     8005ee <vprintfmt+0x200>
  8005e8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ec:	78 1e                	js     80060c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f2:	74 d1                	je     8005c5 <vprintfmt+0x1d7>
  8005f4:	0f be c0             	movsbl %al,%eax
  8005f7:	83 e8 20             	sub    $0x20,%eax
  8005fa:	83 f8 5e             	cmp    $0x5e,%eax
  8005fd:	76 c6                	jbe    8005c5 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	6a 3f                	push   $0x3f
  800605:	ff d6                	call   *%esi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	eb c3                	jmp    8005cf <vprintfmt+0x1e1>
  80060c:	89 cf                	mov    %ecx,%edi
  80060e:	eb 0e                	jmp    80061e <vprintfmt+0x230>
				putch(' ', putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	6a 20                	push   $0x20
  800616:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800618:	83 ef 01             	sub    $0x1,%edi
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	85 ff                	test   %edi,%edi
  800620:	7f ee                	jg     800610 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	e9 67 01 00 00       	jmp    800794 <vprintfmt+0x3a6>
  80062d:	89 cf                	mov    %ecx,%edi
  80062f:	eb ed                	jmp    80061e <vprintfmt+0x230>
	if (lflag >= 2)
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7f 1b                	jg     800651 <vprintfmt+0x263>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	74 63                	je     80069d <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	99                   	cltd   
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 17                	jmp    800668 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 50 04             	mov    0x4(%eax),%edx
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800668:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80066e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800673:	85 c9                	test   %ecx,%ecx
  800675:	0f 89 ff 00 00 00    	jns    80077a <vprintfmt+0x38c>
				putch('-', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 2d                	push   $0x2d
  800681:	ff d6                	call   *%esi
				num = -(long long) num;
  800683:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800686:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800689:	f7 da                	neg    %edx
  80068b:	83 d1 00             	adc    $0x0,%ecx
  80068e:	f7 d9                	neg    %ecx
  800690:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800693:	b8 0a 00 00 00       	mov    $0xa,%eax
  800698:	e9 dd 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	99                   	cltd   
  8006a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb b4                	jmp    800668 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006b4:	83 f9 01             	cmp    $0x1,%ecx
  8006b7:	7f 1e                	jg     8006d7 <vprintfmt+0x2e9>
	else if (lflag)
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	74 32                	je     8006ef <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006d2:	e9 a3 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006df:	8d 40 08             	lea    0x8(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006ea:	e9 8b 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800704:	eb 74                	jmp    80077a <vprintfmt+0x38c>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x338>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80071f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800724:	eb 54                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800734:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800739:	eb 3f                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80074b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800750:	eb 28                	jmp    80077a <vprintfmt+0x38c>
			putch('0', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 30                	push   $0x30
  800758:	ff d6                	call   *%esi
			putch('x', putdat);
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 78                	push   $0x78
  800760:	ff d6                	call   *%esi
			num = (unsigned long long)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80076c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077a:	83 ec 0c             	sub    $0xc,%esp
  80077d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800781:	57                   	push   %edi
  800782:	ff 75 e0             	pushl  -0x20(%ebp)
  800785:	50                   	push   %eax
  800786:	51                   	push   %ecx
  800787:	52                   	push   %edx
  800788:	89 da                	mov    %ebx,%edx
  80078a:	89 f0                	mov    %esi,%eax
  80078c:	e8 72 fb ff ff       	call   800303 <printnum>
			break;
  800791:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800797:	83 c7 01             	add    $0x1,%edi
  80079a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079e:	83 f8 25             	cmp    $0x25,%eax
  8007a1:	0f 84 62 fc ff ff    	je     800409 <vprintfmt+0x1b>
			if (ch == '\0')
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	0f 84 8b 00 00 00    	je     80083a <vprintfmt+0x44c>
			putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	50                   	push   %eax
  8007b4:	ff d6                	call   *%esi
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	eb dc                	jmp    800797 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007bb:	83 f9 01             	cmp    $0x1,%ecx
  8007be:	7f 1b                	jg     8007db <vprintfmt+0x3ed>
	else if (lflag)
  8007c0:	85 c9                	test   %ecx,%ecx
  8007c2:	74 2c                	je     8007f0 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 10                	mov    (%eax),%edx
  8007c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8007d9:	eb 9f                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e3:	8d 40 08             	lea    0x8(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007ee:	eb 8a                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fa:	8d 40 04             	lea    0x4(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800800:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800805:	e9 70 ff ff ff       	jmp    80077a <vprintfmt+0x38c>
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	53                   	push   %ebx
  80080e:	6a 25                	push   $0x25
  800810:	ff d6                	call   *%esi
			break;
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	e9 7a ff ff ff       	jmp    800794 <vprintfmt+0x3a6>
			putch('%', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 25                	push   $0x25
  800820:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	89 f8                	mov    %edi,%eax
  800827:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082b:	74 05                	je     800832 <vprintfmt+0x444>
  80082d:	83 e8 01             	sub    $0x1,%eax
  800830:	eb f5                	jmp    800827 <vprintfmt+0x439>
  800832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800835:	e9 5a ff ff ff       	jmp    800794 <vprintfmt+0x3a6>
}
  80083a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5f                   	pop    %edi
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800842:	f3 0f 1e fb          	endbr32 
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	83 ec 18             	sub    $0x18,%esp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800855:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800859:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800863:	85 c0                	test   %eax,%eax
  800865:	74 26                	je     80088d <vsnprintf+0x4b>
  800867:	85 d2                	test   %edx,%edx
  800869:	7e 22                	jle    80088d <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086b:	ff 75 14             	pushl  0x14(%ebp)
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800874:	50                   	push   %eax
  800875:	68 ac 03 80 00       	push   $0x8003ac
  80087a:	e8 6f fb ff ff       	call   8003ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb f7                	jmp    80088b <vsnprintf+0x49>

00800894 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800894:	f3 0f 1e fb          	endbr32 
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a1:	50                   	push   %eax
  8008a2:	ff 75 10             	pushl  0x10(%ebp)
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 92 ff ff ff       	call   800842 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b2:	f3 0f 1e fb          	endbr32 
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c5:	74 05                	je     8008cc <strlen+0x1a>
		n++;
  8008c7:	83 c0 01             	add    $0x1,%eax
  8008ca:	eb f5                	jmp    8008c1 <strlen+0xf>
	return n;
}
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ce:	f3 0f 1e fb          	endbr32 
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	39 d0                	cmp    %edx,%eax
  8008e2:	74 0d                	je     8008f1 <strnlen+0x23>
  8008e4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e8:	74 05                	je     8008ef <strnlen+0x21>
		n++;
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	eb f1                	jmp    8008e0 <strnlen+0x12>
  8008ef:	89 c2                	mov    %eax,%edx
	return n;
}
  8008f1:	89 d0                	mov    %edx,%eax
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f5:	f3 0f 1e fb          	endbr32 
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80090c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80090f:	83 c0 01             	add    $0x1,%eax
  800912:	84 d2                	test   %dl,%dl
  800914:	75 f2                	jne    800908 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800916:	89 c8                	mov    %ecx,%eax
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091b:	f3 0f 1e fb          	endbr32 
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	53                   	push   %ebx
  800923:	83 ec 10             	sub    $0x10,%esp
  800926:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800929:	53                   	push   %ebx
  80092a:	e8 83 ff ff ff       	call   8008b2 <strlen>
  80092f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	01 d8                	add    %ebx,%eax
  800937:	50                   	push   %eax
  800938:	e8 b8 ff ff ff       	call   8008f5 <strcpy>
	return dst;
}
  80093d:	89 d8                	mov    %ebx,%eax
  80093f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800944:	f3 0f 1e fb          	endbr32 
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 75 08             	mov    0x8(%ebp),%esi
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 f3                	mov    %esi,%ebx
  800955:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800958:	89 f0                	mov    %esi,%eax
  80095a:	39 d8                	cmp    %ebx,%eax
  80095c:	74 11                	je     80096f <strncpy+0x2b>
		*dst++ = *src;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	0f b6 0a             	movzbl (%edx),%ecx
  800964:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800967:	80 f9 01             	cmp    $0x1,%cl
  80096a:	83 da ff             	sbb    $0xffffffff,%edx
  80096d:	eb eb                	jmp    80095a <strncpy+0x16>
	}
	return ret;
}
  80096f:	89 f0                	mov    %esi,%eax
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	56                   	push   %esi
  80097d:	53                   	push   %ebx
  80097e:	8b 75 08             	mov    0x8(%ebp),%esi
  800981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800984:	8b 55 10             	mov    0x10(%ebp),%edx
  800987:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800989:	85 d2                	test   %edx,%edx
  80098b:	74 21                	je     8009ae <strlcpy+0x39>
  80098d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800991:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 14                	je     8009ab <strlcpy+0x36>
  800997:	0f b6 19             	movzbl (%ecx),%ebx
  80099a:	84 db                	test   %bl,%bl
  80099c:	74 0b                	je     8009a9 <strlcpy+0x34>
			*dst++ = *src++;
  80099e:	83 c1 01             	add    $0x1,%ecx
  8009a1:	83 c2 01             	add    $0x1,%edx
  8009a4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a7:	eb ea                	jmp    800993 <strlcpy+0x1e>
  8009a9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ae:	29 f0                	sub    %esi,%eax
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c1:	0f b6 01             	movzbl (%ecx),%eax
  8009c4:	84 c0                	test   %al,%al
  8009c6:	74 0c                	je     8009d4 <strcmp+0x20>
  8009c8:	3a 02                	cmp    (%edx),%al
  8009ca:	75 08                	jne    8009d4 <strcmp+0x20>
		p++, q++;
  8009cc:	83 c1 01             	add    $0x1,%ecx
  8009cf:	83 c2 01             	add    $0x1,%edx
  8009d2:	eb ed                	jmp    8009c1 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d4:	0f b6 c0             	movzbl %al,%eax
  8009d7:	0f b6 12             	movzbl (%edx),%edx
  8009da:	29 d0                	sub    %edx,%eax
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 c3                	mov    %eax,%ebx
  8009ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f1:	eb 06                	jmp    8009f9 <strncmp+0x1b>
		n--, p++, q++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f9:	39 d8                	cmp    %ebx,%eax
  8009fb:	74 16                	je     800a13 <strncmp+0x35>
  8009fd:	0f b6 08             	movzbl (%eax),%ecx
  800a00:	84 c9                	test   %cl,%cl
  800a02:	74 04                	je     800a08 <strncmp+0x2a>
  800a04:	3a 0a                	cmp    (%edx),%cl
  800a06:	74 eb                	je     8009f3 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 00             	movzbl (%eax),%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    
		return 0;
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
  800a18:	eb f6                	jmp    800a10 <strncmp+0x32>

00800a1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a28:	0f b6 10             	movzbl (%eax),%edx
  800a2b:	84 d2                	test   %dl,%dl
  800a2d:	74 09                	je     800a38 <strchr+0x1e>
		if (*s == c)
  800a2f:	38 ca                	cmp    %cl,%dl
  800a31:	74 0a                	je     800a3d <strchr+0x23>
	for (; *s; s++)
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f0                	jmp    800a28 <strchr+0xe>
			return (char *) s;
	return 0;
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3f:	f3 0f 1e fb          	endbr32 
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a50:	38 ca                	cmp    %cl,%dl
  800a52:	74 09                	je     800a5d <strfind+0x1e>
  800a54:	84 d2                	test   %dl,%dl
  800a56:	74 05                	je     800a5d <strfind+0x1e>
	for (; *s; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f0                	jmp    800a4d <strfind+0xe>
			break;
	return (char *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a5f:	f3 0f 1e fb          	endbr32 
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6f:	85 c9                	test   %ecx,%ecx
  800a71:	74 31                	je     800aa4 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a73:	89 f8                	mov    %edi,%eax
  800a75:	09 c8                	or     %ecx,%eax
  800a77:	a8 03                	test   $0x3,%al
  800a79:	75 23                	jne    800a9e <memset+0x3f>
		c &= 0xFF;
  800a7b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a7f:	89 d3                	mov    %edx,%ebx
  800a81:	c1 e3 08             	shl    $0x8,%ebx
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	c1 e0 18             	shl    $0x18,%eax
  800a89:	89 d6                	mov    %edx,%esi
  800a8b:	c1 e6 10             	shl    $0x10,%esi
  800a8e:	09 f0                	or     %esi,%eax
  800a90:	09 c2                	or     %eax,%edx
  800a92:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a94:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a97:	89 d0                	mov    %edx,%eax
  800a99:	fc                   	cld    
  800a9a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a9c:	eb 06                	jmp    800aa4 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	fc                   	cld    
  800aa2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa4:	89 f8                	mov    %edi,%eax
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5f                   	pop    %edi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800abd:	39 c6                	cmp    %eax,%esi
  800abf:	73 32                	jae    800af3 <memmove+0x48>
  800ac1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac4:	39 c2                	cmp    %eax,%edx
  800ac6:	76 2b                	jbe    800af3 <memmove+0x48>
		s += n;
		d += n;
  800ac8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 fe                	mov    %edi,%esi
  800acd:	09 ce                	or     %ecx,%esi
  800acf:	09 d6                	or     %edx,%esi
  800ad1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad7:	75 0e                	jne    800ae7 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad9:	83 ef 04             	sub    $0x4,%edi
  800adc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800adf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae2:	fd                   	std    
  800ae3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae5:	eb 09                	jmp    800af0 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae7:	83 ef 01             	sub    $0x1,%edi
  800aea:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aed:	fd                   	std    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af0:	fc                   	cld    
  800af1:	eb 1a                	jmp    800b0d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	09 ca                	or     %ecx,%edx
  800af7:	09 f2                	or     %esi,%edx
  800af9:	f6 c2 03             	test   $0x3,%dl
  800afc:	75 0a                	jne    800b08 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b01:	89 c7                	mov    %eax,%edi
  800b03:	fc                   	cld    
  800b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b06:	eb 05                	jmp    800b0d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b08:	89 c7                	mov    %eax,%edi
  800b0a:	fc                   	cld    
  800b0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b11:	f3 0f 1e fb          	endbr32 
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1b:	ff 75 10             	pushl  0x10(%ebp)
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	e8 82 ff ff ff       	call   800aab <memmove>
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2b:	f3 0f 1e fb          	endbr32 
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 c6                	mov    %eax,%esi
  800b3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3f:	39 f0                	cmp    %esi,%eax
  800b41:	74 1c                	je     800b5f <memcmp+0x34>
		if (*s1 != *s2)
  800b43:	0f b6 08             	movzbl (%eax),%ecx
  800b46:	0f b6 1a             	movzbl (%edx),%ebx
  800b49:	38 d9                	cmp    %bl,%cl
  800b4b:	75 08                	jne    800b55 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4d:	83 c0 01             	add    $0x1,%eax
  800b50:	83 c2 01             	add    $0x1,%edx
  800b53:	eb ea                	jmp    800b3f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b55:	0f b6 c1             	movzbl %cl,%eax
  800b58:	0f b6 db             	movzbl %bl,%ebx
  800b5b:	29 d8                	sub    %ebx,%eax
  800b5d:	eb 05                	jmp    800b64 <memcmp+0x39>
	}

	return 0;
  800b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7a:	39 d0                	cmp    %edx,%eax
  800b7c:	73 09                	jae    800b87 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7e:	38 08                	cmp    %cl,(%eax)
  800b80:	74 05                	je     800b87 <memfind+0x1f>
	for (; s < ends; s++)
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	eb f3                	jmp    800b7a <memfind+0x12>
			break;
	return (void *) s;
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b89:	f3 0f 1e fb          	endbr32 
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b99:	eb 03                	jmp    800b9e <strtol+0x15>
		s++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 01             	movzbl (%ecx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0x12>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	74 2a                	je     800bd7 <strtol+0x4e>
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb2:	3c 2d                	cmp    $0x2d,%al
  800bb4:	74 2b                	je     800be1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbc:	75 0f                	jne    800bcd <strtol+0x44>
  800bbe:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc1:	74 28                	je     800beb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bca:	0f 44 d8             	cmove  %eax,%ebx
  800bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd5:	eb 46                	jmp    800c1d <strtol+0x94>
		s++;
  800bd7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdf:	eb d5                	jmp    800bb6 <strtol+0x2d>
		s++, neg = 1;
  800be1:	83 c1 01             	add    $0x1,%ecx
  800be4:	bf 01 00 00 00       	mov    $0x1,%edi
  800be9:	eb cb                	jmp    800bb6 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800beb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bef:	74 0e                	je     800bff <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	75 d8                	jne    800bcd <strtol+0x44>
		s++, base = 8;
  800bf5:	83 c1 01             	add    $0x1,%ecx
  800bf8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bfd:	eb ce                	jmp    800bcd <strtol+0x44>
		s += 2, base = 16;
  800bff:	83 c1 02             	add    $0x2,%ecx
  800c02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c07:	eb c4                	jmp    800bcd <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c09:	0f be d2             	movsbl %dl,%edx
  800c0c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c12:	7d 3a                	jge    800c4e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c14:	83 c1 01             	add    $0x1,%ecx
  800c17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1d:	0f b6 11             	movzbl (%ecx),%edx
  800c20:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 09             	cmp    $0x9,%bl
  800c28:	76 df                	jbe    800c09 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	80 fb 19             	cmp    $0x19,%bl
  800c32:	77 08                	ja     800c3c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c34:	0f be d2             	movsbl %dl,%edx
  800c37:	83 ea 57             	sub    $0x57,%edx
  800c3a:	eb d3                	jmp    800c0f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3f:	89 f3                	mov    %esi,%ebx
  800c41:	80 fb 19             	cmp    $0x19,%bl
  800c44:	77 08                	ja     800c4e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c46:	0f be d2             	movsbl %dl,%edx
  800c49:	83 ea 37             	sub    $0x37,%edx
  800c4c:	eb c1                	jmp    800c0f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c52:	74 05                	je     800c59 <strtol+0xd0>
		*endptr = (char *) s;
  800c54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c59:	89 c2                	mov    %eax,%edx
  800c5b:	f7 da                	neg    %edx
  800c5d:	85 ff                	test   %edi,%edi
  800c5f:	0f 45 c2             	cmovne %edx,%eax
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c67:	f3 0f 1e fb          	endbr32 
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	89 c6                	mov    %eax,%esi
  800c82:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c89:	f3 0f 1e fb          	endbr32 
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9d:	89 d1                	mov    %edx,%ecx
  800c9f:	89 d3                	mov    %edx,%ebx
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	89 d6                	mov    %edx,%esi
  800ca5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc6:	89 cb                	mov    %ecx,%ebx
  800cc8:	89 cf                	mov    %ecx,%edi
  800cca:	89 ce                	mov    %ecx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 03                	push   $0x3
  800ce0:	68 3f 2e 80 00       	push   $0x802e3f
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 5c 2e 80 00       	push   $0x802e5c
  800cec:	e8 13 f5 ff ff       	call   800204 <_panic>

00800cf1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf1:	f3 0f 1e fb          	endbr32 
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 02 00 00 00       	mov    $0x2,%eax
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	89 d3                	mov    %edx,%ebx
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	89 d6                	mov    %edx,%esi
  800d0d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_yield>:

void
sys_yield(void)
{
  800d14:	f3 0f 1e fb          	endbr32 
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d28:	89 d1                	mov    %edx,%ecx
  800d2a:	89 d3                	mov    %edx,%ebx
  800d2c:	89 d7                	mov    %edx,%edi
  800d2e:	89 d6                	mov    %edx,%esi
  800d30:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d37:	f3 0f 1e fb          	endbr32 
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d44:	be 00 00 00 00       	mov    $0x0,%esi
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d57:	89 f7                	mov    %esi,%edi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d6b:	6a 04                	push   $0x4
  800d6d:	68 3f 2e 80 00       	push   $0x802e3f
  800d72:	6a 23                	push   $0x23
  800d74:	68 5c 2e 80 00       	push   $0x802e5c
  800d79:	e8 86 f4 ff ff       	call   800204 <_panic>

00800d7e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 05 00 00 00       	mov    $0x5,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 05                	push   $0x5
  800db3:	68 3f 2e 80 00       	push   $0x802e3f
  800db8:	6a 23                	push   $0x23
  800dba:	68 5c 2e 80 00       	push   $0x802e5c
  800dbf:	e8 40 f4 ff ff       	call   800204 <_panic>

00800dc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 06 00 00 00       	mov    $0x6,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 06                	push   $0x6
  800df9:	68 3f 2e 80 00       	push   $0x802e3f
  800dfe:	6a 23                	push   $0x23
  800e00:	68 5c 2e 80 00       	push   $0x802e5c
  800e05:	e8 fa f3 ff ff       	call   800204 <_panic>

00800e0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0a:	f3 0f 1e fb          	endbr32 
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 08 00 00 00       	mov    $0x8,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 08                	push   $0x8
  800e3f:	68 3f 2e 80 00       	push   $0x802e3f
  800e44:	6a 23                	push   $0x23
  800e46:	68 5c 2e 80 00       	push   $0x802e5c
  800e4b:	e8 b4 f3 ff ff       	call   800204 <_panic>

00800e50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 09                	push   $0x9
  800e85:	68 3f 2e 80 00       	push   $0x802e3f
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 5c 2e 80 00       	push   $0x802e5c
  800e91:	e8 6e f3 ff ff       	call   800204 <_panic>

00800e96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e96:	f3 0f 1e fb          	endbr32 
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 0a                	push   $0xa
  800ecb:	68 3f 2e 80 00       	push   $0x802e3f
  800ed0:	6a 23                	push   $0x23
  800ed2:	68 5c 2e 80 00       	push   $0x802e5c
  800ed7:	e8 28 f3 ff ff       	call   800204 <_panic>

00800edc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800edc:	f3 0f 1e fb          	endbr32 
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f03:	f3 0f 1e fb          	endbr32 
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1d:	89 cb                	mov    %ecx,%ebx
  800f1f:	89 cf                	mov    %ecx,%edi
  800f21:	89 ce                	mov    %ecx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	50                   	push   %eax
  800f35:	6a 0d                	push   $0xd
  800f37:	68 3f 2e 80 00       	push   $0x802e3f
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 5c 2e 80 00       	push   $0x802e5c
  800f43:	e8 bc f2 ff ff       	call   800204 <_panic>

00800f48 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800f48:	f3 0f 1e fb          	endbr32 
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f54:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f56:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f5a:	74 7f                	je     800fdb <pgfault+0x93>
  800f5c:	89 f0                	mov    %esi,%eax
  800f5e:	c1 e8 0c             	shr    $0xc,%eax
  800f61:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f68:	f6 c4 08             	test   $0x8,%ah
  800f6b:	74 6e                	je     800fdb <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800f6d:	e8 7f fd ff ff       	call   800cf1 <sys_getenvid>
  800f72:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800f74:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	6a 07                	push   $0x7
  800f7f:	68 00 f0 7f 00       	push   $0x7ff000
  800f84:	50                   	push   %eax
  800f85:	e8 ad fd ff ff       	call   800d37 <sys_page_alloc>
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	78 5e                	js     800fef <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800f91:	83 ec 04             	sub    $0x4,%esp
  800f94:	68 00 10 00 00       	push   $0x1000
  800f99:	56                   	push   %esi
  800f9a:	68 00 f0 7f 00       	push   $0x7ff000
  800f9f:	e8 6d fb ff ff       	call   800b11 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800fa4:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fab:	56                   	push   %esi
  800fac:	53                   	push   %ebx
  800fad:	68 00 f0 7f 00       	push   $0x7ff000
  800fb2:	53                   	push   %ebx
  800fb3:	e8 c6 fd ff ff       	call   800d7e <sys_page_map>
  800fb8:	83 c4 20             	add    $0x20,%esp
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	78 44                	js     801003 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	68 00 f0 7f 00       	push   $0x7ff000
  800fc7:	53                   	push   %ebx
  800fc8:	e8 f7 fd ff ff       	call   800dc4 <sys_page_unmap>
  800fcd:	83 c4 10             	add    $0x10,%esp
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	78 43                	js     801017 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800fd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800fdb:	83 ec 04             	sub    $0x4,%esp
  800fde:	68 6a 2e 80 00       	push   $0x802e6a
  800fe3:	6a 1e                	push   $0x1e
  800fe5:	68 87 2e 80 00       	push   $0x802e87
  800fea:	e8 15 f2 ff ff       	call   800204 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 18 2f 80 00       	push   $0x802f18
  800ff7:	6a 2b                	push   $0x2b
  800ff9:	68 87 2e 80 00       	push   $0x802e87
  800ffe:	e8 01 f2 ff ff       	call   800204 <_panic>
		panic("pgfault: sys_page_map Failed!");
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 92 2e 80 00       	push   $0x802e92
  80100b:	6a 2f                	push   $0x2f
  80100d:	68 87 2e 80 00       	push   $0x802e87
  801012:	e8 ed f1 ff ff       	call   800204 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  801017:	83 ec 04             	sub    $0x4,%esp
  80101a:	68 38 2f 80 00       	push   $0x802f38
  80101f:	6a 32                	push   $0x32
  801021:	68 87 2e 80 00       	push   $0x802e87
  801026:	e8 d9 f1 ff ff       	call   800204 <_panic>

0080102b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80102b:	f3 0f 1e fb          	endbr32 
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
  801035:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801038:	68 48 0f 80 00       	push   $0x800f48
  80103d:	e8 d5 15 00 00       	call   802617 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801042:	b8 07 00 00 00       	mov    $0x7,%eax
  801047:	cd 30                	int    $0x30
  801049:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80104c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  80104f:	83 c4 10             	add    $0x10,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	78 2b                	js     801081 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  80105b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80105f:	0f 85 ba 00 00 00    	jne    80111f <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  801065:	e8 87 fc ff ff       	call   800cf1 <sys_getenvid>
  80106a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80106f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801072:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801077:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80107c:	e9 90 01 00 00       	jmp    801211 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	68 b0 2e 80 00       	push   $0x802eb0
  801089:	6a 76                	push   $0x76
  80108b:	68 87 2e 80 00       	push   $0x802e87
  801090:	e8 6f f1 ff ff       	call   800204 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  801095:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  80109c:	e8 50 fc ff ff       	call   800cf1 <sys_getenvid>
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  8010aa:	56                   	push   %esi
  8010ab:	57                   	push   %edi
  8010ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8010af:	57                   	push   %edi
  8010b0:	50                   	push   %eax
  8010b1:	e8 c8 fc ff ff       	call   800d7e <sys_page_map>
  8010b6:	83 c4 20             	add    $0x20,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	79 50                	jns    80110d <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 c9 2e 80 00       	push   $0x802ec9
  8010c5:	6a 4b                	push   $0x4b
  8010c7:	68 87 2e 80 00       	push   $0x802e87
  8010cc:	e8 33 f1 ff ff       	call   800204 <_panic>
			panic("duppage:child sys_page_map Failed!");
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	68 58 2f 80 00       	push   $0x802f58
  8010d9:	6a 50                	push   $0x50
  8010db:	68 87 2e 80 00       	push   $0x802e87
  8010e0:	e8 1f f1 ff ff       	call   800204 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  8010e5:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010ec:	83 ec 0c             	sub    $0xc,%esp
  8010ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f4:	50                   	push   %eax
  8010f5:	57                   	push   %edi
  8010f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8010f9:	57                   	push   %edi
  8010fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010fd:	e8 7c fc ff ff       	call   800d7e <sys_page_map>
  801102:	83 c4 20             	add    $0x20,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	0f 88 b4 00 00 00    	js     8011c1 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  80110d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801113:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801119:	0f 84 b6 00 00 00    	je     8011d5 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  80111f:	89 d8                	mov    %ebx,%eax
  801121:	c1 e8 16             	shr    $0x16,%eax
  801124:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112b:	a8 01                	test   $0x1,%al
  80112d:	74 de                	je     80110d <fork+0xe2>
  80112f:	89 de                	mov    %ebx,%esi
  801131:	c1 ee 0c             	shr    $0xc,%esi
  801134:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80113b:	a8 01                	test   $0x1,%al
  80113d:	74 ce                	je     80110d <fork+0xe2>
	envid_t f_id=sys_getenvid();
  80113f:	e8 ad fb ff ff       	call   800cf1 <sys_getenvid>
  801144:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801147:	89 f7                	mov    %esi,%edi
  801149:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80114c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801153:	f6 c4 04             	test   $0x4,%ah
  801156:	0f 85 39 ff ff ff    	jne    801095 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80115c:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801163:	a9 02 08 00 00       	test   $0x802,%eax
  801168:	0f 84 77 ff ff ff    	je     8010e5 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	68 05 08 00 00       	push   $0x805
  801176:	57                   	push   %edi
  801177:	ff 75 e0             	pushl  -0x20(%ebp)
  80117a:	57                   	push   %edi
  80117b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117e:	e8 fb fb ff ff       	call   800d7e <sys_page_map>
  801183:	83 c4 20             	add    $0x20,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	0f 88 43 ff ff ff    	js     8010d1 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	68 05 08 00 00       	push   $0x805
  801196:	57                   	push   %edi
  801197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80119a:	50                   	push   %eax
  80119b:	57                   	push   %edi
  80119c:	50                   	push   %eax
  80119d:	e8 dc fb ff ff       	call   800d7e <sys_page_map>
  8011a2:	83 c4 20             	add    $0x20,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	0f 89 60 ff ff ff    	jns    80110d <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	68 7c 2f 80 00       	push   $0x802f7c
  8011b5:	6a 52                	push   $0x52
  8011b7:	68 87 2e 80 00       	push   $0x802e87
  8011bc:	e8 43 f0 ff ff       	call   800204 <_panic>
			panic("duppage: single sys_page_map Failed!");
  8011c1:	83 ec 04             	sub    $0x4,%esp
  8011c4:	68 a0 2f 80 00       	push   $0x802fa0
  8011c9:	6a 56                	push   $0x56
  8011cb:	68 87 2e 80 00       	push   $0x802e87
  8011d0:	e8 2f f0 ff ff       	call   800204 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	6a 07                	push   $0x7
  8011da:	68 00 f0 bf ee       	push   $0xeebff000
  8011df:	ff 75 dc             	pushl  -0x24(%ebp)
  8011e2:	e8 50 fb ff ff       	call   800d37 <sys_page_alloc>
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 2e                	js     80121c <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	68 93 26 80 00       	push   $0x802693
  8011f6:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8011f9:	57                   	push   %edi
  8011fa:	e8 97 fc ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  8011ff:	83 c4 08             	add    $0x8,%esp
  801202:	6a 02                	push   $0x2
  801204:	57                   	push   %edi
  801205:	e8 00 fc ff ff       	call   800e0a <sys_env_set_status>
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	78 22                	js     801233 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801211:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801214:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 e6 2e 80 00       	push   $0x802ee6
  801224:	68 83 00 00 00       	push   $0x83
  801229:	68 87 2e 80 00       	push   $0x802e87
  80122e:	e8 d1 ef ff ff       	call   800204 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801233:	83 ec 04             	sub    $0x4,%esp
  801236:	68 c8 2f 80 00       	push   $0x802fc8
  80123b:	68 89 00 00 00       	push   $0x89
  801240:	68 87 2e 80 00       	push   $0x802e87
  801245:	e8 ba ef ff ff       	call   800204 <_panic>

0080124a <sfork>:

// Challenge!
int
sfork(void)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801254:	68 02 2f 80 00       	push   $0x802f02
  801259:	68 93 00 00 00       	push   $0x93
  80125e:	68 87 2e 80 00       	push   $0x802e87
  801263:	e8 9c ef ff ff       	call   800204 <_panic>

00801268 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801268:	f3 0f 1e fb          	endbr32 
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	05 00 00 00 30       	add    $0x30000000,%eax
  801277:	c1 e8 0c             	shr    $0xc,%eax
}
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80127c:	f3 0f 1e fb          	endbr32 
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80128b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801290:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    

00801297 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801297:	f3 0f 1e fb          	endbr32 
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	c1 ea 16             	shr    $0x16,%edx
  8012a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012af:	f6 c2 01             	test   $0x1,%dl
  8012b2:	74 2d                	je     8012e1 <fd_alloc+0x4a>
  8012b4:	89 c2                	mov    %eax,%edx
  8012b6:	c1 ea 0c             	shr    $0xc,%edx
  8012b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c0:	f6 c2 01             	test   $0x1,%dl
  8012c3:	74 1c                	je     8012e1 <fd_alloc+0x4a>
  8012c5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012ca:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012cf:	75 d2                	jne    8012a3 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012da:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012df:	eb 0a                	jmp    8012eb <fd_alloc+0x54>
			*fd_store = fd;
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012ed:	f3 0f 1e fb          	endbr32 
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012f7:	83 f8 1f             	cmp    $0x1f,%eax
  8012fa:	77 30                	ja     80132c <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012fc:	c1 e0 0c             	shl    $0xc,%eax
  8012ff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801304:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80130a:	f6 c2 01             	test   $0x1,%dl
  80130d:	74 24                	je     801333 <fd_lookup+0x46>
  80130f:	89 c2                	mov    %eax,%edx
  801311:	c1 ea 0c             	shr    $0xc,%edx
  801314:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	74 1a                	je     80133a <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801320:	8b 55 0c             	mov    0xc(%ebp),%edx
  801323:	89 02                	mov    %eax,(%edx)
	return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    
		return -E_INVAL;
  80132c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801331:	eb f7                	jmp    80132a <fd_lookup+0x3d>
		return -E_INVAL;
  801333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801338:	eb f0                	jmp    80132a <fd_lookup+0x3d>
  80133a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133f:	eb e9                	jmp    80132a <fd_lookup+0x3d>

00801341 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801341:	f3 0f 1e fb          	endbr32 
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134e:	ba 68 30 80 00       	mov    $0x803068,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801353:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801358:	39 08                	cmp    %ecx,(%eax)
  80135a:	74 33                	je     80138f <dev_lookup+0x4e>
  80135c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80135f:	8b 02                	mov    (%edx),%eax
  801361:	85 c0                	test   %eax,%eax
  801363:	75 f3                	jne    801358 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801365:	a1 04 50 80 00       	mov    0x805004,%eax
  80136a:	8b 40 48             	mov    0x48(%eax),%eax
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	51                   	push   %ecx
  801371:	50                   	push   %eax
  801372:	68 ec 2f 80 00       	push   $0x802fec
  801377:	e8 6f ef ff ff       	call   8002eb <cprintf>
	*dev = 0;
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    
			*dev = devtab[i];
  80138f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801392:	89 01                	mov    %eax,(%ecx)
			return 0;
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
  801399:	eb f2                	jmp    80138d <dev_lookup+0x4c>

0080139b <fd_close>:
{
  80139b:	f3 0f 1e fb          	endbr32 
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	57                   	push   %edi
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
  8013a5:	83 ec 24             	sub    $0x24,%esp
  8013a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8013ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013b8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013bb:	50                   	push   %eax
  8013bc:	e8 2c ff ff ff       	call   8012ed <fd_lookup>
  8013c1:	89 c3                	mov    %eax,%ebx
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 05                	js     8013cf <fd_close+0x34>
	    || fd != fd2)
  8013ca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013cd:	74 16                	je     8013e5 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013cf:	89 f8                	mov    %edi,%eax
  8013d1:	84 c0                	test   %al,%al
  8013d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d8:	0f 44 d8             	cmove  %eax,%ebx
}
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013eb:	50                   	push   %eax
  8013ec:	ff 36                	pushl  (%esi)
  8013ee:	e8 4e ff ff ff       	call   801341 <dev_lookup>
  8013f3:	89 c3                	mov    %eax,%ebx
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	78 1a                	js     801416 <fd_close+0x7b>
		if (dev->dev_close)
  8013fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ff:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801402:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801407:	85 c0                	test   %eax,%eax
  801409:	74 0b                	je     801416 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	56                   	push   %esi
  80140f:	ff d0                	call   *%eax
  801411:	89 c3                	mov    %eax,%ebx
  801413:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	56                   	push   %esi
  80141a:	6a 00                	push   $0x0
  80141c:	e8 a3 f9 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	eb b5                	jmp    8013db <fd_close+0x40>

00801426 <close>:

int
close(int fdnum)
{
  801426:	f3 0f 1e fb          	endbr32 
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801430:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801433:	50                   	push   %eax
  801434:	ff 75 08             	pushl  0x8(%ebp)
  801437:	e8 b1 fe ff ff       	call   8012ed <fd_lookup>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	79 02                	jns    801445 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    
		return fd_close(fd, 1);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	6a 01                	push   $0x1
  80144a:	ff 75 f4             	pushl  -0xc(%ebp)
  80144d:	e8 49 ff ff ff       	call   80139b <fd_close>
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	eb ec                	jmp    801443 <close+0x1d>

00801457 <close_all>:

void
close_all(void)
{
  801457:	f3 0f 1e fb          	endbr32 
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	53                   	push   %ebx
  80145f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801462:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	53                   	push   %ebx
  80146b:	e8 b6 ff ff ff       	call   801426 <close>
	for (i = 0; i < MAXFD; i++)
  801470:	83 c3 01             	add    $0x1,%ebx
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	83 fb 20             	cmp    $0x20,%ebx
  801479:	75 ec                	jne    801467 <close_all+0x10>
}
  80147b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801480:	f3 0f 1e fb          	endbr32 
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80148d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	ff 75 08             	pushl  0x8(%ebp)
  801494:	e8 54 fe ff ff       	call   8012ed <fd_lookup>
  801499:	89 c3                	mov    %eax,%ebx
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	0f 88 81 00 00 00    	js     801527 <dup+0xa7>
		return r;
	close(newfdnum);
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	e8 75 ff ff ff       	call   801426 <close>

	newfd = INDEX2FD(newfdnum);
  8014b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014b4:	c1 e6 0c             	shl    $0xc,%esi
  8014b7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014bd:	83 c4 04             	add    $0x4,%esp
  8014c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014c3:	e8 b4 fd ff ff       	call   80127c <fd2data>
  8014c8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014ca:	89 34 24             	mov    %esi,(%esp)
  8014cd:	e8 aa fd ff ff       	call   80127c <fd2data>
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014d7:	89 d8                	mov    %ebx,%eax
  8014d9:	c1 e8 16             	shr    $0x16,%eax
  8014dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e3:	a8 01                	test   $0x1,%al
  8014e5:	74 11                	je     8014f8 <dup+0x78>
  8014e7:	89 d8                	mov    %ebx,%eax
  8014e9:	c1 e8 0c             	shr    $0xc,%eax
  8014ec:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014f3:	f6 c2 01             	test   $0x1,%dl
  8014f6:	75 39                	jne    801531 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014fb:	89 d0                	mov    %edx,%eax
  8014fd:	c1 e8 0c             	shr    $0xc,%eax
  801500:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	25 07 0e 00 00       	and    $0xe07,%eax
  80150f:	50                   	push   %eax
  801510:	56                   	push   %esi
  801511:	6a 00                	push   $0x0
  801513:	52                   	push   %edx
  801514:	6a 00                	push   $0x0
  801516:	e8 63 f8 ff ff       	call   800d7e <sys_page_map>
  80151b:	89 c3                	mov    %eax,%ebx
  80151d:	83 c4 20             	add    $0x20,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 31                	js     801555 <dup+0xd5>
		goto err;

	return newfdnum;
  801524:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801527:	89 d8                	mov    %ebx,%eax
  801529:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801531:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	25 07 0e 00 00       	and    $0xe07,%eax
  801540:	50                   	push   %eax
  801541:	57                   	push   %edi
  801542:	6a 00                	push   $0x0
  801544:	53                   	push   %ebx
  801545:	6a 00                	push   $0x0
  801547:	e8 32 f8 ff ff       	call   800d7e <sys_page_map>
  80154c:	89 c3                	mov    %eax,%ebx
  80154e:	83 c4 20             	add    $0x20,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	79 a3                	jns    8014f8 <dup+0x78>
	sys_page_unmap(0, newfd);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	56                   	push   %esi
  801559:	6a 00                	push   $0x0
  80155b:	e8 64 f8 ff ff       	call   800dc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801560:	83 c4 08             	add    $0x8,%esp
  801563:	57                   	push   %edi
  801564:	6a 00                	push   $0x0
  801566:	e8 59 f8 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	eb b7                	jmp    801527 <dup+0xa7>

00801570 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801570:	f3 0f 1e fb          	endbr32 
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	53                   	push   %ebx
  801578:	83 ec 1c             	sub    $0x1c,%esp
  80157b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	53                   	push   %ebx
  801583:	e8 65 fd ff ff       	call   8012ed <fd_lookup>
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 3f                	js     8015ce <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	ff 30                	pushl  (%eax)
  80159b:	e8 a1 fd ff ff       	call   801341 <dev_lookup>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 27                	js     8015ce <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015aa:	8b 42 08             	mov    0x8(%edx),%eax
  8015ad:	83 e0 03             	and    $0x3,%eax
  8015b0:	83 f8 01             	cmp    $0x1,%eax
  8015b3:	74 1e                	je     8015d3 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b8:	8b 40 08             	mov    0x8(%eax),%eax
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	74 35                	je     8015f4 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	ff 75 10             	pushl  0x10(%ebp)
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	52                   	push   %edx
  8015c9:	ff d0                	call   *%eax
  8015cb:	83 c4 10             	add    $0x10,%esp
}
  8015ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015d8:	8b 40 48             	mov    0x48(%eax),%eax
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	53                   	push   %ebx
  8015df:	50                   	push   %eax
  8015e0:	68 2d 30 80 00       	push   $0x80302d
  8015e5:	e8 01 ed ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f2:	eb da                	jmp    8015ce <read+0x5e>
		return -E_NOT_SUPP;
  8015f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f9:	eb d3                	jmp    8015ce <read+0x5e>

008015fb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015fb:	f3 0f 1e fb          	endbr32 
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	57                   	push   %edi
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 0c             	sub    $0xc,%esp
  801608:	8b 7d 08             	mov    0x8(%ebp),%edi
  80160b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80160e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801613:	eb 02                	jmp    801617 <readn+0x1c>
  801615:	01 c3                	add    %eax,%ebx
  801617:	39 f3                	cmp    %esi,%ebx
  801619:	73 21                	jae    80163c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	89 f0                	mov    %esi,%eax
  801620:	29 d8                	sub    %ebx,%eax
  801622:	50                   	push   %eax
  801623:	89 d8                	mov    %ebx,%eax
  801625:	03 45 0c             	add    0xc(%ebp),%eax
  801628:	50                   	push   %eax
  801629:	57                   	push   %edi
  80162a:	e8 41 ff ff ff       	call   801570 <read>
		if (m < 0)
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 04                	js     80163a <readn+0x3f>
			return m;
		if (m == 0)
  801636:	75 dd                	jne    801615 <readn+0x1a>
  801638:	eb 02                	jmp    80163c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80163c:	89 d8                	mov    %ebx,%eax
  80163e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801641:	5b                   	pop    %ebx
  801642:	5e                   	pop    %esi
  801643:	5f                   	pop    %edi
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    

00801646 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801646:	f3 0f 1e fb          	endbr32 
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	53                   	push   %ebx
  80164e:	83 ec 1c             	sub    $0x1c,%esp
  801651:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801654:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801657:	50                   	push   %eax
  801658:	53                   	push   %ebx
  801659:	e8 8f fc ff ff       	call   8012ed <fd_lookup>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 3a                	js     80169f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166f:	ff 30                	pushl  (%eax)
  801671:	e8 cb fc ff ff       	call   801341 <dev_lookup>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 22                	js     80169f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801684:	74 1e                	je     8016a4 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801689:	8b 52 0c             	mov    0xc(%edx),%edx
  80168c:	85 d2                	test   %edx,%edx
  80168e:	74 35                	je     8016c5 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	ff 75 10             	pushl  0x10(%ebp)
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	50                   	push   %eax
  80169a:	ff d2                	call   *%edx
  80169c:	83 c4 10             	add    $0x10,%esp
}
  80169f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016a4:	a1 04 50 80 00       	mov    0x805004,%eax
  8016a9:	8b 40 48             	mov    0x48(%eax),%eax
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	53                   	push   %ebx
  8016b0:	50                   	push   %eax
  8016b1:	68 49 30 80 00       	push   $0x803049
  8016b6:	e8 30 ec ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c3:	eb da                	jmp    80169f <write+0x59>
		return -E_NOT_SUPP;
  8016c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ca:	eb d3                	jmp    80169f <write+0x59>

008016cc <seek>:

int
seek(int fdnum, off_t offset)
{
  8016cc:	f3 0f 1e fb          	endbr32 
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 0b fc ff ff       	call   8012ed <fd_lookup>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 0e                	js     8016f7 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016f9:	f3 0f 1e fb          	endbr32 
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	53                   	push   %ebx
  801701:	83 ec 1c             	sub    $0x1c,%esp
  801704:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801707:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	53                   	push   %ebx
  80170c:	e8 dc fb ff ff       	call   8012ed <fd_lookup>
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	78 37                	js     80174f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801722:	ff 30                	pushl  (%eax)
  801724:	e8 18 fc ff ff       	call   801341 <dev_lookup>
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	85 c0                	test   %eax,%eax
  80172e:	78 1f                	js     80174f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801737:	74 1b                	je     801754 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173c:	8b 52 18             	mov    0x18(%edx),%edx
  80173f:	85 d2                	test   %edx,%edx
  801741:	74 32                	je     801775 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801743:	83 ec 08             	sub    $0x8,%esp
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	50                   	push   %eax
  80174a:	ff d2                	call   *%edx
  80174c:	83 c4 10             	add    $0x10,%esp
}
  80174f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801752:	c9                   	leave  
  801753:	c3                   	ret    
			thisenv->env_id, fdnum);
  801754:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801759:	8b 40 48             	mov    0x48(%eax),%eax
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	53                   	push   %ebx
  801760:	50                   	push   %eax
  801761:	68 0c 30 80 00       	push   $0x80300c
  801766:	e8 80 eb ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801773:	eb da                	jmp    80174f <ftruncate+0x56>
		return -E_NOT_SUPP;
  801775:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80177a:	eb d3                	jmp    80174f <ftruncate+0x56>

0080177c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80177c:	f3 0f 1e fb          	endbr32 
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	53                   	push   %ebx
  801784:	83 ec 1c             	sub    $0x1c,%esp
  801787:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178d:	50                   	push   %eax
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 57 fb ff ff       	call   8012ed <fd_lookup>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 4b                	js     8017e8 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	ff 30                	pushl  (%eax)
  8017a9:	e8 93 fb ff ff       	call   801341 <dev_lookup>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 33                	js     8017e8 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017bc:	74 2f                	je     8017ed <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017be:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017c1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017c8:	00 00 00 
	stat->st_isdir = 0;
  8017cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017d2:	00 00 00 
	stat->st_dev = dev;
  8017d5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	53                   	push   %ebx
  8017df:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e2:	ff 50 14             	call   *0x14(%eax)
  8017e5:	83 c4 10             	add    $0x10,%esp
}
  8017e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    
		return -E_NOT_SUPP;
  8017ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f2:	eb f4                	jmp    8017e8 <fstat+0x6c>

008017f4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017f4:	f3 0f 1e fb          	endbr32 
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	56                   	push   %esi
  8017fc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	6a 00                	push   $0x0
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	e8 fb 01 00 00       	call   801a05 <open>
  80180a:	89 c3                	mov    %eax,%ebx
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 1b                	js     80182e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	50                   	push   %eax
  80181a:	e8 5d ff ff ff       	call   80177c <fstat>
  80181f:	89 c6                	mov    %eax,%esi
	close(fd);
  801821:	89 1c 24             	mov    %ebx,(%esp)
  801824:	e8 fd fb ff ff       	call   801426 <close>
	return r;
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	89 f3                	mov    %esi,%ebx
}
  80182e:	89 d8                	mov    %ebx,%eax
  801830:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	89 c6                	mov    %eax,%esi
  80183e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801840:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801847:	74 27                	je     801870 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801849:	6a 07                	push   $0x7
  80184b:	68 00 60 80 00       	push   $0x806000
  801850:	56                   	push   %esi
  801851:	ff 35 00 50 80 00    	pushl  0x805000
  801857:	e8 c8 0e 00 00       	call   802724 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80185c:	83 c4 0c             	add    $0xc,%esp
  80185f:	6a 00                	push   $0x0
  801861:	53                   	push   %ebx
  801862:	6a 00                	push   $0x0
  801864:	e8 4e 0e 00 00       	call   8026b7 <ipc_recv>
}
  801869:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	6a 01                	push   $0x1
  801875:	e8 04 0f 00 00       	call   80277e <ipc_find_env>
  80187a:	a3 00 50 80 00       	mov    %eax,0x805000
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	eb c5                	jmp    801849 <fsipc+0x12>

00801884 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801884:	f3 0f 1e fb          	endbr32 
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8b 40 0c             	mov    0xc(%eax),%eax
  801894:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a6:	b8 02 00 00 00       	mov    $0x2,%eax
  8018ab:	e8 87 ff ff ff       	call   801837 <fsipc>
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <devfile_flush>:
{
  8018b2:	f3 0f 1e fb          	endbr32 
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c2:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d1:	e8 61 ff ff ff       	call   801837 <fsipc>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <devfile_stat>:
{
  8018d8:	f3 0f 1e fb          	endbr32 
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ec:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	b8 05 00 00 00       	mov    $0x5,%eax
  8018fb:	e8 37 ff ff ff       	call   801837 <fsipc>
  801900:	85 c0                	test   %eax,%eax
  801902:	78 2c                	js     801930 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	68 00 60 80 00       	push   $0x806000
  80190c:	53                   	push   %ebx
  80190d:	e8 e3 ef ff ff       	call   8008f5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801912:	a1 80 60 80 00       	mov    0x806080,%eax
  801917:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80191d:	a1 84 60 80 00       	mov    0x806084,%eax
  801922:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <devfile_write>:
{
  801935:	f3 0f 1e fb          	endbr32 
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	8b 45 10             	mov    0x10(%ebp),%eax
  801942:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801947:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80194c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80194f:	8b 55 08             	mov    0x8(%ebp),%edx
  801952:	8b 52 0c             	mov    0xc(%edx),%edx
  801955:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  80195b:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801960:	50                   	push   %eax
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	68 08 60 80 00       	push   $0x806008
  801969:	e8 3d f1 ff ff       	call   800aab <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
  801973:	b8 04 00 00 00       	mov    $0x4,%eax
  801978:	e8 ba fe ff ff       	call   801837 <fsipc>
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <devfile_read>:
{
  80197f:	f3 0f 1e fb          	endbr32 
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	56                   	push   %esi
  801987:	53                   	push   %ebx
  801988:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	8b 40 0c             	mov    0xc(%eax),%eax
  801991:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801996:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80199c:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8019a6:	e8 8c fe ff ff       	call   801837 <fsipc>
  8019ab:	89 c3                	mov    %eax,%ebx
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	78 1f                	js     8019d0 <devfile_read+0x51>
	assert(r <= n);
  8019b1:	39 f0                	cmp    %esi,%eax
  8019b3:	77 24                	ja     8019d9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ba:	7f 33                	jg     8019ef <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	50                   	push   %eax
  8019c0:	68 00 60 80 00       	push   $0x806000
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 de f0 ff ff       	call   800aab <memmove>
	return r;
  8019cd:	83 c4 10             	add    $0x10,%esp
}
  8019d0:	89 d8                	mov    %ebx,%eax
  8019d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5e                   	pop    %esi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    
	assert(r <= n);
  8019d9:	68 78 30 80 00       	push   $0x803078
  8019de:	68 7f 30 80 00       	push   $0x80307f
  8019e3:	6a 7d                	push   $0x7d
  8019e5:	68 94 30 80 00       	push   $0x803094
  8019ea:	e8 15 e8 ff ff       	call   800204 <_panic>
	assert(r <= PGSIZE);
  8019ef:	68 9f 30 80 00       	push   $0x80309f
  8019f4:	68 7f 30 80 00       	push   $0x80307f
  8019f9:	6a 7e                	push   $0x7e
  8019fb:	68 94 30 80 00       	push   $0x803094
  801a00:	e8 ff e7 ff ff       	call   800204 <_panic>

00801a05 <open>:
{
  801a05:	f3 0f 1e fb          	endbr32 
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 1c             	sub    $0x1c,%esp
  801a11:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a14:	56                   	push   %esi
  801a15:	e8 98 ee ff ff       	call   8008b2 <strlen>
  801a1a:	83 c4 10             	add    $0x10,%esp
  801a1d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a22:	7f 6c                	jg     801a90 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2a:	50                   	push   %eax
  801a2b:	e8 67 f8 ff ff       	call   801297 <fd_alloc>
  801a30:	89 c3                	mov    %eax,%ebx
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 3c                	js     801a75 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a39:	83 ec 08             	sub    $0x8,%esp
  801a3c:	56                   	push   %esi
  801a3d:	68 00 60 80 00       	push   $0x806000
  801a42:	e8 ae ee ff ff       	call   8008f5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	e8 db fd ff ff       	call   801837 <fsipc>
  801a5c:	89 c3                	mov    %eax,%ebx
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 19                	js     801a7e <open+0x79>
	return fd2num(fd);
  801a65:	83 ec 0c             	sub    $0xc,%esp
  801a68:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6b:	e8 f8 f7 ff ff       	call   801268 <fd2num>
  801a70:	89 c3                	mov    %eax,%ebx
  801a72:	83 c4 10             	add    $0x10,%esp
}
  801a75:	89 d8                	mov    %ebx,%eax
  801a77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7a:	5b                   	pop    %ebx
  801a7b:	5e                   	pop    %esi
  801a7c:	5d                   	pop    %ebp
  801a7d:	c3                   	ret    
		fd_close(fd, 0);
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 f4             	pushl  -0xc(%ebp)
  801a86:	e8 10 f9 ff ff       	call   80139b <fd_close>
		return r;
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	eb e5                	jmp    801a75 <open+0x70>
		return -E_BAD_PATH;
  801a90:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a95:	eb de                	jmp    801a75 <open+0x70>

00801a97 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a97:	f3 0f 1e fb          	endbr32 
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa6:	b8 08 00 00 00       	mov    $0x8,%eax
  801aab:	e8 87 fd ff ff       	call   801837 <fsipc>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ab2:	f3 0f 1e fb          	endbr32 
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	57                   	push   %edi
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
  801abc:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	//cprintf("spawn start\n");
	if ((r = open(prog, O_RDONLY)) < 0)
  801ac2:	6a 00                	push   $0x0
  801ac4:	ff 75 08             	pushl  0x8(%ebp)
  801ac7:	e8 39 ff ff ff       	call   801a05 <open>
  801acc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	0f 88 e9 04 00 00    	js     801fc6 <spawn+0x514>
  801add:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;
	
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 00 02 00 00       	push   $0x200
  801ae7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801aed:	50                   	push   %eax
  801aee:	51                   	push   %ecx
  801aef:	e8 07 fb ff ff       	call   8015fb <readn>
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	3d 00 02 00 00       	cmp    $0x200,%eax
  801afc:	75 7e                	jne    801b7c <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801afe:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b05:	45 4c 46 
  801b08:	75 72                	jne    801b7c <spawn+0xca>
  801b0a:	b8 07 00 00 00       	mov    $0x7,%eax
  801b0f:	cd 30                	int    $0x30
  801b11:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801b17:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	0f 88 95 04 00 00    	js     801fba <spawn+0x508>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b25:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b2a:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801b2d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b33:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b39:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b40:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b46:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	char *string_store;
	uintptr_t *argv_store;
	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b4c:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801b51:	be 00 00 00 00       	mov    $0x0,%esi
  801b56:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b59:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801b60:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b63:	85 c0                	test   %eax,%eax
  801b65:	74 4d                	je     801bb4 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	50                   	push   %eax
  801b6b:	e8 42 ed ff ff       	call   8008b2 <strlen>
  801b70:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801b74:	83 c3 01             	add    $0x1,%ebx
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	eb dd                	jmp    801b59 <spawn+0xa7>
		close(fd);
  801b7c:	83 ec 0c             	sub    $0xc,%esp
  801b7f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b85:	e8 9c f8 ff ff       	call   801426 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b8a:	83 c4 0c             	add    $0xc,%esp
  801b8d:	68 7f 45 4c 46       	push   $0x464c457f
  801b92:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801b98:	68 ab 30 80 00       	push   $0x8030ab
  801b9d:	e8 49 e7 ff ff       	call   8002eb <cprintf>
		return -E_NOT_EXEC;
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801bac:	ff ff ff 
  801baf:	e9 12 04 00 00       	jmp    801fc6 <spawn+0x514>
  801bb4:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801bba:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801bc0:	bf 00 10 40 00       	mov    $0x401000,%edi
  801bc5:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801bc7:	89 fa                	mov    %edi,%edx
  801bc9:	83 e2 fc             	and    $0xfffffffc,%edx
  801bcc:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801bd3:	29 c2                	sub    %eax,%edx
  801bd5:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bdb:	8d 42 f8             	lea    -0x8(%edx),%eax
  801bde:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801be3:	0f 86 00 04 00 00    	jbe    801fe9 <spawn+0x537>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	6a 07                	push   $0x7
  801bee:	68 00 00 40 00       	push   $0x400000
  801bf3:	6a 00                	push   $0x0
  801bf5:	e8 3d f1 ff ff       	call   800d37 <sys_page_alloc>
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	0f 88 e9 03 00 00    	js     801fee <spawn+0x53c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)

	for (i = 0; i < argc; i++) {
  801c05:	be 00 00 00 00       	mov    $0x0,%esi
  801c0a:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c13:	eb 30                	jmp    801c45 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801c15:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c1b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c21:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c2a:	57                   	push   %edi
  801c2b:	e8 c5 ec ff ff       	call   8008f5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c30:	83 c4 04             	add    $0x4,%esp
  801c33:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c36:	e8 77 ec ff ff       	call   8008b2 <strlen>
  801c3b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801c3f:	83 c6 01             	add    $0x1,%esi
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801c4b:	7f c8                	jg     801c15 <spawn+0x163>
	}

	argv_store[argc] = 0;
  801c4d:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c53:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801c59:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c60:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c66:	0f 85 82 00 00 00    	jne    801cee <spawn+0x23c>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c6c:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c72:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801c78:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c7b:	89 c8                	mov    %ecx,%eax
  801c7d:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801c83:	89 51 f8             	mov    %edx,-0x8(%ecx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c86:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801c8b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	6a 07                	push   $0x7
  801c96:	68 00 d0 bf ee       	push   $0xeebfd000
  801c9b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ca1:	68 00 00 40 00       	push   $0x400000
  801ca6:	6a 00                	push   $0x0
  801ca8:	e8 d1 f0 ff ff       	call   800d7e <sys_page_map>
  801cad:	83 c4 20             	add    $0x20,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	0f 88 41 03 00 00    	js     801ff9 <spawn+0x547>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	68 00 00 40 00       	push   $0x400000
  801cc0:	6a 00                	push   $0x0
  801cc2:	e8 fd f0 ff ff       	call   800dc4 <sys_page_unmap>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	0f 88 27 03 00 00    	js     801ff9 <spawn+0x547>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801cd2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801cd8:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cdf:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801ce6:	00 00 00 
  801ce9:	e9 4f 01 00 00       	jmp    801e3d <spawn+0x38b>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801cee:	68 20 31 80 00       	push   $0x803120
  801cf3:	68 7f 30 80 00       	push   $0x80307f
  801cf8:	68 ea 00 00 00       	push   $0xea
  801cfd:	68 c5 30 80 00       	push   $0x8030c5
  801d02:	e8 fd e4 ff ff       	call   800204 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	6a 07                	push   $0x7
  801d0c:	68 00 00 40 00       	push   $0x400000
  801d11:	6a 00                	push   $0x0
  801d13:	e8 1f f0 ff ff       	call   800d37 <sys_page_alloc>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	0f 88 b1 02 00 00    	js     801fd4 <spawn+0x522>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d2c:	01 f0                	add    %esi,%eax
  801d2e:	50                   	push   %eax
  801d2f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d35:	e8 92 f9 ff ff       	call   8016cc <seek>
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	0f 88 96 02 00 00    	js     801fdb <spawn+0x529>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801d4e:	29 f0                	sub    %esi,%eax
  801d50:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d55:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801d5a:	0f 47 c1             	cmova  %ecx,%eax
  801d5d:	50                   	push   %eax
  801d5e:	68 00 00 40 00       	push   $0x400000
  801d63:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d69:	e8 8d f8 ff ff       	call   8015fb <readn>
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	85 c0                	test   %eax,%eax
  801d73:	0f 88 69 02 00 00    	js     801fe2 <spawn+0x530>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801d79:	83 ec 0c             	sub    $0xc,%esp
  801d7c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d82:	53                   	push   %ebx
  801d83:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d89:	68 00 00 40 00       	push   $0x400000
  801d8e:	6a 00                	push   $0x0
  801d90:	e8 e9 ef ff ff       	call   800d7e <sys_page_map>
  801d95:	83 c4 20             	add    $0x20,%esp
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	78 7c                	js     801e18 <spawn+0x366>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801d9c:	83 ec 08             	sub    $0x8,%esp
  801d9f:	68 00 00 40 00       	push   $0x400000
  801da4:	6a 00                	push   $0x0
  801da6:	e8 19 f0 ff ff       	call   800dc4 <sys_page_unmap>
  801dab:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801dae:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801db4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dba:	89 fe                	mov    %edi,%esi
  801dbc:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801dc2:	76 69                	jbe    801e2d <spawn+0x37b>
		if (i >= filesz) {
  801dc4:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801dca:	0f 87 37 ff ff ff    	ja     801d07 <spawn+0x255>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801dd9:	53                   	push   %ebx
  801dda:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801de0:	e8 52 ef ff ff       	call   800d37 <sys_page_alloc>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	79 c2                	jns    801dae <spawn+0x2fc>
  801dec:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801df7:	e8 b0 ee ff ff       	call   800cac <sys_env_destroy>
	close(fd);
  801dfc:	83 c4 04             	add    $0x4,%esp
  801dff:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e05:	e8 1c f6 ff ff       	call   801426 <close>
	return r;
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801e13:	e9 ae 01 00 00       	jmp    801fc6 <spawn+0x514>
				panic("spawn: sys_page_map data: %e", r);
  801e18:	50                   	push   %eax
  801e19:	68 d1 30 80 00       	push   $0x8030d1
  801e1e:	68 1b 01 00 00       	push   $0x11b
  801e23:	68 c5 30 80 00       	push   $0x8030c5
  801e28:	e8 d7 e3 ff ff       	call   800204 <_panic>
  801e2d:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801e33:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801e3a:	83 c6 20             	add    $0x20,%esi
  801e3d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801e44:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801e4a:	7e 6d                	jle    801eb9 <spawn+0x407>
		if (ph->p_type != ELF_PROG_LOAD)
  801e4c:	83 3e 01             	cmpl   $0x1,(%esi)
  801e4f:	75 e2                	jne    801e33 <spawn+0x381>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e51:	8b 46 18             	mov    0x18(%esi),%eax
  801e54:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801e57:	83 f8 01             	cmp    $0x1,%eax
  801e5a:	19 c0                	sbb    %eax,%eax
  801e5c:	83 e0 fe             	and    $0xfffffffe,%eax
  801e5f:	83 c0 07             	add    $0x7,%eax
  801e62:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e68:	8b 4e 04             	mov    0x4(%esi),%ecx
  801e6b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801e71:	8b 56 10             	mov    0x10(%esi),%edx
  801e74:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801e7a:	8b 7e 14             	mov    0x14(%esi),%edi
  801e7d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801e83:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801e86:	89 d8                	mov    %ebx,%eax
  801e88:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e8d:	74 1a                	je     801ea9 <spawn+0x3f7>
		va -= i;
  801e8f:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801e91:	01 c7                	add    %eax,%edi
  801e93:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801e99:	01 c2                	add    %eax,%edx
  801e9b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801ea1:	29 c1                	sub    %eax,%ecx
  801ea3:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801ea9:	bf 00 00 00 00       	mov    $0x0,%edi
  801eae:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801eb4:	e9 01 ff ff ff       	jmp    801dba <spawn+0x308>
	close(fd);
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ec2:	e8 5f f5 ff ff       	call   801426 <close>
  801ec7:	83 c4 10             	add    $0x10,%esp
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  801eca:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801ecf:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ed5:	eb 33                	jmp    801f0a <spawn+0x458>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
		sys_page_map(thisenv->env_id,(void *)addr,child,(void *)addr,(uvpt[PGNUM(addr)] & PTE_SYSCALL));
  801ed7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ede:	8b 15 04 50 80 00    	mov    0x805004,%edx
  801ee4:	8b 52 48             	mov    0x48(%edx),%edx
  801ee7:	83 ec 0c             	sub    $0xc,%esp
  801eea:	25 07 0e 00 00       	and    $0xe07,%eax
  801eef:	50                   	push   %eax
  801ef0:	53                   	push   %ebx
  801ef1:	56                   	push   %esi
  801ef2:	53                   	push   %ebx
  801ef3:	52                   	push   %edx
  801ef4:	e8 85 ee ff ff       	call   800d7e <sys_page_map>
  801ef9:	83 c4 20             	add    $0x20,%esp
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  801efc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f02:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801f08:	74 3b                	je     801f45 <spawn+0x493>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
  801f0a:	89 d8                	mov    %ebx,%eax
  801f0c:	c1 e8 16             	shr    $0x16,%eax
  801f0f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f16:	a8 01                	test   $0x1,%al
  801f18:	74 e2                	je     801efc <spawn+0x44a>
  801f1a:	89 d8                	mov    %ebx,%eax
  801f1c:	c1 e8 0c             	shr    $0xc,%eax
  801f1f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f26:	f6 c2 01             	test   $0x1,%dl
  801f29:	74 d1                	je     801efc <spawn+0x44a>
  801f2b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f32:	f6 c2 04             	test   $0x4,%dl
  801f35:	74 c5                	je     801efc <spawn+0x44a>
  801f37:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f3e:	f6 c6 04             	test   $0x4,%dh
  801f41:	74 b9                	je     801efc <spawn+0x44a>
  801f43:	eb 92                	jmp    801ed7 <spawn+0x425>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801f45:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801f4c:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801f4f:	83 ec 08             	sub    $0x8,%esp
  801f52:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801f58:	50                   	push   %eax
  801f59:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f5f:	e8 ec ee ff ff       	call   800e50 <sys_env_set_trapframe>
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	78 25                	js     801f90 <spawn+0x4de>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801f6b:	83 ec 08             	sub    $0x8,%esp
  801f6e:	6a 02                	push   $0x2
  801f70:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f76:	e8 8f ee ff ff       	call   800e0a <sys_env_set_status>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 23                	js     801fa5 <spawn+0x4f3>
	return child;
  801f82:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f88:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f8e:	eb 36                	jmp    801fc6 <spawn+0x514>
		panic("sys_env_set_trapframe: %e", r);
  801f90:	50                   	push   %eax
  801f91:	68 ee 30 80 00       	push   $0x8030ee
  801f96:	68 82 00 00 00       	push   $0x82
  801f9b:	68 c5 30 80 00       	push   $0x8030c5
  801fa0:	e8 5f e2 ff ff       	call   800204 <_panic>
		panic("sys_env_set_status: %e", r);
  801fa5:	50                   	push   %eax
  801fa6:	68 08 31 80 00       	push   $0x803108
  801fab:	68 84 00 00 00       	push   $0x84
  801fb0:	68 c5 30 80 00       	push   $0x8030c5
  801fb5:	e8 4a e2 ff ff       	call   800204 <_panic>
		return r;
  801fba:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801fc0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801fc6:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5f                   	pop    %edi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    
  801fd4:	89 c7                	mov    %eax,%edi
  801fd6:	e9 13 fe ff ff       	jmp    801dee <spawn+0x33c>
  801fdb:	89 c7                	mov    %eax,%edi
  801fdd:	e9 0c fe ff ff       	jmp    801dee <spawn+0x33c>
  801fe2:	89 c7                	mov    %eax,%edi
  801fe4:	e9 05 fe ff ff       	jmp    801dee <spawn+0x33c>
		return -E_NO_MEM;
  801fe9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  801fee:	c1 e8 1f             	shr    $0x1f,%eax
  801ff1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ff7:	eb cd                	jmp    801fc6 <spawn+0x514>
	sys_page_unmap(0, UTEMP);
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	68 00 00 40 00       	push   $0x400000
  802001:	6a 00                	push   $0x0
  802003:	e8 bc ed ff ff       	call   800dc4 <sys_page_unmap>
  802008:	83 c4 10             	add    $0x10,%esp
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  80200b:	c7 85 94 fd ff ff 01 	movl   $0x1,-0x26c(%ebp)
  802012:	00 00 00 
  802015:	eb af                	jmp    801fc6 <spawn+0x514>

00802017 <spawnl>:
{
  802017:	f3 0f 1e fb          	endbr32 
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	57                   	push   %edi
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802024:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80202c:	8d 4a 04             	lea    0x4(%edx),%ecx
  80202f:	83 3a 00             	cmpl   $0x0,(%edx)
  802032:	74 07                	je     80203b <spawnl+0x24>
		argc++;
  802034:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802037:	89 ca                	mov    %ecx,%edx
  802039:	eb f1                	jmp    80202c <spawnl+0x15>
	const char *argv[argc+2];
  80203b:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802042:	89 d1                	mov    %edx,%ecx
  802044:	83 e1 f0             	and    $0xfffffff0,%ecx
  802047:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80204d:	89 e6                	mov    %esp,%esi
  80204f:	29 d6                	sub    %edx,%esi
  802051:	89 f2                	mov    %esi,%edx
  802053:	39 d4                	cmp    %edx,%esp
  802055:	74 10                	je     802067 <spawnl+0x50>
  802057:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80205d:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802064:	00 
  802065:	eb ec                	jmp    802053 <spawnl+0x3c>
  802067:	89 ca                	mov    %ecx,%edx
  802069:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80206f:	29 d4                	sub    %edx,%esp
  802071:	85 d2                	test   %edx,%edx
  802073:	74 05                	je     80207a <spawnl+0x63>
  802075:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  80207a:	8d 74 24 03          	lea    0x3(%esp),%esi
  80207e:	89 f2                	mov    %esi,%edx
  802080:	c1 ea 02             	shr    $0x2,%edx
  802083:	83 e6 fc             	and    $0xfffffffc,%esi
  802086:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80208b:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802092:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802099:	00 
	va_start(vl, arg0);
  80209a:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80209d:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	eb 0b                	jmp    8020b1 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  8020a6:	83 c0 01             	add    $0x1,%eax
  8020a9:	8b 39                	mov    (%ecx),%edi
  8020ab:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8020ae:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8020b1:	39 d0                	cmp    %edx,%eax
  8020b3:	75 f1                	jne    8020a6 <spawnl+0x8f>
	return spawn(prog, argv);
  8020b5:	83 ec 08             	sub    $0x8,%esp
  8020b8:	56                   	push   %esi
  8020b9:	ff 75 08             	pushl  0x8(%ebp)
  8020bc:	e8 f1 f9 ff ff       	call   801ab2 <spawn>
}
  8020c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c4:	5b                   	pop    %ebx
  8020c5:	5e                   	pop    %esi
  8020c6:	5f                   	pop    %edi
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    

008020c9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c9:	f3 0f 1e fb          	endbr32 
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	56                   	push   %esi
  8020d1:	53                   	push   %ebx
  8020d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 08             	pushl  0x8(%ebp)
  8020db:	e8 9c f1 ff ff       	call   80127c <fd2data>
  8020e0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020e2:	83 c4 08             	add    $0x8,%esp
  8020e5:	68 46 31 80 00       	push   $0x803146
  8020ea:	53                   	push   %ebx
  8020eb:	e8 05 e8 ff ff       	call   8008f5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020f0:	8b 46 04             	mov    0x4(%esi),%eax
  8020f3:	2b 06                	sub    (%esi),%eax
  8020f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802102:	00 00 00 
	stat->st_dev = &devpipe;
  802105:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  80210c:	40 80 00 
	return 0;
}
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    

0080211b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80211b:	f3 0f 1e fb          	endbr32 
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	53                   	push   %ebx
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802129:	53                   	push   %ebx
  80212a:	6a 00                	push   $0x0
  80212c:	e8 93 ec ff ff       	call   800dc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802131:	89 1c 24             	mov    %ebx,(%esp)
  802134:	e8 43 f1 ff ff       	call   80127c <fd2data>
  802139:	83 c4 08             	add    $0x8,%esp
  80213c:	50                   	push   %eax
  80213d:	6a 00                	push   $0x0
  80213f:	e8 80 ec ff ff       	call   800dc4 <sys_page_unmap>
}
  802144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <_pipeisclosed>:
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	57                   	push   %edi
  80214d:	56                   	push   %esi
  80214e:	53                   	push   %ebx
  80214f:	83 ec 1c             	sub    $0x1c,%esp
  802152:	89 c7                	mov    %eax,%edi
  802154:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802156:	a1 04 50 80 00       	mov    0x805004,%eax
  80215b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	57                   	push   %edi
  802162:	e8 54 06 00 00       	call   8027bb <pageref>
  802167:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80216a:	89 34 24             	mov    %esi,(%esp)
  80216d:	e8 49 06 00 00       	call   8027bb <pageref>
		nn = thisenv->env_runs;
  802172:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802178:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	39 cb                	cmp    %ecx,%ebx
  802180:	74 1b                	je     80219d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802182:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802185:	75 cf                	jne    802156 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802187:	8b 42 58             	mov    0x58(%edx),%eax
  80218a:	6a 01                	push   $0x1
  80218c:	50                   	push   %eax
  80218d:	53                   	push   %ebx
  80218e:	68 4d 31 80 00       	push   $0x80314d
  802193:	e8 53 e1 ff ff       	call   8002eb <cprintf>
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	eb b9                	jmp    802156 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80219d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021a0:	0f 94 c0             	sete   %al
  8021a3:	0f b6 c0             	movzbl %al,%eax
}
  8021a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5f                   	pop    %edi
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    

008021ae <devpipe_write>:
{
  8021ae:	f3 0f 1e fb          	endbr32 
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 28             	sub    $0x28,%esp
  8021bb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021be:	56                   	push   %esi
  8021bf:	e8 b8 f0 ff ff       	call   80127c <fd2data>
  8021c4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021d1:	74 4f                	je     802222 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021d3:	8b 43 04             	mov    0x4(%ebx),%eax
  8021d6:	8b 0b                	mov    (%ebx),%ecx
  8021d8:	8d 51 20             	lea    0x20(%ecx),%edx
  8021db:	39 d0                	cmp    %edx,%eax
  8021dd:	72 14                	jb     8021f3 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8021df:	89 da                	mov    %ebx,%edx
  8021e1:	89 f0                	mov    %esi,%eax
  8021e3:	e8 61 ff ff ff       	call   802149 <_pipeisclosed>
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	75 3b                	jne    802227 <devpipe_write+0x79>
			sys_yield();
  8021ec:	e8 23 eb ff ff       	call   800d14 <sys_yield>
  8021f1:	eb e0                	jmp    8021d3 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021f6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021fa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021fd:	89 c2                	mov    %eax,%edx
  8021ff:	c1 fa 1f             	sar    $0x1f,%edx
  802202:	89 d1                	mov    %edx,%ecx
  802204:	c1 e9 1b             	shr    $0x1b,%ecx
  802207:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80220a:	83 e2 1f             	and    $0x1f,%edx
  80220d:	29 ca                	sub    %ecx,%edx
  80220f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802217:	83 c0 01             	add    $0x1,%eax
  80221a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80221d:	83 c7 01             	add    $0x1,%edi
  802220:	eb ac                	jmp    8021ce <devpipe_write+0x20>
	return i;
  802222:	8b 45 10             	mov    0x10(%ebp),%eax
  802225:	eb 05                	jmp    80222c <devpipe_write+0x7e>
				return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    

00802234 <devpipe_read>:
{
  802234:	f3 0f 1e fb          	endbr32 
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	57                   	push   %edi
  80223c:	56                   	push   %esi
  80223d:	53                   	push   %ebx
  80223e:	83 ec 18             	sub    $0x18,%esp
  802241:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802244:	57                   	push   %edi
  802245:	e8 32 f0 ff ff       	call   80127c <fd2data>
  80224a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	be 00 00 00 00       	mov    $0x0,%esi
  802254:	3b 75 10             	cmp    0x10(%ebp),%esi
  802257:	75 14                	jne    80226d <devpipe_read+0x39>
	return i;
  802259:	8b 45 10             	mov    0x10(%ebp),%eax
  80225c:	eb 02                	jmp    802260 <devpipe_read+0x2c>
				return i;
  80225e:	89 f0                	mov    %esi,%eax
}
  802260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    
			sys_yield();
  802268:	e8 a7 ea ff ff       	call   800d14 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80226d:	8b 03                	mov    (%ebx),%eax
  80226f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802272:	75 18                	jne    80228c <devpipe_read+0x58>
			if (i > 0)
  802274:	85 f6                	test   %esi,%esi
  802276:	75 e6                	jne    80225e <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802278:	89 da                	mov    %ebx,%edx
  80227a:	89 f8                	mov    %edi,%eax
  80227c:	e8 c8 fe ff ff       	call   802149 <_pipeisclosed>
  802281:	85 c0                	test   %eax,%eax
  802283:	74 e3                	je     802268 <devpipe_read+0x34>
				return 0;
  802285:	b8 00 00 00 00       	mov    $0x0,%eax
  80228a:	eb d4                	jmp    802260 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80228c:	99                   	cltd   
  80228d:	c1 ea 1b             	shr    $0x1b,%edx
  802290:	01 d0                	add    %edx,%eax
  802292:	83 e0 1f             	and    $0x1f,%eax
  802295:	29 d0                	sub    %edx,%eax
  802297:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80229c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80229f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022a2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022a5:	83 c6 01             	add    $0x1,%esi
  8022a8:	eb aa                	jmp    802254 <devpipe_read+0x20>

008022aa <pipe>:
{
  8022aa:	f3 0f 1e fb          	endbr32 
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	56                   	push   %esi
  8022b2:	53                   	push   %ebx
  8022b3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b9:	50                   	push   %eax
  8022ba:	e8 d8 ef ff ff       	call   801297 <fd_alloc>
  8022bf:	89 c3                	mov    %eax,%ebx
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	0f 88 23 01 00 00    	js     8023ef <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cc:	83 ec 04             	sub    $0x4,%esp
  8022cf:	68 07 04 00 00       	push   $0x407
  8022d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d7:	6a 00                	push   $0x0
  8022d9:	e8 59 ea ff ff       	call   800d37 <sys_page_alloc>
  8022de:	89 c3                	mov    %eax,%ebx
  8022e0:	83 c4 10             	add    $0x10,%esp
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	0f 88 04 01 00 00    	js     8023ef <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8022eb:	83 ec 0c             	sub    $0xc,%esp
  8022ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022f1:	50                   	push   %eax
  8022f2:	e8 a0 ef ff ff       	call   801297 <fd_alloc>
  8022f7:	89 c3                	mov    %eax,%ebx
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	0f 88 db 00 00 00    	js     8023df <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	68 07 04 00 00       	push   $0x407
  80230c:	ff 75 f0             	pushl  -0x10(%ebp)
  80230f:	6a 00                	push   $0x0
  802311:	e8 21 ea ff ff       	call   800d37 <sys_page_alloc>
  802316:	89 c3                	mov    %eax,%ebx
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	85 c0                	test   %eax,%eax
  80231d:	0f 88 bc 00 00 00    	js     8023df <pipe+0x135>
	va = fd2data(fd0);
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	ff 75 f4             	pushl  -0xc(%ebp)
  802329:	e8 4e ef ff ff       	call   80127c <fd2data>
  80232e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802330:	83 c4 0c             	add    $0xc,%esp
  802333:	68 07 04 00 00       	push   $0x407
  802338:	50                   	push   %eax
  802339:	6a 00                	push   $0x0
  80233b:	e8 f7 e9 ff ff       	call   800d37 <sys_page_alloc>
  802340:	89 c3                	mov    %eax,%ebx
  802342:	83 c4 10             	add    $0x10,%esp
  802345:	85 c0                	test   %eax,%eax
  802347:	0f 88 82 00 00 00    	js     8023cf <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	ff 75 f0             	pushl  -0x10(%ebp)
  802353:	e8 24 ef ff ff       	call   80127c <fd2data>
  802358:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80235f:	50                   	push   %eax
  802360:	6a 00                	push   $0x0
  802362:	56                   	push   %esi
  802363:	6a 00                	push   $0x0
  802365:	e8 14 ea ff ff       	call   800d7e <sys_page_map>
  80236a:	89 c3                	mov    %eax,%ebx
  80236c:	83 c4 20             	add    $0x20,%esp
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 4e                	js     8023c1 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802373:	a1 28 40 80 00       	mov    0x804028,%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80237d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802380:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802387:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	ff 75 f4             	pushl  -0xc(%ebp)
  80239c:	e8 c7 ee ff ff       	call   801268 <fd2num>
  8023a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023a4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023a6:	83 c4 04             	add    $0x4,%esp
  8023a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ac:	e8 b7 ee ff ff       	call   801268 <fd2num>
  8023b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023b4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023b7:	83 c4 10             	add    $0x10,%esp
  8023ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023bf:	eb 2e                	jmp    8023ef <pipe+0x145>
	sys_page_unmap(0, va);
  8023c1:	83 ec 08             	sub    $0x8,%esp
  8023c4:	56                   	push   %esi
  8023c5:	6a 00                	push   $0x0
  8023c7:	e8 f8 e9 ff ff       	call   800dc4 <sys_page_unmap>
  8023cc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023cf:	83 ec 08             	sub    $0x8,%esp
  8023d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8023d5:	6a 00                	push   $0x0
  8023d7:	e8 e8 e9 ff ff       	call   800dc4 <sys_page_unmap>
  8023dc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8023df:	83 ec 08             	sub    $0x8,%esp
  8023e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e5:	6a 00                	push   $0x0
  8023e7:	e8 d8 e9 ff ff       	call   800dc4 <sys_page_unmap>
  8023ec:	83 c4 10             	add    $0x10,%esp
}
  8023ef:	89 d8                	mov    %ebx,%eax
  8023f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f4:	5b                   	pop    %ebx
  8023f5:	5e                   	pop    %esi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    

008023f8 <pipeisclosed>:
{
  8023f8:	f3 0f 1e fb          	endbr32 
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802405:	50                   	push   %eax
  802406:	ff 75 08             	pushl  0x8(%ebp)
  802409:	e8 df ee ff ff       	call   8012ed <fd_lookup>
  80240e:	83 c4 10             	add    $0x10,%esp
  802411:	85 c0                	test   %eax,%eax
  802413:	78 18                	js     80242d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802415:	83 ec 0c             	sub    $0xc,%esp
  802418:	ff 75 f4             	pushl  -0xc(%ebp)
  80241b:	e8 5c ee ff ff       	call   80127c <fd2data>
  802420:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	e8 1f fd ff ff       	call   802149 <_pipeisclosed>
  80242a:	83 c4 10             	add    $0x10,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80242f:	f3 0f 1e fb          	endbr32 
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80243b:	85 f6                	test   %esi,%esi
  80243d:	74 13                	je     802452 <wait+0x23>
	e = &envs[ENVX(envid)];
  80243f:	89 f3                	mov    %esi,%ebx
  802441:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802447:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80244a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802450:	eb 1b                	jmp    80246d <wait+0x3e>
	assert(envid != 0);
  802452:	68 65 31 80 00       	push   $0x803165
  802457:	68 7f 30 80 00       	push   $0x80307f
  80245c:	6a 09                	push   $0x9
  80245e:	68 70 31 80 00       	push   $0x803170
  802463:	e8 9c dd ff ff       	call   800204 <_panic>
		sys_yield();
  802468:	e8 a7 e8 ff ff       	call   800d14 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80246d:	8b 43 48             	mov    0x48(%ebx),%eax
  802470:	39 f0                	cmp    %esi,%eax
  802472:	75 07                	jne    80247b <wait+0x4c>
  802474:	8b 43 54             	mov    0x54(%ebx),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 ed                	jne    802468 <wait+0x39>
}
  80247b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80247e:	5b                   	pop    %ebx
  80247f:	5e                   	pop    %esi
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802482:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
  80248b:	c3                   	ret    

0080248c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80248c:	f3 0f 1e fb          	endbr32 
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802496:	68 7b 31 80 00       	push   $0x80317b
  80249b:	ff 75 0c             	pushl  0xc(%ebp)
  80249e:	e8 52 e4 ff ff       	call   8008f5 <strcpy>
	return 0;
}
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <devcons_write>:
{
  8024aa:	f3 0f 1e fb          	endbr32 
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024ba:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024bf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024c5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024c8:	73 31                	jae    8024fb <devcons_write+0x51>
		m = n - tot;
  8024ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024cd:	29 f3                	sub    %esi,%ebx
  8024cf:	83 fb 7f             	cmp    $0x7f,%ebx
  8024d2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024d7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	53                   	push   %ebx
  8024de:	89 f0                	mov    %esi,%eax
  8024e0:	03 45 0c             	add    0xc(%ebp),%eax
  8024e3:	50                   	push   %eax
  8024e4:	57                   	push   %edi
  8024e5:	e8 c1 e5 ff ff       	call   800aab <memmove>
		sys_cputs(buf, m);
  8024ea:	83 c4 08             	add    $0x8,%esp
  8024ed:	53                   	push   %ebx
  8024ee:	57                   	push   %edi
  8024ef:	e8 73 e7 ff ff       	call   800c67 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024f4:	01 de                	add    %ebx,%esi
  8024f6:	83 c4 10             	add    $0x10,%esp
  8024f9:	eb ca                	jmp    8024c5 <devcons_write+0x1b>
}
  8024fb:	89 f0                	mov    %esi,%eax
  8024fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802500:	5b                   	pop    %ebx
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    

00802505 <devcons_read>:
{
  802505:	f3 0f 1e fb          	endbr32 
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 08             	sub    $0x8,%esp
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802514:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802518:	74 21                	je     80253b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80251a:	e8 6a e7 ff ff       	call   800c89 <sys_cgetc>
  80251f:	85 c0                	test   %eax,%eax
  802521:	75 07                	jne    80252a <devcons_read+0x25>
		sys_yield();
  802523:	e8 ec e7 ff ff       	call   800d14 <sys_yield>
  802528:	eb f0                	jmp    80251a <devcons_read+0x15>
	if (c < 0)
  80252a:	78 0f                	js     80253b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80252c:	83 f8 04             	cmp    $0x4,%eax
  80252f:	74 0c                	je     80253d <devcons_read+0x38>
	*(char*)vbuf = c;
  802531:	8b 55 0c             	mov    0xc(%ebp),%edx
  802534:	88 02                	mov    %al,(%edx)
	return 1;
  802536:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    
		return 0;
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
  802542:	eb f7                	jmp    80253b <devcons_read+0x36>

00802544 <cputchar>:
{
  802544:	f3 0f 1e fb          	endbr32 
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802554:	6a 01                	push   $0x1
  802556:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802559:	50                   	push   %eax
  80255a:	e8 08 e7 ff ff       	call   800c67 <sys_cputs>
}
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <getchar>:
{
  802564:	f3 0f 1e fb          	endbr32 
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80256e:	6a 01                	push   $0x1
  802570:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802573:	50                   	push   %eax
  802574:	6a 00                	push   $0x0
  802576:	e8 f5 ef ff ff       	call   801570 <read>
	if (r < 0)
  80257b:	83 c4 10             	add    $0x10,%esp
  80257e:	85 c0                	test   %eax,%eax
  802580:	78 06                	js     802588 <getchar+0x24>
	if (r < 1)
  802582:	74 06                	je     80258a <getchar+0x26>
	return c;
  802584:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    
		return -E_EOF;
  80258a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80258f:	eb f7                	jmp    802588 <getchar+0x24>

00802591 <iscons>:
{
  802591:	f3 0f 1e fb          	endbr32 
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259e:	50                   	push   %eax
  80259f:	ff 75 08             	pushl  0x8(%ebp)
  8025a2:	e8 46 ed ff ff       	call   8012ed <fd_lookup>
  8025a7:	83 c4 10             	add    $0x10,%esp
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	78 11                	js     8025bf <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8025b7:	39 10                	cmp    %edx,(%eax)
  8025b9:	0f 94 c0             	sete   %al
  8025bc:	0f b6 c0             	movzbl %al,%eax
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <opencons>:
{
  8025c1:	f3 0f 1e fb          	endbr32 
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ce:	50                   	push   %eax
  8025cf:	e8 c3 ec ff ff       	call   801297 <fd_alloc>
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	78 3a                	js     802615 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	68 07 04 00 00       	push   $0x407
  8025e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e6:	6a 00                	push   $0x0
  8025e8:	e8 4a e7 ff ff       	call   800d37 <sys_page_alloc>
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	78 21                	js     802615 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8025fd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802609:	83 ec 0c             	sub    $0xc,%esp
  80260c:	50                   	push   %eax
  80260d:	e8 56 ec ff ff       	call   801268 <fd2num>
  802612:	83 c4 10             	add    $0x10,%esp
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802617:	f3 0f 1e fb          	endbr32 
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	53                   	push   %ebx
  80261f:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802622:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802629:	74 0d                	je     802638 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802636:	c9                   	leave  
  802637:	c3                   	ret    
		envid_t envid=sys_getenvid();
  802638:	e8 b4 e6 ff ff       	call   800cf1 <sys_getenvid>
  80263d:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	6a 07                	push   $0x7
  802644:	68 00 f0 bf ee       	push   $0xeebff000
  802649:	50                   	push   %eax
  80264a:	e8 e8 e6 ff ff       	call   800d37 <sys_page_alloc>
  80264f:	83 c4 10             	add    $0x10,%esp
  802652:	85 c0                	test   %eax,%eax
  802654:	78 29                	js     80267f <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802656:	83 ec 08             	sub    $0x8,%esp
  802659:	68 93 26 80 00       	push   $0x802693
  80265e:	53                   	push   %ebx
  80265f:	e8 32 e8 ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
  802664:	83 c4 10             	add    $0x10,%esp
  802667:	85 c0                	test   %eax,%eax
  802669:	79 c0                	jns    80262b <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 b4 31 80 00       	push   $0x8031b4
  802673:	6a 24                	push   $0x24
  802675:	68 eb 31 80 00       	push   $0x8031eb
  80267a:	e8 85 db ff ff       	call   800204 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	68 88 31 80 00       	push   $0x803188
  802687:	6a 22                	push   $0x22
  802689:	68 eb 31 80 00       	push   $0x8031eb
  80268e:	e8 71 db ff ff       	call   800204 <_panic>

00802693 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802693:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802694:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802699:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80269b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  80269e:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8026a1:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8026a5:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8026aa:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8026ae:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8026b0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8026b1:	83 c4 04             	add    $0x4,%esp
	popfl
  8026b4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8026b5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8026b6:	c3                   	ret    

008026b7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026b7:	f3 0f 1e fb          	endbr32 
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	56                   	push   %esi
  8026bf:	53                   	push   %ebx
  8026c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8026c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8026d0:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8026d3:	83 ec 0c             	sub    $0xc,%esp
  8026d6:	50                   	push   %eax
  8026d7:	e8 27 e8 ff ff       	call   800f03 <sys_ipc_recv>
  8026dc:	83 c4 10             	add    $0x10,%esp
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	78 2b                	js     80270e <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8026e3:	85 f6                	test   %esi,%esi
  8026e5:	74 0a                	je     8026f1 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  8026e7:	a1 04 50 80 00       	mov    0x805004,%eax
  8026ec:	8b 40 74             	mov    0x74(%eax),%eax
  8026ef:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  8026f1:	85 db                	test   %ebx,%ebx
  8026f3:	74 0a                	je     8026ff <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  8026f5:	a1 04 50 80 00       	mov    0x805004,%eax
  8026fa:	8b 40 78             	mov    0x78(%eax),%eax
  8026fd:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8026ff:	a1 04 50 80 00       	mov    0x805004,%eax
  802704:	8b 40 70             	mov    0x70(%eax),%eax
}
  802707:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    
		if(from_env_store)
  80270e:	85 f6                	test   %esi,%esi
  802710:	74 06                	je     802718 <ipc_recv+0x61>
			*from_env_store=0;
  802712:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802718:	85 db                	test   %ebx,%ebx
  80271a:	74 eb                	je     802707 <ipc_recv+0x50>
			*perm_store=0;
  80271c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802722:	eb e3                	jmp    802707 <ipc_recv+0x50>

00802724 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802724:	f3 0f 1e fb          	endbr32 
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	57                   	push   %edi
  80272c:	56                   	push   %esi
  80272d:	53                   	push   %ebx
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	8b 7d 08             	mov    0x8(%ebp),%edi
  802734:	8b 75 0c             	mov    0xc(%ebp),%esi
  802737:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80273a:	85 db                	test   %ebx,%ebx
  80273c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802741:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802744:	ff 75 14             	pushl  0x14(%ebp)
  802747:	53                   	push   %ebx
  802748:	56                   	push   %esi
  802749:	57                   	push   %edi
  80274a:	e8 8d e7 ff ff       	call   800edc <sys_ipc_try_send>
		if(!res)
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	85 c0                	test   %eax,%eax
  802754:	74 20                	je     802776 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802756:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802759:	75 07                	jne    802762 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80275b:	e8 b4 e5 ff ff       	call   800d14 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802760:	eb e2                	jmp    802744 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 f9 31 80 00       	push   $0x8031f9
  80276a:	6a 3f                	push   $0x3f
  80276c:	68 11 32 80 00       	push   $0x803211
  802771:	e8 8e da ff ff       	call   800204 <_panic>
	}
}
  802776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802779:	5b                   	pop    %ebx
  80277a:	5e                   	pop    %esi
  80277b:	5f                   	pop    %edi
  80277c:	5d                   	pop    %ebp
  80277d:	c3                   	ret    

0080277e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80277e:	f3 0f 1e fb          	endbr32 
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80278d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802790:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802796:	8b 52 50             	mov    0x50(%edx),%edx
  802799:	39 ca                	cmp    %ecx,%edx
  80279b:	74 11                	je     8027ae <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80279d:	83 c0 01             	add    $0x1,%eax
  8027a0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027a5:	75 e6                	jne    80278d <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ac:	eb 0b                	jmp    8027b9 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8027ae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027b6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027b9:	5d                   	pop    %ebp
  8027ba:	c3                   	ret    

008027bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027bb:	f3 0f 1e fb          	endbr32 
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027c5:	89 c2                	mov    %eax,%edx
  8027c7:	c1 ea 16             	shr    $0x16,%edx
  8027ca:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8027d1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8027d6:	f6 c1 01             	test   $0x1,%cl
  8027d9:	74 1c                	je     8027f7 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8027db:	c1 e8 0c             	shr    $0xc,%eax
  8027de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027e5:	a8 01                	test   $0x1,%al
  8027e7:	74 0e                	je     8027f7 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027e9:	c1 e8 0c             	shr    $0xc,%eax
  8027ec:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8027f3:	ef 
  8027f4:	0f b7 d2             	movzwl %dx,%edx
}
  8027f7:	89 d0                	mov    %edx,%eax
  8027f9:	5d                   	pop    %ebp
  8027fa:	c3                   	ret    
  8027fb:	66 90                	xchg   %ax,%ax
  8027fd:	66 90                	xchg   %ax,%ax
  8027ff:	90                   	nop

00802800 <__udivdi3>:
  802800:	f3 0f 1e fb          	endbr32 
  802804:	55                   	push   %ebp
  802805:	57                   	push   %edi
  802806:	56                   	push   %esi
  802807:	53                   	push   %ebx
  802808:	83 ec 1c             	sub    $0x1c,%esp
  80280b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80280f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802813:	8b 74 24 34          	mov    0x34(%esp),%esi
  802817:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80281b:	85 d2                	test   %edx,%edx
  80281d:	75 19                	jne    802838 <__udivdi3+0x38>
  80281f:	39 f3                	cmp    %esi,%ebx
  802821:	76 4d                	jbe    802870 <__udivdi3+0x70>
  802823:	31 ff                	xor    %edi,%edi
  802825:	89 e8                	mov    %ebp,%eax
  802827:	89 f2                	mov    %esi,%edx
  802829:	f7 f3                	div    %ebx
  80282b:	89 fa                	mov    %edi,%edx
  80282d:	83 c4 1c             	add    $0x1c,%esp
  802830:	5b                   	pop    %ebx
  802831:	5e                   	pop    %esi
  802832:	5f                   	pop    %edi
  802833:	5d                   	pop    %ebp
  802834:	c3                   	ret    
  802835:	8d 76 00             	lea    0x0(%esi),%esi
  802838:	39 f2                	cmp    %esi,%edx
  80283a:	76 14                	jbe    802850 <__udivdi3+0x50>
  80283c:	31 ff                	xor    %edi,%edi
  80283e:	31 c0                	xor    %eax,%eax
  802840:	89 fa                	mov    %edi,%edx
  802842:	83 c4 1c             	add    $0x1c,%esp
  802845:	5b                   	pop    %ebx
  802846:	5e                   	pop    %esi
  802847:	5f                   	pop    %edi
  802848:	5d                   	pop    %ebp
  802849:	c3                   	ret    
  80284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802850:	0f bd fa             	bsr    %edx,%edi
  802853:	83 f7 1f             	xor    $0x1f,%edi
  802856:	75 48                	jne    8028a0 <__udivdi3+0xa0>
  802858:	39 f2                	cmp    %esi,%edx
  80285a:	72 06                	jb     802862 <__udivdi3+0x62>
  80285c:	31 c0                	xor    %eax,%eax
  80285e:	39 eb                	cmp    %ebp,%ebx
  802860:	77 de                	ja     802840 <__udivdi3+0x40>
  802862:	b8 01 00 00 00       	mov    $0x1,%eax
  802867:	eb d7                	jmp    802840 <__udivdi3+0x40>
  802869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802870:	89 d9                	mov    %ebx,%ecx
  802872:	85 db                	test   %ebx,%ebx
  802874:	75 0b                	jne    802881 <__udivdi3+0x81>
  802876:	b8 01 00 00 00       	mov    $0x1,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	f7 f3                	div    %ebx
  80287f:	89 c1                	mov    %eax,%ecx
  802881:	31 d2                	xor    %edx,%edx
  802883:	89 f0                	mov    %esi,%eax
  802885:	f7 f1                	div    %ecx
  802887:	89 c6                	mov    %eax,%esi
  802889:	89 e8                	mov    %ebp,%eax
  80288b:	89 f7                	mov    %esi,%edi
  80288d:	f7 f1                	div    %ecx
  80288f:	89 fa                	mov    %edi,%edx
  802891:	83 c4 1c             	add    $0x1c,%esp
  802894:	5b                   	pop    %ebx
  802895:	5e                   	pop    %esi
  802896:	5f                   	pop    %edi
  802897:	5d                   	pop    %ebp
  802898:	c3                   	ret    
  802899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	89 f9                	mov    %edi,%ecx
  8028a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028a7:	29 f8                	sub    %edi,%eax
  8028a9:	d3 e2                	shl    %cl,%edx
  8028ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028af:	89 c1                	mov    %eax,%ecx
  8028b1:	89 da                	mov    %ebx,%edx
  8028b3:	d3 ea                	shr    %cl,%edx
  8028b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028b9:	09 d1                	or     %edx,%ecx
  8028bb:	89 f2                	mov    %esi,%edx
  8028bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028c1:	89 f9                	mov    %edi,%ecx
  8028c3:	d3 e3                	shl    %cl,%ebx
  8028c5:	89 c1                	mov    %eax,%ecx
  8028c7:	d3 ea                	shr    %cl,%edx
  8028c9:	89 f9                	mov    %edi,%ecx
  8028cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028cf:	89 eb                	mov    %ebp,%ebx
  8028d1:	d3 e6                	shl    %cl,%esi
  8028d3:	89 c1                	mov    %eax,%ecx
  8028d5:	d3 eb                	shr    %cl,%ebx
  8028d7:	09 de                	or     %ebx,%esi
  8028d9:	89 f0                	mov    %esi,%eax
  8028db:	f7 74 24 08          	divl   0x8(%esp)
  8028df:	89 d6                	mov    %edx,%esi
  8028e1:	89 c3                	mov    %eax,%ebx
  8028e3:	f7 64 24 0c          	mull   0xc(%esp)
  8028e7:	39 d6                	cmp    %edx,%esi
  8028e9:	72 15                	jb     802900 <__udivdi3+0x100>
  8028eb:	89 f9                	mov    %edi,%ecx
  8028ed:	d3 e5                	shl    %cl,%ebp
  8028ef:	39 c5                	cmp    %eax,%ebp
  8028f1:	73 04                	jae    8028f7 <__udivdi3+0xf7>
  8028f3:	39 d6                	cmp    %edx,%esi
  8028f5:	74 09                	je     802900 <__udivdi3+0x100>
  8028f7:	89 d8                	mov    %ebx,%eax
  8028f9:	31 ff                	xor    %edi,%edi
  8028fb:	e9 40 ff ff ff       	jmp    802840 <__udivdi3+0x40>
  802900:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802903:	31 ff                	xor    %edi,%edi
  802905:	e9 36 ff ff ff       	jmp    802840 <__udivdi3+0x40>
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	66 90                	xchg   %ax,%ax
  80290e:	66 90                	xchg   %ax,%ax

00802910 <__umoddi3>:
  802910:	f3 0f 1e fb          	endbr32 
  802914:	55                   	push   %ebp
  802915:	57                   	push   %edi
  802916:	56                   	push   %esi
  802917:	53                   	push   %ebx
  802918:	83 ec 1c             	sub    $0x1c,%esp
  80291b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80291f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802923:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80292b:	85 c0                	test   %eax,%eax
  80292d:	75 19                	jne    802948 <__umoddi3+0x38>
  80292f:	39 df                	cmp    %ebx,%edi
  802931:	76 5d                	jbe    802990 <__umoddi3+0x80>
  802933:	89 f0                	mov    %esi,%eax
  802935:	89 da                	mov    %ebx,%edx
  802937:	f7 f7                	div    %edi
  802939:	89 d0                	mov    %edx,%eax
  80293b:	31 d2                	xor    %edx,%edx
  80293d:	83 c4 1c             	add    $0x1c,%esp
  802940:	5b                   	pop    %ebx
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	89 f2                	mov    %esi,%edx
  80294a:	39 d8                	cmp    %ebx,%eax
  80294c:	76 12                	jbe    802960 <__umoddi3+0x50>
  80294e:	89 f0                	mov    %esi,%eax
  802950:	89 da                	mov    %ebx,%edx
  802952:	83 c4 1c             	add    $0x1c,%esp
  802955:	5b                   	pop    %ebx
  802956:	5e                   	pop    %esi
  802957:	5f                   	pop    %edi
  802958:	5d                   	pop    %ebp
  802959:	c3                   	ret    
  80295a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802960:	0f bd e8             	bsr    %eax,%ebp
  802963:	83 f5 1f             	xor    $0x1f,%ebp
  802966:	75 50                	jne    8029b8 <__umoddi3+0xa8>
  802968:	39 d8                	cmp    %ebx,%eax
  80296a:	0f 82 e0 00 00 00    	jb     802a50 <__umoddi3+0x140>
  802970:	89 d9                	mov    %ebx,%ecx
  802972:	39 f7                	cmp    %esi,%edi
  802974:	0f 86 d6 00 00 00    	jbe    802a50 <__umoddi3+0x140>
  80297a:	89 d0                	mov    %edx,%eax
  80297c:	89 ca                	mov    %ecx,%edx
  80297e:	83 c4 1c             	add    $0x1c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	89 fd                	mov    %edi,%ebp
  802992:	85 ff                	test   %edi,%edi
  802994:	75 0b                	jne    8029a1 <__umoddi3+0x91>
  802996:	b8 01 00 00 00       	mov    $0x1,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	f7 f7                	div    %edi
  80299f:	89 c5                	mov    %eax,%ebp
  8029a1:	89 d8                	mov    %ebx,%eax
  8029a3:	31 d2                	xor    %edx,%edx
  8029a5:	f7 f5                	div    %ebp
  8029a7:	89 f0                	mov    %esi,%eax
  8029a9:	f7 f5                	div    %ebp
  8029ab:	89 d0                	mov    %edx,%eax
  8029ad:	31 d2                	xor    %edx,%edx
  8029af:	eb 8c                	jmp    80293d <__umoddi3+0x2d>
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	89 e9                	mov    %ebp,%ecx
  8029ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8029bf:	29 ea                	sub    %ebp,%edx
  8029c1:	d3 e0                	shl    %cl,%eax
  8029c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029c7:	89 d1                	mov    %edx,%ecx
  8029c9:	89 f8                	mov    %edi,%eax
  8029cb:	d3 e8                	shr    %cl,%eax
  8029cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029d9:	09 c1                	or     %eax,%ecx
  8029db:	89 d8                	mov    %ebx,%eax
  8029dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e1:	89 e9                	mov    %ebp,%ecx
  8029e3:	d3 e7                	shl    %cl,%edi
  8029e5:	89 d1                	mov    %edx,%ecx
  8029e7:	d3 e8                	shr    %cl,%eax
  8029e9:	89 e9                	mov    %ebp,%ecx
  8029eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ef:	d3 e3                	shl    %cl,%ebx
  8029f1:	89 c7                	mov    %eax,%edi
  8029f3:	89 d1                	mov    %edx,%ecx
  8029f5:	89 f0                	mov    %esi,%eax
  8029f7:	d3 e8                	shr    %cl,%eax
  8029f9:	89 e9                	mov    %ebp,%ecx
  8029fb:	89 fa                	mov    %edi,%edx
  8029fd:	d3 e6                	shl    %cl,%esi
  8029ff:	09 d8                	or     %ebx,%eax
  802a01:	f7 74 24 08          	divl   0x8(%esp)
  802a05:	89 d1                	mov    %edx,%ecx
  802a07:	89 f3                	mov    %esi,%ebx
  802a09:	f7 64 24 0c          	mull   0xc(%esp)
  802a0d:	89 c6                	mov    %eax,%esi
  802a0f:	89 d7                	mov    %edx,%edi
  802a11:	39 d1                	cmp    %edx,%ecx
  802a13:	72 06                	jb     802a1b <__umoddi3+0x10b>
  802a15:	75 10                	jne    802a27 <__umoddi3+0x117>
  802a17:	39 c3                	cmp    %eax,%ebx
  802a19:	73 0c                	jae    802a27 <__umoddi3+0x117>
  802a1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a23:	89 d7                	mov    %edx,%edi
  802a25:	89 c6                	mov    %eax,%esi
  802a27:	89 ca                	mov    %ecx,%edx
  802a29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a2e:	29 f3                	sub    %esi,%ebx
  802a30:	19 fa                	sbb    %edi,%edx
  802a32:	89 d0                	mov    %edx,%eax
  802a34:	d3 e0                	shl    %cl,%eax
  802a36:	89 e9                	mov    %ebp,%ecx
  802a38:	d3 eb                	shr    %cl,%ebx
  802a3a:	d3 ea                	shr    %cl,%edx
  802a3c:	09 d8                	or     %ebx,%eax
  802a3e:	83 c4 1c             	add    $0x1c,%esp
  802a41:	5b                   	pop    %ebx
  802a42:	5e                   	pop    %esi
  802a43:	5f                   	pop    %edi
  802a44:	5d                   	pop    %ebp
  802a45:	c3                   	ret    
  802a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	29 fe                	sub    %edi,%esi
  802a52:	19 c3                	sbb    %eax,%ebx
  802a54:	89 f2                	mov    %esi,%edx
  802a56:	89 d9                	mov    %ebx,%ecx
  802a58:	e9 1d ff ff ff       	jmp    80297a <__umoddi3+0x6a>
