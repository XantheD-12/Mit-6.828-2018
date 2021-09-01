
obj/user/testshell.debug：     文件格式 elf32-i386


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
  80002c:	e8 7d 04 00 00       	call   8004ae <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 84 00 00 00    	sub    $0x84,%esp
  800043:	8b 75 08             	mov    0x8(%ebp),%esi
  800046:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800049:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  80004c:	53                   	push   %ebx
  80004d:	56                   	push   %esi
  80004e:	e8 8b 19 00 00       	call   8019de <seek>
	seek(kfd, off);
  800053:	83 c4 08             	add    $0x8,%esp
  800056:	53                   	push   %ebx
  800057:	57                   	push   %edi
  800058:	e8 81 19 00 00       	call   8019de <seek>

	cprintf("shell produced incorrect output.\n");
  80005d:	c7 04 24 e0 2b 80 00 	movl   $0x802be0,(%esp)
  800064:	e8 94 05 00 00       	call   8005fd <cprintf>
	cprintf("expected:\n===\n");
  800069:	c7 04 24 4b 2c 80 00 	movl   $0x802c4b,(%esp)
  800070:	e8 88 05 00 00       	call   8005fd <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	6a 63                	push   $0x63
  800080:	53                   	push   %ebx
  800081:	57                   	push   %edi
  800082:	e8 fb 17 00 00       	call   801882 <read>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	85 c0                	test   %eax,%eax
  80008c:	7e 0f                	jle    80009d <wrong+0x6a>
		sys_cputs(buf, n);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	50                   	push   %eax
  800092:	53                   	push   %ebx
  800093:	e8 e1 0e 00 00       	call   800f79 <sys_cputs>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	eb de                	jmp    80007b <wrong+0x48>
	cprintf("===\ngot:\n===\n");
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 5a 2c 80 00       	push   $0x802c5a
  8000a5:	e8 53 05 00 00       	call   8005fd <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0d                	jmp    8000bf <wrong+0x8c>
		sys_cputs(buf, n);
  8000b2:	83 ec 08             	sub    $0x8,%esp
  8000b5:	50                   	push   %eax
  8000b6:	53                   	push   %ebx
  8000b7:	e8 bd 0e 00 00       	call   800f79 <sys_cputs>
  8000bc:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bf:	83 ec 04             	sub    $0x4,%esp
  8000c2:	6a 63                	push   $0x63
  8000c4:	53                   	push   %ebx
  8000c5:	56                   	push   %esi
  8000c6:	e8 b7 17 00 00       	call   801882 <read>
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f e0                	jg     8000b2 <wrong+0x7f>
	cprintf("===\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 55 2c 80 00       	push   $0x802c55
  8000da:	e8 1e 05 00 00       	call   8005fd <cprintf>
	exit();
  8000df:	e8 14 04 00 00       	call   8004f8 <exit>
}
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <umain>:
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000fc:	6a 00                	push   $0x0
  8000fe:	e8 35 16 00 00       	call   801738 <close>
	close(1);
  800103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010a:	e8 29 16 00 00       	call   801738 <close>
	opencons();
  80010f:	e8 44 03 00 00       	call   800458 <opencons>
	opencons();
  800114:	e8 3f 03 00 00       	call   800458 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800119:	83 c4 08             	add    $0x8,%esp
  80011c:	6a 00                	push   $0x0
  80011e:	68 68 2c 80 00       	push   $0x802c68
  800123:	e8 ef 1b 00 00       	call   801d17 <open>
  800128:	89 c3                	mov    %eax,%ebx
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	85 c0                	test   %eax,%eax
  80012f:	0f 88 e7 00 00 00    	js     80021c <umain+0x12d>
	if ((wfd = pipe(pfds)) < 0)
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80013b:	50                   	push   %eax
  80013c:	e8 7b 24 00 00       	call   8025bc <pipe>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	85 c0                	test   %eax,%eax
  800146:	0f 88 e2 00 00 00    	js     80022e <umain+0x13f>
	wfd = pfds[1];
  80014c:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 04 2c 80 00       	push   $0x802c04
  800157:	e8 a1 04 00 00       	call   8005fd <cprintf>
	if ((r = fork()) < 0)
  80015c:	e8 dc 11 00 00       	call   80133d <fork>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	85 c0                	test   %eax,%eax
  800166:	0f 88 d4 00 00 00    	js     800240 <umain+0x151>
	if (r == 0) {
  80016c:	75 6f                	jne    8001dd <umain+0xee>
		dup(rfd, 0);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	6a 00                	push   $0x0
  800173:	53                   	push   %ebx
  800174:	e8 19 16 00 00       	call   801792 <dup>
		dup(wfd, 1);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	6a 01                	push   $0x1
  80017e:	56                   	push   %esi
  80017f:	e8 0e 16 00 00       	call   801792 <dup>
		close(rfd);
  800184:	89 1c 24             	mov    %ebx,(%esp)
  800187:	e8 ac 15 00 00       	call   801738 <close>
		close(wfd);
  80018c:	89 34 24             	mov    %esi,(%esp)
  80018f:	e8 a4 15 00 00       	call   801738 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800194:	6a 00                	push   $0x0
  800196:	68 ae 2c 80 00       	push   $0x802cae
  80019b:	68 72 2c 80 00       	push   $0x802c72
  8001a0:	68 b1 2c 80 00       	push   $0x802cb1
  8001a5:	e8 7f 21 00 00       	call   802329 <spawnl>
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	83 c4 20             	add    $0x20,%esp
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	0f 88 9b 00 00 00    	js     800252 <umain+0x163>
		close(0);
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 77 15 00 00       	call   801738 <close>
		close(1);
  8001c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c8:	e8 6b 15 00 00       	call   801738 <close>
		wait(r);
  8001cd:	89 3c 24             	mov    %edi,(%esp)
  8001d0:	e8 6c 25 00 00       	call   802741 <wait>
		exit();
  8001d5:	e8 1e 03 00 00       	call   8004f8 <exit>
  8001da:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	53                   	push   %ebx
  8001e1:	e8 52 15 00 00       	call   801738 <close>
	close(wfd);
  8001e6:	89 34 24             	mov    %esi,(%esp)
  8001e9:	e8 4a 15 00 00       	call   801738 <close>
	rfd = pfds[0];
  8001ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001f4:	83 c4 08             	add    $0x8,%esp
  8001f7:	6a 00                	push   $0x0
  8001f9:	68 bf 2c 80 00       	push   $0x802cbf
  8001fe:	e8 14 1b 00 00       	call   801d17 <open>
  800203:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	85 c0                	test   %eax,%eax
  80020b:	78 57                	js     800264 <umain+0x175>
  80020d:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  800212:	bf 00 00 00 00       	mov    $0x0,%edi
  800217:	e9 9a 00 00 00       	jmp    8002b6 <umain+0x1c7>
		panic("open testshell.sh: %e", rfd);
  80021c:	50                   	push   %eax
  80021d:	68 75 2c 80 00       	push   $0x802c75
  800222:	6a 13                	push   $0x13
  800224:	68 8b 2c 80 00       	push   $0x802c8b
  800229:	e8 e8 02 00 00       	call   800516 <_panic>
		panic("pipe: %e", wfd);
  80022e:	50                   	push   %eax
  80022f:	68 9c 2c 80 00       	push   $0x802c9c
  800234:	6a 15                	push   $0x15
  800236:	68 8b 2c 80 00       	push   $0x802c8b
  80023b:	e8 d6 02 00 00       	call   800516 <_panic>
		panic("fork: %e", r);
  800240:	50                   	push   %eax
  800241:	68 a5 2c 80 00       	push   $0x802ca5
  800246:	6a 1a                	push   $0x1a
  800248:	68 8b 2c 80 00       	push   $0x802c8b
  80024d:	e8 c4 02 00 00       	call   800516 <_panic>
			panic("spawn: %e", r);
  800252:	50                   	push   %eax
  800253:	68 b5 2c 80 00       	push   $0x802cb5
  800258:	6a 21                	push   $0x21
  80025a:	68 8b 2c 80 00       	push   $0x802c8b
  80025f:	e8 b2 02 00 00       	call   800516 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  800264:	50                   	push   %eax
  800265:	68 28 2c 80 00       	push   $0x802c28
  80026a:	6a 2c                	push   $0x2c
  80026c:	68 8b 2c 80 00       	push   $0x802c8b
  800271:	e8 a0 02 00 00       	call   800516 <_panic>
			panic("reading testshell.out: %e", n1);
  800276:	53                   	push   %ebx
  800277:	68 cd 2c 80 00       	push   $0x802ccd
  80027c:	6a 33                	push   $0x33
  80027e:	68 8b 2c 80 00       	push   $0x802c8b
  800283:	e8 8e 02 00 00       	call   800516 <_panic>
			panic("reading testshell.key: %e", n2);
  800288:	50                   	push   %eax
  800289:	68 e7 2c 80 00       	push   $0x802ce7
  80028e:	6a 35                	push   $0x35
  800290:	68 8b 2c 80 00       	push   $0x802c8b
  800295:	e8 7c 02 00 00       	call   800516 <_panic>
			wrong(rfd, kfd, nloff);
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	57                   	push   %edi
  80029e:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a4:	e8 8a fd ff ff       	call   800033 <wrong>
  8002a9:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002ac:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002b0:	0f 44 fe             	cmove  %esi,%edi
  8002b3:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	6a 01                	push   $0x1
  8002bb:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8002c2:	e8 bb 15 00 00       	call   801882 <read>
  8002c7:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c9:	83 c4 0c             	add    $0xc,%esp
  8002cc:	6a 01                	push   $0x1
  8002ce:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d5:	e8 a8 15 00 00       	call   801882 <read>
		if (n1 < 0)
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	85 db                	test   %ebx,%ebx
  8002df:	78 95                	js     800276 <umain+0x187>
		if (n2 < 0)
  8002e1:	85 c0                	test   %eax,%eax
  8002e3:	78 a3                	js     800288 <umain+0x199>
		if (n1 == 0 && n2 == 0)
  8002e5:	89 da                	mov    %ebx,%edx
  8002e7:	09 c2                	or     %eax,%edx
  8002e9:	74 15                	je     800300 <umain+0x211>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002eb:	83 fb 01             	cmp    $0x1,%ebx
  8002ee:	75 aa                	jne    80029a <umain+0x1ab>
  8002f0:	83 f8 01             	cmp    $0x1,%eax
  8002f3:	75 a5                	jne    80029a <umain+0x1ab>
  8002f5:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f9:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002fc:	75 9c                	jne    80029a <umain+0x1ab>
  8002fe:	eb ac                	jmp    8002ac <umain+0x1bd>
	cprintf("shell ran correctly\n");
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 01 2d 80 00       	push   $0x802d01
  800308:	e8 f0 02 00 00       	call   8005fd <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80030d:	cc                   	int3   
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5f                   	pop    %edi
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800319:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	c3                   	ret    

00800323 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80032d:	68 16 2d 80 00       	push   $0x802d16
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	e8 cd 08 00 00       	call   800c07 <strcpy>
	return 0;
}
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <devcons_write>:
{
  800341:	f3 0f 1e fb          	endbr32 
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800351:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800356:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80035c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80035f:	73 31                	jae    800392 <devcons_write+0x51>
		m = n - tot;
  800361:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800364:	29 f3                	sub    %esi,%ebx
  800366:	83 fb 7f             	cmp    $0x7f,%ebx
  800369:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80036e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800371:	83 ec 04             	sub    $0x4,%esp
  800374:	53                   	push   %ebx
  800375:	89 f0                	mov    %esi,%eax
  800377:	03 45 0c             	add    0xc(%ebp),%eax
  80037a:	50                   	push   %eax
  80037b:	57                   	push   %edi
  80037c:	e8 3c 0a 00 00       	call   800dbd <memmove>
		sys_cputs(buf, m);
  800381:	83 c4 08             	add    $0x8,%esp
  800384:	53                   	push   %ebx
  800385:	57                   	push   %edi
  800386:	e8 ee 0b 00 00       	call   800f79 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80038b:	01 de                	add    %ebx,%esi
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	eb ca                	jmp    80035c <devcons_write+0x1b>
}
  800392:	89 f0                	mov    %esi,%eax
  800394:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800397:	5b                   	pop    %ebx
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <devcons_read>:
{
  80039c:	f3 0f 1e fb          	endbr32 
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8003ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003af:	74 21                	je     8003d2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8003b1:	e8 e5 0b 00 00       	call   800f9b <sys_cgetc>
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	75 07                	jne    8003c1 <devcons_read+0x25>
		sys_yield();
  8003ba:	e8 67 0c 00 00       	call   801026 <sys_yield>
  8003bf:	eb f0                	jmp    8003b1 <devcons_read+0x15>
	if (c < 0)
  8003c1:	78 0f                	js     8003d2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8003c3:	83 f8 04             	cmp    $0x4,%eax
  8003c6:	74 0c                	je     8003d4 <devcons_read+0x38>
	*(char*)vbuf = c;
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	88 02                	mov    %al,(%edx)
	return 1;
  8003cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    
		return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d9:	eb f7                	jmp    8003d2 <devcons_read+0x36>

008003db <cputchar>:
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003eb:	6a 01                	push   $0x1
  8003ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f0:	50                   	push   %eax
  8003f1:	e8 83 0b 00 00       	call   800f79 <sys_cputs>
}
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <getchar>:
{
  8003fb:	f3 0f 1e fb          	endbr32 
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800405:	6a 01                	push   $0x1
  800407:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80040a:	50                   	push   %eax
  80040b:	6a 00                	push   $0x0
  80040d:	e8 70 14 00 00       	call   801882 <read>
	if (r < 0)
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	85 c0                	test   %eax,%eax
  800417:	78 06                	js     80041f <getchar+0x24>
	if (r < 1)
  800419:	74 06                	je     800421 <getchar+0x26>
	return c;
  80041b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80041f:	c9                   	leave  
  800420:	c3                   	ret    
		return -E_EOF;
  800421:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800426:	eb f7                	jmp    80041f <getchar+0x24>

00800428 <iscons>:
{
  800428:	f3 0f 1e fb          	endbr32 
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800432:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800435:	50                   	push   %eax
  800436:	ff 75 08             	pushl  0x8(%ebp)
  800439:	e8 c1 11 00 00       	call   8015ff <fd_lookup>
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	85 c0                	test   %eax,%eax
  800443:	78 11                	js     800456 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800448:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80044e:	39 10                	cmp    %edx,(%eax)
  800450:	0f 94 c0             	sete   %al
  800453:	0f b6 c0             	movzbl %al,%eax
}
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <opencons>:
{
  800458:	f3 0f 1e fb          	endbr32 
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800465:	50                   	push   %eax
  800466:	e8 3e 11 00 00       	call   8015a9 <fd_alloc>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	85 c0                	test   %eax,%eax
  800470:	78 3a                	js     8004ac <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 07 04 00 00       	push   $0x407
  80047a:	ff 75 f4             	pushl  -0xc(%ebp)
  80047d:	6a 00                	push   $0x0
  80047f:	e8 c5 0b 00 00       	call   801049 <sys_page_alloc>
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	85 c0                	test   %eax,%eax
  800489:	78 21                	js     8004ac <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80048b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800494:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800499:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8004a0:	83 ec 0c             	sub    $0xc,%esp
  8004a3:	50                   	push   %eax
  8004a4:	e8 d1 10 00 00       	call   80157a <fd2num>
  8004a9:	83 c4 10             	add    $0x10,%esp
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004ae:	f3 0f 1e fb          	endbr32 
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	56                   	push   %esi
  8004b6:	53                   	push   %ebx
  8004b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ba:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004bd:	e8 41 0b 00 00       	call   801003 <sys_getenvid>
  8004c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004cf:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d4:	85 db                	test   %ebx,%ebx
  8004d6:	7e 07                	jle    8004df <libmain+0x31>
		binaryname = argv[0];
  8004d8:	8b 06                	mov    (%esi),%eax
  8004da:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	e8 06 fc ff ff       	call   8000ef <umain>

	// exit gracefully
	exit();
  8004e9:	e8 0a 00 00 00       	call   8004f8 <exit>
}
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004f4:	5b                   	pop    %ebx
  8004f5:	5e                   	pop    %esi
  8004f6:	5d                   	pop    %ebp
  8004f7:	c3                   	ret    

008004f8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f8:	f3 0f 1e fb          	endbr32 
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800502:	e8 62 12 00 00       	call   801769 <close_all>
	sys_env_destroy(0);
  800507:	83 ec 0c             	sub    $0xc,%esp
  80050a:	6a 00                	push   $0x0
  80050c:	e8 ad 0a 00 00       	call   800fbe <sys_env_destroy>
}
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	c9                   	leave  
  800515:	c3                   	ret    

