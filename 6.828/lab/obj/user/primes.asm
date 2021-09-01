
obj/user/primes.debug：     文件格式 elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  800040:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 00                	push   $0x0
  800048:	6a 00                	push   $0x0
  80004a:	56                   	push   %esi
  80004b:	e8 7a 11 00 00       	call   8011ca <ipc_recv>
  800050:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800052:	a1 04 40 80 00       	mov    0x804004,%eax
  800057:	8b 40 5c             	mov    0x5c(%eax),%eax
  80005a:	83 c4 0c             	add    $0xc,%esp
  80005d:	53                   	push   %ebx
  80005e:	50                   	push   %eax
  80005f:	68 60 23 80 00       	push   $0x802360
  800064:	e8 e4 01 00 00       	call   80024d <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800069:	e8 1f 0f 00 00       	call   800f8d <fork>
  80006e:	89 c7                	mov    %eax,%edi
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 07                	js     80007e <primeproc+0x4b>
		panic("fork: %e", id);
	if (id == 0)
  800077:	74 ca                	je     800043 <primeproc+0x10>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800079:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007c:	eb 20                	jmp    80009e <primeproc+0x6b>
		panic("fork: %e", id);
  80007e:	50                   	push   %eax
  80007f:	68 6c 23 80 00       	push   $0x80236c
  800084:	6a 1a                	push   $0x1a
  800086:	68 75 23 80 00       	push   $0x802375
  80008b:	e8 d6 00 00 00       	call   800166 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	51                   	push   %ecx
  800095:	57                   	push   %edi
  800096:	e8 9c 11 00 00       	call   801237 <ipc_send>
  80009b:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	56                   	push   %esi
  8000a6:	e8 1f 11 00 00       	call   8011ca <ipc_recv>
  8000ab:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000ad:	99                   	cltd   
  8000ae:	f7 fb                	idiv   %ebx
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	85 d2                	test   %edx,%edx
  8000b5:	74 e7                	je     80009e <primeproc+0x6b>
  8000b7:	eb d7                	jmp    800090 <primeproc+0x5d>

008000b9 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000c2:	e8 c6 0e 00 00       	call   800f8d <fork>
  8000c7:	89 c6                	mov    %eax,%esi
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	78 1a                	js     8000e7 <umain+0x2e>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000cd:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000d2:	74 25                	je     8000f9 <umain+0x40>
		ipc_send(id, i, 0, 0);
  8000d4:	6a 00                	push   $0x0
  8000d6:	6a 00                	push   $0x0
  8000d8:	53                   	push   %ebx
  8000d9:	56                   	push   %esi
  8000da:	e8 58 11 00 00       	call   801237 <ipc_send>
	for (i = 2; ; i++)
  8000df:	83 c3 01             	add    $0x1,%ebx
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb ed                	jmp    8000d4 <umain+0x1b>
		panic("fork: %e", id);
  8000e7:	50                   	push   %eax
  8000e8:	68 6c 23 80 00       	push   $0x80236c
  8000ed:	6a 2d                	push   $0x2d
  8000ef:	68 75 23 80 00       	push   $0x802375
  8000f4:	e8 6d 00 00 00       	call   800166 <_panic>
		primeproc();
  8000f9:	e8 35 ff ff ff       	call   800033 <primeproc>

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	f3 0f 1e fb          	endbr32 
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010d:	e8 41 0b 00 00       	call   800c53 <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	85 db                	test   %ebx,%ebx
  800126:	7e 07                	jle    80012f <libmain+0x31>
		binaryname = argv[0];
  800128:	8b 06                	mov    (%esi),%eax
  80012a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	e8 80 ff ff ff       	call   8000b9 <umain>

	// exit gracefully
	exit();
  800139:	e8 0a 00 00 00       	call   800148 <exit>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5d                   	pop    %ebp
  800147:	c3                   	ret    

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	f3 0f 1e fb          	endbr32 
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800152:	e8 66 13 00 00       	call   8014bd <close_all>
	sys_env_destroy(0);
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	6a 00                	push   $0x0
  80015c:	e8 ad 0a 00 00       	call   800c0e <sys_env_destroy>
}
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800166:	f3 0f 1e fb          	endbr32 
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80016f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800172:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800178:	e8 d6 0a 00 00       	call   800c53 <sys_getenvid>
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	ff 75 0c             	pushl  0xc(%ebp)
  800183:	ff 75 08             	pushl  0x8(%ebp)
  800186:	56                   	push   %esi
  800187:	50                   	push   %eax
  800188:	68 90 23 80 00       	push   $0x802390
  80018d:	e8 bb 00 00 00       	call   80024d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800192:	83 c4 18             	add    $0x18,%esp
  800195:	53                   	push   %ebx
  800196:	ff 75 10             	pushl  0x10(%ebp)
  800199:	e8 5a 00 00 00       	call   8001f8 <vcprintf>
	cprintf("\n");
  80019e:	c7 04 24 63 29 80 00 	movl   $0x802963,(%esp)
  8001a5:	e8 a3 00 00 00       	call   80024d <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ad:	cc                   	int3   
  8001ae:	eb fd                	jmp    8001ad <_panic+0x47>

008001b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001be:	8b 13                	mov    (%ebx),%edx
  8001c0:	8d 42 01             	lea    0x1(%edx),%eax
  8001c3:	89 03                	mov    %eax,(%ebx)
  8001c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d1:	74 09                	je     8001dc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	68 ff 00 00 00       	push   $0xff
  8001e4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 dc 09 00 00       	call   800bc9 <sys_cputs>
		b->idx = 0;
  8001ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	eb db                	jmp    8001d3 <putch+0x23>

008001f8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f8:	f3 0f 1e fb          	endbr32 
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800205:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020c:	00 00 00 
	b.cnt = 0;
  80020f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800216:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800219:	ff 75 0c             	pushl  0xc(%ebp)
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	68 b0 01 80 00       	push   $0x8001b0
  80022b:	e8 20 01 00 00       	call   800350 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800230:	83 c4 08             	add    $0x8,%esp
  800233:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800239:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	e8 84 09 00 00       	call   800bc9 <sys_cputs>

	return b.cnt;
}
  800245:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024d:	f3 0f 1e fb          	endbr32 
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800257:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80025a:	50                   	push   %eax
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 95 ff ff ff       	call   8001f8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    

00800265 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	83 ec 1c             	sub    $0x1c,%esp
  80026e:	89 c7                	mov    %eax,%edi
  800270:	89 d6                	mov    %edx,%esi
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	8b 55 0c             	mov    0xc(%ebp),%edx
  800278:	89 d1                	mov    %edx,%ecx
  80027a:	89 c2                	mov    %eax,%edx
  80027c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800282:	8b 45 10             	mov    0x10(%ebp),%eax
  800285:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800288:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800292:	39 c2                	cmp    %eax,%edx
  800294:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800297:	72 3e                	jb     8002d7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	ff 75 18             	pushl  0x18(%ebp)
  80029f:	83 eb 01             	sub    $0x1,%ebx
  8002a2:	53                   	push   %ebx
  8002a3:	50                   	push   %eax
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b3:	e8 48 1e 00 00       	call   802100 <__udivdi3>
  8002b8:	83 c4 18             	add    $0x18,%esp
  8002bb:	52                   	push   %edx
  8002bc:	50                   	push   %eax
  8002bd:	89 f2                	mov    %esi,%edx
  8002bf:	89 f8                	mov    %edi,%eax
  8002c1:	e8 9f ff ff ff       	call   800265 <printnum>
  8002c6:	83 c4 20             	add    $0x20,%esp
  8002c9:	eb 13                	jmp    8002de <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	56                   	push   %esi
  8002cf:	ff 75 18             	pushl  0x18(%ebp)
  8002d2:	ff d7                	call   *%edi
  8002d4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d7:	83 eb 01             	sub    $0x1,%ebx
  8002da:	85 db                	test   %ebx,%ebx
  8002dc:	7f ed                	jg     8002cb <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	56                   	push   %esi
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f1:	e8 1a 1f 00 00       	call   802210 <__umoddi3>
  8002f6:	83 c4 14             	add    $0x14,%esp
  8002f9:	0f be 80 b3 23 80 00 	movsbl 0x8023b3(%eax),%eax
  800300:	50                   	push   %eax
  800301:	ff d7                	call   *%edi
}
  800303:	83 c4 10             	add    $0x10,%esp
  800306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030e:	f3 0f 1e fb          	endbr32 
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800318:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031c:	8b 10                	mov    (%eax),%edx
  80031e:	3b 50 04             	cmp    0x4(%eax),%edx
  800321:	73 0a                	jae    80032d <sprintputch+0x1f>
		*b->buf++ = ch;
  800323:	8d 4a 01             	lea    0x1(%edx),%ecx
  800326:	89 08                	mov    %ecx,(%eax)
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	88 02                	mov    %al,(%edx)
}
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    

