
obj/user/primespipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 08 02 00 00       	call   800239 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800043:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800046:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800049:	eb 5e                	jmp    8000a9 <primeproc+0x76>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	85 c0                	test   %eax,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	0f 4e d0             	cmovle %eax,%edx
  800058:	52                   	push   %edx
  800059:	50                   	push   %eax
  80005a:	68 a0 24 80 00       	push   $0x8024a0
  80005f:	6a 15                	push   $0x15
  800061:	68 cf 24 80 00       	push   $0x8024cf
  800066:	e8 36 02 00 00       	call   8002a1 <_panic>
		panic("pipe: %e", i);
  80006b:	50                   	push   %eax
  80006c:	68 e5 24 80 00       	push   $0x8024e5
  800071:	6a 1b                	push   $0x1b
  800073:	68 cf 24 80 00       	push   $0x8024cf
  800078:	e8 24 02 00 00       	call   8002a1 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  80007d:	50                   	push   %eax
  80007e:	68 ee 24 80 00       	push   $0x8024ee
  800083:	6a 1d                	push   $0x1d
  800085:	68 cf 24 80 00       	push   $0x8024cf
  80008a:	e8 12 02 00 00       	call   8002a1 <_panic>
	if (id == 0) {
		close(fd);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	53                   	push   %ebx
  800093:	e8 2b 14 00 00       	call   8014c3 <close>
		close(pfd[1]);
  800098:	83 c4 04             	add    $0x4,%esp
  80009b:	ff 75 dc             	pushl  -0x24(%ebp)
  80009e:	e8 20 14 00 00       	call   8014c3 <close>
		fd = pfd[0];
  8000a3:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a6:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 e3 15 00 00       	call   801698 <readn>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	83 f8 04             	cmp    $0x4,%eax
  8000bb:	75 8e                	jne    80004b <primeproc+0x18>
	cprintf("%d\n", p);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	68 e1 24 80 00       	push   $0x8024e1
  8000c8:	e8 bb 02 00 00       	call   800388 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000cd:	89 3c 24             	mov    %edi,(%esp)
  8000d0:	e8 5b 1c 00 00       	call   801d30 <pipe>
  8000d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	78 8c                	js     80006b <primeproc+0x38>
	if ((id = fork()) < 0)
  8000df:	e8 e4 0f 00 00       	call   8010c8 <fork>
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	78 95                	js     80007d <primeproc+0x4a>
	if (id == 0) {
  8000e8:	74 a5                	je     80008f <primeproc+0x5c>
	}

	close(pfd[0]);
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8000f0:	e8 ce 13 00 00       	call   8014c3 <close>
	wfd = pfd[1];
  8000f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f8:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	6a 04                	push   $0x4
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	e8 8e 15 00 00       	call   801698 <readn>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	83 f8 04             	cmp    $0x4,%eax
  800110:	75 42                	jne    800154 <primeproc+0x121>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800115:	99                   	cltd   
  800116:	f7 7d e0             	idivl  -0x20(%ebp)
  800119:	85 d2                	test   %edx,%edx
  80011b:	74 e1                	je     8000fe <primeproc+0xcb>
			if ((r=write(wfd, &i, 4)) != 4)
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	6a 04                	push   $0x4
  800122:	56                   	push   %esi
  800123:	57                   	push   %edi
  800124:	e8 ba 15 00 00       	call   8016e3 <write>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	83 f8 04             	cmp    $0x4,%eax
  80012f:	74 cd                	je     8000fe <primeproc+0xcb>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800131:	83 ec 08             	sub    $0x8,%esp
  800134:	85 c0                	test   %eax,%eax
  800136:	ba 00 00 00 00       	mov    $0x0,%edx
  80013b:	0f 4e d0             	cmovle %eax,%edx
  80013e:	52                   	push   %edx
  80013f:	50                   	push   %eax
  800140:	ff 75 e0             	pushl  -0x20(%ebp)
  800143:	68 13 25 80 00       	push   $0x802513
  800148:	6a 2e                	push   $0x2e
  80014a:	68 cf 24 80 00       	push   $0x8024cf
  80014f:	e8 4d 01 00 00       	call   8002a1 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	85 c0                	test   %eax,%eax
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	0f 4e d0             	cmovle %eax,%edx
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	53                   	push   %ebx
  800164:	ff 75 e0             	pushl  -0x20(%ebp)
  800167:	68 f7 24 80 00       	push   $0x8024f7
  80016c:	6a 2b                	push   $0x2b
  80016e:	68 cf 24 80 00       	push   $0x8024cf
  800173:	e8 29 01 00 00       	call   8002a1 <_panic>

00800178 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	53                   	push   %ebx
  800180:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  800183:	c7 05 00 30 80 00 2d 	movl   $0x80252d,0x803000
  80018a:	25 80 00 

	if ((i=pipe(p)) < 0)
  80018d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 9a 1b 00 00       	call   801d30 <pipe>
  800196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	85 c0                	test   %eax,%eax
  80019e:	78 21                	js     8001c1 <umain+0x49>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001a0:	e8 23 0f 00 00       	call   8010c8 <fork>
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	78 2a                	js     8001d3 <umain+0x5b>
		panic("fork: %e", id);

	if (id == 0) {
  8001a9:	75 3a                	jne    8001e5 <umain+0x6d>
		close(p[1]);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b1:	e8 0d 13 00 00       	call   8014c3 <close>
		primeproc(p[0]);
  8001b6:	83 c4 04             	add    $0x4,%esp
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 72 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001c1:	50                   	push   %eax
  8001c2:	68 e5 24 80 00       	push   $0x8024e5
  8001c7:	6a 3a                	push   $0x3a
  8001c9:	68 cf 24 80 00       	push   $0x8024cf
  8001ce:	e8 ce 00 00 00       	call   8002a1 <_panic>
		panic("fork: %e", id);
  8001d3:	50                   	push   %eax
  8001d4:	68 ee 24 80 00       	push   $0x8024ee
  8001d9:	6a 3e                	push   $0x3e
  8001db:	68 cf 24 80 00       	push   $0x8024cf
  8001e0:	e8 bc 00 00 00       	call   8002a1 <_panic>
	}

	close(p[0]);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001eb:	e8 d3 12 00 00       	call   8014c3 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001f0:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f7:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001fa:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	6a 04                	push   $0x4
  800202:	53                   	push   %ebx
  800203:	ff 75 f0             	pushl  -0x10(%ebp)
  800206:	e8 d8 14 00 00       	call   8016e3 <write>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	83 f8 04             	cmp    $0x4,%eax
  800211:	75 06                	jne    800219 <umain+0xa1>
	for (i=2;; i++)
  800213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800217:	eb e4                	jmp    8001fd <umain+0x85>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	85 c0                	test   %eax,%eax
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	0f 4e d0             	cmovle %eax,%edx
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 38 25 80 00       	push   $0x802538
  80022d:	6a 4a                	push   $0x4a
  80022f:	68 cf 24 80 00       	push   $0x8024cf
  800234:	e8 68 00 00 00       	call   8002a1 <_panic>

00800239 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
  800242:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800245:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800248:	e8 41 0b 00 00       	call   800d8e <sys_getenvid>
  80024d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800252:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800255:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025a:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025f:	85 db                	test   %ebx,%ebx
  800261:	7e 07                	jle    80026a <libmain+0x31>
		binaryname = argv[0];
  800263:	8b 06                	mov    (%esi),%eax
  800265:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	53                   	push   %ebx
  80026f:	e8 04 ff ff ff       	call   800178 <umain>

	// exit gracefully
	exit();
  800274:	e8 0a 00 00 00       	call   800283 <exit>
}
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800283:	f3 0f 1e fb          	endbr32 
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80028d:	e8 62 12 00 00       	call   8014f4 <close_all>
	sys_env_destroy(0);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 00                	push   $0x0
  800297:	e8 ad 0a 00 00       	call   800d49 <sys_env_destroy>
}
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a1:	f3 0f 1e fb          	endbr32 
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	56                   	push   %esi
  8002a9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ad:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002b3:	e8 d6 0a 00 00       	call   800d8e <sys_getenvid>
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	56                   	push   %esi
  8002c2:	50                   	push   %eax
  8002c3:	68 5c 25 80 00       	push   $0x80255c
  8002c8:	e8 bb 00 00 00       	call   800388 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cd:	83 c4 18             	add    $0x18,%esp
  8002d0:	53                   	push   %ebx
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	e8 5a 00 00 00       	call   800333 <vcprintf>
	cprintf("\n");
  8002d9:	c7 04 24 e3 24 80 00 	movl   $0x8024e3,(%esp)
  8002e0:	e8 a3 00 00 00       	call   800388 <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e8:	cc                   	int3   
  8002e9:	eb fd                	jmp    8002e8 <_panic+0x47>

008002eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002eb:	f3 0f 1e fb          	endbr32 
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f9:	8b 13                	mov    (%ebx),%edx
  8002fb:	8d 42 01             	lea    0x1(%edx),%eax
  8002fe:	89 03                	mov    %eax,(%ebx)
  800300:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800303:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800307:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030c:	74 09                	je     800317 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800315:	c9                   	leave  
  800316:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	68 ff 00 00 00       	push   $0xff
  80031f:	8d 43 08             	lea    0x8(%ebx),%eax
  800322:	50                   	push   %eax
  800323:	e8 dc 09 00 00       	call   800d04 <sys_cputs>
		b->idx = 0;
  800328:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	eb db                	jmp    80030e <putch+0x23>

00800333 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800333:	f3 0f 1e fb          	endbr32 
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800340:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800347:	00 00 00 
	b.cnt = 0;
  80034a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800351:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800354:	ff 75 0c             	pushl  0xc(%ebp)
  800357:	ff 75 08             	pushl  0x8(%ebp)
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	68 eb 02 80 00       	push   $0x8002eb
  800366:	e8 20 01 00 00       	call   80048b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036b:	83 c4 08             	add    $0x8,%esp
  80036e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800374:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037a:	50                   	push   %eax
  80037b:	e8 84 09 00 00       	call   800d04 <sys_cputs>

	return b.cnt;
}
  800380:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800392:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800395:	50                   	push   %eax
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	e8 95 ff ff ff       	call   800333 <vcprintf>
	va_end(ap);

	return cnt;
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 1c             	sub    $0x1c,%esp
  8003a9:	89 c7                	mov    %eax,%edi
  8003ab:	89 d6                	mov    %edx,%esi
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	89 d1                	mov    %edx,%ecx
  8003b5:	89 c2                	mov    %eax,%edx
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8003d2:	72 3e                	jb     800412 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	ff 75 18             	pushl  0x18(%ebp)
  8003da:	83 eb 01             	sub    $0x1,%ebx
  8003dd:	53                   	push   %ebx
  8003de:	50                   	push   %eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ee:	e8 3d 1e 00 00       	call   802230 <__udivdi3>
  8003f3:	83 c4 18             	add    $0x18,%esp
  8003f6:	52                   	push   %edx
  8003f7:	50                   	push   %eax
  8003f8:	89 f2                	mov    %esi,%edx
  8003fa:	89 f8                	mov    %edi,%eax
  8003fc:	e8 9f ff ff ff       	call   8003a0 <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 13                	jmp    800419 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	56                   	push   %esi
  80040a:	ff 75 18             	pushl  0x18(%ebp)
  80040d:	ff d7                	call   *%edi
  80040f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800412:	83 eb 01             	sub    $0x1,%ebx
  800415:	85 db                	test   %ebx,%ebx
  800417:	7f ed                	jg     800406 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	56                   	push   %esi
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	ff 75 e4             	pushl  -0x1c(%ebp)
  800423:	ff 75 e0             	pushl  -0x20(%ebp)
  800426:	ff 75 dc             	pushl  -0x24(%ebp)
  800429:	ff 75 d8             	pushl  -0x28(%ebp)
  80042c:	e8 0f 1f 00 00       	call   802340 <__umoddi3>
  800431:	83 c4 14             	add    $0x14,%esp
  800434:	0f be 80 7f 25 80 00 	movsbl 0x80257f(%eax),%eax
  80043b:	50                   	push   %eax
  80043c:	ff d7                	call   *%edi
}
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800444:	5b                   	pop    %ebx
  800445:	5e                   	pop    %esi
  800446:	5f                   	pop    %edi
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800449:	f3 0f 1e fb          	endbr32 
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800453:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800457:	8b 10                	mov    (%eax),%edx
  800459:	3b 50 04             	cmp    0x4(%eax),%edx
  80045c:	73 0a                	jae    800468 <sprintputch+0x1f>
		*b->buf++ = ch;
  80045e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800461:	89 08                	mov    %ecx,(%eax)
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	88 02                	mov    %al,(%edx)
}
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    