00800516 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800516:	f3 0f 1e fb          	endbr32 
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	56                   	push   %esi
  80051e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80051f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800522:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800528:	e8 d6 0a 00 00       	call   801003 <sys_getenvid>
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	ff 75 0c             	pushl  0xc(%ebp)
  800533:	ff 75 08             	pushl  0x8(%ebp)
  800536:	56                   	push   %esi
  800537:	50                   	push   %eax
  800538:	68 2c 2d 80 00       	push   $0x802d2c
  80053d:	e8 bb 00 00 00       	call   8005fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800542:	83 c4 18             	add    $0x18,%esp
  800545:	53                   	push   %ebx
  800546:	ff 75 10             	pushl  0x10(%ebp)
  800549:	e8 5a 00 00 00       	call   8005a8 <vcprintf>
	cprintf("\n");
  80054e:	c7 04 24 58 2c 80 00 	movl   $0x802c58,(%esp)
  800555:	e8 a3 00 00 00       	call   8005fd <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80055d:	cc                   	int3   
  80055e:	eb fd                	jmp    80055d <_panic+0x47>

00800560 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800560:	f3 0f 1e fb          	endbr32 
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	53                   	push   %ebx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80056e:	8b 13                	mov    (%ebx),%edx
  800570:	8d 42 01             	lea    0x1(%edx),%eax
  800573:	89 03                	mov    %eax,(%ebx)
  800575:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800578:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80057c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800581:	74 09                	je     80058c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800583:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	68 ff 00 00 00       	push   $0xff
  800594:	8d 43 08             	lea    0x8(%ebx),%eax
  800597:	50                   	push   %eax
  800598:	e8 dc 09 00 00       	call   800f79 <sys_cputs>
		b->idx = 0;
  80059d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb db                	jmp    800583 <putch+0x23>

008005a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005a8:	f3 0f 1e fb          	endbr32 
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005bc:	00 00 00 
	b.cnt = 0;
  8005bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	ff 75 08             	pushl  0x8(%ebp)
  8005cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d5:	50                   	push   %eax
  8005d6:	68 60 05 80 00       	push   $0x800560
  8005db:	e8 20 01 00 00       	call   800700 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005e0:	83 c4 08             	add    $0x8,%esp
  8005e3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005ef:	50                   	push   %eax
  8005f0:	e8 84 09 00 00       	call   800f79 <sys_cputs>

	return b.cnt;
}
  8005f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005fd:	f3 0f 1e fb          	endbr32 
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800607:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80060a:	50                   	push   %eax
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 95 ff ff ff       	call   8005a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	57                   	push   %edi
  800619:	56                   	push   %esi
  80061a:	53                   	push   %ebx
  80061b:	83 ec 1c             	sub    $0x1c,%esp
  80061e:	89 c7                	mov    %eax,%edi
  800620:	89 d6                	mov    %edx,%esi
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	8b 55 0c             	mov    0xc(%ebp),%edx
  800628:	89 d1                	mov    %edx,%ecx
  80062a:	89 c2                	mov    %eax,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800632:	8b 45 10             	mov    0x10(%ebp),%eax
  800635:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800642:	39 c2                	cmp    %eax,%edx
  800644:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800647:	72 3e                	jb     800687 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800649:	83 ec 0c             	sub    $0xc,%esp
  80064c:	ff 75 18             	pushl  0x18(%ebp)
  80064f:	83 eb 01             	sub    $0x1,%ebx
  800652:	53                   	push   %ebx
  800653:	50                   	push   %eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065a:	ff 75 e0             	pushl  -0x20(%ebp)
  80065d:	ff 75 dc             	pushl  -0x24(%ebp)
  800660:	ff 75 d8             	pushl  -0x28(%ebp)
  800663:	e8 18 23 00 00       	call   802980 <__udivdi3>
  800668:	83 c4 18             	add    $0x18,%esp
  80066b:	52                   	push   %edx
  80066c:	50                   	push   %eax
  80066d:	89 f2                	mov    %esi,%edx
  80066f:	89 f8                	mov    %edi,%eax
  800671:	e8 9f ff ff ff       	call   800615 <printnum>
  800676:	83 c4 20             	add    $0x20,%esp
  800679:	eb 13                	jmp    80068e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	56                   	push   %esi
  80067f:	ff 75 18             	pushl  0x18(%ebp)
  800682:	ff d7                	call   *%edi
  800684:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800687:	83 eb 01             	sub    $0x1,%ebx
  80068a:	85 db                	test   %ebx,%ebx
  80068c:	7f ed                	jg     80067b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	56                   	push   %esi
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	ff 75 e4             	pushl  -0x1c(%ebp)
  800698:	ff 75 e0             	pushl  -0x20(%ebp)
  80069b:	ff 75 dc             	pushl  -0x24(%ebp)
  80069e:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a1:	e8 ea 23 00 00       	call   802a90 <__umoddi3>
  8006a6:	83 c4 14             	add    $0x14,%esp
  8006a9:	0f be 80 4f 2d 80 00 	movsbl 0x802d4f(%eax),%eax
  8006b0:	50                   	push   %eax
  8006b1:	ff d7                	call   *%edi
}
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006be:	f3 0f 1e fb          	endbr32 
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006cc:	8b 10                	mov    (%eax),%edx
  8006ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8006d1:	73 0a                	jae    8006dd <sprintputch+0x1f>
		*b->buf++ = ch;
  8006d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006d6:	89 08                	mov    %ecx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	88 02                	mov    %al,(%edx)
}
  8006dd:	5d                   	pop    %ebp
  8006de:	c3                   	ret    

008006df <printfmt>:
{
  8006df:	f3 0f 1e fb          	endbr32 
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ec:	50                   	push   %eax
  8006ed:	ff 75 10             	pushl  0x10(%ebp)
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 08             	pushl  0x8(%ebp)
  8006f6:	e8 05 00 00 00       	call   800700 <vprintfmt>
}
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	c9                   	leave  
  8006ff:	c3                   	ret    