0080032f <printfmt>:
{
  80032f:	f3 0f 1e fb          	endbr32 
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800339:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033c:	50                   	push   %eax
  80033d:	ff 75 10             	pushl  0x10(%ebp)
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 05 00 00 00       	call   800350 <vprintfmt>
}
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <vprintfmt>:
{
  800350:	f3 0f 1e fb          	endbr32 
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 3c             	sub    $0x3c,%esp
  80035d:	8b 75 08             	mov    0x8(%ebp),%esi
  800360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800363:	8b 7d 10             	mov    0x10(%ebp),%edi
  800366:	e9 8e 03 00 00       	jmp    8006f9 <vprintfmt+0x3a9>
		padc = ' ';
  80036b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80036f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800376:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800384:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8d 47 01             	lea    0x1(%edi),%eax
  80038c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038f:	0f b6 17             	movzbl (%edi),%edx
  800392:	8d 42 dd             	lea    -0x23(%edx),%eax
  800395:	3c 55                	cmp    $0x55,%al
  800397:	0f 87 df 03 00 00    	ja     80077c <vprintfmt+0x42c>
  80039d:	0f b6 c0             	movzbl %al,%eax
  8003a0:	3e ff 24 85 00 25 80 	notrack jmp *0x802500(,%eax,4)
  8003a7:	00 
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ab:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003af:	eb d8                	jmp    800389 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003b8:	eb cf                	jmp    800389 <vprintfmt+0x39>
  8003ba:	0f b6 d2             	movzbl %dl,%edx
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003cb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003cf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003d5:	83 f9 09             	cmp    $0x9,%ecx
  8003d8:	77 55                	ja     80042f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003da:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003dd:	eb e9                	jmp    8003c8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8d 40 04             	lea    0x4(%eax),%eax
  8003ed:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f7:	79 90                	jns    800389 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800406:	eb 81                	jmp    800389 <vprintfmt+0x39>
  800408:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040b:	85 c0                	test   %eax,%eax
  80040d:	ba 00 00 00 00       	mov    $0x0,%edx
  800412:	0f 49 d0             	cmovns %eax,%edx
  800415:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041b:	e9 69 ff ff ff       	jmp    800389 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800423:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80042a:	e9 5a ff ff ff       	jmp    800389 <vprintfmt+0x39>
  80042f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800432:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800435:	eb bc                	jmp    8003f3 <vprintfmt+0xa3>
			lflag++;
  800437:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043d:	e9 47 ff ff ff       	jmp    800389 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8d 78 04             	lea    0x4(%eax),%edi
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	53                   	push   %ebx
  80044c:	ff 30                	pushl  (%eax)
  80044e:	ff d6                	call   *%esi
			break;
  800450:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800456:	e9 9b 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 78 04             	lea    0x4(%eax),%edi
  800461:	8b 00                	mov    (%eax),%eax
  800463:	99                   	cltd   
  800464:	31 d0                	xor    %edx,%eax
  800466:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800468:	83 f8 0f             	cmp    $0xf,%eax
  80046b:	7f 23                	jg     800490 <vprintfmt+0x140>
  80046d:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  800474:	85 d2                	test   %edx,%edx
  800476:	74 18                	je     800490 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800478:	52                   	push   %edx
  800479:	68 31 29 80 00       	push   $0x802931
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 aa fe ff ff       	call   80032f <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048b:	e9 66 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800490:	50                   	push   %eax
  800491:	68 cb 23 80 00       	push   $0x8023cb
  800496:	53                   	push   %ebx
  800497:	56                   	push   %esi
  800498:	e8 92 fe ff ff       	call   80032f <printfmt>
  80049d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a3:	e9 4e 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	83 c0 04             	add    $0x4,%eax
  8004ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004b6:	85 d2                	test   %edx,%edx
  8004b8:	b8 c4 23 80 00       	mov    $0x8023c4,%eax
  8004bd:	0f 45 c2             	cmovne %edx,%eax
  8004c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c7:	7e 06                	jle    8004cf <vprintfmt+0x17f>
  8004c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004cd:	75 0d                	jne    8004dc <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d2:	89 c7                	mov    %eax,%edi
  8004d4:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004da:	eb 55                	jmp    800531 <vprintfmt+0x1e1>
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e2:	ff 75 cc             	pushl  -0x34(%ebp)
  8004e5:	e8 46 03 00 00       	call   800830 <strnlen>
  8004ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ed:	29 c2                	sub    %eax,%edx
  8004ef:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fe:	85 ff                	test   %edi,%edi
  800500:	7e 11                	jle    800513 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	ff 75 e0             	pushl  -0x20(%ebp)
  800509:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	83 ef 01             	sub    $0x1,%edi
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	eb eb                	jmp    8004fe <vprintfmt+0x1ae>
  800513:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800516:	85 d2                	test   %edx,%edx
  800518:	b8 00 00 00 00       	mov    $0x0,%eax
  80051d:	0f 49 c2             	cmovns %edx,%eax
  800520:	29 c2                	sub    %eax,%edx
  800522:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800525:	eb a8                	jmp    8004cf <vprintfmt+0x17f>
					putch(ch, putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	53                   	push   %ebx
  80052b:	52                   	push   %edx
  80052c:	ff d6                	call   *%esi
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800536:	83 c7 01             	add    $0x1,%edi
  800539:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053d:	0f be d0             	movsbl %al,%edx
  800540:	85 d2                	test   %edx,%edx
  800542:	74 4b                	je     80058f <vprintfmt+0x23f>
  800544:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800548:	78 06                	js     800550 <vprintfmt+0x200>
  80054a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80054e:	78 1e                	js     80056e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800550:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800554:	74 d1                	je     800527 <vprintfmt+0x1d7>
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 e8 20             	sub    $0x20,%eax
  80055c:	83 f8 5e             	cmp    $0x5e,%eax
  80055f:	76 c6                	jbe    800527 <vprintfmt+0x1d7>
					putch('?', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	6a 3f                	push   $0x3f
  800567:	ff d6                	call   *%esi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	eb c3                	jmp    800531 <vprintfmt+0x1e1>
  80056e:	89 cf                	mov    %ecx,%edi
  800570:	eb 0e                	jmp    800580 <vprintfmt+0x230>
				putch(' ', putdat);
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	53                   	push   %ebx
  800576:	6a 20                	push   $0x20
  800578:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80057a:	83 ef 01             	sub    $0x1,%edi
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	85 ff                	test   %edi,%edi
  800582:	7f ee                	jg     800572 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800584:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	e9 67 01 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
  80058f:	89 cf                	mov    %ecx,%edi
  800591:	eb ed                	jmp    800580 <vprintfmt+0x230>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1b                	jg     8005b3 <vprintfmt+0x263>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 63                	je     8005ff <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	99                   	cltd   
  8005a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b1:	eb 17                	jmp    8005ca <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 50 04             	mov    0x4(%eax),%edx
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 08             	lea    0x8(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005d5:	85 c9                	test   %ecx,%ecx
  8005d7:	0f 89 ff 00 00 00    	jns    8006dc <vprintfmt+0x38c>
				putch('-', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	6a 2d                	push   $0x2d
  8005e3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005eb:	f7 da                	neg    %edx
  8005ed:	83 d1 00             	adc    $0x0,%ecx
  8005f0:	f7 d9                	neg    %ecx
  8005f2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 dd 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800607:	99                   	cltd   
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	eb b4                	jmp    8005ca <vprintfmt+0x27a>
	if (lflag >= 2)
  800616:	83 f9 01             	cmp    $0x1,%ecx
  800619:	7f 1e                	jg     800639 <vprintfmt+0x2e9>
	else if (lflag)
  80061b:	85 c9                	test   %ecx,%ecx
  80061d:	74 32                	je     800651 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 10                	mov    (%eax),%edx
  800624:	b9 00 00 00 00       	mov    $0x0,%ecx
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800634:	e9 a3 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	8b 48 04             	mov    0x4(%eax),%ecx
  800641:	8d 40 08             	lea    0x8(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800647:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80064c:	e9 8b 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800661:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800666:	eb 74                	jmp    8006dc <vprintfmt+0x38c>
	if (lflag >= 2)
  800668:	83 f9 01             	cmp    $0x1,%ecx
  80066b:	7f 1b                	jg     800688 <vprintfmt+0x338>
	else if (lflag)
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	74 2c                	je     80069d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800686:	eb 54                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	8b 48 04             	mov    0x4(%eax),%ecx
  800690:	8d 40 08             	lea    0x8(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80069b:	eb 3f                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8006ad:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006b2:	eb 28                	jmp    8006dc <vprintfmt+0x38c>
			putch('0', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 30                	push   $0x30
  8006ba:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bc:	83 c4 08             	add    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 78                	push   $0x78
  8006c2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006ce:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006e3:	57                   	push   %edi
  8006e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	51                   	push   %ecx
  8006e9:	52                   	push   %edx
  8006ea:	89 da                	mov    %ebx,%edx
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	e8 72 fb ff ff       	call   800265 <printnum>
			break;
  8006f3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f9:	83 c7 01             	add    $0x1,%edi
  8006fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800700:	83 f8 25             	cmp    $0x25,%eax
  800703:	0f 84 62 fc ff ff    	je     80036b <vprintfmt+0x1b>
			if (ch == '\0')
  800709:	85 c0                	test   %eax,%eax
  80070b:	0f 84 8b 00 00 00    	je     80079c <vprintfmt+0x44c>
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	50                   	push   %eax
  800716:	ff d6                	call   *%esi
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb dc                	jmp    8006f9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7f 1b                	jg     80073d <vprintfmt+0x3ed>
	else if (lflag)
  800722:	85 c9                	test   %ecx,%ecx
  800724:	74 2c                	je     800752 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80073b:	eb 9f                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	8b 48 04             	mov    0x4(%eax),%ecx
  800745:	8d 40 08             	lea    0x8(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800750:	eb 8a                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800762:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800767:	e9 70 ff ff ff       	jmp    8006dc <vprintfmt+0x38c>
			putch(ch, putdat);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	53                   	push   %ebx
  800770:	6a 25                	push   $0x25
  800772:	ff d6                	call   *%esi
			break;
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	e9 7a ff ff ff       	jmp    8006f6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	6a 25                	push   $0x25
  800782:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 f8                	mov    %edi,%eax
  800789:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80078d:	74 05                	je     800794 <vprintfmt+0x444>
  80078f:	83 e8 01             	sub    $0x1,%eax
  800792:	eb f5                	jmp    800789 <vprintfmt+0x439>
  800794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800797:	e9 5a ff ff ff       	jmp    8006f6 <vprintfmt+0x3a6>
}
  80079c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079f:	5b                   	pop    %ebx
  8007a0:	5e                   	pop    %esi
  8007a1:	5f                   	pop    %edi
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a4:	f3 0f 1e fb          	endbr32 
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 18             	sub    $0x18,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 26                	je     8007ef <vsnprintf+0x4b>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 22                	jle    8007ef <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	ff 75 14             	pushl  0x14(%ebp)
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	68 0e 03 80 00       	push   $0x80030e
  8007dc:	e8 6f fb ff ff       	call   800350 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    
		return -E_INVAL;
  8007ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f4:	eb f7                	jmp    8007ed <vsnprintf+0x49>

008007f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 92 ff ff ff       	call   8007a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800814:	f3 0f 1e fb          	endbr32 
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800827:	74 05                	je     80082e <strlen+0x1a>
		n++;
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	eb f5                	jmp    800823 <strlen+0xf>
	return n;
}
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083d:	b8 00 00 00 00       	mov    $0x0,%eax
  800842:	39 d0                	cmp    %edx,%eax
  800844:	74 0d                	je     800853 <strnlen+0x23>
  800846:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084a:	74 05                	je     800851 <strnlen+0x21>
		n++;
  80084c:	83 c0 01             	add    $0x1,%eax
  80084f:	eb f1                	jmp    800842 <strnlen+0x12>
  800851:	89 c2                	mov    %eax,%edx
	return n;
}
  800853:	89 d0                	mov    %edx,%eax
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800857:	f3 0f 1e fb          	endbr32 
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800862:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800865:	b8 00 00 00 00       	mov    $0x0,%eax
  80086a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	84 d2                	test   %dl,%dl
  800876:	75 f2                	jne    80086a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800878:	89 c8                	mov    %ecx,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087d:	f3 0f 1e fb          	endbr32 
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	53                   	push   %ebx
  800885:	83 ec 10             	sub    $0x10,%esp
  800888:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80088b:	53                   	push   %ebx
  80088c:	e8 83 ff ff ff       	call   800814 <strlen>
  800891:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	01 d8                	add    %ebx,%eax
  800899:	50                   	push   %eax
  80089a:	e8 b8 ff ff ff       	call   800857 <strcpy>
	return dst;
}
  80089f:	89 d8                	mov    %ebx,%eax
  8008a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a6:	f3 0f 1e fb          	endbr32 
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	89 f3                	mov    %esi,%ebx
  8008b7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	39 d8                	cmp    %ebx,%eax
  8008be:	74 11                	je     8008d1 <strncpy+0x2b>
		*dst++ = *src;
  8008c0:	83 c0 01             	add    $0x1,%eax
  8008c3:	0f b6 0a             	movzbl (%edx),%ecx
  8008c6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c9:	80 f9 01             	cmp    $0x1,%cl
  8008cc:	83 da ff             	sbb    $0xffffffff,%edx
  8008cf:	eb eb                	jmp    8008bc <strncpy+0x16>
	}
	return ret;
}
  8008d1:	89 f0                	mov    %esi,%eax
  8008d3:	5b                   	pop    %ebx
  8008d4:	5e                   	pop    %esi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d7:	f3 0f 1e fb          	endbr32 
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
  8008e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008eb:	85 d2                	test   %edx,%edx
  8008ed:	74 21                	je     800910 <strlcpy+0x39>
  8008ef:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f5:	39 c2                	cmp    %eax,%edx
  8008f7:	74 14                	je     80090d <strlcpy+0x36>
  8008f9:	0f b6 19             	movzbl (%ecx),%ebx
  8008fc:	84 db                	test   %bl,%bl
  8008fe:	74 0b                	je     80090b <strlcpy+0x34>
			*dst++ = *src++;
  800900:	83 c1 01             	add    $0x1,%ecx
  800903:	83 c2 01             	add    $0x1,%edx
  800906:	88 5a ff             	mov    %bl,-0x1(%edx)
  800909:	eb ea                	jmp    8008f5 <strlcpy+0x1e>
  80090b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800910:	29 f0                	sub    %esi,%eax
}
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800916:	f3 0f 1e fb          	endbr32 
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800923:	0f b6 01             	movzbl (%ecx),%eax
  800926:	84 c0                	test   %al,%al
  800928:	74 0c                	je     800936 <strcmp+0x20>
  80092a:	3a 02                	cmp    (%edx),%al
  80092c:	75 08                	jne    800936 <strcmp+0x20>
		p++, q++;
  80092e:	83 c1 01             	add    $0x1,%ecx
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	eb ed                	jmp    800923 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	0f b6 12             	movzbl (%edx),%edx
  80093c:	29 d0                	sub    %edx,%eax
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800940:	f3 0f 1e fb          	endbr32 
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	53                   	push   %ebx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	89 c3                	mov    %eax,%ebx
  800950:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800953:	eb 06                	jmp    80095b <strncmp+0x1b>
		n--, p++, q++;
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095b:	39 d8                	cmp    %ebx,%eax
  80095d:	74 16                	je     800975 <strncmp+0x35>
  80095f:	0f b6 08             	movzbl (%eax),%ecx
  800962:	84 c9                	test   %cl,%cl
  800964:	74 04                	je     80096a <strncmp+0x2a>
  800966:	3a 0a                	cmp    (%edx),%cl
  800968:	74 eb                	je     800955 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096a:	0f b6 00             	movzbl (%eax),%eax
  80096d:	0f b6 12             	movzbl (%edx),%edx
  800970:	29 d0                	sub    %edx,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    
		return 0;
  800975:	b8 00 00 00 00       	mov    $0x0,%eax
  80097a:	eb f6                	jmp    800972 <strncmp+0x32>

0080097c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098a:	0f b6 10             	movzbl (%eax),%edx
  80098d:	84 d2                	test   %dl,%dl
  80098f:	74 09                	je     80099a <strchr+0x1e>
		if (*s == c)
  800991:	38 ca                	cmp    %cl,%dl
  800993:	74 0a                	je     80099f <strchr+0x23>
	for (; *s; s++)
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	eb f0                	jmp    80098a <strchr+0xe>
			return (char *) s;
	return 0;
  80099a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a1:	f3 0f 1e fb          	endbr32 
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009af:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 09                	je     8009bf <strfind+0x1e>
  8009b6:	84 d2                	test   %dl,%dl
  8009b8:	74 05                	je     8009bf <strfind+0x1e>
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	eb f0                	jmp    8009af <strfind+0xe>
			break;
	return (char *) s;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c1:	f3 0f 1e fb          	endbr32 
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	57                   	push   %edi
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
  8009cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d1:	85 c9                	test   %ecx,%ecx
  8009d3:	74 31                	je     800a06 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d5:	89 f8                	mov    %edi,%eax
  8009d7:	09 c8                	or     %ecx,%eax
  8009d9:	a8 03                	test   $0x3,%al
  8009db:	75 23                	jne    800a00 <memset+0x3f>
		c &= 0xFF;
  8009dd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e1:	89 d3                	mov    %edx,%ebx
  8009e3:	c1 e3 08             	shl    $0x8,%ebx
  8009e6:	89 d0                	mov    %edx,%eax
  8009e8:	c1 e0 18             	shl    $0x18,%eax
  8009eb:	89 d6                	mov    %edx,%esi
  8009ed:	c1 e6 10             	shl    $0x10,%esi
  8009f0:	09 f0                	or     %esi,%eax
  8009f2:	09 c2                	or     %eax,%edx
  8009f4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f9:	89 d0                	mov    %edx,%eax
  8009fb:	fc                   	cld    
  8009fc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fe:	eb 06                	jmp    800a06 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	fc                   	cld    
  800a04:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a06:	89 f8                	mov    %edi,%eax
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5f                   	pop    %edi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0d:	f3 0f 1e fb          	endbr32 
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1f:	39 c6                	cmp    %eax,%esi
  800a21:	73 32                	jae    800a55 <memmove+0x48>
  800a23:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	76 2b                	jbe    800a55 <memmove+0x48>
		s += n;
		d += n;
  800a2a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2d:	89 fe                	mov    %edi,%esi
  800a2f:	09 ce                	or     %ecx,%esi
  800a31:	09 d6                	or     %edx,%esi
  800a33:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a39:	75 0e                	jne    800a49 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a3b:	83 ef 04             	sub    $0x4,%edi
  800a3e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a44:	fd                   	std    
  800a45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a47:	eb 09                	jmp    800a52 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a49:	83 ef 01             	sub    $0x1,%edi
  800a4c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4f:	fd                   	std    
  800a50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a52:	fc                   	cld    
  800a53:	eb 1a                	jmp    800a6f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a55:	89 c2                	mov    %eax,%edx
  800a57:	09 ca                	or     %ecx,%edx
  800a59:	09 f2                	or     %esi,%edx
  800a5b:	f6 c2 03             	test   $0x3,%dl
  800a5e:	75 0a                	jne    800a6a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a68:	eb 05                	jmp    800a6f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a6a:	89 c7                	mov    %eax,%edi
  800a6c:	fc                   	cld    
  800a6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6f:	5e                   	pop    %esi
  800a70:	5f                   	pop    %edi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a73:	f3 0f 1e fb          	endbr32 
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7d:	ff 75 10             	pushl  0x10(%ebp)
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 82 ff ff ff       	call   800a0d <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	f3 0f 1e fb          	endbr32 
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 c6                	mov    %eax,%esi
  800a9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa1:	39 f0                	cmp    %esi,%eax
  800aa3:	74 1c                	je     800ac1 <memcmp+0x34>
		if (*s1 != *s2)
  800aa5:	0f b6 08             	movzbl (%eax),%ecx
  800aa8:	0f b6 1a             	movzbl (%edx),%ebx
  800aab:	38 d9                	cmp    %bl,%cl
  800aad:	75 08                	jne    800ab7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aaf:	83 c0 01             	add    $0x1,%eax
  800ab2:	83 c2 01             	add    $0x1,%edx
  800ab5:	eb ea                	jmp    800aa1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab7:	0f b6 c1             	movzbl %cl,%eax
  800aba:	0f b6 db             	movzbl %bl,%ebx
  800abd:	29 d8                	sub    %ebx,%eax
  800abf:	eb 05                	jmp    800ac6 <memcmp+0x39>
	}

	return 0;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aca:	f3 0f 1e fb          	endbr32 
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad7:	89 c2                	mov    %eax,%edx
  800ad9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800adc:	39 d0                	cmp    %edx,%eax
  800ade:	73 09                	jae    800ae9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae0:	38 08                	cmp    %cl,(%eax)
  800ae2:	74 05                	je     800ae9 <memfind+0x1f>
	for (; s < ends; s++)
  800ae4:	83 c0 01             	add    $0x1,%eax
  800ae7:	eb f3                	jmp    800adc <memfind+0x12>
			break;
	return (void *) s;
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aeb:	f3 0f 1e fb          	endbr32 
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afb:	eb 03                	jmp    800b00 <strtol+0x15>
		s++;
  800afd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b00:	0f b6 01             	movzbl (%ecx),%eax
  800b03:	3c 20                	cmp    $0x20,%al
  800b05:	74 f6                	je     800afd <strtol+0x12>
  800b07:	3c 09                	cmp    $0x9,%al
  800b09:	74 f2                	je     800afd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b0b:	3c 2b                	cmp    $0x2b,%al
  800b0d:	74 2a                	je     800b39 <strtol+0x4e>
	int neg = 0;
  800b0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b14:	3c 2d                	cmp    $0x2d,%al
  800b16:	74 2b                	je     800b43 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1e:	75 0f                	jne    800b2f <strtol+0x44>
  800b20:	80 39 30             	cmpb   $0x30,(%ecx)
  800b23:	74 28                	je     800b4d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b25:	85 db                	test   %ebx,%ebx
  800b27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2c:	0f 44 d8             	cmove  %eax,%ebx
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b37:	eb 46                	jmp    800b7f <strtol+0x94>
		s++;
  800b39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b41:	eb d5                	jmp    800b18 <strtol+0x2d>
		s++, neg = 1;
  800b43:	83 c1 01             	add    $0x1,%ecx
  800b46:	bf 01 00 00 00       	mov    $0x1,%edi
  800b4b:	eb cb                	jmp    800b18 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b51:	74 0e                	je     800b61 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b53:	85 db                	test   %ebx,%ebx
  800b55:	75 d8                	jne    800b2f <strtol+0x44>
		s++, base = 8;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5f:	eb ce                	jmp    800b2f <strtol+0x44>
		s += 2, base = 16;
  800b61:	83 c1 02             	add    $0x2,%ecx
  800b64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b69:	eb c4                	jmp    800b2f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b6b:	0f be d2             	movsbl %dl,%edx
  800b6e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b71:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b74:	7d 3a                	jge    800bb0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b76:	83 c1 01             	add    $0x1,%ecx
  800b79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7f:	0f b6 11             	movzbl (%ecx),%edx
  800b82:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b85:	89 f3                	mov    %esi,%ebx
  800b87:	80 fb 09             	cmp    $0x9,%bl
  800b8a:	76 df                	jbe    800b6b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b8c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8f:	89 f3                	mov    %esi,%ebx
  800b91:	80 fb 19             	cmp    $0x19,%bl
  800b94:	77 08                	ja     800b9e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b96:	0f be d2             	movsbl %dl,%edx
  800b99:	83 ea 57             	sub    $0x57,%edx
  800b9c:	eb d3                	jmp    800b71 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba1:	89 f3                	mov    %esi,%ebx
  800ba3:	80 fb 19             	cmp    $0x19,%bl
  800ba6:	77 08                	ja     800bb0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba8:	0f be d2             	movsbl %dl,%edx
  800bab:	83 ea 37             	sub    $0x37,%edx
  800bae:	eb c1                	jmp    800b71 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb4:	74 05                	je     800bbb <strtol+0xd0>
		*endptr = (char *) s;
  800bb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	f7 da                	neg    %edx
  800bbf:	85 ff                	test   %edi,%edi
  800bc1:	0f 45 c2             	cmovne %edx,%eax
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc9:	f3 0f 1e fb          	endbr32 
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	89 c7                	mov    %eax,%edi
  800be2:	89 c6                	mov    %eax,%esi
  800be4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_cgetc>:

int
sys_cgetc(void)
{
  800beb:	f3 0f 1e fb          	endbr32 
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  800bff:	89 d1                	mov    %edx,%ecx
  800c01:	89 d3                	mov    %edx,%ebx
  800c03:	89 d7                	mov    %edx,%edi
  800c05:	89 d6                	mov    %edx,%esi
  800c07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0e:	f3 0f 1e fb          	endbr32 
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	89 cb                	mov    %ecx,%ebx
  800c2a:	89 cf                	mov    %ecx,%edi
  800c2c:	89 ce                	mov    %ecx,%esi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 03                	push   $0x3
  800c42:	68 bf 26 80 00       	push   $0x8026bf
  800c47:	6a 23                	push   $0x23
  800c49:	68 dc 26 80 00       	push   $0x8026dc
  800c4e:	e8 13 f5 ff ff       	call   800166 <_panic>

00800c53 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c53:	f3 0f 1e fb          	endbr32 
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	b8 02 00 00 00       	mov    $0x2,%eax
  800c67:	89 d1                	mov    %edx,%ecx
  800c69:	89 d3                	mov    %edx,%ebx
  800c6b:	89 d7                	mov    %edx,%edi
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_yield>:

void
sys_yield(void)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	be 00 00 00 00       	mov    $0x0,%esi
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb9:	89 f7                	mov    %esi,%edi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 04                	push   $0x4
  800ccf:	68 bf 26 80 00       	push   $0x8026bf
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 dc 26 80 00       	push   $0x8026dc
  800cdb:	e8 86 f4 ff ff       	call   800166 <_panic>

00800ce0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce0:	f3 0f 1e fb          	endbr32 
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfe:	8b 75 18             	mov    0x18(%ebp),%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 05                	push   $0x5
  800d15:	68 bf 26 80 00       	push   $0x8026bf
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 dc 26 80 00       	push   $0x8026dc
  800d21:	e8 40 f4 ff ff       	call   800166 <_panic>

00800d26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 06                	push   $0x6
  800d5b:	68 bf 26 80 00       	push   $0x8026bf
  800d60:	6a 23                	push   $0x23
  800d62:	68 dc 26 80 00       	push   $0x8026dc
  800d67:	e8 fa f3 ff ff       	call   800166 <_panic>

00800d6c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d6c:	f3 0f 1e fb          	endbr32 
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 08 00 00 00       	mov    $0x8,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 08                	push   $0x8
  800da1:	68 bf 26 80 00       	push   $0x8026bf
  800da6:	6a 23                	push   $0x23
  800da8:	68 dc 26 80 00       	push   $0x8026dc
  800dad:	e8 b4 f3 ff ff       	call   800166 <_panic>

00800db2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db2:	f3 0f 1e fb          	endbr32 
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcf:	89 df                	mov    %ebx,%edi
  800dd1:	89 de                	mov    %ebx,%esi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 09                	push   $0x9
  800de7:	68 bf 26 80 00       	push   $0x8026bf
  800dec:	6a 23                	push   $0x23
  800dee:	68 dc 26 80 00       	push   $0x8026dc
  800df3:	e8 6e f3 ff ff       	call   800166 <_panic>

00800df8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df8:	f3 0f 1e fb          	endbr32 
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0a                	push   $0xa
  800e2d:	68 bf 26 80 00       	push   $0x8026bf
  800e32:	6a 23                	push   $0x23
  800e34:	68 dc 26 80 00       	push   $0x8026dc
  800e39:	e8 28 f3 ff ff       	call   800166 <_panic>

00800e3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e53:	be 00 00 00 00       	mov    $0x0,%esi
  800e58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e65:	f3 0f 1e fb          	endbr32 
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 0d                	push   $0xd
  800e99:	68 bf 26 80 00       	push   $0x8026bf
  800e9e:	6a 23                	push   $0x23
  800ea0:	68 dc 26 80 00       	push   $0x8026dc
  800ea5:	e8 bc f2 ff ff       	call   800166 <_panic>

00800eaa <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800eaa:	f3 0f 1e fb          	endbr32 
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eb6:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800eb8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ebc:	74 7f                	je     800f3d <pgfault+0x93>
  800ebe:	89 f0                	mov    %esi,%eax
  800ec0:	c1 e8 0c             	shr    $0xc,%eax
  800ec3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eca:	f6 c4 08             	test   $0x8,%ah
  800ecd:	74 6e                	je     800f3d <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800ecf:	e8 7f fd ff ff       	call   800c53 <sys_getenvid>
  800ed4:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800ed6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800edc:	83 ec 04             	sub    $0x4,%esp
  800edf:	6a 07                	push   $0x7
  800ee1:	68 00 f0 7f 00       	push   $0x7ff000
  800ee6:	50                   	push   %eax
  800ee7:	e8 ad fd ff ff       	call   800c99 <sys_page_alloc>
  800eec:	83 c4 10             	add    $0x10,%esp
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	78 5e                	js     800f51 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	68 00 10 00 00       	push   $0x1000
  800efb:	56                   	push   %esi
  800efc:	68 00 f0 7f 00       	push   $0x7ff000
  800f01:	e8 6d fb ff ff       	call   800a73 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800f06:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	68 00 f0 7f 00       	push   $0x7ff000
  800f14:	53                   	push   %ebx
  800f15:	e8 c6 fd ff ff       	call   800ce0 <sys_page_map>
  800f1a:	83 c4 20             	add    $0x20,%esp
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	78 44                	js     800f65 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	68 00 f0 7f 00       	push   $0x7ff000
  800f29:	53                   	push   %ebx
  800f2a:	e8 f7 fd ff ff       	call   800d26 <sys_page_unmap>
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 43                	js     800f79 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800f3d:	83 ec 04             	sub    $0x4,%esp
  800f40:	68 ea 26 80 00       	push   $0x8026ea
  800f45:	6a 1e                	push   $0x1e
  800f47:	68 07 27 80 00       	push   $0x802707
  800f4c:	e8 15 f2 ff ff       	call   800166 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	68 98 27 80 00       	push   $0x802798
  800f59:	6a 2b                	push   $0x2b
  800f5b:	68 07 27 80 00       	push   $0x802707
  800f60:	e8 01 f2 ff ff       	call   800166 <_panic>
		panic("pgfault: sys_page_map Failed!");
  800f65:	83 ec 04             	sub    $0x4,%esp
  800f68:	68 12 27 80 00       	push   $0x802712
  800f6d:	6a 2f                	push   $0x2f
  800f6f:	68 07 27 80 00       	push   $0x802707
  800f74:	e8 ed f1 ff ff       	call   800166 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800f79:	83 ec 04             	sub    $0x4,%esp
  800f7c:	68 b8 27 80 00       	push   $0x8027b8
  800f81:	6a 32                	push   $0x32
  800f83:	68 07 27 80 00       	push   $0x802707
  800f88:	e8 d9 f1 ff ff       	call   800166 <_panic>

00800f8d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f8d:	f3 0f 1e fb          	endbr32 
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
  800f97:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f9a:	68 aa 0e 80 00       	push   $0x800eaa
  800f9f:	e8 6f 10 00 00       	call   802013 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fa4:	b8 07 00 00 00       	mov    $0x7,%eax
  800fa9:	cd 30                	int    $0x30
  800fab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  800fb1:	83 c4 10             	add    $0x10,%esp
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	78 2b                	js     800fe3 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  800fb8:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  800fbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fc1:	0f 85 ba 00 00 00    	jne    801081 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  800fc7:	e8 87 fc ff ff       	call   800c53 <sys_getenvid>
  800fcc:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fd1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fd4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fd9:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800fde:	e9 90 01 00 00       	jmp    801173 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  800fe3:	83 ec 04             	sub    $0x4,%esp
  800fe6:	68 30 27 80 00       	push   $0x802730
  800feb:	6a 76                	push   $0x76
  800fed:	68 07 27 80 00       	push   $0x802707
  800ff2:	e8 6f f1 ff ff       	call   800166 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  800ff7:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  800ffe:	e8 50 fc ff ff       	call   800c53 <sys_getenvid>
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  80100c:	56                   	push   %esi
  80100d:	57                   	push   %edi
  80100e:	ff 75 e0             	pushl  -0x20(%ebp)
  801011:	57                   	push   %edi
  801012:	50                   	push   %eax
  801013:	e8 c8 fc ff ff       	call   800ce0 <sys_page_map>
  801018:	83 c4 20             	add    $0x20,%esp
  80101b:	85 c0                	test   %eax,%eax
  80101d:	79 50                	jns    80106f <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  80101f:	83 ec 04             	sub    $0x4,%esp
  801022:	68 49 27 80 00       	push   $0x802749
  801027:	6a 4b                	push   $0x4b
  801029:	68 07 27 80 00       	push   $0x802707
  80102e:	e8 33 f1 ff ff       	call   800166 <_panic>
			panic("duppage:child sys_page_map Failed!");
  801033:	83 ec 04             	sub    $0x4,%esp
  801036:	68 d8 27 80 00       	push   $0x8027d8
  80103b:	6a 50                	push   $0x50
  80103d:	68 07 27 80 00       	push   $0x802707
  801042:	e8 1f f1 ff ff       	call   800166 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  801047:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80104e:	83 ec 0c             	sub    $0xc,%esp
  801051:	25 07 0e 00 00       	and    $0xe07,%eax
  801056:	50                   	push   %eax
  801057:	57                   	push   %edi
  801058:	ff 75 e0             	pushl  -0x20(%ebp)
  80105b:	57                   	push   %edi
  80105c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105f:	e8 7c fc ff ff       	call   800ce0 <sys_page_map>
  801064:	83 c4 20             	add    $0x20,%esp
  801067:	85 c0                	test   %eax,%eax
  801069:	0f 88 b4 00 00 00    	js     801123 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  80106f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801075:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80107b:	0f 84 b6 00 00 00    	je     801137 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801081:	89 d8                	mov    %ebx,%eax
  801083:	c1 e8 16             	shr    $0x16,%eax
  801086:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80108d:	a8 01                	test   $0x1,%al
  80108f:	74 de                	je     80106f <fork+0xe2>
  801091:	89 de                	mov    %ebx,%esi
  801093:	c1 ee 0c             	shr    $0xc,%esi
  801096:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80109d:	a8 01                	test   $0x1,%al
  80109f:	74 ce                	je     80106f <fork+0xe2>
	envid_t f_id=sys_getenvid();
  8010a1:	e8 ad fb ff ff       	call   800c53 <sys_getenvid>
  8010a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  8010a9:	89 f7                	mov    %esi,%edi
  8010ab:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  8010ae:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010b5:	f6 c4 04             	test   $0x4,%ah
  8010b8:	0f 85 39 ff ff ff    	jne    800ff7 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  8010be:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010c5:	a9 02 08 00 00       	test   $0x802,%eax
  8010ca:	0f 84 77 ff ff ff    	je     801047 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	68 05 08 00 00       	push   $0x805
  8010d8:	57                   	push   %edi
  8010d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8010dc:	57                   	push   %edi
  8010dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e0:	e8 fb fb ff ff       	call   800ce0 <sys_page_map>
  8010e5:	83 c4 20             	add    $0x20,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	0f 88 43 ff ff ff    	js     801033 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	68 05 08 00 00       	push   $0x805
  8010f8:	57                   	push   %edi
  8010f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010fc:	50                   	push   %eax
  8010fd:	57                   	push   %edi
  8010fe:	50                   	push   %eax
  8010ff:	e8 dc fb ff ff       	call   800ce0 <sys_page_map>
  801104:	83 c4 20             	add    $0x20,%esp
  801107:	85 c0                	test   %eax,%eax
  801109:	0f 89 60 ff ff ff    	jns    80106f <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  80110f:	83 ec 04             	sub    $0x4,%esp
  801112:	68 fc 27 80 00       	push   $0x8027fc
  801117:	6a 52                	push   $0x52
  801119:	68 07 27 80 00       	push   $0x802707
  80111e:	e8 43 f0 ff ff       	call   800166 <_panic>
			panic("duppage: single sys_page_map Failed!");
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	68 20 28 80 00       	push   $0x802820
  80112b:	6a 56                	push   $0x56
  80112d:	68 07 27 80 00       	push   $0x802707
  801132:	e8 2f f0 ff ff       	call   800166 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801137:	83 ec 04             	sub    $0x4,%esp
  80113a:	6a 07                	push   $0x7
  80113c:	68 00 f0 bf ee       	push   $0xeebff000
  801141:	ff 75 dc             	pushl  -0x24(%ebp)
  801144:	e8 50 fb ff ff       	call   800c99 <sys_page_alloc>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 2e                	js     80117e <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	68 8f 20 80 00       	push   $0x80208f
  801158:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80115b:	57                   	push   %edi
  80115c:	e8 97 fc ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801161:	83 c4 08             	add    $0x8,%esp
  801164:	6a 02                	push   $0x2
  801166:	57                   	push   %edi
  801167:	e8 00 fc ff ff       	call   800d6c <sys_env_set_status>
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 22                	js     801195 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801179:	5b                   	pop    %ebx
  80117a:	5e                   	pop    %esi
  80117b:	5f                   	pop    %edi
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 66 27 80 00       	push   $0x802766
  801186:	68 83 00 00 00       	push   $0x83
  80118b:	68 07 27 80 00       	push   $0x802707
  801190:	e8 d1 ef ff ff       	call   800166 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	68 48 28 80 00       	push   $0x802848
  80119d:	68 89 00 00 00       	push   $0x89
  8011a2:	68 07 27 80 00       	push   $0x802707
  8011a7:	e8 ba ef ff ff       	call   800166 <_panic>

008011ac <sfork>:

// Challenge!
int
sfork(void)
{
  8011ac:	f3 0f 1e fb          	endbr32 
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b6:	68 82 27 80 00       	push   $0x802782
  8011bb:	68 93 00 00 00       	push   $0x93
  8011c0:	68 07 27 80 00       	push   $0x802707
  8011c5:	e8 9c ef ff ff       	call   800166 <_panic>

008011ca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011ca:	f3 0f 1e fb          	endbr32 
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8011e3:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	50                   	push   %eax
  8011ea:	e8 76 fc ff ff       	call   800e65 <sys_ipc_recv>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 2b                	js     801221 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8011f6:	85 f6                	test   %esi,%esi
  8011f8:	74 0a                	je     801204 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  8011fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ff:	8b 40 74             	mov    0x74(%eax),%eax
  801202:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801204:	85 db                	test   %ebx,%ebx
  801206:	74 0a                	je     801212 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801208:	a1 04 40 80 00       	mov    0x804004,%eax
  80120d:	8b 40 78             	mov    0x78(%eax),%eax
  801210:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801212:	a1 04 40 80 00       	mov    0x804004,%eax
  801217:	8b 40 70             	mov    0x70(%eax),%eax
}
  80121a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    
		if(from_env_store)
  801221:	85 f6                	test   %esi,%esi
  801223:	74 06                	je     80122b <ipc_recv+0x61>
			*from_env_store=0;
  801225:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80122b:	85 db                	test   %ebx,%ebx
  80122d:	74 eb                	je     80121a <ipc_recv+0x50>
			*perm_store=0;
  80122f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801235:	eb e3                	jmp    80121a <ipc_recv+0x50>

00801237 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801237:	f3 0f 1e fb          	endbr32 
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	8b 7d 08             	mov    0x8(%ebp),%edi
  801247:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80124d:	85 db                	test   %ebx,%ebx
  80124f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801254:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801257:	ff 75 14             	pushl  0x14(%ebp)
  80125a:	53                   	push   %ebx
  80125b:	56                   	push   %esi
  80125c:	57                   	push   %edi
  80125d:	e8 dc fb ff ff       	call   800e3e <sys_ipc_try_send>
		if(!res)
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	74 20                	je     801289 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  801269:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80126c:	75 07                	jne    801275 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80126e:	e8 03 fa ff ff       	call   800c76 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  801273:	eb e2                	jmp    801257 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	68 69 28 80 00       	push   $0x802869
  80127d:	6a 3f                	push   $0x3f
  80127f:	68 81 28 80 00       	push   $0x802881
  801284:	e8 dd ee ff ff       	call   800166 <_panic>
	}
}
  801289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801291:	f3 0f 1e fb          	endbr32 
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012a0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012a3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012a9:	8b 52 50             	mov    0x50(%edx),%edx
  8012ac:	39 ca                	cmp    %ecx,%edx
  8012ae:	74 11                	je     8012c1 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012b0:	83 c0 01             	add    $0x1,%eax
  8012b3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012b8:	75 e6                	jne    8012a0 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8012ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bf:	eb 0b                	jmp    8012cc <ipc_find_env+0x3b>
			return envs[i].env_id;
  8012c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012c9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012ce:	f3 0f 1e fb          	endbr32 
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	05 00 00 00 30       	add    $0x30000000,%eax
  8012dd:	c1 e8 0c             	shr    $0xc,%eax
}
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e2:	f3 0f 1e fb          	endbr32 
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012fd:	f3 0f 1e fb          	endbr32 
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801309:	89 c2                	mov    %eax,%edx
  80130b:	c1 ea 16             	shr    $0x16,%edx
  80130e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801315:	f6 c2 01             	test   $0x1,%dl
  801318:	74 2d                	je     801347 <fd_alloc+0x4a>
  80131a:	89 c2                	mov    %eax,%edx
  80131c:	c1 ea 0c             	shr    $0xc,%edx
  80131f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801326:	f6 c2 01             	test   $0x1,%dl
  801329:	74 1c                	je     801347 <fd_alloc+0x4a>
  80132b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801330:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801335:	75 d2                	jne    801309 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801340:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801345:	eb 0a                	jmp    801351 <fd_alloc+0x54>
			*fd_store = fd;
  801347:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    

