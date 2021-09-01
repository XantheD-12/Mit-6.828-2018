
obj/user/sendpage.debug：     文件格式 elf32-i386


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
  80002c:	e8 77 01 00 00       	call   8001a8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  80003d:	e8 ab 0f 00 00       	call   800fed <fork>
  800042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 84 a5 00 00 00    	je     8000f2 <umain+0xbf>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80004d:	a1 04 40 80 00       	mov    0x804004,%eax
  800052:	8b 40 48             	mov    0x48(%eax),%eax
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 a0 00       	push   $0xa00000
  80005f:	50                   	push   %eax
  800060:	e8 94 0c 00 00       	call   800cf9 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800065:	83 c4 04             	add    $0x4,%esp
  800068:	ff 35 04 30 80 00    	pushl  0x803004
  80006e:	e8 01 08 00 00       	call   800874 <strlen>
  800073:	83 c4 0c             	add    $0xc,%esp
  800076:	83 c0 01             	add    $0x1,%eax
  800079:	50                   	push   %eax
  80007a:	ff 35 04 30 80 00    	pushl  0x803004
  800080:	68 00 00 a0 00       	push   $0xa00000
  800085:	e8 49 0a 00 00       	call   800ad3 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80008a:	6a 07                	push   $0x7
  80008c:	68 00 00 a0 00       	push   $0xa00000
  800091:	6a 00                	push   $0x0
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 fc 11 00 00       	call   801297 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80009b:	83 c4 1c             	add    $0x1c,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	68 00 00 a0 00       	push   $0xa00000
  8000a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	e8 7c 11 00 00       	call   80122a <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000ae:	83 c4 0c             	add    $0xc,%esp
  8000b1:	68 00 00 a0 00       	push   $0xa00000
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 00 24 80 00       	push   $0x802400
  8000be:	e8 ea 01 00 00       	call   8002ad <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000c3:	83 c4 04             	add    $0x4,%esp
  8000c6:	ff 35 00 30 80 00    	pushl  0x803000
  8000cc:	e8 a3 07 00 00       	call   800874 <strlen>
  8000d1:	83 c4 0c             	add    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	68 00 00 a0 00       	push   $0xa00000
  8000e0:	e8 bb 08 00 00       	call   8009a0 <strncmp>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	0f 84 a3 00 00 00    	je     800193 <umain+0x160>
		cprintf("parent received correct message\n");
	return;
}
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	68 00 00 b0 00       	push   $0xb00000
  8000fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ff:	50                   	push   %eax
  800100:	e8 25 11 00 00       	call   80122a <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	68 00 00 b0 00       	push   $0xb00000
  80010d:	ff 75 f4             	pushl  -0xc(%ebp)
  800110:	68 00 24 80 00       	push   $0x802400
  800115:	e8 93 01 00 00       	call   8002ad <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80011a:	83 c4 04             	add    $0x4,%esp
  80011d:	ff 35 04 30 80 00    	pushl  0x803004
  800123:	e8 4c 07 00 00       	call   800874 <strlen>
  800128:	83 c4 0c             	add    $0xc,%esp
  80012b:	50                   	push   %eax
  80012c:	ff 35 04 30 80 00    	pushl  0x803004
  800132:	68 00 00 b0 00       	push   $0xb00000
  800137:	e8 64 08 00 00       	call   8009a0 <strncmp>
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 3e                	je     800181 <umain+0x14e>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 35 00 30 80 00    	pushl  0x803000
  80014c:	e8 23 07 00 00       	call   800874 <strlen>
  800151:	83 c4 0c             	add    $0xc,%esp
  800154:	83 c0 01             	add    $0x1,%eax
  800157:	50                   	push   %eax
  800158:	ff 35 00 30 80 00    	pushl  0x803000
  80015e:	68 00 00 b0 00       	push   $0xb00000
  800163:	e8 6b 09 00 00       	call   800ad3 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800168:	6a 07                	push   $0x7
  80016a:	68 00 00 b0 00       	push   $0xb00000
  80016f:	6a 00                	push   $0x0
  800171:	ff 75 f4             	pushl  -0xc(%ebp)
  800174:	e8 1e 11 00 00       	call   801297 <ipc_send>
		return;
  800179:	83 c4 20             	add    $0x20,%esp
  80017c:	e9 6f ff ff ff       	jmp    8000f0 <umain+0xbd>
			cprintf("child received correct message\n");
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	68 14 24 80 00       	push   $0x802414
  800189:	e8 1f 01 00 00       	call   8002ad <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	eb b0                	jmp    800143 <umain+0x110>
		cprintf("parent received correct message\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 34 24 80 00       	push   $0x802434
  80019b:	e8 0d 01 00 00       	call   8002ad <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	e9 48 ff ff ff       	jmp    8000f0 <umain+0xbd>

008001a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a8:	f3 0f 1e fb          	endbr32 
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001b7:	e8 f7 0a 00 00       	call   800cb3 <sys_getenvid>
  8001bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c9:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ce:	85 db                	test   %ebx,%ebx
  8001d0:	7e 07                	jle    8001d9 <libmain+0x31>
		binaryname = argv[0];
  8001d2:	8b 06                	mov    (%esi),%eax
  8001d4:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
  8001de:	e8 50 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001e3:	e8 0a 00 00 00       	call   8001f2 <exit>
}
  8001e8:	83 c4 10             	add    $0x10,%esp
  8001eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    

008001f2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001fc:	e8 1c 13 00 00       	call   80151d <close_all>
	sys_env_destroy(0);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	6a 00                	push   $0x0
  800206:	e8 63 0a 00 00       	call   800c6e <sys_env_destroy>
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	53                   	push   %ebx
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021e:	8b 13                	mov    (%ebx),%edx
  800220:	8d 42 01             	lea    0x1(%edx),%eax
  800223:	89 03                	mov    %eax,(%ebx)
  800225:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800228:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80022c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800231:	74 09                	je     80023c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800233:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	68 ff 00 00 00       	push   $0xff
  800244:	8d 43 08             	lea    0x8(%ebx),%eax
  800247:	50                   	push   %eax
  800248:	e8 dc 09 00 00       	call   800c29 <sys_cputs>
		b->idx = 0;
  80024d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	eb db                	jmp    800233 <putch+0x23>

00800258 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800258:	f3 0f 1e fb          	endbr32 
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800265:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026c:	00 00 00 
	b.cnt = 0;
  80026f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800276:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	68 10 02 80 00       	push   $0x800210
  80028b:	e8 20 01 00 00       	call   8003b0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800290:	83 c4 08             	add    $0x8,%esp
  800293:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800299:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 84 09 00 00       	call   800c29 <sys_cputs>

	return b.cnt;
}
  8002a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	e8 95 ff ff ff       	call   800258 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 1c             	sub    $0x1c,%esp
  8002ce:	89 c7                	mov    %eax,%edi
  8002d0:	89 d6                	mov    %edx,%esi
  8002d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d8:	89 d1                	mov    %edx,%ecx
  8002da:	89 c2                	mov    %eax,%edx
  8002dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f2:	39 c2                	cmp    %eax,%edx
  8002f4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002f7:	72 3e                	jb     800337 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 18             	pushl  0x18(%ebp)
  8002ff:	83 eb 01             	sub    $0x1,%ebx
  800302:	53                   	push   %ebx
  800303:	50                   	push   %eax
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030a:	ff 75 e0             	pushl  -0x20(%ebp)
  80030d:	ff 75 dc             	pushl  -0x24(%ebp)
  800310:	ff 75 d8             	pushl  -0x28(%ebp)
  800313:	e8 88 1e 00 00       	call   8021a0 <__udivdi3>
  800318:	83 c4 18             	add    $0x18,%esp
  80031b:	52                   	push   %edx
  80031c:	50                   	push   %eax
  80031d:	89 f2                	mov    %esi,%edx
  80031f:	89 f8                	mov    %edi,%eax
  800321:	e8 9f ff ff ff       	call   8002c5 <printnum>
  800326:	83 c4 20             	add    $0x20,%esp
  800329:	eb 13                	jmp    80033e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	56                   	push   %esi
  80032f:	ff 75 18             	pushl  0x18(%ebp)
  800332:	ff d7                	call   *%edi
  800334:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800337:	83 eb 01             	sub    $0x1,%ebx
  80033a:	85 db                	test   %ebx,%ebx
  80033c:	7f ed                	jg     80032b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	56                   	push   %esi
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	ff 75 dc             	pushl  -0x24(%ebp)
  80034e:	ff 75 d8             	pushl  -0x28(%ebp)
  800351:	e8 5a 1f 00 00       	call   8022b0 <__umoddi3>
  800356:	83 c4 14             	add    $0x14,%esp
  800359:	0f be 80 ac 24 80 00 	movsbl 0x8024ac(%eax),%eax
  800360:	50                   	push   %eax
  800361:	ff d7                	call   *%edi
}
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5f                   	pop    %edi
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036e:	f3 0f 1e fb          	endbr32 
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800378:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037c:	8b 10                	mov    (%eax),%edx
  80037e:	3b 50 04             	cmp    0x4(%eax),%edx
  800381:	73 0a                	jae    80038d <sprintputch+0x1f>
		*b->buf++ = ch;
  800383:	8d 4a 01             	lea    0x1(%edx),%ecx
  800386:	89 08                	mov    %ecx,(%eax)
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	88 02                	mov    %al,(%edx)
}
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    