00800700 <vprintfmt>:
{
  800700:	f3 0f 1e fb          	endbr32 
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	57                   	push   %edi
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 3c             	sub    $0x3c,%esp
  80070d:	8b 75 08             	mov    0x8(%ebp),%esi
  800710:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800713:	8b 7d 10             	mov    0x10(%ebp),%edi
  800716:	e9 8e 03 00 00       	jmp    800aa9 <vprintfmt+0x3a9>
		padc = ' ';
  80071b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80071f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800726:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80072d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800734:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800739:	8d 47 01             	lea    0x1(%edi),%eax
  80073c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073f:	0f b6 17             	movzbl (%edi),%edx
  800742:	8d 42 dd             	lea    -0x23(%edx),%eax
  800745:	3c 55                	cmp    $0x55,%al
  800747:	0f 87 df 03 00 00    	ja     800b2c <vprintfmt+0x42c>
  80074d:	0f b6 c0             	movzbl %al,%eax
  800750:	3e ff 24 85 a0 2e 80 	notrack jmp *0x802ea0(,%eax,4)
  800757:	00 
  800758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80075b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80075f:	eb d8                	jmp    800739 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800764:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800768:	eb cf                	jmp    800739 <vprintfmt+0x39>
  80076a:	0f b6 d2             	movzbl %dl,%edx
  80076d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800770:	b8 00 00 00 00       	mov    $0x0,%eax
  800775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800778:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80077b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80077f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800782:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800785:	83 f9 09             	cmp    $0x9,%ecx
  800788:	77 55                	ja     8007df <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80078a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80078d:	eb e9                	jmp    800778 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a7:	79 90                	jns    800739 <vprintfmt+0x39>
				width = precision, precision = -1;
  8007a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007b6:	eb 81                	jmp    800739 <vprintfmt+0x39>
  8007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c2:	0f 49 d0             	cmovns %eax,%edx
  8007c5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007cb:	e9 69 ff ff ff       	jmp    800739 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007d3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007da:	e9 5a ff ff ff       	jmp    800739 <vprintfmt+0x39>
  8007df:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	eb bc                	jmp    8007a3 <vprintfmt+0xa3>
			lflag++;
  8007e7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ed:	e9 47 ff ff ff       	jmp    800739 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 78 04             	lea    0x4(%eax),%edi
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	ff 30                	pushl  (%eax)
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800803:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800806:	e9 9b 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 78 04             	lea    0x4(%eax),%edi
  800811:	8b 00                	mov    (%eax),%eax
  800813:	99                   	cltd   
  800814:	31 d0                	xor    %edx,%eax
  800816:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800818:	83 f8 0f             	cmp    $0xf,%eax
  80081b:	7f 23                	jg     800840 <vprintfmt+0x140>
  80081d:	8b 14 85 00 30 80 00 	mov    0x803000(,%eax,4),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	74 18                	je     800840 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800828:	52                   	push   %edx
  800829:	68 b1 32 80 00       	push   $0x8032b1
  80082e:	53                   	push   %ebx
  80082f:	56                   	push   %esi
  800830:	e8 aa fe ff ff       	call   8006df <printfmt>
  800835:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800838:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083b:	e9 66 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800840:	50                   	push   %eax
  800841:	68 67 2d 80 00       	push   $0x802d67
  800846:	53                   	push   %ebx
  800847:	56                   	push   %esi
  800848:	e8 92 fe ff ff       	call   8006df <printfmt>
  80084d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800850:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800853:	e9 4e 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800866:	85 d2                	test   %edx,%edx
  800868:	b8 60 2d 80 00       	mov    $0x802d60,%eax
  80086d:	0f 45 c2             	cmovne %edx,%eax
  800870:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800873:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800877:	7e 06                	jle    80087f <vprintfmt+0x17f>
  800879:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80087d:	75 0d                	jne    80088c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800882:	89 c7                	mov    %eax,%edi
  800884:	03 45 e0             	add    -0x20(%ebp),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80088a:	eb 55                	jmp    8008e1 <vprintfmt+0x1e1>
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 d8             	pushl  -0x28(%ebp)
  800892:	ff 75 cc             	pushl  -0x34(%ebp)
  800895:	e8 46 03 00 00       	call   800be0 <strnlen>
  80089a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089d:	29 c2                	sub    %eax,%edx
  80089f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8008a7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ae:	85 ff                	test   %edi,%edi
  8008b0:	7e 11                	jle    8008c3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bb:	83 ef 01             	sub    $0x1,%edi
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	eb eb                	jmp    8008ae <vprintfmt+0x1ae>
  8008c3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008c6:	85 d2                	test   %edx,%edx
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	0f 49 c2             	cmovns %edx,%eax
  8008d0:	29 c2                	sub    %eax,%edx
  8008d2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008d5:	eb a8                	jmp    80087f <vprintfmt+0x17f>
					putch(ch, putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	53                   	push   %ebx
  8008db:	52                   	push   %edx
  8008dc:	ff d6                	call   *%esi
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e6:	83 c7 01             	add    $0x1,%edi
  8008e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ed:	0f be d0             	movsbl %al,%edx
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	74 4b                	je     80093f <vprintfmt+0x23f>
  8008f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008f8:	78 06                	js     800900 <vprintfmt+0x200>
  8008fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008fe:	78 1e                	js     80091e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800900:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800904:	74 d1                	je     8008d7 <vprintfmt+0x1d7>
  800906:	0f be c0             	movsbl %al,%eax
  800909:	83 e8 20             	sub    $0x20,%eax
  80090c:	83 f8 5e             	cmp    $0x5e,%eax
  80090f:	76 c6                	jbe    8008d7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	53                   	push   %ebx
  800915:	6a 3f                	push   $0x3f
  800917:	ff d6                	call   *%esi
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	eb c3                	jmp    8008e1 <vprintfmt+0x1e1>
  80091e:	89 cf                	mov    %ecx,%edi
  800920:	eb 0e                	jmp    800930 <vprintfmt+0x230>
				putch(' ', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	53                   	push   %ebx
  800926:	6a 20                	push   $0x20
  800928:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80092a:	83 ef 01             	sub    $0x1,%edi
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	85 ff                	test   %edi,%edi
  800932:	7f ee                	jg     800922 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800934:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
  80093a:	e9 67 01 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
  80093f:	89 cf                	mov    %ecx,%edi
  800941:	eb ed                	jmp    800930 <vprintfmt+0x230>
	if (lflag >= 2)
  800943:	83 f9 01             	cmp    $0x1,%ecx
  800946:	7f 1b                	jg     800963 <vprintfmt+0x263>
	else if (lflag)
  800948:	85 c9                	test   %ecx,%ecx
  80094a:	74 63                	je     8009af <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800954:	99                   	cltd   
  800955:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8d 40 04             	lea    0x4(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	eb 17                	jmp    80097a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 50 04             	mov    0x4(%eax),%edx
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 08             	lea    0x8(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80097a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80097d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800980:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800985:	85 c9                	test   %ecx,%ecx
  800987:	0f 89 ff 00 00 00    	jns    800a8c <vprintfmt+0x38c>
				putch('-', putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 2d                	push   $0x2d
  800993:	ff d6                	call   *%esi
				num = -(long long) num;
  800995:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800998:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80099b:	f7 da                	neg    %edx
  80099d:	83 d1 00             	adc    $0x0,%ecx
  8009a0:	f7 d9                	neg    %ecx
  8009a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009aa:	e9 dd 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b7:	99                   	cltd   
  8009b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 40 04             	lea    0x4(%eax),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	eb b4                	jmp    80097a <vprintfmt+0x27a>
	if (lflag >= 2)
  8009c6:	83 f9 01             	cmp    $0x1,%ecx
  8009c9:	7f 1e                	jg     8009e9 <vprintfmt+0x2e9>
	else if (lflag)
  8009cb:	85 c9                	test   %ecx,%ecx
  8009cd:	74 32                	je     800a01 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 10                	mov    (%eax),%edx
  8009d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d9:	8d 40 04             	lea    0x4(%eax),%eax
  8009dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009df:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009e4:	e9 a3 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	8b 10                	mov    (%eax),%edx
  8009ee:	8b 48 04             	mov    0x4(%eax),%ecx
  8009f1:	8d 40 08             	lea    0x8(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009f7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8009fc:	e9 8b 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 10                	mov    (%eax),%edx
  800a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a0b:	8d 40 04             	lea    0x4(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a11:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a16:	eb 74                	jmp    800a8c <vprintfmt+0x38c>
	if (lflag >= 2)
  800a18:	83 f9 01             	cmp    $0x1,%ecx
  800a1b:	7f 1b                	jg     800a38 <vprintfmt+0x338>
	else if (lflag)
  800a1d:	85 c9                	test   %ecx,%ecx
  800a1f:	74 2c                	je     800a4d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	8b 10                	mov    (%eax),%edx
  800a26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a2b:	8d 40 04             	lea    0x4(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800a31:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a36:	eb 54                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 10                	mov    (%eax),%edx
  800a3d:	8b 48 04             	mov    0x4(%eax),%ecx
  800a40:	8d 40 08             	lea    0x8(%eax),%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800a46:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a4b:	eb 3f                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	8b 10                	mov    (%eax),%edx
  800a52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a57:	8d 40 04             	lea    0x4(%eax),%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800a5d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a62:	eb 28                	jmp    800a8c <vprintfmt+0x38c>
			putch('0', putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	53                   	push   %ebx
  800a68:	6a 30                	push   $0x30
  800a6a:	ff d6                	call   *%esi
			putch('x', putdat);
  800a6c:	83 c4 08             	add    $0x8,%esp
  800a6f:	53                   	push   %ebx
  800a70:	6a 78                	push   $0x78
  800a72:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8b 10                	mov    (%eax),%edx
  800a79:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a7e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a81:	8d 40 04             	lea    0x4(%eax),%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a87:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a8c:	83 ec 0c             	sub    $0xc,%esp
  800a8f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a93:	57                   	push   %edi
  800a94:	ff 75 e0             	pushl  -0x20(%ebp)
  800a97:	50                   	push   %eax
  800a98:	51                   	push   %ecx
  800a99:	52                   	push   %edx
  800a9a:	89 da                	mov    %ebx,%edx
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	e8 72 fb ff ff       	call   800615 <printnum>
			break;
  800aa3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa9:	83 c7 01             	add    $0x1,%edi
  800aac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab0:	83 f8 25             	cmp    $0x25,%eax
  800ab3:	0f 84 62 fc ff ff    	je     80071b <vprintfmt+0x1b>
			if (ch == '\0')
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	0f 84 8b 00 00 00    	je     800b4c <vprintfmt+0x44c>
			putch(ch, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	53                   	push   %ebx
  800ac5:	50                   	push   %eax
  800ac6:	ff d6                	call   *%esi
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	eb dc                	jmp    800aa9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800acd:	83 f9 01             	cmp    $0x1,%ecx
  800ad0:	7f 1b                	jg     800aed <vprintfmt+0x3ed>
	else if (lflag)
  800ad2:	85 c9                	test   %ecx,%ecx
  800ad4:	74 2c                	je     800b02 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8b 10                	mov    (%eax),%edx
  800adb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae0:	8d 40 04             	lea    0x4(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800aeb:	eb 9f                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	8b 10                	mov    (%eax),%edx
  800af2:	8b 48 04             	mov    0x4(%eax),%ecx
  800af5:	8d 40 08             	lea    0x8(%eax),%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800afb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800b00:	eb 8a                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	8b 10                	mov    (%eax),%edx
  800b07:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0c:	8d 40 04             	lea    0x4(%eax),%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b12:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b17:	e9 70 ff ff ff       	jmp    800a8c <vprintfmt+0x38c>
			putch(ch, putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	53                   	push   %ebx
  800b20:	6a 25                	push   $0x25
  800b22:	ff d6                	call   *%esi
			break;
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	e9 7a ff ff ff       	jmp    800aa6 <vprintfmt+0x3a6>
			putch('%', putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	53                   	push   %ebx
  800b30:	6a 25                	push   $0x25
  800b32:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	89 f8                	mov    %edi,%eax
  800b39:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b3d:	74 05                	je     800b44 <vprintfmt+0x444>
  800b3f:	83 e8 01             	sub    $0x1,%eax
  800b42:	eb f5                	jmp    800b39 <vprintfmt+0x439>
  800b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b47:	e9 5a ff ff ff       	jmp    800aa6 <vprintfmt+0x3a6>
}
  800b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 18             	sub    $0x18,%esp
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b67:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b6b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b75:	85 c0                	test   %eax,%eax
  800b77:	74 26                	je     800b9f <vsnprintf+0x4b>
  800b79:	85 d2                	test   %edx,%edx
  800b7b:	7e 22                	jle    800b9f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7d:	ff 75 14             	pushl  0x14(%ebp)
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	68 be 06 80 00       	push   $0x8006be
  800b8c:	e8 6f fb ff ff       	call   800700 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    
		return -E_INVAL;
  800b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ba4:	eb f7                	jmp    800b9d <vsnprintf+0x49>

00800ba6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba6:	f3 0f 1e fb          	endbr32 
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bb3:	50                   	push   %eax
  800bb4:	ff 75 10             	pushl  0x10(%ebp)
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	ff 75 08             	pushl  0x8(%ebp)
  800bbd:	e8 92 ff ff ff       	call   800b54 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bd7:	74 05                	je     800bde <strlen+0x1a>
		n++;
  800bd9:	83 c0 01             	add    $0x1,%eax
  800bdc:	eb f5                	jmp    800bd3 <strlen+0xf>
	return n;
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be0:	f3 0f 1e fb          	endbr32 
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	39 d0                	cmp    %edx,%eax
  800bf4:	74 0d                	je     800c03 <strnlen+0x23>
  800bf6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bfa:	74 05                	je     800c01 <strnlen+0x21>
		n++;
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	eb f1                	jmp    800bf2 <strnlen+0x12>
  800c01:	89 c2                	mov    %eax,%edx
	return n;
}
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	f3 0f 1e fb          	endbr32 
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	53                   	push   %ebx
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c1e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c21:	83 c0 01             	add    $0x1,%eax
  800c24:	84 d2                	test   %dl,%dl
  800c26:	75 f2                	jne    800c1a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c28:	89 c8                	mov    %ecx,%eax
  800c2a:	5b                   	pop    %ebx
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	53                   	push   %ebx
  800c35:	83 ec 10             	sub    $0x10,%esp
  800c38:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c3b:	53                   	push   %ebx
  800c3c:	e8 83 ff ff ff       	call   800bc4 <strlen>
  800c41:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	01 d8                	add    %ebx,%eax
  800c49:	50                   	push   %eax
  800c4a:	e8 b8 ff ff ff       	call   800c07 <strcpy>
	return dst;
}
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c56:	f3 0f 1e fb          	endbr32 
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 75 08             	mov    0x8(%ebp),%esi
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6a:	89 f0                	mov    %esi,%eax
  800c6c:	39 d8                	cmp    %ebx,%eax
  800c6e:	74 11                	je     800c81 <strncpy+0x2b>
		*dst++ = *src;
  800c70:	83 c0 01             	add    $0x1,%eax
  800c73:	0f b6 0a             	movzbl (%edx),%ecx
  800c76:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c79:	80 f9 01             	cmp    $0x1,%cl
  800c7c:	83 da ff             	sbb    $0xffffffff,%edx
  800c7f:	eb eb                	jmp    800c6c <strncpy+0x16>
	}
	return ret;
}
  800c81:	89 f0                	mov    %esi,%eax
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	8b 75 08             	mov    0x8(%ebp),%esi
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	8b 55 10             	mov    0x10(%ebp),%edx
  800c99:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c9b:	85 d2                	test   %edx,%edx
  800c9d:	74 21                	je     800cc0 <strlcpy+0x39>
  800c9f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ca3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	74 14                	je     800cbd <strlcpy+0x36>
  800ca9:	0f b6 19             	movzbl (%ecx),%ebx
  800cac:	84 db                	test   %bl,%bl
  800cae:	74 0b                	je     800cbb <strlcpy+0x34>
			*dst++ = *src++;
  800cb0:	83 c1 01             	add    $0x1,%ecx
  800cb3:	83 c2 01             	add    $0x1,%edx
  800cb6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cb9:	eb ea                	jmp    800ca5 <strlcpy+0x1e>
  800cbb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cbd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc0:	29 f0                	sub    %esi,%eax
}
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc6:	f3 0f 1e fb          	endbr32 
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd3:	0f b6 01             	movzbl (%ecx),%eax
  800cd6:	84 c0                	test   %al,%al
  800cd8:	74 0c                	je     800ce6 <strcmp+0x20>
  800cda:	3a 02                	cmp    (%edx),%al
  800cdc:	75 08                	jne    800ce6 <strcmp+0x20>
		p++, q++;
  800cde:	83 c1 01             	add    $0x1,%ecx
  800ce1:	83 c2 01             	add    $0x1,%edx
  800ce4:	eb ed                	jmp    800cd3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	0f b6 c0             	movzbl %al,%eax
  800ce9:	0f b6 12             	movzbl (%edx),%edx
  800cec:	29 d0                	sub    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	53                   	push   %ebx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	89 c3                	mov    %eax,%ebx
  800d00:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d03:	eb 06                	jmp    800d0b <strncmp+0x1b>
		n--, p++, q++;
  800d05:	83 c0 01             	add    $0x1,%eax
  800d08:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d0b:	39 d8                	cmp    %ebx,%eax
  800d0d:	74 16                	je     800d25 <strncmp+0x35>
  800d0f:	0f b6 08             	movzbl (%eax),%ecx
  800d12:	84 c9                	test   %cl,%cl
  800d14:	74 04                	je     800d1a <strncmp+0x2a>
  800d16:	3a 0a                	cmp    (%edx),%cl
  800d18:	74 eb                	je     800d05 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	0f b6 00             	movzbl (%eax),%eax
  800d1d:	0f b6 12             	movzbl (%edx),%edx
  800d20:	29 d0                	sub    %edx,%eax
}
  800d22:	5b                   	pop    %ebx
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	eb f6                	jmp    800d22 <strncmp+0x32>

00800d2c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2c:	f3 0f 1e fb          	endbr32 
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d3a:	0f b6 10             	movzbl (%eax),%edx
  800d3d:	84 d2                	test   %dl,%dl
  800d3f:	74 09                	je     800d4a <strchr+0x1e>
		if (*s == c)
  800d41:	38 ca                	cmp    %cl,%dl
  800d43:	74 0a                	je     800d4f <strchr+0x23>
	for (; *s; s++)
  800d45:	83 c0 01             	add    $0x1,%eax
  800d48:	eb f0                	jmp    800d3a <strchr+0xe>
			return (char *) s;
	return 0;
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d51:	f3 0f 1e fb          	endbr32 
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d5f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d62:	38 ca                	cmp    %cl,%dl
  800d64:	74 09                	je     800d6f <strfind+0x1e>
  800d66:	84 d2                	test   %dl,%dl
  800d68:	74 05                	je     800d6f <strfind+0x1e>
	for (; *s; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	eb f0                	jmp    800d5f <strfind+0xe>
			break;
	return (char *) s;
}
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d81:	85 c9                	test   %ecx,%ecx
  800d83:	74 31                	je     800db6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d85:	89 f8                	mov    %edi,%eax
  800d87:	09 c8                	or     %ecx,%eax
  800d89:	a8 03                	test   $0x3,%al
  800d8b:	75 23                	jne    800db0 <memset+0x3f>
		c &= 0xFF;
  800d8d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d91:	89 d3                	mov    %edx,%ebx
  800d93:	c1 e3 08             	shl    $0x8,%ebx
  800d96:	89 d0                	mov    %edx,%eax
  800d98:	c1 e0 18             	shl    $0x18,%eax
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	c1 e6 10             	shl    $0x10,%esi
  800da0:	09 f0                	or     %esi,%eax
  800da2:	09 c2                	or     %eax,%edx
  800da4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800da6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	fc                   	cld    
  800dac:	f3 ab                	rep stos %eax,%es:(%edi)
  800dae:	eb 06                	jmp    800db6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	fc                   	cld    
  800db4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800db6:	89 f8                	mov    %edi,%eax
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dbd:	f3 0f 1e fb          	endbr32 
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dcf:	39 c6                	cmp    %eax,%esi
  800dd1:	73 32                	jae    800e05 <memmove+0x48>
  800dd3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	76 2b                	jbe    800e05 <memmove+0x48>
		s += n;
		d += n;
  800dda:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ddd:	89 fe                	mov    %edi,%esi
  800ddf:	09 ce                	or     %ecx,%esi
  800de1:	09 d6                	or     %edx,%esi
  800de3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de9:	75 0e                	jne    800df9 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800deb:	83 ef 04             	sub    $0x4,%edi
  800dee:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df4:	fd                   	std    
  800df5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df7:	eb 09                	jmp    800e02 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800df9:	83 ef 01             	sub    $0x1,%edi
  800dfc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dff:	fd                   	std    
  800e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e02:	fc                   	cld    
  800e03:	eb 1a                	jmp    800e1f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	09 ca                	or     %ecx,%edx
  800e09:	09 f2                	or     %esi,%edx
  800e0b:	f6 c2 03             	test   $0x3,%dl
  800e0e:	75 0a                	jne    800e1a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e13:	89 c7                	mov    %eax,%edi
  800e15:	fc                   	cld    
  800e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e18:	eb 05                	jmp    800e1f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e1a:	89 c7                	mov    %eax,%edi
  800e1c:	fc                   	cld    
  800e1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e23:	f3 0f 1e fb          	endbr32 
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2d:	ff 75 10             	pushl  0x10(%ebp)
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	ff 75 08             	pushl  0x8(%ebp)
  800e36:	e8 82 ff ff ff       	call   800dbd <memmove>
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4c:	89 c6                	mov    %eax,%esi
  800e4e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e51:	39 f0                	cmp    %esi,%eax
  800e53:	74 1c                	je     800e71 <memcmp+0x34>
		if (*s1 != *s2)
  800e55:	0f b6 08             	movzbl (%eax),%ecx
  800e58:	0f b6 1a             	movzbl (%edx),%ebx
  800e5b:	38 d9                	cmp    %bl,%cl
  800e5d:	75 08                	jne    800e67 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e5f:	83 c0 01             	add    $0x1,%eax
  800e62:	83 c2 01             	add    $0x1,%edx
  800e65:	eb ea                	jmp    800e51 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e67:	0f b6 c1             	movzbl %cl,%eax
  800e6a:	0f b6 db             	movzbl %bl,%ebx
  800e6d:	29 d8                	sub    %ebx,%eax
  800e6f:	eb 05                	jmp    800e76 <memcmp+0x39>
	}

	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e7a:	f3 0f 1e fb          	endbr32 
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e87:	89 c2                	mov    %eax,%edx
  800e89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e8c:	39 d0                	cmp    %edx,%eax
  800e8e:	73 09                	jae    800e99 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e90:	38 08                	cmp    %cl,(%eax)
  800e92:	74 05                	je     800e99 <memfind+0x1f>
	for (; s < ends; s++)
  800e94:	83 c0 01             	add    $0x1,%eax
  800e97:	eb f3                	jmp    800e8c <memfind+0x12>
			break;
	return (void *) s;
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e9b:	f3 0f 1e fb          	endbr32 
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eab:	eb 03                	jmp    800eb0 <strtol+0x15>
		s++;
  800ead:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb0:	0f b6 01             	movzbl (%ecx),%eax
  800eb3:	3c 20                	cmp    $0x20,%al
  800eb5:	74 f6                	je     800ead <strtol+0x12>
  800eb7:	3c 09                	cmp    $0x9,%al
  800eb9:	74 f2                	je     800ead <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ebb:	3c 2b                	cmp    $0x2b,%al
  800ebd:	74 2a                	je     800ee9 <strtol+0x4e>
	int neg = 0;
  800ebf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ec4:	3c 2d                	cmp    $0x2d,%al
  800ec6:	74 2b                	je     800ef3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ec8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ece:	75 0f                	jne    800edf <strtol+0x44>
  800ed0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ed3:	74 28                	je     800efd <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ed5:	85 db                	test   %ebx,%ebx
  800ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edc:	0f 44 d8             	cmove  %eax,%ebx
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ee7:	eb 46                	jmp    800f2f <strtol+0x94>
		s++;
  800ee9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800eec:	bf 00 00 00 00       	mov    $0x0,%edi
  800ef1:	eb d5                	jmp    800ec8 <strtol+0x2d>
		s++, neg = 1;
  800ef3:	83 c1 01             	add    $0x1,%ecx
  800ef6:	bf 01 00 00 00       	mov    $0x1,%edi
  800efb:	eb cb                	jmp    800ec8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f01:	74 0e                	je     800f11 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f03:	85 db                	test   %ebx,%ebx
  800f05:	75 d8                	jne    800edf <strtol+0x44>
		s++, base = 8;
  800f07:	83 c1 01             	add    $0x1,%ecx
  800f0a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f0f:	eb ce                	jmp    800edf <strtol+0x44>
		s += 2, base = 16;
  800f11:	83 c1 02             	add    $0x2,%ecx
  800f14:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f19:	eb c4                	jmp    800edf <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f1b:	0f be d2             	movsbl %dl,%edx
  800f1e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f24:	7d 3a                	jge    800f60 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f26:	83 c1 01             	add    $0x1,%ecx
  800f29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2f:	0f b6 11             	movzbl (%ecx),%edx
  800f32:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f35:	89 f3                	mov    %esi,%ebx
  800f37:	80 fb 09             	cmp    $0x9,%bl
  800f3a:	76 df                	jbe    800f1b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f3c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f3f:	89 f3                	mov    %esi,%ebx
  800f41:	80 fb 19             	cmp    $0x19,%bl
  800f44:	77 08                	ja     800f4e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f46:	0f be d2             	movsbl %dl,%edx
  800f49:	83 ea 57             	sub    $0x57,%edx
  800f4c:	eb d3                	jmp    800f21 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f4e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f51:	89 f3                	mov    %esi,%ebx
  800f53:	80 fb 19             	cmp    $0x19,%bl
  800f56:	77 08                	ja     800f60 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f58:	0f be d2             	movsbl %dl,%edx
  800f5b:	83 ea 37             	sub    $0x37,%edx
  800f5e:	eb c1                	jmp    800f21 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f64:	74 05                	je     800f6b <strtol+0xd0>
		*endptr = (char *) s;
  800f66:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f69:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f6b:	89 c2                	mov    %eax,%edx
  800f6d:	f7 da                	neg    %edx
  800f6f:	85 ff                	test   %edi,%edi
  800f71:	0f 45 c2             	cmovne %edx,%eax
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f79:	f3 0f 1e fb          	endbr32 
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	89 c7                	mov    %eax,%edi
  800f92:	89 c6                	mov    %eax,%esi
  800f94:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_cgetc>:

int
sys_cgetc(void)
{
  800f9b:	f3 0f 1e fb          	endbr32 
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800faa:	b8 01 00 00 00       	mov    $0x1,%eax
  800faf:	89 d1                	mov    %edx,%ecx
  800fb1:	89 d3                	mov    %edx,%ebx
  800fb3:	89 d7                	mov    %edx,%edi
  800fb5:	89 d6                	mov    %edx,%esi
  800fb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd8:	89 cb                	mov    %ecx,%ebx
  800fda:	89 cf                	mov    %ecx,%edi
  800fdc:	89 ce                	mov    %ecx,%esi
  800fde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	7f 08                	jg     800fec <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	6a 03                	push   $0x3
  800ff2:	68 5f 30 80 00       	push   $0x80305f
  800ff7:	6a 23                	push   $0x23
  800ff9:	68 7c 30 80 00       	push   $0x80307c
  800ffe:	e8 13 f5 ff ff       	call   800516 <_panic>

00801003 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801003:	f3 0f 1e fb          	endbr32 
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	b8 02 00 00 00       	mov    $0x2,%eax
  801017:	89 d1                	mov    %edx,%ecx
  801019:	89 d3                	mov    %edx,%ebx
  80101b:	89 d7                	mov    %edx,%edi
  80101d:	89 d6                	mov    %edx,%esi
  80101f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <sys_yield>:

void
sys_yield(void)
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	ba 00 00 00 00       	mov    $0x0,%edx
  801035:	b8 0b 00 00 00       	mov    $0xb,%eax
  80103a:	89 d1                	mov    %edx,%ecx
  80103c:	89 d3                	mov    %edx,%ebx
  80103e:	89 d7                	mov    %edx,%edi
  801040:	89 d6                	mov    %edx,%esi
  801042:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801049:	f3 0f 1e fb          	endbr32 
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801056:	be 00 00 00 00       	mov    $0x0,%esi
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801061:	b8 04 00 00 00       	mov    $0x4,%eax
  801066:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801069:	89 f7                	mov    %esi,%edi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 04                	push   $0x4
  80107f:	68 5f 30 80 00       	push   $0x80305f
  801084:	6a 23                	push   $0x23
  801086:	68 7c 30 80 00       	push   $0x80307c
  80108b:	e8 86 f4 ff ff       	call   800516 <_panic>

00801090 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8010a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8010b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	7f 08                	jg     8010bf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	50                   	push   %eax
  8010c3:	6a 05                	push   $0x5
  8010c5:	68 5f 30 80 00       	push   $0x80305f
  8010ca:	6a 23                	push   $0x23
  8010cc:	68 7c 30 80 00       	push   $0x80307c
  8010d1:	e8 40 f4 ff ff       	call   800516 <_panic>

008010d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010d6:	f3 0f 1e fb          	endbr32 
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f3:	89 df                	mov    %ebx,%edi
  8010f5:	89 de                	mov    %ebx,%esi
  8010f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	7f 08                	jg     801105 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	50                   	push   %eax
  801109:	6a 06                	push   $0x6
  80110b:	68 5f 30 80 00       	push   $0x80305f
  801110:	6a 23                	push   $0x23
  801112:	68 7c 30 80 00       	push   $0x80307c
  801117:	e8 fa f3 ff ff       	call   800516 <_panic>

0080111c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80111c:	f3 0f 1e fb          	endbr32 
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801134:	b8 08 00 00 00       	mov    $0x8,%eax
  801139:	89 df                	mov    %ebx,%edi
  80113b:	89 de                	mov    %ebx,%esi
  80113d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113f:	85 c0                	test   %eax,%eax
  801141:	7f 08                	jg     80114b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	50                   	push   %eax
  80114f:	6a 08                	push   $0x8
  801151:	68 5f 30 80 00       	push   $0x80305f
  801156:	6a 23                	push   $0x23
  801158:	68 7c 30 80 00       	push   $0x80307c
  80115d:	e8 b4 f3 ff ff       	call   800516 <_panic>

00801162 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	b8 09 00 00 00       	mov    $0x9,%eax
  80117f:	89 df                	mov    %ebx,%edi
  801181:	89 de                	mov    %ebx,%esi
  801183:	cd 30                	int    $0x30
	if(check && ret > 0)
  801185:	85 c0                	test   %eax,%eax
  801187:	7f 08                	jg     801191 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	50                   	push   %eax
  801195:	6a 09                	push   $0x9
  801197:	68 5f 30 80 00       	push   $0x80305f
  80119c:	6a 23                	push   $0x23
  80119e:	68 7c 30 80 00       	push   $0x80307c
  8011a3:	e8 6e f3 ff ff       	call   800516 <_panic>

008011a8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a8:	f3 0f 1e fb          	endbr32 
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c5:	89 df                	mov    %ebx,%edi
  8011c7:	89 de                	mov    %ebx,%esi
  8011c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	7f 08                	jg     8011d7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	50                   	push   %eax
  8011db:	6a 0a                	push   $0xa
  8011dd:	68 5f 30 80 00       	push   $0x80305f
  8011e2:	6a 23                	push   $0x23
  8011e4:	68 7c 30 80 00       	push   $0x80307c
  8011e9:	e8 28 f3 ff ff       	call   800516 <_panic>

008011ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011ee:	f3 0f 1e fb          	endbr32 
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	57                   	push   %edi
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 0c 00 00 00       	mov    $0xc,%eax
  801203:	be 00 00 00 00       	mov    $0x0,%esi
  801208:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80120b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801215:	f3 0f 1e fb          	endbr32 
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	57                   	push   %edi
  80121d:	56                   	push   %esi
  80121e:	53                   	push   %ebx
  80121f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801222:	b9 00 00 00 00       	mov    $0x0,%ecx
  801227:	8b 55 08             	mov    0x8(%ebp),%edx
  80122a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80122f:	89 cb                	mov    %ecx,%ebx
  801231:	89 cf                	mov    %ecx,%edi
  801233:	89 ce                	mov    %ecx,%esi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 0d                	push   $0xd
  801249:	68 5f 30 80 00       	push   $0x80305f
  80124e:	6a 23                	push   $0x23
  801250:	68 7c 30 80 00       	push   $0x80307c
  801255:	e8 bc f2 ff ff       	call   800516 <_panic>

0080125a <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  80125a:	f3 0f 1e fb          	endbr32 
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	56                   	push   %esi
  801262:	53                   	push   %ebx
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801266:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  801268:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80126c:	74 7f                	je     8012ed <pgfault+0x93>
  80126e:	89 f0                	mov    %esi,%eax
  801270:	c1 e8 0c             	shr    $0xc,%eax
  801273:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127a:	f6 c4 08             	test   $0x8,%ah
  80127d:	74 6e                	je     8012ed <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  80127f:	e8 7f fd ff ff       	call   801003 <sys_getenvid>
  801284:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  801286:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	6a 07                	push   $0x7
  801291:	68 00 f0 7f 00       	push   $0x7ff000
  801296:	50                   	push   %eax
  801297:	e8 ad fd ff ff       	call   801049 <sys_page_alloc>
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 5e                	js     801301 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  8012a3:	83 ec 04             	sub    $0x4,%esp
  8012a6:	68 00 10 00 00       	push   $0x1000
  8012ab:	56                   	push   %esi
  8012ac:	68 00 f0 7f 00       	push   $0x7ff000
  8012b1:	e8 6d fb ff ff       	call   800e23 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  8012b6:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	68 00 f0 7f 00       	push   $0x7ff000
  8012c4:	53                   	push   %ebx
  8012c5:	e8 c6 fd ff ff       	call   801090 <sys_page_map>
  8012ca:	83 c4 20             	add    $0x20,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 44                	js     801315 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	68 00 f0 7f 00       	push   $0x7ff000
  8012d9:	53                   	push   %ebx
  8012da:	e8 f7 fd ff ff       	call   8010d6 <sys_page_unmap>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	78 43                	js     801329 <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5e                   	pop    %esi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  8012ed:	83 ec 04             	sub    $0x4,%esp
  8012f0:	68 8a 30 80 00       	push   $0x80308a
  8012f5:	6a 1e                	push   $0x1e
  8012f7:	68 a7 30 80 00       	push   $0x8030a7
  8012fc:	e8 15 f2 ff ff       	call   800516 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	68 38 31 80 00       	push   $0x803138
  801309:	6a 2b                	push   $0x2b
  80130b:	68 a7 30 80 00       	push   $0x8030a7
  801310:	e8 01 f2 ff ff       	call   800516 <_panic>
		panic("pgfault: sys_page_map Failed!");
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	68 b2 30 80 00       	push   $0x8030b2
  80131d:	6a 2f                	push   $0x2f
  80131f:	68 a7 30 80 00       	push   $0x8030a7
  801324:	e8 ed f1 ff ff       	call   800516 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	68 58 31 80 00       	push   $0x803158
  801331:	6a 32                	push   $0x32
  801333:	68 a7 30 80 00       	push   $0x8030a7
  801338:	e8 d9 f1 ff ff       	call   800516 <_panic>

0080133d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80133d:	f3 0f 1e fb          	endbr32 
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	57                   	push   %edi
  801345:	56                   	push   %esi
  801346:	53                   	push   %ebx
  801347:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80134a:	68 5a 12 80 00       	push   $0x80125a
  80134f:	e8 40 14 00 00       	call   802794 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801354:	b8 07 00 00 00       	mov    $0x7,%eax
  801359:	cd 30                	int    $0x30
  80135b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80135e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 2b                	js     801393 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801368:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  80136d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801371:	0f 85 ba 00 00 00    	jne    801431 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  801377:	e8 87 fc ff ff       	call   801003 <sys_getenvid>
  80137c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801381:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801384:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801389:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80138e:	e9 90 01 00 00       	jmp    801523 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	68 d0 30 80 00       	push   $0x8030d0
  80139b:	6a 76                	push   $0x76
  80139d:	68 a7 30 80 00       	push   $0x8030a7
  8013a2:	e8 6f f1 ff ff       	call   800516 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  8013a7:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  8013ae:	e8 50 fc ff ff       	call   801003 <sys_getenvid>
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  8013bc:	56                   	push   %esi
  8013bd:	57                   	push   %edi
  8013be:	ff 75 e0             	pushl  -0x20(%ebp)
  8013c1:	57                   	push   %edi
  8013c2:	50                   	push   %eax
  8013c3:	e8 c8 fc ff ff       	call   801090 <sys_page_map>
  8013c8:	83 c4 20             	add    $0x20,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	79 50                	jns    80141f <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	68 e9 30 80 00       	push   $0x8030e9
  8013d7:	6a 4b                	push   $0x4b
  8013d9:	68 a7 30 80 00       	push   $0x8030a7
  8013de:	e8 33 f1 ff ff       	call   800516 <_panic>
			panic("duppage:child sys_page_map Failed!");
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	68 78 31 80 00       	push   $0x803178
  8013eb:	6a 50                	push   $0x50
  8013ed:	68 a7 30 80 00       	push   $0x8030a7
  8013f2:	e8 1f f1 ff ff       	call   800516 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  8013f7:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013fe:	83 ec 0c             	sub    $0xc,%esp
  801401:	25 07 0e 00 00       	and    $0xe07,%eax
  801406:	50                   	push   %eax
  801407:	57                   	push   %edi
  801408:	ff 75 e0             	pushl  -0x20(%ebp)
  80140b:	57                   	push   %edi
  80140c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80140f:	e8 7c fc ff ff       	call   801090 <sys_page_map>
  801414:	83 c4 20             	add    $0x20,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	0f 88 b4 00 00 00    	js     8014d3 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  80141f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801425:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80142b:	0f 84 b6 00 00 00    	je     8014e7 <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801431:	89 d8                	mov    %ebx,%eax
  801433:	c1 e8 16             	shr    $0x16,%eax
  801436:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80143d:	a8 01                	test   $0x1,%al
  80143f:	74 de                	je     80141f <fork+0xe2>
  801441:	89 de                	mov    %ebx,%esi
  801443:	c1 ee 0c             	shr    $0xc,%esi
  801446:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80144d:	a8 01                	test   $0x1,%al
  80144f:	74 ce                	je     80141f <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801451:	e8 ad fb ff ff       	call   801003 <sys_getenvid>
  801456:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801459:	89 f7                	mov    %esi,%edi
  80145b:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  80145e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801465:	f6 c4 04             	test   $0x4,%ah
  801468:	0f 85 39 ff ff ff    	jne    8013a7 <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  80146e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801475:	a9 02 08 00 00       	test   $0x802,%eax
  80147a:	0f 84 77 ff ff ff    	je     8013f7 <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  801480:	83 ec 0c             	sub    $0xc,%esp
  801483:	68 05 08 00 00       	push   $0x805
  801488:	57                   	push   %edi
  801489:	ff 75 e0             	pushl  -0x20(%ebp)
  80148c:	57                   	push   %edi
  80148d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801490:	e8 fb fb ff ff       	call   801090 <sys_page_map>
  801495:	83 c4 20             	add    $0x20,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	0f 88 43 ff ff ff    	js     8013e3 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	68 05 08 00 00       	push   $0x805
  8014a8:	57                   	push   %edi
  8014a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ac:	50                   	push   %eax
  8014ad:	57                   	push   %edi
  8014ae:	50                   	push   %eax
  8014af:	e8 dc fb ff ff       	call   801090 <sys_page_map>
  8014b4:	83 c4 20             	add    $0x20,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	0f 89 60 ff ff ff    	jns    80141f <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	68 9c 31 80 00       	push   $0x80319c
  8014c7:	6a 52                	push   $0x52
  8014c9:	68 a7 30 80 00       	push   $0x8030a7
  8014ce:	e8 43 f0 ff ff       	call   800516 <_panic>
			panic("duppage: single sys_page_map Failed!");
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	68 c0 31 80 00       	push   $0x8031c0
  8014db:	6a 56                	push   $0x56
  8014dd:	68 a7 30 80 00       	push   $0x8030a7
  8014e2:	e8 2f f0 ff ff       	call   800516 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	6a 07                	push   $0x7
  8014ec:	68 00 f0 bf ee       	push   $0xeebff000
  8014f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8014f4:	e8 50 fb ff ff       	call   801049 <sys_page_alloc>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 2e                	js     80152e <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801500:	83 ec 08             	sub    $0x8,%esp
  801503:	68 10 28 80 00       	push   $0x802810
  801508:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80150b:	57                   	push   %edi
  80150c:	e8 97 fc ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801511:	83 c4 08             	add    $0x8,%esp
  801514:	6a 02                	push   $0x2
  801516:	57                   	push   %edi
  801517:	e8 00 fc ff ff       	call   80111c <sys_env_set_status>
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 22                	js     801545 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801523:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801526:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801529:	5b                   	pop    %ebx
  80152a:	5e                   	pop    %esi
  80152b:	5f                   	pop    %edi
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	68 06 31 80 00       	push   $0x803106
  801536:	68 83 00 00 00       	push   $0x83
  80153b:	68 a7 30 80 00       	push   $0x8030a7
  801540:	e8 d1 ef ff ff       	call   800516 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	68 e8 31 80 00       	push   $0x8031e8
  80154d:	68 89 00 00 00       	push   $0x89
  801552:	68 a7 30 80 00       	push   $0x8030a7
  801557:	e8 ba ef ff ff       	call   800516 <_panic>

0080155c <sfork>:

// Challenge!
int
sfork(void)
{
  80155c:	f3 0f 1e fb          	endbr32 
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801566:	68 22 31 80 00       	push   $0x803122
  80156b:	68 93 00 00 00       	push   $0x93
  801570:	68 a7 30 80 00       	push   $0x8030a7
  801575:	e8 9c ef ff ff       	call   800516 <_panic>

0080157a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80157a:	f3 0f 1e fb          	endbr32 
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	05 00 00 00 30       	add    $0x30000000,%eax
  801589:	c1 e8 0c             	shr    $0xc,%eax
}
  80158c:	5d                   	pop    %ebp
  80158d:	c3                   	ret    

0080158e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80158e:	f3 0f 1e fb          	endbr32 
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80159d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015a9:	f3 0f 1e fb          	endbr32 
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015b5:	89 c2                	mov    %eax,%edx
  8015b7:	c1 ea 16             	shr    $0x16,%edx
  8015ba:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015c1:	f6 c2 01             	test   $0x1,%dl
  8015c4:	74 2d                	je     8015f3 <fd_alloc+0x4a>
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	c1 ea 0c             	shr    $0xc,%edx
  8015cb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015d2:	f6 c2 01             	test   $0x1,%dl
  8015d5:	74 1c                	je     8015f3 <fd_alloc+0x4a>
  8015d7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015dc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015e1:	75 d2                	jne    8015b5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015ec:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015f1:	eb 0a                	jmp    8015fd <fd_alloc+0x54>
			*fd_store = fd;
  8015f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015ff:	f3 0f 1e fb          	endbr32 
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801609:	83 f8 1f             	cmp    $0x1f,%eax
  80160c:	77 30                	ja     80163e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80160e:	c1 e0 0c             	shl    $0xc,%eax
  801611:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801616:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80161c:	f6 c2 01             	test   $0x1,%dl
  80161f:	74 24                	je     801645 <fd_lookup+0x46>
  801621:	89 c2                	mov    %eax,%edx
  801623:	c1 ea 0c             	shr    $0xc,%edx
  801626:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80162d:	f6 c2 01             	test   $0x1,%dl
  801630:	74 1a                	je     80164c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	89 02                	mov    %eax,(%edx)
	return 0;
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    
		return -E_INVAL;
  80163e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801643:	eb f7                	jmp    80163c <fd_lookup+0x3d>
		return -E_INVAL;
  801645:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164a:	eb f0                	jmp    80163c <fd_lookup+0x3d>
  80164c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801651:	eb e9                	jmp    80163c <fd_lookup+0x3d>

00801653 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801653:	f3 0f 1e fb          	endbr32 
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801660:	ba 88 32 80 00       	mov    $0x803288,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801665:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80166a:	39 08                	cmp    %ecx,(%eax)
  80166c:	74 33                	je     8016a1 <dev_lookup+0x4e>
  80166e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801671:	8b 02                	mov    (%edx),%eax
  801673:	85 c0                	test   %eax,%eax
  801675:	75 f3                	jne    80166a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801677:	a1 04 50 80 00       	mov    0x805004,%eax
  80167c:	8b 40 48             	mov    0x48(%eax),%eax
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	51                   	push   %ecx
  801683:	50                   	push   %eax
  801684:	68 0c 32 80 00       	push   $0x80320c
  801689:	e8 6f ef ff ff       	call   8005fd <cprintf>
	*dev = 0;
  80168e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801691:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    
			*dev = devtab[i];
  8016a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ab:	eb f2                	jmp    80169f <dev_lookup+0x4c>

008016ad <fd_close>:
{
  8016ad:	f3 0f 1e fb          	endbr32 
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	57                   	push   %edi
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 24             	sub    $0x24,%esp
  8016ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8016bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016ca:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016cd:	50                   	push   %eax
  8016ce:	e8 2c ff ff ff       	call   8015ff <fd_lookup>
  8016d3:	89 c3                	mov    %eax,%ebx
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 05                	js     8016e1 <fd_close+0x34>
	    || fd != fd2)
  8016dc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016df:	74 16                	je     8016f7 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8016e1:	89 f8                	mov    %edi,%eax
  8016e3:	84 c0                	test   %al,%al
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	0f 44 d8             	cmove  %eax,%ebx
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016fd:	50                   	push   %eax
  8016fe:	ff 36                	pushl  (%esi)
  801700:	e8 4e ff ff ff       	call   801653 <dev_lookup>
  801705:	89 c3                	mov    %eax,%ebx
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 1a                	js     801728 <fd_close+0x7b>
		if (dev->dev_close)
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801714:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801719:	85 c0                	test   %eax,%eax
  80171b:	74 0b                	je     801728 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	56                   	push   %esi
  801721:	ff d0                	call   *%eax
  801723:	89 c3                	mov    %eax,%ebx
  801725:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	56                   	push   %esi
  80172c:	6a 00                	push   $0x0
  80172e:	e8 a3 f9 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	eb b5                	jmp    8016ed <fd_close+0x40>

00801738 <close>:

int
close(int fdnum)
{
  801738:	f3 0f 1e fb          	endbr32 
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801742:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801745:	50                   	push   %eax
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	e8 b1 fe ff ff       	call   8015ff <fd_lookup>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	85 c0                	test   %eax,%eax
  801753:	79 02                	jns    801757 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    
		return fd_close(fd, 1);
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	6a 01                	push   $0x1
  80175c:	ff 75 f4             	pushl  -0xc(%ebp)
  80175f:	e8 49 ff ff ff       	call   8016ad <fd_close>
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	eb ec                	jmp    801755 <close+0x1d>

00801769 <close_all>:

void
close_all(void)
{
  801769:	f3 0f 1e fb          	endbr32 
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	53                   	push   %ebx
  801771:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801774:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801779:	83 ec 0c             	sub    $0xc,%esp
  80177c:	53                   	push   %ebx
  80177d:	e8 b6 ff ff ff       	call   801738 <close>
	for (i = 0; i < MAXFD; i++)
  801782:	83 c3 01             	add    $0x1,%ebx
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	83 fb 20             	cmp    $0x20,%ebx
  80178b:	75 ec                	jne    801779 <close_all+0x10>
}
  80178d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801792:	f3 0f 1e fb          	endbr32 
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	57                   	push   %edi
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80179f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a2:	50                   	push   %eax
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	e8 54 fe ff ff       	call   8015ff <fd_lookup>
  8017ab:	89 c3                	mov    %eax,%ebx
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	0f 88 81 00 00 00    	js     801839 <dup+0xa7>
		return r;
	close(newfdnum);
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	e8 75 ff ff ff       	call   801738 <close>

	newfd = INDEX2FD(newfdnum);
  8017c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017c6:	c1 e6 0c             	shl    $0xc,%esi
  8017c9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017cf:	83 c4 04             	add    $0x4,%esp
  8017d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017d5:	e8 b4 fd ff ff       	call   80158e <fd2data>
  8017da:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017dc:	89 34 24             	mov    %esi,(%esp)
  8017df:	e8 aa fd ff ff       	call   80158e <fd2data>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017e9:	89 d8                	mov    %ebx,%eax
  8017eb:	c1 e8 16             	shr    $0x16,%eax
  8017ee:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017f5:	a8 01                	test   $0x1,%al
  8017f7:	74 11                	je     80180a <dup+0x78>
  8017f9:	89 d8                	mov    %ebx,%eax
  8017fb:	c1 e8 0c             	shr    $0xc,%eax
  8017fe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801805:	f6 c2 01             	test   $0x1,%dl
  801808:	75 39                	jne    801843 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80180a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80180d:	89 d0                	mov    %edx,%eax
  80180f:	c1 e8 0c             	shr    $0xc,%eax
  801812:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	25 07 0e 00 00       	and    $0xe07,%eax
  801821:	50                   	push   %eax
  801822:	56                   	push   %esi
  801823:	6a 00                	push   $0x0
  801825:	52                   	push   %edx
  801826:	6a 00                	push   $0x0
  801828:	e8 63 f8 ff ff       	call   801090 <sys_page_map>
  80182d:	89 c3                	mov    %eax,%ebx
  80182f:	83 c4 20             	add    $0x20,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	78 31                	js     801867 <dup+0xd5>
		goto err;

	return newfdnum;
  801836:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801839:	89 d8                	mov    %ebx,%eax
  80183b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5f                   	pop    %edi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801843:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	25 07 0e 00 00       	and    $0xe07,%eax
  801852:	50                   	push   %eax
  801853:	57                   	push   %edi
  801854:	6a 00                	push   $0x0
  801856:	53                   	push   %ebx
  801857:	6a 00                	push   $0x0
  801859:	e8 32 f8 ff ff       	call   801090 <sys_page_map>
  80185e:	89 c3                	mov    %eax,%ebx
  801860:	83 c4 20             	add    $0x20,%esp
  801863:	85 c0                	test   %eax,%eax
  801865:	79 a3                	jns    80180a <dup+0x78>
	sys_page_unmap(0, newfd);
  801867:	83 ec 08             	sub    $0x8,%esp
  80186a:	56                   	push   %esi
  80186b:	6a 00                	push   $0x0
  80186d:	e8 64 f8 ff ff       	call   8010d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801872:	83 c4 08             	add    $0x8,%esp
  801875:	57                   	push   %edi
  801876:	6a 00                	push   $0x0
  801878:	e8 59 f8 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	eb b7                	jmp    801839 <dup+0xa7>

00801882 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801882:	f3 0f 1e fb          	endbr32 
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 1c             	sub    $0x1c,%esp
  80188d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801890:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801893:	50                   	push   %eax
  801894:	53                   	push   %ebx
  801895:	e8 65 fd ff ff       	call   8015ff <fd_lookup>
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 3f                	js     8018e0 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a7:	50                   	push   %eax
  8018a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ab:	ff 30                	pushl  (%eax)
  8018ad:	e8 a1 fd ff ff       	call   801653 <dev_lookup>
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	78 27                	js     8018e0 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018bc:	8b 42 08             	mov    0x8(%edx),%eax
  8018bf:	83 e0 03             	and    $0x3,%eax
  8018c2:	83 f8 01             	cmp    $0x1,%eax
  8018c5:	74 1e                	je     8018e5 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ca:	8b 40 08             	mov    0x8(%eax),%eax
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	74 35                	je     801906 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	ff 75 10             	pushl  0x10(%ebp)
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	52                   	push   %edx
  8018db:	ff d0                	call   *%eax
  8018dd:	83 c4 10             	add    $0x10,%esp
}
  8018e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018e5:	a1 04 50 80 00       	mov    0x805004,%eax
  8018ea:	8b 40 48             	mov    0x48(%eax),%eax
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	53                   	push   %ebx
  8018f1:	50                   	push   %eax
  8018f2:	68 4d 32 80 00       	push   $0x80324d
  8018f7:	e8 01 ed ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801904:	eb da                	jmp    8018e0 <read+0x5e>
		return -E_NOT_SUPP;
  801906:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80190b:	eb d3                	jmp    8018e0 <read+0x5e>

0080190d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80190d:	f3 0f 1e fb          	endbr32 
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	57                   	push   %edi
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80191d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801920:	bb 00 00 00 00       	mov    $0x0,%ebx
  801925:	eb 02                	jmp    801929 <readn+0x1c>
  801927:	01 c3                	add    %eax,%ebx
  801929:	39 f3                	cmp    %esi,%ebx
  80192b:	73 21                	jae    80194e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	89 f0                	mov    %esi,%eax
  801932:	29 d8                	sub    %ebx,%eax
  801934:	50                   	push   %eax
  801935:	89 d8                	mov    %ebx,%eax
  801937:	03 45 0c             	add    0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	57                   	push   %edi
  80193c:	e8 41 ff ff ff       	call   801882 <read>
		if (m < 0)
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	85 c0                	test   %eax,%eax
  801946:	78 04                	js     80194c <readn+0x3f>
			return m;
		if (m == 0)
  801948:	75 dd                	jne    801927 <readn+0x1a>
  80194a:	eb 02                	jmp    80194e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80194c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801953:	5b                   	pop    %ebx
  801954:	5e                   	pop    %esi
  801955:	5f                   	pop    %edi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    

00801958 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801958:	f3 0f 1e fb          	endbr32 
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	53                   	push   %ebx
  801960:	83 ec 1c             	sub    $0x1c,%esp
  801963:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801966:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801969:	50                   	push   %eax
  80196a:	53                   	push   %ebx
  80196b:	e8 8f fc ff ff       	call   8015ff <fd_lookup>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	78 3a                	js     8019b1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801977:	83 ec 08             	sub    $0x8,%esp
  80197a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197d:	50                   	push   %eax
  80197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801981:	ff 30                	pushl  (%eax)
  801983:	e8 cb fc ff ff       	call   801653 <dev_lookup>
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 22                	js     8019b1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801996:	74 1e                	je     8019b6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199b:	8b 52 0c             	mov    0xc(%edx),%edx
  80199e:	85 d2                	test   %edx,%edx
  8019a0:	74 35                	je     8019d7 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	ff 75 10             	pushl  0x10(%ebp)
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	50                   	push   %eax
  8019ac:	ff d2                	call   *%edx
  8019ae:	83 c4 10             	add    $0x10,%esp
}
  8019b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019b6:	a1 04 50 80 00       	mov    0x805004,%eax
  8019bb:	8b 40 48             	mov    0x48(%eax),%eax
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	53                   	push   %ebx
  8019c2:	50                   	push   %eax
  8019c3:	68 69 32 80 00       	push   $0x803269
  8019c8:	e8 30 ec ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d5:	eb da                	jmp    8019b1 <write+0x59>
		return -E_NOT_SUPP;
  8019d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019dc:	eb d3                	jmp    8019b1 <write+0x59>

008019de <seek>:

int
seek(int fdnum, off_t offset)
{
  8019de:	f3 0f 1e fb          	endbr32 
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019eb:	50                   	push   %eax
  8019ec:	ff 75 08             	pushl  0x8(%ebp)
  8019ef:	e8 0b fc ff ff       	call   8015ff <fd_lookup>
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	78 0e                	js     801a09 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a0b:	f3 0f 1e fb          	endbr32 
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	53                   	push   %ebx
  801a13:	83 ec 1c             	sub    $0x1c,%esp
  801a16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a19:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1c:	50                   	push   %eax
  801a1d:	53                   	push   %ebx
  801a1e:	e8 dc fb ff ff       	call   8015ff <fd_lookup>
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 37                	js     801a61 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a30:	50                   	push   %eax
  801a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a34:	ff 30                	pushl  (%eax)
  801a36:	e8 18 fc ff ff       	call   801653 <dev_lookup>
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 1f                	js     801a61 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a45:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a49:	74 1b                	je     801a66 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4e:	8b 52 18             	mov    0x18(%edx),%edx
  801a51:	85 d2                	test   %edx,%edx
  801a53:	74 32                	je     801a87 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a55:	83 ec 08             	sub    $0x8,%esp
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	50                   	push   %eax
  801a5c:	ff d2                	call   *%edx
  801a5e:	83 c4 10             	add    $0x10,%esp
}
  801a61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a66:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a6b:	8b 40 48             	mov    0x48(%eax),%eax
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	53                   	push   %ebx
  801a72:	50                   	push   %eax
  801a73:	68 2c 32 80 00       	push   $0x80322c
  801a78:	e8 80 eb ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a85:	eb da                	jmp    801a61 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801a87:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a8c:	eb d3                	jmp    801a61 <ftruncate+0x56>

00801a8e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a8e:	f3 0f 1e fb          	endbr32 
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	53                   	push   %ebx
  801a96:	83 ec 1c             	sub    $0x1c,%esp
  801a99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9f:	50                   	push   %eax
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	e8 57 fb ff ff       	call   8015ff <fd_lookup>
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 4b                	js     801afa <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab5:	50                   	push   %eax
  801ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab9:	ff 30                	pushl  (%eax)
  801abb:	e8 93 fb ff ff       	call   801653 <dev_lookup>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 33                	js     801afa <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aca:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ace:	74 2f                	je     801aff <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ad0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ad3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ada:	00 00 00 
	stat->st_isdir = 0;
  801add:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ae4:	00 00 00 
	stat->st_dev = dev;
  801ae7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	53                   	push   %ebx
  801af1:	ff 75 f0             	pushl  -0x10(%ebp)
  801af4:	ff 50 14             	call   *0x14(%eax)
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    
		return -E_NOT_SUPP;
  801aff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b04:	eb f4                	jmp    801afa <fstat+0x6c>

00801b06 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b06:	f3 0f 1e fb          	endbr32 
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	56                   	push   %esi
  801b0e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	e8 fb 01 00 00       	call   801d17 <open>
  801b1c:	89 c3                	mov    %eax,%ebx
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	85 c0                	test   %eax,%eax
  801b23:	78 1b                	js     801b40 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801b25:	83 ec 08             	sub    $0x8,%esp
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	50                   	push   %eax
  801b2c:	e8 5d ff ff ff       	call   801a8e <fstat>
  801b31:	89 c6                	mov    %eax,%esi
	close(fd);
  801b33:	89 1c 24             	mov    %ebx,(%esp)
  801b36:	e8 fd fb ff ff       	call   801738 <close>
	return r;
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	89 f3                	mov    %esi,%ebx
}
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
  801b4e:	89 c6                	mov    %eax,%esi
  801b50:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b52:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b59:	74 27                	je     801b82 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b5b:	6a 07                	push   $0x7
  801b5d:	68 00 60 80 00       	push   $0x806000
  801b62:	56                   	push   %esi
  801b63:	ff 35 00 50 80 00    	pushl  0x805000
  801b69:	e8 33 0d 00 00       	call   8028a1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b6e:	83 c4 0c             	add    $0xc,%esp
  801b71:	6a 00                	push   $0x0
  801b73:	53                   	push   %ebx
  801b74:	6a 00                	push   $0x0
  801b76:	e8 b9 0c 00 00       	call   802834 <ipc_recv>
}
  801b7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5e                   	pop    %esi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	6a 01                	push   $0x1
  801b87:	e8 6f 0d 00 00       	call   8028fb <ipc_find_env>
  801b8c:	a3 00 50 80 00       	mov    %eax,0x805000
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	eb c5                	jmp    801b5b <fsipc+0x12>

00801b96 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b96:	f3 0f 1e fb          	endbr32 
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bae:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb8:	b8 02 00 00 00       	mov    $0x2,%eax
  801bbd:	e8 87 ff ff ff       	call   801b49 <fsipc>
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <devfile_flush>:
{
  801bc4:	f3 0f 1e fb          	endbr32 
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd4:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bde:	b8 06 00 00 00       	mov    $0x6,%eax
  801be3:	e8 61 ff ff ff       	call   801b49 <fsipc>
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <devfile_stat>:
{
  801bea:	f3 0f 1e fb          	endbr32 
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c03:	ba 00 00 00 00       	mov    $0x0,%edx
  801c08:	b8 05 00 00 00       	mov    $0x5,%eax
  801c0d:	e8 37 ff ff ff       	call   801b49 <fsipc>
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 2c                	js     801c42 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	68 00 60 80 00       	push   $0x806000
  801c1e:	53                   	push   %ebx
  801c1f:	e8 e3 ef ff ff       	call   800c07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c24:	a1 80 60 80 00       	mov    0x806080,%eax
  801c29:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c2f:	a1 84 60 80 00       	mov    0x806084,%eax
  801c34:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <devfile_write>:
{
  801c47:	f3 0f 1e fb          	endbr32 
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c59:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c5e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c61:	8b 55 08             	mov    0x8(%ebp),%edx
  801c64:	8b 52 0c             	mov    0xc(%edx),%edx
  801c67:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801c6d:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801c72:	50                   	push   %eax
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	68 08 60 80 00       	push   $0x806008
  801c7b:	e8 3d f1 ff ff       	call   800dbd <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c80:	ba 00 00 00 00       	mov    $0x0,%edx
  801c85:	b8 04 00 00 00       	mov    $0x4,%eax
  801c8a:	e8 ba fe ff ff       	call   801b49 <fsipc>
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <devfile_read>:
{
  801c91:	f3 0f 1e fb          	endbr32 
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	56                   	push   %esi
  801c99:	53                   	push   %ebx
  801c9a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ca8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cae:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb3:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb8:	e8 8c fe ff ff       	call   801b49 <fsipc>
  801cbd:	89 c3                	mov    %eax,%ebx
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 1f                	js     801ce2 <devfile_read+0x51>
	assert(r <= n);
  801cc3:	39 f0                	cmp    %esi,%eax
  801cc5:	77 24                	ja     801ceb <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801cc7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ccc:	7f 33                	jg     801d01 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	50                   	push   %eax
  801cd2:	68 00 60 80 00       	push   $0x806000
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	e8 de f0 ff ff       	call   800dbd <memmove>
	return r;
  801cdf:	83 c4 10             	add    $0x10,%esp
}
  801ce2:	89 d8                	mov    %ebx,%eax
  801ce4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    
	assert(r <= n);
  801ceb:	68 98 32 80 00       	push   $0x803298
  801cf0:	68 9f 32 80 00       	push   $0x80329f
  801cf5:	6a 7d                	push   $0x7d
  801cf7:	68 b4 32 80 00       	push   $0x8032b4
  801cfc:	e8 15 e8 ff ff       	call   800516 <_panic>
	assert(r <= PGSIZE);
  801d01:	68 bf 32 80 00       	push   $0x8032bf
  801d06:	68 9f 32 80 00       	push   $0x80329f
  801d0b:	6a 7e                	push   $0x7e
  801d0d:	68 b4 32 80 00       	push   $0x8032b4
  801d12:	e8 ff e7 ff ff       	call   800516 <_panic>

00801d17 <open>:
{
  801d17:	f3 0f 1e fb          	endbr32 
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 1c             	sub    $0x1c,%esp
  801d23:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d26:	56                   	push   %esi
  801d27:	e8 98 ee ff ff       	call   800bc4 <strlen>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d34:	7f 6c                	jg     801da2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3c:	50                   	push   %eax
  801d3d:	e8 67 f8 ff ff       	call   8015a9 <fd_alloc>
  801d42:	89 c3                	mov    %eax,%ebx
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	85 c0                	test   %eax,%eax
  801d49:	78 3c                	js     801d87 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801d4b:	83 ec 08             	sub    $0x8,%esp
  801d4e:	56                   	push   %esi
  801d4f:	68 00 60 80 00       	push   $0x806000
  801d54:	e8 ae ee ff ff       	call   800c07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d64:	b8 01 00 00 00       	mov    $0x1,%eax
  801d69:	e8 db fd ff ff       	call   801b49 <fsipc>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 19                	js     801d90 <open+0x79>
	return fd2num(fd);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7d:	e8 f8 f7 ff ff       	call   80157a <fd2num>
  801d82:	89 c3                	mov    %eax,%ebx
  801d84:	83 c4 10             	add    $0x10,%esp
}
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    
		fd_close(fd, 0);
  801d90:	83 ec 08             	sub    $0x8,%esp
  801d93:	6a 00                	push   $0x0
  801d95:	ff 75 f4             	pushl  -0xc(%ebp)
  801d98:	e8 10 f9 ff ff       	call   8016ad <fd_close>
		return r;
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	eb e5                	jmp    801d87 <open+0x70>
		return -E_BAD_PATH;
  801da2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801da7:	eb de                	jmp    801d87 <open+0x70>

00801da9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801da9:	f3 0f 1e fb          	endbr32 
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801db3:	ba 00 00 00 00       	mov    $0x0,%edx
  801db8:	b8 08 00 00 00       	mov    $0x8,%eax
  801dbd:	e8 87 fd ff ff       	call   801b49 <fsipc>
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801dc4:	f3 0f 1e fb          	endbr32 
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	57                   	push   %edi
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	//cprintf("spawn start\n");
	if ((r = open(prog, O_RDONLY)) < 0)
  801dd4:	6a 00                	push   $0x0
  801dd6:	ff 75 08             	pushl  0x8(%ebp)
  801dd9:	e8 39 ff ff ff       	call   801d17 <open>
  801dde:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	85 c0                	test   %eax,%eax
  801de9:	0f 88 e9 04 00 00    	js     8022d8 <spawn+0x514>
  801def:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;
	
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	68 00 02 00 00       	push   $0x200
  801df9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801dff:	50                   	push   %eax
  801e00:	51                   	push   %ecx
  801e01:	e8 07 fb ff ff       	call   80190d <readn>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e0e:	75 7e                	jne    801e8e <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801e10:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e17:	45 4c 46 
  801e1a:	75 72                	jne    801e8e <spawn+0xca>
  801e1c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e21:	cd 30                	int    $0x30
  801e23:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801e29:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	0f 88 95 04 00 00    	js     8022cc <spawn+0x508>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e37:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e3c:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801e3f:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e45:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e4b:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e52:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e58:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	char *string_store;
	uintptr_t *argv_store;
	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e5e:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801e63:	be 00 00 00 00       	mov    $0x0,%esi
  801e68:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801e6b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801e72:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801e75:	85 c0                	test   %eax,%eax
  801e77:	74 4d                	je     801ec6 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	50                   	push   %eax
  801e7d:	e8 42 ed ff ff       	call   800bc4 <strlen>
  801e82:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801e86:	83 c3 01             	add    $0x1,%ebx
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	eb dd                	jmp    801e6b <spawn+0xa7>
		close(fd);
  801e8e:	83 ec 0c             	sub    $0xc,%esp
  801e91:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e97:	e8 9c f8 ff ff       	call   801738 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e9c:	83 c4 0c             	add    $0xc,%esp
  801e9f:	68 7f 45 4c 46       	push   $0x464c457f
  801ea4:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801eaa:	68 cb 32 80 00       	push   $0x8032cb
  801eaf:	e8 49 e7 ff ff       	call   8005fd <cprintf>
		return -E_NOT_EXEC;
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801ebe:	ff ff ff 
  801ec1:	e9 12 04 00 00       	jmp    8022d8 <spawn+0x514>
  801ec6:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ecc:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ed2:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ed7:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ed9:	89 fa                	mov    %edi,%edx
  801edb:	83 e2 fc             	and    $0xfffffffc,%edx
  801ede:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ee5:	29 c2                	sub    %eax,%edx
  801ee7:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801eed:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ef0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ef5:	0f 86 00 04 00 00    	jbe    8022fb <spawn+0x537>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	6a 07                	push   $0x7
  801f00:	68 00 00 40 00       	push   $0x400000
  801f05:	6a 00                	push   $0x0
  801f07:	e8 3d f1 ff ff       	call   801049 <sys_page_alloc>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	0f 88 e9 03 00 00    	js     802300 <spawn+0x53c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)

	for (i = 0; i < argc; i++) {
  801f17:	be 00 00 00 00       	mov    $0x0,%esi
  801f1c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801f22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f25:	eb 30                	jmp    801f57 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801f27:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f2d:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f33:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801f36:	83 ec 08             	sub    $0x8,%esp
  801f39:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f3c:	57                   	push   %edi
  801f3d:	e8 c5 ec ff ff       	call   800c07 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f42:	83 c4 04             	add    $0x4,%esp
  801f45:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801f48:	e8 77 ec ff ff       	call   800bc4 <strlen>
  801f4d:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801f51:	83 c6 01             	add    $0x1,%esi
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801f5d:	7f c8                	jg     801f27 <spawn+0x163>
	}

	argv_store[argc] = 0;
  801f5f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f65:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801f6b:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f72:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f78:	0f 85 82 00 00 00    	jne    802000 <spawn+0x23c>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f7e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f84:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801f8a:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801f8d:	89 c8                	mov    %ecx,%eax
  801f8f:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801f95:	89 51 f8             	mov    %edx,-0x8(%ecx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f98:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801f9d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	6a 07                	push   $0x7
  801fa8:	68 00 d0 bf ee       	push   $0xeebfd000
  801fad:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fb3:	68 00 00 40 00       	push   $0x400000
  801fb8:	6a 00                	push   $0x0
  801fba:	e8 d1 f0 ff ff       	call   801090 <sys_page_map>
  801fbf:	83 c4 20             	add    $0x20,%esp
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	0f 88 41 03 00 00    	js     80230b <spawn+0x547>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801fca:	83 ec 08             	sub    $0x8,%esp
  801fcd:	68 00 00 40 00       	push   $0x400000
  801fd2:	6a 00                	push   $0x0
  801fd4:	e8 fd f0 ff ff       	call   8010d6 <sys_page_unmap>
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	0f 88 27 03 00 00    	js     80230b <spawn+0x547>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fe4:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801fea:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ff1:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801ff8:	00 00 00 
  801ffb:	e9 4f 01 00 00       	jmp    80214f <spawn+0x38b>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802000:	68 40 33 80 00       	push   $0x803340
  802005:	68 9f 32 80 00       	push   $0x80329f
  80200a:	68 ea 00 00 00       	push   $0xea
  80200f:	68 e5 32 80 00       	push   $0x8032e5
  802014:	e8 fd e4 ff ff       	call   800516 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	6a 07                	push   $0x7
  80201e:	68 00 00 40 00       	push   $0x400000
  802023:	6a 00                	push   $0x0
  802025:	e8 1f f0 ff ff       	call   801049 <sys_page_alloc>
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	0f 88 b1 02 00 00    	js     8022e6 <spawn+0x522>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80203e:	01 f0                	add    %esi,%eax
  802040:	50                   	push   %eax
  802041:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802047:	e8 92 f9 ff ff       	call   8019de <seek>
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	85 c0                	test   %eax,%eax
  802051:	0f 88 96 02 00 00    	js     8022ed <spawn+0x529>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802060:	29 f0                	sub    %esi,%eax
  802062:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802067:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80206c:	0f 47 c1             	cmova  %ecx,%eax
  80206f:	50                   	push   %eax
  802070:	68 00 00 40 00       	push   $0x400000
  802075:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80207b:	e8 8d f8 ff ff       	call   80190d <readn>
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	85 c0                	test   %eax,%eax
  802085:	0f 88 69 02 00 00    	js     8022f4 <spawn+0x530>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802094:	53                   	push   %ebx
  802095:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80209b:	68 00 00 40 00       	push   $0x400000
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 e9 ef ff ff       	call   801090 <sys_page_map>
  8020a7:	83 c4 20             	add    $0x20,%esp
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 7c                	js     80212a <spawn+0x366>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8020ae:	83 ec 08             	sub    $0x8,%esp
  8020b1:	68 00 00 40 00       	push   $0x400000
  8020b6:	6a 00                	push   $0x0
  8020b8:	e8 19 f0 ff ff       	call   8010d6 <sys_page_unmap>
  8020bd:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8020c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8020c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020cc:	89 fe                	mov    %edi,%esi
  8020ce:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8020d4:	76 69                	jbe    80213f <spawn+0x37b>
		if (i >= filesz) {
  8020d6:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8020dc:	0f 87 37 ff ff ff    	ja     802019 <spawn+0x255>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8020eb:	53                   	push   %ebx
  8020ec:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8020f2:	e8 52 ef ff ff       	call   801049 <sys_page_alloc>
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	79 c2                	jns    8020c0 <spawn+0x2fc>
  8020fe:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802109:	e8 b0 ee ff ff       	call   800fbe <sys_env_destroy>
	close(fd);
  80210e:	83 c4 04             	add    $0x4,%esp
  802111:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802117:	e8 1c f6 ff ff       	call   801738 <close>
	return r;
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802125:	e9 ae 01 00 00       	jmp    8022d8 <spawn+0x514>
				panic("spawn: sys_page_map data: %e", r);
  80212a:	50                   	push   %eax
  80212b:	68 f1 32 80 00       	push   $0x8032f1
  802130:	68 1b 01 00 00       	push   $0x11b
  802135:	68 e5 32 80 00       	push   $0x8032e5
  80213a:	e8 d7 e3 ff ff       	call   800516 <_panic>
  80213f:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802145:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  80214c:	83 c6 20             	add    $0x20,%esi
  80214f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802156:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  80215c:	7e 6d                	jle    8021cb <spawn+0x407>
		if (ph->p_type != ELF_PROG_LOAD)
  80215e:	83 3e 01             	cmpl   $0x1,(%esi)
  802161:	75 e2                	jne    802145 <spawn+0x381>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802163:	8b 46 18             	mov    0x18(%esi),%eax
  802166:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802169:	83 f8 01             	cmp    $0x1,%eax
  80216c:	19 c0                	sbb    %eax,%eax
  80216e:	83 e0 fe             	and    $0xfffffffe,%eax
  802171:	83 c0 07             	add    $0x7,%eax
  802174:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80217a:	8b 4e 04             	mov    0x4(%esi),%ecx
  80217d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802183:	8b 56 10             	mov    0x10(%esi),%edx
  802186:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  80218c:	8b 7e 14             	mov    0x14(%esi),%edi
  80218f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802195:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802198:	89 d8                	mov    %ebx,%eax
  80219a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80219f:	74 1a                	je     8021bb <spawn+0x3f7>
		va -= i;
  8021a1:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8021a3:	01 c7                	add    %eax,%edi
  8021a5:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8021ab:	01 c2                	add    %eax,%edx
  8021ad:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8021b3:	29 c1                	sub    %eax,%ecx
  8021b5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8021bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c0:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8021c6:	e9 01 ff ff ff       	jmp    8020cc <spawn+0x308>
	close(fd);
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021d4:	e8 5f f5 ff ff       	call   801738 <close>
  8021d9:	83 c4 10             	add    $0x10,%esp
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  8021dc:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8021e1:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8021e7:	eb 33                	jmp    80221c <spawn+0x458>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
		sys_page_map(thisenv->env_id,(void *)addr,child,(void *)addr,(uvpt[PGNUM(addr)] & PTE_SYSCALL));
  8021e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021f0:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8021f6:	8b 52 48             	mov    0x48(%edx),%edx
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	25 07 0e 00 00       	and    $0xe07,%eax
  802201:	50                   	push   %eax
  802202:	53                   	push   %ebx
  802203:	56                   	push   %esi
  802204:	53                   	push   %ebx
  802205:	52                   	push   %edx
  802206:	e8 85 ee ff ff       	call   801090 <sys_page_map>
  80220b:	83 c4 20             	add    $0x20,%esp
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  80220e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802214:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80221a:	74 3b                	je     802257 <spawn+0x493>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
  80221c:	89 d8                	mov    %ebx,%eax
  80221e:	c1 e8 16             	shr    $0x16,%eax
  802221:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802228:	a8 01                	test   $0x1,%al
  80222a:	74 e2                	je     80220e <spawn+0x44a>
  80222c:	89 d8                	mov    %ebx,%eax
  80222e:	c1 e8 0c             	shr    $0xc,%eax
  802231:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802238:	f6 c2 01             	test   $0x1,%dl
  80223b:	74 d1                	je     80220e <spawn+0x44a>
  80223d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802244:	f6 c2 04             	test   $0x4,%dl
  802247:	74 c5                	je     80220e <spawn+0x44a>
  802249:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802250:	f6 c6 04             	test   $0x4,%dh
  802253:	74 b9                	je     80220e <spawn+0x44a>
  802255:	eb 92                	jmp    8021e9 <spawn+0x425>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802257:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80225e:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802261:	83 ec 08             	sub    $0x8,%esp
  802264:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80226a:	50                   	push   %eax
  80226b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802271:	e8 ec ee ff ff       	call   801162 <sys_env_set_trapframe>
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 25                	js     8022a2 <spawn+0x4de>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80227d:	83 ec 08             	sub    $0x8,%esp
  802280:	6a 02                	push   $0x2
  802282:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802288:	e8 8f ee ff ff       	call   80111c <sys_env_set_status>
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	85 c0                	test   %eax,%eax
  802292:	78 23                	js     8022b7 <spawn+0x4f3>
	return child;
  802294:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80229a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8022a0:	eb 36                	jmp    8022d8 <spawn+0x514>
		panic("sys_env_set_trapframe: %e", r);
  8022a2:	50                   	push   %eax
  8022a3:	68 0e 33 80 00       	push   $0x80330e
  8022a8:	68 82 00 00 00       	push   $0x82
  8022ad:	68 e5 32 80 00       	push   $0x8032e5
  8022b2:	e8 5f e2 ff ff       	call   800516 <_panic>
		panic("sys_env_set_status: %e", r);
  8022b7:	50                   	push   %eax
  8022b8:	68 28 33 80 00       	push   $0x803328
  8022bd:	68 84 00 00 00       	push   $0x84
  8022c2:	68 e5 32 80 00       	push   $0x8032e5
  8022c7:	e8 4a e2 ff ff       	call   800516 <_panic>
		return r;
  8022cc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022d2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8022d8:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8022de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	89 c7                	mov    %eax,%edi
  8022e8:	e9 13 fe ff ff       	jmp    802100 <spawn+0x33c>
  8022ed:	89 c7                	mov    %eax,%edi
  8022ef:	e9 0c fe ff ff       	jmp    802100 <spawn+0x33c>
  8022f4:	89 c7                	mov    %eax,%edi
  8022f6:	e9 05 fe ff ff       	jmp    802100 <spawn+0x33c>
		return -E_NO_MEM;
  8022fb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  802300:	c1 e8 1f             	shr    $0x1f,%eax
  802303:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802309:	eb cd                	jmp    8022d8 <spawn+0x514>
	sys_page_unmap(0, UTEMP);
  80230b:	83 ec 08             	sub    $0x8,%esp
  80230e:	68 00 00 40 00       	push   $0x400000
  802313:	6a 00                	push   $0x0
  802315:	e8 bc ed ff ff       	call   8010d6 <sys_page_unmap>
  80231a:	83 c4 10             	add    $0x10,%esp
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  80231d:	c7 85 94 fd ff ff 01 	movl   $0x1,-0x26c(%ebp)
  802324:	00 00 00 
  802327:	eb af                	jmp    8022d8 <spawn+0x514>

00802329 <spawnl>:
{
  802329:	f3 0f 1e fb          	endbr32 
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	57                   	push   %edi
  802331:	56                   	push   %esi
  802332:	53                   	push   %ebx
  802333:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802336:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80233e:	8d 4a 04             	lea    0x4(%edx),%ecx
  802341:	83 3a 00             	cmpl   $0x0,(%edx)
  802344:	74 07                	je     80234d <spawnl+0x24>
		argc++;
  802346:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802349:	89 ca                	mov    %ecx,%edx
  80234b:	eb f1                	jmp    80233e <spawnl+0x15>
	const char *argv[argc+2];
  80234d:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802354:	89 d1                	mov    %edx,%ecx
  802356:	83 e1 f0             	and    $0xfffffff0,%ecx
  802359:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80235f:	89 e6                	mov    %esp,%esi
  802361:	29 d6                	sub    %edx,%esi
  802363:	89 f2                	mov    %esi,%edx
  802365:	39 d4                	cmp    %edx,%esp
  802367:	74 10                	je     802379 <spawnl+0x50>
  802369:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  80236f:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802376:	00 
  802377:	eb ec                	jmp    802365 <spawnl+0x3c>
  802379:	89 ca                	mov    %ecx,%edx
  80237b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802381:	29 d4                	sub    %edx,%esp
  802383:	85 d2                	test   %edx,%edx
  802385:	74 05                	je     80238c <spawnl+0x63>
  802387:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  80238c:	8d 74 24 03          	lea    0x3(%esp),%esi
  802390:	89 f2                	mov    %esi,%edx
  802392:	c1 ea 02             	shr    $0x2,%edx
  802395:	83 e6 fc             	and    $0xfffffffc,%esi
  802398:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80239a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8023a4:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8023ab:	00 
	va_start(vl, arg0);
  8023ac:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8023af:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	eb 0b                	jmp    8023c3 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  8023b8:	83 c0 01             	add    $0x1,%eax
  8023bb:	8b 39                	mov    (%ecx),%edi
  8023bd:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8023c0:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8023c3:	39 d0                	cmp    %edx,%eax
  8023c5:	75 f1                	jne    8023b8 <spawnl+0x8f>
	return spawn(prog, argv);
  8023c7:	83 ec 08             	sub    $0x8,%esp
  8023ca:	56                   	push   %esi
  8023cb:	ff 75 08             	pushl  0x8(%ebp)
  8023ce:	e8 f1 f9 ff ff       	call   801dc4 <spawn>
}
  8023d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d6:	5b                   	pop    %ebx
  8023d7:	5e                   	pop    %esi
  8023d8:	5f                   	pop    %edi
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    

008023db <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023db:	f3 0f 1e fb          	endbr32 
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	ff 75 08             	pushl  0x8(%ebp)
  8023ed:	e8 9c f1 ff ff       	call   80158e <fd2data>
  8023f2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023f4:	83 c4 08             	add    $0x8,%esp
  8023f7:	68 66 33 80 00       	push   $0x803366
  8023fc:	53                   	push   %ebx
  8023fd:	e8 05 e8 ff ff       	call   800c07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802402:	8b 46 04             	mov    0x4(%esi),%eax
  802405:	2b 06                	sub    (%esi),%eax
  802407:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80240d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802414:	00 00 00 
	stat->st_dev = &devpipe;
  802417:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80241e:	40 80 00 
	return 0;
}
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802429:	5b                   	pop    %ebx
  80242a:	5e                   	pop    %esi
  80242b:	5d                   	pop    %ebp
  80242c:	c3                   	ret    

0080242d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80242d:	f3 0f 1e fb          	endbr32 
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	53                   	push   %ebx
  802435:	83 ec 0c             	sub    $0xc,%esp
  802438:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80243b:	53                   	push   %ebx
  80243c:	6a 00                	push   $0x0
  80243e:	e8 93 ec ff ff       	call   8010d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802443:	89 1c 24             	mov    %ebx,(%esp)
  802446:	e8 43 f1 ff ff       	call   80158e <fd2data>
  80244b:	83 c4 08             	add    $0x8,%esp
  80244e:	50                   	push   %eax
  80244f:	6a 00                	push   $0x0
  802451:	e8 80 ec ff ff       	call   8010d6 <sys_page_unmap>
}
  802456:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <_pipeisclosed>:
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	57                   	push   %edi
  80245f:	56                   	push   %esi
  802460:	53                   	push   %ebx
  802461:	83 ec 1c             	sub    $0x1c,%esp
  802464:	89 c7                	mov    %eax,%edi
  802466:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802468:	a1 04 50 80 00       	mov    0x805004,%eax
  80246d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802470:	83 ec 0c             	sub    $0xc,%esp
  802473:	57                   	push   %edi
  802474:	e8 bf 04 00 00       	call   802938 <pageref>
  802479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80247c:	89 34 24             	mov    %esi,(%esp)
  80247f:	e8 b4 04 00 00       	call   802938 <pageref>
		nn = thisenv->env_runs;
  802484:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80248a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80248d:	83 c4 10             	add    $0x10,%esp
  802490:	39 cb                	cmp    %ecx,%ebx
  802492:	74 1b                	je     8024af <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802494:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802497:	75 cf                	jne    802468 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802499:	8b 42 58             	mov    0x58(%edx),%eax
  80249c:	6a 01                	push   $0x1
  80249e:	50                   	push   %eax
  80249f:	53                   	push   %ebx
  8024a0:	68 6d 33 80 00       	push   $0x80336d
  8024a5:	e8 53 e1 ff ff       	call   8005fd <cprintf>
  8024aa:	83 c4 10             	add    $0x10,%esp
  8024ad:	eb b9                	jmp    802468 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024af:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024b2:	0f 94 c0             	sete   %al
  8024b5:	0f b6 c0             	movzbl %al,%eax
}
  8024b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    

008024c0 <devpipe_write>:
{
  8024c0:	f3 0f 1e fb          	endbr32 
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	57                   	push   %edi
  8024c8:	56                   	push   %esi
  8024c9:	53                   	push   %ebx
  8024ca:	83 ec 28             	sub    $0x28,%esp
  8024cd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024d0:	56                   	push   %esi
  8024d1:	e8 b8 f0 ff ff       	call   80158e <fd2data>
  8024d6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024e3:	74 4f                	je     802534 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024e5:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e8:	8b 0b                	mov    (%ebx),%ecx
  8024ea:	8d 51 20             	lea    0x20(%ecx),%edx
  8024ed:	39 d0                	cmp    %edx,%eax
  8024ef:	72 14                	jb     802505 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8024f1:	89 da                	mov    %ebx,%edx
  8024f3:	89 f0                	mov    %esi,%eax
  8024f5:	e8 61 ff ff ff       	call   80245b <_pipeisclosed>
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	75 3b                	jne    802539 <devpipe_write+0x79>
			sys_yield();
  8024fe:	e8 23 eb ff ff       	call   801026 <sys_yield>
  802503:	eb e0                	jmp    8024e5 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802505:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802508:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80250c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80250f:	89 c2                	mov    %eax,%edx
  802511:	c1 fa 1f             	sar    $0x1f,%edx
  802514:	89 d1                	mov    %edx,%ecx
  802516:	c1 e9 1b             	shr    $0x1b,%ecx
  802519:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80251c:	83 e2 1f             	and    $0x1f,%edx
  80251f:	29 ca                	sub    %ecx,%edx
  802521:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802525:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802529:	83 c0 01             	add    $0x1,%eax
  80252c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80252f:	83 c7 01             	add    $0x1,%edi
  802532:	eb ac                	jmp    8024e0 <devpipe_write+0x20>
	return i;
  802534:	8b 45 10             	mov    0x10(%ebp),%eax
  802537:	eb 05                	jmp    80253e <devpipe_write+0x7e>
				return 0;
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    

00802546 <devpipe_read>:
{
  802546:	f3 0f 1e fb          	endbr32 
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	57                   	push   %edi
  80254e:	56                   	push   %esi
  80254f:	53                   	push   %ebx
  802550:	83 ec 18             	sub    $0x18,%esp
  802553:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802556:	57                   	push   %edi
  802557:	e8 32 f0 ff ff       	call   80158e <fd2data>
  80255c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	be 00 00 00 00       	mov    $0x0,%esi
  802566:	3b 75 10             	cmp    0x10(%ebp),%esi
  802569:	75 14                	jne    80257f <devpipe_read+0x39>
	return i;
  80256b:	8b 45 10             	mov    0x10(%ebp),%eax
  80256e:	eb 02                	jmp    802572 <devpipe_read+0x2c>
				return i;
  802570:	89 f0                	mov    %esi,%eax
}
  802572:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802575:	5b                   	pop    %ebx
  802576:	5e                   	pop    %esi
  802577:	5f                   	pop    %edi
  802578:	5d                   	pop    %ebp
  802579:	c3                   	ret    
			sys_yield();
  80257a:	e8 a7 ea ff ff       	call   801026 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80257f:	8b 03                	mov    (%ebx),%eax
  802581:	3b 43 04             	cmp    0x4(%ebx),%eax
  802584:	75 18                	jne    80259e <devpipe_read+0x58>
			if (i > 0)
  802586:	85 f6                	test   %esi,%esi
  802588:	75 e6                	jne    802570 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80258a:	89 da                	mov    %ebx,%edx
  80258c:	89 f8                	mov    %edi,%eax
  80258e:	e8 c8 fe ff ff       	call   80245b <_pipeisclosed>
  802593:	85 c0                	test   %eax,%eax
  802595:	74 e3                	je     80257a <devpipe_read+0x34>
				return 0;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	eb d4                	jmp    802572 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80259e:	99                   	cltd   
  80259f:	c1 ea 1b             	shr    $0x1b,%edx
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	83 e0 1f             	and    $0x1f,%eax
  8025a7:	29 d0                	sub    %edx,%eax
  8025a9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025b1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025b4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025b7:	83 c6 01             	add    $0x1,%esi
  8025ba:	eb aa                	jmp    802566 <devpipe_read+0x20>

008025bc <pipe>:
{
  8025bc:	f3 0f 1e fb          	endbr32 
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	56                   	push   %esi
  8025c4:	53                   	push   %ebx
  8025c5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cb:	50                   	push   %eax
  8025cc:	e8 d8 ef ff ff       	call   8015a9 <fd_alloc>
  8025d1:	89 c3                	mov    %eax,%ebx
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 88 23 01 00 00    	js     802701 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025de:	83 ec 04             	sub    $0x4,%esp
  8025e1:	68 07 04 00 00       	push   $0x407
  8025e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e9:	6a 00                	push   $0x0
  8025eb:	e8 59 ea ff ff       	call   801049 <sys_page_alloc>
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	83 c4 10             	add    $0x10,%esp
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	0f 88 04 01 00 00    	js     802701 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8025fd:	83 ec 0c             	sub    $0xc,%esp
  802600:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802603:	50                   	push   %eax
  802604:	e8 a0 ef ff ff       	call   8015a9 <fd_alloc>
  802609:	89 c3                	mov    %eax,%ebx
  80260b:	83 c4 10             	add    $0x10,%esp
  80260e:	85 c0                	test   %eax,%eax
  802610:	0f 88 db 00 00 00    	js     8026f1 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 07 04 00 00       	push   $0x407
  80261e:	ff 75 f0             	pushl  -0x10(%ebp)
  802621:	6a 00                	push   $0x0
  802623:	e8 21 ea ff ff       	call   801049 <sys_page_alloc>
  802628:	89 c3                	mov    %eax,%ebx
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	85 c0                	test   %eax,%eax
  80262f:	0f 88 bc 00 00 00    	js     8026f1 <pipe+0x135>
	va = fd2data(fd0);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	ff 75 f4             	pushl  -0xc(%ebp)
  80263b:	e8 4e ef ff ff       	call   80158e <fd2data>
  802640:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802642:	83 c4 0c             	add    $0xc,%esp
  802645:	68 07 04 00 00       	push   $0x407
  80264a:	50                   	push   %eax
  80264b:	6a 00                	push   $0x0
  80264d:	e8 f7 e9 ff ff       	call   801049 <sys_page_alloc>
  802652:	89 c3                	mov    %eax,%ebx
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	0f 88 82 00 00 00    	js     8026e1 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	ff 75 f0             	pushl  -0x10(%ebp)
  802665:	e8 24 ef ff ff       	call   80158e <fd2data>
  80266a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802671:	50                   	push   %eax
  802672:	6a 00                	push   $0x0
  802674:	56                   	push   %esi
  802675:	6a 00                	push   $0x0
  802677:	e8 14 ea ff ff       	call   801090 <sys_page_map>
  80267c:	89 c3                	mov    %eax,%ebx
  80267e:	83 c4 20             	add    $0x20,%esp
  802681:	85 c0                	test   %eax,%eax
  802683:	78 4e                	js     8026d3 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802685:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80268a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802699:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80269c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ae:	e8 c7 ee ff ff       	call   80157a <fd2num>
  8026b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026b6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026b8:	83 c4 04             	add    $0x4,%esp
  8026bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8026be:	e8 b7 ee ff ff       	call   80157a <fd2num>
  8026c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026c9:	83 c4 10             	add    $0x10,%esp
  8026cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026d1:	eb 2e                	jmp    802701 <pipe+0x145>
	sys_page_unmap(0, va);
  8026d3:	83 ec 08             	sub    $0x8,%esp
  8026d6:	56                   	push   %esi
  8026d7:	6a 00                	push   $0x0
  8026d9:	e8 f8 e9 ff ff       	call   8010d6 <sys_page_unmap>
  8026de:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026e1:	83 ec 08             	sub    $0x8,%esp
  8026e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8026e7:	6a 00                	push   $0x0
  8026e9:	e8 e8 e9 ff ff       	call   8010d6 <sys_page_unmap>
  8026ee:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026f1:	83 ec 08             	sub    $0x8,%esp
  8026f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f7:	6a 00                	push   $0x0
  8026f9:	e8 d8 e9 ff ff       	call   8010d6 <sys_page_unmap>
  8026fe:	83 c4 10             	add    $0x10,%esp
}
  802701:	89 d8                	mov    %ebx,%eax
  802703:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802706:	5b                   	pop    %ebx
  802707:	5e                   	pop    %esi
  802708:	5d                   	pop    %ebp
  802709:	c3                   	ret    

0080270a <pipeisclosed>:
{
  80270a:	f3 0f 1e fb          	endbr32 
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802717:	50                   	push   %eax
  802718:	ff 75 08             	pushl  0x8(%ebp)
  80271b:	e8 df ee ff ff       	call   8015ff <fd_lookup>
  802720:	83 c4 10             	add    $0x10,%esp
  802723:	85 c0                	test   %eax,%eax
  802725:	78 18                	js     80273f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802727:	83 ec 0c             	sub    $0xc,%esp
  80272a:	ff 75 f4             	pushl  -0xc(%ebp)
  80272d:	e8 5c ee ff ff       	call   80158e <fd2data>
  802732:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	e8 1f fd ff ff       	call   80245b <_pipeisclosed>
  80273c:	83 c4 10             	add    $0x10,%esp
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802741:	f3 0f 1e fb          	endbr32 
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	56                   	push   %esi
  802749:	53                   	push   %ebx
  80274a:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80274d:	85 f6                	test   %esi,%esi
  80274f:	74 13                	je     802764 <wait+0x23>
	e = &envs[ENVX(envid)];
  802751:	89 f3                	mov    %esi,%ebx
  802753:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802759:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80275c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802762:	eb 1b                	jmp    80277f <wait+0x3e>
	assert(envid != 0);
  802764:	68 85 33 80 00       	push   $0x803385
  802769:	68 9f 32 80 00       	push   $0x80329f
  80276e:	6a 09                	push   $0x9
  802770:	68 90 33 80 00       	push   $0x803390
  802775:	e8 9c dd ff ff       	call   800516 <_panic>
		sys_yield();
  80277a:	e8 a7 e8 ff ff       	call   801026 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80277f:	8b 43 48             	mov    0x48(%ebx),%eax
  802782:	39 f0                	cmp    %esi,%eax
  802784:	75 07                	jne    80278d <wait+0x4c>
  802786:	8b 43 54             	mov    0x54(%ebx),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	75 ed                	jne    80277a <wait+0x39>
}
  80278d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5d                   	pop    %ebp
  802793:	c3                   	ret    

00802794 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802794:	f3 0f 1e fb          	endbr32 
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	53                   	push   %ebx
  80279c:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  80279f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8027a6:	74 0d                	je     8027b5 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8027b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    
		envid_t envid=sys_getenvid();
  8027b5:	e8 49 e8 ff ff       	call   801003 <sys_getenvid>
  8027ba:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8027bc:	83 ec 04             	sub    $0x4,%esp
  8027bf:	6a 07                	push   $0x7
  8027c1:	68 00 f0 bf ee       	push   $0xeebff000
  8027c6:	50                   	push   %eax
  8027c7:	e8 7d e8 ff ff       	call   801049 <sys_page_alloc>
  8027cc:	83 c4 10             	add    $0x10,%esp
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	78 29                	js     8027fc <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  8027d3:	83 ec 08             	sub    $0x8,%esp
  8027d6:	68 10 28 80 00       	push   $0x802810
  8027db:	53                   	push   %ebx
  8027dc:	e8 c7 e9 ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
  8027e1:	83 c4 10             	add    $0x10,%esp
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	79 c0                	jns    8027a8 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	68 c8 33 80 00       	push   $0x8033c8
  8027f0:	6a 24                	push   $0x24
  8027f2:	68 ff 33 80 00       	push   $0x8033ff
  8027f7:	e8 1a dd ff ff       	call   800516 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	68 9c 33 80 00       	push   $0x80339c
  802804:	6a 22                	push   $0x22
  802806:	68 ff 33 80 00       	push   $0x8033ff
  80280b:	e8 06 dd ff ff       	call   800516 <_panic>

00802810 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802810:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802811:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802816:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802818:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  80281b:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  80281e:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  802822:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  802827:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  80282b:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80282d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80282e:	83 c4 04             	add    $0x4,%esp
	popfl
  802831:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802832:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802833:	c3                   	ret    

00802834 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802834:	f3 0f 1e fb          	endbr32 
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	56                   	push   %esi
  80283c:	53                   	push   %ebx
  80283d:	8b 75 08             	mov    0x8(%ebp),%esi
  802840:	8b 45 0c             	mov    0xc(%ebp),%eax
  802843:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802846:	85 c0                	test   %eax,%eax
  802848:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80284d:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  802850:	83 ec 0c             	sub    $0xc,%esp
  802853:	50                   	push   %eax
  802854:	e8 bc e9 ff ff       	call   801215 <sys_ipc_recv>
  802859:	83 c4 10             	add    $0x10,%esp
  80285c:	85 c0                	test   %eax,%eax
  80285e:	78 2b                	js     80288b <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  802860:	85 f6                	test   %esi,%esi
  802862:	74 0a                	je     80286e <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  802864:	a1 04 50 80 00       	mov    0x805004,%eax
  802869:	8b 40 74             	mov    0x74(%eax),%eax
  80286c:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  80286e:	85 db                	test   %ebx,%ebx
  802870:	74 0a                	je     80287c <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  802872:	a1 04 50 80 00       	mov    0x805004,%eax
  802877:	8b 40 78             	mov    0x78(%eax),%eax
  80287a:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80287c:	a1 04 50 80 00       	mov    0x805004,%eax
  802881:	8b 40 70             	mov    0x70(%eax),%eax
}
  802884:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802887:	5b                   	pop    %ebx
  802888:	5e                   	pop    %esi
  802889:	5d                   	pop    %ebp
  80288a:	c3                   	ret    
		if(from_env_store)
  80288b:	85 f6                	test   %esi,%esi
  80288d:	74 06                	je     802895 <ipc_recv+0x61>
			*from_env_store=0;
  80288f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802895:	85 db                	test   %ebx,%ebx
  802897:	74 eb                	je     802884 <ipc_recv+0x50>
			*perm_store=0;
  802899:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80289f:	eb e3                	jmp    802884 <ipc_recv+0x50>

008028a1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028a1:	f3 0f 1e fb          	endbr32 
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	57                   	push   %edi
  8028a9:	56                   	push   %esi
  8028aa:	53                   	push   %ebx
  8028ab:	83 ec 0c             	sub    $0xc,%esp
  8028ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8028b7:	85 db                	test   %ebx,%ebx
  8028b9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028be:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8028c1:	ff 75 14             	pushl  0x14(%ebp)
  8028c4:	53                   	push   %ebx
  8028c5:	56                   	push   %esi
  8028c6:	57                   	push   %edi
  8028c7:	e8 22 e9 ff ff       	call   8011ee <sys_ipc_try_send>
		if(!res)
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 20                	je     8028f3 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  8028d3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028d6:	75 07                	jne    8028df <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  8028d8:	e8 49 e7 ff ff       	call   801026 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8028dd:	eb e2                	jmp    8028c1 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	68 0d 34 80 00       	push   $0x80340d
  8028e7:	6a 3f                	push   $0x3f
  8028e9:	68 25 34 80 00       	push   $0x803425
  8028ee:	e8 23 dc ff ff       	call   800516 <_panic>
	}
}
  8028f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028f6:	5b                   	pop    %ebx
  8028f7:	5e                   	pop    %esi
  8028f8:	5f                   	pop    %edi
  8028f9:	5d                   	pop    %ebp
  8028fa:	c3                   	ret    

008028fb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028fb:	f3 0f 1e fb          	endbr32 
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
  802902:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802905:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80290a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80290d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802913:	8b 52 50             	mov    0x50(%edx),%edx
  802916:	39 ca                	cmp    %ecx,%edx
  802918:	74 11                	je     80292b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80291a:	83 c0 01             	add    $0x1,%eax
  80291d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802922:	75 e6                	jne    80290a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
  802929:	eb 0b                	jmp    802936 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80292b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80292e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802933:	8b 40 48             	mov    0x48(%eax),%eax
}
  802936:	5d                   	pop    %ebp
  802937:	c3                   	ret    

00802938 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802938:	f3 0f 1e fb          	endbr32 
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802942:	89 c2                	mov    %eax,%edx
  802944:	c1 ea 16             	shr    $0x16,%edx
  802947:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80294e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802953:	f6 c1 01             	test   $0x1,%cl
  802956:	74 1c                	je     802974 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802958:	c1 e8 0c             	shr    $0xc,%eax
  80295b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802962:	a8 01                	test   $0x1,%al
  802964:	74 0e                	je     802974 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802966:	c1 e8 0c             	shr    $0xc,%eax
  802969:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802970:	ef 
  802971:	0f b7 d2             	movzwl %dx,%edx
}
  802974:	89 d0                	mov    %edx,%eax
  802976:	5d                   	pop    %ebp
  802977:	c3                   	ret    
  802978:	66 90                	xchg   %ax,%ax
  80297a:	66 90                	xchg   %ax,%ax
  80297c:	66 90                	xchg   %ax,%ax
  80297e:	66 90                	xchg   %ax,%ax

00802980 <__udivdi3>:
  802980:	f3 0f 1e fb          	endbr32 
  802984:	55                   	push   %ebp
  802985:	57                   	push   %edi
  802986:	56                   	push   %esi
  802987:	53                   	push   %ebx
  802988:	83 ec 1c             	sub    $0x1c,%esp
  80298b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80298f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802993:	8b 74 24 34          	mov    0x34(%esp),%esi
  802997:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80299b:	85 d2                	test   %edx,%edx
  80299d:	75 19                	jne    8029b8 <__udivdi3+0x38>
  80299f:	39 f3                	cmp    %esi,%ebx
  8029a1:	76 4d                	jbe    8029f0 <__udivdi3+0x70>
  8029a3:	31 ff                	xor    %edi,%edi
  8029a5:	89 e8                	mov    %ebp,%eax
  8029a7:	89 f2                	mov    %esi,%edx
  8029a9:	f7 f3                	div    %ebx
  8029ab:	89 fa                	mov    %edi,%edx
  8029ad:	83 c4 1c             	add    $0x1c,%esp
  8029b0:	5b                   	pop    %ebx
  8029b1:	5e                   	pop    %esi
  8029b2:	5f                   	pop    %edi
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	39 f2                	cmp    %esi,%edx
  8029ba:	76 14                	jbe    8029d0 <__udivdi3+0x50>
  8029bc:	31 ff                	xor    %edi,%edi
  8029be:	31 c0                	xor    %eax,%eax
  8029c0:	89 fa                	mov    %edi,%edx
  8029c2:	83 c4 1c             	add    $0x1c,%esp
  8029c5:	5b                   	pop    %ebx
  8029c6:	5e                   	pop    %esi
  8029c7:	5f                   	pop    %edi
  8029c8:	5d                   	pop    %ebp
  8029c9:	c3                   	ret    
  8029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029d0:	0f bd fa             	bsr    %edx,%edi
  8029d3:	83 f7 1f             	xor    $0x1f,%edi
  8029d6:	75 48                	jne    802a20 <__udivdi3+0xa0>
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	72 06                	jb     8029e2 <__udivdi3+0x62>
  8029dc:	31 c0                	xor    %eax,%eax
  8029de:	39 eb                	cmp    %ebp,%ebx
  8029e0:	77 de                	ja     8029c0 <__udivdi3+0x40>
  8029e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e7:	eb d7                	jmp    8029c0 <__udivdi3+0x40>
  8029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	89 d9                	mov    %ebx,%ecx
  8029f2:	85 db                	test   %ebx,%ebx
  8029f4:	75 0b                	jne    802a01 <__udivdi3+0x81>
  8029f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	f7 f3                	div    %ebx
  8029ff:	89 c1                	mov    %eax,%ecx
  802a01:	31 d2                	xor    %edx,%edx
  802a03:	89 f0                	mov    %esi,%eax
  802a05:	f7 f1                	div    %ecx
  802a07:	89 c6                	mov    %eax,%esi
  802a09:	89 e8                	mov    %ebp,%eax
  802a0b:	89 f7                	mov    %esi,%edi
  802a0d:	f7 f1                	div    %ecx
  802a0f:	89 fa                	mov    %edi,%edx
  802a11:	83 c4 1c             	add    $0x1c,%esp
  802a14:	5b                   	pop    %ebx
  802a15:	5e                   	pop    %esi
  802a16:	5f                   	pop    %edi
  802a17:	5d                   	pop    %ebp
  802a18:	c3                   	ret    
  802a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a20:	89 f9                	mov    %edi,%ecx
  802a22:	b8 20 00 00 00       	mov    $0x20,%eax
  802a27:	29 f8                	sub    %edi,%eax
  802a29:	d3 e2                	shl    %cl,%edx
  802a2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a2f:	89 c1                	mov    %eax,%ecx
  802a31:	89 da                	mov    %ebx,%edx
  802a33:	d3 ea                	shr    %cl,%edx
  802a35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a39:	09 d1                	or     %edx,%ecx
  802a3b:	89 f2                	mov    %esi,%edx
  802a3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a41:	89 f9                	mov    %edi,%ecx
  802a43:	d3 e3                	shl    %cl,%ebx
  802a45:	89 c1                	mov    %eax,%ecx
  802a47:	d3 ea                	shr    %cl,%edx
  802a49:	89 f9                	mov    %edi,%ecx
  802a4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a4f:	89 eb                	mov    %ebp,%ebx
  802a51:	d3 e6                	shl    %cl,%esi
  802a53:	89 c1                	mov    %eax,%ecx
  802a55:	d3 eb                	shr    %cl,%ebx
  802a57:	09 de                	or     %ebx,%esi
  802a59:	89 f0                	mov    %esi,%eax
  802a5b:	f7 74 24 08          	divl   0x8(%esp)
  802a5f:	89 d6                	mov    %edx,%esi
  802a61:	89 c3                	mov    %eax,%ebx
  802a63:	f7 64 24 0c          	mull   0xc(%esp)
  802a67:	39 d6                	cmp    %edx,%esi
  802a69:	72 15                	jb     802a80 <__udivdi3+0x100>
  802a6b:	89 f9                	mov    %edi,%ecx
  802a6d:	d3 e5                	shl    %cl,%ebp
  802a6f:	39 c5                	cmp    %eax,%ebp
  802a71:	73 04                	jae    802a77 <__udivdi3+0xf7>
  802a73:	39 d6                	cmp    %edx,%esi
  802a75:	74 09                	je     802a80 <__udivdi3+0x100>
  802a77:	89 d8                	mov    %ebx,%eax
  802a79:	31 ff                	xor    %edi,%edi
  802a7b:	e9 40 ff ff ff       	jmp    8029c0 <__udivdi3+0x40>
  802a80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a83:	31 ff                	xor    %edi,%edi
  802a85:	e9 36 ff ff ff       	jmp    8029c0 <__udivdi3+0x40>
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <__umoddi3>:
  802a90:	f3 0f 1e fb          	endbr32 
  802a94:	55                   	push   %ebp
  802a95:	57                   	push   %edi
  802a96:	56                   	push   %esi
  802a97:	53                   	push   %ebx
  802a98:	83 ec 1c             	sub    $0x1c,%esp
  802a9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802aa3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aab:	85 c0                	test   %eax,%eax
  802aad:	75 19                	jne    802ac8 <__umoddi3+0x38>
  802aaf:	39 df                	cmp    %ebx,%edi
  802ab1:	76 5d                	jbe    802b10 <__umoddi3+0x80>
  802ab3:	89 f0                	mov    %esi,%eax
  802ab5:	89 da                	mov    %ebx,%edx
  802ab7:	f7 f7                	div    %edi
  802ab9:	89 d0                	mov    %edx,%eax
  802abb:	31 d2                	xor    %edx,%edx
  802abd:	83 c4 1c             	add    $0x1c,%esp
  802ac0:	5b                   	pop    %ebx
  802ac1:	5e                   	pop    %esi
  802ac2:	5f                   	pop    %edi
  802ac3:	5d                   	pop    %ebp
  802ac4:	c3                   	ret    
  802ac5:	8d 76 00             	lea    0x0(%esi),%esi
  802ac8:	89 f2                	mov    %esi,%edx
  802aca:	39 d8                	cmp    %ebx,%eax
  802acc:	76 12                	jbe    802ae0 <__umoddi3+0x50>
  802ace:	89 f0                	mov    %esi,%eax
  802ad0:	89 da                	mov    %ebx,%edx
  802ad2:	83 c4 1c             	add    $0x1c,%esp
  802ad5:	5b                   	pop    %ebx
  802ad6:	5e                   	pop    %esi
  802ad7:	5f                   	pop    %edi
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    
  802ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ae0:	0f bd e8             	bsr    %eax,%ebp
  802ae3:	83 f5 1f             	xor    $0x1f,%ebp
  802ae6:	75 50                	jne    802b38 <__umoddi3+0xa8>
  802ae8:	39 d8                	cmp    %ebx,%eax
  802aea:	0f 82 e0 00 00 00    	jb     802bd0 <__umoddi3+0x140>
  802af0:	89 d9                	mov    %ebx,%ecx
  802af2:	39 f7                	cmp    %esi,%edi
  802af4:	0f 86 d6 00 00 00    	jbe    802bd0 <__umoddi3+0x140>
  802afa:	89 d0                	mov    %edx,%eax
  802afc:	89 ca                	mov    %ecx,%edx
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	89 fd                	mov    %edi,%ebp
  802b12:	85 ff                	test   %edi,%edi
  802b14:	75 0b                	jne    802b21 <__umoddi3+0x91>
  802b16:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f7                	div    %edi
  802b1f:	89 c5                	mov    %eax,%ebp
  802b21:	89 d8                	mov    %ebx,%eax
  802b23:	31 d2                	xor    %edx,%edx
  802b25:	f7 f5                	div    %ebp
  802b27:	89 f0                	mov    %esi,%eax
  802b29:	f7 f5                	div    %ebp
  802b2b:	89 d0                	mov    %edx,%eax
  802b2d:	31 d2                	xor    %edx,%edx
  802b2f:	eb 8c                	jmp    802abd <__umoddi3+0x2d>
  802b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b3f:	29 ea                	sub    %ebp,%edx
  802b41:	d3 e0                	shl    %cl,%eax
  802b43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b47:	89 d1                	mov    %edx,%ecx
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	d3 e8                	shr    %cl,%eax
  802b4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b59:	09 c1                	or     %eax,%ecx
  802b5b:	89 d8                	mov    %ebx,%eax
  802b5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b61:	89 e9                	mov    %ebp,%ecx
  802b63:	d3 e7                	shl    %cl,%edi
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	d3 e8                	shr    %cl,%eax
  802b69:	89 e9                	mov    %ebp,%ecx
  802b6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b6f:	d3 e3                	shl    %cl,%ebx
  802b71:	89 c7                	mov    %eax,%edi
  802b73:	89 d1                	mov    %edx,%ecx
  802b75:	89 f0                	mov    %esi,%eax
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 fa                	mov    %edi,%edx
  802b7d:	d3 e6                	shl    %cl,%esi
  802b7f:	09 d8                	or     %ebx,%eax
  802b81:	f7 74 24 08          	divl   0x8(%esp)
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	89 f3                	mov    %esi,%ebx
  802b89:	f7 64 24 0c          	mull   0xc(%esp)
  802b8d:	89 c6                	mov    %eax,%esi
  802b8f:	89 d7                	mov    %edx,%edi
  802b91:	39 d1                	cmp    %edx,%ecx
  802b93:	72 06                	jb     802b9b <__umoddi3+0x10b>
  802b95:	75 10                	jne    802ba7 <__umoddi3+0x117>
  802b97:	39 c3                	cmp    %eax,%ebx
  802b99:	73 0c                	jae    802ba7 <__umoddi3+0x117>
  802b9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ba3:	89 d7                	mov    %edx,%edi
  802ba5:	89 c6                	mov    %eax,%esi
  802ba7:	89 ca                	mov    %ecx,%edx
  802ba9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bae:	29 f3                	sub    %esi,%ebx
  802bb0:	19 fa                	sbb    %edi,%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	d3 e0                	shl    %cl,%eax
  802bb6:	89 e9                	mov    %ebp,%ecx
  802bb8:	d3 eb                	shr    %cl,%ebx
  802bba:	d3 ea                	shr    %cl,%edx
  802bbc:	09 d8                	or     %ebx,%eax
  802bbe:	83 c4 1c             	add    $0x1c,%esp
  802bc1:	5b                   	pop    %ebx
  802bc2:	5e                   	pop    %esi
  802bc3:	5f                   	pop    %edi
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    
  802bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	29 fe                	sub    %edi,%esi
  802bd2:	19 c3                	sbb    %eax,%ebx
  802bd4:	89 f2                	mov    %esi,%edx
  802bd6:	89 d9                	mov    %ebx,%ecx
  802bd8:	e9 1d ff ff ff       	jmp    802afa <__umoddi3+0x6a>