00801353 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801353:	f3 0f 1e fb          	endbr32 
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80135d:	83 f8 1f             	cmp    $0x1f,%eax
  801360:	77 30                	ja     801392 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801362:	c1 e0 0c             	shl    $0xc,%eax
  801365:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80136a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801370:	f6 c2 01             	test   $0x1,%dl
  801373:	74 24                	je     801399 <fd_lookup+0x46>
  801375:	89 c2                	mov    %eax,%edx
  801377:	c1 ea 0c             	shr    $0xc,%edx
  80137a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801381:	f6 c2 01             	test   $0x1,%dl
  801384:	74 1a                	je     8013a0 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801386:	8b 55 0c             	mov    0xc(%ebp),%edx
  801389:	89 02                	mov    %eax,(%edx)
	return 0;
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    
		return -E_INVAL;
  801392:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801397:	eb f7                	jmp    801390 <fd_lookup+0x3d>
		return -E_INVAL;
  801399:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139e:	eb f0                	jmp    801390 <fd_lookup+0x3d>
  8013a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a5:	eb e9                	jmp    801390 <fd_lookup+0x3d>

008013a7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013a7:	f3 0f 1e fb          	endbr32 
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b4:	ba 08 29 80 00       	mov    $0x802908,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013b9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013be:	39 08                	cmp    %ecx,(%eax)
  8013c0:	74 33                	je     8013f5 <dev_lookup+0x4e>
  8013c2:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013c5:	8b 02                	mov    (%edx),%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	75 f3                	jne    8013be <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d0:	8b 40 48             	mov    0x48(%eax),%eax
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	51                   	push   %ecx
  8013d7:	50                   	push   %eax
  8013d8:	68 8c 28 80 00       	push   $0x80288c
  8013dd:	e8 6b ee ff ff       	call   80024d <cprintf>
	*dev = 0;
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    
			*dev = devtab[i];
  8013f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	eb f2                	jmp    8013f3 <dev_lookup+0x4c>