0080038f <printfmt>:
{
  80038f:	f3 0f 1e fb          	endbr32 
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800399:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039c:	50                   	push   %eax
  80039d:	ff 75 10             	pushl  0x10(%ebp)
  8003a0:	ff 75 0c             	pushl  0xc(%ebp)
  8003a3:	ff 75 08             	pushl  0x8(%ebp)
  8003a6:	e8 05 00 00 00       	call   8003b0 <vprintfmt>
}
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <vprintfmt>:
{
  8003b0:	f3 0f 1e fb          	endbr32 
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 3c             	sub    $0x3c,%esp
  8003bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c6:	e9 8e 03 00 00       	jmp    800759 <vprintfmt+0x3a9>
		padc = ' ';
  8003cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8d 47 01             	lea    0x1(%edi),%eax
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ef:	0f b6 17             	movzbl (%edi),%edx
  8003f2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f5:	3c 55                	cmp    $0x55,%al
  8003f7:	0f 87 df 03 00 00    	ja     8007dc <vprintfmt+0x42c>
  8003fd:	0f b6 c0             	movzbl %al,%eax
  800400:	3e ff 24 85 e0 25 80 	notrack jmp *0x8025e0(,%eax,4)
  800407:	00 
  800408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80040f:	eb d8                	jmp    8003e9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800414:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800418:	eb cf                	jmp    8003e9 <vprintfmt+0x39>
  80041a:	0f b6 d2             	movzbl %dl,%edx
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800428:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80042f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800432:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800435:	83 f9 09             	cmp    $0x9,%ecx
  800438:	77 55                	ja     80048f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80043a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043d:	eb e9                	jmp    800428 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 40 04             	lea    0x4(%eax),%eax
  80044d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800453:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800457:	79 90                	jns    8003e9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800466:	eb 81                	jmp    8003e9 <vprintfmt+0x39>
  800468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	ba 00 00 00 00       	mov    $0x0,%edx
  800472:	0f 49 d0             	cmovns %eax,%edx
  800475:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047b:	e9 69 ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800480:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800483:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80048a:	e9 5a ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
  80048f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800495:	eb bc                	jmp    800453 <vprintfmt+0xa3>
			lflag++;
  800497:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049d:	e9 47 ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 78 04             	lea    0x4(%eax),%edi
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	ff 30                	pushl  (%eax)
  8004ae:	ff d6                	call   *%esi
			break;
  8004b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b6:	e9 9b 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	99                   	cltd   
  8004c4:	31 d0                	xor    %edx,%eax
  8004c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c8:	83 f8 0f             	cmp    $0xf,%eax
  8004cb:	7f 23                	jg     8004f0 <vprintfmt+0x140>
  8004cd:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	74 18                	je     8004f0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004d8:	52                   	push   %edx
  8004d9:	68 11 2a 80 00       	push   $0x802a11
  8004de:	53                   	push   %ebx
  8004df:	56                   	push   %esi
  8004e0:	e8 aa fe ff ff       	call   80038f <printfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004eb:	e9 66 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004f0:	50                   	push   %eax
  8004f1:	68 c4 24 80 00       	push   $0x8024c4
  8004f6:	53                   	push   %ebx
  8004f7:	56                   	push   %esi
  8004f8:	e8 92 fe ff ff       	call   80038f <printfmt>
  8004fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800500:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800503:	e9 4e 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	83 c0 04             	add    $0x4,%eax
  80050e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800516:	85 d2                	test   %edx,%edx
  800518:	b8 bd 24 80 00       	mov    $0x8024bd,%eax
  80051d:	0f 45 c2             	cmovne %edx,%eax
  800520:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800523:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800527:	7e 06                	jle    80052f <vprintfmt+0x17f>
  800529:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80052d:	75 0d                	jne    80053c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800532:	89 c7                	mov    %eax,%edi
  800534:	03 45 e0             	add    -0x20(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	eb 55                	jmp    800591 <vprintfmt+0x1e1>
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 d8             	pushl  -0x28(%ebp)
  800542:	ff 75 cc             	pushl  -0x34(%ebp)
  800545:	e8 46 03 00 00       	call   800890 <strnlen>
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800557:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80055b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055e:	85 ff                	test   %edi,%edi
  800560:	7e 11                	jle    800573 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	53                   	push   %ebx
  800566:	ff 75 e0             	pushl  -0x20(%ebp)
  800569:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056b:	83 ef 01             	sub    $0x1,%edi
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	eb eb                	jmp    80055e <vprintfmt+0x1ae>
  800573:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800576:	85 d2                	test   %edx,%edx
  800578:	b8 00 00 00 00       	mov    $0x0,%eax
  80057d:	0f 49 c2             	cmovns %edx,%eax
  800580:	29 c2                	sub    %eax,%edx
  800582:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800585:	eb a8                	jmp    80052f <vprintfmt+0x17f>
					putch(ch, putdat);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	52                   	push   %edx
  80058c:	ff d6                	call   *%esi
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800594:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800596:	83 c7 01             	add    $0x1,%edi
  800599:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059d:	0f be d0             	movsbl %al,%edx
  8005a0:	85 d2                	test   %edx,%edx
  8005a2:	74 4b                	je     8005ef <vprintfmt+0x23f>
  8005a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a8:	78 06                	js     8005b0 <vprintfmt+0x200>
  8005aa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ae:	78 1e                	js     8005ce <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b4:	74 d1                	je     800587 <vprintfmt+0x1d7>
  8005b6:	0f be c0             	movsbl %al,%eax
  8005b9:	83 e8 20             	sub    $0x20,%eax
  8005bc:	83 f8 5e             	cmp    $0x5e,%eax
  8005bf:	76 c6                	jbe    800587 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 3f                	push   $0x3f
  8005c7:	ff d6                	call   *%esi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	eb c3                	jmp    800591 <vprintfmt+0x1e1>
  8005ce:	89 cf                	mov    %ecx,%edi
  8005d0:	eb 0e                	jmp    8005e0 <vprintfmt+0x230>
				putch(' ', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 20                	push   $0x20
  8005d8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005da:	83 ef 01             	sub    $0x1,%edi
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	85 ff                	test   %edi,%edi
  8005e2:	7f ee                	jg     8005d2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ea:	e9 67 01 00 00       	jmp    800756 <vprintfmt+0x3a6>
  8005ef:	89 cf                	mov    %ecx,%edi
  8005f1:	eb ed                	jmp    8005e0 <vprintfmt+0x230>
	if (lflag >= 2)
  8005f3:	83 f9 01             	cmp    $0x1,%ecx
  8005f6:	7f 1b                	jg     800613 <vprintfmt+0x263>
	else if (lflag)
  8005f8:	85 c9                	test   %ecx,%ecx
  8005fa:	74 63                	je     80065f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	99                   	cltd   
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	eb 17                	jmp    80062a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 08             	lea    0x8(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80062d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800635:	85 c9                	test   %ecx,%ecx
  800637:	0f 89 ff 00 00 00    	jns    80073c <vprintfmt+0x38c>
				putch('-', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 2d                	push   $0x2d
  800643:	ff d6                	call   *%esi
				num = -(long long) num;
  800645:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800648:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80064b:	f7 da                	neg    %edx
  80064d:	83 d1 00             	adc    $0x0,%ecx
  800650:	f7 d9                	neg    %ecx
  800652:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065a:	e9 dd 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	99                   	cltd   
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb b4                	jmp    80062a <vprintfmt+0x27a>
	if (lflag >= 2)
  800676:	83 f9 01             	cmp    $0x1,%ecx
  800679:	7f 1e                	jg     800699 <vprintfmt+0x2e9>
	else if (lflag)
  80067b:	85 c9                	test   %ecx,%ecx
  80067d:	74 32                	je     8006b1 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800694:	e9 a3 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 10                	mov    (%eax),%edx
  80069e:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a1:	8d 40 08             	lea    0x8(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006ac:	e9 8b 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 10                	mov    (%eax),%edx
  8006b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bb:	8d 40 04             	lea    0x4(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006c6:	eb 74                	jmp    80073c <vprintfmt+0x38c>
	if (lflag >= 2)
  8006c8:	83 f9 01             	cmp    $0x1,%ecx
  8006cb:	7f 1b                	jg     8006e8 <vprintfmt+0x338>
	else if (lflag)
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	74 2c                	je     8006fd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8006e1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006e6:	eb 54                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f0:	8d 40 08             	lea    0x8(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8006f6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006fb:	eb 3f                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800712:	eb 28                	jmp    80073c <vprintfmt+0x38c>
			putch('0', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 30                	push   $0x30
  80071a:	ff d6                	call   *%esi
			putch('x', putdat);
  80071c:	83 c4 08             	add    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 78                	push   $0x78
  800722:	ff d6                	call   *%esi
			num = (unsigned long long)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80072e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80073c:	83 ec 0c             	sub    $0xc,%esp
  80073f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800743:	57                   	push   %edi
  800744:	ff 75 e0             	pushl  -0x20(%ebp)
  800747:	50                   	push   %eax
  800748:	51                   	push   %ecx
  800749:	52                   	push   %edx
  80074a:	89 da                	mov    %ebx,%edx
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	e8 72 fb ff ff       	call   8002c5 <printnum>
			break;
  800753:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800756:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	83 c7 01             	add    $0x1,%edi
  80075c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800760:	83 f8 25             	cmp    $0x25,%eax
  800763:	0f 84 62 fc ff ff    	je     8003cb <vprintfmt+0x1b>
			if (ch == '\0')
  800769:	85 c0                	test   %eax,%eax
  80076b:	0f 84 8b 00 00 00    	je     8007fc <vprintfmt+0x44c>
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	50                   	push   %eax
  800776:	ff d6                	call   *%esi
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb dc                	jmp    800759 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80077d:	83 f9 01             	cmp    $0x1,%ecx
  800780:	7f 1b                	jg     80079d <vprintfmt+0x3ed>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	74 2c                	je     8007b2 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80079b:	eb 9f                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a5:	8d 40 08             	lea    0x8(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007b0:	eb 8a                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007c7:	e9 70 ff ff ff       	jmp    80073c <vprintfmt+0x38c>
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 25                	push   $0x25
  8007d2:	ff d6                	call   *%esi
			break;
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	e9 7a ff ff ff       	jmp    800756 <vprintfmt+0x3a6>
			putch('%', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	6a 25                	push   $0x25
  8007e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	89 f8                	mov    %edi,%eax
  8007e9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ed:	74 05                	je     8007f4 <vprintfmt+0x444>
  8007ef:	83 e8 01             	sub    $0x1,%eax
  8007f2:	eb f5                	jmp    8007e9 <vprintfmt+0x439>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	e9 5a ff ff ff       	jmp    800756 <vprintfmt+0x3a6>
}
  8007fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5f                   	pop    %edi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800804:	f3 0f 1e fb          	endbr32 
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 18             	sub    $0x18,%esp
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800814:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800817:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800825:	85 c0                	test   %eax,%eax
  800827:	74 26                	je     80084f <vsnprintf+0x4b>
  800829:	85 d2                	test   %edx,%edx
  80082b:	7e 22                	jle    80084f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082d:	ff 75 14             	pushl  0x14(%ebp)
  800830:	ff 75 10             	pushl  0x10(%ebp)
  800833:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	68 6e 03 80 00       	push   $0x80036e
  80083c:	e8 6f fb ff ff       	call   8003b0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800844:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084a:	83 c4 10             	add    $0x10,%esp
}
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    
		return -E_INVAL;
  80084f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800854:	eb f7                	jmp    80084d <vsnprintf+0x49>

00800856 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800863:	50                   	push   %eax
  800864:	ff 75 10             	pushl  0x10(%ebp)
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 92 ff ff ff       	call   800804 <vsnprintf>
	va_end(ap);

	return rc;
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800874:	f3 0f 1e fb          	endbr32 
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80087e:	b8 00 00 00 00       	mov    $0x0,%eax
  800883:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800887:	74 05                	je     80088e <strlen+0x1a>
		n++;
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	eb f5                	jmp    800883 <strlen+0xf>
	return n;
}
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800890:	f3 0f 1e fb          	endbr32 
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a2:	39 d0                	cmp    %edx,%eax
  8008a4:	74 0d                	je     8008b3 <strnlen+0x23>
  8008a6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008aa:	74 05                	je     8008b1 <strnlen+0x21>
		n++;
  8008ac:	83 c0 01             	add    $0x1,%eax
  8008af:	eb f1                	jmp    8008a2 <strnlen+0x12>
  8008b1:	89 c2                	mov    %eax,%edx
	return n;
}
  8008b3:	89 d0                	mov    %edx,%eax
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008ce:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	84 d2                	test   %dl,%dl
  8008d6:	75 f2                	jne    8008ca <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008d8:	89 c8                	mov    %ecx,%eax
  8008da:	5b                   	pop    %ebx
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	83 ec 10             	sub    $0x10,%esp
  8008e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008eb:	53                   	push   %ebx
  8008ec:	e8 83 ff ff ff       	call   800874 <strlen>
  8008f1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	01 d8                	add    %ebx,%eax
  8008f9:	50                   	push   %eax
  8008fa:	e8 b8 ff ff ff       	call   8008b7 <strcpy>
	return dst;
}
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800906:	f3 0f 1e fb          	endbr32 
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	56                   	push   %esi
  80090e:	53                   	push   %ebx
  80090f:	8b 75 08             	mov    0x8(%ebp),%esi
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	89 f3                	mov    %esi,%ebx
  800917:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091a:	89 f0                	mov    %esi,%eax
  80091c:	39 d8                	cmp    %ebx,%eax
  80091e:	74 11                	je     800931 <strncpy+0x2b>
		*dst++ = *src;
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	0f b6 0a             	movzbl (%edx),%ecx
  800926:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800929:	80 f9 01             	cmp    $0x1,%cl
  80092c:	83 da ff             	sbb    $0xffffffff,%edx
  80092f:	eb eb                	jmp    80091c <strncpy+0x16>
	}
	return ret;
}
  800931:	89 f0                	mov    %esi,%eax
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
  800943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800946:	8b 55 10             	mov    0x10(%ebp),%edx
  800949:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80094b:	85 d2                	test   %edx,%edx
  80094d:	74 21                	je     800970 <strlcpy+0x39>
  80094f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800953:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 14                	je     80096d <strlcpy+0x36>
  800959:	0f b6 19             	movzbl (%ecx),%ebx
  80095c:	84 db                	test   %bl,%bl
  80095e:	74 0b                	je     80096b <strlcpy+0x34>
			*dst++ = *src++;
  800960:	83 c1 01             	add    $0x1,%ecx
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	88 5a ff             	mov    %bl,-0x1(%edx)
  800969:	eb ea                	jmp    800955 <strlcpy+0x1e>
  80096b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80096d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800970:	29 f0                	sub    %esi,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 0c                	je     800996 <strcmp+0x20>
  80098a:	3a 02                	cmp    (%edx),%al
  80098c:	75 08                	jne    800996 <strcmp+0x20>
		p++, q++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	eb ed                	jmp    800983 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800996:	0f b6 c0             	movzbl %al,%eax
  800999:	0f b6 12             	movzbl (%edx),%edx
  80099c:	29 d0                	sub    %edx,%eax
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a0:	f3 0f 1e fb          	endbr32 
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 c3                	mov    %eax,%ebx
  8009b0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b3:	eb 06                	jmp    8009bb <strncmp+0x1b>
		n--, p++, q++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009bb:	39 d8                	cmp    %ebx,%eax
  8009bd:	74 16                	je     8009d5 <strncmp+0x35>
  8009bf:	0f b6 08             	movzbl (%eax),%ecx
  8009c2:	84 c9                	test   %cl,%cl
  8009c4:	74 04                	je     8009ca <strncmp+0x2a>
  8009c6:	3a 0a                	cmp    (%edx),%cl
  8009c8:	74 eb                	je     8009b5 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ca:	0f b6 00             	movzbl (%eax),%eax
  8009cd:	0f b6 12             	movzbl (%edx),%edx
  8009d0:	29 d0                	sub    %edx,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    
		return 0;
  8009d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009da:	eb f6                	jmp    8009d2 <strncmp+0x32>

008009dc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ea:	0f b6 10             	movzbl (%eax),%edx
  8009ed:	84 d2                	test   %dl,%dl
  8009ef:	74 09                	je     8009fa <strchr+0x1e>
		if (*s == c)
  8009f1:	38 ca                	cmp    %cl,%dl
  8009f3:	74 0a                	je     8009ff <strchr+0x23>
	for (; *s; s++)
  8009f5:	83 c0 01             	add    $0x1,%eax
  8009f8:	eb f0                	jmp    8009ea <strchr+0xe>
			return (char *) s;
	return 0;
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a01:	f3 0f 1e fb          	endbr32 
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a12:	38 ca                	cmp    %cl,%dl
  800a14:	74 09                	je     800a1f <strfind+0x1e>
  800a16:	84 d2                	test   %dl,%dl
  800a18:	74 05                	je     800a1f <strfind+0x1e>
	for (; *s; s++)
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	eb f0                	jmp    800a0f <strfind+0xe>
			break;
	return (char *) s;
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a21:	f3 0f 1e fb          	endbr32 
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	57                   	push   %edi
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a31:	85 c9                	test   %ecx,%ecx
  800a33:	74 31                	je     800a66 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a35:	89 f8                	mov    %edi,%eax
  800a37:	09 c8                	or     %ecx,%eax
  800a39:	a8 03                	test   $0x3,%al
  800a3b:	75 23                	jne    800a60 <memset+0x3f>
		c &= 0xFF;
  800a3d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a41:	89 d3                	mov    %edx,%ebx
  800a43:	c1 e3 08             	shl    $0x8,%ebx
  800a46:	89 d0                	mov    %edx,%eax
  800a48:	c1 e0 18             	shl    $0x18,%eax
  800a4b:	89 d6                	mov    %edx,%esi
  800a4d:	c1 e6 10             	shl    $0x10,%esi
  800a50:	09 f0                	or     %esi,%eax
  800a52:	09 c2                	or     %eax,%edx
  800a54:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a56:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a59:	89 d0                	mov    %edx,%eax
  800a5b:	fc                   	cld    
  800a5c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a5e:	eb 06                	jmp    800a66 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	fc                   	cld    
  800a64:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a66:	89 f8                	mov    %edi,%eax
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5f                   	pop    %edi
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6d:	f3 0f 1e fb          	endbr32 
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	57                   	push   %edi
  800a75:	56                   	push   %esi
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7f:	39 c6                	cmp    %eax,%esi
  800a81:	73 32                	jae    800ab5 <memmove+0x48>
  800a83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a86:	39 c2                	cmp    %eax,%edx
  800a88:	76 2b                	jbe    800ab5 <memmove+0x48>
		s += n;
		d += n;
  800a8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8d:	89 fe                	mov    %edi,%esi
  800a8f:	09 ce                	or     %ecx,%esi
  800a91:	09 d6                	or     %edx,%esi
  800a93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a99:	75 0e                	jne    800aa9 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9b:	83 ef 04             	sub    $0x4,%edi
  800a9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa4:	fd                   	std    
  800aa5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa7:	eb 09                	jmp    800ab2 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa9:	83 ef 01             	sub    $0x1,%edi
  800aac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aaf:	fd                   	std    
  800ab0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab2:	fc                   	cld    
  800ab3:	eb 1a                	jmp    800acf <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab5:	89 c2                	mov    %eax,%edx
  800ab7:	09 ca                	or     %ecx,%edx
  800ab9:	09 f2                	or     %esi,%edx
  800abb:	f6 c2 03             	test   $0x3,%dl
  800abe:	75 0a                	jne    800aca <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac8:	eb 05                	jmp    800acf <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aca:	89 c7                	mov    %eax,%edi
  800acc:	fc                   	cld    
  800acd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800add:	ff 75 10             	pushl  0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 82 ff ff ff       	call   800a6d <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	f3 0f 1e fb          	endbr32 
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	56                   	push   %esi
  800af5:	53                   	push   %ebx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 c6                	mov    %eax,%esi
  800afe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b01:	39 f0                	cmp    %esi,%eax
  800b03:	74 1c                	je     800b21 <memcmp+0x34>
		if (*s1 != *s2)
  800b05:	0f b6 08             	movzbl (%eax),%ecx
  800b08:	0f b6 1a             	movzbl (%edx),%ebx
  800b0b:	38 d9                	cmp    %bl,%cl
  800b0d:	75 08                	jne    800b17 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0f:	83 c0 01             	add    $0x1,%eax
  800b12:	83 c2 01             	add    $0x1,%edx
  800b15:	eb ea                	jmp    800b01 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b17:	0f b6 c1             	movzbl %cl,%eax
  800b1a:	0f b6 db             	movzbl %bl,%ebx
  800b1d:	29 d8                	sub    %ebx,%eax
  800b1f:	eb 05                	jmp    800b26 <memcmp+0x39>
	}

	return 0;
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2a:	f3 0f 1e fb          	endbr32 
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3c:	39 d0                	cmp    %edx,%eax
  800b3e:	73 09                	jae    800b49 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b40:	38 08                	cmp    %cl,(%eax)
  800b42:	74 05                	je     800b49 <memfind+0x1f>
	for (; s < ends; s++)
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	eb f3                	jmp    800b3c <memfind+0x12>
			break;
	return (void *) s;
}
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5b:	eb 03                	jmp    800b60 <strtol+0x15>
		s++;
  800b5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b60:	0f b6 01             	movzbl (%ecx),%eax
  800b63:	3c 20                	cmp    $0x20,%al
  800b65:	74 f6                	je     800b5d <strtol+0x12>
  800b67:	3c 09                	cmp    $0x9,%al
  800b69:	74 f2                	je     800b5d <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b6b:	3c 2b                	cmp    $0x2b,%al
  800b6d:	74 2a                	je     800b99 <strtol+0x4e>
	int neg = 0;
  800b6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b74:	3c 2d                	cmp    $0x2d,%al
  800b76:	74 2b                	je     800ba3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7e:	75 0f                	jne    800b8f <strtol+0x44>
  800b80:	80 39 30             	cmpb   $0x30,(%ecx)
  800b83:	74 28                	je     800bad <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8c:	0f 44 d8             	cmove  %eax,%ebx
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b97:	eb 46                	jmp    800bdf <strtol+0x94>
		s++;
  800b99:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba1:	eb d5                	jmp    800b78 <strtol+0x2d>
		s++, neg = 1;
  800ba3:	83 c1 01             	add    $0x1,%ecx
  800ba6:	bf 01 00 00 00       	mov    $0x1,%edi
  800bab:	eb cb                	jmp    800b78 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bad:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb1:	74 0e                	je     800bc1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	75 d8                	jne    800b8f <strtol+0x44>
		s++, base = 8;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bbf:	eb ce                	jmp    800b8f <strtol+0x44>
		s += 2, base = 16;
  800bc1:	83 c1 02             	add    $0x2,%ecx
  800bc4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc9:	eb c4                	jmp    800b8f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bcb:	0f be d2             	movsbl %dl,%edx
  800bce:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd4:	7d 3a                	jge    800c10 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdf:	0f b6 11             	movzbl (%ecx),%edx
  800be2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 09             	cmp    $0x9,%bl
  800bea:	76 df                	jbe    800bcb <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bef:	89 f3                	mov    %esi,%ebx
  800bf1:	80 fb 19             	cmp    $0x19,%bl
  800bf4:	77 08                	ja     800bfe <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 57             	sub    $0x57,%edx
  800bfc:	eb d3                	jmp    800bd1 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bfe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 08                	ja     800c10 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 37             	sub    $0x37,%edx
  800c0e:	eb c1                	jmp    800bd1 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 05                	je     800c1b <strtol+0xd0>
		*endptr = (char *) s;
  800c16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c19:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	85 ff                	test   %edi,%edi
  800c21:	0f 45 c2             	cmovne %edx,%eax
}
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c29:	f3 0f 1e fb          	endbr32 
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	89 c3                	mov    %eax,%ebx
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	b8 03 00 00 00       	mov    $0x3,%eax
  800c88:	89 cb                	mov    %ecx,%ebx
  800c8a:	89 cf                	mov    %ecx,%edi
  800c8c:	89 ce                	mov    %ecx,%esi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 03                	push   $0x3
  800ca2:	68 9f 27 80 00       	push   $0x80279f
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 bc 27 80 00       	push   $0x8027bc
  800cae:	e8 c0 13 00 00       	call   802073 <_panic>

00800cb3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb3:	f3 0f 1e fb          	endbr32 
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_yield>:

void
sys_yield(void)
{
  800cd6:	f3 0f 1e fb          	endbr32 
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf9:	f3 0f 1e fb          	endbr32 
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d06:	be 00 00 00 00       	mov    $0x0,%esi
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	89 f7                	mov    %esi,%edi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d2d:	6a 04                	push   $0x4
  800d2f:	68 9f 27 80 00       	push   $0x80279f
  800d34:	6a 23                	push   $0x23
  800d36:	68 bc 27 80 00       	push   $0x8027bc
  800d3b:	e8 33 13 00 00       	call   802073 <_panic>

00800d40 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 05 00 00 00       	mov    $0x5,%eax
  800d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d73:	6a 05                	push   $0x5
  800d75:	68 9f 27 80 00       	push   $0x80279f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 bc 27 80 00       	push   $0x8027bc
  800d81:	e8 ed 12 00 00       	call   802073 <_panic>

00800d86 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800db9:	6a 06                	push   $0x6
  800dbb:	68 9f 27 80 00       	push   $0x80279f
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 bc 27 80 00       	push   $0x8027bc
  800dc7:	e8 a7 12 00 00       	call   802073 <_panic>

00800dcc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800de4:	b8 08 00 00 00       	mov    $0x8,%eax
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800dff:	6a 08                	push   $0x8
  800e01:	68 9f 27 80 00       	push   $0x80279f
  800e06:	6a 23                	push   $0x23
  800e08:	68 bc 27 80 00       	push   $0x8027bc
  800e0d:	e8 61 12 00 00       	call   802073 <_panic>

00800e12 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2f:	89 df                	mov    %ebx,%edi
  800e31:	89 de                	mov    %ebx,%esi
  800e33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	7f 08                	jg     800e41 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 09                	push   $0x9
  800e47:	68 9f 27 80 00       	push   $0x80279f
  800e4c:	6a 23                	push   $0x23
  800e4e:	68 bc 27 80 00       	push   $0x8027bc
  800e53:	e8 1b 12 00 00       	call   802073 <_panic>

00800e58 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e58:	f3 0f 1e fb          	endbr32 
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 0a                	push   $0xa
  800e8d:	68 9f 27 80 00       	push   $0x80279f
  800e92:	6a 23                	push   $0x23
  800e94:	68 bc 27 80 00       	push   $0x8027bc
  800e99:	e8 d5 11 00 00       	call   802073 <_panic>

00800e9e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb3:	be 00 00 00 00       	mov    $0x0,%esi
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec5:	f3 0f 1e fb          	endbr32 
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7f 08                	jg     800ef3 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	50                   	push   %eax
  800ef7:	6a 0d                	push   $0xd
  800ef9:	68 9f 27 80 00       	push   $0x80279f
  800efe:	6a 23                	push   $0x23
  800f00:	68 bc 27 80 00       	push   $0x8027bc
  800f05:	e8 69 11 00 00       	call   802073 <_panic>

00800f0a <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800f0a:	f3 0f 1e fb          	endbr32 
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f16:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f18:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f1c:	74 7f                	je     800f9d <pgfault+0x93>
  800f1e:	89 f0                	mov    %esi,%eax
  800f20:	c1 e8 0c             	shr    $0xc,%eax
  800f23:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f2a:	f6 c4 08             	test   $0x8,%ah
  800f2d:	74 6e                	je     800f9d <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  800f2f:	e8 7f fd ff ff       	call   800cb3 <sys_getenvid>
  800f34:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  800f36:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  800f3c:	83 ec 04             	sub    $0x4,%esp
  800f3f:	6a 07                	push   $0x7
  800f41:	68 00 f0 7f 00       	push   $0x7ff000
  800f46:	50                   	push   %eax
  800f47:	e8 ad fd ff ff       	call   800cf9 <sys_page_alloc>
  800f4c:	83 c4 10             	add    $0x10,%esp
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	78 5e                	js     800fb1 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  800f53:	83 ec 04             	sub    $0x4,%esp
  800f56:	68 00 10 00 00       	push   $0x1000
  800f5b:	56                   	push   %esi
  800f5c:	68 00 f0 7f 00       	push   $0x7ff000
  800f61:	e8 6d fb ff ff       	call   800ad3 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  800f66:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
  800f6f:	68 00 f0 7f 00       	push   $0x7ff000
  800f74:	53                   	push   %ebx
  800f75:	e8 c6 fd ff ff       	call   800d40 <sys_page_map>
  800f7a:	83 c4 20             	add    $0x20,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	78 44                	js     800fc5 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	68 00 f0 7f 00       	push   $0x7ff000
  800f89:	53                   	push   %ebx
  800f8a:	e8 f7 fd ff ff       	call   800d86 <sys_page_unmap>
  800f8f:	83 c4 10             	add    $0x10,%esp
  800f92:	85 c0                	test   %eax,%eax
  800f94:	78 43                	js     800fd9 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  800f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f99:	5b                   	pop    %ebx
  800f9a:	5e                   	pop    %esi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	68 ca 27 80 00       	push   $0x8027ca
  800fa5:	6a 1e                	push   $0x1e
  800fa7:	68 e7 27 80 00       	push   $0x8027e7
  800fac:	e8 c2 10 00 00       	call   802073 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  800fb1:	83 ec 04             	sub    $0x4,%esp
  800fb4:	68 78 28 80 00       	push   $0x802878
  800fb9:	6a 2b                	push   $0x2b
  800fbb:	68 e7 27 80 00       	push   $0x8027e7
  800fc0:	e8 ae 10 00 00       	call   802073 <_panic>
		panic("pgfault: sys_page_map Failed!");
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	68 f2 27 80 00       	push   $0x8027f2
  800fcd:	6a 2f                	push   $0x2f
  800fcf:	68 e7 27 80 00       	push   $0x8027e7
  800fd4:	e8 9a 10 00 00       	call   802073 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	68 98 28 80 00       	push   $0x802898
  800fe1:	6a 32                	push   $0x32
  800fe3:	68 e7 27 80 00       	push   $0x8027e7
  800fe8:	e8 86 10 00 00       	call   802073 <_panic>

00800fed <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fed:	f3 0f 1e fb          	endbr32 
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800ffa:	68 0a 0f 80 00       	push   $0x800f0a
  800fff:	e8 b9 10 00 00       	call   8020bd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801004:	b8 07 00 00 00       	mov    $0x7,%eax
  801009:	cd 30                	int    $0x30
  80100b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80100e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	85 c0                	test   %eax,%eax
  801016:	78 2b                	js     801043 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  80101d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801021:	0f 85 ba 00 00 00    	jne    8010e1 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  801027:	e8 87 fc ff ff       	call   800cb3 <sys_getenvid>
  80102c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801031:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801034:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801039:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80103e:	e9 90 01 00 00       	jmp    8011d3 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	68 10 28 80 00       	push   $0x802810
  80104b:	6a 76                	push   $0x76
  80104d:	68 e7 27 80 00       	push   $0x8027e7
  801052:	e8 1c 10 00 00       	call   802073 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  801057:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  80105e:	e8 50 fc ff ff       	call   800cb3 <sys_getenvid>
  801063:	83 ec 0c             	sub    $0xc,%esp
  801066:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  80106c:	56                   	push   %esi
  80106d:	57                   	push   %edi
  80106e:	ff 75 e0             	pushl  -0x20(%ebp)
  801071:	57                   	push   %edi
  801072:	50                   	push   %eax
  801073:	e8 c8 fc ff ff       	call   800d40 <sys_page_map>
  801078:	83 c4 20             	add    $0x20,%esp
  80107b:	85 c0                	test   %eax,%eax
  80107d:	79 50                	jns    8010cf <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  80107f:	83 ec 04             	sub    $0x4,%esp
  801082:	68 29 28 80 00       	push   $0x802829
  801087:	6a 4b                	push   $0x4b
  801089:	68 e7 27 80 00       	push   $0x8027e7
  80108e:	e8 e0 0f 00 00       	call   802073 <_panic>
			panic("duppage:child sys_page_map Failed!");
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 b8 28 80 00       	push   $0x8028b8
  80109b:	6a 50                	push   $0x50
  80109d:	68 e7 27 80 00       	push   $0x8027e7
  8010a2:	e8 cc 0f 00 00       	call   802073 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  8010a7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010ae:	83 ec 0c             	sub    $0xc,%esp
  8010b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8010b6:	50                   	push   %eax
  8010b7:	57                   	push   %edi
  8010b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8010bb:	57                   	push   %edi
  8010bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010bf:	e8 7c fc ff ff       	call   800d40 <sys_page_map>
  8010c4:	83 c4 20             	add    $0x20,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	0f 88 b4 00 00 00    	js     801183 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  8010cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010d5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010db:	0f 84 b6 00 00 00    	je     801197 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  8010e1:	89 d8                	mov    %ebx,%eax
  8010e3:	c1 e8 16             	shr    $0x16,%eax
  8010e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ed:	a8 01                	test   $0x1,%al
  8010ef:	74 de                	je     8010cf <fork+0xe2>
  8010f1:	89 de                	mov    %ebx,%esi
  8010f3:	c1 ee 0c             	shr    $0xc,%esi
  8010f6:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010fd:	a8 01                	test   $0x1,%al
  8010ff:	74 ce                	je     8010cf <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801101:	e8 ad fb ff ff       	call   800cb3 <sys_getenvid>
  801106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801109:	89 f7                	mov    %esi,%edi
  80110b:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80110e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801115:	f6 c4 04             	test   $0x4,%ah
  801118:	0f 85 39 ff ff ff    	jne    801057 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80111e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801125:	a9 02 08 00 00       	test   $0x802,%eax
  80112a:	0f 84 77 ff ff ff    	je     8010a7 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	68 05 08 00 00       	push   $0x805
  801138:	57                   	push   %edi
  801139:	ff 75 e0             	pushl  -0x20(%ebp)
  80113c:	57                   	push   %edi
  80113d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801140:	e8 fb fb ff ff       	call   800d40 <sys_page_map>
  801145:	83 c4 20             	add    $0x20,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	0f 88 43 ff ff ff    	js     801093 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  801150:	83 ec 0c             	sub    $0xc,%esp
  801153:	68 05 08 00 00       	push   $0x805
  801158:	57                   	push   %edi
  801159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80115c:	50                   	push   %eax
  80115d:	57                   	push   %edi
  80115e:	50                   	push   %eax
  80115f:	e8 dc fb ff ff       	call   800d40 <sys_page_map>
  801164:	83 c4 20             	add    $0x20,%esp
  801167:	85 c0                	test   %eax,%eax
  801169:	0f 89 60 ff ff ff    	jns    8010cf <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	68 dc 28 80 00       	push   $0x8028dc
  801177:	6a 52                	push   $0x52
  801179:	68 e7 27 80 00       	push   $0x8027e7
  80117e:	e8 f0 0e 00 00       	call   802073 <_panic>
			panic("duppage: single sys_page_map Failed!");
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	68 00 29 80 00       	push   $0x802900
  80118b:	6a 56                	push   $0x56
  80118d:	68 e7 27 80 00       	push   $0x8027e7
  801192:	e8 dc 0e 00 00       	call   802073 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	6a 07                	push   $0x7
  80119c:	68 00 f0 bf ee       	push   $0xeebff000
  8011a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8011a4:	e8 50 fb ff ff       	call   800cf9 <sys_page_alloc>
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 2e                	js     8011de <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	68 39 21 80 00       	push   $0x802139
  8011b8:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8011bb:	57                   	push   %edi
  8011bc:	e8 97 fc ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  8011c1:	83 c4 08             	add    $0x8,%esp
  8011c4:	6a 02                	push   $0x2
  8011c6:	57                   	push   %edi
  8011c7:	e8 00 fc ff ff       	call   800dcc <sys_env_set_status>
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 22                	js     8011f5 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  8011d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d9:	5b                   	pop    %ebx
  8011da:	5e                   	pop    %esi
  8011db:	5f                   	pop    %edi
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  8011de:	83 ec 04             	sub    $0x4,%esp
  8011e1:	68 46 28 80 00       	push   $0x802846
  8011e6:	68 83 00 00 00       	push   $0x83
  8011eb:	68 e7 27 80 00       	push   $0x8027e7
  8011f0:	e8 7e 0e 00 00       	call   802073 <_panic>
		panic("fork: sys_env_set_status Failed!");
  8011f5:	83 ec 04             	sub    $0x4,%esp
  8011f8:	68 28 29 80 00       	push   $0x802928
  8011fd:	68 89 00 00 00       	push   $0x89
  801202:	68 e7 27 80 00       	push   $0x8027e7
  801207:	e8 67 0e 00 00       	call   802073 <_panic>

0080120c <sfork>:

// Challenge!
int
sfork(void)
{
  80120c:	f3 0f 1e fb          	endbr32 
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801216:	68 62 28 80 00       	push   $0x802862
  80121b:	68 93 00 00 00       	push   $0x93
  801220:	68 e7 27 80 00       	push   $0x8027e7
  801225:	e8 49 0e 00 00       	call   802073 <_panic>

0080122a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80122a:	f3 0f 1e fb          	endbr32 
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	8b 75 08             	mov    0x8(%ebp),%esi
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80123c:	85 c0                	test   %eax,%eax
  80123e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801243:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	50                   	push   %eax
  80124a:	e8 76 fc ff ff       	call   800ec5 <sys_ipc_recv>
  80124f:	83 c4 10             	add    $0x10,%esp
  801252:	85 c0                	test   %eax,%eax
  801254:	78 2b                	js     801281 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  801256:	85 f6                	test   %esi,%esi
  801258:	74 0a                	je     801264 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  80125a:	a1 04 40 80 00       	mov    0x804004,%eax
  80125f:	8b 40 74             	mov    0x74(%eax),%eax
  801262:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  801264:	85 db                	test   %ebx,%ebx
  801266:	74 0a                	je     801272 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  801268:	a1 04 40 80 00       	mov    0x804004,%eax
  80126d:	8b 40 78             	mov    0x78(%eax),%eax
  801270:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801272:	a1 04 40 80 00       	mov    0x804004,%eax
  801277:	8b 40 70             	mov    0x70(%eax),%eax
}
  80127a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    
		if(from_env_store)
  801281:	85 f6                	test   %esi,%esi
  801283:	74 06                	je     80128b <ipc_recv+0x61>
			*from_env_store=0;
  801285:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	74 eb                	je     80127a <ipc_recv+0x50>
			*perm_store=0;
  80128f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801295:	eb e3                	jmp    80127a <ipc_recv+0x50>

00801297 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801297:	f3 0f 1e fb          	endbr32 
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	57                   	push   %edi
  80129f:	56                   	push   %esi
  8012a0:	53                   	push   %ebx
  8012a1:	83 ec 0c             	sub    $0xc,%esp
  8012a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8012ad:	85 db                	test   %ebx,%ebx
  8012af:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012b4:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8012b7:	ff 75 14             	pushl  0x14(%ebp)
  8012ba:	53                   	push   %ebx
  8012bb:	56                   	push   %esi
  8012bc:	57                   	push   %edi
  8012bd:	e8 dc fb ff ff       	call   800e9e <sys_ipc_try_send>
		if(!res)
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	74 20                	je     8012e9 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  8012c9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012cc:	75 07                	jne    8012d5 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  8012ce:	e8 03 fa ff ff       	call   800cd6 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8012d3:	eb e2                	jmp    8012b7 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 49 29 80 00       	push   $0x802949
  8012dd:	6a 3f                	push   $0x3f
  8012df:	68 61 29 80 00       	push   $0x802961
  8012e4:	e8 8a 0d 00 00       	call   802073 <_panic>
	}
}
  8012e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ec:	5b                   	pop    %ebx
  8012ed:	5e                   	pop    %esi
  8012ee:	5f                   	pop    %edi
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012f1:	f3 0f 1e fb          	endbr32 
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801300:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801303:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801309:	8b 52 50             	mov    0x50(%edx),%edx
  80130c:	39 ca                	cmp    %ecx,%edx
  80130e:	74 11                	je     801321 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801310:	83 c0 01             	add    $0x1,%eax
  801313:	3d 00 04 00 00       	cmp    $0x400,%eax
  801318:	75 e6                	jne    801300 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	eb 0b                	jmp    80132c <ipc_find_env+0x3b>
			return envs[i].env_id;
  801321:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801324:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801329:	8b 40 48             	mov    0x48(%eax),%eax
}
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80132e:	f3 0f 1e fb          	endbr32 
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	05 00 00 00 30       	add    $0x30000000,%eax
  80133d:	c1 e8 0c             	shr    $0xc,%eax
}
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801342:	f3 0f 1e fb          	endbr32 
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801351:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801356:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80135d:	f3 0f 1e fb          	endbr32 
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801369:	89 c2                	mov    %eax,%edx
  80136b:	c1 ea 16             	shr    $0x16,%edx
  80136e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801375:	f6 c2 01             	test   $0x1,%dl
  801378:	74 2d                	je     8013a7 <fd_alloc+0x4a>
  80137a:	89 c2                	mov    %eax,%edx
  80137c:	c1 ea 0c             	shr    $0xc,%edx
  80137f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801386:	f6 c2 01             	test   $0x1,%dl
  801389:	74 1c                	je     8013a7 <fd_alloc+0x4a>
  80138b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801390:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801395:	75 d2                	jne    801369 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013a0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013a5:	eb 0a                	jmp    8013b1 <fd_alloc+0x54>
			*fd_store = fd;
  8013a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013b3:	f3 0f 1e fb          	endbr32 
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013bd:	83 f8 1f             	cmp    $0x1f,%eax
  8013c0:	77 30                	ja     8013f2 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013c2:	c1 e0 0c             	shl    $0xc,%eax
  8013c5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ca:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013d0:	f6 c2 01             	test   $0x1,%dl
  8013d3:	74 24                	je     8013f9 <fd_lookup+0x46>
  8013d5:	89 c2                	mov    %eax,%edx
  8013d7:	c1 ea 0c             	shr    $0xc,%edx
  8013da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e1:	f6 c2 01             	test   $0x1,%dl
  8013e4:	74 1a                	je     801400 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e9:	89 02                	mov    %eax,(%edx)
	return 0;
  8013eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    
		return -E_INVAL;
  8013f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f7:	eb f7                	jmp    8013f0 <fd_lookup+0x3d>
		return -E_INVAL;
  8013f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fe:	eb f0                	jmp    8013f0 <fd_lookup+0x3d>
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801405:	eb e9                	jmp    8013f0 <fd_lookup+0x3d>