0080046a <printfmt>:
{
  80046a:	f3 0f 1e fb          	endbr32 
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800474:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800477:	50                   	push   %eax
  800478:	ff 75 10             	pushl  0x10(%ebp)
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	ff 75 08             	pushl  0x8(%ebp)
  800481:	e8 05 00 00 00       	call   80048b <vprintfmt>
}
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <vprintfmt>:
{
  80048b:	f3 0f 1e fb          	endbr32 
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	57                   	push   %edi
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	83 ec 3c             	sub    $0x3c,%esp
  800498:	8b 75 08             	mov    0x8(%ebp),%esi
  80049b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80049e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a1:	e9 8e 03 00 00       	jmp    800834 <vprintfmt+0x3a9>
		padc = ' ';
  8004a6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004aa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004bf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c4:	8d 47 01             	lea    0x1(%edi),%eax
  8004c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ca:	0f b6 17             	movzbl (%edi),%edx
  8004cd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004d0:	3c 55                	cmp    $0x55,%al
  8004d2:	0f 87 df 03 00 00    	ja     8008b7 <vprintfmt+0x42c>
  8004d8:	0f b6 c0             	movzbl %al,%eax
  8004db:	3e ff 24 85 c0 26 80 	notrack jmp *0x8026c0(,%eax,4)
  8004e2:	00 
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004ea:	eb d8                	jmp    8004c4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ef:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004f3:	eb cf                	jmp    8004c4 <vprintfmt+0x39>
  8004f5:	0f b6 d2             	movzbl %dl,%edx
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800503:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800506:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80050a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80050d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800510:	83 f9 09             	cmp    $0x9,%ecx
  800513:	77 55                	ja     80056a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800515:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800518:	eb e9                	jmp    800503 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 40 04             	lea    0x4(%eax),%eax
  800528:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80052e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800532:	79 90                	jns    8004c4 <vprintfmt+0x39>
				width = precision, precision = -1;
  800534:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800541:	eb 81                	jmp    8004c4 <vprintfmt+0x39>
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	85 c0                	test   %eax,%eax
  800548:	ba 00 00 00 00       	mov    $0x0,%edx
  80054d:	0f 49 d0             	cmovns %eax,%edx
  800550:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800556:	e9 69 ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80055e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800565:	e9 5a ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
  80056a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	eb bc                	jmp    80052e <vprintfmt+0xa3>
			lflag++;
  800572:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800578:	e9 47 ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 78 04             	lea    0x4(%eax),%edi
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	ff 30                	pushl  (%eax)
  800589:	ff d6                	call   *%esi
			break;
  80058b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80058e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800591:	e9 9b 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 78 04             	lea    0x4(%eax),%edi
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	99                   	cltd   
  80059f:	31 d0                	xor    %edx,%eax
  8005a1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a3:	83 f8 0f             	cmp    $0xf,%eax
  8005a6:	7f 23                	jg     8005cb <vprintfmt+0x140>
  8005a8:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  8005af:	85 d2                	test   %edx,%edx
  8005b1:	74 18                	je     8005cb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8005b3:	52                   	push   %edx
  8005b4:	68 d1 2a 80 00       	push   $0x802ad1
  8005b9:	53                   	push   %ebx
  8005ba:	56                   	push   %esi
  8005bb:	e8 aa fe ff ff       	call   80046a <printfmt>
  8005c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005c6:	e9 66 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	50                   	push   %eax
  8005cc:	68 97 25 80 00       	push   $0x802597
  8005d1:	53                   	push   %ebx
  8005d2:	56                   	push   %esi
  8005d3:	e8 92 fe ff ff       	call   80046a <printfmt>
  8005d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005db:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005de:	e9 4e 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 c0 04             	add    $0x4,%eax
  8005e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005f1:	85 d2                	test   %edx,%edx
  8005f3:	b8 90 25 80 00       	mov    $0x802590,%eax
  8005f8:	0f 45 c2             	cmovne %edx,%eax
  8005fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800602:	7e 06                	jle    80060a <vprintfmt+0x17f>
  800604:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800608:	75 0d                	jne    800617 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80060d:	89 c7                	mov    %eax,%edi
  80060f:	03 45 e0             	add    -0x20(%ebp),%eax
  800612:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800615:	eb 55                	jmp    80066c <vprintfmt+0x1e1>
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 d8             	pushl  -0x28(%ebp)
  80061d:	ff 75 cc             	pushl  -0x34(%ebp)
  800620:	e8 46 03 00 00       	call   80096b <strnlen>
  800625:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800628:	29 c2                	sub    %eax,%edx
  80062a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800632:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800636:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800639:	85 ff                	test   %edi,%edi
  80063b:	7e 11                	jle    80064e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800646:	83 ef 01             	sub    $0x1,%edi
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb eb                	jmp    800639 <vprintfmt+0x1ae>
  80064e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800651:	85 d2                	test   %edx,%edx
  800653:	b8 00 00 00 00       	mov    $0x0,%eax
  800658:	0f 49 c2             	cmovns %edx,%eax
  80065b:	29 c2                	sub    %eax,%edx
  80065d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800660:	eb a8                	jmp    80060a <vprintfmt+0x17f>
					putch(ch, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	52                   	push   %edx
  800667:	ff d6                	call   *%esi
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800671:	83 c7 01             	add    $0x1,%edi
  800674:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800678:	0f be d0             	movsbl %al,%edx
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 4b                	je     8006ca <vprintfmt+0x23f>
  80067f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800683:	78 06                	js     80068b <vprintfmt+0x200>
  800685:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800689:	78 1e                	js     8006a9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80068b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80068f:	74 d1                	je     800662 <vprintfmt+0x1d7>
  800691:	0f be c0             	movsbl %al,%eax
  800694:	83 e8 20             	sub    $0x20,%eax
  800697:	83 f8 5e             	cmp    $0x5e,%eax
  80069a:	76 c6                	jbe    800662 <vprintfmt+0x1d7>
					putch('?', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 3f                	push   $0x3f
  8006a2:	ff d6                	call   *%esi
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	eb c3                	jmp    80066c <vprintfmt+0x1e1>
  8006a9:	89 cf                	mov    %ecx,%edi
  8006ab:	eb 0e                	jmp    8006bb <vprintfmt+0x230>
				putch(' ', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 20                	push   $0x20
  8006b3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ee                	jg     8006ad <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	e9 67 01 00 00       	jmp    800831 <vprintfmt+0x3a6>
  8006ca:	89 cf                	mov    %ecx,%edi
  8006cc:	eb ed                	jmp    8006bb <vprintfmt+0x230>
	if (lflag >= 2)
  8006ce:	83 f9 01             	cmp    $0x1,%ecx
  8006d1:	7f 1b                	jg     8006ee <vprintfmt+0x263>
	else if (lflag)
  8006d3:	85 c9                	test   %ecx,%ecx
  8006d5:	74 63                	je     80073a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	99                   	cltd   
  8006e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	eb 17                	jmp    800705 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 50 04             	mov    0x4(%eax),%edx
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 40 08             	lea    0x8(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800705:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800708:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80070b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800710:	85 c9                	test   %ecx,%ecx
  800712:	0f 89 ff 00 00 00    	jns    800817 <vprintfmt+0x38c>
				putch('-', putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 2d                	push   $0x2d
  80071e:	ff d6                	call   *%esi
				num = -(long long) num;
  800720:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800723:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800726:	f7 da                	neg    %edx
  800728:	83 d1 00             	adc    $0x0,%ecx
  80072b:	f7 d9                	neg    %ecx
  80072d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	e9 dd 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	99                   	cltd   
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
  80074f:	eb b4                	jmp    800705 <vprintfmt+0x27a>
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7f 1e                	jg     800774 <vprintfmt+0x2e9>
	else if (lflag)
  800756:	85 c9                	test   %ecx,%ecx
  800758:	74 32                	je     80078c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80076f:	e9 a3 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
  800779:	8b 48 04             	mov    0x4(%eax),%ecx
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800782:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800787:	e9 8b 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8007a1:	eb 74                	jmp    800817 <vprintfmt+0x38c>
	if (lflag >= 2)
  8007a3:	83 f9 01             	cmp    $0x1,%ecx
  8007a6:	7f 1b                	jg     8007c3 <vprintfmt+0x338>
	else if (lflag)
  8007a8:	85 c9                	test   %ecx,%ecx
  8007aa:	74 2c                	je     8007d8 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8b 10                	mov    (%eax),%edx
  8007b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b6:	8d 40 04             	lea    0x4(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8007bc:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8007c1:	eb 54                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cb:	8d 40 08             	lea    0x8(%eax),%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8007d1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8007d6:	eb 3f                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 10                	mov    (%eax),%edx
  8007dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  8007e8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8007ed:	eb 28                	jmp    800817 <vprintfmt+0x38c>
			putch('0', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	6a 30                	push   $0x30
  8007f5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f7:	83 c4 08             	add    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 78                	push   $0x78
  8007fd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800809:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800812:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800817:	83 ec 0c             	sub    $0xc,%esp
  80081a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80081e:	57                   	push   %edi
  80081f:	ff 75 e0             	pushl  -0x20(%ebp)
  800822:	50                   	push   %eax
  800823:	51                   	push   %ecx
  800824:	52                   	push   %edx
  800825:	89 da                	mov    %ebx,%edx
  800827:	89 f0                	mov    %esi,%eax
  800829:	e8 72 fb ff ff       	call   8003a0 <printnum>
			break;
  80082e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800831:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800834:	83 c7 01             	add    $0x1,%edi
  800837:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80083b:	83 f8 25             	cmp    $0x25,%eax
  80083e:	0f 84 62 fc ff ff    	je     8004a6 <vprintfmt+0x1b>
			if (ch == '\0')
  800844:	85 c0                	test   %eax,%eax
  800846:	0f 84 8b 00 00 00    	je     8008d7 <vprintfmt+0x44c>
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	50                   	push   %eax
  800851:	ff d6                	call   *%esi
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	eb dc                	jmp    800834 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800858:	83 f9 01             	cmp    $0x1,%ecx
  80085b:	7f 1b                	jg     800878 <vprintfmt+0x3ed>
	else if (lflag)
  80085d:	85 c9                	test   %ecx,%ecx
  80085f:	74 2c                	je     80088d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 10                	mov    (%eax),%edx
  800866:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800871:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800876:	eb 9f                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8b 10                	mov    (%eax),%edx
  80087d:	8b 48 04             	mov    0x4(%eax),%ecx
  800880:	8d 40 08             	lea    0x8(%eax),%eax
  800883:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800886:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80088b:	eb 8a                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 10                	mov    (%eax),%edx
  800892:	b9 00 00 00 00       	mov    $0x0,%ecx
  800897:	8d 40 04             	lea    0x4(%eax),%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8008a2:	e9 70 ff ff ff       	jmp    800817 <vprintfmt+0x38c>
			putch(ch, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 25                	push   $0x25
  8008ad:	ff d6                	call   *%esi
			break;
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	e9 7a ff ff ff       	jmp    800831 <vprintfmt+0x3a6>
			putch('%', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 25                	push   $0x25
  8008bd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	89 f8                	mov    %edi,%eax
  8008c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c8:	74 05                	je     8008cf <vprintfmt+0x444>
  8008ca:	83 e8 01             	sub    $0x1,%eax
  8008cd:	eb f5                	jmp    8008c4 <vprintfmt+0x439>
  8008cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d2:	e9 5a ff ff ff       	jmp    800831 <vprintfmt+0x3a6>
}
  8008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008df:	f3 0f 1e fb          	endbr32 
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800900:	85 c0                	test   %eax,%eax
  800902:	74 26                	je     80092a <vsnprintf+0x4b>
  800904:	85 d2                	test   %edx,%edx
  800906:	7e 22                	jle    80092a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800908:	ff 75 14             	pushl  0x14(%ebp)
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	68 49 04 80 00       	push   $0x800449
  800917:	e8 6f fb ff ff       	call   80048b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800925:	83 c4 10             	add    $0x10,%esp
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    
		return -E_INVAL;
  80092a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092f:	eb f7                	jmp    800928 <vsnprintf+0x49>

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	f3 0f 1e fb          	endbr32 
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093e:	50                   	push   %eax
  80093f:	ff 75 10             	pushl  0x10(%ebp)
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 92 ff ff ff       	call   8008df <vsnprintf>
	va_end(ap);

	return rc;
}
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800962:	74 05                	je     800969 <strlen+0x1a>
		n++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	eb f5                	jmp    80095e <strlen+0xf>
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800975:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
  80097d:	39 d0                	cmp    %edx,%eax
  80097f:	74 0d                	je     80098e <strnlen+0x23>
  800981:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800985:	74 05                	je     80098c <strnlen+0x21>
		n++;
  800987:	83 c0 01             	add    $0x1,%eax
  80098a:	eb f1                	jmp    80097d <strnlen+0x12>
  80098c:	89 c2                	mov    %eax,%edx
	return n;
}
  80098e:	89 d0                	mov    %edx,%eax
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800992:	f3 0f 1e fb          	endbr32 
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	53                   	push   %ebx
  80099a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009a9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009ac:	83 c0 01             	add    $0x1,%eax
  8009af:	84 d2                	test   %dl,%dl
  8009b1:	75 f2                	jne    8009a5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8009b3:	89 c8                	mov    %ecx,%eax
  8009b5:	5b                   	pop    %ebx
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b8:	f3 0f 1e fb          	endbr32 
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 10             	sub    $0x10,%esp
  8009c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c6:	53                   	push   %ebx
  8009c7:	e8 83 ff ff ff       	call   80094f <strlen>
  8009cc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	01 d8                	add    %ebx,%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 b8 ff ff ff       	call   800992 <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f0:	89 f3                	mov    %esi,%ebx
  8009f2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f5:	89 f0                	mov    %esi,%eax
  8009f7:	39 d8                	cmp    %ebx,%eax
  8009f9:	74 11                	je     800a0c <strncpy+0x2b>
		*dst++ = *src;
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	0f b6 0a             	movzbl (%edx),%ecx
  800a01:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a04:	80 f9 01             	cmp    $0x1,%cl
  800a07:	83 da ff             	sbb    $0xffffffff,%edx
  800a0a:	eb eb                	jmp    8009f7 <strncpy+0x16>
	}
	return ret;
}
  800a0c:	89 f0                	mov    %esi,%eax
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a12:	f3 0f 1e fb          	endbr32 
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a21:	8b 55 10             	mov    0x10(%ebp),%edx
  800a24:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a26:	85 d2                	test   %edx,%edx
  800a28:	74 21                	je     800a4b <strlcpy+0x39>
  800a2a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	74 14                	je     800a48 <strlcpy+0x36>
  800a34:	0f b6 19             	movzbl (%ecx),%ebx
  800a37:	84 db                	test   %bl,%bl
  800a39:	74 0b                	je     800a46 <strlcpy+0x34>
			*dst++ = *src++;
  800a3b:	83 c1 01             	add    $0x1,%ecx
  800a3e:	83 c2 01             	add    $0x1,%edx
  800a41:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a44:	eb ea                	jmp    800a30 <strlcpy+0x1e>
  800a46:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4b:	29 f0                	sub    %esi,%eax
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a51:	f3 0f 1e fb          	endbr32 
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5e:	0f b6 01             	movzbl (%ecx),%eax
  800a61:	84 c0                	test   %al,%al
  800a63:	74 0c                	je     800a71 <strcmp+0x20>
  800a65:	3a 02                	cmp    (%edx),%al
  800a67:	75 08                	jne    800a71 <strcmp+0x20>
		p++, q++;
  800a69:	83 c1 01             	add    $0x1,%ecx
  800a6c:	83 c2 01             	add    $0x1,%edx
  800a6f:	eb ed                	jmp    800a5e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a71:	0f b6 c0             	movzbl %al,%eax
  800a74:	0f b6 12             	movzbl (%edx),%edx
  800a77:	29 d0                	sub    %edx,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7b:	f3 0f 1e fb          	endbr32 
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a89:	89 c3                	mov    %eax,%ebx
  800a8b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a8e:	eb 06                	jmp    800a96 <strncmp+0x1b>
		n--, p++, q++;
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a96:	39 d8                	cmp    %ebx,%eax
  800a98:	74 16                	je     800ab0 <strncmp+0x35>
  800a9a:	0f b6 08             	movzbl (%eax),%ecx
  800a9d:	84 c9                	test   %cl,%cl
  800a9f:	74 04                	je     800aa5 <strncmp+0x2a>
  800aa1:	3a 0a                	cmp    (%edx),%cl
  800aa3:	74 eb                	je     800a90 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa5:	0f b6 00             	movzbl (%eax),%eax
  800aa8:	0f b6 12             	movzbl (%edx),%edx
  800aab:	29 d0                	sub    %edx,%eax
}
  800aad:	5b                   	pop    %ebx
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    
		return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb f6                	jmp    800aad <strncmp+0x32>

00800ab7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab7:	f3 0f 1e fb          	endbr32 
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac5:	0f b6 10             	movzbl (%eax),%edx
  800ac8:	84 d2                	test   %dl,%dl
  800aca:	74 09                	je     800ad5 <strchr+0x1e>
		if (*s == c)
  800acc:	38 ca                	cmp    %cl,%dl
  800ace:	74 0a                	je     800ada <strchr+0x23>
	for (; *s; s++)
  800ad0:	83 c0 01             	add    $0x1,%eax
  800ad3:	eb f0                	jmp    800ac5 <strchr+0xe>
			return (char *) s;
	return 0;
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adc:	f3 0f 1e fb          	endbr32 
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aea:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aed:	38 ca                	cmp    %cl,%dl
  800aef:	74 09                	je     800afa <strfind+0x1e>
  800af1:	84 d2                	test   %dl,%dl
  800af3:	74 05                	je     800afa <strfind+0x1e>
	for (; *s; s++)
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	eb f0                	jmp    800aea <strfind+0xe>
			break;
	return (char *) s;
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800afc:	f3 0f 1e fb          	endbr32 
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	57                   	push   %edi
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b0c:	85 c9                	test   %ecx,%ecx
  800b0e:	74 31                	je     800b41 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	09 c8                	or     %ecx,%eax
  800b14:	a8 03                	test   $0x3,%al
  800b16:	75 23                	jne    800b3b <memset+0x3f>
		c &= 0xFF;
  800b18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1c:	89 d3                	mov    %edx,%ebx
  800b1e:	c1 e3 08             	shl    $0x8,%ebx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	c1 e0 18             	shl    $0x18,%eax
  800b26:	89 d6                	mov    %edx,%esi
  800b28:	c1 e6 10             	shl    $0x10,%esi
  800b2b:	09 f0                	or     %esi,%eax
  800b2d:	09 c2                	or     %eax,%edx
  800b2f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b34:	89 d0                	mov    %edx,%eax
  800b36:	fc                   	cld    
  800b37:	f3 ab                	rep stos %eax,%es:(%edi)
  800b39:	eb 06                	jmp    800b41 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	fc                   	cld    
  800b3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b41:	89 f8                	mov    %edi,%eax
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5a:	39 c6                	cmp    %eax,%esi
  800b5c:	73 32                	jae    800b90 <memmove+0x48>
  800b5e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	76 2b                	jbe    800b90 <memmove+0x48>
		s += n;
		d += n;
  800b65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b68:	89 fe                	mov    %edi,%esi
  800b6a:	09 ce                	or     %ecx,%esi
  800b6c:	09 d6                	or     %edx,%esi
  800b6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b74:	75 0e                	jne    800b84 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b76:	83 ef 04             	sub    $0x4,%edi
  800b79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7f:	fd                   	std    
  800b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b82:	eb 09                	jmp    800b8d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8a:	fd                   	std    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8d:	fc                   	cld    
  800b8e:	eb 1a                	jmp    800baa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	09 ca                	or     %ecx,%edx
  800b94:	09 f2                	or     %esi,%edx
  800b96:	f6 c2 03             	test   $0x3,%dl
  800b99:	75 0a                	jne    800ba5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	fc                   	cld    
  800ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba3:	eb 05                	jmp    800baa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bae:	f3 0f 1e fb          	endbr32 
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb8:	ff 75 10             	pushl  0x10(%ebp)
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 82 ff ff ff       	call   800b48 <memmove>
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc8:	f3 0f 1e fb          	endbr32 
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	89 c6                	mov    %eax,%esi
  800bd9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdc:	39 f0                	cmp    %esi,%eax
  800bde:	74 1c                	je     800bfc <memcmp+0x34>
		if (*s1 != *s2)
  800be0:	0f b6 08             	movzbl (%eax),%ecx
  800be3:	0f b6 1a             	movzbl (%edx),%ebx
  800be6:	38 d9                	cmp    %bl,%cl
  800be8:	75 08                	jne    800bf2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	83 c2 01             	add    $0x1,%edx
  800bf0:	eb ea                	jmp    800bdc <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bf2:	0f b6 c1             	movzbl %cl,%eax
  800bf5:	0f b6 db             	movzbl %bl,%ebx
  800bf8:	29 d8                	sub    %ebx,%eax
  800bfa:	eb 05                	jmp    800c01 <memcmp+0x39>
	}

	return 0;
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c05:	f3 0f 1e fb          	endbr32 
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c17:	39 d0                	cmp    %edx,%eax
  800c19:	73 09                	jae    800c24 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1b:	38 08                	cmp    %cl,(%eax)
  800c1d:	74 05                	je     800c24 <memfind+0x1f>
	for (; s < ends; s++)
  800c1f:	83 c0 01             	add    $0x1,%eax
  800c22:	eb f3                	jmp    800c17 <memfind+0x12>
			break;
	return (void *) s;
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c26:	f3 0f 1e fb          	endbr32 
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c36:	eb 03                	jmp    800c3b <strtol+0x15>
		s++;
  800c38:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c3b:	0f b6 01             	movzbl (%ecx),%eax
  800c3e:	3c 20                	cmp    $0x20,%al
  800c40:	74 f6                	je     800c38 <strtol+0x12>
  800c42:	3c 09                	cmp    $0x9,%al
  800c44:	74 f2                	je     800c38 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c46:	3c 2b                	cmp    $0x2b,%al
  800c48:	74 2a                	je     800c74 <strtol+0x4e>
	int neg = 0;
  800c4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c4f:	3c 2d                	cmp    $0x2d,%al
  800c51:	74 2b                	je     800c7e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c53:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c59:	75 0f                	jne    800c6a <strtol+0x44>
  800c5b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c5e:	74 28                	je     800c88 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c67:	0f 44 d8             	cmove  %eax,%ebx
  800c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c72:	eb 46                	jmp    800cba <strtol+0x94>
		s++;
  800c74:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c77:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7c:	eb d5                	jmp    800c53 <strtol+0x2d>
		s++, neg = 1;
  800c7e:	83 c1 01             	add    $0x1,%ecx
  800c81:	bf 01 00 00 00       	mov    $0x1,%edi
  800c86:	eb cb                	jmp    800c53 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c88:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c8c:	74 0e                	je     800c9c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c8e:	85 db                	test   %ebx,%ebx
  800c90:	75 d8                	jne    800c6a <strtol+0x44>
		s++, base = 8;
  800c92:	83 c1 01             	add    $0x1,%ecx
  800c95:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c9a:	eb ce                	jmp    800c6a <strtol+0x44>
		s += 2, base = 16;
  800c9c:	83 c1 02             	add    $0x2,%ecx
  800c9f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca4:	eb c4                	jmp    800c6a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca6:	0f be d2             	movsbl %dl,%edx
  800ca9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cac:	3b 55 10             	cmp    0x10(%ebp),%edx
  800caf:	7d 3a                	jge    800ceb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cba:	0f b6 11             	movzbl (%ecx),%edx
  800cbd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc0:	89 f3                	mov    %esi,%ebx
  800cc2:	80 fb 09             	cmp    $0x9,%bl
  800cc5:	76 df                	jbe    800ca6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800cc7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cca:	89 f3                	mov    %esi,%ebx
  800ccc:	80 fb 19             	cmp    $0x19,%bl
  800ccf:	77 08                	ja     800cd9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cd1:	0f be d2             	movsbl %dl,%edx
  800cd4:	83 ea 57             	sub    $0x57,%edx
  800cd7:	eb d3                	jmp    800cac <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800cd9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cdc:	89 f3                	mov    %esi,%ebx
  800cde:	80 fb 19             	cmp    $0x19,%bl
  800ce1:	77 08                	ja     800ceb <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ce3:	0f be d2             	movsbl %dl,%edx
  800ce6:	83 ea 37             	sub    $0x37,%edx
  800ce9:	eb c1                	jmp    800cac <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ceb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cef:	74 05                	je     800cf6 <strtol+0xd0>
		*endptr = (char *) s;
  800cf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cf4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cf6:	89 c2                	mov    %eax,%edx
  800cf8:	f7 da                	neg    %edx
  800cfa:	85 ff                	test   %edi,%edi
  800cfc:	0f 45 c2             	cmovne %edx,%eax
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d04:	f3 0f 1e fb          	endbr32 
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	89 c7                	mov    %eax,%edi
  800d1d:	89 c6                	mov    %eax,%esi
  800d1f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
  800d35:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3a:	89 d1                	mov    %edx,%ecx
  800d3c:	89 d3                	mov    %edx,%ebx
  800d3e:	89 d7                	mov    %edx,%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d49:	f3 0f 1e fb          	endbr32 
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d63:	89 cb                	mov    %ecx,%ebx
  800d65:	89 cf                	mov    %ecx,%edi
  800d67:	89 ce                	mov    %ecx,%esi
  800d69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7f 08                	jg     800d77 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	50                   	push   %eax
  800d7b:	6a 03                	push   $0x3
  800d7d:	68 7f 28 80 00       	push   $0x80287f
  800d82:	6a 23                	push   $0x23
  800d84:	68 9c 28 80 00       	push   $0x80289c
  800d89:	e8 13 f5 ff ff       	call   8002a1 <_panic>

00800d8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8e:	f3 0f 1e fb          	endbr32 
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d98:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9d:	b8 02 00 00 00       	mov    $0x2,%eax
  800da2:	89 d1                	mov    %edx,%ecx
  800da4:	89 d3                	mov    %edx,%ebx
  800da6:	89 d7                	mov    %edx,%edi
  800da8:	89 d6                	mov    %edx,%esi
  800daa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <sys_yield>:

void
sys_yield(void)
{
  800db1:	f3 0f 1e fb          	endbr32 
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc5:	89 d1                	mov    %edx,%ecx
  800dc7:	89 d3                	mov    %edx,%ebx
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 04 00 00 00       	mov    $0x4,%eax
  800df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df4:	89 f7                	mov    %esi,%edi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 04                	push   $0x4
  800e0a:	68 7f 28 80 00       	push   $0x80287f
  800e0f:	6a 23                	push   $0x23
  800e11:	68 9c 28 80 00       	push   $0x80289c
  800e16:	e8 86 f4 ff ff       	call   8002a1 <_panic>

00800e1b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 05 00 00 00       	mov    $0x5,%eax
  800e33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e36:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e39:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 05                	push   $0x5
  800e50:	68 7f 28 80 00       	push   $0x80287f
  800e55:	6a 23                	push   $0x23
  800e57:	68 9c 28 80 00       	push   $0x80289c
  800e5c:	e8 40 f4 ff ff       	call   8002a1 <_panic>

00800e61 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e61:	f3 0f 1e fb          	endbr32 
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7e:	89 df                	mov    %ebx,%edi
  800e80:	89 de                	mov    %ebx,%esi
  800e82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7f 08                	jg     800e90 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	50                   	push   %eax
  800e94:	6a 06                	push   $0x6
  800e96:	68 7f 28 80 00       	push   $0x80287f
  800e9b:	6a 23                	push   $0x23
  800e9d:	68 9c 28 80 00       	push   $0x80289c
  800ea2:	e8 fa f3 ff ff       	call   8002a1 <_panic>

00800ea7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea7:	f3 0f 1e fb          	endbr32 
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 08                	push   $0x8
  800edc:	68 7f 28 80 00       	push   $0x80287f
  800ee1:	6a 23                	push   $0x23
  800ee3:	68 9c 28 80 00       	push   $0x80289c
  800ee8:	e8 b4 f3 ff ff       	call   8002a1 <_panic>

00800eed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eed:	f3 0f 1e fb          	endbr32 
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	b8 09 00 00 00       	mov    $0x9,%eax
  800f0a:	89 df                	mov    %ebx,%edi
  800f0c:	89 de                	mov    %ebx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 09                	push   $0x9
  800f22:	68 7f 28 80 00       	push   $0x80287f
  800f27:	6a 23                	push   $0x23
  800f29:	68 9c 28 80 00       	push   $0x80289c
  800f2e:	e8 6e f3 ff ff       	call   8002a1 <_panic>

00800f33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7f 08                	jg     800f62 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	50                   	push   %eax
  800f66:	6a 0a                	push   $0xa
  800f68:	68 7f 28 80 00       	push   $0x80287f
  800f6d:	6a 23                	push   $0x23
  800f6f:	68 9c 28 80 00       	push   $0x80289c
  800f74:	e8 28 f3 ff ff       	call   8002a1 <_panic>

00800f79 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f79:	f3 0f 1e fb          	endbr32 
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8e:	be 00 00 00 00       	mov    $0x0,%esi
  800f93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f99:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa0:	f3 0f 1e fb          	endbr32 
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fba:	89 cb                	mov    %ecx,%ebx
  800fbc:	89 cf                	mov    %ecx,%edi
  800fbe:	89 ce                	mov    %ecx,%esi
  800fc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7f 08                	jg     800fce <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	50                   	push   %eax
  800fd2:	6a 0d                	push   $0xd
  800fd4:	68 7f 28 80 00       	push   $0x80287f
  800fd9:	6a 23                	push   $0x23
  800fdb:	68 9c 28 80 00       	push   $0x80289c
  800fe0:	e8 bc f2 ff ff       	call   8002a1 <_panic>

00800fe5 <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  800fe5:	f3 0f 1e fb          	endbr32 
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	56                   	push   %esi
  800fed:	53                   	push   %ebx
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ff1:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800ff3:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ff7:	74 7f                	je     801078 <pgfault+0x93>
  800ff9:	89 f0                	mov    %esi,%eax
  800ffb:	c1 e8 0c             	shr    $0xc,%eax
  800ffe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801005:	f6 c4 08             	test   $0x8,%ah
  801008:	74 6e                	je     801078 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  80100a:	e8 7f fd ff ff       	call   800d8e <sys_getenvid>
  80100f:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  801011:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  801017:	83 ec 04             	sub    $0x4,%esp
  80101a:	6a 07                	push   $0x7
  80101c:	68 00 f0 7f 00       	push   $0x7ff000
  801021:	50                   	push   %eax
  801022:	e8 ad fd ff ff       	call   800dd4 <sys_page_alloc>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	78 5e                	js     80108c <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  80102e:	83 ec 04             	sub    $0x4,%esp
  801031:	68 00 10 00 00       	push   $0x1000
  801036:	56                   	push   %esi
  801037:	68 00 f0 7f 00       	push   $0x7ff000
  80103c:	e8 6d fb ff ff       	call   800bae <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  801041:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
  80104a:	68 00 f0 7f 00       	push   $0x7ff000
  80104f:	53                   	push   %ebx
  801050:	e8 c6 fd ff ff       	call   800e1b <sys_page_map>
  801055:	83 c4 20             	add    $0x20,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	78 44                	js     8010a0 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	68 00 f0 7f 00       	push   $0x7ff000
  801064:	53                   	push   %ebx
  801065:	e8 f7 fd ff ff       	call   800e61 <sys_page_unmap>
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	85 c0                	test   %eax,%eax
  80106f:	78 43                	js     8010b4 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  801071:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	68 aa 28 80 00       	push   $0x8028aa
  801080:	6a 1e                	push   $0x1e
  801082:	68 c7 28 80 00       	push   $0x8028c7
  801087:	e8 15 f2 ff ff       	call   8002a1 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	68 58 29 80 00       	push   $0x802958
  801094:	6a 2b                	push   $0x2b
  801096:	68 c7 28 80 00       	push   $0x8028c7
  80109b:	e8 01 f2 ff ff       	call   8002a1 <_panic>
		panic("pgfault: sys_page_map Failed!");
  8010a0:	83 ec 04             	sub    $0x4,%esp
  8010a3:	68 d2 28 80 00       	push   $0x8028d2
  8010a8:	6a 2f                	push   $0x2f
  8010aa:	68 c7 28 80 00       	push   $0x8028c7
  8010af:	e8 ed f1 ff ff       	call   8002a1 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  8010b4:	83 ec 04             	sub    $0x4,%esp
  8010b7:	68 78 29 80 00       	push   $0x802978
  8010bc:	6a 32                	push   $0x32
  8010be:	68 c7 28 80 00       	push   $0x8028c7
  8010c3:	e8 d9 f1 ff ff       	call   8002a1 <_panic>

008010c8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010c8:	f3 0f 1e fb          	endbr32 
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
  8010d2:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8010d5:	68 e5 0f 80 00       	push   $0x800fe5
  8010da:	e8 6b 0f 00 00       	call   80204a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010df:	b8 07 00 00 00       	mov    $0x7,%eax
  8010e4:	cd 30                	int    $0x30
  8010e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	78 2b                	js     80111e <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  8010f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010fc:	0f 85 ba 00 00 00    	jne    8011bc <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  801102:	e8 87 fc ff ff       	call   800d8e <sys_getenvid>
  801107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80110c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80110f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801114:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801119:	e9 90 01 00 00       	jmp    8012ae <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	68 f0 28 80 00       	push   $0x8028f0
  801126:	6a 76                	push   $0x76
  801128:	68 c7 28 80 00       	push   $0x8028c7
  80112d:	e8 6f f1 ff ff       	call   8002a1 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  801132:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  801139:	e8 50 fc ff ff       	call   800d8e <sys_getenvid>
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  801147:	56                   	push   %esi
  801148:	57                   	push   %edi
  801149:	ff 75 e0             	pushl  -0x20(%ebp)
  80114c:	57                   	push   %edi
  80114d:	50                   	push   %eax
  80114e:	e8 c8 fc ff ff       	call   800e1b <sys_page_map>
  801153:	83 c4 20             	add    $0x20,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	79 50                	jns    8011aa <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  80115a:	83 ec 04             	sub    $0x4,%esp
  80115d:	68 09 29 80 00       	push   $0x802909
  801162:	6a 4b                	push   $0x4b
  801164:	68 c7 28 80 00       	push   $0x8028c7
  801169:	e8 33 f1 ff ff       	call   8002a1 <_panic>
			panic("duppage:child sys_page_map Failed!");
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	68 98 29 80 00       	push   $0x802998
  801176:	6a 50                	push   $0x50
  801178:	68 c7 28 80 00       	push   $0x8028c7
  80117d:	e8 1f f1 ff ff       	call   8002a1 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  801182:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	25 07 0e 00 00       	and    $0xe07,%eax
  801191:	50                   	push   %eax
  801192:	57                   	push   %edi
  801193:	ff 75 e0             	pushl  -0x20(%ebp)
  801196:	57                   	push   %edi
  801197:	ff 75 e4             	pushl  -0x1c(%ebp)
  80119a:	e8 7c fc ff ff       	call   800e1b <sys_page_map>
  80119f:	83 c4 20             	add    $0x20,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	0f 88 b4 00 00 00    	js     80125e <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  8011aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011b0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011b6:	0f 84 b6 00 00 00    	je     801272 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  8011bc:	89 d8                	mov    %ebx,%eax
  8011be:	c1 e8 16             	shr    $0x16,%eax
  8011c1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011c8:	a8 01                	test   $0x1,%al
  8011ca:	74 de                	je     8011aa <fork+0xe2>
  8011cc:	89 de                	mov    %ebx,%esi
  8011ce:	c1 ee 0c             	shr    $0xc,%esi
  8011d1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011d8:	a8 01                	test   $0x1,%al
  8011da:	74 ce                	je     8011aa <fork+0xe2>
	envid_t f_id=sys_getenvid();
  8011dc:	e8 ad fb ff ff       	call   800d8e <sys_getenvid>
  8011e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  8011e4:	89 f7                	mov    %esi,%edi
  8011e6:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  8011e9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011f0:	f6 c4 04             	test   $0x4,%ah
  8011f3:	0f 85 39 ff ff ff    	jne    801132 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  8011f9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801200:	a9 02 08 00 00       	test   $0x802,%eax
  801205:	0f 84 77 ff ff ff    	je     801182 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	68 05 08 00 00       	push   $0x805
  801213:	57                   	push   %edi
  801214:	ff 75 e0             	pushl  -0x20(%ebp)
  801217:	57                   	push   %edi
  801218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121b:	e8 fb fb ff ff       	call   800e1b <sys_page_map>
  801220:	83 c4 20             	add    $0x20,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	0f 88 43 ff ff ff    	js     80116e <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  80122b:	83 ec 0c             	sub    $0xc,%esp
  80122e:	68 05 08 00 00       	push   $0x805
  801233:	57                   	push   %edi
  801234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	57                   	push   %edi
  801239:	50                   	push   %eax
  80123a:	e8 dc fb ff ff       	call   800e1b <sys_page_map>
  80123f:	83 c4 20             	add    $0x20,%esp
  801242:	85 c0                	test   %eax,%eax
  801244:	0f 89 60 ff ff ff    	jns    8011aa <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  80124a:	83 ec 04             	sub    $0x4,%esp
  80124d:	68 bc 29 80 00       	push   $0x8029bc
  801252:	6a 52                	push   $0x52
  801254:	68 c7 28 80 00       	push   $0x8028c7
  801259:	e8 43 f0 ff ff       	call   8002a1 <_panic>
			panic("duppage: single sys_page_map Failed!");
  80125e:	83 ec 04             	sub    $0x4,%esp
  801261:	68 e0 29 80 00       	push   $0x8029e0
  801266:	6a 56                	push   $0x56
  801268:	68 c7 28 80 00       	push   $0x8028c7
  80126d:	e8 2f f0 ff ff       	call   8002a1 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801272:	83 ec 04             	sub    $0x4,%esp
  801275:	6a 07                	push   $0x7
  801277:	68 00 f0 bf ee       	push   $0xeebff000
  80127c:	ff 75 dc             	pushl  -0x24(%ebp)
  80127f:	e8 50 fb ff ff       	call   800dd4 <sys_page_alloc>
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 2e                	js     8012b9 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	68 c6 20 80 00       	push   $0x8020c6
  801293:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801296:	57                   	push   %edi
  801297:	e8 97 fc ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  80129c:	83 c4 08             	add    $0x8,%esp
  80129f:	6a 02                	push   $0x2
  8012a1:	57                   	push   %edi
  8012a2:	e8 00 fc ff ff       	call   800ea7 <sys_env_set_status>
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 22                	js     8012d0 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  8012ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b4:	5b                   	pop    %ebx
  8012b5:	5e                   	pop    %esi
  8012b6:	5f                   	pop    %edi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  8012b9:	83 ec 04             	sub    $0x4,%esp
  8012bc:	68 26 29 80 00       	push   $0x802926
  8012c1:	68 83 00 00 00       	push   $0x83
  8012c6:	68 c7 28 80 00       	push   $0x8028c7
  8012cb:	e8 d1 ef ff ff       	call   8002a1 <_panic>
		panic("fork: sys_env_set_status Failed!");
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 08 2a 80 00       	push   $0x802a08
  8012d8:	68 89 00 00 00       	push   $0x89
  8012dd:	68 c7 28 80 00       	push   $0x8028c7
  8012e2:	e8 ba ef ff ff       	call   8002a1 <_panic>

008012e7 <sfork>:

// Challenge!
int
sfork(void)
{
  8012e7:	f3 0f 1e fb          	endbr32 
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012f1:	68 42 29 80 00       	push   $0x802942
  8012f6:	68 93 00 00 00       	push   $0x93
  8012fb:	68 c7 28 80 00       	push   $0x8028c7
  801300:	e8 9c ef ff ff       	call   8002a1 <_panic>

00801305 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801305:	f3 0f 1e fb          	endbr32 
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	05 00 00 00 30       	add    $0x30000000,%eax
  801314:	c1 e8 0c             	shr    $0xc,%eax
}
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801319:	f3 0f 1e fb          	endbr32 
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801328:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801332:	5d                   	pop    %ebp
  801333:	c3                   	ret    

00801334 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801334:	f3 0f 1e fb          	endbr32 
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801340:	89 c2                	mov    %eax,%edx
  801342:	c1 ea 16             	shr    $0x16,%edx
  801345:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80134c:	f6 c2 01             	test   $0x1,%dl
  80134f:	74 2d                	je     80137e <fd_alloc+0x4a>
  801351:	89 c2                	mov    %eax,%edx
  801353:	c1 ea 0c             	shr    $0xc,%edx
  801356:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80135d:	f6 c2 01             	test   $0x1,%dl
  801360:	74 1c                	je     80137e <fd_alloc+0x4a>
  801362:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801367:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80136c:	75 d2                	jne    801340 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801377:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80137c:	eb 0a                	jmp    801388 <fd_alloc+0x54>
			*fd_store = fd;
  80137e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801381:	89 01                	mov    %eax,(%ecx)
			return 0;
  801383:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80138a:	f3 0f 1e fb          	endbr32 
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801394:	83 f8 1f             	cmp    $0x1f,%eax
  801397:	77 30                	ja     8013c9 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801399:	c1 e0 0c             	shl    $0xc,%eax
  80139c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013a1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013a7:	f6 c2 01             	test   $0x1,%dl
  8013aa:	74 24                	je     8013d0 <fd_lookup+0x46>
  8013ac:	89 c2                	mov    %eax,%edx
  8013ae:	c1 ea 0c             	shr    $0xc,%edx
  8013b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013b8:	f6 c2 01             	test   $0x1,%dl
  8013bb:	74 1a                	je     8013d7 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c0:	89 02                	mov    %eax,(%edx)
	return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    
		return -E_INVAL;
  8013c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ce:	eb f7                	jmp    8013c7 <fd_lookup+0x3d>
		return -E_INVAL;
  8013d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d5:	eb f0                	jmp    8013c7 <fd_lookup+0x3d>
  8013d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013dc:	eb e9                	jmp    8013c7 <fd_lookup+0x3d>

008013de <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013de:	f3 0f 1e fb          	endbr32 
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013eb:	ba a8 2a 80 00       	mov    $0x802aa8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013f0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013f5:	39 08                	cmp    %ecx,(%eax)
  8013f7:	74 33                	je     80142c <dev_lookup+0x4e>
  8013f9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013fc:	8b 02                	mov    (%edx),%eax
  8013fe:	85 c0                	test   %eax,%eax
  801400:	75 f3                	jne    8013f5 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801402:	a1 04 40 80 00       	mov    0x804004,%eax
  801407:	8b 40 48             	mov    0x48(%eax),%eax
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	51                   	push   %ecx
  80140e:	50                   	push   %eax
  80140f:	68 2c 2a 80 00       	push   $0x802a2c
  801414:	e8 6f ef ff ff       	call   800388 <cprintf>
	*dev = 0;
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    
			*dev = devtab[i];
  80142c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb f2                	jmp    80142a <dev_lookup+0x4c>

00801438 <fd_close>:
{
  801438:	f3 0f 1e fb          	endbr32 
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	57                   	push   %edi
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	83 ec 24             	sub    $0x24,%esp
  801445:	8b 75 08             	mov    0x8(%ebp),%esi
  801448:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80144b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80144e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80144f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801455:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801458:	50                   	push   %eax
  801459:	e8 2c ff ff ff       	call   80138a <fd_lookup>
  80145e:	89 c3                	mov    %eax,%ebx
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 05                	js     80146c <fd_close+0x34>
	    || fd != fd2)
  801467:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80146a:	74 16                	je     801482 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80146c:	89 f8                	mov    %edi,%eax
  80146e:	84 c0                	test   %al,%al
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	0f 44 d8             	cmove  %eax,%ebx
}
  801478:	89 d8                	mov    %ebx,%eax
  80147a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147d:	5b                   	pop    %ebx
  80147e:	5e                   	pop    %esi
  80147f:	5f                   	pop    %edi
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801488:	50                   	push   %eax
  801489:	ff 36                	pushl  (%esi)
  80148b:	e8 4e ff ff ff       	call   8013de <dev_lookup>
  801490:	89 c3                	mov    %eax,%ebx
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 1a                	js     8014b3 <fd_close+0x7b>
		if (dev->dev_close)
  801499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80149f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	74 0b                	je     8014b3 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014a8:	83 ec 0c             	sub    $0xc,%esp
  8014ab:	56                   	push   %esi
  8014ac:	ff d0                	call   *%eax
  8014ae:	89 c3                	mov    %eax,%ebx
  8014b0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	56                   	push   %esi
  8014b7:	6a 00                	push   $0x0
  8014b9:	e8 a3 f9 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	eb b5                	jmp    801478 <fd_close+0x40>

008014c3 <close>:

int
close(int fdnum)
{
  8014c3:	f3 0f 1e fb          	endbr32 
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	ff 75 08             	pushl  0x8(%ebp)
  8014d4:	e8 b1 fe ff ff       	call   80138a <fd_lookup>
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	79 02                	jns    8014e2 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
		return fd_close(fd, 1);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	6a 01                	push   $0x1
  8014e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ea:	e8 49 ff ff ff       	call   801438 <fd_close>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	eb ec                	jmp    8014e0 <close+0x1d>

008014f4 <close_all>:

void
close_all(void)
{
  8014f4:	f3 0f 1e fb          	endbr32 
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	53                   	push   %ebx
  8014fc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	53                   	push   %ebx
  801508:	e8 b6 ff ff ff       	call   8014c3 <close>
	for (i = 0; i < MAXFD; i++)
  80150d:	83 c3 01             	add    $0x1,%ebx
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	83 fb 20             	cmp    $0x20,%ebx
  801516:	75 ec                	jne    801504 <close_all+0x10>
}
  801518:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80151d:	f3 0f 1e fb          	endbr32 
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	57                   	push   %edi
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
  801527:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80152a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80152d:	50                   	push   %eax
  80152e:	ff 75 08             	pushl  0x8(%ebp)
  801531:	e8 54 fe ff ff       	call   80138a <fd_lookup>
  801536:	89 c3                	mov    %eax,%ebx
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	0f 88 81 00 00 00    	js     8015c4 <dup+0xa7>
		return r;
	close(newfdnum);
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	e8 75 ff ff ff       	call   8014c3 <close>

	newfd = INDEX2FD(newfdnum);
  80154e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801551:	c1 e6 0c             	shl    $0xc,%esi
  801554:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80155a:	83 c4 04             	add    $0x4,%esp
  80155d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801560:	e8 b4 fd ff ff       	call   801319 <fd2data>
  801565:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801567:	89 34 24             	mov    %esi,(%esp)
  80156a:	e8 aa fd ff ff       	call   801319 <fd2data>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801574:	89 d8                	mov    %ebx,%eax
  801576:	c1 e8 16             	shr    $0x16,%eax
  801579:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801580:	a8 01                	test   $0x1,%al
  801582:	74 11                	je     801595 <dup+0x78>
  801584:	89 d8                	mov    %ebx,%eax
  801586:	c1 e8 0c             	shr    $0xc,%eax
  801589:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801590:	f6 c2 01             	test   $0x1,%dl
  801593:	75 39                	jne    8015ce <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801595:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801598:	89 d0                	mov    %edx,%eax
  80159a:	c1 e8 0c             	shr    $0xc,%eax
  80159d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ac:	50                   	push   %eax
  8015ad:	56                   	push   %esi
  8015ae:	6a 00                	push   $0x0
  8015b0:	52                   	push   %edx
  8015b1:	6a 00                	push   $0x0
  8015b3:	e8 63 f8 ff ff       	call   800e1b <sys_page_map>
  8015b8:	89 c3                	mov    %eax,%ebx
  8015ba:	83 c4 20             	add    $0x20,%esp
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 31                	js     8015f2 <dup+0xd5>
		goto err;

	return newfdnum;
  8015c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015c4:	89 d8                	mov    %ebx,%eax
  8015c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015d5:	83 ec 0c             	sub    $0xc,%esp
  8015d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8015dd:	50                   	push   %eax
  8015de:	57                   	push   %edi
  8015df:	6a 00                	push   $0x0
  8015e1:	53                   	push   %ebx
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 32 f8 ff ff       	call   800e1b <sys_page_map>
  8015e9:	89 c3                	mov    %eax,%ebx
  8015eb:	83 c4 20             	add    $0x20,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	79 a3                	jns    801595 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	56                   	push   %esi
  8015f6:	6a 00                	push   $0x0
  8015f8:	e8 64 f8 ff ff       	call   800e61 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015fd:	83 c4 08             	add    $0x8,%esp
  801600:	57                   	push   %edi
  801601:	6a 00                	push   $0x0
  801603:	e8 59 f8 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	eb b7                	jmp    8015c4 <dup+0xa7>

0080160d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80160d:	f3 0f 1e fb          	endbr32 
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	53                   	push   %ebx
  801615:	83 ec 1c             	sub    $0x1c,%esp
  801618:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	53                   	push   %ebx
  801620:	e8 65 fd ff ff       	call   80138a <fd_lookup>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 3f                	js     80166b <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801632:	50                   	push   %eax
  801633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801636:	ff 30                	pushl  (%eax)
  801638:	e8 a1 fd ff ff       	call   8013de <dev_lookup>
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 27                	js     80166b <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801644:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801647:	8b 42 08             	mov    0x8(%edx),%eax
  80164a:	83 e0 03             	and    $0x3,%eax
  80164d:	83 f8 01             	cmp    $0x1,%eax
  801650:	74 1e                	je     801670 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801655:	8b 40 08             	mov    0x8(%eax),%eax
  801658:	85 c0                	test   %eax,%eax
  80165a:	74 35                	je     801691 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	ff 75 10             	pushl  0x10(%ebp)
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	52                   	push   %edx
  801666:	ff d0                	call   *%eax
  801668:	83 c4 10             	add    $0x10,%esp
}
  80166b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801670:	a1 04 40 80 00       	mov    0x804004,%eax
  801675:	8b 40 48             	mov    0x48(%eax),%eax
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	53                   	push   %ebx
  80167c:	50                   	push   %eax
  80167d:	68 6d 2a 80 00       	push   $0x802a6d
  801682:	e8 01 ed ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80168f:	eb da                	jmp    80166b <read+0x5e>
		return -E_NOT_SUPP;
  801691:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801696:	eb d3                	jmp    80166b <read+0x5e>

00801698 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801698:	f3 0f 1e fb          	endbr32 
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b0:	eb 02                	jmp    8016b4 <readn+0x1c>
  8016b2:	01 c3                	add    %eax,%ebx
  8016b4:	39 f3                	cmp    %esi,%ebx
  8016b6:	73 21                	jae    8016d9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	89 f0                	mov    %esi,%eax
  8016bd:	29 d8                	sub    %ebx,%eax
  8016bf:	50                   	push   %eax
  8016c0:	89 d8                	mov    %ebx,%eax
  8016c2:	03 45 0c             	add    0xc(%ebp),%eax
  8016c5:	50                   	push   %eax
  8016c6:	57                   	push   %edi
  8016c7:	e8 41 ff ff ff       	call   80160d <read>
		if (m < 0)
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 04                	js     8016d7 <readn+0x3f>
			return m;
		if (m == 0)
  8016d3:	75 dd                	jne    8016b2 <readn+0x1a>
  8016d5:	eb 02                	jmp    8016d9 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016d7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016d9:	89 d8                	mov    %ebx,%eax
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e3:	f3 0f 1e fb          	endbr32 
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 1c             	sub    $0x1c,%esp
  8016ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	53                   	push   %ebx
  8016f6:	e8 8f fc ff ff       	call   80138a <fd_lookup>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 3a                	js     80173c <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801708:	50                   	push   %eax
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	ff 30                	pushl  (%eax)
  80170e:	e8 cb fc ff ff       	call   8013de <dev_lookup>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 22                	js     80173c <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801721:	74 1e                	je     801741 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801726:	8b 52 0c             	mov    0xc(%edx),%edx
  801729:	85 d2                	test   %edx,%edx
  80172b:	74 35                	je     801762 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	ff 75 10             	pushl  0x10(%ebp)
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	50                   	push   %eax
  801737:	ff d2                	call   *%edx
  801739:	83 c4 10             	add    $0x10,%esp
}
  80173c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173f:	c9                   	leave  
  801740:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801741:	a1 04 40 80 00       	mov    0x804004,%eax
  801746:	8b 40 48             	mov    0x48(%eax),%eax
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	53                   	push   %ebx
  80174d:	50                   	push   %eax
  80174e:	68 89 2a 80 00       	push   $0x802a89
  801753:	e8 30 ec ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801760:	eb da                	jmp    80173c <write+0x59>
		return -E_NOT_SUPP;
  801762:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801767:	eb d3                	jmp    80173c <write+0x59>

00801769 <seek>:

int
seek(int fdnum, off_t offset)
{
  801769:	f3 0f 1e fb          	endbr32 
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801773:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	e8 0b fc ff ff       	call   80138a <fd_lookup>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	78 0e                	js     801794 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801796:	f3 0f 1e fb          	endbr32 
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	53                   	push   %ebx
  80179e:	83 ec 1c             	sub    $0x1c,%esp
  8017a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a7:	50                   	push   %eax
  8017a8:	53                   	push   %ebx
  8017a9:	e8 dc fb ff ff       	call   80138a <fd_lookup>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 37                	js     8017ec <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bf:	ff 30                	pushl  (%eax)
  8017c1:	e8 18 fc ff ff       	call   8013de <dev_lookup>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 1f                	js     8017ec <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017d4:	74 1b                	je     8017f1 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	8b 52 18             	mov    0x18(%edx),%edx
  8017dc:	85 d2                	test   %edx,%edx
  8017de:	74 32                	je     801812 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	50                   	push   %eax
  8017e7:	ff d2                	call   *%edx
  8017e9:	83 c4 10             	add    $0x10,%esp
}
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017f1:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017f6:	8b 40 48             	mov    0x48(%eax),%eax
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	53                   	push   %ebx
  8017fd:	50                   	push   %eax
  8017fe:	68 4c 2a 80 00       	push   $0x802a4c
  801803:	e8 80 eb ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801810:	eb da                	jmp    8017ec <ftruncate+0x56>
		return -E_NOT_SUPP;
  801812:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801817:	eb d3                	jmp    8017ec <ftruncate+0x56>

00801819 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801819:	f3 0f 1e fb          	endbr32 
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	53                   	push   %ebx
  801821:	83 ec 1c             	sub    $0x1c,%esp
  801824:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801827:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182a:	50                   	push   %eax
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	e8 57 fb ff ff       	call   80138a <fd_lookup>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 4b                	js     801885 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801840:	50                   	push   %eax
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	ff 30                	pushl  (%eax)
  801846:	e8 93 fb ff ff       	call   8013de <dev_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 33                	js     801885 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801855:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801859:	74 2f                	je     80188a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80185b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80185e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801865:	00 00 00 
	stat->st_isdir = 0;
  801868:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80186f:	00 00 00 
	stat->st_dev = dev;
  801872:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801878:	83 ec 08             	sub    $0x8,%esp
  80187b:	53                   	push   %ebx
  80187c:	ff 75 f0             	pushl  -0x10(%ebp)
  80187f:	ff 50 14             	call   *0x14(%eax)
  801882:	83 c4 10             	add    $0x10,%esp
}
  801885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801888:	c9                   	leave  
  801889:	c3                   	ret    
		return -E_NOT_SUPP;
  80188a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188f:	eb f4                	jmp    801885 <fstat+0x6c>

00801891 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801891:	f3 0f 1e fb          	endbr32 
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 fb 01 00 00       	call   801aa2 <open>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 1b                	js     8018cb <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	e8 5d ff ff ff       	call   801819 <fstat>
  8018bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8018be:	89 1c 24             	mov    %ebx,(%esp)
  8018c1:	e8 fd fb ff ff       	call   8014c3 <close>
	return r;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 f3                	mov    %esi,%ebx
}
  8018cb:	89 d8                	mov    %ebx,%eax
  8018cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d0:	5b                   	pop    %ebx
  8018d1:	5e                   	pop    %esi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	89 c6                	mov    %eax,%esi
  8018db:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018dd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018e4:	74 27                	je     80190d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018e6:	6a 07                	push   $0x7
  8018e8:	68 00 50 80 00       	push   $0x805000
  8018ed:	56                   	push   %esi
  8018ee:	ff 35 00 40 80 00    	pushl  0x804000
  8018f4:	e8 5e 08 00 00       	call   802157 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018f9:	83 c4 0c             	add    $0xc,%esp
  8018fc:	6a 00                	push   $0x0
  8018fe:	53                   	push   %ebx
  8018ff:	6a 00                	push   $0x0
  801901:	e8 e4 07 00 00       	call   8020ea <ipc_recv>
}
  801906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	6a 01                	push   $0x1
  801912:	e8 9a 08 00 00       	call   8021b1 <ipc_find_env>
  801917:	a3 00 40 80 00       	mov    %eax,0x804000
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	eb c5                	jmp    8018e6 <fsipc+0x12>