00801401 <fd_close>:
{
  801401:	f3 0f 1e fb          	endbr32 
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	57                   	push   %edi
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	83 ec 24             	sub    $0x24,%esp
  80140e:	8b 75 08             	mov    0x8(%ebp),%esi
  801411:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801414:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801417:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801418:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80141e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801421:	50                   	push   %eax
  801422:	e8 2c ff ff ff       	call   801353 <fd_lookup>
  801427:	89 c3                	mov    %eax,%ebx
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 05                	js     801435 <fd_close+0x34>
	    || fd != fd2)
  801430:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801433:	74 16                	je     80144b <fd_close+0x4a>
		return (must_exist ? r : 0);
  801435:	89 f8                	mov    %edi,%eax
  801437:	84 c0                	test   %al,%al
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
  80143e:	0f 44 d8             	cmove  %eax,%ebx
}
  801441:	89 d8                	mov    %ebx,%eax
  801443:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801446:	5b                   	pop    %ebx
  801447:	5e                   	pop    %esi
  801448:	5f                   	pop    %edi
  801449:	5d                   	pop    %ebp
  80144a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	ff 36                	pushl  (%esi)
  801454:	e8 4e ff ff ff       	call   8013a7 <dev_lookup>
  801459:	89 c3                	mov    %eax,%ebx
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 1a                	js     80147c <fd_close+0x7b>
		if (dev->dev_close)
  801462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801465:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801468:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80146d:	85 c0                	test   %eax,%eax
  80146f:	74 0b                	je     80147c <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801471:	83 ec 0c             	sub    $0xc,%esp
  801474:	56                   	push   %esi
  801475:	ff d0                	call   *%eax
  801477:	89 c3                	mov    %eax,%ebx
  801479:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	56                   	push   %esi
  801480:	6a 00                	push   $0x0
  801482:	e8 9f f8 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	eb b5                	jmp    801441 <fd_close+0x40>