00801407 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801407:	f3 0f 1e fb          	endbr32 
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801414:	ba e8 29 80 00       	mov    $0x8029e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801419:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80141e:	39 08                	cmp    %ecx,(%eax)
  801420:	74 33                	je     801455 <dev_lookup+0x4e>
  801422:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801425:	8b 02                	mov    (%edx),%eax
  801427:	85 c0                	test   %eax,%eax
  801429:	75 f3                	jne    80141e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80142b:	a1 04 40 80 00       	mov    0x804004,%eax
  801430:	8b 40 48             	mov    0x48(%eax),%eax
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	51                   	push   %ecx
  801437:	50                   	push   %eax
  801438:	68 6c 29 80 00       	push   $0x80296c
  80143d:	e8 6b ee ff ff       	call   8002ad <cprintf>
	*dev = 0;
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    
			*dev = devtab[i];
  801455:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801458:	89 01                	mov    %eax,(%ecx)
			return 0;
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
  80145f:	eb f2                	jmp    801453 <dev_lookup+0x4c>

00801461 <fd_close>:
{
  801461:	f3 0f 1e fb          	endbr32 
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	57                   	push   %edi
  801469:	56                   	push   %esi
  80146a:	53                   	push   %ebx
  80146b:	83 ec 24             	sub    $0x24,%esp
  80146e:	8b 75 08             	mov    0x8(%ebp),%esi
  801471:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801474:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801477:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801478:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80147e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801481:	50                   	push   %eax
  801482:	e8 2c ff ff ff       	call   8013b3 <fd_lookup>
  801487:	89 c3                	mov    %eax,%ebx
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 05                	js     801495 <fd_close+0x34>
	    || fd != fd2)
  801490:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801493:	74 16                	je     8014ab <fd_close+0x4a>
		return (must_exist ? r : 0);
  801495:	89 f8                	mov    %edi,%eax
  801497:	84 c0                	test   %al,%al
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
  80149e:	0f 44 d8             	cmove  %eax,%ebx
}
  8014a1:	89 d8                	mov    %ebx,%eax
  8014a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a6:	5b                   	pop    %ebx
  8014a7:	5e                   	pop    %esi
  8014a8:	5f                   	pop    %edi
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 36                	pushl  (%esi)
  8014b4:	e8 4e ff ff ff       	call   801407 <dev_lookup>
  8014b9:	89 c3                	mov    %eax,%ebx
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 1a                	js     8014dc <fd_close+0x7b>
		if (dev->dev_close)
  8014c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	74 0b                	je     8014dc <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014d1:	83 ec 0c             	sub    $0xc,%esp
  8014d4:	56                   	push   %esi
  8014d5:	ff d0                	call   *%eax
  8014d7:	89 c3                	mov    %eax,%ebx
  8014d9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	56                   	push   %esi
  8014e0:	6a 00                	push   $0x0
  8014e2:	e8 9f f8 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	eb b5                	jmp    8014a1 <fd_close+0x40>

