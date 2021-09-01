
obj/user/init.debug：     文件格式 elf32-i386


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
  80002c:	e8 8f 03 00 00       	call   8003c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  800042:	b9 00 00 00 00       	mov    $0x0,%ecx
	for (i = 0; i < n; i++)
  800047:	b8 00 00 00 00       	mov    $0x0,%eax
  80004c:	39 d8                	cmp    %ebx,%eax
  80004e:	7d 0e                	jge    80005e <sum+0x2b>
		tot ^= i * s[i];
  800050:	0f be 14 06          	movsbl (%esi,%eax,1),%edx
  800054:	0f af d0             	imul   %eax,%edx
  800057:	31 d1                	xor    %edx,%ecx
	for (i = 0; i < n; i++)
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	eb ee                	jmp    80004c <sum+0x19>
	return tot;
}
  80005e:	89 c8                	mov    %ecx,%eax
  800060:	5b                   	pop    %ebx
  800061:	5e                   	pop    %esi
  800062:	5d                   	pop    %ebp
  800063:	c3                   	ret    

00800064 <umain>:

void
umain(int argc, char **argv)
{
  800064:	f3 0f 1e fb          	endbr32 
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	57                   	push   %edi
  80006c:	56                   	push   %esi
  80006d:	53                   	push   %ebx
  80006e:	81 ec 18 01 00 00    	sub    $0x118,%esp
  800074:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  800077:	68 40 27 80 00       	push   $0x802740
  80007c:	e8 8e 04 00 00       	call   80050f <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800081:	83 c4 08             	add    $0x8,%esp
  800084:	68 70 17 00 00       	push   $0x1770
  800089:	68 00 30 80 00       	push   $0x803000
  80008e:	e8 a0 ff ff ff       	call   800033 <sum>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009b:	0f 84 99 00 00 00    	je     80013a <umain+0xd6>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	68 9e 98 0f 00       	push   $0xf989e
  8000a9:	50                   	push   %eax
  8000aa:	68 08 28 80 00       	push   $0x802808
  8000af:	e8 5b 04 00 00       	call   80050f <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	68 70 17 00 00       	push   $0x1770
  8000bf:	68 20 50 80 00       	push   $0x805020
  8000c4:	e8 6a ff ff ff       	call   800033 <sum>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 7f                	je     80014f <umain+0xeb>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 44 28 80 00       	push   $0x802844
  8000d9:	e8 31 04 00 00       	call   80050f <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	68 7c 27 80 00       	push   $0x80277c
  8000e9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000ef:	50                   	push   %eax
  8000f0:	e8 4a 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000fd:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  800103:	39 fb                	cmp    %edi,%ebx
  800105:	7d 5a                	jge    800161 <umain+0xfd>
		strcat(args, " '");
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	68 88 27 80 00       	push   $0x802788
  80010f:	56                   	push   %esi
  800110:	e8 2a 0a 00 00       	call   800b3f <strcat>
		strcat(args, argv[i]);
  800115:	83 c4 08             	add    $0x8,%esp
  800118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011b:	ff 34 98             	pushl  (%eax,%ebx,4)
  80011e:	56                   	push   %esi
  80011f:	e8 1b 0a 00 00       	call   800b3f <strcat>
		strcat(args, "'");
  800124:	83 c4 08             	add    $0x8,%esp
  800127:	68 89 27 80 00       	push   $0x802789
  80012c:	56                   	push   %esi
  80012d:	e8 0d 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  800132:	83 c3 01             	add    $0x1,%ebx
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	eb c9                	jmp    800103 <umain+0x9f>
		cprintf("init: data seems okay\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 4f 27 80 00       	push   $0x80274f
  800142:	e8 c8 03 00 00       	call   80050f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	e9 68 ff ff ff       	jmp    8000b7 <umain+0x53>
		cprintf("init: bss seems okay\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 66 27 80 00       	push   $0x802766
  800157:	e8 b3 03 00 00       	call   80050f <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 80                	jmp    8000e1 <umain+0x7d>
	}
	cprintf("%s\n", args);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	68 8b 27 80 00       	push   $0x80278b
  800170:	e8 9a 03 00 00       	call   80050f <cprintf>

	cprintf("init: running sh\n");
  800175:	c7 04 24 8f 27 80 00 	movl   $0x80278f,(%esp)
  80017c:	e8 8e 03 00 00       	call   80050f <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800188:	e8 9d 11 00 00       	call   80132a <close>
	if ((r = opencons()) < 0)
  80018d:	e8 d8 01 00 00       	call   80036a <opencons>
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	85 c0                	test   %eax,%eax
  800197:	78 14                	js     8001ad <umain+0x149>
		panic("opencons: %e", r);
	if (r != 0)
  800199:	74 24                	je     8001bf <umain+0x15b>
		panic("first opencons used fd %d", r);
  80019b:	50                   	push   %eax
  80019c:	68 ba 27 80 00       	push   $0x8027ba
  8001a1:	6a 39                	push   $0x39
  8001a3:	68 ae 27 80 00       	push   $0x8027ae
  8001a8:	e8 7b 02 00 00       	call   800428 <_panic>
		panic("opencons: %e", r);
  8001ad:	50                   	push   %eax
  8001ae:	68 a1 27 80 00       	push   $0x8027a1
  8001b3:	6a 37                	push   $0x37
  8001b5:	68 ae 27 80 00       	push   $0x8027ae
  8001ba:	e8 69 02 00 00       	call   800428 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	6a 01                	push   $0x1
  8001c4:	6a 00                	push   $0x0
  8001c6:	e8 b9 11 00 00       	call   801384 <dup>
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	79 23                	jns    8001f5 <umain+0x191>
		panic("dup: %e", r);
  8001d2:	50                   	push   %eax
  8001d3:	68 d4 27 80 00       	push   $0x8027d4
  8001d8:	6a 3b                	push   $0x3b
  8001da:	68 ae 27 80 00       	push   $0x8027ae
  8001df:	e8 44 02 00 00       	call   800428 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	50                   	push   %eax
  8001e8:	68 f3 27 80 00       	push   $0x8027f3
  8001ed:	e8 1d 03 00 00       	call   80050f <cprintf>
			continue;
  8001f2:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 dc 27 80 00       	push   $0x8027dc
  8001fd:	e8 0d 03 00 00       	call   80050f <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800202:	83 c4 0c             	add    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	68 f0 27 80 00       	push   $0x8027f0
  80020c:	68 ef 27 80 00       	push   $0x8027ef
  800211:	e8 05 1d 00 00       	call   801f1b <spawnl>
		if (r < 0) {
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	85 c0                	test   %eax,%eax
  80021b:	78 c7                	js     8001e4 <umain+0x180>
		}
		wait(r);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	50                   	push   %eax
  800221:	e8 0d 21 00 00       	call   802333 <wait>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	eb ca                	jmp    8001f5 <umain+0x191>

0080022b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80022b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80022f:	b8 00 00 00 00       	mov    $0x0,%eax
  800234:	c3                   	ret    

00800235 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800235:	f3 0f 1e fb          	endbr32 
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80023f:	68 73 28 80 00       	push   $0x802873
  800244:	ff 75 0c             	pushl  0xc(%ebp)
  800247:	e8 cd 08 00 00       	call   800b19 <strcpy>
	return 0;
}
  80024c:	b8 00 00 00 00       	mov    $0x0,%eax
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <devcons_write>:
{
  800253:	f3 0f 1e fb          	endbr32 
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800263:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800268:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80026e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800271:	73 31                	jae    8002a4 <devcons_write+0x51>
		m = n - tot;
  800273:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800276:	29 f3                	sub    %esi,%ebx
  800278:	83 fb 7f             	cmp    $0x7f,%ebx
  80027b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800280:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	53                   	push   %ebx
  800287:	89 f0                	mov    %esi,%eax
  800289:	03 45 0c             	add    0xc(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	57                   	push   %edi
  80028e:	e8 3c 0a 00 00       	call   800ccf <memmove>
		sys_cputs(buf, m);
  800293:	83 c4 08             	add    $0x8,%esp
  800296:	53                   	push   %ebx
  800297:	57                   	push   %edi
  800298:	e8 ee 0b 00 00       	call   800e8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80029d:	01 de                	add    %ebx,%esi
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	eb ca                	jmp    80026e <devcons_write+0x1b>
}
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    

008002ae <devcons_read>:
{
  8002ae:	f3 0f 1e fb          	endbr32 
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002c1:	74 21                	je     8002e4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8002c3:	e8 e5 0b 00 00       	call   800ead <sys_cgetc>
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	75 07                	jne    8002d3 <devcons_read+0x25>
		sys_yield();
  8002cc:	e8 67 0c 00 00       	call   800f38 <sys_yield>
  8002d1:	eb f0                	jmp    8002c3 <devcons_read+0x15>
	if (c < 0)
  8002d3:	78 0f                	js     8002e4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8002d5:	83 f8 04             	cmp    $0x4,%eax
  8002d8:	74 0c                	je     8002e6 <devcons_read+0x38>
	*(char*)vbuf = c;
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	88 02                	mov    %al,(%edx)
	return 1;
  8002df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    
		return 0;
  8002e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002eb:	eb f7                	jmp    8002e4 <devcons_read+0x36>

008002ed <cputchar>:
{
  8002ed:	f3 0f 1e fb          	endbr32 
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	e8 83 0b 00 00       	call   800e8b <sys_cputs>
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <getchar>:
{
  80030d:	f3 0f 1e fb          	endbr32 
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800317:	6a 01                	push   $0x1
  800319:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80031c:	50                   	push   %eax
  80031d:	6a 00                	push   $0x0
  80031f:	e8 50 11 00 00       	call   801474 <read>
	if (r < 0)
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	85 c0                	test   %eax,%eax
  800329:	78 06                	js     800331 <getchar+0x24>
	if (r < 1)
  80032b:	74 06                	je     800333 <getchar+0x26>
	return c;
  80032d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    
		return -E_EOF;
  800333:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800338:	eb f7                	jmp    800331 <getchar+0x24>

0080033a <iscons>:
{
  80033a:	f3 0f 1e fb          	endbr32 
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800344:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	ff 75 08             	pushl  0x8(%ebp)
  80034b:	e8 a1 0e 00 00       	call   8011f1 <fd_lookup>
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	85 c0                	test   %eax,%eax
  800355:	78 11                	js     800368 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800360:	39 10                	cmp    %edx,(%eax)
  800362:	0f 94 c0             	sete   %al
  800365:	0f b6 c0             	movzbl %al,%eax
}
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <opencons>:
{
  80036a:	f3 0f 1e fb          	endbr32 
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800374:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800377:	50                   	push   %eax
  800378:	e8 1e 0e 00 00       	call   80119b <fd_alloc>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	85 c0                	test   %eax,%eax
  800382:	78 3a                	js     8003be <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 07 04 00 00       	push   $0x407
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	6a 00                	push   $0x0
  800391:	e8 c5 0b 00 00       	call   800f5b <sys_page_alloc>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 21                	js     8003be <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80039d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a0:	8b 15 70 47 80 00    	mov    0x804770,%edx
  8003a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	50                   	push   %eax
  8003b6:	e8 b1 0d 00 00       	call   80116c <fd2num>
  8003bb:	83 c4 10             	add    $0x10,%esp
}
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003c0:	f3 0f 1e fb          	endbr32 
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	56                   	push   %esi
  8003c8:	53                   	push   %ebx
  8003c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003cf:	e8 41 0b 00 00       	call   800f15 <sys_getenvid>
  8003d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e1:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e6:	85 db                	test   %ebx,%ebx
  8003e8:	7e 07                	jle    8003f1 <libmain+0x31>
		binaryname = argv[0];
  8003ea:	8b 06                	mov    (%esi),%eax
  8003ec:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
  8003f6:	e8 69 fc ff ff       	call   800064 <umain>

	// exit gracefully
	exit();
  8003fb:	e8 0a 00 00 00       	call   80040a <exit>
}
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80040a:	f3 0f 1e fb          	endbr32 
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800414:	e8 42 0f 00 00       	call   80135b <close_all>
	sys_env_destroy(0);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	6a 00                	push   $0x0
  80041e:	e8 ad 0a 00 00       	call   800ed0 <sys_env_destroy>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800428:	f3 0f 1e fb          	endbr32 
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800431:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800434:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  80043a:	e8 d6 0a 00 00       	call   800f15 <sys_getenvid>
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	ff 75 08             	pushl  0x8(%ebp)
  800448:	56                   	push   %esi
  800449:	50                   	push   %eax
  80044a:	68 8c 28 80 00       	push   $0x80288c
  80044f:	e8 bb 00 00 00       	call   80050f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	83 c4 18             	add    $0x18,%esp
  800457:	53                   	push   %ebx
  800458:	ff 75 10             	pushl  0x10(%ebp)
  80045b:	e8 5a 00 00 00       	call   8004ba <vcprintf>
	cprintf("\n");
  800460:	c7 04 24 5e 2d 80 00 	movl   $0x802d5e,(%esp)
  800467:	e8 a3 00 00 00       	call   80050f <cprintf>
  80046c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046f:	cc                   	int3   
  800470:	eb fd                	jmp    80046f <_panic+0x47>

00800472 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800472:	f3 0f 1e fb          	endbr32 
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	53                   	push   %ebx
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800480:	8b 13                	mov    (%ebx),%edx
  800482:	8d 42 01             	lea    0x1(%edx),%eax
  800485:	89 03                	mov    %eax,(%ebx)
  800487:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80048a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80048e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800493:	74 09                	je     80049e <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800495:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	68 ff 00 00 00       	push   $0xff
  8004a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8004a9:	50                   	push   %eax
  8004aa:	e8 dc 09 00 00       	call   800e8b <sys_cputs>
		b->idx = 0;
  8004af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	eb db                	jmp    800495 <putch+0x23>

008004ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004ba:	f3 0f 1e fb          	endbr32 
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ce:	00 00 00 
	b.cnt = 0;
  8004d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	ff 75 08             	pushl  0x8(%ebp)
  8004e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e7:	50                   	push   %eax
  8004e8:	68 72 04 80 00       	push   $0x800472
  8004ed:	e8 20 01 00 00       	call   800612 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004f2:	83 c4 08             	add    $0x8,%esp
  8004f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800501:	50                   	push   %eax
  800502:	e8 84 09 00 00       	call   800e8b <sys_cputs>

	return b.cnt;
}
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80050f:	f3 0f 1e fb          	endbr32 
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800519:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80051c:	50                   	push   %eax
  80051d:	ff 75 08             	pushl  0x8(%ebp)
  800520:	e8 95 ff ff ff       	call   8004ba <vcprintf>
	va_end(ap);

	return cnt;
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	57                   	push   %edi
  80052b:	56                   	push   %esi
  80052c:	53                   	push   %ebx
  80052d:	83 ec 1c             	sub    $0x1c,%esp
  800530:	89 c7                	mov    %eax,%edi
  800532:	89 d6                	mov    %edx,%esi
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053a:	89 d1                	mov    %edx,%ecx
  80053c:	89 c2                	mov    %eax,%edx
  80053e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800541:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800544:	8b 45 10             	mov    0x10(%ebp),%eax
  800547:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80054a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80054d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800554:	39 c2                	cmp    %eax,%edx
  800556:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800559:	72 3e                	jb     800599 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	ff 75 18             	pushl  0x18(%ebp)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	53                   	push   %ebx
  800565:	50                   	push   %eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	ff 75 e0             	pushl  -0x20(%ebp)
  80056f:	ff 75 dc             	pushl  -0x24(%ebp)
  800572:	ff 75 d8             	pushl  -0x28(%ebp)
  800575:	e8 56 1f 00 00       	call   8024d0 <__udivdi3>
  80057a:	83 c4 18             	add    $0x18,%esp
  80057d:	52                   	push   %edx
  80057e:	50                   	push   %eax
  80057f:	89 f2                	mov    %esi,%edx
  800581:	89 f8                	mov    %edi,%eax
  800583:	e8 9f ff ff ff       	call   800527 <printnum>
  800588:	83 c4 20             	add    $0x20,%esp
  80058b:	eb 13                	jmp    8005a0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	56                   	push   %esi
  800591:	ff 75 18             	pushl  0x18(%ebp)
  800594:	ff d7                	call   *%edi
  800596:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800599:	83 eb 01             	sub    $0x1,%ebx
  80059c:	85 db                	test   %ebx,%ebx
  80059e:	7f ed                	jg     80058d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	56                   	push   %esi
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8005b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b3:	e8 28 20 00 00       	call   8025e0 <__umoddi3>
  8005b8:	83 c4 14             	add    $0x14,%esp
  8005bb:	0f be 80 af 28 80 00 	movsbl 0x8028af(%eax),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff d7                	call   *%edi
}
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005cb:	5b                   	pop    %ebx
  8005cc:	5e                   	pop    %esi
  8005cd:	5f                   	pop    %edi
  8005ce:	5d                   	pop    %ebp
  8005cf:	c3                   	ret    

008005d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d0:	f3 0f 1e fb          	endbr32 
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005de:	8b 10                	mov    (%eax),%edx
  8005e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e3:	73 0a                	jae    8005ef <sprintputch+0x1f>
		*b->buf++ = ch;
  8005e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005e8:	89 08                	mov    %ecx,(%eax)
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	88 02                	mov    %al,(%edx)
}
  8005ef:	5d                   	pop    %ebp
  8005f0:	c3                   	ret    

008005f1 <printfmt>:
{
  8005f1:	f3 0f 1e fb          	endbr32 
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005fb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 10             	pushl  0x10(%ebp)
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 05 00 00 00       	call   800612 <vprintfmt>
}
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	c9                   	leave  
  800611:	c3                   	ret    

00800612 <vprintfmt>:
{
  800612:	f3 0f 1e fb          	endbr32 
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	57                   	push   %edi
  80061a:	56                   	push   %esi
  80061b:	53                   	push   %ebx
  80061c:	83 ec 3c             	sub    $0x3c,%esp
  80061f:	8b 75 08             	mov    0x8(%ebp),%esi
  800622:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800625:	8b 7d 10             	mov    0x10(%ebp),%edi
  800628:	e9 8e 03 00 00       	jmp    8009bb <vprintfmt+0x3a9>
		padc = ' ';
  80062d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800631:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800638:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80063f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800646:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	8d 47 01             	lea    0x1(%edi),%eax
  80064e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800651:	0f b6 17             	movzbl (%edi),%edx
  800654:	8d 42 dd             	lea    -0x23(%edx),%eax
  800657:	3c 55                	cmp    $0x55,%al
  800659:	0f 87 df 03 00 00    	ja     800a3e <vprintfmt+0x42c>
  80065f:	0f b6 c0             	movzbl %al,%eax
  800662:	3e ff 24 85 00 2a 80 	notrack jmp *0x802a00(,%eax,4)
  800669:	00 
  80066a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80066d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800671:	eb d8                	jmp    80064b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800676:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80067a:	eb cf                	jmp    80064b <vprintfmt+0x39>
  80067c:	0f b6 d2             	movzbl %dl,%edx
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800682:	b8 00 00 00 00       	mov    $0x0,%eax
  800687:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80068a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800691:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800694:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800697:	83 f9 09             	cmp    $0x9,%ecx
  80069a:	77 55                	ja     8006f1 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80069c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80069f:	eb e9                	jmp    80068a <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b9:	79 90                	jns    80064b <vprintfmt+0x39>
				width = precision, precision = -1;
  8006bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c8:	eb 81                	jmp    80064b <vprintfmt+0x39>
  8006ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	0f 49 d0             	cmovns %eax,%edx
  8006d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006dd:	e9 69 ff ff ff       	jmp    80064b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8006e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006ec:	e9 5a ff ff ff       	jmp    80064b <vprintfmt+0x39>
  8006f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	eb bc                	jmp    8006b5 <vprintfmt+0xa3>
			lflag++;
  8006f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006ff:	e9 47 ff ff ff       	jmp    80064b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 78 04             	lea    0x4(%eax),%edi
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	53                   	push   %ebx
  80070e:	ff 30                	pushl  (%eax)
  800710:	ff d6                	call   *%esi
			break;
  800712:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800715:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800718:	e9 9b 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 78 04             	lea    0x4(%eax),%edi
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	31 d0                	xor    %edx,%eax
  800728:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072a:	83 f8 0f             	cmp    $0xf,%eax
  80072d:	7f 23                	jg     800752 <vprintfmt+0x140>
  80072f:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  800736:	85 d2                	test   %edx,%edx
  800738:	74 18                	je     800752 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80073a:	52                   	push   %edx
  80073b:	68 91 2c 80 00       	push   $0x802c91
  800740:	53                   	push   %ebx
  800741:	56                   	push   %esi
  800742:	e8 aa fe ff ff       	call   8005f1 <printfmt>
  800747:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80074d:	e9 66 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800752:	50                   	push   %eax
  800753:	68 c7 28 80 00       	push   $0x8028c7
  800758:	53                   	push   %ebx
  800759:	56                   	push   %esi
  80075a:	e8 92 fe ff ff       	call   8005f1 <printfmt>
  80075f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800762:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800765:	e9 4e 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 c0 04             	add    $0x4,%eax
  800770:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800778:	85 d2                	test   %edx,%edx
  80077a:	b8 c0 28 80 00       	mov    $0x8028c0,%eax
  80077f:	0f 45 c2             	cmovne %edx,%eax
  800782:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	7e 06                	jle    800791 <vprintfmt+0x17f>
  80078b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80078f:	75 0d                	jne    80079e <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800791:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800794:	89 c7                	mov    %eax,%edi
  800796:	03 45 e0             	add    -0x20(%ebp),%eax
  800799:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80079c:	eb 55                	jmp    8007f3 <vprintfmt+0x1e1>
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a4:	ff 75 cc             	pushl  -0x34(%ebp)
  8007a7:	e8 46 03 00 00       	call   800af2 <strnlen>
  8007ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007af:	29 c2                	sub    %eax,%edx
  8007b1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007b9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c0:	85 ff                	test   %edi,%edi
  8007c2:	7e 11                	jle    8007d5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cd:	83 ef 01             	sub    $0x1,%edi
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb eb                	jmp    8007c0 <vprintfmt+0x1ae>
  8007d5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007d8:	85 d2                	test   %edx,%edx
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	0f 49 c2             	cmovns %edx,%eax
  8007e2:	29 c2                	sub    %eax,%edx
  8007e4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007e7:	eb a8                	jmp    800791 <vprintfmt+0x17f>
					putch(ch, putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	53                   	push   %ebx
  8007ed:	52                   	push   %edx
  8007ee:	ff d6                	call   *%esi
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007f6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ff:	0f be d0             	movsbl %al,%edx
  800802:	85 d2                	test   %edx,%edx
  800804:	74 4b                	je     800851 <vprintfmt+0x23f>
  800806:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80080a:	78 06                	js     800812 <vprintfmt+0x200>
  80080c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800810:	78 1e                	js     800830 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800812:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800816:	74 d1                	je     8007e9 <vprintfmt+0x1d7>
  800818:	0f be c0             	movsbl %al,%eax
  80081b:	83 e8 20             	sub    $0x20,%eax
  80081e:	83 f8 5e             	cmp    $0x5e,%eax
  800821:	76 c6                	jbe    8007e9 <vprintfmt+0x1d7>
					putch('?', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 3f                	push   $0x3f
  800829:	ff d6                	call   *%esi
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	eb c3                	jmp    8007f3 <vprintfmt+0x1e1>
  800830:	89 cf                	mov    %ecx,%edi
  800832:	eb 0e                	jmp    800842 <vprintfmt+0x230>
				putch(' ', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 20                	push   $0x20
  80083a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80083c:	83 ef 01             	sub    $0x1,%edi
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 ff                	test   %edi,%edi
  800844:	7f ee                	jg     800834 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800846:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	e9 67 01 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
  800851:	89 cf                	mov    %ecx,%edi
  800853:	eb ed                	jmp    800842 <vprintfmt+0x230>
	if (lflag >= 2)
  800855:	83 f9 01             	cmp    $0x1,%ecx
  800858:	7f 1b                	jg     800875 <vprintfmt+0x263>
	else if (lflag)
  80085a:	85 c9                	test   %ecx,%ecx
  80085c:	74 63                	je     8008c1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	99                   	cltd   
  800867:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	eb 17                	jmp    80088c <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 08             	lea    0x8(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80088c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80088f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800892:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800897:	85 c9                	test   %ecx,%ecx
  800899:	0f 89 ff 00 00 00    	jns    80099e <vprintfmt+0x38c>
				putch('-', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 2d                	push   $0x2d
  8008a5:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008ad:	f7 da                	neg    %edx
  8008af:	83 d1 00             	adc    $0x0,%ecx
  8008b2:	f7 d9                	neg    %ecx
  8008b4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bc:	e9 dd 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c9:	99                   	cltd   
  8008ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	eb b4                	jmp    80088c <vprintfmt+0x27a>
	if (lflag >= 2)
  8008d8:	83 f9 01             	cmp    $0x1,%ecx
  8008db:	7f 1e                	jg     8008fb <vprintfmt+0x2e9>
	else if (lflag)
  8008dd:	85 c9                	test   %ecx,%ecx
  8008df:	74 32                	je     800913 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8b 10                	mov    (%eax),%edx
  8008e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008eb:	8d 40 04             	lea    0x4(%eax),%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8008f6:	e9 a3 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	8b 48 04             	mov    0x4(%eax),%ecx
  800903:	8d 40 08             	lea    0x8(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800909:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80090e:	e9 8b 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 10                	mov    (%eax),%edx
  800918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091d:	8d 40 04             	lea    0x4(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800923:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800928:	eb 74                	jmp    80099e <vprintfmt+0x38c>
	if (lflag >= 2)
  80092a:	83 f9 01             	cmp    $0x1,%ecx
  80092d:	7f 1b                	jg     80094a <vprintfmt+0x338>
	else if (lflag)
  80092f:	85 c9                	test   %ecx,%ecx
  800931:	74 2c                	je     80095f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 10                	mov    (%eax),%edx
  800938:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093d:	8d 40 04             	lea    0x4(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800943:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800948:	eb 54                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 10                	mov    (%eax),%edx
  80094f:	8b 48 04             	mov    0x4(%eax),%ecx
  800952:	8d 40 08             	lea    0x8(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800958:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80095d:	eb 3f                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	8b 10                	mov    (%eax),%edx
  800964:	b9 00 00 00 00       	mov    $0x0,%ecx
  800969:	8d 40 04             	lea    0x4(%eax),%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80096f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800974:	eb 28                	jmp    80099e <vprintfmt+0x38c>
			putch('0', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 30                	push   $0x30
  80097c:	ff d6                	call   *%esi
			putch('x', putdat);
  80097e:	83 c4 08             	add    $0x8,%esp
  800981:	53                   	push   %ebx
  800982:	6a 78                	push   $0x78
  800984:	ff d6                	call   *%esi
			num = (unsigned long long)
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8b 10                	mov    (%eax),%edx
  80098b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800990:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800993:	8d 40 04             	lea    0x4(%eax),%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800999:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8009a5:	57                   	push   %edi
  8009a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a9:	50                   	push   %eax
  8009aa:	51                   	push   %ecx
  8009ab:	52                   	push   %edx
  8009ac:	89 da                	mov    %ebx,%edx
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	e8 72 fb ff ff       	call   800527 <printnum>
			break;
  8009b5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bb:	83 c7 01             	add    $0x1,%edi
  8009be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c2:	83 f8 25             	cmp    $0x25,%eax
  8009c5:	0f 84 62 fc ff ff    	je     80062d <vprintfmt+0x1b>
			if (ch == '\0')
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	0f 84 8b 00 00 00    	je     800a5e <vprintfmt+0x44c>
			putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	eb dc                	jmp    8009bb <vprintfmt+0x3a9>
	if (lflag >= 2)
  8009df:	83 f9 01             	cmp    $0x1,%ecx
  8009e2:	7f 1b                	jg     8009ff <vprintfmt+0x3ed>
	else if (lflag)
  8009e4:	85 c9                	test   %ecx,%ecx
  8009e6:	74 2c                	je     800a14 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	8b 10                	mov    (%eax),%edx
  8009ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f2:	8d 40 04             	lea    0x4(%eax),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8009fd:	eb 9f                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	8b 10                	mov    (%eax),%edx
  800a04:	8b 48 04             	mov    0x4(%eax),%ecx
  800a07:	8d 40 08             	lea    0x8(%eax),%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800a12:	eb 8a                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 10                	mov    (%eax),%edx
  800a19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a1e:	8d 40 04             	lea    0x4(%eax),%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a24:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800a29:	e9 70 ff ff ff       	jmp    80099e <vprintfmt+0x38c>
			putch(ch, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	53                   	push   %ebx
  800a32:	6a 25                	push   $0x25
  800a34:	ff d6                	call   *%esi
			break;
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	e9 7a ff ff ff       	jmp    8009b8 <vprintfmt+0x3a6>
			putch('%', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	53                   	push   %ebx
  800a42:	6a 25                	push   $0x25
  800a44:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	89 f8                	mov    %edi,%eax
  800a4b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a4f:	74 05                	je     800a56 <vprintfmt+0x444>
  800a51:	83 e8 01             	sub    $0x1,%eax
  800a54:	eb f5                	jmp    800a4b <vprintfmt+0x439>
  800a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a59:	e9 5a ff ff ff       	jmp    8009b8 <vprintfmt+0x3a6>
}
  800a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5f                   	pop    %edi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a66:	f3 0f 1e fb          	endbr32 
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 18             	sub    $0x18,%esp
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a79:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a7d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a87:	85 c0                	test   %eax,%eax
  800a89:	74 26                	je     800ab1 <vsnprintf+0x4b>
  800a8b:	85 d2                	test   %edx,%edx
  800a8d:	7e 22                	jle    800ab1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8f:	ff 75 14             	pushl  0x14(%ebp)
  800a92:	ff 75 10             	pushl  0x10(%ebp)
  800a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 d0 05 80 00       	push   $0x8005d0
  800a9e:	e8 6f fb ff ff       	call   800612 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aac:	83 c4 10             	add    $0x10,%esp
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    
		return -E_INVAL;
  800ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab6:	eb f7                	jmp    800aaf <vsnprintf+0x49>

00800ab8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 10             	pushl  0x10(%ebp)
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 92 ff ff ff       	call   800a66 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ad6:	f3 0f 1e fb          	endbr32 
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ae9:	74 05                	je     800af0 <strlen+0x1a>
		n++;
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	eb f5                	jmp    800ae5 <strlen+0xf>
	return n;
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800af2:	f3 0f 1e fb          	endbr32 
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	39 d0                	cmp    %edx,%eax
  800b06:	74 0d                	je     800b15 <strnlen+0x23>
  800b08:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b0c:	74 05                	je     800b13 <strnlen+0x21>
		n++;
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	eb f1                	jmp    800b04 <strnlen+0x12>
  800b13:	89 c2                	mov    %eax,%edx
	return n;
}
  800b15:	89 d0                	mov    %edx,%eax
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b19:	f3 0f 1e fb          	endbr32 
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b30:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	84 d2                	test   %dl,%dl
  800b38:	75 f2                	jne    800b2c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800b3a:	89 c8                	mov    %ecx,%eax
  800b3c:	5b                   	pop    %ebx
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b3f:	f3 0f 1e fb          	endbr32 
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	53                   	push   %ebx
  800b47:	83 ec 10             	sub    $0x10,%esp
  800b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b4d:	53                   	push   %ebx
  800b4e:	e8 83 ff ff ff       	call   800ad6 <strlen>
  800b53:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	01 d8                	add    %ebx,%eax
  800b5b:	50                   	push   %eax
  800b5c:	e8 b8 ff ff ff       	call   800b19 <strcpy>
	return dst;
}
  800b61:	89 d8                	mov    %ebx,%eax
  800b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 75 08             	mov    0x8(%ebp),%esi
  800b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b77:	89 f3                	mov    %esi,%ebx
  800b79:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	39 d8                	cmp    %ebx,%eax
  800b80:	74 11                	je     800b93 <strncpy+0x2b>
		*dst++ = *src;
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b8b:	80 f9 01             	cmp    $0x1,%cl
  800b8e:	83 da ff             	sbb    $0xffffffff,%edx
  800b91:	eb eb                	jmp    800b7e <strncpy+0x16>
	}
	return ret;
}
  800b93:	89 f0                	mov    %esi,%eax
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b99:	f3 0f 1e fb          	endbr32 
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	8b 55 10             	mov    0x10(%ebp),%edx
  800bab:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bad:	85 d2                	test   %edx,%edx
  800baf:	74 21                	je     800bd2 <strlcpy+0x39>
  800bb1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	74 14                	je     800bcf <strlcpy+0x36>
  800bbb:	0f b6 19             	movzbl (%ecx),%ebx
  800bbe:	84 db                	test   %bl,%bl
  800bc0:	74 0b                	je     800bcd <strlcpy+0x34>
			*dst++ = *src++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bcb:	eb ea                	jmp    800bb7 <strlcpy+0x1e>
  800bcd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bcf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd2:	29 f0                	sub    %esi,%eax
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be5:	0f b6 01             	movzbl (%ecx),%eax
  800be8:	84 c0                	test   %al,%al
  800bea:	74 0c                	je     800bf8 <strcmp+0x20>
  800bec:	3a 02                	cmp    (%edx),%al
  800bee:	75 08                	jne    800bf8 <strcmp+0x20>
		p++, q++;
  800bf0:	83 c1 01             	add    $0x1,%ecx
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	eb ed                	jmp    800be5 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf8:	0f b6 c0             	movzbl %al,%eax
  800bfb:	0f b6 12             	movzbl (%edx),%edx
  800bfe:	29 d0                	sub    %edx,%eax
}
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c02:	f3 0f 1e fb          	endbr32 
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	53                   	push   %ebx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c10:	89 c3                	mov    %eax,%ebx
  800c12:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c15:	eb 06                	jmp    800c1d <strncmp+0x1b>
		n--, p++, q++;
  800c17:	83 c0 01             	add    $0x1,%eax
  800c1a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c1d:	39 d8                	cmp    %ebx,%eax
  800c1f:	74 16                	je     800c37 <strncmp+0x35>
  800c21:	0f b6 08             	movzbl (%eax),%ecx
  800c24:	84 c9                	test   %cl,%cl
  800c26:	74 04                	je     800c2c <strncmp+0x2a>
  800c28:	3a 0a                	cmp    (%edx),%cl
  800c2a:	74 eb                	je     800c17 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2c:	0f b6 00             	movzbl (%eax),%eax
  800c2f:	0f b6 12             	movzbl (%edx),%edx
  800c32:	29 d0                	sub    %edx,%eax
}
  800c34:	5b                   	pop    %ebx
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    
		return 0;
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	eb f6                	jmp    800c34 <strncmp+0x32>

00800c3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3e:	f3 0f 1e fb          	endbr32 
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4c:	0f b6 10             	movzbl (%eax),%edx
  800c4f:	84 d2                	test   %dl,%dl
  800c51:	74 09                	je     800c5c <strchr+0x1e>
		if (*s == c)
  800c53:	38 ca                	cmp    %cl,%dl
  800c55:	74 0a                	je     800c61 <strchr+0x23>
	for (; *s; s++)
  800c57:	83 c0 01             	add    $0x1,%eax
  800c5a:	eb f0                	jmp    800c4c <strchr+0xe>
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c74:	38 ca                	cmp    %cl,%dl
  800c76:	74 09                	je     800c81 <strfind+0x1e>
  800c78:	84 d2                	test   %dl,%dl
  800c7a:	74 05                	je     800c81 <strfind+0x1e>
	for (; *s; s++)
  800c7c:	83 c0 01             	add    $0x1,%eax
  800c7f:	eb f0                	jmp    800c71 <strfind+0xe>
			break;
	return (char *) s;
}
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c83:	f3 0f 1e fb          	endbr32 
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c93:	85 c9                	test   %ecx,%ecx
  800c95:	74 31                	je     800cc8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c97:	89 f8                	mov    %edi,%eax
  800c99:	09 c8                	or     %ecx,%eax
  800c9b:	a8 03                	test   $0x3,%al
  800c9d:	75 23                	jne    800cc2 <memset+0x3f>
		c &= 0xFF;
  800c9f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	c1 e3 08             	shl    $0x8,%ebx
  800ca8:	89 d0                	mov    %edx,%eax
  800caa:	c1 e0 18             	shl    $0x18,%eax
  800cad:	89 d6                	mov    %edx,%esi
  800caf:	c1 e6 10             	shl    $0x10,%esi
  800cb2:	09 f0                	or     %esi,%eax
  800cb4:	09 c2                	or     %eax,%edx
  800cb6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cb8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cbb:	89 d0                	mov    %edx,%eax
  800cbd:	fc                   	cld    
  800cbe:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc0:	eb 06                	jmp    800cc8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	fc                   	cld    
  800cc6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cc8:	89 f8                	mov    %edi,%eax
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ccf:	f3 0f 1e fb          	endbr32 
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce1:	39 c6                	cmp    %eax,%esi
  800ce3:	73 32                	jae    800d17 <memmove+0x48>
  800ce5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce8:	39 c2                	cmp    %eax,%edx
  800cea:	76 2b                	jbe    800d17 <memmove+0x48>
		s += n;
		d += n;
  800cec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cef:	89 fe                	mov    %edi,%esi
  800cf1:	09 ce                	or     %ecx,%esi
  800cf3:	09 d6                	or     %edx,%esi
  800cf5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cfb:	75 0e                	jne    800d0b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cfd:	83 ef 04             	sub    $0x4,%edi
  800d00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d06:	fd                   	std    
  800d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d09:	eb 09                	jmp    800d14 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0b:	83 ef 01             	sub    $0x1,%edi
  800d0e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d11:	fd                   	std    
  800d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d14:	fc                   	cld    
  800d15:	eb 1a                	jmp    800d31 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d17:	89 c2                	mov    %eax,%edx
  800d19:	09 ca                	or     %ecx,%edx
  800d1b:	09 f2                	or     %esi,%edx
  800d1d:	f6 c2 03             	test   $0x3,%dl
  800d20:	75 0a                	jne    800d2c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d25:	89 c7                	mov    %eax,%edi
  800d27:	fc                   	cld    
  800d28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2a:	eb 05                	jmp    800d31 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800d2c:	89 c7                	mov    %eax,%edi
  800d2e:	fc                   	cld    
  800d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d3f:	ff 75 10             	pushl  0x10(%ebp)
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 82 ff ff ff       	call   800ccf <memmove>
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4f:	f3 0f 1e fb          	endbr32 
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5e:	89 c6                	mov    %eax,%esi
  800d60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d63:	39 f0                	cmp    %esi,%eax
  800d65:	74 1c                	je     800d83 <memcmp+0x34>
		if (*s1 != *s2)
  800d67:	0f b6 08             	movzbl (%eax),%ecx
  800d6a:	0f b6 1a             	movzbl (%edx),%ebx
  800d6d:	38 d9                	cmp    %bl,%cl
  800d6f:	75 08                	jne    800d79 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d71:	83 c0 01             	add    $0x1,%eax
  800d74:	83 c2 01             	add    $0x1,%edx
  800d77:	eb ea                	jmp    800d63 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800d79:	0f b6 c1             	movzbl %cl,%eax
  800d7c:	0f b6 db             	movzbl %bl,%ebx
  800d7f:	29 d8                	sub    %ebx,%eax
  800d81:	eb 05                	jmp    800d88 <memcmp+0x39>
	}

	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d8c:	f3 0f 1e fb          	endbr32 
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d99:	89 c2                	mov    %eax,%edx
  800d9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d9e:	39 d0                	cmp    %edx,%eax
  800da0:	73 09                	jae    800dab <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da2:	38 08                	cmp    %cl,(%eax)
  800da4:	74 05                	je     800dab <memfind+0x1f>
	for (; s < ends; s++)
  800da6:	83 c0 01             	add    $0x1,%eax
  800da9:	eb f3                	jmp    800d9e <memfind+0x12>
			break;
	return (void *) s;
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dad:	f3 0f 1e fb          	endbr32 
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dbd:	eb 03                	jmp    800dc2 <strtol+0x15>
		s++;
  800dbf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dc2:	0f b6 01             	movzbl (%ecx),%eax
  800dc5:	3c 20                	cmp    $0x20,%al
  800dc7:	74 f6                	je     800dbf <strtol+0x12>
  800dc9:	3c 09                	cmp    $0x9,%al
  800dcb:	74 f2                	je     800dbf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800dcd:	3c 2b                	cmp    $0x2b,%al
  800dcf:	74 2a                	je     800dfb <strtol+0x4e>
	int neg = 0;
  800dd1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dd6:	3c 2d                	cmp    $0x2d,%al
  800dd8:	74 2b                	je     800e05 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dda:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800de0:	75 0f                	jne    800df1 <strtol+0x44>
  800de2:	80 39 30             	cmpb   $0x30,(%ecx)
  800de5:	74 28                	je     800e0f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800de7:	85 db                	test   %ebx,%ebx
  800de9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dee:	0f 44 d8             	cmove  %eax,%ebx
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800df9:	eb 46                	jmp    800e41 <strtol+0x94>
		s++;
  800dfb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dfe:	bf 00 00 00 00       	mov    $0x0,%edi
  800e03:	eb d5                	jmp    800dda <strtol+0x2d>
		s++, neg = 1;
  800e05:	83 c1 01             	add    $0x1,%ecx
  800e08:	bf 01 00 00 00       	mov    $0x1,%edi
  800e0d:	eb cb                	jmp    800dda <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e13:	74 0e                	je     800e23 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e15:	85 db                	test   %ebx,%ebx
  800e17:	75 d8                	jne    800df1 <strtol+0x44>
		s++, base = 8;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e21:	eb ce                	jmp    800df1 <strtol+0x44>
		s += 2, base = 16;
  800e23:	83 c1 02             	add    $0x2,%ecx
  800e26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e2b:	eb c4                	jmp    800df1 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800e2d:	0f be d2             	movsbl %dl,%edx
  800e30:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e36:	7d 3a                	jge    800e72 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e38:	83 c1 01             	add    $0x1,%ecx
  800e3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e41:	0f b6 11             	movzbl (%ecx),%edx
  800e44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e47:	89 f3                	mov    %esi,%ebx
  800e49:	80 fb 09             	cmp    $0x9,%bl
  800e4c:	76 df                	jbe    800e2d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800e4e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e51:	89 f3                	mov    %esi,%ebx
  800e53:	80 fb 19             	cmp    $0x19,%bl
  800e56:	77 08                	ja     800e60 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e58:	0f be d2             	movsbl %dl,%edx
  800e5b:	83 ea 57             	sub    $0x57,%edx
  800e5e:	eb d3                	jmp    800e33 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800e60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e63:	89 f3                	mov    %esi,%ebx
  800e65:	80 fb 19             	cmp    $0x19,%bl
  800e68:	77 08                	ja     800e72 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e6a:	0f be d2             	movsbl %dl,%edx
  800e6d:	83 ea 37             	sub    $0x37,%edx
  800e70:	eb c1                	jmp    800e33 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e76:	74 05                	je     800e7d <strtol+0xd0>
		*endptr = (char *) s;
  800e78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e7d:	89 c2                	mov    %eax,%edx
  800e7f:	f7 da                	neg    %edx
  800e81:	85 ff                	test   %edi,%edi
  800e83:	0f 45 c2             	cmovne %edx,%eax
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e8b:	f3 0f 1e fb          	endbr32 
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e95:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	89 c3                	mov    %eax,%ebx
  800ea2:	89 c7                	mov    %eax,%edi
  800ea4:	89 c6                	mov    %eax,%esi
  800ea6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_cgetc>:

int
sys_cgetc(void)
{
  800ead:	f3 0f 1e fb          	endbr32 
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec1:	89 d1                	mov    %edx,%ecx
  800ec3:	89 d3                	mov    %edx,%ebx
  800ec5:	89 d7                	mov    %edx,%edi
  800ec7:	89 d6                	mov    %edx,%esi
  800ec9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	57                   	push   %edi
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	b8 03 00 00 00       	mov    $0x3,%eax
  800eea:	89 cb                	mov    %ecx,%ebx
  800eec:	89 cf                	mov    %ecx,%edi
  800eee:	89 ce                	mov    %ecx,%esi
  800ef0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7f 08                	jg     800efe <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	6a 03                	push   $0x3
  800f04:	68 bf 2b 80 00       	push   $0x802bbf
  800f09:	6a 23                	push   $0x23
  800f0b:	68 dc 2b 80 00       	push   $0x802bdc
  800f10:	e8 13 f5 ff ff       	call   800428 <_panic>

00800f15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f15:	f3 0f 1e fb          	endbr32 
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	b8 02 00 00 00       	mov    $0x2,%eax
  800f29:	89 d1                	mov    %edx,%ecx
  800f2b:	89 d3                	mov    %edx,%ebx
  800f2d:	89 d7                	mov    %edx,%edi
  800f2f:	89 d6                	mov    %edx,%esi
  800f31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_yield>:

void
sys_yield(void)
{
  800f38:	f3 0f 1e fb          	endbr32 
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f42:	ba 00 00 00 00       	mov    $0x0,%edx
  800f47:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f4c:	89 d1                	mov    %edx,%ecx
  800f4e:	89 d3                	mov    %edx,%ebx
  800f50:	89 d7                	mov    %edx,%edi
  800f52:	89 d6                	mov    %edx,%esi
  800f54:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f5b:	f3 0f 1e fb          	endbr32 
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f68:	be 00 00 00 00       	mov    $0x0,%esi
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	b8 04 00 00 00       	mov    $0x4,%eax
  800f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7b:	89 f7                	mov    %esi,%edi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 04                	push   $0x4
  800f91:	68 bf 2b 80 00       	push   $0x802bbf
  800f96:	6a 23                	push   $0x23
  800f98:	68 dc 2b 80 00       	push   $0x802bdc
  800f9d:	e8 86 f4 ff ff       	call   800428 <_panic>

00800fa2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fa2:	f3 0f 1e fb          	endbr32 
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 05 00 00 00       	mov    $0x5,%eax
  800fba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc0:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	7f 08                	jg     800fd1 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	50                   	push   %eax
  800fd5:	6a 05                	push   $0x5
  800fd7:	68 bf 2b 80 00       	push   $0x802bbf
  800fdc:	6a 23                	push   $0x23
  800fde:	68 dc 2b 80 00       	push   $0x802bdc
  800fe3:	e8 40 f4 ff ff       	call   800428 <_panic>

00800fe8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fe8:	f3 0f 1e fb          	endbr32 
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	b8 06 00 00 00       	mov    $0x6,%eax
  801005:	89 df                	mov    %ebx,%edi
  801007:	89 de                	mov    %ebx,%esi
  801009:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	7f 08                	jg     801017 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	50                   	push   %eax
  80101b:	6a 06                	push   $0x6
  80101d:	68 bf 2b 80 00       	push   $0x802bbf
  801022:	6a 23                	push   $0x23
  801024:	68 dc 2b 80 00       	push   $0x802bdc
  801029:	e8 fa f3 ff ff       	call   800428 <_panic>

0080102e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80102e:	f3 0f 1e fb          	endbr32 
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	b8 08 00 00 00       	mov    $0x8,%eax
  80104b:	89 df                	mov    %ebx,%edi
  80104d:	89 de                	mov    %ebx,%esi
  80104f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801051:	85 c0                	test   %eax,%eax
  801053:	7f 08                	jg     80105d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801055:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	50                   	push   %eax
  801061:	6a 08                	push   $0x8
  801063:	68 bf 2b 80 00       	push   $0x802bbf
  801068:	6a 23                	push   $0x23
  80106a:	68 dc 2b 80 00       	push   $0x802bdc
  80106f:	e8 b4 f3 ff ff       	call   800428 <_panic>

00801074 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801074:	f3 0f 1e fb          	endbr32 
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
  80107e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801081:	bb 00 00 00 00       	mov    $0x0,%ebx
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108c:	b8 09 00 00 00       	mov    $0x9,%eax
  801091:	89 df                	mov    %ebx,%edi
  801093:	89 de                	mov    %ebx,%esi
  801095:	cd 30                	int    $0x30
	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7f 08                	jg     8010a3 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	50                   	push   %eax
  8010a7:	6a 09                	push   $0x9
  8010a9:	68 bf 2b 80 00       	push   $0x802bbf
  8010ae:	6a 23                	push   $0x23
  8010b0:	68 dc 2b 80 00       	push   $0x802bdc
  8010b5:	e8 6e f3 ff ff       	call   800428 <_panic>

008010ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010ba:	f3 0f 1e fb          	endbr32 
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d7:	89 df                	mov    %ebx,%edi
  8010d9:	89 de                	mov    %ebx,%esi
  8010db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	7f 08                	jg     8010e9 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5f                   	pop    %edi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	50                   	push   %eax
  8010ed:	6a 0a                	push   $0xa
  8010ef:	68 bf 2b 80 00       	push   $0x802bbf
  8010f4:	6a 23                	push   $0x23
  8010f6:	68 dc 2b 80 00       	push   $0x802bdc
  8010fb:	e8 28 f3 ff ff       	call   800428 <_panic>

00801100 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801100:	f3 0f 1e fb          	endbr32 
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	57                   	push   %edi
  801108:	56                   	push   %esi
  801109:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110a:	8b 55 08             	mov    0x8(%ebp),%edx
  80110d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801110:	b8 0c 00 00 00       	mov    $0xc,%eax
  801115:	be 00 00 00 00       	mov    $0x0,%esi
  80111a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801120:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801127:	f3 0f 1e fb          	endbr32 
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
  801131:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801134:	b9 00 00 00 00       	mov    $0x0,%ecx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801141:	89 cb                	mov    %ecx,%ebx
  801143:	89 cf                	mov    %ecx,%edi
  801145:	89 ce                	mov    %ecx,%esi
  801147:	cd 30                	int    $0x30
	if(check && ret > 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	7f 08                	jg     801155 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80114d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	50                   	push   %eax
  801159:	6a 0d                	push   $0xd
  80115b:	68 bf 2b 80 00       	push   $0x802bbf
  801160:	6a 23                	push   $0x23
  801162:	68 dc 2b 80 00       	push   $0x802bdc
  801167:	e8 bc f2 ff ff       	call   800428 <_panic>

0080116c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80116c:	f3 0f 1e fb          	endbr32 
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	05 00 00 00 30       	add    $0x30000000,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80118f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801194:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80119b:	f3 0f 1e fb          	endbr32 
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a7:	89 c2                	mov    %eax,%edx
  8011a9:	c1 ea 16             	shr    $0x16,%edx
  8011ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b3:	f6 c2 01             	test   $0x1,%dl
  8011b6:	74 2d                	je     8011e5 <fd_alloc+0x4a>
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	c1 ea 0c             	shr    $0xc,%edx
  8011bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c4:	f6 c2 01             	test   $0x1,%dl
  8011c7:	74 1c                	je     8011e5 <fd_alloc+0x4a>
  8011c9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011ce:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d3:	75 d2                	jne    8011a7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011de:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e3:	eb 0a                	jmp    8011ef <fd_alloc+0x54>
			*fd_store = fd;
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f1:	f3 0f 1e fb          	endbr32 
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fb:	83 f8 1f             	cmp    $0x1f,%eax
  8011fe:	77 30                	ja     801230 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801200:	c1 e0 0c             	shl    $0xc,%eax
  801203:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801208:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	74 24                	je     801237 <fd_lookup+0x46>
  801213:	89 c2                	mov    %eax,%edx
  801215:	c1 ea 0c             	shr    $0xc,%edx
  801218:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121f:	f6 c2 01             	test   $0x1,%dl
  801222:	74 1a                	je     80123e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801224:	8b 55 0c             	mov    0xc(%ebp),%edx
  801227:	89 02                	mov    %eax,(%edx)
	return 0;
  801229:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    
		return -E_INVAL;
  801230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801235:	eb f7                	jmp    80122e <fd_lookup+0x3d>
		return -E_INVAL;
  801237:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123c:	eb f0                	jmp    80122e <fd_lookup+0x3d>
  80123e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801243:	eb e9                	jmp    80122e <fd_lookup+0x3d>

00801245 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801245:	f3 0f 1e fb          	endbr32 
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801252:	ba 68 2c 80 00       	mov    $0x802c68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801257:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80125c:	39 08                	cmp    %ecx,(%eax)
  80125e:	74 33                	je     801293 <dev_lookup+0x4e>
  801260:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801263:	8b 02                	mov    (%edx),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	75 f3                	jne    80125c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801269:	a1 90 67 80 00       	mov    0x806790,%eax
  80126e:	8b 40 48             	mov    0x48(%eax),%eax
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	51                   	push   %ecx
  801275:	50                   	push   %eax
  801276:	68 ec 2b 80 00       	push   $0x802bec
  80127b:	e8 8f f2 ff ff       	call   80050f <cprintf>
	*dev = 0;
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    
			*dev = devtab[i];
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	89 01                	mov    %eax,(%ecx)
			return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	eb f2                	jmp    801291 <dev_lookup+0x4c>

0080129f <fd_close>:
{
  80129f:	f3 0f 1e fb          	endbr32 
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 24             	sub    $0x24,%esp
  8012ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8012af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012bc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bf:	50                   	push   %eax
  8012c0:	e8 2c ff ff ff       	call   8011f1 <fd_lookup>
  8012c5:	89 c3                	mov    %eax,%ebx
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 05                	js     8012d3 <fd_close+0x34>
	    || fd != fd2)
  8012ce:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012d1:	74 16                	je     8012e9 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012d3:	89 f8                	mov    %edi,%eax
  8012d5:	84 c0                	test   %al,%al
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	0f 44 d8             	cmove  %eax,%ebx
}
  8012df:	89 d8                	mov    %ebx,%eax
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 36                	pushl  (%esi)
  8012f2:	e8 4e ff ff ff       	call   801245 <dev_lookup>
  8012f7:	89 c3                	mov    %eax,%ebx
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 1a                	js     80131a <fd_close+0x7b>
		if (dev->dev_close)
  801300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801303:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801306:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80130b:	85 c0                	test   %eax,%eax
  80130d:	74 0b                	je     80131a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	56                   	push   %esi
  801313:	ff d0                	call   *%eax
  801315:	89 c3                	mov    %eax,%ebx
  801317:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	56                   	push   %esi
  80131e:	6a 00                	push   $0x0
  801320:	e8 c3 fc ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	eb b5                	jmp    8012df <fd_close+0x40>

0080132a <close>:

int
close(int fdnum)
{
  80132a:	f3 0f 1e fb          	endbr32 
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	ff 75 08             	pushl  0x8(%ebp)
  80133b:	e8 b1 fe ff ff       	call   8011f1 <fd_lookup>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	79 02                	jns    801349 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    
		return fd_close(fd, 1);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	6a 01                	push   $0x1
  80134e:	ff 75 f4             	pushl  -0xc(%ebp)
  801351:	e8 49 ff ff ff       	call   80129f <fd_close>
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	eb ec                	jmp    801347 <close+0x1d>

0080135b <close_all>:

void
close_all(void)
{
  80135b:	f3 0f 1e fb          	endbr32 
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	53                   	push   %ebx
  801363:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801366:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	53                   	push   %ebx
  80136f:	e8 b6 ff ff ff       	call   80132a <close>
	for (i = 0; i < MAXFD; i++)
  801374:	83 c3 01             	add    $0x1,%ebx
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	83 fb 20             	cmp    $0x20,%ebx
  80137d:	75 ec                	jne    80136b <close_all+0x10>
}
  80137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801384:	f3 0f 1e fb          	endbr32 
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	57                   	push   %edi
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
  80138e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fe ff ff       	call   8011f1 <fd_lookup>
  80139d:	89 c3                	mov    %eax,%ebx
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	0f 88 81 00 00 00    	js     80142b <dup+0xa7>
		return r;
	close(newfdnum);
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	e8 75 ff ff ff       	call   80132a <close>

	newfd = INDEX2FD(newfdnum);
  8013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b8:	c1 e6 0c             	shl    $0xc,%esi
  8013bb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013c1:	83 c4 04             	add    $0x4,%esp
  8013c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c7:	e8 b4 fd ff ff       	call   801180 <fd2data>
  8013cc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ce:	89 34 24             	mov    %esi,(%esp)
  8013d1:	e8 aa fd ff ff       	call   801180 <fd2data>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	c1 e8 16             	shr    $0x16,%eax
  8013e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e7:	a8 01                	test   $0x1,%al
  8013e9:	74 11                	je     8013fc <dup+0x78>
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	c1 e8 0c             	shr    $0xc,%eax
  8013f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f7:	f6 c2 01             	test   $0x1,%dl
  8013fa:	75 39                	jne    801435 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ff:	89 d0                	mov    %edx,%eax
  801401:	c1 e8 0c             	shr    $0xc,%eax
  801404:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	25 07 0e 00 00       	and    $0xe07,%eax
  801413:	50                   	push   %eax
  801414:	56                   	push   %esi
  801415:	6a 00                	push   $0x0
  801417:	52                   	push   %edx
  801418:	6a 00                	push   $0x0
  80141a:	e8 83 fb ff ff       	call   800fa2 <sys_page_map>
  80141f:	89 c3                	mov    %eax,%ebx
  801421:	83 c4 20             	add    $0x20,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 31                	js     801459 <dup+0xd5>
		goto err;

	return newfdnum;
  801428:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142b:	89 d8                	mov    %ebx,%eax
  80142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801435:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	25 07 0e 00 00       	and    $0xe07,%eax
  801444:	50                   	push   %eax
  801445:	57                   	push   %edi
  801446:	6a 00                	push   $0x0
  801448:	53                   	push   %ebx
  801449:	6a 00                	push   $0x0
  80144b:	e8 52 fb ff ff       	call   800fa2 <sys_page_map>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	83 c4 20             	add    $0x20,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	79 a3                	jns    8013fc <dup+0x78>
	sys_page_unmap(0, newfd);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	56                   	push   %esi
  80145d:	6a 00                	push   $0x0
  80145f:	e8 84 fb ff ff       	call   800fe8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801464:	83 c4 08             	add    $0x8,%esp
  801467:	57                   	push   %edi
  801468:	6a 00                	push   $0x0
  80146a:	e8 79 fb ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	eb b7                	jmp    80142b <dup+0xa7>

00801474 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801474:	f3 0f 1e fb          	endbr32 
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	53                   	push   %ebx
  80147c:	83 ec 1c             	sub    $0x1c,%esp
  80147f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801482:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	53                   	push   %ebx
  801487:	e8 65 fd ff ff       	call   8011f1 <fd_lookup>
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 3f                	js     8014d2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801499:	50                   	push   %eax
  80149a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149d:	ff 30                	pushl  (%eax)
  80149f:	e8 a1 fd ff ff       	call   801245 <dev_lookup>
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 27                	js     8014d2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ae:	8b 42 08             	mov    0x8(%edx),%eax
  8014b1:	83 e0 03             	and    $0x3,%eax
  8014b4:	83 f8 01             	cmp    $0x1,%eax
  8014b7:	74 1e                	je     8014d7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bc:	8b 40 08             	mov    0x8(%eax),%eax
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	74 35                	je     8014f8 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	ff 75 10             	pushl  0x10(%ebp)
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	52                   	push   %edx
  8014cd:	ff d0                	call   *%eax
  8014cf:	83 c4 10             	add    $0x10,%esp
}
  8014d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d7:	a1 90 67 80 00       	mov    0x806790,%eax
  8014dc:	8b 40 48             	mov    0x48(%eax),%eax
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	53                   	push   %ebx
  8014e3:	50                   	push   %eax
  8014e4:	68 2d 2c 80 00       	push   $0x802c2d
  8014e9:	e8 21 f0 ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f6:	eb da                	jmp    8014d2 <read+0x5e>
		return -E_NOT_SUPP;
  8014f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fd:	eb d3                	jmp    8014d2 <read+0x5e>

008014ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ff:	f3 0f 1e fb          	endbr32 
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	57                   	push   %edi
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80150f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801512:	bb 00 00 00 00       	mov    $0x0,%ebx
  801517:	eb 02                	jmp    80151b <readn+0x1c>
  801519:	01 c3                	add    %eax,%ebx
  80151b:	39 f3                	cmp    %esi,%ebx
  80151d:	73 21                	jae    801540 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	89 f0                	mov    %esi,%eax
  801524:	29 d8                	sub    %ebx,%eax
  801526:	50                   	push   %eax
  801527:	89 d8                	mov    %ebx,%eax
  801529:	03 45 0c             	add    0xc(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	57                   	push   %edi
  80152e:	e8 41 ff ff ff       	call   801474 <read>
		if (m < 0)
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 04                	js     80153e <readn+0x3f>
			return m;
		if (m == 0)
  80153a:	75 dd                	jne    801519 <readn+0x1a>
  80153c:	eb 02                	jmp    801540 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80153e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801540:	89 d8                	mov    %ebx,%eax
  801542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5f                   	pop    %edi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    

0080154a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80154a:	f3 0f 1e fb          	endbr32 
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	53                   	push   %ebx
  801552:	83 ec 1c             	sub    $0x1c,%esp
  801555:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801558:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	53                   	push   %ebx
  80155d:	e8 8f fc ff ff       	call   8011f1 <fd_lookup>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 3a                	js     8015a3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	ff 30                	pushl  (%eax)
  801575:	e8 cb fc ff ff       	call   801245 <dev_lookup>
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 22                	js     8015a3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801584:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801588:	74 1e                	je     8015a8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	8b 52 0c             	mov    0xc(%edx),%edx
  801590:	85 d2                	test   %edx,%edx
  801592:	74 35                	je     8015c9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	ff 75 10             	pushl  0x10(%ebp)
  80159a:	ff 75 0c             	pushl  0xc(%ebp)
  80159d:	50                   	push   %eax
  80159e:	ff d2                	call   *%edx
  8015a0:	83 c4 10             	add    $0x10,%esp
}
  8015a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a8:	a1 90 67 80 00       	mov    0x806790,%eax
  8015ad:	8b 40 48             	mov    0x48(%eax),%eax
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	53                   	push   %ebx
  8015b4:	50                   	push   %eax
  8015b5:	68 49 2c 80 00       	push   $0x802c49
  8015ba:	e8 50 ef ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c7:	eb da                	jmp    8015a3 <write+0x59>
		return -E_NOT_SUPP;
  8015c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ce:	eb d3                	jmp    8015a3 <write+0x59>

008015d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015d0:	f3 0f 1e fb          	endbr32 
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015dd:	50                   	push   %eax
  8015de:	ff 75 08             	pushl  0x8(%ebp)
  8015e1:	e8 0b fc ff ff       	call   8011f1 <fd_lookup>
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	78 0e                	js     8015fb <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8015ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015fd:	f3 0f 1e fb          	endbr32 
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	53                   	push   %ebx
  801605:	83 ec 1c             	sub    $0x1c,%esp
  801608:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	53                   	push   %ebx
  801610:	e8 dc fb ff ff       	call   8011f1 <fd_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 37                	js     801653 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801622:	50                   	push   %eax
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	ff 30                	pushl  (%eax)
  801628:	e8 18 fc ff ff       	call   801245 <dev_lookup>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 1f                	js     801653 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163b:	74 1b                	je     801658 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80163d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801640:	8b 52 18             	mov    0x18(%edx),%edx
  801643:	85 d2                	test   %edx,%edx
  801645:	74 32                	je     801679 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	50                   	push   %eax
  80164e:	ff d2                	call   *%edx
  801650:	83 c4 10             	add    $0x10,%esp
}
  801653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801656:	c9                   	leave  
  801657:	c3                   	ret    
			thisenv->env_id, fdnum);
  801658:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80165d:	8b 40 48             	mov    0x48(%eax),%eax
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	53                   	push   %ebx
  801664:	50                   	push   %eax
  801665:	68 0c 2c 80 00       	push   $0x802c0c
  80166a:	e8 a0 ee ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801677:	eb da                	jmp    801653 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801679:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167e:	eb d3                	jmp    801653 <ftruncate+0x56>

00801680 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801680:	f3 0f 1e fb          	endbr32 
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	53                   	push   %ebx
  801688:	83 ec 1c             	sub    $0x1c,%esp
  80168b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801691:	50                   	push   %eax
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	e8 57 fb ff ff       	call   8011f1 <fd_lookup>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 4b                	js     8016ec <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	ff 30                	pushl  (%eax)
  8016ad:	e8 93 fb ff ff       	call   801245 <dev_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 33                	js     8016ec <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c0:	74 2f                	je     8016f1 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016cc:	00 00 00 
	stat->st_isdir = 0;
  8016cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d6:	00 00 00 
	stat->st_dev = dev;
  8016d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	53                   	push   %ebx
  8016e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e6:	ff 50 14             	call   *0x14(%eax)
  8016e9:	83 c4 10             	add    $0x10,%esp
}
  8016ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f6:	eb f4                	jmp    8016ec <fstat+0x6c>

008016f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016f8:	f3 0f 1e fb          	endbr32 
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	56                   	push   %esi
  801700:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801701:	83 ec 08             	sub    $0x8,%esp
  801704:	6a 00                	push   $0x0
  801706:	ff 75 08             	pushl  0x8(%ebp)
  801709:	e8 fb 01 00 00       	call   801909 <open>
  80170e:	89 c3                	mov    %eax,%ebx
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	78 1b                	js     801732 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	50                   	push   %eax
  80171e:	e8 5d ff ff ff       	call   801680 <fstat>
  801723:	89 c6                	mov    %eax,%esi
	close(fd);
  801725:	89 1c 24             	mov    %ebx,(%esp)
  801728:	e8 fd fb ff ff       	call   80132a <close>
	return r;
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	89 f3                	mov    %esi,%ebx
}
  801732:	89 d8                	mov    %ebx,%eax
  801734:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    

0080173b <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	89 c6                	mov    %eax,%esi
  801742:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801744:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80174b:	74 27                	je     801774 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174d:	6a 07                	push   $0x7
  80174f:	68 00 70 80 00       	push   $0x807000
  801754:	56                   	push   %esi
  801755:	ff 35 00 50 80 00    	pushl  0x805000
  80175b:	e8 93 0c 00 00       	call   8023f3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801760:	83 c4 0c             	add    $0xc,%esp
  801763:	6a 00                	push   $0x0
  801765:	53                   	push   %ebx
  801766:	6a 00                	push   $0x0
  801768:	e8 19 0c 00 00       	call   802386 <ipc_recv>
}
  80176d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	6a 01                	push   $0x1
  801779:	e8 cf 0c 00 00       	call   80244d <ipc_find_env>
  80177e:	a3 00 50 80 00       	mov    %eax,0x805000
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	eb c5                	jmp    80174d <fsipc+0x12>

00801788 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801788:	f3 0f 1e fb          	endbr32 
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8b 40 0c             	mov    0xc(%eax),%eax
  801798:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	b8 02 00 00 00       	mov    $0x2,%eax
  8017af:	e8 87 ff ff ff       	call   80173b <fsipc>
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <devfile_flush>:
{
  8017b6:	f3 0f 1e fb          	endbr32 
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c6:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	b8 06 00 00 00       	mov    $0x6,%eax
  8017d5:	e8 61 ff ff ff       	call   80173b <fsipc>
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <devfile_stat>:
{
  8017dc:	f3 0f 1e fb          	endbr32 
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f0:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ff:	e8 37 ff ff ff       	call   80173b <fsipc>
  801804:	85 c0                	test   %eax,%eax
  801806:	78 2c                	js     801834 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	68 00 70 80 00       	push   $0x807000
  801810:	53                   	push   %ebx
  801811:	e8 03 f3 ff ff       	call   800b19 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801816:	a1 80 70 80 00       	mov    0x807080,%eax
  80181b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801821:	a1 84 70 80 00       	mov    0x807084,%eax
  801826:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <devfile_write>:
{
  801839:	f3 0f 1e fb          	endbr32 
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
  801846:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80184b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801850:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801853:	8b 55 08             	mov    0x8(%ebp),%edx
  801856:	8b 52 0c             	mov    0xc(%edx),%edx
  801859:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = n;
  80185f:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf,buf,n);
  801864:	50                   	push   %eax
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	68 08 70 80 00       	push   $0x807008
  80186d:	e8 5d f4 ff ff       	call   800ccf <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801872:	ba 00 00 00 00       	mov    $0x0,%edx
  801877:	b8 04 00 00 00       	mov    $0x4,%eax
  80187c:	e8 ba fe ff ff       	call   80173b <fsipc>
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <devfile_read>:
{
  801883:	f3 0f 1e fb          	endbr32 
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	8b 40 0c             	mov    0xc(%eax),%eax
  801895:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80189a:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a5:	b8 03 00 00 00       	mov    $0x3,%eax
  8018aa:	e8 8c fe ff ff       	call   80173b <fsipc>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	78 1f                	js     8018d4 <devfile_read+0x51>
	assert(r <= n);
  8018b5:	39 f0                	cmp    %esi,%eax
  8018b7:	77 24                	ja     8018dd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8018b9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018be:	7f 33                	jg     8018f3 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	50                   	push   %eax
  8018c4:	68 00 70 80 00       	push   $0x807000
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	e8 fe f3 ff ff       	call   800ccf <memmove>
	return r;
  8018d1:	83 c4 10             	add    $0x10,%esp
}
  8018d4:	89 d8                	mov    %ebx,%eax
  8018d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5e                   	pop    %esi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    
	assert(r <= n);
  8018dd:	68 78 2c 80 00       	push   $0x802c78
  8018e2:	68 7f 2c 80 00       	push   $0x802c7f
  8018e7:	6a 7d                	push   $0x7d
  8018e9:	68 94 2c 80 00       	push   $0x802c94
  8018ee:	e8 35 eb ff ff       	call   800428 <_panic>
	assert(r <= PGSIZE);
  8018f3:	68 9f 2c 80 00       	push   $0x802c9f
  8018f8:	68 7f 2c 80 00       	push   $0x802c7f
  8018fd:	6a 7e                	push   $0x7e
  8018ff:	68 94 2c 80 00       	push   $0x802c94
  801904:	e8 1f eb ff ff       	call   800428 <_panic>

00801909 <open>:
{
  801909:	f3 0f 1e fb          	endbr32 
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
  801912:	83 ec 1c             	sub    $0x1c,%esp
  801915:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801918:	56                   	push   %esi
  801919:	e8 b8 f1 ff ff       	call   800ad6 <strlen>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801926:	7f 6c                	jg     801994 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192e:	50                   	push   %eax
  80192f:	e8 67 f8 ff ff       	call   80119b <fd_alloc>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 3c                	js     801979 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	56                   	push   %esi
  801941:	68 00 70 80 00       	push   $0x807000
  801946:	e8 ce f1 ff ff       	call   800b19 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194e:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801956:	b8 01 00 00 00       	mov    $0x1,%eax
  80195b:	e8 db fd ff ff       	call   80173b <fsipc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 19                	js     801982 <open+0x79>
	return fd2num(fd);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	ff 75 f4             	pushl  -0xc(%ebp)
  80196f:	e8 f8 f7 ff ff       	call   80116c <fd2num>
  801974:	89 c3                	mov    %eax,%ebx
  801976:	83 c4 10             	add    $0x10,%esp
}
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    
		fd_close(fd, 0);
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	6a 00                	push   $0x0
  801987:	ff 75 f4             	pushl  -0xc(%ebp)
  80198a:	e8 10 f9 ff ff       	call   80129f <fd_close>
		return r;
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	eb e5                	jmp    801979 <open+0x70>
		return -E_BAD_PATH;
  801994:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801999:	eb de                	jmp    801979 <open+0x70>

0080199b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80199b:	f3 0f 1e fb          	endbr32 
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8019af:	e8 87 fd ff ff       	call   80173b <fsipc>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019b6:	f3 0f 1e fb          	endbr32 
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	57                   	push   %edi
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	//cprintf("spawn start\n");
	if ((r = open(prog, O_RDONLY)) < 0)
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	e8 39 ff ff ff       	call   801909 <open>
  8019d0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	0f 88 e9 04 00 00    	js     801eca <spawn+0x514>
  8019e1:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;
	
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 00 02 00 00       	push   $0x200
  8019eb:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019f1:	50                   	push   %eax
  8019f2:	51                   	push   %ecx
  8019f3:	e8 07 fb ff ff       	call   8014ff <readn>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a00:	75 7e                	jne    801a80 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  801a02:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a09:	45 4c 46 
  801a0c:	75 72                	jne    801a80 <spawn+0xca>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a0e:	b8 07 00 00 00       	mov    $0x7,%eax
  801a13:	cd 30                	int    $0x30
  801a15:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a1b:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a21:	85 c0                	test   %eax,%eax
  801a23:	0f 88 95 04 00 00    	js     801ebe <spawn+0x508>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a29:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a2e:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801a31:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a37:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a3d:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a44:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a4a:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	char *string_store;
	uintptr_t *argv_store;
	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a50:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a55:	be 00 00 00 00       	mov    $0x0,%esi
  801a5a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a5d:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801a64:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	74 4d                	je     801ab8 <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	50                   	push   %eax
  801a6f:	e8 62 f0 ff ff       	call   800ad6 <strlen>
  801a74:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a78:	83 c3 01             	add    $0x1,%ebx
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	eb dd                	jmp    801a5d <spawn+0xa7>
		close(fd);
  801a80:	83 ec 0c             	sub    $0xc,%esp
  801a83:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a89:	e8 9c f8 ff ff       	call   80132a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a8e:	83 c4 0c             	add    $0xc,%esp
  801a91:	68 7f 45 4c 46       	push   $0x464c457f
  801a96:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a9c:	68 ab 2c 80 00       	push   $0x802cab
  801aa1:	e8 69 ea ff ff       	call   80050f <cprintf>
		return -E_NOT_EXEC;
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801ab0:	ff ff ff 
  801ab3:	e9 12 04 00 00       	jmp    801eca <spawn+0x514>
  801ab8:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801abe:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ac4:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ac9:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801acb:	89 fa                	mov    %edi,%edx
  801acd:	83 e2 fc             	and    $0xfffffffc,%edx
  801ad0:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ad7:	29 c2                	sub    %eax,%edx
  801ad9:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801adf:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ae2:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ae7:	0f 86 00 04 00 00    	jbe    801eed <spawn+0x537>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	6a 07                	push   $0x7
  801af2:	68 00 00 40 00       	push   $0x400000
  801af7:	6a 00                	push   $0x0
  801af9:	e8 5d f4 ff ff       	call   800f5b <sys_page_alloc>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	0f 88 e9 03 00 00    	js     801ef2 <spawn+0x53c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)

	for (i = 0; i < argc; i++) {
  801b09:	be 00 00 00 00       	mov    $0x0,%esi
  801b0e:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b17:	eb 30                	jmp    801b49 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b19:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b1f:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b25:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b2e:	57                   	push   %edi
  801b2f:	e8 e5 ef ff ff       	call   800b19 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b3a:	e8 97 ef ff ff       	call   800ad6 <strlen>
  801b3f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b43:	83 c6 01             	add    $0x1,%esi
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b4f:	7f c8                	jg     801b19 <spawn+0x163>
	}

	argv_store[argc] = 0;
  801b51:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b57:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801b5d:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b64:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b6a:	0f 85 82 00 00 00    	jne    801bf2 <spawn+0x23c>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b70:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b76:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801b7c:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801b7f:	89 c8                	mov    %ecx,%eax
  801b81:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801b87:	89 51 f8             	mov    %edx,-0x8(%ecx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b8a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b8f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	6a 07                	push   $0x7
  801b9a:	68 00 d0 bf ee       	push   $0xeebfd000
  801b9f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ba5:	68 00 00 40 00       	push   $0x400000
  801baa:	6a 00                	push   $0x0
  801bac:	e8 f1 f3 ff ff       	call   800fa2 <sys_page_map>
  801bb1:	83 c4 20             	add    $0x20,%esp
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	0f 88 41 03 00 00    	js     801efd <spawn+0x547>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	68 00 00 40 00       	push   $0x400000
  801bc4:	6a 00                	push   $0x0
  801bc6:	e8 1d f4 ff ff       	call   800fe8 <sys_page_unmap>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	0f 88 27 03 00 00    	js     801efd <spawn+0x547>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bd6:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bdc:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801be3:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801bea:	00 00 00 
  801bed:	e9 4f 01 00 00       	jmp    801d41 <spawn+0x38b>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801bf2:	68 20 2d 80 00       	push   $0x802d20
  801bf7:	68 7f 2c 80 00       	push   $0x802c7f
  801bfc:	68 ea 00 00 00       	push   $0xea
  801c01:	68 c5 2c 80 00       	push   $0x802cc5
  801c06:	e8 1d e8 ff ff       	call   800428 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	6a 07                	push   $0x7
  801c10:	68 00 00 40 00       	push   $0x400000
  801c15:	6a 00                	push   $0x0
  801c17:	e8 3f f3 ff ff       	call   800f5b <sys_page_alloc>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	0f 88 b1 02 00 00    	js     801ed8 <spawn+0x522>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c27:	83 ec 08             	sub    $0x8,%esp
  801c2a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c30:	01 f0                	add    %esi,%eax
  801c32:	50                   	push   %eax
  801c33:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c39:	e8 92 f9 ff ff       	call   8015d0 <seek>
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	0f 88 96 02 00 00    	js     801edf <spawn+0x529>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c52:	29 f0                	sub    %esi,%eax
  801c54:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c59:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c5e:	0f 47 c1             	cmova  %ecx,%eax
  801c61:	50                   	push   %eax
  801c62:	68 00 00 40 00       	push   $0x400000
  801c67:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c6d:	e8 8d f8 ff ff       	call   8014ff <readn>
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	85 c0                	test   %eax,%eax
  801c77:	0f 88 69 02 00 00    	js     801ee6 <spawn+0x530>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c86:	53                   	push   %ebx
  801c87:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c8d:	68 00 00 40 00       	push   $0x400000
  801c92:	6a 00                	push   $0x0
  801c94:	e8 09 f3 ff ff       	call   800fa2 <sys_page_map>
  801c99:	83 c4 20             	add    $0x20,%esp
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	78 7c                	js     801d1c <spawn+0x366>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ca0:	83 ec 08             	sub    $0x8,%esp
  801ca3:	68 00 00 40 00       	push   $0x400000
  801ca8:	6a 00                	push   $0x0
  801caa:	e8 39 f3 ff ff       	call   800fe8 <sys_page_unmap>
  801caf:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cb2:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cbe:	89 fe                	mov    %edi,%esi
  801cc0:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801cc6:	76 69                	jbe    801d31 <spawn+0x37b>
		if (i >= filesz) {
  801cc8:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801cce:	0f 87 37 ff ff ff    	ja     801c0b <spawn+0x255>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cdd:	53                   	push   %ebx
  801cde:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801ce4:	e8 72 f2 ff ff       	call   800f5b <sys_page_alloc>
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	85 c0                	test   %eax,%eax
  801cee:	79 c2                	jns    801cb2 <spawn+0x2fc>
  801cf0:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801cfb:	e8 d0 f1 ff ff       	call   800ed0 <sys_env_destroy>
	close(fd);
  801d00:	83 c4 04             	add    $0x4,%esp
  801d03:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d09:	e8 1c f6 ff ff       	call   80132a <close>
	return r;
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d17:	e9 ae 01 00 00       	jmp    801eca <spawn+0x514>
				panic("spawn: sys_page_map data: %e", r);
  801d1c:	50                   	push   %eax
  801d1d:	68 d1 2c 80 00       	push   $0x802cd1
  801d22:	68 1b 01 00 00       	push   $0x11b
  801d27:	68 c5 2c 80 00       	push   $0x802cc5
  801d2c:	e8 f7 e6 ff ff       	call   800428 <_panic>
  801d31:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d37:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d3e:	83 c6 20             	add    $0x20,%esi
  801d41:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d48:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d4e:	7e 6d                	jle    801dbd <spawn+0x407>
		if (ph->p_type != ELF_PROG_LOAD)
  801d50:	83 3e 01             	cmpl   $0x1,(%esi)
  801d53:	75 e2                	jne    801d37 <spawn+0x381>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d55:	8b 46 18             	mov    0x18(%esi),%eax
  801d58:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d5b:	83 f8 01             	cmp    $0x1,%eax
  801d5e:	19 c0                	sbb    %eax,%eax
  801d60:	83 e0 fe             	and    $0xfffffffe,%eax
  801d63:	83 c0 07             	add    $0x7,%eax
  801d66:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d6c:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d6f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d75:	8b 56 10             	mov    0x10(%esi),%edx
  801d78:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d7e:	8b 7e 14             	mov    0x14(%esi),%edi
  801d81:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801d87:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801d8a:	89 d8                	mov    %ebx,%eax
  801d8c:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d91:	74 1a                	je     801dad <spawn+0x3f7>
		va -= i;
  801d93:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801d95:	01 c7                	add    %eax,%edi
  801d97:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801d9d:	01 c2                	add    %eax,%edx
  801d9f:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801da5:	29 c1                	sub    %eax,%ecx
  801da7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801dad:	bf 00 00 00 00       	mov    $0x0,%edi
  801db2:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801db8:	e9 01 ff ff ff       	jmp    801cbe <spawn+0x308>
	close(fd);
  801dbd:	83 ec 0c             	sub    $0xc,%esp
  801dc0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dc6:	e8 5f f5 ff ff       	call   80132a <close>
  801dcb:	83 c4 10             	add    $0x10,%esp
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  801dce:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801dd3:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801dd9:	eb 33                	jmp    801e0e <spawn+0x458>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
		sys_page_map(thisenv->env_id,(void *)addr,child,(void *)addr,(uvpt[PGNUM(addr)] & PTE_SYSCALL));
  801ddb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801de2:	8b 15 90 67 80 00    	mov    0x806790,%edx
  801de8:	8b 52 48             	mov    0x48(%edx),%edx
  801deb:	83 ec 0c             	sub    $0xc,%esp
  801dee:	25 07 0e 00 00       	and    $0xe07,%eax
  801df3:	50                   	push   %eax
  801df4:	53                   	push   %ebx
  801df5:	56                   	push   %esi
  801df6:	53                   	push   %ebx
  801df7:	52                   	push   %edx
  801df8:	e8 a5 f1 ff ff       	call   800fa2 <sys_page_map>
  801dfd:	83 c4 20             	add    $0x20,%esp
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  801e00:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e06:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e0c:	74 3b                	je     801e49 <spawn+0x493>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
  801e0e:	89 d8                	mov    %ebx,%eax
  801e10:	c1 e8 16             	shr    $0x16,%eax
  801e13:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e1a:	a8 01                	test   $0x1,%al
  801e1c:	74 e2                	je     801e00 <spawn+0x44a>
  801e1e:	89 d8                	mov    %ebx,%eax
  801e20:	c1 e8 0c             	shr    $0xc,%eax
  801e23:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e2a:	f6 c2 01             	test   $0x1,%dl
  801e2d:	74 d1                	je     801e00 <spawn+0x44a>
  801e2f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e36:	f6 c2 04             	test   $0x4,%dl
  801e39:	74 c5                	je     801e00 <spawn+0x44a>
  801e3b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e42:	f6 c6 04             	test   $0x4,%dh
  801e45:	74 b9                	je     801e00 <spawn+0x44a>
  801e47:	eb 92                	jmp    801ddb <spawn+0x425>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e49:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e50:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e5c:	50                   	push   %eax
  801e5d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e63:	e8 0c f2 ff ff       	call   801074 <sys_env_set_trapframe>
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	78 25                	js     801e94 <spawn+0x4de>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e6f:	83 ec 08             	sub    $0x8,%esp
  801e72:	6a 02                	push   $0x2
  801e74:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e7a:	e8 af f1 ff ff       	call   80102e <sys_env_set_status>
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 23                	js     801ea9 <spawn+0x4f3>
	return child;
  801e86:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e8c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e92:	eb 36                	jmp    801eca <spawn+0x514>
		panic("sys_env_set_trapframe: %e", r);
  801e94:	50                   	push   %eax
  801e95:	68 ee 2c 80 00       	push   $0x802cee
  801e9a:	68 82 00 00 00       	push   $0x82
  801e9f:	68 c5 2c 80 00       	push   $0x802cc5
  801ea4:	e8 7f e5 ff ff       	call   800428 <_panic>
		panic("sys_env_set_status: %e", r);
  801ea9:	50                   	push   %eax
  801eaa:	68 08 2d 80 00       	push   $0x802d08
  801eaf:	68 84 00 00 00       	push   $0x84
  801eb4:	68 c5 2c 80 00       	push   $0x802cc5
  801eb9:	e8 6a e5 ff ff       	call   800428 <_panic>
		return r;
  801ebe:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ec4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801eca:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5f                   	pop    %edi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
  801ed8:	89 c7                	mov    %eax,%edi
  801eda:	e9 13 fe ff ff       	jmp    801cf2 <spawn+0x33c>
  801edf:	89 c7                	mov    %eax,%edi
  801ee1:	e9 0c fe ff ff       	jmp    801cf2 <spawn+0x33c>
  801ee6:	89 c7                	mov    %eax,%edi
  801ee8:	e9 05 fe ff ff       	jmp    801cf2 <spawn+0x33c>
		return -E_NO_MEM;
  801eed:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  801ef2:	c1 e8 1f             	shr    $0x1f,%eax
  801ef5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801efb:	eb cd                	jmp    801eca <spawn+0x514>
	sys_page_unmap(0, UTEMP);
  801efd:	83 ec 08             	sub    $0x8,%esp
  801f00:	68 00 00 40 00       	push   $0x400000
  801f05:	6a 00                	push   $0x0
  801f07:	e8 dc f0 ff ff       	call   800fe8 <sys_page_unmap>
  801f0c:	83 c4 10             	add    $0x10,%esp
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  801f0f:	c7 85 94 fd ff ff 01 	movl   $0x1,-0x26c(%ebp)
  801f16:	00 00 00 
  801f19:	eb af                	jmp    801eca <spawn+0x514>

00801f1b <spawnl>:
{
  801f1b:	f3 0f 1e fb          	endbr32 
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	57                   	push   %edi
  801f23:	56                   	push   %esi
  801f24:	53                   	push   %ebx
  801f25:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f28:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f30:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f33:	83 3a 00             	cmpl   $0x0,(%edx)
  801f36:	74 07                	je     801f3f <spawnl+0x24>
		argc++;
  801f38:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f3b:	89 ca                	mov    %ecx,%edx
  801f3d:	eb f1                	jmp    801f30 <spawnl+0x15>
	const char *argv[argc+2];
  801f3f:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f46:	89 d1                	mov    %edx,%ecx
  801f48:	83 e1 f0             	and    $0xfffffff0,%ecx
  801f4b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f51:	89 e6                	mov    %esp,%esi
  801f53:	29 d6                	sub    %edx,%esi
  801f55:	89 f2                	mov    %esi,%edx
  801f57:	39 d4                	cmp    %edx,%esp
  801f59:	74 10                	je     801f6b <spawnl+0x50>
  801f5b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801f61:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801f68:	00 
  801f69:	eb ec                	jmp    801f57 <spawnl+0x3c>
  801f6b:	89 ca                	mov    %ecx,%edx
  801f6d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801f73:	29 d4                	sub    %edx,%esp
  801f75:	85 d2                	test   %edx,%edx
  801f77:	74 05                	je     801f7e <spawnl+0x63>
  801f79:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801f7e:	8d 74 24 03          	lea    0x3(%esp),%esi
  801f82:	89 f2                	mov    %esi,%edx
  801f84:	c1 ea 02             	shr    $0x2,%edx
  801f87:	83 e6 fc             	and    $0xfffffffc,%esi
  801f8a:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8f:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f96:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f9d:	00 
	va_start(vl, arg0);
  801f9e:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801fa1:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	eb 0b                	jmp    801fb5 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801faa:	83 c0 01             	add    $0x1,%eax
  801fad:	8b 39                	mov    (%ecx),%edi
  801faf:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801fb2:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801fb5:	39 d0                	cmp    %edx,%eax
  801fb7:	75 f1                	jne    801faa <spawnl+0x8f>
	return spawn(prog, argv);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	56                   	push   %esi
  801fbd:	ff 75 08             	pushl  0x8(%ebp)
  801fc0:	e8 f1 f9 ff ff       	call   8019b6 <spawn>
}
  801fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5f                   	pop    %edi
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    

00801fcd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fcd:	f3 0f 1e fb          	endbr32 
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	56                   	push   %esi
  801fd5:	53                   	push   %ebx
  801fd6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	e8 9c f1 ff ff       	call   801180 <fd2data>
  801fe4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fe6:	83 c4 08             	add    $0x8,%esp
  801fe9:	68 46 2d 80 00       	push   $0x802d46
  801fee:	53                   	push   %ebx
  801fef:	e8 25 eb ff ff       	call   800b19 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ff4:	8b 46 04             	mov    0x4(%esi),%eax
  801ff7:	2b 06                	sub    (%esi),%eax
  801ff9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802006:	00 00 00 
	stat->st_dev = &devpipe;
  802009:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  802010:	47 80 00 
	return 0;
}
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    

0080201f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80201f:	f3 0f 1e fb          	endbr32 
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	53                   	push   %ebx
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80202d:	53                   	push   %ebx
  80202e:	6a 00                	push   $0x0
  802030:	e8 b3 ef ff ff       	call   800fe8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802035:	89 1c 24             	mov    %ebx,(%esp)
  802038:	e8 43 f1 ff ff       	call   801180 <fd2data>
  80203d:	83 c4 08             	add    $0x8,%esp
  802040:	50                   	push   %eax
  802041:	6a 00                	push   $0x0
  802043:	e8 a0 ef ff ff       	call   800fe8 <sys_page_unmap>
}
  802048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <_pipeisclosed>:
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	57                   	push   %edi
  802051:	56                   	push   %esi
  802052:	53                   	push   %ebx
  802053:	83 ec 1c             	sub    $0x1c,%esp
  802056:	89 c7                	mov    %eax,%edi
  802058:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80205a:	a1 90 67 80 00       	mov    0x806790,%eax
  80205f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	57                   	push   %edi
  802066:	e8 1f 04 00 00       	call   80248a <pageref>
  80206b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80206e:	89 34 24             	mov    %esi,(%esp)
  802071:	e8 14 04 00 00       	call   80248a <pageref>
		nn = thisenv->env_runs;
  802076:	8b 15 90 67 80 00    	mov    0x806790,%edx
  80207c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	39 cb                	cmp    %ecx,%ebx
  802084:	74 1b                	je     8020a1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802086:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802089:	75 cf                	jne    80205a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80208b:	8b 42 58             	mov    0x58(%edx),%eax
  80208e:	6a 01                	push   $0x1
  802090:	50                   	push   %eax
  802091:	53                   	push   %ebx
  802092:	68 4d 2d 80 00       	push   $0x802d4d
  802097:	e8 73 e4 ff ff       	call   80050f <cprintf>
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	eb b9                	jmp    80205a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020a1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020a4:	0f 94 c0             	sete   %al
  8020a7:	0f b6 c0             	movzbl %al,%eax
}
  8020aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5e                   	pop    %esi
  8020af:	5f                   	pop    %edi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <devpipe_write>:
{
  8020b2:	f3 0f 1e fb          	endbr32 
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	57                   	push   %edi
  8020ba:	56                   	push   %esi
  8020bb:	53                   	push   %ebx
  8020bc:	83 ec 28             	sub    $0x28,%esp
  8020bf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020c2:	56                   	push   %esi
  8020c3:	e8 b8 f0 ff ff       	call   801180 <fd2data>
  8020c8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020d5:	74 4f                	je     802126 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020d7:	8b 43 04             	mov    0x4(%ebx),%eax
  8020da:	8b 0b                	mov    (%ebx),%ecx
  8020dc:	8d 51 20             	lea    0x20(%ecx),%edx
  8020df:	39 d0                	cmp    %edx,%eax
  8020e1:	72 14                	jb     8020f7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020e3:	89 da                	mov    %ebx,%edx
  8020e5:	89 f0                	mov    %esi,%eax
  8020e7:	e8 61 ff ff ff       	call   80204d <_pipeisclosed>
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	75 3b                	jne    80212b <devpipe_write+0x79>
			sys_yield();
  8020f0:	e8 43 ee ff ff       	call   800f38 <sys_yield>
  8020f5:	eb e0                	jmp    8020d7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802101:	89 c2                	mov    %eax,%edx
  802103:	c1 fa 1f             	sar    $0x1f,%edx
  802106:	89 d1                	mov    %edx,%ecx
  802108:	c1 e9 1b             	shr    $0x1b,%ecx
  80210b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80210e:	83 e2 1f             	and    $0x1f,%edx
  802111:	29 ca                	sub    %ecx,%edx
  802113:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802117:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80211b:	83 c0 01             	add    $0x1,%eax
  80211e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802121:	83 c7 01             	add    $0x1,%edi
  802124:	eb ac                	jmp    8020d2 <devpipe_write+0x20>
	return i;
  802126:	8b 45 10             	mov    0x10(%ebp),%eax
  802129:	eb 05                	jmp    802130 <devpipe_write+0x7e>
				return 0;
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802130:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <devpipe_read>:
{
  802138:	f3 0f 1e fb          	endbr32 
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	57                   	push   %edi
  802140:	56                   	push   %esi
  802141:	53                   	push   %ebx
  802142:	83 ec 18             	sub    $0x18,%esp
  802145:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802148:	57                   	push   %edi
  802149:	e8 32 f0 ff ff       	call   801180 <fd2data>
  80214e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	be 00 00 00 00       	mov    $0x0,%esi
  802158:	3b 75 10             	cmp    0x10(%ebp),%esi
  80215b:	75 14                	jne    802171 <devpipe_read+0x39>
	return i;
  80215d:	8b 45 10             	mov    0x10(%ebp),%eax
  802160:	eb 02                	jmp    802164 <devpipe_read+0x2c>
				return i;
  802162:	89 f0                	mov    %esi,%eax
}
  802164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
			sys_yield();
  80216c:	e8 c7 ed ff ff       	call   800f38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802171:	8b 03                	mov    (%ebx),%eax
  802173:	3b 43 04             	cmp    0x4(%ebx),%eax
  802176:	75 18                	jne    802190 <devpipe_read+0x58>
			if (i > 0)
  802178:	85 f6                	test   %esi,%esi
  80217a:	75 e6                	jne    802162 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80217c:	89 da                	mov    %ebx,%edx
  80217e:	89 f8                	mov    %edi,%eax
  802180:	e8 c8 fe ff ff       	call   80204d <_pipeisclosed>
  802185:	85 c0                	test   %eax,%eax
  802187:	74 e3                	je     80216c <devpipe_read+0x34>
				return 0;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	eb d4                	jmp    802164 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802190:	99                   	cltd   
  802191:	c1 ea 1b             	shr    $0x1b,%edx
  802194:	01 d0                	add    %edx,%eax
  802196:	83 e0 1f             	and    $0x1f,%eax
  802199:	29 d0                	sub    %edx,%eax
  80219b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021a6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021a9:	83 c6 01             	add    $0x1,%esi
  8021ac:	eb aa                	jmp    802158 <devpipe_read+0x20>

008021ae <pipe>:
{
  8021ae:	f3 0f 1e fb          	endbr32 
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	56                   	push   %esi
  8021b6:	53                   	push   %ebx
  8021b7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bd:	50                   	push   %eax
  8021be:	e8 d8 ef ff ff       	call   80119b <fd_alloc>
  8021c3:	89 c3                	mov    %eax,%ebx
  8021c5:	83 c4 10             	add    $0x10,%esp
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	0f 88 23 01 00 00    	js     8022f3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	68 07 04 00 00       	push   $0x407
  8021d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021db:	6a 00                	push   $0x0
  8021dd:	e8 79 ed ff ff       	call   800f5b <sys_page_alloc>
  8021e2:	89 c3                	mov    %eax,%ebx
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	0f 88 04 01 00 00    	js     8022f3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021f5:	50                   	push   %eax
  8021f6:	e8 a0 ef ff ff       	call   80119b <fd_alloc>
  8021fb:	89 c3                	mov    %eax,%ebx
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	85 c0                	test   %eax,%eax
  802202:	0f 88 db 00 00 00    	js     8022e3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 07 04 00 00       	push   $0x407
  802210:	ff 75 f0             	pushl  -0x10(%ebp)
  802213:	6a 00                	push   $0x0
  802215:	e8 41 ed ff ff       	call   800f5b <sys_page_alloc>
  80221a:	89 c3                	mov    %eax,%ebx
  80221c:	83 c4 10             	add    $0x10,%esp
  80221f:	85 c0                	test   %eax,%eax
  802221:	0f 88 bc 00 00 00    	js     8022e3 <pipe+0x135>
	va = fd2data(fd0);
  802227:	83 ec 0c             	sub    $0xc,%esp
  80222a:	ff 75 f4             	pushl  -0xc(%ebp)
  80222d:	e8 4e ef ff ff       	call   801180 <fd2data>
  802232:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802234:	83 c4 0c             	add    $0xc,%esp
  802237:	68 07 04 00 00       	push   $0x407
  80223c:	50                   	push   %eax
  80223d:	6a 00                	push   $0x0
  80223f:	e8 17 ed ff ff       	call   800f5b <sys_page_alloc>
  802244:	89 c3                	mov    %eax,%ebx
  802246:	83 c4 10             	add    $0x10,%esp
  802249:	85 c0                	test   %eax,%eax
  80224b:	0f 88 82 00 00 00    	js     8022d3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	ff 75 f0             	pushl  -0x10(%ebp)
  802257:	e8 24 ef ff ff       	call   801180 <fd2data>
  80225c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802263:	50                   	push   %eax
  802264:	6a 00                	push   $0x0
  802266:	56                   	push   %esi
  802267:	6a 00                	push   $0x0
  802269:	e8 34 ed ff ff       	call   800fa2 <sys_page_map>
  80226e:	89 c3                	mov    %eax,%ebx
  802270:	83 c4 20             	add    $0x20,%esp
  802273:	85 c0                	test   %eax,%eax
  802275:	78 4e                	js     8022c5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802277:	a1 ac 47 80 00       	mov    0x8047ac,%eax
  80227c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802284:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80228b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80228e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80229a:	83 ec 0c             	sub    $0xc,%esp
  80229d:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a0:	e8 c7 ee ff ff       	call   80116c <fd2num>
  8022a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022a8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022aa:	83 c4 04             	add    $0x4,%esp
  8022ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b0:	e8 b7 ee ff ff       	call   80116c <fd2num>
  8022b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022bb:	83 c4 10             	add    $0x10,%esp
  8022be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022c3:	eb 2e                	jmp    8022f3 <pipe+0x145>
	sys_page_unmap(0, va);
  8022c5:	83 ec 08             	sub    $0x8,%esp
  8022c8:	56                   	push   %esi
  8022c9:	6a 00                	push   $0x0
  8022cb:	e8 18 ed ff ff       	call   800fe8 <sys_page_unmap>
  8022d0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022d3:	83 ec 08             	sub    $0x8,%esp
  8022d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d9:	6a 00                	push   $0x0
  8022db:	e8 08 ed ff ff       	call   800fe8 <sys_page_unmap>
  8022e0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022e3:	83 ec 08             	sub    $0x8,%esp
  8022e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e9:	6a 00                	push   $0x0
  8022eb:	e8 f8 ec ff ff       	call   800fe8 <sys_page_unmap>
  8022f0:	83 c4 10             	add    $0x10,%esp
}
  8022f3:	89 d8                	mov    %ebx,%eax
  8022f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f8:	5b                   	pop    %ebx
  8022f9:	5e                   	pop    %esi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    

008022fc <pipeisclosed>:
{
  8022fc:	f3 0f 1e fb          	endbr32 
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802309:	50                   	push   %eax
  80230a:	ff 75 08             	pushl  0x8(%ebp)
  80230d:	e8 df ee ff ff       	call   8011f1 <fd_lookup>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	78 18                	js     802331 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802319:	83 ec 0c             	sub    $0xc,%esp
  80231c:	ff 75 f4             	pushl  -0xc(%ebp)
  80231f:	e8 5c ee ff ff       	call   801180 <fd2data>
  802324:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	e8 1f fd ff ff       	call   80204d <_pipeisclosed>
  80232e:	83 c4 10             	add    $0x10,%esp
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802333:	f3 0f 1e fb          	endbr32 
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	56                   	push   %esi
  80233b:	53                   	push   %ebx
  80233c:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80233f:	85 f6                	test   %esi,%esi
  802341:	74 13                	je     802356 <wait+0x23>
	e = &envs[ENVX(envid)];
  802343:	89 f3                	mov    %esi,%ebx
  802345:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80234b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80234e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802354:	eb 1b                	jmp    802371 <wait+0x3e>
	assert(envid != 0);
  802356:	68 65 2d 80 00       	push   $0x802d65
  80235b:	68 7f 2c 80 00       	push   $0x802c7f
  802360:	6a 09                	push   $0x9
  802362:	68 70 2d 80 00       	push   $0x802d70
  802367:	e8 bc e0 ff ff       	call   800428 <_panic>
		sys_yield();
  80236c:	e8 c7 eb ff ff       	call   800f38 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802371:	8b 43 48             	mov    0x48(%ebx),%eax
  802374:	39 f0                	cmp    %esi,%eax
  802376:	75 07                	jne    80237f <wait+0x4c>
  802378:	8b 43 54             	mov    0x54(%ebx),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	75 ed                	jne    80236c <wait+0x39>
}
  80237f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802382:	5b                   	pop    %ebx
  802383:	5e                   	pop    %esi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    

00802386 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802386:	f3 0f 1e fb          	endbr32 
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	56                   	push   %esi
  80238e:	53                   	push   %ebx
  80238f:	8b 75 08             	mov    0x8(%ebp),%esi
  802392:	8b 45 0c             	mov    0xc(%ebp),%eax
  802395:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802398:	85 c0                	test   %eax,%eax
  80239a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80239f:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8023a2:	83 ec 0c             	sub    $0xc,%esp
  8023a5:	50                   	push   %eax
  8023a6:	e8 7c ed ff ff       	call   801127 <sys_ipc_recv>
  8023ab:	83 c4 10             	add    $0x10,%esp
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	78 2b                	js     8023dd <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  8023b2:	85 f6                	test   %esi,%esi
  8023b4:	74 0a                	je     8023c0 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  8023b6:	a1 90 67 80 00       	mov    0x806790,%eax
  8023bb:	8b 40 74             	mov    0x74(%eax),%eax
  8023be:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  8023c0:	85 db                	test   %ebx,%ebx
  8023c2:	74 0a                	je     8023ce <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  8023c4:	a1 90 67 80 00       	mov    0x806790,%eax
  8023c9:	8b 40 78             	mov    0x78(%eax),%eax
  8023cc:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8023ce:	a1 90 67 80 00       	mov    0x806790,%eax
  8023d3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d9:	5b                   	pop    %ebx
  8023da:	5e                   	pop    %esi
  8023db:	5d                   	pop    %ebp
  8023dc:	c3                   	ret    
		if(from_env_store)
  8023dd:	85 f6                	test   %esi,%esi
  8023df:	74 06                	je     8023e7 <ipc_recv+0x61>
			*from_env_store=0;
  8023e1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023e7:	85 db                	test   %ebx,%ebx
  8023e9:	74 eb                	je     8023d6 <ipc_recv+0x50>
			*perm_store=0;
  8023eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023f1:	eb e3                	jmp    8023d6 <ipc_recv+0x50>

008023f3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023f3:	f3 0f 1e fb          	endbr32 
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	57                   	push   %edi
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	8b 7d 08             	mov    0x8(%ebp),%edi
  802403:	8b 75 0c             	mov    0xc(%ebp),%esi
  802406:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802409:	85 db                	test   %ebx,%ebx
  80240b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802410:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802413:	ff 75 14             	pushl  0x14(%ebp)
  802416:	53                   	push   %ebx
  802417:	56                   	push   %esi
  802418:	57                   	push   %edi
  802419:	e8 e2 ec ff ff       	call   801100 <sys_ipc_try_send>
		if(!res)
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	85 c0                	test   %eax,%eax
  802423:	74 20                	je     802445 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802425:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802428:	75 07                	jne    802431 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  80242a:	e8 09 eb ff ff       	call   800f38 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  80242f:	eb e2                	jmp    802413 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	68 7b 2d 80 00       	push   $0x802d7b
  802439:	6a 3f                	push   $0x3f
  80243b:	68 93 2d 80 00       	push   $0x802d93
  802440:	e8 e3 df ff ff       	call   800428 <_panic>
	}
}
  802445:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802448:	5b                   	pop    %ebx
  802449:	5e                   	pop    %esi
  80244a:	5f                   	pop    %edi
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    

0080244d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80244d:	f3 0f 1e fb          	endbr32 
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80245c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80245f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802465:	8b 52 50             	mov    0x50(%edx),%edx
  802468:	39 ca                	cmp    %ecx,%edx
  80246a:	74 11                	je     80247d <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80246c:	83 c0 01             	add    $0x1,%eax
  80246f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802474:	75 e6                	jne    80245c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
  80247b:	eb 0b                	jmp    802488 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80247d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802480:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802485:	8b 40 48             	mov    0x48(%eax),%eax
}
  802488:	5d                   	pop    %ebp
  802489:	c3                   	ret    