0080148c <close>:

int
close(int fdnum)
{
  80148c:	f3 0f 1e fb          	endbr32 
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801496:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801499:	50                   	push   %eax
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	e8 b1 fe ff ff       	call   801353 <fd_lookup>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	79 02                	jns    8014ab <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    
		return fd_close(fd, 1);
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	6a 01                	push   $0x1
  8014b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b3:	e8 49 ff ff ff       	call   801401 <fd_close>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	eb ec                	jmp    8014a9 <close+0x1d>

008014bd <close_all>:

void
close_all(void)
{
  8014bd:	f3 0f 1e fb          	endbr32 
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	53                   	push   %ebx
  8014c5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014cd:	83 ec 0c             	sub    $0xc,%esp
  8014d0:	53                   	push   %ebx
  8014d1:	e8 b6 ff ff ff       	call   80148c <close>
	for (i = 0; i < MAXFD; i++)
  8014d6:	83 c3 01             	add    $0x1,%ebx
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	83 fb 20             	cmp    $0x20,%ebx
  8014df:	75 ec                	jne    8014cd <close_all+0x10>
}
  8014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014e6:	f3 0f 1e fb          	endbr32 
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	57                   	push   %edi
  8014ee:	56                   	push   %esi
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 54 fe ff ff       	call   801353 <fd_lookup>
  8014ff:	89 c3                	mov    %eax,%ebx
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	0f 88 81 00 00 00    	js     80158d <dup+0xa7>
		return r;
	close(newfdnum);
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	e8 75 ff ff ff       	call   80148c <close>

	newfd = INDEX2FD(newfdnum);
  801517:	8b 75 0c             	mov    0xc(%ebp),%esi
  80151a:	c1 e6 0c             	shl    $0xc,%esi
  80151d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801523:	83 c4 04             	add    $0x4,%esp
  801526:	ff 75 e4             	pushl  -0x1c(%ebp)
  801529:	e8 b4 fd ff ff       	call   8012e2 <fd2data>
  80152e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801530:	89 34 24             	mov    %esi,(%esp)
  801533:	e8 aa fd ff ff       	call   8012e2 <fd2data>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80153d:	89 d8                	mov    %ebx,%eax
  80153f:	c1 e8 16             	shr    $0x16,%eax
  801542:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801549:	a8 01                	test   $0x1,%al
  80154b:	74 11                	je     80155e <dup+0x78>
  80154d:	89 d8                	mov    %ebx,%eax
  80154f:	c1 e8 0c             	shr    $0xc,%eax
  801552:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801559:	f6 c2 01             	test   $0x1,%dl
  80155c:	75 39                	jne    801597 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80155e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	c1 e8 0c             	shr    $0xc,%eax
  801566:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80156d:	83 ec 0c             	sub    $0xc,%esp
  801570:	25 07 0e 00 00       	and    $0xe07,%eax
  801575:	50                   	push   %eax
  801576:	56                   	push   %esi
  801577:	6a 00                	push   $0x0
  801579:	52                   	push   %edx
  80157a:	6a 00                	push   $0x0
  80157c:	e8 5f f7 ff ff       	call   800ce0 <sys_page_map>
  801581:	89 c3                	mov    %eax,%ebx
  801583:	83 c4 20             	add    $0x20,%esp
  801586:	85 c0                	test   %eax,%eax
  801588:	78 31                	js     8015bb <dup+0xd5>
		goto err;

	return newfdnum;
  80158a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80158d:	89 d8                	mov    %ebx,%eax
  80158f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801592:	5b                   	pop    %ebx
  801593:	5e                   	pop    %esi
  801594:	5f                   	pop    %edi
  801595:	5d                   	pop    %ebp
  801596:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801597:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a6:	50                   	push   %eax
  8015a7:	57                   	push   %edi
  8015a8:	6a 00                	push   $0x0
  8015aa:	53                   	push   %ebx
  8015ab:	6a 00                	push   $0x0
  8015ad:	e8 2e f7 ff ff       	call   800ce0 <sys_page_map>
  8015b2:	89 c3                	mov    %eax,%ebx
  8015b4:	83 c4 20             	add    $0x20,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	79 a3                	jns    80155e <dup+0x78>
	sys_page_unmap(0, newfd);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	56                   	push   %esi
  8015bf:	6a 00                	push   $0x0
  8015c1:	e8 60 f7 ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015c6:	83 c4 08             	add    $0x8,%esp
  8015c9:	57                   	push   %edi
  8015ca:	6a 00                	push   $0x0
  8015cc:	e8 55 f7 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	eb b7                	jmp    80158d <dup+0xa7>

008015d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015d6:	f3 0f 1e fb          	endbr32 
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 1c             	sub    $0x1c,%esp
  8015e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e7:	50                   	push   %eax
  8015e8:	53                   	push   %ebx
  8015e9:	e8 65 fd ff ff       	call   801353 <fd_lookup>
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 3f                	js     801634 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fb:	50                   	push   %eax
  8015fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ff:	ff 30                	pushl  (%eax)
  801601:	e8 a1 fd ff ff       	call   8013a7 <dev_lookup>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 27                	js     801634 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80160d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801610:	8b 42 08             	mov    0x8(%edx),%eax
  801613:	83 e0 03             	and    $0x3,%eax
  801616:	83 f8 01             	cmp    $0x1,%eax
  801619:	74 1e                	je     801639 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161e:	8b 40 08             	mov    0x8(%eax),%eax
  801621:	85 c0                	test   %eax,%eax
  801623:	74 35                	je     80165a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	ff 75 10             	pushl  0x10(%ebp)
  80162b:	ff 75 0c             	pushl  0xc(%ebp)
  80162e:	52                   	push   %edx
  80162f:	ff d0                	call   *%eax
  801631:	83 c4 10             	add    $0x10,%esp
}
  801634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801637:	c9                   	leave  
  801638:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801639:	a1 04 40 80 00       	mov    0x804004,%eax
  80163e:	8b 40 48             	mov    0x48(%eax),%eax
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	53                   	push   %ebx
  801645:	50                   	push   %eax
  801646:	68 cd 28 80 00       	push   $0x8028cd
  80164b:	e8 fd eb ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801658:	eb da                	jmp    801634 <read+0x5e>
		return -E_NOT_SUPP;
  80165a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165f:	eb d3                	jmp    801634 <read+0x5e>