008014ec <close>:

int
close(int fdnum)
{
  8014ec:	f3 0f 1e fb          	endbr32 
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	ff 75 08             	pushl  0x8(%ebp)
  8014fd:	e8 b1 fe ff ff       	call   8013b3 <fd_lookup>
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	79 02                	jns    80150b <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    
		return fd_close(fd, 1);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	6a 01                	push   $0x1
  801510:	ff 75 f4             	pushl  -0xc(%ebp)
  801513:	e8 49 ff ff ff       	call   801461 <fd_close>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	eb ec                	jmp    801509 <close+0x1d>

0080151d <close_all>:

void
close_all(void)
{
  80151d:	f3 0f 1e fb          	endbr32 
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	53                   	push   %ebx
  801525:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801528:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80152d:	83 ec 0c             	sub    $0xc,%esp
  801530:	53                   	push   %ebx
  801531:	e8 b6 ff ff ff       	call   8014ec <close>
	for (i = 0; i < MAXFD; i++)
  801536:	83 c3 01             	add    $0x1,%ebx
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	83 fb 20             	cmp    $0x20,%ebx
  80153f:	75 ec                	jne    80152d <close_all+0x10>
}
  801541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801546:	f3 0f 1e fb          	endbr32 
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	57                   	push   %edi
  80154e:	56                   	push   %esi
  80154f:	53                   	push   %ebx
  801550:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801553:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801556:	50                   	push   %eax
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	e8 54 fe ff ff       	call   8013b3 <fd_lookup>
  80155f:	89 c3                	mov    %eax,%ebx
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	0f 88 81 00 00 00    	js     8015ed <dup+0xa7>
		return r;
	close(newfdnum);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 75 ff ff ff       	call   8014ec <close>

	newfd = INDEX2FD(newfdnum);
  801577:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157a:	c1 e6 0c             	shl    $0xc,%esi
  80157d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801583:	83 c4 04             	add    $0x4,%esp
  801586:	ff 75 e4             	pushl  -0x1c(%ebp)
  801589:	e8 b4 fd ff ff       	call   801342 <fd2data>
  80158e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801590:	89 34 24             	mov    %esi,(%esp)
  801593:	e8 aa fd ff ff       	call   801342 <fd2data>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80159d:	89 d8                	mov    %ebx,%eax
  80159f:	c1 e8 16             	shr    $0x16,%eax
  8015a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015a9:	a8 01                	test   $0x1,%al
  8015ab:	74 11                	je     8015be <dup+0x78>
  8015ad:	89 d8                	mov    %ebx,%eax
  8015af:	c1 e8 0c             	shr    $0xc,%eax
  8015b2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015b9:	f6 c2 01             	test   $0x1,%dl
  8015bc:	75 39                	jne    8015f7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c1:	89 d0                	mov    %edx,%eax
  8015c3:	c1 e8 0c             	shr    $0xc,%eax
  8015c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015cd:	83 ec 0c             	sub    $0xc,%esp
  8015d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d5:	50                   	push   %eax
  8015d6:	56                   	push   %esi
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	6a 00                	push   $0x0
  8015dc:	e8 5f f7 ff ff       	call   800d40 <sys_page_map>
  8015e1:	89 c3                	mov    %eax,%ebx
  8015e3:	83 c4 20             	add    $0x20,%esp
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 31                	js     80161b <dup+0xd5>
		goto err;

	return newfdnum;
  8015ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015ed:	89 d8                	mov    %ebx,%eax
  8015ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f2:	5b                   	pop    %ebx
  8015f3:	5e                   	pop    %esi
  8015f4:	5f                   	pop    %edi
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	25 07 0e 00 00       	and    $0xe07,%eax
  801606:	50                   	push   %eax
  801607:	57                   	push   %edi
  801608:	6a 00                	push   $0x0
  80160a:	53                   	push   %ebx
  80160b:	6a 00                	push   $0x0
  80160d:	e8 2e f7 ff ff       	call   800d40 <sys_page_map>
  801612:	89 c3                	mov    %eax,%ebx
  801614:	83 c4 20             	add    $0x20,%esp
  801617:	85 c0                	test   %eax,%eax
  801619:	79 a3                	jns    8015be <dup+0x78>
	sys_page_unmap(0, newfd);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	56                   	push   %esi
  80161f:	6a 00                	push   $0x0
  801621:	e8 60 f7 ff ff       	call   800d86 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801626:	83 c4 08             	add    $0x8,%esp
  801629:	57                   	push   %edi
  80162a:	6a 00                	push   $0x0
  80162c:	e8 55 f7 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	eb b7                	jmp    8015ed <dup+0xa7>

00801636 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801636:	f3 0f 1e fb          	endbr32 
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	53                   	push   %ebx
  80163e:	83 ec 1c             	sub    $0x1c,%esp
  801641:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801644:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801647:	50                   	push   %eax
  801648:	53                   	push   %ebx
  801649:	e8 65 fd ff ff       	call   8013b3 <fd_lookup>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 3f                	js     801694 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	ff 30                	pushl  (%eax)
  801661:	e8 a1 fd ff ff       	call   801407 <dev_lookup>
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	85 c0                	test   %eax,%eax
  80166b:	78 27                	js     801694 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80166d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801670:	8b 42 08             	mov    0x8(%edx),%eax
  801673:	83 e0 03             	and    $0x3,%eax
  801676:	83 f8 01             	cmp    $0x1,%eax
  801679:	74 1e                	je     801699 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167e:	8b 40 08             	mov    0x8(%eax),%eax
  801681:	85 c0                	test   %eax,%eax
  801683:	74 35                	je     8016ba <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	ff 75 10             	pushl  0x10(%ebp)
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	52                   	push   %edx
  80168f:	ff d0                	call   *%eax
  801691:	83 c4 10             	add    $0x10,%esp
}
  801694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801697:	c9                   	leave  
  801698:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801699:	a1 04 40 80 00       	mov    0x804004,%eax
  80169e:	8b 40 48             	mov    0x48(%eax),%eax
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	53                   	push   %ebx
  8016a5:	50                   	push   %eax
  8016a6:	68 ad 29 80 00       	push   $0x8029ad
  8016ab:	e8 fd eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b8:	eb da                	jmp    801694 <read+0x5e>
		return -E_NOT_SUPP;
  8016ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016bf:	eb d3                	jmp    801694 <read+0x5e>