0080248a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80248a:	f3 0f 1e fb          	endbr32 
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802494:	89 c2                	mov    %eax,%edx
  802496:	c1 ea 16             	shr    $0x16,%edx
  802499:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8024a0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8024a5:	f6 c1 01             	test   $0x1,%cl
  8024a8:	74 1c                	je     8024c6 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8024aa:	c1 e8 0c             	shr    $0xc,%eax
  8024ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8024b4:	a8 01                	test   $0x1,%al
  8024b6:	74 0e                	je     8024c6 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024b8:	c1 e8 0c             	shr    $0xc,%eax
  8024bb:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8024c2:	ef 
  8024c3:	0f b7 d2             	movzwl %dx,%edx
}
  8024c6:	89 d0                	mov    %edx,%eax
  8024c8:	5d                   	pop    %ebp
  8024c9:	c3                   	ret    
  8024ca:	66 90                	xchg   %ax,%ax
  8024cc:	66 90                	xchg   %ax,%ax
  8024ce:	66 90                	xchg   %ax,%ax

008024d0 <__udivdi3>:
  8024d0:	f3 0f 1e fb          	endbr32 
  8024d4:	55                   	push   %ebp
  8024d5:	57                   	push   %edi
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	83 ec 1c             	sub    $0x1c,%esp
  8024db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024eb:	85 d2                	test   %edx,%edx
  8024ed:	75 19                	jne    802508 <__udivdi3+0x38>
  8024ef:	39 f3                	cmp    %esi,%ebx
  8024f1:	76 4d                	jbe    802540 <__udivdi3+0x70>
  8024f3:	31 ff                	xor    %edi,%edi
  8024f5:	89 e8                	mov    %ebp,%eax
  8024f7:	89 f2                	mov    %esi,%edx
  8024f9:	f7 f3                	div    %ebx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	83 c4 1c             	add    $0x1c,%esp
  802500:	5b                   	pop    %ebx
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    
  802505:	8d 76 00             	lea    0x0(%esi),%esi
  802508:	39 f2                	cmp    %esi,%edx
  80250a:	76 14                	jbe    802520 <__udivdi3+0x50>
  80250c:	31 ff                	xor    %edi,%edi
  80250e:	31 c0                	xor    %eax,%eax
  802510:	89 fa                	mov    %edi,%edx
  802512:	83 c4 1c             	add    $0x1c,%esp
  802515:	5b                   	pop    %ebx
  802516:	5e                   	pop    %esi
  802517:	5f                   	pop    %edi
  802518:	5d                   	pop    %ebp
  802519:	c3                   	ret    
  80251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802520:	0f bd fa             	bsr    %edx,%edi
  802523:	83 f7 1f             	xor    $0x1f,%edi
  802526:	75 48                	jne    802570 <__udivdi3+0xa0>
  802528:	39 f2                	cmp    %esi,%edx
  80252a:	72 06                	jb     802532 <__udivdi3+0x62>
  80252c:	31 c0                	xor    %eax,%eax
  80252e:	39 eb                	cmp    %ebp,%ebx
  802530:	77 de                	ja     802510 <__udivdi3+0x40>
  802532:	b8 01 00 00 00       	mov    $0x1,%eax
  802537:	eb d7                	jmp    802510 <__udivdi3+0x40>
  802539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802540:	89 d9                	mov    %ebx,%ecx
  802542:	85 db                	test   %ebx,%ebx
  802544:	75 0b                	jne    802551 <__udivdi3+0x81>
  802546:	b8 01 00 00 00       	mov    $0x1,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	f7 f3                	div    %ebx
  80254f:	89 c1                	mov    %eax,%ecx
  802551:	31 d2                	xor    %edx,%edx
  802553:	89 f0                	mov    %esi,%eax
  802555:	f7 f1                	div    %ecx
  802557:	89 c6                	mov    %eax,%esi
  802559:	89 e8                	mov    %ebp,%eax
  80255b:	89 f7                	mov    %esi,%edi
  80255d:	f7 f1                	div    %ecx
  80255f:	89 fa                	mov    %edi,%edx
  802561:	83 c4 1c             	add    $0x1c,%esp
  802564:	5b                   	pop    %ebx
  802565:	5e                   	pop    %esi
  802566:	5f                   	pop    %edi
  802567:	5d                   	pop    %ebp
  802568:	c3                   	ret    
  802569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802570:	89 f9                	mov    %edi,%ecx
  802572:	b8 20 00 00 00       	mov    $0x20,%eax
  802577:	29 f8                	sub    %edi,%eax
  802579:	d3 e2                	shl    %cl,%edx
  80257b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80257f:	89 c1                	mov    %eax,%ecx
  802581:	89 da                	mov    %ebx,%edx
  802583:	d3 ea                	shr    %cl,%edx
  802585:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802589:	09 d1                	or     %edx,%ecx
  80258b:	89 f2                	mov    %esi,%edx
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 f9                	mov    %edi,%ecx
  802593:	d3 e3                	shl    %cl,%ebx
  802595:	89 c1                	mov    %eax,%ecx
  802597:	d3 ea                	shr    %cl,%edx
  802599:	89 f9                	mov    %edi,%ecx
  80259b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80259f:	89 eb                	mov    %ebp,%ebx
  8025a1:	d3 e6                	shl    %cl,%esi
  8025a3:	89 c1                	mov    %eax,%ecx
  8025a5:	d3 eb                	shr    %cl,%ebx
  8025a7:	09 de                	or     %ebx,%esi
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	f7 74 24 08          	divl   0x8(%esp)
  8025af:	89 d6                	mov    %edx,%esi
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	f7 64 24 0c          	mull   0xc(%esp)
  8025b7:	39 d6                	cmp    %edx,%esi
  8025b9:	72 15                	jb     8025d0 <__udivdi3+0x100>
  8025bb:	89 f9                	mov    %edi,%ecx
  8025bd:	d3 e5                	shl    %cl,%ebp
  8025bf:	39 c5                	cmp    %eax,%ebp
  8025c1:	73 04                	jae    8025c7 <__udivdi3+0xf7>
  8025c3:	39 d6                	cmp    %edx,%esi
  8025c5:	74 09                	je     8025d0 <__udivdi3+0x100>
  8025c7:	89 d8                	mov    %ebx,%eax
  8025c9:	31 ff                	xor    %edi,%edi
  8025cb:	e9 40 ff ff ff       	jmp    802510 <__udivdi3+0x40>
  8025d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025d3:	31 ff                	xor    %edi,%edi
  8025d5:	e9 36 ff ff ff       	jmp    802510 <__udivdi3+0x40>
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <__umoddi3>:
  8025e0:	f3 0f 1e fb          	endbr32 
  8025e4:	55                   	push   %ebp
  8025e5:	57                   	push   %edi
  8025e6:	56                   	push   %esi
  8025e7:	53                   	push   %ebx
  8025e8:	83 ec 1c             	sub    $0x1c,%esp
  8025eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	75 19                	jne    802618 <__umoddi3+0x38>
  8025ff:	39 df                	cmp    %ebx,%edi
  802601:	76 5d                	jbe    802660 <__umoddi3+0x80>
  802603:	89 f0                	mov    %esi,%eax
  802605:	89 da                	mov    %ebx,%edx
  802607:	f7 f7                	div    %edi
  802609:	89 d0                	mov    %edx,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	83 c4 1c             	add    $0x1c,%esp
  802610:	5b                   	pop    %ebx
  802611:	5e                   	pop    %esi
  802612:	5f                   	pop    %edi
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    
  802615:	8d 76 00             	lea    0x0(%esi),%esi
  802618:	89 f2                	mov    %esi,%edx
  80261a:	39 d8                	cmp    %ebx,%eax
  80261c:	76 12                	jbe    802630 <__umoddi3+0x50>
  80261e:	89 f0                	mov    %esi,%eax
  802620:	89 da                	mov    %ebx,%edx
  802622:	83 c4 1c             	add    $0x1c,%esp
  802625:	5b                   	pop    %ebx
  802626:	5e                   	pop    %esi
  802627:	5f                   	pop    %edi
  802628:	5d                   	pop    %ebp
  802629:	c3                   	ret    
  80262a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802630:	0f bd e8             	bsr    %eax,%ebp
  802633:	83 f5 1f             	xor    $0x1f,%ebp
  802636:	75 50                	jne    802688 <__umoddi3+0xa8>
  802638:	39 d8                	cmp    %ebx,%eax
  80263a:	0f 82 e0 00 00 00    	jb     802720 <__umoddi3+0x140>
  802640:	89 d9                	mov    %ebx,%ecx
  802642:	39 f7                	cmp    %esi,%edi
  802644:	0f 86 d6 00 00 00    	jbe    802720 <__umoddi3+0x140>
  80264a:	89 d0                	mov    %edx,%eax
  80264c:	89 ca                	mov    %ecx,%edx
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	89 fd                	mov    %edi,%ebp
  802662:	85 ff                	test   %edi,%edi
  802664:	75 0b                	jne    802671 <__umoddi3+0x91>
  802666:	b8 01 00 00 00       	mov    $0x1,%eax
  80266b:	31 d2                	xor    %edx,%edx
  80266d:	f7 f7                	div    %edi
  80266f:	89 c5                	mov    %eax,%ebp
  802671:	89 d8                	mov    %ebx,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f5                	div    %ebp
  802677:	89 f0                	mov    %esi,%eax
  802679:	f7 f5                	div    %ebp
  80267b:	89 d0                	mov    %edx,%eax
  80267d:	31 d2                	xor    %edx,%edx
  80267f:	eb 8c                	jmp    80260d <__umoddi3+0x2d>
  802681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802688:	89 e9                	mov    %ebp,%ecx
  80268a:	ba 20 00 00 00       	mov    $0x20,%edx
  80268f:	29 ea                	sub    %ebp,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 44 24 08          	mov    %eax,0x8(%esp)
  802697:	89 d1                	mov    %edx,%ecx
  802699:	89 f8                	mov    %edi,%eax
  80269b:	d3 e8                	shr    %cl,%eax
  80269d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026a9:	09 c1                	or     %eax,%ecx
  8026ab:	89 d8                	mov    %ebx,%eax
  8026ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b1:	89 e9                	mov    %ebp,%ecx
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 d1                	mov    %edx,%ecx
  8026b7:	d3 e8                	shr    %cl,%eax
  8026b9:	89 e9                	mov    %ebp,%ecx
  8026bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026bf:	d3 e3                	shl    %cl,%ebx
  8026c1:	89 c7                	mov    %eax,%edi
  8026c3:	89 d1                	mov    %edx,%ecx
  8026c5:	89 f0                	mov    %esi,%eax
  8026c7:	d3 e8                	shr    %cl,%eax
  8026c9:	89 e9                	mov    %ebp,%ecx
  8026cb:	89 fa                	mov    %edi,%edx
  8026cd:	d3 e6                	shl    %cl,%esi
  8026cf:	09 d8                	or     %ebx,%eax
  8026d1:	f7 74 24 08          	divl   0x8(%esp)
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	89 f3                	mov    %esi,%ebx
  8026d9:	f7 64 24 0c          	mull   0xc(%esp)
  8026dd:	89 c6                	mov    %eax,%esi
  8026df:	89 d7                	mov    %edx,%edi
  8026e1:	39 d1                	cmp    %edx,%ecx
  8026e3:	72 06                	jb     8026eb <__umoddi3+0x10b>
  8026e5:	75 10                	jne    8026f7 <__umoddi3+0x117>
  8026e7:	39 c3                	cmp    %eax,%ebx
  8026e9:	73 0c                	jae    8026f7 <__umoddi3+0x117>
  8026eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026f3:	89 d7                	mov    %edx,%edi
  8026f5:	89 c6                	mov    %eax,%esi
  8026f7:	89 ca                	mov    %ecx,%edx
  8026f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fe:	29 f3                	sub    %esi,%ebx
  802700:	19 fa                	sbb    %edi,%edx
  802702:	89 d0                	mov    %edx,%eax
  802704:	d3 e0                	shl    %cl,%eax
  802706:	89 e9                	mov    %ebp,%ecx
  802708:	d3 eb                	shr    %cl,%ebx
  80270a:	d3 ea                	shr    %cl,%edx
  80270c:	09 d8                	or     %ebx,%eax
  80270e:	83 c4 1c             	add    $0x1c,%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    
  802716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80271d:	8d 76 00             	lea    0x0(%esi),%esi
  802720:	29 fe                	sub    %edi,%esi
  802722:	19 c3                	sbb    %eax,%ebx
  802724:	89 f2                	mov    %esi,%edx
  802726:	89 d9                	mov    %ebx,%ecx
  802728:	e9 1d ff ff ff       	jmp    80264a <__umoddi3+0x6a>