00801661 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801661:	f3 0f 1e fb          	endbr32 
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	57                   	push   %edi
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801671:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801674:	bb 00 00 00 00       	mov    $0x0,%ebx
  801679:	eb 02                	jmp    80167d <readn+0x1c>
  80167b:	01 c3                	add    %eax,%ebx
  80167d:	39 f3                	cmp    %esi,%ebx
  80167f:	73 21                	jae    8016a2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801681:	83 ec 04             	sub    $0x4,%esp
  801684:	89 f0                	mov    %esi,%eax
  801686:	29 d8                	sub    %ebx,%eax
  801688:	50                   	push   %eax
  801689:	89 d8                	mov    %ebx,%eax
  80168b:	03 45 0c             	add    0xc(%ebp),%eax
  80168e:	50                   	push   %eax
  80168f:	57                   	push   %edi
  801690:	e8 41 ff ff ff       	call   8015d6 <read>
		if (m < 0)
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 04                	js     8016a0 <readn+0x3f>
			return m;
		if (m == 0)
  80169c:	75 dd                	jne    80167b <readn+0x1a>
  80169e:	eb 02                	jmp    8016a2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016a2:	89 d8                	mov    %ebx,%eax
  8016a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a7:	5b                   	pop    %ebx
  8016a8:	5e                   	pop    %esi
  8016a9:	5f                   	pop    %edi
  8016aa:	5d                   	pop    %ebp
  8016ab:	c3                   	ret    

008016ac <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016ac:	f3 0f 1e fb          	endbr32 
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 1c             	sub    $0x1c,%esp
  8016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bd:	50                   	push   %eax
  8016be:	53                   	push   %ebx
  8016bf:	e8 8f fc ff ff       	call   801353 <fd_lookup>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 3a                	js     801705 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d1:	50                   	push   %eax
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	ff 30                	pushl  (%eax)
  8016d7:	e8 cb fc ff ff       	call   8013a7 <dev_lookup>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 22                	js     801705 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ea:	74 1e                	je     80170a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8016f2:	85 d2                	test   %edx,%edx
  8016f4:	74 35                	je     80172b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	ff 75 10             	pushl  0x10(%ebp)
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	50                   	push   %eax
  801700:	ff d2                	call   *%edx
  801702:	83 c4 10             	add    $0x10,%esp
}
  801705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801708:	c9                   	leave  
  801709:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80170a:	a1 04 40 80 00       	mov    0x804004,%eax
  80170f:	8b 40 48             	mov    0x48(%eax),%eax
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	53                   	push   %ebx
  801716:	50                   	push   %eax
  801717:	68 e9 28 80 00       	push   $0x8028e9
  80171c:	e8 2c eb ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801729:	eb da                	jmp    801705 <write+0x59>
		return -E_NOT_SUPP;
  80172b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801730:	eb d3                	jmp    801705 <write+0x59>

00801732 <seek>:

int
seek(int fdnum, off_t offset)
{
  801732:	f3 0f 1e fb          	endbr32 
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80173c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173f:	50                   	push   %eax
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	e8 0b fc ff ff       	call   801353 <fd_lookup>
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	85 c0                	test   %eax,%eax
  80174d:	78 0e                	js     80175d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80174f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801755:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80175f:	f3 0f 1e fb          	endbr32 
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	53                   	push   %ebx
  801767:	83 ec 1c             	sub    $0x1c,%esp
  80176a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80176d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801770:	50                   	push   %eax
  801771:	53                   	push   %ebx
  801772:	e8 dc fb ff ff       	call   801353 <fd_lookup>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 37                	js     8017b5 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801784:	50                   	push   %eax
  801785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801788:	ff 30                	pushl  (%eax)
  80178a:	e8 18 fc ff ff       	call   8013a7 <dev_lookup>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	78 1f                	js     8017b5 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80179d:	74 1b                	je     8017ba <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	8b 52 18             	mov    0x18(%edx),%edx
  8017a5:	85 d2                	test   %edx,%edx
  8017a7:	74 32                	je     8017db <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	ff d2                	call   *%edx
  8017b2:	83 c4 10             	add    $0x10,%esp
}
  8017b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017ba:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017bf:	8b 40 48             	mov    0x48(%eax),%eax
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	53                   	push   %ebx
  8017c6:	50                   	push   %eax
  8017c7:	68 ac 28 80 00       	push   $0x8028ac
  8017cc:	e8 7c ea ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d9:	eb da                	jmp    8017b5 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017e0:	eb d3                	jmp    8017b5 <ftruncate+0x56>

008017e2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017e2:	f3 0f 1e fb          	endbr32 
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 1c             	sub    $0x1c,%esp
  8017ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	e8 57 fb ff ff       	call   801353 <fd_lookup>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 4b                	js     80184e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801803:	83 ec 08             	sub    $0x8,%esp
  801806:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801809:	50                   	push   %eax
  80180a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180d:	ff 30                	pushl  (%eax)
  80180f:	e8 93 fb ff ff       	call   8013a7 <dev_lookup>
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 33                	js     80184e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801822:	74 2f                	je     801853 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801824:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801827:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80182e:	00 00 00 
	stat->st_isdir = 0;
  801831:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801838:	00 00 00 
	stat->st_dev = dev;
  80183b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	53                   	push   %ebx
  801845:	ff 75 f0             	pushl  -0x10(%ebp)
  801848:	ff 50 14             	call   *0x14(%eax)
  80184b:	83 c4 10             	add    $0x10,%esp
}
  80184e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801851:	c9                   	leave  
  801852:	c3                   	ret    
		return -E_NOT_SUPP;
  801853:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801858:	eb f4                	jmp    80184e <fstat+0x6c>

0080185a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80185a:	f3 0f 1e fb          	endbr32 
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	6a 00                	push   $0x0
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	e8 fb 01 00 00       	call   801a6b <open>
  801870:	89 c3                	mov    %eax,%ebx
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	85 c0                	test   %eax,%eax
  801877:	78 1b                	js     801894 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801879:	83 ec 08             	sub    $0x8,%esp
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	50                   	push   %eax
  801880:	e8 5d ff ff ff       	call   8017e2 <fstat>
  801885:	89 c6                	mov    %eax,%esi
	close(fd);
  801887:	89 1c 24             	mov    %ebx,(%esp)
  80188a:	e8 fd fb ff ff       	call   80148c <close>
	return r;
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	89 f3                	mov    %esi,%ebx
}
  801894:	89 d8                	mov    %ebx,%eax
  801896:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    

0080189d <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	89 c6                	mov    %eax,%esi
  8018a4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018a6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018ad:	74 27                	je     8018d6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018af:	6a 07                	push   $0x7
  8018b1:	68 00 50 80 00       	push   $0x805000
  8018b6:	56                   	push   %esi
  8018b7:	ff 35 00 40 80 00    	pushl  0x804000
  8018bd:	e8 75 f9 ff ff       	call   801237 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018c2:	83 c4 0c             	add    $0xc,%esp
  8018c5:	6a 00                	push   $0x0
  8018c7:	53                   	push   %ebx
  8018c8:	6a 00                	push   $0x0
  8018ca:	e8 fb f8 ff ff       	call   8011ca <ipc_recv>
}
  8018cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018d6:	83 ec 0c             	sub    $0xc,%esp
  8018d9:	6a 01                	push   $0x1
  8018db:	e8 b1 f9 ff ff       	call   801291 <ipc_find_env>
  8018e0:	a3 00 40 80 00       	mov    %eax,0x804000
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	eb c5                	jmp    8018af <fsipc+0x12>