008016c1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016c1:	f3 0f 1e fb          	endbr32 
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	57                   	push   %edi
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 0c             	sub    $0xc,%esp
  8016ce:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d9:	eb 02                	jmp    8016dd <readn+0x1c>
  8016db:	01 c3                	add    %eax,%ebx
  8016dd:	39 f3                	cmp    %esi,%ebx
  8016df:	73 21                	jae    801702 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	89 f0                	mov    %esi,%eax
  8016e6:	29 d8                	sub    %ebx,%eax
  8016e8:	50                   	push   %eax
  8016e9:	89 d8                	mov    %ebx,%eax
  8016eb:	03 45 0c             	add    0xc(%ebp),%eax
  8016ee:	50                   	push   %eax
  8016ef:	57                   	push   %edi
  8016f0:	e8 41 ff ff ff       	call   801636 <read>
		if (m < 0)
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 04                	js     801700 <readn+0x3f>
			return m;
		if (m == 0)
  8016fc:	75 dd                	jne    8016db <readn+0x1a>
  8016fe:	eb 02                	jmp    801702 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801700:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801702:	89 d8                	mov    %ebx,%eax
  801704:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801707:	5b                   	pop    %ebx
  801708:	5e                   	pop    %esi
  801709:	5f                   	pop    %edi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80170c:	f3 0f 1e fb          	endbr32 
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	53                   	push   %ebx
  801714:	83 ec 1c             	sub    $0x1c,%esp
  801717:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171d:	50                   	push   %eax
  80171e:	53                   	push   %ebx
  80171f:	e8 8f fc ff ff       	call   8013b3 <fd_lookup>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	85 c0                	test   %eax,%eax
  801729:	78 3a                	js     801765 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801735:	ff 30                	pushl  (%eax)
  801737:	e8 cb fc ff ff       	call   801407 <dev_lookup>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	85 c0                	test   %eax,%eax
  801741:	78 22                	js     801765 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801746:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80174a:	74 1e                	je     80176a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80174c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174f:	8b 52 0c             	mov    0xc(%edx),%edx
  801752:	85 d2                	test   %edx,%edx
  801754:	74 35                	je     80178b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	ff 75 10             	pushl  0x10(%ebp)
  80175c:	ff 75 0c             	pushl  0xc(%ebp)
  80175f:	50                   	push   %eax
  801760:	ff d2                	call   *%edx
  801762:	83 c4 10             	add    $0x10,%esp
}
  801765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801768:	c9                   	leave  
  801769:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80176a:	a1 04 40 80 00       	mov    0x804004,%eax
  80176f:	8b 40 48             	mov    0x48(%eax),%eax
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	53                   	push   %ebx
  801776:	50                   	push   %eax
  801777:	68 c9 29 80 00       	push   $0x8029c9
  80177c:	e8 2c eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801789:	eb da                	jmp    801765 <write+0x59>
		return -E_NOT_SUPP;
  80178b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801790:	eb d3                	jmp    801765 <write+0x59>

00801792 <seek>:

int
seek(int fdnum, off_t offset)
{
  801792:	f3 0f 1e fb          	endbr32 
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80179c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179f:	50                   	push   %eax
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	e8 0b fc ff ff       	call   8013b3 <fd_lookup>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 0e                	js     8017bd <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017bf:	f3 0f 1e fb          	endbr32 
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 1c             	sub    $0x1c,%esp
  8017ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	53                   	push   %ebx
  8017d2:	e8 dc fb ff ff       	call   8013b3 <fd_lookup>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 37                	js     801815 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e4:	50                   	push   %eax
  8017e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e8:	ff 30                	pushl  (%eax)
  8017ea:	e8 18 fc ff ff       	call   801407 <dev_lookup>
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	78 1f                	js     801815 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017fd:	74 1b                	je     80181a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	8b 52 18             	mov    0x18(%edx),%edx
  801805:	85 d2                	test   %edx,%edx
  801807:	74 32                	je     80183b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	50                   	push   %eax
  801810:	ff d2                	call   *%edx
  801812:	83 c4 10             	add    $0x10,%esp
}
  801815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801818:	c9                   	leave  
  801819:	c3                   	ret    
			thisenv->env_id, fdnum);
  80181a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80181f:	8b 40 48             	mov    0x48(%eax),%eax
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	53                   	push   %ebx
  801826:	50                   	push   %eax
  801827:	68 8c 29 80 00       	push   $0x80298c
  80182c:	e8 7c ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801839:	eb da                	jmp    801815 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80183b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801840:	eb d3                	jmp    801815 <ftruncate+0x56>

00801842 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801842:	f3 0f 1e fb          	endbr32 
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	53                   	push   %ebx
  80184a:	83 ec 1c             	sub    $0x1c,%esp
  80184d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801850:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801853:	50                   	push   %eax
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 57 fb ff ff       	call   8013b3 <fd_lookup>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	78 4b                	js     8018ae <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801869:	50                   	push   %eax
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	ff 30                	pushl  (%eax)
  80186f:	e8 93 fb ff ff       	call   801407 <dev_lookup>
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 33                	js     8018ae <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801882:	74 2f                	je     8018b3 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801884:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801887:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80188e:	00 00 00 
	stat->st_isdir = 0;
  801891:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801898:	00 00 00 
	stat->st_dev = dev;
  80189b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	53                   	push   %ebx
  8018a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a8:	ff 50 14             	call   *0x14(%eax)
  8018ab:	83 c4 10             	add    $0x10,%esp
}
  8018ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b8:	eb f4                	jmp    8018ae <fstat+0x6c>

008018ba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	e8 fb 01 00 00       	call   801acb <open>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 1b                	js     8018f4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	50                   	push   %eax
  8018e0:	e8 5d ff ff ff       	call   801842 <fstat>
  8018e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8018e7:	89 1c 24             	mov    %ebx,(%esp)
  8018ea:	e8 fd fb ff ff       	call   8014ec <close>
	return r;
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	89 f3                	mov    %esi,%ebx
}
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    

008018fd <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	89 c6                	mov    %eax,%esi
  801904:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801906:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80190d:	74 27                	je     801936 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80190f:	6a 07                	push   $0x7
  801911:	68 00 50 80 00       	push   $0x805000
  801916:	56                   	push   %esi
  801917:	ff 35 00 40 80 00    	pushl  0x804000
  80191d:	e8 75 f9 ff ff       	call   801297 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801922:	83 c4 0c             	add    $0xc,%esp
  801925:	6a 00                	push   $0x0
  801927:	53                   	push   %ebx
  801928:	6a 00                	push   $0x0
  80192a:	e8 fb f8 ff ff       	call   80122a <ipc_recv>
}
  80192f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801936:	83 ec 0c             	sub    $0xc,%esp
  801939:	6a 01                	push   $0x1
  80193b:	e8 b1 f9 ff ff       	call   8012f1 <ipc_find_env>
  801940:	a3 00 40 80 00       	mov    %eax,0x804000
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	eb c5                	jmp    80190f <fsipc+0x12>