00801921 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801921:	f3 0f 1e fb          	endbr32 
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8b 40 0c             	mov    0xc(%eax),%eax
  801931:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801936:	8b 45 0c             	mov    0xc(%ebp),%eax
  801939:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	b8 02 00 00 00       	mov    $0x2,%eax
  801948:	e8 87 ff ff ff       	call   8018d4 <fsipc>
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <devfile_flush>:
{
  80194f:	f3 0f 1e fb          	endbr32 
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8b 40 0c             	mov    0xc(%eax),%eax
  80195f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801964:	ba 00 00 00 00       	mov    $0x0,%edx
  801969:	b8 06 00 00 00       	mov    $0x6,%eax
  80196e:	e8 61 ff ff ff       	call   8018d4 <fsipc>
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <devfile_stat>:
{
  801975:	f3 0f 1e fb          	endbr32 
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	53                   	push   %ebx
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8b 40 0c             	mov    0xc(%eax),%eax
  801989:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
  801993:	b8 05 00 00 00       	mov    $0x5,%eax
  801998:	e8 37 ff ff ff       	call   8018d4 <fsipc>
  80199d:	85 c0                	test   %eax,%eax
  80199f:	78 2c                	js     8019cd <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	68 00 50 80 00       	push   $0x805000
  8019a9:	53                   	push   %ebx
  8019aa:	e8 e3 ef ff ff       	call   800992 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019af:	a1 80 50 80 00       	mov    0x805080,%eax
  8019b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8019bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <devfile_write>:
{
  8019d2:	f3 0f 1e fb          	endbr32 
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019df:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019e4:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019e9:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f2:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8019f8:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf,buf,n);
  8019fd:	50                   	push   %eax
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	68 08 50 80 00       	push   $0x805008
  801a06:	e8 3d f1 ff ff       	call   800b48 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a10:	b8 04 00 00 00       	mov    $0x4,%eax
  801a15:	e8 ba fe ff ff       	call   8018d4 <fsipc>
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <devfile_read>:
{
  801a1c:	f3 0f 1e fb          	endbr32 
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	56                   	push   %esi
  801a24:	53                   	push   %ebx
  801a25:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a33:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a39:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a43:	e8 8c fe ff ff       	call   8018d4 <fsipc>
  801a48:	89 c3                	mov    %eax,%ebx
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 1f                	js     801a6d <devfile_read+0x51>
	assert(r <= n);
  801a4e:	39 f0                	cmp    %esi,%eax
  801a50:	77 24                	ja     801a76 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a52:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a57:	7f 33                	jg     801a8c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a59:	83 ec 04             	sub    $0x4,%esp
  801a5c:	50                   	push   %eax
  801a5d:	68 00 50 80 00       	push   $0x805000
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 de f0 ff ff       	call   800b48 <memmove>
	return r;
  801a6a:	83 c4 10             	add    $0x10,%esp
}
  801a6d:	89 d8                	mov    %ebx,%eax
  801a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a72:	5b                   	pop    %ebx
  801a73:	5e                   	pop    %esi
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    
	assert(r <= n);
  801a76:	68 b8 2a 80 00       	push   $0x802ab8
  801a7b:	68 bf 2a 80 00       	push   $0x802abf
  801a80:	6a 7d                	push   $0x7d
  801a82:	68 d4 2a 80 00       	push   $0x802ad4
  801a87:	e8 15 e8 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801a8c:	68 df 2a 80 00       	push   $0x802adf
  801a91:	68 bf 2a 80 00       	push   $0x802abf
  801a96:	6a 7e                	push   $0x7e
  801a98:	68 d4 2a 80 00       	push   $0x802ad4
  801a9d:	e8 ff e7 ff ff       	call   8002a1 <_panic>

00801aa2 <open>:
{
  801aa2:	f3 0f 1e fb          	endbr32 
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	56                   	push   %esi
  801aaa:	53                   	push   %ebx
  801aab:	83 ec 1c             	sub    $0x1c,%esp
  801aae:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ab1:	56                   	push   %esi
  801ab2:	e8 98 ee ff ff       	call   80094f <strlen>
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801abf:	7f 6c                	jg     801b2d <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ac1:	83 ec 0c             	sub    $0xc,%esp
  801ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac7:	50                   	push   %eax
  801ac8:	e8 67 f8 ff ff       	call   801334 <fd_alloc>
  801acd:	89 c3                	mov    %eax,%ebx
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 3c                	js     801b12 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ad6:	83 ec 08             	sub    $0x8,%esp
  801ad9:	56                   	push   %esi
  801ada:	68 00 50 80 00       	push   $0x805000
  801adf:	e8 ae ee ff ff       	call   800992 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aef:	b8 01 00 00 00       	mov    $0x1,%eax
  801af4:	e8 db fd ff ff       	call   8018d4 <fsipc>
  801af9:	89 c3                	mov    %eax,%ebx
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	85 c0                	test   %eax,%eax
  801b00:	78 19                	js     801b1b <open+0x79>
	return fd2num(fd);
  801b02:	83 ec 0c             	sub    $0xc,%esp
  801b05:	ff 75 f4             	pushl  -0xc(%ebp)
  801b08:	e8 f8 f7 ff ff       	call   801305 <fd2num>
  801b0d:	89 c3                	mov    %eax,%ebx
  801b0f:	83 c4 10             	add    $0x10,%esp
}
  801b12:	89 d8                	mov    %ebx,%eax
  801b14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b17:	5b                   	pop    %ebx
  801b18:	5e                   	pop    %esi
  801b19:	5d                   	pop    %ebp
  801b1a:	c3                   	ret    
		fd_close(fd, 0);
  801b1b:	83 ec 08             	sub    $0x8,%esp
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 f4             	pushl  -0xc(%ebp)
  801b23:	e8 10 f9 ff ff       	call   801438 <fd_close>
		return r;
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	eb e5                	jmp    801b12 <open+0x70>
		return -E_BAD_PATH;
  801b2d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b32:	eb de                	jmp    801b12 <open+0x70>

00801b34 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b34:	f3 0f 1e fb          	endbr32 
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b43:	b8 08 00 00 00       	mov    $0x8,%eax
  801b48:	e8 87 fd ff ff       	call   8018d4 <fsipc>
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b4f:	f3 0f 1e fb          	endbr32 
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	e8 b3 f7 ff ff       	call   801319 <fd2data>
  801b66:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b68:	83 c4 08             	add    $0x8,%esp
  801b6b:	68 eb 2a 80 00       	push   $0x802aeb
  801b70:	53                   	push   %ebx
  801b71:	e8 1c ee ff ff       	call   800992 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b76:	8b 46 04             	mov    0x4(%esi),%eax
  801b79:	2b 06                	sub    (%esi),%eax
  801b7b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b81:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b88:	00 00 00 
	stat->st_dev = &devpipe;
  801b8b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b92:	30 80 00 
	return 0;
}
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    

00801ba1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ba1:	f3 0f 1e fb          	endbr32 
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 0c             	sub    $0xc,%esp
  801bac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801baf:	53                   	push   %ebx
  801bb0:	6a 00                	push   $0x0
  801bb2:	e8 aa f2 ff ff       	call   800e61 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bb7:	89 1c 24             	mov    %ebx,(%esp)
  801bba:	e8 5a f7 ff ff       	call   801319 <fd2data>
  801bbf:	83 c4 08             	add    $0x8,%esp
  801bc2:	50                   	push   %eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	e8 97 f2 ff ff       	call   800e61 <sys_page_unmap>
}
  801bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <_pipeisclosed>:
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	57                   	push   %edi
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 1c             	sub    $0x1c,%esp
  801bd8:	89 c7                	mov    %eax,%edi
  801bda:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bdc:	a1 04 40 80 00       	mov    0x804004,%eax
  801be1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801be4:	83 ec 0c             	sub    $0xc,%esp
  801be7:	57                   	push   %edi
  801be8:	e8 01 06 00 00       	call   8021ee <pageref>
  801bed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bf0:	89 34 24             	mov    %esi,(%esp)
  801bf3:	e8 f6 05 00 00       	call   8021ee <pageref>
		nn = thisenv->env_runs;
  801bf8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bfe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	39 cb                	cmp    %ecx,%ebx
  801c06:	74 1b                	je     801c23 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c08:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c0b:	75 cf                	jne    801bdc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c0d:	8b 42 58             	mov    0x58(%edx),%eax
  801c10:	6a 01                	push   $0x1
  801c12:	50                   	push   %eax
  801c13:	53                   	push   %ebx
  801c14:	68 f2 2a 80 00       	push   $0x802af2
  801c19:	e8 6a e7 ff ff       	call   800388 <cprintf>
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	eb b9                	jmp    801bdc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c23:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c26:	0f 94 c0             	sete   %al
  801c29:	0f b6 c0             	movzbl %al,%eax
}
  801c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    