008018ea <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018ea:	f3 0f 1e fb          	endbr32 
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
  80190c:	b8 02 00 00 00       	mov    $0x2,%eax
  801911:	e8 87 ff ff ff       	call   80189d <fsipc>
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <devfile_flush>:
{
  801918:	f3 0f 1e fb          	endbr32 
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8b 40 0c             	mov    0xc(%eax),%eax
  801928:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80192d:	ba 00 00 00 00       	mov    $0x0,%edx
  801932:	b8 06 00 00 00       	mov    $0x6,%eax
  801937:	e8 61 ff ff ff       	call   80189d <fsipc>
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <devfile_stat>:
{
  80193e:	f3 0f 1e fb          	endbr32 
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	53                   	push   %ebx
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	8b 40 0c             	mov    0xc(%eax),%eax
  801952:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801957:	ba 00 00 00 00       	mov    $0x0,%edx
  80195c:	b8 05 00 00 00       	mov    $0x5,%eax
  801961:	e8 37 ff ff ff       	call   80189d <fsipc>
  801966:	85 c0                	test   %eax,%eax
  801968:	78 2c                	js     801996 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	68 00 50 80 00       	push   $0x805000
  801972:	53                   	push   %ebx
  801973:	e8 df ee ff ff       	call   800857 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801978:	a1 80 50 80 00       	mov    0x805080,%eax
  80197d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801983:	a1 84 50 80 00       	mov    0x805084,%eax
  801988:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <devfile_write>:
{
  80199b:	f3 0f 1e fb          	endbr32 
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 0c             	sub    $0xc,%esp
  8019a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019ad:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019b2:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b8:	8b 52 0c             	mov    0xc(%edx),%edx
  8019bb:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8019c1:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  8019c6:	50                   	push   %eax
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	68 08 50 80 00       	push   $0x805008
  8019cf:	e8 39 f0 ff ff       	call   800a0d <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 04 00 00 00       	mov    $0x4,%eax
  8019de:	e8 ba fe ff ff       	call   80189d <fsipc>
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <devfile_read>:
{
  8019e5:	f3 0f 1e fb          	endbr32 
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	56                   	push   %esi
  8019ed:	53                   	push   %ebx
  8019ee:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019fc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a02:	ba 00 00 00 00       	mov    $0x0,%edx
  801a07:	b8 03 00 00 00       	mov    $0x3,%eax
  801a0c:	e8 8c fe ff ff       	call   80189d <fsipc>
  801a11:	89 c3                	mov    %eax,%ebx
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 1f                	js     801a36 <devfile_read+0x51>
	assert(r <= n);
  801a17:	39 f0                	cmp    %esi,%eax
  801a19:	77 24                	ja     801a3f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a1b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a20:	7f 33                	jg     801a55 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	50                   	push   %eax
  801a26:	68 00 50 80 00       	push   $0x805000
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	e8 da ef ff ff       	call   800a0d <memmove>
	return r;
  801a33:	83 c4 10             	add    $0x10,%esp
}
  801a36:	89 d8                	mov    %ebx,%eax
  801a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    
	assert(r <= n);
  801a3f:	68 18 29 80 00       	push   $0x802918
  801a44:	68 1f 29 80 00       	push   $0x80291f
  801a49:	6a 7d                	push   $0x7d
  801a4b:	68 34 29 80 00       	push   $0x802934
  801a50:	e8 11 e7 ff ff       	call   800166 <_panic>
	assert(r <= PGSIZE);
  801a55:	68 3f 29 80 00       	push   $0x80293f
  801a5a:	68 1f 29 80 00       	push   $0x80291f
  801a5f:	6a 7e                	push   $0x7e
  801a61:	68 34 29 80 00       	push   $0x802934
  801a66:	e8 fb e6 ff ff       	call   800166 <_panic>

00801a6b <open>:
{
  801a6b:	f3 0f 1e fb          	endbr32 
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 1c             	sub    $0x1c,%esp
  801a77:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a7a:	56                   	push   %esi
  801a7b:	e8 94 ed ff ff       	call   800814 <strlen>
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a88:	7f 6c                	jg     801af6 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	e8 67 f8 ff ff       	call   8012fd <fd_alloc>
  801a96:	89 c3                	mov    %eax,%ebx
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 3c                	js     801adb <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a9f:	83 ec 08             	sub    $0x8,%esp
  801aa2:	56                   	push   %esi
  801aa3:	68 00 50 80 00       	push   $0x805000
  801aa8:	e8 aa ed ff ff       	call   800857 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab8:	b8 01 00 00 00       	mov    $0x1,%eax
  801abd:	e8 db fd ff ff       	call   80189d <fsipc>
  801ac2:	89 c3                	mov    %eax,%ebx
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 19                	js     801ae4 <open+0x79>
	return fd2num(fd);
  801acb:	83 ec 0c             	sub    $0xc,%esp
  801ace:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad1:	e8 f8 f7 ff ff       	call   8012ce <fd2num>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
}
  801adb:	89 d8                	mov    %ebx,%eax
  801add:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
		fd_close(fd, 0);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  801aec:	e8 10 f9 ff ff       	call   801401 <fd_close>
		return r;
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	eb e5                	jmp    801adb <open+0x70>
		return -E_BAD_PATH;
  801af6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801afb:	eb de                	jmp    801adb <open+0x70>

00801afd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801afd:	f3 0f 1e fb          	endbr32 
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b07:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b11:	e8 87 fd ff ff       	call   80189d <fsipc>
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b18:	f3 0f 1e fb          	endbr32 
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	56                   	push   %esi
  801b20:	53                   	push   %ebx
  801b21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	e8 b3 f7 ff ff       	call   8012e2 <fd2data>
  801b2f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b31:	83 c4 08             	add    $0x8,%esp
  801b34:	68 4b 29 80 00       	push   $0x80294b
  801b39:	53                   	push   %ebx
  801b3a:	e8 18 ed ff ff       	call   800857 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b3f:	8b 46 04             	mov    0x4(%esi),%eax
  801b42:	2b 06                	sub    (%esi),%eax
  801b44:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b4a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b51:	00 00 00 
	stat->st_dev = &devpipe;
  801b54:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b5b:	30 80 00 
	return 0;
}
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5e                   	pop    %esi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    

00801b6a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b6a:	f3 0f 1e fb          	endbr32 
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 0c             	sub    $0xc,%esp
  801b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b78:	53                   	push   %ebx
  801b79:	6a 00                	push   $0x0
  801b7b:	e8 a6 f1 ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b80:	89 1c 24             	mov    %ebx,(%esp)
  801b83:	e8 5a f7 ff ff       	call   8012e2 <fd2data>
  801b88:	83 c4 08             	add    $0x8,%esp
  801b8b:	50                   	push   %eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	e8 93 f1 ff ff       	call   800d26 <sys_page_unmap>
}
  801b93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <_pipeisclosed>:
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	57                   	push   %edi
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
  801b9e:	83 ec 1c             	sub    $0x1c,%esp
  801ba1:	89 c7                	mov    %eax,%edi
  801ba3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ba5:	a1 04 40 80 00       	mov    0x804004,%eax
  801baa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	57                   	push   %edi
  801bb1:	e8 fd 04 00 00       	call   8020b3 <pageref>
  801bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bb9:	89 34 24             	mov    %esi,(%esp)
  801bbc:	e8 f2 04 00 00       	call   8020b3 <pageref>
		nn = thisenv->env_runs;
  801bc1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bc7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	39 cb                	cmp    %ecx,%ebx
  801bcf:	74 1b                	je     801bec <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bd1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bd4:	75 cf                	jne    801ba5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bd6:	8b 42 58             	mov    0x58(%edx),%eax
  801bd9:	6a 01                	push   $0x1
  801bdb:	50                   	push   %eax
  801bdc:	53                   	push   %ebx
  801bdd:	68 52 29 80 00       	push   $0x802952
  801be2:	e8 66 e6 ff ff       	call   80024d <cprintf>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	eb b9                	jmp    801ba5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bef:	0f 94 c0             	sete   %al
  801bf2:	0f b6 c0             	movzbl %al,%eax
}
  801bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    