0080194a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80194a:	f3 0f 1e fb          	endbr32 
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 40 0c             	mov    0xc(%eax),%eax
  80195a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	b8 02 00 00 00       	mov    $0x2,%eax
  801971:	e8 87 ff ff ff       	call   8018fd <fsipc>
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <devfile_flush>:
{
  801978:	f3 0f 1e fb          	endbr32 
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 40 0c             	mov    0xc(%eax),%eax
  801988:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	b8 06 00 00 00       	mov    $0x6,%eax
  801997:	e8 61 ff ff ff       	call   8018fd <fsipc>
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <devfile_stat>:
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bc:	b8 05 00 00 00       	mov    $0x5,%eax
  8019c1:	e8 37 ff ff ff       	call   8018fd <fsipc>
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 2c                	js     8019f6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019ca:	83 ec 08             	sub    $0x8,%esp
  8019cd:	68 00 50 80 00       	push   $0x805000
  8019d2:	53                   	push   %ebx
  8019d3:	e8 df ee ff ff       	call   8008b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d8:	a1 80 50 80 00       	mov    0x805080,%eax
  8019dd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019e3:	a1 84 50 80 00       	mov    0x805084,%eax
  8019e8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <devfile_write>:
{
  8019fb:	f3 0f 1e fb          	endbr32 
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a0d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a12:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a15:	8b 55 08             	mov    0x8(%ebp),%edx
  801a18:	8b 52 0c             	mov    0xc(%edx),%edx
  801a1b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801a21:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801a26:	50                   	push   %eax
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	68 08 50 80 00       	push   $0x805008
  801a2f:	e8 39 f0 ff ff       	call   800a6d <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a34:	ba 00 00 00 00       	mov    $0x0,%edx
  801a39:	b8 04 00 00 00       	mov    $0x4,%eax
  801a3e:	e8 ba fe ff ff       	call   8018fd <fsipc>
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <devfile_read>:
{
  801a45:	f3 0f 1e fb          	endbr32 
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
  801a4e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	8b 40 0c             	mov    0xc(%eax),%eax
  801a57:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a5c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	b8 03 00 00 00       	mov    $0x3,%eax
  801a6c:	e8 8c fe ff ff       	call   8018fd <fsipc>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 1f                	js     801a96 <devfile_read+0x51>
	assert(r <= n);
  801a77:	39 f0                	cmp    %esi,%eax
  801a79:	77 24                	ja     801a9f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a7b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a80:	7f 33                	jg     801ab5 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	50                   	push   %eax
  801a86:	68 00 50 80 00       	push   $0x805000
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	e8 da ef ff ff       	call   800a6d <memmove>
	return r;
  801a93:	83 c4 10             	add    $0x10,%esp
}
  801a96:	89 d8                	mov    %ebx,%eax
  801a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    
	assert(r <= n);
  801a9f:	68 f8 29 80 00       	push   $0x8029f8
  801aa4:	68 ff 29 80 00       	push   $0x8029ff
  801aa9:	6a 7d                	push   $0x7d
  801aab:	68 14 2a 80 00       	push   $0x802a14
  801ab0:	e8 be 05 00 00       	call   802073 <_panic>
	assert(r <= PGSIZE);
  801ab5:	68 1f 2a 80 00       	push   $0x802a1f
  801aba:	68 ff 29 80 00       	push   $0x8029ff
  801abf:	6a 7e                	push   $0x7e
  801ac1:	68 14 2a 80 00       	push   $0x802a14
  801ac6:	e8 a8 05 00 00       	call   802073 <_panic>

00801acb <open>:
{
  801acb:	f3 0f 1e fb          	endbr32 
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ada:	56                   	push   %esi
  801adb:	e8 94 ed ff ff       	call   800874 <strlen>
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae8:	7f 6c                	jg     801b56 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af0:	50                   	push   %eax
  801af1:	e8 67 f8 ff ff       	call   80135d <fd_alloc>
  801af6:	89 c3                	mov    %eax,%ebx
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 3c                	js     801b3b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	56                   	push   %esi
  801b03:	68 00 50 80 00       	push   $0x805000
  801b08:	e8 aa ed ff ff       	call   8008b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b18:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1d:	e8 db fd ff ff       	call   8018fd <fsipc>
  801b22:	89 c3                	mov    %eax,%ebx
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 19                	js     801b44 <open+0x79>
	return fd2num(fd);
  801b2b:	83 ec 0c             	sub    $0xc,%esp
  801b2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b31:	e8 f8 f7 ff ff       	call   80132e <fd2num>
  801b36:	89 c3                	mov    %eax,%ebx
  801b38:	83 c4 10             	add    $0x10,%esp
}
  801b3b:	89 d8                	mov    %ebx,%eax
  801b3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b40:	5b                   	pop    %ebx
  801b41:	5e                   	pop    %esi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    
		fd_close(fd, 0);
  801b44:	83 ec 08             	sub    $0x8,%esp
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4c:	e8 10 f9 ff ff       	call   801461 <fd_close>
		return r;
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	eb e5                	jmp    801b3b <open+0x70>
		return -E_BAD_PATH;
  801b56:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b5b:	eb de                	jmp    801b3b <open+0x70>

00801b5d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b5d:	f3 0f 1e fb          	endbr32 
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b67:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b71:	e8 87 fd ff ff       	call   8018fd <fsipc>
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b78:	f3 0f 1e fb          	endbr32 
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
  801b81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	e8 b3 f7 ff ff       	call   801342 <fd2data>
  801b8f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b91:	83 c4 08             	add    $0x8,%esp
  801b94:	68 2b 2a 80 00       	push   $0x802a2b
  801b99:	53                   	push   %ebx
  801b9a:	e8 18 ed ff ff       	call   8008b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b9f:	8b 46 04             	mov    0x4(%esi),%eax
  801ba2:	2b 06                	sub    (%esi),%eax
  801ba4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801baa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bb1:	00 00 00 
	stat->st_dev = &devpipe;
  801bb4:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801bbb:	30 80 00 
	return 0;
}
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    

00801bca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bca:	f3 0f 1e fb          	endbr32 
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bd8:	53                   	push   %ebx
  801bd9:	6a 00                	push   $0x0
  801bdb:	e8 a6 f1 ff ff       	call   800d86 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801be0:	89 1c 24             	mov    %ebx,(%esp)
  801be3:	e8 5a f7 ff ff       	call   801342 <fd2data>
  801be8:	83 c4 08             	add    $0x8,%esp
  801beb:	50                   	push   %eax
  801bec:	6a 00                	push   $0x0
  801bee:	e8 93 f1 ff ff       	call   800d86 <sys_page_unmap>
}
  801bf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <_pipeisclosed>:
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	57                   	push   %edi
  801bfc:	56                   	push   %esi
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 1c             	sub    $0x1c,%esp
  801c01:	89 c7                	mov    %eax,%edi
  801c03:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c05:	a1 04 40 80 00       	mov    0x804004,%eax
  801c0a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c0d:	83 ec 0c             	sub    $0xc,%esp
  801c10:	57                   	push   %edi
  801c11:	e8 47 05 00 00       	call   80215d <pageref>
  801c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c19:	89 34 24             	mov    %esi,(%esp)
  801c1c:	e8 3c 05 00 00       	call   80215d <pageref>
		nn = thisenv->env_runs;
  801c21:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c27:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	39 cb                	cmp    %ecx,%ebx
  801c2f:	74 1b                	je     801c4c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c31:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c34:	75 cf                	jne    801c05 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c36:	8b 42 58             	mov    0x58(%edx),%eax
  801c39:	6a 01                	push   $0x1
  801c3b:	50                   	push   %eax
  801c3c:	53                   	push   %ebx
  801c3d:	68 32 2a 80 00       	push   $0x802a32
  801c42:	e8 66 e6 ff ff       	call   8002ad <cprintf>
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	eb b9                	jmp    801c05 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c4c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c4f:	0f 94 c0             	sete   %al
  801c52:	0f b6 c0             	movzbl %al,%eax
}
  801c55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5f                   	pop    %edi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <devpipe_write>:
{
  801c5d:	f3 0f 1e fb          	endbr32 
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	57                   	push   %edi
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	83 ec 28             	sub    $0x28,%esp
  801c6a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c6d:	56                   	push   %esi
  801c6e:	e8 cf f6 ff ff       	call   801342 <fd2data>
  801c73:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c80:	74 4f                	je     801cd1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c82:	8b 43 04             	mov    0x4(%ebx),%eax
  801c85:	8b 0b                	mov    (%ebx),%ecx
  801c87:	8d 51 20             	lea    0x20(%ecx),%edx
  801c8a:	39 d0                	cmp    %edx,%eax
  801c8c:	72 14                	jb     801ca2 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c8e:	89 da                	mov    %ebx,%edx
  801c90:	89 f0                	mov    %esi,%eax
  801c92:	e8 61 ff ff ff       	call   801bf8 <_pipeisclosed>
  801c97:	85 c0                	test   %eax,%eax
  801c99:	75 3b                	jne    801cd6 <devpipe_write+0x79>
			sys_yield();
  801c9b:	e8 36 f0 ff ff       	call   800cd6 <sys_yield>
  801ca0:	eb e0                	jmp    801c82 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ca9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cac:	89 c2                	mov    %eax,%edx
  801cae:	c1 fa 1f             	sar    $0x1f,%edx
  801cb1:	89 d1                	mov    %edx,%ecx
  801cb3:	c1 e9 1b             	shr    $0x1b,%ecx
  801cb6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cb9:	83 e2 1f             	and    $0x1f,%edx
  801cbc:	29 ca                	sub    %ecx,%edx
  801cbe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cc2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cc6:	83 c0 01             	add    $0x1,%eax
  801cc9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ccc:	83 c7 01             	add    $0x1,%edi
  801ccf:	eb ac                	jmp    801c7d <devpipe_write+0x20>
	return i;
  801cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd4:	eb 05                	jmp    801cdb <devpipe_write+0x7e>
				return 0;
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cde:	5b                   	pop    %ebx
  801cdf:	5e                   	pop    %esi
  801ce0:	5f                   	pop    %edi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <devpipe_read>:
{
  801ce3:	f3 0f 1e fb          	endbr32 
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	57                   	push   %edi
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 18             	sub    $0x18,%esp
  801cf0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cf3:	57                   	push   %edi
  801cf4:	e8 49 f6 ff ff       	call   801342 <fd2data>
  801cf9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	be 00 00 00 00       	mov    $0x0,%esi
  801d03:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d06:	75 14                	jne    801d1c <devpipe_read+0x39>
	return i;
  801d08:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0b:	eb 02                	jmp    801d0f <devpipe_read+0x2c>
				return i;
  801d0d:	89 f0                	mov    %esi,%eax
}
  801d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d12:	5b                   	pop    %ebx
  801d13:	5e                   	pop    %esi
  801d14:	5f                   	pop    %edi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    
			sys_yield();
  801d17:	e8 ba ef ff ff       	call   800cd6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d1c:	8b 03                	mov    (%ebx),%eax
  801d1e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d21:	75 18                	jne    801d3b <devpipe_read+0x58>
			if (i > 0)
  801d23:	85 f6                	test   %esi,%esi
  801d25:	75 e6                	jne    801d0d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d27:	89 da                	mov    %ebx,%edx
  801d29:	89 f8                	mov    %edi,%eax
  801d2b:	e8 c8 fe ff ff       	call   801bf8 <_pipeisclosed>
  801d30:	85 c0                	test   %eax,%eax
  801d32:	74 e3                	je     801d17 <devpipe_read+0x34>
				return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	eb d4                	jmp    801d0f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d3b:	99                   	cltd   
  801d3c:	c1 ea 1b             	shr    $0x1b,%edx
  801d3f:	01 d0                	add    %edx,%eax
  801d41:	83 e0 1f             	and    $0x1f,%eax
  801d44:	29 d0                	sub    %edx,%eax
  801d46:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d4e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d51:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d54:	83 c6 01             	add    $0x1,%esi
  801d57:	eb aa                	jmp    801d03 <devpipe_read+0x20>

00801d59 <pipe>:
{
  801d59:	f3 0f 1e fb          	endbr32 
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	56                   	push   %esi
  801d61:	53                   	push   %ebx
  801d62:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d68:	50                   	push   %eax
  801d69:	e8 ef f5 ff ff       	call   80135d <fd_alloc>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	85 c0                	test   %eax,%eax
  801d75:	0f 88 23 01 00 00    	js     801e9e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	68 07 04 00 00       	push   $0x407
  801d83:	ff 75 f4             	pushl  -0xc(%ebp)
  801d86:	6a 00                	push   $0x0
  801d88:	e8 6c ef ff ff       	call   800cf9 <sys_page_alloc>
  801d8d:	89 c3                	mov    %eax,%ebx
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	85 c0                	test   %eax,%eax
  801d94:	0f 88 04 01 00 00    	js     801e9e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801da0:	50                   	push   %eax
  801da1:	e8 b7 f5 ff ff       	call   80135d <fd_alloc>
  801da6:	89 c3                	mov    %eax,%ebx
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	0f 88 db 00 00 00    	js     801e8e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	68 07 04 00 00       	push   $0x407
  801dbb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dbe:	6a 00                	push   $0x0
  801dc0:	e8 34 ef ff ff       	call   800cf9 <sys_page_alloc>
  801dc5:	89 c3                	mov    %eax,%ebx
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	0f 88 bc 00 00 00    	js     801e8e <pipe+0x135>
	va = fd2data(fd0);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd8:	e8 65 f5 ff ff       	call   801342 <fd2data>
  801ddd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ddf:	83 c4 0c             	add    $0xc,%esp
  801de2:	68 07 04 00 00       	push   $0x407
  801de7:	50                   	push   %eax
  801de8:	6a 00                	push   $0x0
  801dea:	e8 0a ef ff ff       	call   800cf9 <sys_page_alloc>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	85 c0                	test   %eax,%eax
  801df6:	0f 88 82 00 00 00    	js     801e7e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	ff 75 f0             	pushl  -0x10(%ebp)
  801e02:	e8 3b f5 ff ff       	call   801342 <fd2data>
  801e07:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e0e:	50                   	push   %eax
  801e0f:	6a 00                	push   $0x0
  801e11:	56                   	push   %esi
  801e12:	6a 00                	push   $0x0
  801e14:	e8 27 ef ff ff       	call   800d40 <sys_page_map>
  801e19:	89 c3                	mov    %eax,%ebx
  801e1b:	83 c4 20             	add    $0x20,%esp
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	78 4e                	js     801e70 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e22:	a1 28 30 80 00       	mov    0x803028,%eax
  801e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e39:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4b:	e8 de f4 ff ff       	call   80132e <fd2num>
  801e50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e53:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e55:	83 c4 04             	add    $0x4,%esp
  801e58:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5b:	e8 ce f4 ff ff       	call   80132e <fd2num>
  801e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e63:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e6e:	eb 2e                	jmp    801e9e <pipe+0x145>
	sys_page_unmap(0, va);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	56                   	push   %esi
  801e74:	6a 00                	push   $0x0
  801e76:	e8 0b ef ff ff       	call   800d86 <sys_page_unmap>
  801e7b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e7e:	83 ec 08             	sub    $0x8,%esp
  801e81:	ff 75 f0             	pushl  -0x10(%ebp)
  801e84:	6a 00                	push   $0x0
  801e86:	e8 fb ee ff ff       	call   800d86 <sys_page_unmap>
  801e8b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e8e:	83 ec 08             	sub    $0x8,%esp
  801e91:	ff 75 f4             	pushl  -0xc(%ebp)
  801e94:	6a 00                	push   $0x0
  801e96:	e8 eb ee ff ff       	call   800d86 <sys_page_unmap>
  801e9b:	83 c4 10             	add    $0x10,%esp
}
  801e9e:	89 d8                	mov    %ebx,%eax
  801ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea3:	5b                   	pop    %ebx
  801ea4:	5e                   	pop    %esi
  801ea5:	5d                   	pop    %ebp
  801ea6:	c3                   	ret    

00801ea7 <pipeisclosed>:
{
  801ea7:	f3 0f 1e fb          	endbr32 
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	50                   	push   %eax
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 f6 f4 ff ff       	call   8013b3 <fd_lookup>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 18                	js     801edc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eca:	e8 73 f4 ff ff       	call   801342 <fd2data>
  801ecf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	e8 1f fd ff ff       	call   801bf8 <_pipeisclosed>
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ede:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	c3                   	ret    

00801ee8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ef2:	68 4a 2a 80 00       	push   $0x802a4a
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	e8 b8 e9 ff ff       	call   8008b7 <strcpy>
	return 0;
}
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <devcons_write>:
{
  801f06:	f3 0f 1e fb          	endbr32 
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	57                   	push   %edi
  801f0e:	56                   	push   %esi
  801f0f:	53                   	push   %ebx
  801f10:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f16:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f1b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f21:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f24:	73 31                	jae    801f57 <devcons_write+0x51>
		m = n - tot;
  801f26:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f29:	29 f3                	sub    %esi,%ebx
  801f2b:	83 fb 7f             	cmp    $0x7f,%ebx
  801f2e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f33:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	53                   	push   %ebx
  801f3a:	89 f0                	mov    %esi,%eax
  801f3c:	03 45 0c             	add    0xc(%ebp),%eax
  801f3f:	50                   	push   %eax
  801f40:	57                   	push   %edi
  801f41:	e8 27 eb ff ff       	call   800a6d <memmove>
		sys_cputs(buf, m);
  801f46:	83 c4 08             	add    $0x8,%esp
  801f49:	53                   	push   %ebx
  801f4a:	57                   	push   %edi
  801f4b:	e8 d9 ec ff ff       	call   800c29 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f50:	01 de                	add    %ebx,%esi
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	eb ca                	jmp    801f21 <devcons_write+0x1b>
}
  801f57:	89 f0                	mov    %esi,%eax
  801f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5c:	5b                   	pop    %ebx
  801f5d:	5e                   	pop    %esi
  801f5e:	5f                   	pop    %edi
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    

00801f61 <devcons_read>:
{
  801f61:	f3 0f 1e fb          	endbr32 
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f74:	74 21                	je     801f97 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f76:	e8 d0 ec ff ff       	call   800c4b <sys_cgetc>
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	75 07                	jne    801f86 <devcons_read+0x25>
		sys_yield();
  801f7f:	e8 52 ed ff ff       	call   800cd6 <sys_yield>
  801f84:	eb f0                	jmp    801f76 <devcons_read+0x15>
	if (c < 0)
  801f86:	78 0f                	js     801f97 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f88:	83 f8 04             	cmp    $0x4,%eax
  801f8b:	74 0c                	je     801f99 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f90:	88 02                	mov    %al,(%edx)
	return 1;
  801f92:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    
		return 0;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	eb f7                	jmp    801f97 <devcons_read+0x36>

00801fa0 <cputchar>:
{
  801fa0:	f3 0f 1e fb          	endbr32 
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fb0:	6a 01                	push   $0x1
  801fb2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb5:	50                   	push   %eax
  801fb6:	e8 6e ec ff ff       	call   800c29 <sys_cputs>
}
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <getchar>:
{
  801fc0:	f3 0f 1e fb          	endbr32 
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fca:	6a 01                	push   $0x1
  801fcc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fcf:	50                   	push   %eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	e8 5f f6 ff ff       	call   801636 <read>
	if (r < 0)
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 06                	js     801fe4 <getchar+0x24>
	if (r < 1)
  801fde:	74 06                	je     801fe6 <getchar+0x26>
	return c;
  801fe0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    
		return -E_EOF;
  801fe6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801feb:	eb f7                	jmp    801fe4 <getchar+0x24>

00801fed <iscons>:
{
  801fed:	f3 0f 1e fb          	endbr32 
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffa:	50                   	push   %eax
  801ffb:	ff 75 08             	pushl  0x8(%ebp)
  801ffe:	e8 b0 f3 ff ff       	call   8013b3 <fd_lookup>
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	85 c0                	test   %eax,%eax
  802008:	78 11                	js     80201b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 15 44 30 80 00    	mov    0x803044,%edx
  802013:	39 10                	cmp    %edx,(%eax)
  802015:	0f 94 c0             	sete   %al
  802018:	0f b6 c0             	movzbl %al,%eax
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <opencons>:
{
  80201d:	f3 0f 1e fb          	endbr32 
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802027:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202a:	50                   	push   %eax
  80202b:	e8 2d f3 ff ff       	call   80135d <fd_alloc>
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	85 c0                	test   %eax,%eax
  802035:	78 3a                	js     802071 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	68 07 04 00 00       	push   $0x407
  80203f:	ff 75 f4             	pushl  -0xc(%ebp)
  802042:	6a 00                	push   $0x0
  802044:	e8 b0 ec ff ff       	call   800cf9 <sys_page_alloc>
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 21                	js     802071 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 15 44 30 80 00    	mov    0x803044,%edx
  802059:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	50                   	push   %eax
  802069:	e8 c0 f2 ff ff       	call   80132e <fd2num>
  80206e:	83 c4 10             	add    $0x10,%esp
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802073:	f3 0f 1e fb          	endbr32 
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	56                   	push   %esi
  80207b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80207c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80207f:	8b 35 08 30 80 00    	mov    0x803008,%esi
  802085:	e8 29 ec ff ff       	call   800cb3 <sys_getenvid>
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	56                   	push   %esi
  802094:	50                   	push   %eax
  802095:	68 58 2a 80 00       	push   $0x802a58
  80209a:	e8 0e e2 ff ff       	call   8002ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80209f:	83 c4 18             	add    $0x18,%esp
  8020a2:	53                   	push   %ebx
  8020a3:	ff 75 10             	pushl  0x10(%ebp)
  8020a6:	e8 ad e1 ff ff       	call   800258 <vcprintf>
	cprintf("\n");
  8020ab:	c7 04 24 43 2a 80 00 	movl   $0x802a43,(%esp)
  8020b2:	e8 f6 e1 ff ff       	call   8002ad <cprintf>
  8020b7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020ba:	cc                   	int3   
  8020bb:	eb fd                	jmp    8020ba <_panic+0x47>

008020bd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020bd:	f3 0f 1e fb          	endbr32 
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	53                   	push   %ebx
  8020c5:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020c8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020cf:	74 0d                	je     8020de <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8020d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    
		envid_t envid=sys_getenvid();
  8020de:	e8 d0 eb ff ff       	call   800cb3 <sys_getenvid>
  8020e3:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8020e5:	83 ec 04             	sub    $0x4,%esp
  8020e8:	6a 07                	push   $0x7
  8020ea:	68 00 f0 bf ee       	push   $0xeebff000
  8020ef:	50                   	push   %eax
  8020f0:	e8 04 ec ff ff       	call   800cf9 <sys_page_alloc>
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	78 29                	js     802125 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	68 39 21 80 00       	push   $0x802139
  802104:	53                   	push   %ebx
  802105:	e8 4e ed ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	85 c0                	test   %eax,%eax
  80210f:	79 c0                	jns    8020d1 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	68 a8 2a 80 00       	push   $0x802aa8
  802119:	6a 24                	push   $0x24
  80211b:	68 df 2a 80 00       	push   $0x802adf
  802120:	e8 4e ff ff ff       	call   802073 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 7c 2a 80 00       	push   $0x802a7c
  80212d:	6a 22                	push   $0x22
  80212f:	68 df 2a 80 00       	push   $0x802adf
  802134:	e8 3a ff ff ff       	call   802073 <_panic>

00802139 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802139:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80213a:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  80213f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802141:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  802144:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  802147:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  80214b:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  802150:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  802154:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802156:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802157:	83 c4 04             	add    $0x4,%esp
	popfl
  80215a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80215b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80215c:	c3                   	ret    

0080215d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80215d:	f3 0f 1e fb          	endbr32 
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802167:	89 c2                	mov    %eax,%edx
  802169:	c1 ea 16             	shr    $0x16,%edx
  80216c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802173:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802178:	f6 c1 01             	test   $0x1,%cl
  80217b:	74 1c                	je     802199 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80217d:	c1 e8 0c             	shr    $0xc,%eax
  802180:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802187:	a8 01                	test   $0x1,%al
  802189:	74 0e                	je     802199 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80218b:	c1 e8 0c             	shr    $0xc,%eax
  80218e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802195:	ef 
  802196:	0f b7 d2             	movzwl %dx,%edx
}
  802199:	89 d0                	mov    %edx,%eax
  80219b:	5d                   	pop    %ebp
  80219c:	c3                   	ret    
  80219d:	66 90                	xchg   %ax,%ax
  80219f:	90                   	nop

008021a0 <__udivdi3>:
  8021a0:	f3 0f 1e fb          	endbr32 
  8021a4:	55                   	push   %ebp
  8021a5:	57                   	push   %edi
  8021a6:	56                   	push   %esi
  8021a7:	53                   	push   %ebx
  8021a8:	83 ec 1c             	sub    $0x1c,%esp
  8021ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021bb:	85 d2                	test   %edx,%edx
  8021bd:	75 19                	jne    8021d8 <__udivdi3+0x38>
  8021bf:	39 f3                	cmp    %esi,%ebx
  8021c1:	76 4d                	jbe    802210 <__udivdi3+0x70>
  8021c3:	31 ff                	xor    %edi,%edi
  8021c5:	89 e8                	mov    %ebp,%eax
  8021c7:	89 f2                	mov    %esi,%edx
  8021c9:	f7 f3                	div    %ebx
  8021cb:	89 fa                	mov    %edi,%edx
  8021cd:	83 c4 1c             	add    $0x1c,%esp
  8021d0:	5b                   	pop    %ebx
  8021d1:	5e                   	pop    %esi
  8021d2:	5f                   	pop    %edi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    
  8021d5:	8d 76 00             	lea    0x0(%esi),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	76 14                	jbe    8021f0 <__udivdi3+0x50>
  8021dc:	31 ff                	xor    %edi,%edi
  8021de:	31 c0                	xor    %eax,%eax
  8021e0:	89 fa                	mov    %edi,%edx
  8021e2:	83 c4 1c             	add    $0x1c,%esp
  8021e5:	5b                   	pop    %ebx
  8021e6:	5e                   	pop    %esi
  8021e7:	5f                   	pop    %edi
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    
  8021ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f0:	0f bd fa             	bsr    %edx,%edi
  8021f3:	83 f7 1f             	xor    $0x1f,%edi
  8021f6:	75 48                	jne    802240 <__udivdi3+0xa0>
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	72 06                	jb     802202 <__udivdi3+0x62>
  8021fc:	31 c0                	xor    %eax,%eax
  8021fe:	39 eb                	cmp    %ebp,%ebx
  802200:	77 de                	ja     8021e0 <__udivdi3+0x40>
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	eb d7                	jmp    8021e0 <__udivdi3+0x40>
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	89 d9                	mov    %ebx,%ecx
  802212:	85 db                	test   %ebx,%ebx
  802214:	75 0b                	jne    802221 <__udivdi3+0x81>
  802216:	b8 01 00 00 00       	mov    $0x1,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	f7 f3                	div    %ebx
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	31 d2                	xor    %edx,%edx
  802223:	89 f0                	mov    %esi,%eax
  802225:	f7 f1                	div    %ecx
  802227:	89 c6                	mov    %eax,%esi
  802229:	89 e8                	mov    %ebp,%eax
  80222b:	89 f7                	mov    %esi,%edi
  80222d:	f7 f1                	div    %ecx
  80222f:	89 fa                	mov    %edi,%edx
  802231:	83 c4 1c             	add    $0x1c,%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	89 f9                	mov    %edi,%ecx
  802242:	b8 20 00 00 00       	mov    $0x20,%eax
  802247:	29 f8                	sub    %edi,%eax
  802249:	d3 e2                	shl    %cl,%edx
  80224b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80224f:	89 c1                	mov    %eax,%ecx
  802251:	89 da                	mov    %ebx,%edx
  802253:	d3 ea                	shr    %cl,%edx
  802255:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802259:	09 d1                	or     %edx,%ecx
  80225b:	89 f2                	mov    %esi,%edx
  80225d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802261:	89 f9                	mov    %edi,%ecx
  802263:	d3 e3                	shl    %cl,%ebx
  802265:	89 c1                	mov    %eax,%ecx
  802267:	d3 ea                	shr    %cl,%edx
  802269:	89 f9                	mov    %edi,%ecx
  80226b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80226f:	89 eb                	mov    %ebp,%ebx
  802271:	d3 e6                	shl    %cl,%esi
  802273:	89 c1                	mov    %eax,%ecx
  802275:	d3 eb                	shr    %cl,%ebx
  802277:	09 de                	or     %ebx,%esi
  802279:	89 f0                	mov    %esi,%eax
  80227b:	f7 74 24 08          	divl   0x8(%esp)
  80227f:	89 d6                	mov    %edx,%esi
  802281:	89 c3                	mov    %eax,%ebx
  802283:	f7 64 24 0c          	mull   0xc(%esp)
  802287:	39 d6                	cmp    %edx,%esi
  802289:	72 15                	jb     8022a0 <__udivdi3+0x100>
  80228b:	89 f9                	mov    %edi,%ecx
  80228d:	d3 e5                	shl    %cl,%ebp
  80228f:	39 c5                	cmp    %eax,%ebp
  802291:	73 04                	jae    802297 <__udivdi3+0xf7>
  802293:	39 d6                	cmp    %edx,%esi
  802295:	74 09                	je     8022a0 <__udivdi3+0x100>
  802297:	89 d8                	mov    %ebx,%eax
  802299:	31 ff                	xor    %edi,%edi
  80229b:	e9 40 ff ff ff       	jmp    8021e0 <__udivdi3+0x40>
  8022a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022a3:	31 ff                	xor    %edi,%edi
  8022a5:	e9 36 ff ff ff       	jmp    8021e0 <__udivdi3+0x40>
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__umoddi3>:
  8022b0:	f3 0f 1e fb          	endbr32 
  8022b4:	55                   	push   %ebp
  8022b5:	57                   	push   %edi
  8022b6:	56                   	push   %esi
  8022b7:	53                   	push   %ebx
  8022b8:	83 ec 1c             	sub    $0x1c,%esp
  8022bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 19                	jne    8022e8 <__umoddi3+0x38>
  8022cf:	39 df                	cmp    %ebx,%edi
  8022d1:	76 5d                	jbe    802330 <__umoddi3+0x80>
  8022d3:	89 f0                	mov    %esi,%eax
  8022d5:	89 da                	mov    %ebx,%edx
  8022d7:	f7 f7                	div    %edi
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	83 c4 1c             	add    $0x1c,%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5e                   	pop    %esi
  8022e2:	5f                   	pop    %edi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    
  8022e5:	8d 76 00             	lea    0x0(%esi),%esi
  8022e8:	89 f2                	mov    %esi,%edx
  8022ea:	39 d8                	cmp    %ebx,%eax
  8022ec:	76 12                	jbe    802300 <__umoddi3+0x50>
  8022ee:	89 f0                	mov    %esi,%eax
  8022f0:	89 da                	mov    %ebx,%edx
  8022f2:	83 c4 1c             	add    $0x1c,%esp
  8022f5:	5b                   	pop    %ebx
  8022f6:	5e                   	pop    %esi
  8022f7:	5f                   	pop    %edi
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    
  8022fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802300:	0f bd e8             	bsr    %eax,%ebp
  802303:	83 f5 1f             	xor    $0x1f,%ebp
  802306:	75 50                	jne    802358 <__umoddi3+0xa8>
  802308:	39 d8                	cmp    %ebx,%eax
  80230a:	0f 82 e0 00 00 00    	jb     8023f0 <__umoddi3+0x140>
  802310:	89 d9                	mov    %ebx,%ecx
  802312:	39 f7                	cmp    %esi,%edi
  802314:	0f 86 d6 00 00 00    	jbe    8023f0 <__umoddi3+0x140>
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	89 ca                	mov    %ecx,%edx
  80231e:	83 c4 1c             	add    $0x1c,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5f                   	pop    %edi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80232d:	8d 76 00             	lea    0x0(%esi),%esi
  802330:	89 fd                	mov    %edi,%ebp
  802332:	85 ff                	test   %edi,%edi
  802334:	75 0b                	jne    802341 <__umoddi3+0x91>
  802336:	b8 01 00 00 00       	mov    $0x1,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	f7 f7                	div    %edi
  80233f:	89 c5                	mov    %eax,%ebp
  802341:	89 d8                	mov    %ebx,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 f5                	div    %ebp
  802347:	89 f0                	mov    %esi,%eax
  802349:	f7 f5                	div    %ebp
  80234b:	89 d0                	mov    %edx,%eax
  80234d:	31 d2                	xor    %edx,%edx
  80234f:	eb 8c                	jmp    8022dd <__umoddi3+0x2d>
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 e9                	mov    %ebp,%ecx
  80235a:	ba 20 00 00 00       	mov    $0x20,%edx
  80235f:	29 ea                	sub    %ebp,%edx
  802361:	d3 e0                	shl    %cl,%eax
  802363:	89 44 24 08          	mov    %eax,0x8(%esp)
  802367:	89 d1                	mov    %edx,%ecx
  802369:	89 f8                	mov    %edi,%eax
  80236b:	d3 e8                	shr    %cl,%eax
  80236d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802371:	89 54 24 04          	mov    %edx,0x4(%esp)
  802375:	8b 54 24 04          	mov    0x4(%esp),%edx
  802379:	09 c1                	or     %eax,%ecx
  80237b:	89 d8                	mov    %ebx,%eax
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 e9                	mov    %ebp,%ecx
  802383:	d3 e7                	shl    %cl,%edi
  802385:	89 d1                	mov    %edx,%ecx
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80238f:	d3 e3                	shl    %cl,%ebx
  802391:	89 c7                	mov    %eax,%edi
  802393:	89 d1                	mov    %edx,%ecx
  802395:	89 f0                	mov    %esi,%eax
  802397:	d3 e8                	shr    %cl,%eax
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	89 fa                	mov    %edi,%edx
  80239d:	d3 e6                	shl    %cl,%esi
  80239f:	09 d8                	or     %ebx,%eax
  8023a1:	f7 74 24 08          	divl   0x8(%esp)
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	89 f3                	mov    %esi,%ebx
  8023a9:	f7 64 24 0c          	mull   0xc(%esp)
  8023ad:	89 c6                	mov    %eax,%esi
  8023af:	89 d7                	mov    %edx,%edi
  8023b1:	39 d1                	cmp    %edx,%ecx
  8023b3:	72 06                	jb     8023bb <__umoddi3+0x10b>
  8023b5:	75 10                	jne    8023c7 <__umoddi3+0x117>
  8023b7:	39 c3                	cmp    %eax,%ebx
  8023b9:	73 0c                	jae    8023c7 <__umoddi3+0x117>
  8023bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023c3:	89 d7                	mov    %edx,%edi
  8023c5:	89 c6                	mov    %eax,%esi
  8023c7:	89 ca                	mov    %ecx,%edx
  8023c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ce:	29 f3                	sub    %esi,%ebx
  8023d0:	19 fa                	sbb    %edi,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	d3 e0                	shl    %cl,%eax
  8023d6:	89 e9                	mov    %ebp,%ecx
  8023d8:	d3 eb                	shr    %cl,%ebx
  8023da:	d3 ea                	shr    %cl,%edx
  8023dc:	09 d8                	or     %ebx,%eax
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	29 fe                	sub    %edi,%esi
  8023f2:	19 c3                	sbb    %eax,%ebx
  8023f4:	89 f2                	mov    %esi,%edx
  8023f6:	89 d9                	mov    %ebx,%ecx
  8023f8:	e9 1d ff ff ff       	jmp    80231a <__umoddi3+0x6a>