00801c34 <devpipe_write>:
{
  801c34:	f3 0f 1e fb          	endbr32 
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	57                   	push   %edi
  801c3c:	56                   	push   %esi
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 28             	sub    $0x28,%esp
  801c41:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c44:	56                   	push   %esi
  801c45:	e8 cf f6 ff ff       	call   801319 <fd2data>
  801c4a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c54:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c57:	74 4f                	je     801ca8 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c59:	8b 43 04             	mov    0x4(%ebx),%eax
  801c5c:	8b 0b                	mov    (%ebx),%ecx
  801c5e:	8d 51 20             	lea    0x20(%ecx),%edx
  801c61:	39 d0                	cmp    %edx,%eax
  801c63:	72 14                	jb     801c79 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c65:	89 da                	mov    %ebx,%edx
  801c67:	89 f0                	mov    %esi,%eax
  801c69:	e8 61 ff ff ff       	call   801bcf <_pipeisclosed>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	75 3b                	jne    801cad <devpipe_write+0x79>
			sys_yield();
  801c72:	e8 3a f1 ff ff       	call   800db1 <sys_yield>
  801c77:	eb e0                	jmp    801c59 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c7c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c80:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c83:	89 c2                	mov    %eax,%edx
  801c85:	c1 fa 1f             	sar    $0x1f,%edx
  801c88:	89 d1                	mov    %edx,%ecx
  801c8a:	c1 e9 1b             	shr    $0x1b,%ecx
  801c8d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c90:	83 e2 1f             	and    $0x1f,%edx
  801c93:	29 ca                	sub    %ecx,%edx
  801c95:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c99:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c9d:	83 c0 01             	add    $0x1,%eax
  801ca0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ca3:	83 c7 01             	add    $0x1,%edi
  801ca6:	eb ac                	jmp    801c54 <devpipe_write+0x20>
	return i;
  801ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  801cab:	eb 05                	jmp    801cb2 <devpipe_write+0x7e>
				return 0;
  801cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5f                   	pop    %edi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    

00801cba <devpipe_read>:
{
  801cba:	f3 0f 1e fb          	endbr32 
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	57                   	push   %edi
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
  801cc4:	83 ec 18             	sub    $0x18,%esp
  801cc7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cca:	57                   	push   %edi
  801ccb:	e8 49 f6 ff ff       	call   801319 <fd2data>
  801cd0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cd2:	83 c4 10             	add    $0x10,%esp
  801cd5:	be 00 00 00 00       	mov    $0x0,%esi
  801cda:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cdd:	75 14                	jne    801cf3 <devpipe_read+0x39>
	return i;
  801cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce2:	eb 02                	jmp    801ce6 <devpipe_read+0x2c>
				return i;
  801ce4:	89 f0                	mov    %esi,%eax
}
  801ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce9:	5b                   	pop    %ebx
  801cea:	5e                   	pop    %esi
  801ceb:	5f                   	pop    %edi
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    
			sys_yield();
  801cee:	e8 be f0 ff ff       	call   800db1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cf3:	8b 03                	mov    (%ebx),%eax
  801cf5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cf8:	75 18                	jne    801d12 <devpipe_read+0x58>
			if (i > 0)
  801cfa:	85 f6                	test   %esi,%esi
  801cfc:	75 e6                	jne    801ce4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801cfe:	89 da                	mov    %ebx,%edx
  801d00:	89 f8                	mov    %edi,%eax
  801d02:	e8 c8 fe ff ff       	call   801bcf <_pipeisclosed>
  801d07:	85 c0                	test   %eax,%eax
  801d09:	74 e3                	je     801cee <devpipe_read+0x34>
				return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	eb d4                	jmp    801ce6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d12:	99                   	cltd   
  801d13:	c1 ea 1b             	shr    $0x1b,%edx
  801d16:	01 d0                	add    %edx,%eax
  801d18:	83 e0 1f             	and    $0x1f,%eax
  801d1b:	29 d0                	sub    %edx,%eax
  801d1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d28:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d2b:	83 c6 01             	add    $0x1,%esi
  801d2e:	eb aa                	jmp    801cda <devpipe_read+0x20>

00801d30 <pipe>:
{
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3f:	50                   	push   %eax
  801d40:	e8 ef f5 ff ff       	call   801334 <fd_alloc>
  801d45:	89 c3                	mov    %eax,%ebx
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	0f 88 23 01 00 00    	js     801e75 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	68 07 04 00 00       	push   $0x407
  801d5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5d:	6a 00                	push   $0x0
  801d5f:	e8 70 f0 ff ff       	call   800dd4 <sys_page_alloc>
  801d64:	89 c3                	mov    %eax,%ebx
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	0f 88 04 01 00 00    	js     801e75 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d77:	50                   	push   %eax
  801d78:	e8 b7 f5 ff ff       	call   801334 <fd_alloc>
  801d7d:	89 c3                	mov    %eax,%ebx
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	85 c0                	test   %eax,%eax
  801d84:	0f 88 db 00 00 00    	js     801e65 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	68 07 04 00 00       	push   $0x407
  801d92:	ff 75 f0             	pushl  -0x10(%ebp)
  801d95:	6a 00                	push   $0x0
  801d97:	e8 38 f0 ff ff       	call   800dd4 <sys_page_alloc>
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	85 c0                	test   %eax,%eax
  801da3:	0f 88 bc 00 00 00    	js     801e65 <pipe+0x135>
	va = fd2data(fd0);
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	ff 75 f4             	pushl  -0xc(%ebp)
  801daf:	e8 65 f5 ff ff       	call   801319 <fd2data>
  801db4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db6:	83 c4 0c             	add    $0xc,%esp
  801db9:	68 07 04 00 00       	push   $0x407
  801dbe:	50                   	push   %eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 0e f0 ff ff       	call   800dd4 <sys_page_alloc>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	0f 88 82 00 00 00    	js     801e55 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd9:	e8 3b f5 ff ff       	call   801319 <fd2data>
  801dde:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801de5:	50                   	push   %eax
  801de6:	6a 00                	push   $0x0
  801de8:	56                   	push   %esi
  801de9:	6a 00                	push   $0x0
  801deb:	e8 2b f0 ff ff       	call   800e1b <sys_page_map>
  801df0:	89 c3                	mov    %eax,%ebx
  801df2:	83 c4 20             	add    $0x20,%esp
  801df5:	85 c0                	test   %eax,%eax
  801df7:	78 4e                	js     801e47 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801df9:	a1 20 30 80 00       	mov    0x803020,%eax
  801dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e01:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e06:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e10:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e15:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e1c:	83 ec 0c             	sub    $0xc,%esp
  801e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e22:	e8 de f4 ff ff       	call   801305 <fd2num>
  801e27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e2a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e2c:	83 c4 04             	add    $0x4,%esp
  801e2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e32:	e8 ce f4 ff ff       	call   801305 <fd2num>
  801e37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e45:	eb 2e                	jmp    801e75 <pipe+0x145>
	sys_page_unmap(0, va);
  801e47:	83 ec 08             	sub    $0x8,%esp
  801e4a:	56                   	push   %esi
  801e4b:	6a 00                	push   $0x0
  801e4d:	e8 0f f0 ff ff       	call   800e61 <sys_page_unmap>
  801e52:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5b:	6a 00                	push   $0x0
  801e5d:	e8 ff ef ff ff       	call   800e61 <sys_page_unmap>
  801e62:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e65:	83 ec 08             	sub    $0x8,%esp
  801e68:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6b:	6a 00                	push   $0x0
  801e6d:	e8 ef ef ff ff       	call   800e61 <sys_page_unmap>
  801e72:	83 c4 10             	add    $0x10,%esp
}
  801e75:	89 d8                	mov    %ebx,%eax
  801e77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7a:	5b                   	pop    %ebx
  801e7b:	5e                   	pop    %esi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <pipeisclosed>:
{
  801e7e:	f3 0f 1e fb          	endbr32 
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8b:	50                   	push   %eax
  801e8c:	ff 75 08             	pushl  0x8(%ebp)
  801e8f:	e8 f6 f4 ff ff       	call   80138a <fd_lookup>
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 18                	js     801eb3 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea1:	e8 73 f4 ff ff       	call   801319 <fd2data>
  801ea6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	e8 1f fd ff ff       	call   801bcf <_pipeisclosed>
  801eb0:	83 c4 10             	add    $0x10,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eb5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebe:	c3                   	ret    

00801ebf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ebf:	f3 0f 1e fb          	endbr32 
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ec9:	68 05 2b 80 00       	push   $0x802b05
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	e8 bc ea ff ff       	call   800992 <strcpy>
	return 0;
}
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devcons_write>:
{
  801edd:	f3 0f 1e fb          	endbr32 
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	57                   	push   %edi
  801ee5:	56                   	push   %esi
  801ee6:	53                   	push   %ebx
  801ee7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801eed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ef2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ef8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801efb:	73 31                	jae    801f2e <devcons_write+0x51>
		m = n - tot;
  801efd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f00:	29 f3                	sub    %esi,%ebx
  801f02:	83 fb 7f             	cmp    $0x7f,%ebx
  801f05:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f0a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	53                   	push   %ebx
  801f11:	89 f0                	mov    %esi,%eax
  801f13:	03 45 0c             	add    0xc(%ebp),%eax
  801f16:	50                   	push   %eax
  801f17:	57                   	push   %edi
  801f18:	e8 2b ec ff ff       	call   800b48 <memmove>
		sys_cputs(buf, m);
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	53                   	push   %ebx
  801f21:	57                   	push   %edi
  801f22:	e8 dd ed ff ff       	call   800d04 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f27:	01 de                	add    %ebx,%esi
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	eb ca                	jmp    801ef8 <devcons_write+0x1b>
}
  801f2e:	89 f0                	mov    %esi,%eax
  801f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    

00801f38 <devcons_read>:
{
  801f38:	f3 0f 1e fb          	endbr32 
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f4b:	74 21                	je     801f6e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f4d:	e8 d4 ed ff ff       	call   800d26 <sys_cgetc>
  801f52:	85 c0                	test   %eax,%eax
  801f54:	75 07                	jne    801f5d <devcons_read+0x25>
		sys_yield();
  801f56:	e8 56 ee ff ff       	call   800db1 <sys_yield>
  801f5b:	eb f0                	jmp    801f4d <devcons_read+0x15>
	if (c < 0)
  801f5d:	78 0f                	js     801f6e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f5f:	83 f8 04             	cmp    $0x4,%eax
  801f62:	74 0c                	je     801f70 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f67:	88 02                	mov    %al,(%edx)
	return 1;
  801f69:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    
		return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
  801f75:	eb f7                	jmp    801f6e <devcons_read+0x36>

00801f77 <cputchar>:
{
  801f77:	f3 0f 1e fb          	endbr32 
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f87:	6a 01                	push   $0x1
  801f89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f8c:	50                   	push   %eax
  801f8d:	e8 72 ed ff ff       	call   800d04 <sys_cputs>
}
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <getchar>:
{
  801f97:	f3 0f 1e fb          	endbr32 
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fa1:	6a 01                	push   $0x1
  801fa3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa6:	50                   	push   %eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	e8 5f f6 ff ff       	call   80160d <read>
	if (r < 0)
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	78 06                	js     801fbb <getchar+0x24>
	if (r < 1)
  801fb5:	74 06                	je     801fbd <getchar+0x26>
	return c;
  801fb7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    
		return -E_EOF;
  801fbd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fc2:	eb f7                	jmp    801fbb <getchar+0x24>

00801fc4 <iscons>:
{
  801fc4:	f3 0f 1e fb          	endbr32 
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd1:	50                   	push   %eax
  801fd2:	ff 75 08             	pushl  0x8(%ebp)
  801fd5:	e8 b0 f3 ff ff       	call   80138a <fd_lookup>
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 11                	js     801ff2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fea:	39 10                	cmp    %edx,(%eax)
  801fec:	0f 94 c0             	sete   %al
  801fef:	0f b6 c0             	movzbl %al,%eax
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <opencons>:
{
  801ff4:	f3 0f 1e fb          	endbr32 
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ffe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	e8 2d f3 ff ff       	call   801334 <fd_alloc>
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 3a                	js     802048 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 07 04 00 00       	push   $0x407
  802016:	ff 75 f4             	pushl  -0xc(%ebp)
  802019:	6a 00                	push   $0x0
  80201b:	e8 b4 ed ff ff       	call   800dd4 <sys_page_alloc>
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	85 c0                	test   %eax,%eax
  802025:	78 21                	js     802048 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802030:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	50                   	push   %eax
  802040:	e8 c0 f2 ff ff       	call   801305 <fd2num>
  802045:	83 c4 10             	add    $0x10,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80204a:	f3 0f 1e fb          	endbr32 
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	53                   	push   %ebx
  802052:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802055:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80205c:	74 0d                	je     80206b <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802066:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802069:	c9                   	leave  
  80206a:	c3                   	ret    
		envid_t envid=sys_getenvid();
  80206b:	e8 1e ed ff ff       	call   800d8e <sys_getenvid>
  802070:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	6a 07                	push   $0x7
  802077:	68 00 f0 bf ee       	push   $0xeebff000
  80207c:	50                   	push   %eax
  80207d:	e8 52 ed ff ff       	call   800dd4 <sys_page_alloc>
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	85 c0                	test   %eax,%eax
  802087:	78 29                	js     8020b2 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802089:	83 ec 08             	sub    $0x8,%esp
  80208c:	68 c6 20 80 00       	push   $0x8020c6
  802091:	53                   	push   %ebx
  802092:	e8 9c ee ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	79 c0                	jns    80205e <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	68 40 2b 80 00       	push   $0x802b40
  8020a6:	6a 24                	push   $0x24
  8020a8:	68 77 2b 80 00       	push   $0x802b77
  8020ad:	e8 ef e1 ff ff       	call   8002a1 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	68 14 2b 80 00       	push   $0x802b14
  8020ba:	6a 22                	push   $0x22
  8020bc:	68 77 2b 80 00       	push   $0x802b77
  8020c1:	e8 db e1 ff ff       	call   8002a1 <_panic>

008020c6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8020c6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8020c7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8020cc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8020ce:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8020d1:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8020d4:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8020d8:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8020dd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8020e1:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8020e3:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8020e4:	83 c4 04             	add    $0x4,%esp
	popfl
  8020e7:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020e8:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8020e9:	c3                   	ret    

008020ea <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020ea:	f3 0f 1e fb          	endbr32 
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	56                   	push   %esi
  8020f2:	53                   	push   %ebx
  8020f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8020f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802103:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	50                   	push   %eax
  80210a:	e8 91 ee ff ff       	call   800fa0 <sys_ipc_recv>
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	85 c0                	test   %eax,%eax
  802114:	78 2b                	js     802141 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  802116:	85 f6                	test   %esi,%esi
  802118:	74 0a                	je     802124 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  80211a:	a1 04 40 80 00       	mov    0x804004,%eax
  80211f:	8b 40 74             	mov    0x74(%eax),%eax
  802122:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  802124:	85 db                	test   %ebx,%ebx
  802126:	74 0a                	je     802132 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  802128:	a1 04 40 80 00       	mov    0x804004,%eax
  80212d:	8b 40 78             	mov    0x78(%eax),%eax
  802130:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802132:	a1 04 40 80 00       	mov    0x804004,%eax
  802137:	8b 40 70             	mov    0x70(%eax),%eax
}
  80213a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213d:	5b                   	pop    %ebx
  80213e:	5e                   	pop    %esi
  80213f:	5d                   	pop    %ebp
  802140:	c3                   	ret    
		if(from_env_store)
  802141:	85 f6                	test   %esi,%esi
  802143:	74 06                	je     80214b <ipc_recv+0x61>
			*from_env_store=0;
  802145:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80214b:	85 db                	test   %ebx,%ebx
  80214d:	74 eb                	je     80213a <ipc_recv+0x50>
			*perm_store=0;
  80214f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802155:	eb e3                	jmp    80213a <ipc_recv+0x50>

00802157 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802157:	f3 0f 1e fb          	endbr32 
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	57                   	push   %edi
  80215f:	56                   	push   %esi
  802160:	53                   	push   %ebx
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	8b 7d 08             	mov    0x8(%ebp),%edi
  802167:	8b 75 0c             	mov    0xc(%ebp),%esi
  80216a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80216d:	85 db                	test   %ebx,%ebx
  80216f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802174:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802177:	ff 75 14             	pushl  0x14(%ebp)
  80217a:	53                   	push   %ebx
  80217b:	56                   	push   %esi
  80217c:	57                   	push   %edi
  80217d:	e8 f7 ed ff ff       	call   800f79 <sys_ipc_try_send>
		if(!res)
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	85 c0                	test   %eax,%eax
  802187:	74 20                	je     8021a9 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802189:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80218c:	75 07                	jne    802195 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80218e:	e8 1e ec ff ff       	call   800db1 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802193:	eb e2                	jmp    802177 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 85 2b 80 00       	push   $0x802b85
  80219d:	6a 3f                	push   $0x3f
  80219f:	68 9d 2b 80 00       	push   $0x802b9d
  8021a4:	e8 f8 e0 ff ff       	call   8002a1 <_panic>
	}
}
  8021a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ac:	5b                   	pop    %ebx
  8021ad:	5e                   	pop    %esi
  8021ae:	5f                   	pop    %edi
  8021af:	5d                   	pop    %ebp
  8021b0:	c3                   	ret    

008021b1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021b1:	f3 0f 1e fb          	endbr32 
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021c0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021c3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021c9:	8b 52 50             	mov    0x50(%edx),%edx
  8021cc:	39 ca                	cmp    %ecx,%edx
  8021ce:	74 11                	je     8021e1 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021d0:	83 c0 01             	add    $0x1,%eax
  8021d3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021d8:	75 e6                	jne    8021c0 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	eb 0b                	jmp    8021ec <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021e9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021ec:	5d                   	pop    %ebp
  8021ed:	c3                   	ret    

008021ee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021ee:	f3 0f 1e fb          	endbr32 
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021f8:	89 c2                	mov    %eax,%edx
  8021fa:	c1 ea 16             	shr    $0x16,%edx
  8021fd:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802204:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802209:	f6 c1 01             	test   $0x1,%cl
  80220c:	74 1c                	je     80222a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80220e:	c1 e8 0c             	shr    $0xc,%eax
  802211:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802218:	a8 01                	test   $0x1,%al
  80221a:	74 0e                	je     80222a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80221c:	c1 e8 0c             	shr    $0xc,%eax
  80221f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802226:	ef 
  802227:	0f b7 d2             	movzwl %dx,%edx
}
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    
  80222e:	66 90                	xchg   %ax,%ax

00802230 <__udivdi3>:
  802230:	f3 0f 1e fb          	endbr32 
  802234:	55                   	push   %ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 1c             	sub    $0x1c,%esp
  80223b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80223f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802243:	8b 74 24 34          	mov    0x34(%esp),%esi
  802247:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80224b:	85 d2                	test   %edx,%edx
  80224d:	75 19                	jne    802268 <__udivdi3+0x38>
  80224f:	39 f3                	cmp    %esi,%ebx
  802251:	76 4d                	jbe    8022a0 <__udivdi3+0x70>
  802253:	31 ff                	xor    %edi,%edi
  802255:	89 e8                	mov    %ebp,%eax
  802257:	89 f2                	mov    %esi,%edx
  802259:	f7 f3                	div    %ebx
  80225b:	89 fa                	mov    %edi,%edx
  80225d:	83 c4 1c             	add    $0x1c,%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5f                   	pop    %edi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
  802265:	8d 76 00             	lea    0x0(%esi),%esi
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	76 14                	jbe    802280 <__udivdi3+0x50>
  80226c:	31 ff                	xor    %edi,%edi
  80226e:	31 c0                	xor    %eax,%eax
  802270:	89 fa                	mov    %edi,%edx
  802272:	83 c4 1c             	add    $0x1c,%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5f                   	pop    %edi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    
  80227a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802280:	0f bd fa             	bsr    %edx,%edi
  802283:	83 f7 1f             	xor    $0x1f,%edi
  802286:	75 48                	jne    8022d0 <__udivdi3+0xa0>
  802288:	39 f2                	cmp    %esi,%edx
  80228a:	72 06                	jb     802292 <__udivdi3+0x62>
  80228c:	31 c0                	xor    %eax,%eax
  80228e:	39 eb                	cmp    %ebp,%ebx
  802290:	77 de                	ja     802270 <__udivdi3+0x40>
  802292:	b8 01 00 00 00       	mov    $0x1,%eax
  802297:	eb d7                	jmp    802270 <__udivdi3+0x40>
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 d9                	mov    %ebx,%ecx
  8022a2:	85 db                	test   %ebx,%ebx
  8022a4:	75 0b                	jne    8022b1 <__udivdi3+0x81>
  8022a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	f7 f3                	div    %ebx
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	31 d2                	xor    %edx,%edx
  8022b3:	89 f0                	mov    %esi,%eax
  8022b5:	f7 f1                	div    %ecx
  8022b7:	89 c6                	mov    %eax,%esi
  8022b9:	89 e8                	mov    %ebp,%eax
  8022bb:	89 f7                	mov    %esi,%edi
  8022bd:	f7 f1                	div    %ecx
  8022bf:	89 fa                	mov    %edi,%edx
  8022c1:	83 c4 1c             	add    $0x1c,%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5f                   	pop    %edi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 f9                	mov    %edi,%ecx
  8022d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022d7:	29 f8                	sub    %edi,%eax
  8022d9:	d3 e2                	shl    %cl,%edx
  8022db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022df:	89 c1                	mov    %eax,%ecx
  8022e1:	89 da                	mov    %ebx,%edx
  8022e3:	d3 ea                	shr    %cl,%edx
  8022e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022e9:	09 d1                	or     %edx,%ecx
  8022eb:	89 f2                	mov    %esi,%edx
  8022ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022f1:	89 f9                	mov    %edi,%ecx
  8022f3:	d3 e3                	shl    %cl,%ebx
  8022f5:	89 c1                	mov    %eax,%ecx
  8022f7:	d3 ea                	shr    %cl,%edx
  8022f9:	89 f9                	mov    %edi,%ecx
  8022fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ff:	89 eb                	mov    %ebp,%ebx
  802301:	d3 e6                	shl    %cl,%esi
  802303:	89 c1                	mov    %eax,%ecx
  802305:	d3 eb                	shr    %cl,%ebx
  802307:	09 de                	or     %ebx,%esi
  802309:	89 f0                	mov    %esi,%eax
  80230b:	f7 74 24 08          	divl   0x8(%esp)
  80230f:	89 d6                	mov    %edx,%esi
  802311:	89 c3                	mov    %eax,%ebx
  802313:	f7 64 24 0c          	mull   0xc(%esp)
  802317:	39 d6                	cmp    %edx,%esi
  802319:	72 15                	jb     802330 <__udivdi3+0x100>
  80231b:	89 f9                	mov    %edi,%ecx
  80231d:	d3 e5                	shl    %cl,%ebp
  80231f:	39 c5                	cmp    %eax,%ebp
  802321:	73 04                	jae    802327 <__udivdi3+0xf7>
  802323:	39 d6                	cmp    %edx,%esi
  802325:	74 09                	je     802330 <__udivdi3+0x100>
  802327:	89 d8                	mov    %ebx,%eax
  802329:	31 ff                	xor    %edi,%edi
  80232b:	e9 40 ff ff ff       	jmp    802270 <__udivdi3+0x40>
  802330:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802333:	31 ff                	xor    %edi,%edi
  802335:	e9 36 ff ff ff       	jmp    802270 <__udivdi3+0x40>
  80233a:	66 90                	xchg   %ax,%ax
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <__umoddi3>:
  802340:	f3 0f 1e fb          	endbr32 
  802344:	55                   	push   %ebp
  802345:	57                   	push   %edi
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	83 ec 1c             	sub    $0x1c,%esp
  80234b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80234f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802353:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 19                	jne    802378 <__umoddi3+0x38>
  80235f:	39 df                	cmp    %ebx,%edi
  802361:	76 5d                	jbe    8023c0 <__umoddi3+0x80>
  802363:	89 f0                	mov    %esi,%eax
  802365:	89 da                	mov    %ebx,%edx
  802367:	f7 f7                	div    %edi
  802369:	89 d0                	mov    %edx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	89 f2                	mov    %esi,%edx
  80237a:	39 d8                	cmp    %ebx,%eax
  80237c:	76 12                	jbe    802390 <__umoddi3+0x50>
  80237e:	89 f0                	mov    %esi,%eax
  802380:	89 da                	mov    %ebx,%edx
  802382:	83 c4 1c             	add    $0x1c,%esp
  802385:	5b                   	pop    %ebx
  802386:	5e                   	pop    %esi
  802387:	5f                   	pop    %edi
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    
  80238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802390:	0f bd e8             	bsr    %eax,%ebp
  802393:	83 f5 1f             	xor    $0x1f,%ebp
  802396:	75 50                	jne    8023e8 <__umoddi3+0xa8>
  802398:	39 d8                	cmp    %ebx,%eax
  80239a:	0f 82 e0 00 00 00    	jb     802480 <__umoddi3+0x140>
  8023a0:	89 d9                	mov    %ebx,%ecx
  8023a2:	39 f7                	cmp    %esi,%edi
  8023a4:	0f 86 d6 00 00 00    	jbe    802480 <__umoddi3+0x140>
  8023aa:	89 d0                	mov    %edx,%eax
  8023ac:	89 ca                	mov    %ecx,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	89 fd                	mov    %edi,%ebp
  8023c2:	85 ff                	test   %edi,%edi
  8023c4:	75 0b                	jne    8023d1 <__umoddi3+0x91>
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f7                	div    %edi
  8023cf:	89 c5                	mov    %eax,%ebp
  8023d1:	89 d8                	mov    %ebx,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f5                	div    %ebp
  8023d7:	89 f0                	mov    %esi,%eax
  8023d9:	f7 f5                	div    %ebp
  8023db:	89 d0                	mov    %edx,%eax
  8023dd:	31 d2                	xor    %edx,%edx
  8023df:	eb 8c                	jmp    80236d <__umoddi3+0x2d>
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 e9                	mov    %ebp,%ecx
  8023ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8023ef:	29 ea                	sub    %ebp,%edx
  8023f1:	d3 e0                	shl    %cl,%eax
  8023f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023f7:	89 d1                	mov    %edx,%ecx
  8023f9:	89 f8                	mov    %edi,%eax
  8023fb:	d3 e8                	shr    %cl,%eax
  8023fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802401:	89 54 24 04          	mov    %edx,0x4(%esp)
  802405:	8b 54 24 04          	mov    0x4(%esp),%edx
  802409:	09 c1                	or     %eax,%ecx
  80240b:	89 d8                	mov    %ebx,%eax
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 e9                	mov    %ebp,%ecx
  802413:	d3 e7                	shl    %cl,%edi
  802415:	89 d1                	mov    %edx,%ecx
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80241f:	d3 e3                	shl    %cl,%ebx
  802421:	89 c7                	mov    %eax,%edi
  802423:	89 d1                	mov    %edx,%ecx
  802425:	89 f0                	mov    %esi,%eax
  802427:	d3 e8                	shr    %cl,%eax
  802429:	89 e9                	mov    %ebp,%ecx
  80242b:	89 fa                	mov    %edi,%edx
  80242d:	d3 e6                	shl    %cl,%esi
  80242f:	09 d8                	or     %ebx,%eax
  802431:	f7 74 24 08          	divl   0x8(%esp)
  802435:	89 d1                	mov    %edx,%ecx
  802437:	89 f3                	mov    %esi,%ebx
  802439:	f7 64 24 0c          	mull   0xc(%esp)
  80243d:	89 c6                	mov    %eax,%esi
  80243f:	89 d7                	mov    %edx,%edi
  802441:	39 d1                	cmp    %edx,%ecx
  802443:	72 06                	jb     80244b <__umoddi3+0x10b>
  802445:	75 10                	jne    802457 <__umoddi3+0x117>
  802447:	39 c3                	cmp    %eax,%ebx
  802449:	73 0c                	jae    802457 <__umoddi3+0x117>
  80244b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80244f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802453:	89 d7                	mov    %edx,%edi
  802455:	89 c6                	mov    %eax,%esi
  802457:	89 ca                	mov    %ecx,%edx
  802459:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80245e:	29 f3                	sub    %esi,%ebx
  802460:	19 fa                	sbb    %edi,%edx
  802462:	89 d0                	mov    %edx,%eax
  802464:	d3 e0                	shl    %cl,%eax
  802466:	89 e9                	mov    %ebp,%ecx
  802468:	d3 eb                	shr    %cl,%ebx
  80246a:	d3 ea                	shr    %cl,%edx
  80246c:	09 d8                	or     %ebx,%eax
  80246e:	83 c4 1c             	add    $0x1c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
  802476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	29 fe                	sub    %edi,%esi
  802482:	19 c3                	sbb    %eax,%ebx
  802484:	89 f2                	mov    %esi,%edx
  802486:	89 d9                	mov    %ebx,%ecx
  802488:	e9 1d ff ff ff       	jmp    8023aa <__umoddi3+0x6a>