00801bfd <devpipe_write>:
{
  801bfd:	f3 0f 1e fb          	endbr32 
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	57                   	push   %edi
  801c05:	56                   	push   %esi
  801c06:	53                   	push   %ebx
  801c07:	83 ec 28             	sub    $0x28,%esp
  801c0a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c0d:	56                   	push   %esi
  801c0e:	e8 cf f6 ff ff       	call   8012e2 <fd2data>
  801c13:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c20:	74 4f                	je     801c71 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c22:	8b 43 04             	mov    0x4(%ebx),%eax
  801c25:	8b 0b                	mov    (%ebx),%ecx
  801c27:	8d 51 20             	lea    0x20(%ecx),%edx
  801c2a:	39 d0                	cmp    %edx,%eax
  801c2c:	72 14                	jb     801c42 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c2e:	89 da                	mov    %ebx,%edx
  801c30:	89 f0                	mov    %esi,%eax
  801c32:	e8 61 ff ff ff       	call   801b98 <_pipeisclosed>
  801c37:	85 c0                	test   %eax,%eax
  801c39:	75 3b                	jne    801c76 <devpipe_write+0x79>
			sys_yield();
  801c3b:	e8 36 f0 ff ff       	call   800c76 <sys_yield>
  801c40:	eb e0                	jmp    801c22 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c45:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c49:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c4c:	89 c2                	mov    %eax,%edx
  801c4e:	c1 fa 1f             	sar    $0x1f,%edx
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	c1 e9 1b             	shr    $0x1b,%ecx
  801c56:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c59:	83 e2 1f             	and    $0x1f,%edx
  801c5c:	29 ca                	sub    %ecx,%edx
  801c5e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c62:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c66:	83 c0 01             	add    $0x1,%eax
  801c69:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c6c:	83 c7 01             	add    $0x1,%edi
  801c6f:	eb ac                	jmp    801c1d <devpipe_write+0x20>
	return i;
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	eb 05                	jmp    801c7b <devpipe_write+0x7e>
				return 0;
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5f                   	pop    %edi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    

00801c83 <devpipe_read>:
{
  801c83:	f3 0f 1e fb          	endbr32 
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	57                   	push   %edi
  801c8b:	56                   	push   %esi
  801c8c:	53                   	push   %ebx
  801c8d:	83 ec 18             	sub    $0x18,%esp
  801c90:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c93:	57                   	push   %edi
  801c94:	e8 49 f6 ff ff       	call   8012e2 <fd2data>
  801c99:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	be 00 00 00 00       	mov    $0x0,%esi
  801ca3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ca6:	75 14                	jne    801cbc <devpipe_read+0x39>
	return i;
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	eb 02                	jmp    801caf <devpipe_read+0x2c>
				return i;
  801cad:	89 f0                	mov    %esi,%eax
}
  801caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
			sys_yield();
  801cb7:	e8 ba ef ff ff       	call   800c76 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cbc:	8b 03                	mov    (%ebx),%eax
  801cbe:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cc1:	75 18                	jne    801cdb <devpipe_read+0x58>
			if (i > 0)
  801cc3:	85 f6                	test   %esi,%esi
  801cc5:	75 e6                	jne    801cad <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801cc7:	89 da                	mov    %ebx,%edx
  801cc9:	89 f8                	mov    %edi,%eax
  801ccb:	e8 c8 fe ff ff       	call   801b98 <_pipeisclosed>
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 e3                	je     801cb7 <devpipe_read+0x34>
				return 0;
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd9:	eb d4                	jmp    801caf <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cdb:	99                   	cltd   
  801cdc:	c1 ea 1b             	shr    $0x1b,%edx
  801cdf:	01 d0                	add    %edx,%eax
  801ce1:	83 e0 1f             	and    $0x1f,%eax
  801ce4:	29 d0                	sub    %edx,%eax
  801ce6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cee:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cf1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cf4:	83 c6 01             	add    $0x1,%esi
  801cf7:	eb aa                	jmp    801ca3 <devpipe_read+0x20>

00801cf9 <pipe>:
{
  801cf9:	f3 0f 1e fb          	endbr32 
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
  801d02:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d08:	50                   	push   %eax
  801d09:	e8 ef f5 ff ff       	call   8012fd <fd_alloc>
  801d0e:	89 c3                	mov    %eax,%ebx
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	85 c0                	test   %eax,%eax
  801d15:	0f 88 23 01 00 00    	js     801e3e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	68 07 04 00 00       	push   $0x407
  801d23:	ff 75 f4             	pushl  -0xc(%ebp)
  801d26:	6a 00                	push   $0x0
  801d28:	e8 6c ef ff ff       	call   800c99 <sys_page_alloc>
  801d2d:	89 c3                	mov    %eax,%ebx
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	0f 88 04 01 00 00    	js     801e3e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d3a:	83 ec 0c             	sub    $0xc,%esp
  801d3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d40:	50                   	push   %eax
  801d41:	e8 b7 f5 ff ff       	call   8012fd <fd_alloc>
  801d46:	89 c3                	mov    %eax,%ebx
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	0f 88 db 00 00 00    	js     801e2e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	68 07 04 00 00       	push   $0x407
  801d5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d5e:	6a 00                	push   $0x0
  801d60:	e8 34 ef ff ff       	call   800c99 <sys_page_alloc>
  801d65:	89 c3                	mov    %eax,%ebx
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	0f 88 bc 00 00 00    	js     801e2e <pipe+0x135>
	va = fd2data(fd0);
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	ff 75 f4             	pushl  -0xc(%ebp)
  801d78:	e8 65 f5 ff ff       	call   8012e2 <fd2data>
  801d7d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7f:	83 c4 0c             	add    $0xc,%esp
  801d82:	68 07 04 00 00       	push   $0x407
  801d87:	50                   	push   %eax
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 0a ef ff ff       	call   800c99 <sys_page_alloc>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	85 c0                	test   %eax,%eax
  801d96:	0f 88 82 00 00 00    	js     801e1e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	ff 75 f0             	pushl  -0x10(%ebp)
  801da2:	e8 3b f5 ff ff       	call   8012e2 <fd2data>
  801da7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dae:	50                   	push   %eax
  801daf:	6a 00                	push   $0x0
  801db1:	56                   	push   %esi
  801db2:	6a 00                	push   $0x0
  801db4:	e8 27 ef ff ff       	call   800ce0 <sys_page_map>
  801db9:	89 c3                	mov    %eax,%ebx
  801dbb:	83 c4 20             	add    $0x20,%esp
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 4e                	js     801e10 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801dc2:	a1 20 30 80 00       	mov    0x803020,%eax
  801dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dca:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dde:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	ff 75 f4             	pushl  -0xc(%ebp)
  801deb:	e8 de f4 ff ff       	call   8012ce <fd2num>
  801df0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801df5:	83 c4 04             	add    $0x4,%esp
  801df8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfb:	e8 ce f4 ff ff       	call   8012ce <fd2num>
  801e00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e03:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e0e:	eb 2e                	jmp    801e3e <pipe+0x145>
	sys_page_unmap(0, va);
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	56                   	push   %esi
  801e14:	6a 00                	push   $0x0
  801e16:	e8 0b ef ff ff       	call   800d26 <sys_page_unmap>
  801e1b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e1e:	83 ec 08             	sub    $0x8,%esp
  801e21:	ff 75 f0             	pushl  -0x10(%ebp)
  801e24:	6a 00                	push   $0x0
  801e26:	e8 fb ee ff ff       	call   800d26 <sys_page_unmap>
  801e2b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e2e:	83 ec 08             	sub    $0x8,%esp
  801e31:	ff 75 f4             	pushl  -0xc(%ebp)
  801e34:	6a 00                	push   $0x0
  801e36:	e8 eb ee ff ff       	call   800d26 <sys_page_unmap>
  801e3b:	83 c4 10             	add    $0x10,%esp
}
  801e3e:	89 d8                	mov    %ebx,%eax
  801e40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5d                   	pop    %ebp
  801e46:	c3                   	ret    

00801e47 <pipeisclosed>:
{
  801e47:	f3 0f 1e fb          	endbr32 
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e54:	50                   	push   %eax
  801e55:	ff 75 08             	pushl  0x8(%ebp)
  801e58:	e8 f6 f4 ff ff       	call   801353 <fd_lookup>
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 18                	js     801e7c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6a:	e8 73 f4 ff ff       	call   8012e2 <fd2data>
  801e6f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e74:	e8 1f fd ff ff       	call   801b98 <_pipeisclosed>
  801e79:	83 c4 10             	add    $0x10,%esp
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e7e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
  801e87:	c3                   	ret    

00801e88 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e88:	f3 0f 1e fb          	endbr32 
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e92:	68 6a 29 80 00       	push   $0x80296a
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	e8 b8 e9 ff ff       	call   800857 <strcpy>
	return 0;
}
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <devcons_write>:
{
  801ea6:	f3 0f 1e fb          	endbr32 
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	57                   	push   %edi
  801eae:	56                   	push   %esi
  801eaf:	53                   	push   %ebx
  801eb0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801eb6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ebb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ec1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ec4:	73 31                	jae    801ef7 <devcons_write+0x51>
		m = n - tot;
  801ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ec9:	29 f3                	sub    %esi,%ebx
  801ecb:	83 fb 7f             	cmp    $0x7f,%ebx
  801ece:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ed3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ed6:	83 ec 04             	sub    $0x4,%esp
  801ed9:	53                   	push   %ebx
  801eda:	89 f0                	mov    %esi,%eax
  801edc:	03 45 0c             	add    0xc(%ebp),%eax
  801edf:	50                   	push   %eax
  801ee0:	57                   	push   %edi
  801ee1:	e8 27 eb ff ff       	call   800a0d <memmove>
		sys_cputs(buf, m);
  801ee6:	83 c4 08             	add    $0x8,%esp
  801ee9:	53                   	push   %ebx
  801eea:	57                   	push   %edi
  801eeb:	e8 d9 ec ff ff       	call   800bc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ef0:	01 de                	add    %ebx,%esi
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	eb ca                	jmp    801ec1 <devcons_write+0x1b>
}
  801ef7:	89 f0                	mov    %esi,%eax
  801ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5f                   	pop    %edi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <devcons_read>:
{
  801f01:	f3 0f 1e fb          	endbr32 
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 08             	sub    $0x8,%esp
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f14:	74 21                	je     801f37 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f16:	e8 d0 ec ff ff       	call   800beb <sys_cgetc>
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	75 07                	jne    801f26 <devcons_read+0x25>
		sys_yield();
  801f1f:	e8 52 ed ff ff       	call   800c76 <sys_yield>
  801f24:	eb f0                	jmp    801f16 <devcons_read+0x15>
	if (c < 0)
  801f26:	78 0f                	js     801f37 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f28:	83 f8 04             	cmp    $0x4,%eax
  801f2b:	74 0c                	je     801f39 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f30:	88 02                	mov    %al,(%edx)
	return 1;
  801f32:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    
		return 0;
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	eb f7                	jmp    801f37 <devcons_read+0x36>

00801f40 <cputchar>:
{
  801f40:	f3 0f 1e fb          	endbr32 
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f50:	6a 01                	push   $0x1
  801f52:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f55:	50                   	push   %eax
  801f56:	e8 6e ec ff ff       	call   800bc9 <sys_cputs>
}
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <getchar>:
{
  801f60:	f3 0f 1e fb          	endbr32 
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f6a:	6a 01                	push   $0x1
  801f6c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f6f:	50                   	push   %eax
  801f70:	6a 00                	push   $0x0
  801f72:	e8 5f f6 ff ff       	call   8015d6 <read>
	if (r < 0)
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 06                	js     801f84 <getchar+0x24>
	if (r < 1)
  801f7e:	74 06                	je     801f86 <getchar+0x26>
	return c;
  801f80:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    
		return -E_EOF;
  801f86:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f8b:	eb f7                	jmp    801f84 <getchar+0x24>

00801f8d <iscons>:
{
  801f8d:	f3 0f 1e fb          	endbr32 
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9a:	50                   	push   %eax
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	e8 b0 f3 ff ff       	call   801353 <fd_lookup>
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	78 11                	js     801fbb <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fb3:	39 10                	cmp    %edx,(%eax)
  801fb5:	0f 94 c0             	sete   %al
  801fb8:	0f b6 c0             	movzbl %al,%eax
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <opencons>:
{
  801fbd:	f3 0f 1e fb          	endbr32 
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fca:	50                   	push   %eax
  801fcb:	e8 2d f3 ff ff       	call   8012fd <fd_alloc>
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 3a                	js     802011 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	68 07 04 00 00       	push   $0x407
  801fdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe2:	6a 00                	push   $0x0
  801fe4:	e8 b0 ec ff ff       	call   800c99 <sys_page_alloc>
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 21                	js     802011 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ff9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	50                   	push   %eax
  802009:	e8 c0 f2 ff ff       	call   8012ce <fd2num>
  80200e:	83 c4 10             	add    $0x10,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802013:	f3 0f 1e fb          	endbr32 
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	53                   	push   %ebx
  80201b:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  80201e:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802025:	74 0d                	je     802034 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80202f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802032:	c9                   	leave  
  802033:	c3                   	ret    
		envid_t envid=sys_getenvid();
  802034:	e8 1a ec ff ff       	call   800c53 <sys_getenvid>
  802039:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	6a 07                	push   $0x7
  802040:	68 00 f0 bf ee       	push   $0xeebff000
  802045:	50                   	push   %eax
  802046:	e8 4e ec ff ff       	call   800c99 <sys_page_alloc>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 29                	js     80207b <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802052:	83 ec 08             	sub    $0x8,%esp
  802055:	68 8f 20 80 00       	push   $0x80208f
  80205a:	53                   	push   %ebx
  80205b:	e8 98 ed ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	85 c0                	test   %eax,%eax
  802065:	79 c0                	jns    802027 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	68 a4 29 80 00       	push   $0x8029a4
  80206f:	6a 24                	push   $0x24
  802071:	68 db 29 80 00       	push   $0x8029db
  802076:	e8 eb e0 ff ff       	call   800166 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	68 78 29 80 00       	push   $0x802978
  802083:	6a 22                	push   $0x22
  802085:	68 db 29 80 00       	push   $0x8029db
  80208a:	e8 d7 e0 ff ff       	call   800166 <_panic>

0080208f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80208f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802090:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802095:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802097:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  80209a:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  80209d:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8020a1:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8020a6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8020aa:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8020ac:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8020ad:	83 c4 04             	add    $0x4,%esp
	popfl
  8020b0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020b1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8020b2:	c3                   	ret    

008020b3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020b3:	f3 0f 1e fb          	endbr32 
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020bd:	89 c2                	mov    %eax,%edx
  8020bf:	c1 ea 16             	shr    $0x16,%edx
  8020c2:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8020c9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8020ce:	f6 c1 01             	test   $0x1,%cl
  8020d1:	74 1c                	je     8020ef <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8020d3:	c1 e8 0c             	shr    $0xc,%eax
  8020d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020dd:	a8 01                	test   $0x1,%al
  8020df:	74 0e                	je     8020ef <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020e1:	c1 e8 0c             	shr    $0xc,%eax
  8020e4:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8020eb:	ef 
  8020ec:	0f b7 d2             	movzwl %dx,%edx
}
  8020ef:	89 d0                	mov    %edx,%eax
  8020f1:	5d                   	pop    %ebp
  8020f2:	c3                   	ret    
  8020f3:	66 90                	xchg   %ax,%ax
  8020f5:	66 90                	xchg   %ax,%ax
  8020f7:	66 90                	xchg   %ax,%ax
  8020f9:	66 90                	xchg   %ax,%ax
  8020fb:	66 90                	xchg   %ax,%ax
  8020fd:	66 90                	xchg   %ax,%ax
  8020ff:	90                   	nop

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
