
obj/user/sh.debug：     文件格式 elf32-i386


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
  80002c:	e8 0c 0a 00 00       	call   800a3d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 0c             	sub    $0xc,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800043:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800046:	85 db                	test   %ebx,%ebx
  800048:	74 1a                	je     800064 <_gettoken+0x31>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80004a:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800051:	7f 31                	jg     800084 <_gettoken+0x51>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800053:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800059:	8b 45 10             	mov    0x10(%ebp),%eax
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  800062:	eb 3a                	jmp    80009e <_gettoken+0x6b>
		return 0;
  800064:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800069:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800070:	7e 59                	jle    8000cb <_gettoken+0x98>
			cprintf("GETTOKEN NULL\n");
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	68 e0 34 80 00       	push   $0x8034e0
  80007a:	e8 0d 0b 00 00       	call   800b8c <cprintf>
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	eb 47                	jmp    8000cb <_gettoken+0x98>
		cprintf("GETTOKEN: %s\n", s);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	53                   	push   %ebx
  800088:	68 ef 34 80 00       	push   $0x8034ef
  80008d:	e8 fa 0a 00 00       	call   800b8c <cprintf>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	eb bc                	jmp    800053 <_gettoken+0x20>
		*s++ = 0;
  800097:	83 c3 01             	add    $0x1,%ebx
  80009a:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	0f be 03             	movsbl (%ebx),%eax
  8000a4:	50                   	push   %eax
  8000a5:	68 fd 34 80 00       	push   $0x8034fd
  8000aa:	e8 00 13 00 00       	call   8013af <strchr>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	85 c0                	test   %eax,%eax
  8000b4:	75 e1                	jne    800097 <_gettoken+0x64>
	if (*s == 0) {
  8000b6:	0f b6 03             	movzbl (%ebx),%eax
  8000b9:	84 c0                	test   %al,%al
  8000bb:	75 2a                	jne    8000e7 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000bd:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000c2:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c9:	7f 0a                	jg     8000d5 <_gettoken+0xa2>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000cb:	89 f0                	mov    %esi,%eax
  8000cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
			cprintf("EOL\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 02 35 80 00       	push   $0x803502
  8000dd:	e8 aa 0a 00 00       	call   800b8c <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb e4                	jmp    8000cb <_gettoken+0x98>
	if (strchr(SYMBOLS, *s)) {
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	0f be c0             	movsbl %al,%eax
  8000ed:	50                   	push   %eax
  8000ee:	68 13 35 80 00       	push   $0x803513
  8000f3:	e8 b7 12 00 00       	call   8013af <strchr>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	74 2c                	je     80012b <_gettoken+0xf8>
		t = *s;
  8000ff:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  800102:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800104:	c6 03 00             	movb   $0x0,(%ebx)
  800107:	83 c3 01             	add    $0x1,%ebx
  80010a:	8b 45 10             	mov    0x10(%ebp),%eax
  80010d:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010f:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800116:	7e b3                	jle    8000cb <_gettoken+0x98>
			cprintf("TOK %c\n", t);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	68 07 35 80 00       	push   $0x803507
  800121:	e8 66 0a 00 00       	call   800b8c <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	eb a0                	jmp    8000cb <_gettoken+0x98>
	*p1 = s;
  80012b:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012d:	eb 03                	jmp    800132 <_gettoken+0xff>
		s++;
  80012f:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800132:	0f b6 03             	movzbl (%ebx),%eax
  800135:	84 c0                	test   %al,%al
  800137:	74 18                	je     800151 <_gettoken+0x11e>
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	0f be c0             	movsbl %al,%eax
  80013f:	50                   	push   %eax
  800140:	68 0f 35 80 00       	push   $0x80350f
  800145:	e8 65 12 00 00       	call   8013af <strchr>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	85 c0                	test   %eax,%eax
  80014f:	74 de                	je     80012f <_gettoken+0xfc>
	*p2 = s;
  800151:	8b 45 10             	mov    0x10(%ebp),%eax
  800154:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800156:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  80015b:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800162:	0f 8e 63 ff ff ff    	jle    8000cb <_gettoken+0x98>
		t = **p2;
  800168:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  80016b:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 37                	pushl  (%edi)
  800173:	68 1b 35 80 00       	push   $0x80351b
  800178:	e8 0f 0a 00 00       	call   800b8c <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 38 ff ff ff       	jmp    8000cb <_gettoken+0x98>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a0:	85 c0                	test   %eax,%eax
  8001a2:	74 22                	je     8001c6 <gettoken+0x33>
		nc = _gettoken(s, &np1, &np2);
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 0c 50 80 00       	push   $0x80500c
  8001ac:	68 10 50 80 00       	push   $0x805010
  8001b1:	50                   	push   %eax
  8001b2:	e8 7c fe ff ff       	call   800033 <_gettoken>
  8001b7:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
	c = nc;
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001d0:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 0c 50 80 00       	push   $0x80500c
  8001e3:	68 10 50 80 00       	push   $0x805010
  8001e8:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001ee:	e8 40 fe ff ff       	call   800033 <_gettoken>
  8001f3:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f8:	a1 04 50 80 00       	mov    0x805004,%eax
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	eb c2                	jmp    8001c4 <gettoken+0x31>

00800202 <runcmd>:
{
  800202:	f3 0f 1e fb          	endbr32 
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800212:	6a 00                	push   $0x0
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	e8 77 ff ff ff       	call   800193 <gettoken>
  80021c:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  80021f:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800222:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	6a 00                	push   $0x0
  80022d:	e8 61 ff ff ff       	call   800193 <gettoken>
  800232:	89 c3                	mov    %eax,%ebx
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	83 f8 3e             	cmp    $0x3e,%eax
  80023a:	0f 84 31 01 00 00    	je     800371 <runcmd+0x16f>
  800240:	7f 49                	jg     80028b <runcmd+0x89>
  800242:	85 c0                	test   %eax,%eax
  800244:	0f 84 1b 02 00 00    	je     800465 <runcmd+0x263>
  80024a:	83 f8 3c             	cmp    $0x3c,%eax
  80024d:	0f 85 ee 02 00 00    	jne    800541 <runcmd+0x33f>
			if (gettoken(0, &t) != 'w') {
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	6a 00                	push   $0x0
  800259:	e8 35 ff ff ff       	call   800193 <gettoken>
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	83 f8 77             	cmp    $0x77,%eax
  800264:	0f 85 ba 00 00 00    	jne    800324 <runcmd+0x122>
			if((fd=open(t,O_RDONLY))<0){
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	ff 75 a4             	pushl  -0x5c(%ebp)
  800272:	e8 82 22 00 00       	call   8024f9 <open>
  800277:	89 c3                	mov    %eax,%ebx
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	85 c0                	test   %eax,%eax
  80027e:	0f 88 ba 00 00 00    	js     80033e <runcmd+0x13c>
			if(fd!=0){
  800284:	74 a1                	je     800227 <runcmd+0x25>
  800286:	e9 cb 00 00 00       	jmp    800356 <runcmd+0x154>
		switch ((c = gettoken(0, &t))) {
  80028b:	83 f8 77             	cmp    $0x77,%eax
  80028e:	74 69                	je     8002f9 <runcmd+0xf7>
  800290:	83 f8 7c             	cmp    $0x7c,%eax
  800293:	0f 85 a8 02 00 00    	jne    800541 <runcmd+0x33f>
			if ((r = pipe(p)) < 0) {
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	e8 1a 2c 00 00       	call   802ec2 <pipe>
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	85 c0                	test   %eax,%eax
  8002ad:	0f 88 40 01 00 00    	js     8003f3 <runcmd+0x1f1>
			if (debug)
  8002b3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002ba:	0f 85 4e 01 00 00    	jne    80040e <runcmd+0x20c>
			if ((r = fork()) < 0) {
  8002c0:	e8 fb 16 00 00       	call   8019c0 <fork>
  8002c5:	89 c3                	mov    %eax,%ebx
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	0f 88 60 01 00 00    	js     80042f <runcmd+0x22d>
			if (r == 0) {
  8002cf:	0f 85 70 01 00 00    	jne    800445 <runcmd+0x243>
				if (p[0] != 0) {
  8002d5:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	0f 85 1c 02 00 00    	jne    8004ff <runcmd+0x2fd>
				close(p[1]);
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002ec:	e8 29 1c 00 00       	call   801f1a <close>
				goto again;
  8002f1:	83 c4 10             	add    $0x10,%esp
  8002f4:	e9 29 ff ff ff       	jmp    800222 <runcmd+0x20>
			if (argc == MAXARGS) {
  8002f9:	83 ff 10             	cmp    $0x10,%edi
  8002fc:	74 0f                	je     80030d <runcmd+0x10b>
			argv[argc++] = t;
  8002fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800301:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800305:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  800308:	e9 1a ff ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("too many arguments\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 25 35 80 00       	push   $0x803525
  800315:	e8 72 08 00 00       	call   800b8c <cprintf>
				exit();
  80031a:	e8 68 07 00 00       	call   800a87 <exit>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	eb da                	jmp    8002fe <runcmd+0xfc>
				cprintf("syntax error: < not followed by word\n");
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 7c 36 80 00       	push   $0x80367c
  80032c:	e8 5b 08 00 00       	call   800b8c <cprintf>
				exit();
  800331:	e8 51 07 00 00       	call   800a87 <exit>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	e9 2c ff ff ff       	jmp    80026a <runcmd+0x68>
				cprintf("open %s for read Failed!\n",t);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	ff 75 a4             	pushl  -0x5c(%ebp)
  800344:	68 39 35 80 00       	push   $0x803539
  800349:	e8 3e 08 00 00       	call   800b8c <cprintf>
				exit();
  80034e:	e8 34 07 00 00       	call   800a87 <exit>
  800353:	83 c4 10             	add    $0x10,%esp
				dup(fd,0);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	6a 00                	push   $0x0
  80035b:	53                   	push   %ebx
  80035c:	e8 13 1c 00 00       	call   801f74 <dup>
				close(fd);
  800361:	89 1c 24             	mov    %ebx,(%esp)
  800364:	e8 b1 1b 00 00       	call   801f1a <close>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	e9 b6 fe ff ff       	jmp    800227 <runcmd+0x25>
			if (gettoken(0, &t) != 'w') {
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	56                   	push   %esi
  800375:	6a 00                	push   $0x0
  800377:	e8 17 fe ff ff       	call   800193 <gettoken>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	83 f8 77             	cmp    $0x77,%eax
  800382:	75 24                	jne    8003a8 <runcmd+0x1a6>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	68 01 03 00 00       	push   $0x301
  80038c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80038f:	e8 65 21 00 00       	call   8024f9 <open>
  800394:	89 c3                	mov    %eax,%ebx
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 22                	js     8003bf <runcmd+0x1bd>
			if (fd != 1) {
  80039d:	83 f8 01             	cmp    $0x1,%eax
  8003a0:	0f 84 81 fe ff ff    	je     800227 <runcmd+0x25>
  8003a6:	eb 30                	jmp    8003d8 <runcmd+0x1d6>
				cprintf("syntax error: > not followed by word\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 a4 36 80 00       	push   $0x8036a4
  8003b0:	e8 d7 07 00 00       	call   800b8c <cprintf>
				exit();
  8003b5:	e8 cd 06 00 00       	call   800a87 <exit>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb c5                	jmp    800384 <runcmd+0x182>
				cprintf("open %s for write: %e", t, fd);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	50                   	push   %eax
  8003c3:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003c6:	68 53 35 80 00       	push   $0x803553
  8003cb:	e8 bc 07 00 00       	call   800b8c <cprintf>
				exit();
  8003d0:	e8 b2 06 00 00       	call   800a87 <exit>
  8003d5:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	6a 01                	push   $0x1
  8003dd:	53                   	push   %ebx
  8003de:	e8 91 1b 00 00       	call   801f74 <dup>
				close(fd);
  8003e3:	89 1c 24             	mov    %ebx,(%esp)
  8003e6:	e8 2f 1b 00 00       	call   801f1a <close>
  8003eb:	83 c4 10             	add    $0x10,%esp
  8003ee:	e9 34 fe ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("pipe: %e", r);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 69 35 80 00       	push   $0x803569
  8003fc:	e8 8b 07 00 00       	call   800b8c <cprintf>
				exit();
  800401:	e8 81 06 00 00       	call   800a87 <exit>
  800406:	83 c4 10             	add    $0x10,%esp
  800409:	e9 a5 fe ff ff       	jmp    8002b3 <runcmd+0xb1>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80040e:	83 ec 04             	sub    $0x4,%esp
  800411:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800417:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041d:	68 72 35 80 00       	push   $0x803572
  800422:	e8 65 07 00 00       	call   800b8c <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	e9 91 fe ff ff       	jmp    8002c0 <runcmd+0xbe>
				cprintf("fork: %e", r);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 7f 35 80 00       	push   $0x80357f
  800438:	e8 4f 07 00 00       	call   800b8c <cprintf>
				exit();
  80043d:	e8 45 06 00 00       	call   800a87 <exit>
  800442:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800445:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044b:	83 f8 01             	cmp    $0x1,%eax
  80044e:	0f 85 cc 00 00 00    	jne    800520 <runcmd+0x31e>
				close(p[0]);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80045d:	e8 b8 1a 00 00       	call   801f1a <close>
				goto runit;
  800462:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  800465:	85 ff                	test   %edi,%edi
  800467:	0f 84 e6 00 00 00    	je     800553 <runcmd+0x351>
	if (argv[0][0] != '/') {
  80046d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800470:	80 38 2f             	cmpb   $0x2f,(%eax)
  800473:	0f 85 f5 00 00 00    	jne    80056e <runcmd+0x36c>
	argv[argc] = 0;
  800479:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  800480:	00 
	if (debug) {
  800481:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800488:	0f 85 08 01 00 00    	jne    800596 <runcmd+0x394>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800494:	50                   	push   %eax
  800495:	ff 75 a8             	pushl  -0x58(%ebp)
  800498:	e8 2d 22 00 00       	call   8026ca <spawn>
  80049d:	89 c6                	mov    %eax,%esi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	85 c0                	test   %eax,%eax
  8004a4:	0f 88 3a 01 00 00    	js     8005e4 <runcmd+0x3e2>
	close_all();
  8004aa:	e8 9c 1a 00 00       	call   801f4b <close_all>
		if (debug)
  8004af:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004b6:	0f 85 75 01 00 00    	jne    800631 <runcmd+0x42f>
		wait(r);
  8004bc:	83 ec 0c             	sub    $0xc,%esp
  8004bf:	56                   	push   %esi
  8004c0:	e8 82 2b 00 00       	call   803047 <wait>
		if (debug)
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004cf:	0f 85 7b 01 00 00    	jne    800650 <runcmd+0x44e>
	if (pipe_child) {
  8004d5:	85 db                	test   %ebx,%ebx
  8004d7:	74 19                	je     8004f2 <runcmd+0x2f0>
		wait(pipe_child);
  8004d9:	83 ec 0c             	sub    $0xc,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	e8 65 2b 00 00       	call   803047 <wait>
		if (debug)
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004ec:	0f 85 79 01 00 00    	jne    80066b <runcmd+0x469>
	exit();
  8004f2:	e8 90 05 00 00       	call   800a87 <exit>
}
  8004f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fa:	5b                   	pop    %ebx
  8004fb:	5e                   	pop    %esi
  8004fc:	5f                   	pop    %edi
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    
					dup(p[0], 0);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	6a 00                	push   $0x0
  800504:	50                   	push   %eax
  800505:	e8 6a 1a 00 00       	call   801f74 <dup>
					close(p[0]);
  80050a:	83 c4 04             	add    $0x4,%esp
  80050d:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800513:	e8 02 1a 00 00       	call   801f1a <close>
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	e9 c3 fd ff ff       	jmp    8002e3 <runcmd+0xe1>
					dup(p[1], 1);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	6a 01                	push   $0x1
  800525:	50                   	push   %eax
  800526:	e8 49 1a 00 00       	call   801f74 <dup>
					close(p[1]);
  80052b:	83 c4 04             	add    $0x4,%esp
  80052e:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800534:	e8 e1 19 00 00       	call   801f1a <close>
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	e9 13 ff ff ff       	jmp    800454 <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  800541:	53                   	push   %ebx
  800542:	68 88 35 80 00       	push   $0x803588
  800547:	6a 78                	push   $0x78
  800549:	68 a4 35 80 00       	push   $0x8035a4
  80054e:	e8 52 05 00 00       	call   800aa5 <_panic>
		if (debug)
  800553:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80055a:	74 9b                	je     8004f7 <runcmd+0x2f5>
			cprintf("EMPTY COMMAND\n");
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	68 ae 35 80 00       	push   $0x8035ae
  800564:	e8 23 06 00 00       	call   800b8c <cprintf>
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	eb 89                	jmp    8004f7 <runcmd+0x2f5>
		argv0buf[0] = '/';
  80056e:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	50                   	push   %eax
  800579:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  80057f:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800585:	50                   	push   %eax
  800586:	e8 ff 0c 00 00       	call   80128a <strcpy>
		argv[0] = argv0buf;
  80058b:	89 75 a8             	mov    %esi,-0x58(%ebp)
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	e9 e3 fe ff ff       	jmp    800479 <runcmd+0x277>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800596:	a1 24 54 80 00       	mov    0x805424,%eax
  80059b:	8b 40 48             	mov    0x48(%eax),%eax
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	50                   	push   %eax
  8005a2:	68 bd 35 80 00       	push   $0x8035bd
  8005a7:	e8 e0 05 00 00       	call   800b8c <cprintf>
  8005ac:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	eb 11                	jmp    8005c5 <runcmd+0x3c3>
			cprintf(" %s", argv[i]);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	50                   	push   %eax
  8005b8:	68 45 36 80 00       	push   $0x803645
  8005bd:	e8 ca 05 00 00       	call   800b8c <cprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c8:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	75 e5                	jne    8005b4 <runcmd+0x3b2>
		cprintf("\n");
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	68 00 35 80 00       	push   $0x803500
  8005d7:	e8 b0 05 00 00       	call   800b8c <cprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	e9 aa fe ff ff       	jmp    80048e <runcmd+0x28c>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	50                   	push   %eax
  8005e8:	ff 75 a8             	pushl  -0x58(%ebp)
  8005eb:	68 cb 35 80 00       	push   $0x8035cb
  8005f0:	e8 97 05 00 00       	call   800b8c <cprintf>
	close_all();
  8005f5:	e8 51 19 00 00       	call   801f4b <close_all>
  8005fa:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005fd:	85 db                	test   %ebx,%ebx
  8005ff:	0f 84 ed fe ff ff    	je     8004f2 <runcmd+0x2f0>
		if (debug)
  800605:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80060c:	0f 84 c7 fe ff ff    	je     8004d9 <runcmd+0x2d7>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800612:	a1 24 54 80 00       	mov    0x805424,%eax
  800617:	8b 40 48             	mov    0x48(%eax),%eax
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	53                   	push   %ebx
  80061e:	50                   	push   %eax
  80061f:	68 04 36 80 00       	push   $0x803604
  800624:	e8 63 05 00 00       	call   800b8c <cprintf>
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	e9 a8 fe ff ff       	jmp    8004d9 <runcmd+0x2d7>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800631:	a1 24 54 80 00       	mov    0x805424,%eax
  800636:	8b 40 48             	mov    0x48(%eax),%eax
  800639:	56                   	push   %esi
  80063a:	ff 75 a8             	pushl  -0x58(%ebp)
  80063d:	50                   	push   %eax
  80063e:	68 d9 35 80 00       	push   $0x8035d9
  800643:	e8 44 05 00 00       	call   800b8c <cprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	e9 6c fe ff ff       	jmp    8004bc <runcmd+0x2ba>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800650:	a1 24 54 80 00       	mov    0x805424,%eax
  800655:	8b 40 48             	mov    0x48(%eax),%eax
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	50                   	push   %eax
  80065c:	68 ee 35 80 00       	push   $0x8035ee
  800661:	e8 26 05 00 00       	call   800b8c <cprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	eb 92                	jmp    8005fd <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80066b:	a1 24 54 80 00       	mov    0x805424,%eax
  800670:	8b 40 48             	mov    0x48(%eax),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	50                   	push   %eax
  800677:	68 ee 35 80 00       	push   $0x8035ee
  80067c:	e8 0b 05 00 00       	call   800b8c <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	e9 69 fe ff ff       	jmp    8004f2 <runcmd+0x2f0>

00800689 <usage>:


void
usage(void)
{
  800689:	f3 0f 1e fb          	endbr32 
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800693:	68 cc 36 80 00       	push   $0x8036cc
  800698:	e8 ef 04 00 00       	call   800b8c <cprintf>
	exit();
  80069d:	e8 e5 03 00 00       	call   800a87 <exit>
}
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    

008006a7 <umain>:

void
umain(int argc, char **argv)
{
  8006a7:	f3 0f 1e fb          	endbr32 
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	57                   	push   %edi
  8006af:	56                   	push   %esi
  8006b0:	53                   	push   %ebx
  8006b1:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006b4:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006b7:	50                   	push   %eax
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	8d 45 08             	lea    0x8(%ebp),%eax
  8006be:	50                   	push   %eax
  8006bf:	e8 39 15 00 00       	call   801bfd <argstart>
	while ((r = argnext(&args)) >= 0)
  8006c4:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006c7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006ce:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006d3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006d6:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006db:	eb 10                	jmp    8006ed <umain+0x46>
			debug++;
  8006dd:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006e4:	eb 07                	jmp    8006ed <umain+0x46>
			interactive = 1;
  8006e6:	89 f7                	mov    %esi,%edi
  8006e8:	eb 03                	jmp    8006ed <umain+0x46>
		switch (r) {
  8006ea:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006ed:	83 ec 0c             	sub    $0xc,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	e8 3b 15 00 00       	call   801c31 <argnext>
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	85 c0                	test   %eax,%eax
  8006fb:	78 16                	js     800713 <umain+0x6c>
		switch (r) {
  8006fd:	83 f8 69             	cmp    $0x69,%eax
  800700:	74 e4                	je     8006e6 <umain+0x3f>
  800702:	83 f8 78             	cmp    $0x78,%eax
  800705:	74 e3                	je     8006ea <umain+0x43>
  800707:	83 f8 64             	cmp    $0x64,%eax
  80070a:	74 d1                	je     8006dd <umain+0x36>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  80070c:	e8 78 ff ff ff       	call   800689 <usage>
  800711:	eb da                	jmp    8006ed <umain+0x46>
		}

	if (argc > 2)
  800713:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800717:	7f 1f                	jg     800738 <umain+0x91>
		usage();
	if (argc == 2) {
  800719:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80071d:	74 20                	je     80073f <umain+0x98>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  80071f:	83 ff 3f             	cmp    $0x3f,%edi
  800722:	74 75                	je     800799 <umain+0xf2>
  800724:	85 ff                	test   %edi,%edi
  800726:	bf 49 36 80 00       	mov    $0x803649,%edi
  80072b:	b8 00 00 00 00       	mov    $0x0,%eax
  800730:	0f 44 f8             	cmove  %eax,%edi
  800733:	e9 06 01 00 00       	jmp    80083e <umain+0x197>
		usage();
  800738:	e8 4c ff ff ff       	call   800689 <usage>
  80073d:	eb da                	jmp    800719 <umain+0x72>
		close(0);
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	6a 00                	push   $0x0
  800744:	e8 d1 17 00 00       	call   801f1a <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800749:	83 c4 08             	add    $0x8,%esp
  80074c:	6a 00                	push   $0x0
  80074e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800751:	ff 70 04             	pushl  0x4(%eax)
  800754:	e8 a0 1d 00 00       	call   8024f9 <open>
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 c0                	test   %eax,%eax
  80075e:	78 1b                	js     80077b <umain+0xd4>
		assert(r == 0);
  800760:	74 bd                	je     80071f <umain+0x78>
  800762:	68 2d 36 80 00       	push   $0x80362d
  800767:	68 34 36 80 00       	push   $0x803634
  80076c:	68 29 01 00 00       	push   $0x129
  800771:	68 a4 35 80 00       	push   $0x8035a4
  800776:	e8 2a 03 00 00       	call   800aa5 <_panic>
			panic("open %s: %e", argv[1], r);
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	50                   	push   %eax
  80077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800782:	ff 70 04             	pushl  0x4(%eax)
  800785:	68 21 36 80 00       	push   $0x803621
  80078a:	68 28 01 00 00       	push   $0x128
  80078f:	68 a4 35 80 00       	push   $0x8035a4
  800794:	e8 0c 03 00 00       	call   800aa5 <_panic>
		interactive = iscons(0);
  800799:	83 ec 0c             	sub    $0xc,%esp
  80079c:	6a 00                	push   $0x0
  80079e:	e8 14 02 00 00       	call   8009b7 <iscons>
  8007a3:	89 c7                	mov    %eax,%edi
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	e9 77 ff ff ff       	jmp    800724 <umain+0x7d>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  8007ad:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007b4:	75 0a                	jne    8007c0 <umain+0x119>
				cprintf("EXITING\n");
			exit();	// end of file
  8007b6:	e8 cc 02 00 00       	call   800a87 <exit>
  8007bb:	e9 94 00 00 00       	jmp    800854 <umain+0x1ad>
				cprintf("EXITING\n");
  8007c0:	83 ec 0c             	sub    $0xc,%esp
  8007c3:	68 4c 36 80 00       	push   $0x80364c
  8007c8:	e8 bf 03 00 00       	call   800b8c <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	eb e4                	jmp    8007b6 <umain+0x10f>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	68 55 36 80 00       	push   $0x803655
  8007db:	e8 ac 03 00 00       	call   800b8c <cprintf>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	eb 7c                	jmp    800861 <umain+0x1ba>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	53                   	push   %ebx
  8007e9:	68 5f 36 80 00       	push   $0x80365f
  8007ee:	e8 bd 1e 00 00       	call   8026b0 <printf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	eb 78                	jmp    800870 <umain+0x1c9>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007f8:	83 ec 0c             	sub    $0xc,%esp
  8007fb:	68 65 36 80 00       	push   $0x803665
  800800:	e8 87 03 00 00       	call   800b8c <cprintf>
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	eb 73                	jmp    80087d <umain+0x1d6>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  80080a:	50                   	push   %eax
  80080b:	68 7f 35 80 00       	push   $0x80357f
  800810:	68 40 01 00 00       	push   $0x140
  800815:	68 a4 35 80 00       	push   $0x8035a4
  80081a:	e8 86 02 00 00       	call   800aa5 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	50                   	push   %eax
  800823:	68 72 36 80 00       	push   $0x803672
  800828:	e8 5f 03 00 00       	call   800b8c <cprintf>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	eb 5f                	jmp    800891 <umain+0x1ea>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800832:	83 ec 0c             	sub    $0xc,%esp
  800835:	56                   	push   %esi
  800836:	e8 0c 28 00 00       	call   803047 <wait>
  80083b:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80083e:	83 ec 0c             	sub    $0xc,%esp
  800841:	57                   	push   %edi
  800842:	e8 0c 09 00 00       	call   801153 <readline>
  800847:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	85 c0                	test   %eax,%eax
  80084e:	0f 84 59 ff ff ff    	je     8007ad <umain+0x106>
		if (debug)
  800854:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80085b:	0f 85 71 ff ff ff    	jne    8007d2 <umain+0x12b>
		if (buf[0] == '#')
  800861:	80 3b 23             	cmpb   $0x23,(%ebx)
  800864:	74 d8                	je     80083e <umain+0x197>
		if (echocmds)
  800866:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80086a:	0f 85 75 ff ff ff    	jne    8007e5 <umain+0x13e>
		if (debug)
  800870:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800877:	0f 85 7b ff ff ff    	jne    8007f8 <umain+0x151>
		if ((r = fork()) < 0)
  80087d:	e8 3e 11 00 00       	call   8019c0 <fork>
  800882:	89 c6                	mov    %eax,%esi
  800884:	85 c0                	test   %eax,%eax
  800886:	78 82                	js     80080a <umain+0x163>
		if (debug)
  800888:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80088f:	75 8e                	jne    80081f <umain+0x178>
		if (r == 0) {
  800891:	85 f6                	test   %esi,%esi
  800893:	75 9d                	jne    800832 <umain+0x18b>
			runcmd(buf);
  800895:	83 ec 0c             	sub    $0xc,%esp
  800898:	53                   	push   %ebx
  800899:	e8 64 f9 ff ff       	call   800202 <runcmd>
			exit();
  80089e:	e8 e4 01 00 00       	call   800a87 <exit>
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	eb 96                	jmp    80083e <umain+0x197>

008008a8 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8008a8:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8008ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b1:	c3                   	ret    

008008b2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008b2:	f3 0f 1e fb          	endbr32 
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008bc:	68 ed 36 80 00       	push   $0x8036ed
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	e8 c1 09 00 00       	call   80128a <strcpy>
	return 0;
}
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <devcons_write>:
{
  8008d0:	f3 0f 1e fb          	endbr32 
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	57                   	push   %edi
  8008d8:	56                   	push   %esi
  8008d9:	53                   	push   %ebx
  8008da:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008e0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008e5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008eb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008ee:	73 31                	jae    800921 <devcons_write+0x51>
		m = n - tot;
  8008f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008f3:	29 f3                	sub    %esi,%ebx
  8008f5:	83 fb 7f             	cmp    $0x7f,%ebx
  8008f8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008fd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	53                   	push   %ebx
  800904:	89 f0                	mov    %esi,%eax
  800906:	03 45 0c             	add    0xc(%ebp),%eax
  800909:	50                   	push   %eax
  80090a:	57                   	push   %edi
  80090b:	e8 30 0b 00 00       	call   801440 <memmove>
		sys_cputs(buf, m);
  800910:	83 c4 08             	add    $0x8,%esp
  800913:	53                   	push   %ebx
  800914:	57                   	push   %edi
  800915:	e8 e2 0c 00 00       	call   8015fc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80091a:	01 de                	add    %ebx,%esi
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	eb ca                	jmp    8008eb <devcons_write+0x1b>
}
  800921:	89 f0                	mov    %esi,%eax
  800923:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800926:	5b                   	pop    %ebx
  800927:	5e                   	pop    %esi
  800928:	5f                   	pop    %edi
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <devcons_read>:
{
  80092b:	f3 0f 1e fb          	endbr32 
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80093a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80093e:	74 21                	je     800961 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800940:	e8 d9 0c 00 00       	call   80161e <sys_cgetc>
  800945:	85 c0                	test   %eax,%eax
  800947:	75 07                	jne    800950 <devcons_read+0x25>
		sys_yield();
  800949:	e8 5b 0d 00 00       	call   8016a9 <sys_yield>
  80094e:	eb f0                	jmp    800940 <devcons_read+0x15>
	if (c < 0)
  800950:	78 0f                	js     800961 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800952:	83 f8 04             	cmp    $0x4,%eax
  800955:	74 0c                	je     800963 <devcons_read+0x38>
	*(char*)vbuf = c;
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	88 02                	mov    %al,(%edx)
	return 1;
  80095c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800961:	c9                   	leave  
  800962:	c3                   	ret    
		return 0;
  800963:	b8 00 00 00 00       	mov    $0x0,%eax
  800968:	eb f7                	jmp    800961 <devcons_read+0x36>

0080096a <cputchar>:
{
  80096a:	f3 0f 1e fb          	endbr32 
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80097a:	6a 01                	push   $0x1
  80097c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80097f:	50                   	push   %eax
  800980:	e8 77 0c 00 00       	call   8015fc <sys_cputs>
}
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <getchar>:
{
  80098a:	f3 0f 1e fb          	endbr32 
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800994:	6a 01                	push   $0x1
  800996:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	6a 00                	push   $0x0
  80099c:	e8 c3 16 00 00       	call   802064 <read>
	if (r < 0)
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	78 06                	js     8009ae <getchar+0x24>
	if (r < 1)
  8009a8:	74 06                	je     8009b0 <getchar+0x26>
	return c;
  8009aa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    
		return -E_EOF;
  8009b0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8009b5:	eb f7                	jmp    8009ae <getchar+0x24>

008009b7 <iscons>:
{
  8009b7:	f3 0f 1e fb          	endbr32 
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c4:	50                   	push   %eax
  8009c5:	ff 75 08             	pushl  0x8(%ebp)
  8009c8:	e8 14 14 00 00       	call   801de1 <fd_lookup>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	78 11                	js     8009e5 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8009d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d7:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009dd:	39 10                	cmp    %edx,(%eax)
  8009df:	0f 94 c0             	sete   %al
  8009e2:	0f b6 c0             	movzbl %al,%eax
}
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <opencons>:
{
  8009e7:	f3 0f 1e fb          	endbr32 
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 91 13 00 00       	call   801d8b <fd_alloc>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	85 c0                	test   %eax,%eax
  8009ff:	78 3a                	js     800a3b <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800a01:	83 ec 04             	sub    $0x4,%esp
  800a04:	68 07 04 00 00       	push   $0x407
  800a09:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 b9 0c 00 00       	call   8016cc <sys_page_alloc>
  800a13:	83 c4 10             	add    $0x10,%esp
  800a16:	85 c0                	test   %eax,%eax
  800a18:	78 21                	js     800a3b <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1d:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800a23:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a28:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a2f:	83 ec 0c             	sub    $0xc,%esp
  800a32:	50                   	push   %eax
  800a33:	e8 24 13 00 00       	call   801d5c <fd2num>
  800a38:	83 c4 10             	add    $0x10,%esp
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a3d:	f3 0f 1e fb          	endbr32 
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	56                   	push   %esi
  800a45:	53                   	push   %ebx
  800a46:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a49:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a4c:	e8 35 0c 00 00       	call   801686 <sys_getenvid>
  800a51:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a56:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a59:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a5e:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	7e 07                	jle    800a6e <libmain+0x31>
		binaryname = argv[0];
  800a67:	8b 06                	mov    (%esi),%eax
  800a69:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	56                   	push   %esi
  800a72:	53                   	push   %ebx
  800a73:	e8 2f fc ff ff       	call   8006a7 <umain>

	// exit gracefully
	exit();
  800a78:	e8 0a 00 00 00       	call   800a87 <exit>
}
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a87:	f3 0f 1e fb          	endbr32 
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a91:	e8 b5 14 00 00       	call   801f4b <close_all>
	sys_env_destroy(0);
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	6a 00                	push   $0x0
  800a9b:	e8 a1 0b 00 00       	call   801641 <sys_env_destroy>
}
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800aa5:	f3 0f 1e fb          	endbr32 
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800aae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ab1:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800ab7:	e8 ca 0b 00 00       	call   801686 <sys_getenvid>
  800abc:	83 ec 0c             	sub    $0xc,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	56                   	push   %esi
  800ac6:	50                   	push   %eax
  800ac7:	68 04 37 80 00       	push   $0x803704
  800acc:	e8 bb 00 00 00       	call   800b8c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ad1:	83 c4 18             	add    $0x18,%esp
  800ad4:	53                   	push   %ebx
  800ad5:	ff 75 10             	pushl  0x10(%ebp)
  800ad8:	e8 5a 00 00 00       	call   800b37 <vcprintf>
	cprintf("\n");
  800add:	c7 04 24 00 35 80 00 	movl   $0x803500,(%esp)
  800ae4:	e8 a3 00 00 00       	call   800b8c <cprintf>
  800ae9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aec:	cc                   	int3   
  800aed:	eb fd                	jmp    800aec <_panic+0x47>

00800aef <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800aef:	f3 0f 1e fb          	endbr32 
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	53                   	push   %ebx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800afd:	8b 13                	mov    (%ebx),%edx
  800aff:	8d 42 01             	lea    0x1(%edx),%eax
  800b02:	89 03                	mov    %eax,(%ebx)
  800b04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b07:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b0b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b10:	74 09                	je     800b1b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b12:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	68 ff 00 00 00       	push   $0xff
  800b23:	8d 43 08             	lea    0x8(%ebx),%eax
  800b26:	50                   	push   %eax
  800b27:	e8 d0 0a 00 00       	call   8015fc <sys_cputs>
		b->idx = 0;
  800b2c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	eb db                	jmp    800b12 <putch+0x23>

00800b37 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b37:	f3 0f 1e fb          	endbr32 
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b44:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4b:	00 00 00 
	b.cnt = 0;
  800b4e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b55:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	ff 75 08             	pushl  0x8(%ebp)
  800b5e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b64:	50                   	push   %eax
  800b65:	68 ef 0a 80 00       	push   $0x800aef
  800b6a:	e8 20 01 00 00       	call   800c8f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b6f:	83 c4 08             	add    $0x8,%esp
  800b72:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b78:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	e8 78 0a 00 00       	call   8015fc <sys_cputs>

	return b.cnt;
}
  800b84:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b8c:	f3 0f 1e fb          	endbr32 
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b96:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b99:	50                   	push   %eax
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 95 ff ff ff       	call   800b37 <vcprintf>
	va_end(ap);

	return cnt;
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
  800baa:	83 ec 1c             	sub    $0x1c,%esp
  800bad:	89 c7                	mov    %eax,%edi
  800baf:	89 d6                	mov    %edx,%esi
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800bd1:	39 c2                	cmp    %eax,%edx
  800bd3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800bd6:	72 3e                	jb     800c16 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	83 ec 0c             	sub    $0xc,%esp
  800bdb:	ff 75 18             	pushl  0x18(%ebp)
  800bde:	83 eb 01             	sub    $0x1,%ebx
  800be1:	53                   	push   %ebx
  800be2:	50                   	push   %eax
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be9:	ff 75 e0             	pushl  -0x20(%ebp)
  800bec:	ff 75 dc             	pushl  -0x24(%ebp)
  800bef:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf2:	e8 89 26 00 00       	call   803280 <__udivdi3>
  800bf7:	83 c4 18             	add    $0x18,%esp
  800bfa:	52                   	push   %edx
  800bfb:	50                   	push   %eax
  800bfc:	89 f2                	mov    %esi,%edx
  800bfe:	89 f8                	mov    %edi,%eax
  800c00:	e8 9f ff ff ff       	call   800ba4 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
  800c08:	eb 13                	jmp    800c1d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	56                   	push   %esi
  800c0e:	ff 75 18             	pushl  0x18(%ebp)
  800c11:	ff d7                	call   *%edi
  800c13:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800c16:	83 eb 01             	sub    $0x1,%ebx
  800c19:	85 db                	test   %ebx,%ebx
  800c1b:	7f ed                	jg     800c0a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	56                   	push   %esi
  800c21:	83 ec 04             	sub    $0x4,%esp
  800c24:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c27:	ff 75 e0             	pushl  -0x20(%ebp)
  800c2a:	ff 75 dc             	pushl  -0x24(%ebp)
  800c2d:	ff 75 d8             	pushl  -0x28(%ebp)
  800c30:	e8 5b 27 00 00       	call   803390 <__umoddi3>
  800c35:	83 c4 14             	add    $0x14,%esp
  800c38:	0f be 80 27 37 80 00 	movsbl 0x803727(%eax),%eax
  800c3f:	50                   	push   %eax
  800c40:	ff d7                	call   *%edi
}
  800c42:	83 c4 10             	add    $0x10,%esp
  800c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	f3 0f 1e fb          	endbr32 
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c57:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5b:	8b 10                	mov    (%eax),%edx
  800c5d:	3b 50 04             	cmp    0x4(%eax),%edx
  800c60:	73 0a                	jae    800c6c <sprintputch+0x1f>
		*b->buf++ = ch;
  800c62:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c65:	89 08                	mov    %ecx,(%eax)
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	88 02                	mov    %al,(%edx)
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <printfmt>:
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c78:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c7b:	50                   	push   %eax
  800c7c:	ff 75 10             	pushl  0x10(%ebp)
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 05 00 00 00       	call   800c8f <vprintfmt>
}
  800c8a:	83 c4 10             	add    $0x10,%esp
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <vprintfmt>:
{
  800c8f:	f3 0f 1e fb          	endbr32 
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 3c             	sub    $0x3c,%esp
  800c9c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ca2:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ca5:	e9 8e 03 00 00       	jmp    801038 <vprintfmt+0x3a9>
		padc = ' ';
  800caa:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800cae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800cb5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800cbc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cc3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cc8:	8d 47 01             	lea    0x1(%edi),%eax
  800ccb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cce:	0f b6 17             	movzbl (%edi),%edx
  800cd1:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cd4:	3c 55                	cmp    $0x55,%al
  800cd6:	0f 87 df 03 00 00    	ja     8010bb <vprintfmt+0x42c>
  800cdc:	0f b6 c0             	movzbl %al,%eax
  800cdf:	3e ff 24 85 60 38 80 	notrack jmp *0x803860(,%eax,4)
  800ce6:	00 
  800ce7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800cea:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800cee:	eb d8                	jmp    800cc8 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800cf0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800cf3:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800cf7:	eb cf                	jmp    800cc8 <vprintfmt+0x39>
  800cf9:	0f b6 d2             	movzbl %dl,%edx
  800cfc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
  800d04:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800d07:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d0a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d0e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d11:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800d14:	83 f9 09             	cmp    $0x9,%ecx
  800d17:	77 55                	ja     800d6e <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800d19:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d1c:	eb e9                	jmp    800d07 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	8d 40 04             	lea    0x4(%eax),%eax
  800d2c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d36:	79 90                	jns    800cc8 <vprintfmt+0x39>
				width = precision, precision = -1;
  800d38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d3e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d45:	eb 81                	jmp    800cc8 <vprintfmt+0x39>
  800d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d51:	0f 49 d0             	cmovns %eax,%edx
  800d54:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d5a:	e9 69 ff ff ff       	jmp    800cc8 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800d5f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d62:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d69:	e9 5a ff ff ff       	jmp    800cc8 <vprintfmt+0x39>
  800d6e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d71:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d74:	eb bc                	jmp    800d32 <vprintfmt+0xa3>
			lflag++;
  800d76:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d79:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d7c:	e9 47 ff ff ff       	jmp    800cc8 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800d81:	8b 45 14             	mov    0x14(%ebp),%eax
  800d84:	8d 78 04             	lea    0x4(%eax),%edi
  800d87:	83 ec 08             	sub    $0x8,%esp
  800d8a:	53                   	push   %ebx
  800d8b:	ff 30                	pushl  (%eax)
  800d8d:	ff d6                	call   *%esi
			break;
  800d8f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d92:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d95:	e9 9b 02 00 00       	jmp    801035 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	8d 78 04             	lea    0x4(%eax),%edi
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	99                   	cltd   
  800da3:	31 d0                	xor    %edx,%eax
  800da5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800da7:	83 f8 0f             	cmp    $0xf,%eax
  800daa:	7f 23                	jg     800dcf <vprintfmt+0x140>
  800dac:	8b 14 85 c0 39 80 00 	mov    0x8039c0(,%eax,4),%edx
  800db3:	85 d2                	test   %edx,%edx
  800db5:	74 18                	je     800dcf <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800db7:	52                   	push   %edx
  800db8:	68 46 36 80 00       	push   $0x803646
  800dbd:	53                   	push   %ebx
  800dbe:	56                   	push   %esi
  800dbf:	e8 aa fe ff ff       	call   800c6e <printfmt>
  800dc4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dc7:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dca:	e9 66 02 00 00       	jmp    801035 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800dcf:	50                   	push   %eax
  800dd0:	68 3f 37 80 00       	push   $0x80373f
  800dd5:	53                   	push   %ebx
  800dd6:	56                   	push   %esi
  800dd7:	e8 92 fe ff ff       	call   800c6e <printfmt>
  800ddc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ddf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800de2:	e9 4e 02 00 00       	jmp    801035 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	83 c0 04             	add    $0x4,%eax
  800ded:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800df5:	85 d2                	test   %edx,%edx
  800df7:	b8 38 37 80 00       	mov    $0x803738,%eax
  800dfc:	0f 45 c2             	cmovne %edx,%eax
  800dff:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800e02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e06:	7e 06                	jle    800e0e <vprintfmt+0x17f>
  800e08:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800e0c:	75 0d                	jne    800e1b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e11:	89 c7                	mov    %eax,%edi
  800e13:	03 45 e0             	add    -0x20(%ebp),%eax
  800e16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e19:	eb 55                	jmp    800e70 <vprintfmt+0x1e1>
  800e1b:	83 ec 08             	sub    $0x8,%esp
  800e1e:	ff 75 d8             	pushl  -0x28(%ebp)
  800e21:	ff 75 cc             	pushl  -0x34(%ebp)
  800e24:	e8 3a 04 00 00       	call   801263 <strnlen>
  800e29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800e31:	83 c4 10             	add    $0x10,%esp
  800e34:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800e36:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800e3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e3d:	85 ff                	test   %edi,%edi
  800e3f:	7e 11                	jle    800e52 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	53                   	push   %ebx
  800e45:	ff 75 e0             	pushl  -0x20(%ebp)
  800e48:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4a:	83 ef 01             	sub    $0x1,%edi
  800e4d:	83 c4 10             	add    $0x10,%esp
  800e50:	eb eb                	jmp    800e3d <vprintfmt+0x1ae>
  800e52:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800e55:	85 d2                	test   %edx,%edx
  800e57:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5c:	0f 49 c2             	cmovns %edx,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e64:	eb a8                	jmp    800e0e <vprintfmt+0x17f>
					putch(ch, putdat);
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	53                   	push   %ebx
  800e6a:	52                   	push   %edx
  800e6b:	ff d6                	call   *%esi
  800e6d:	83 c4 10             	add    $0x10,%esp
  800e70:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e73:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e75:	83 c7 01             	add    $0x1,%edi
  800e78:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e7c:	0f be d0             	movsbl %al,%edx
  800e7f:	85 d2                	test   %edx,%edx
  800e81:	74 4b                	je     800ece <vprintfmt+0x23f>
  800e83:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e87:	78 06                	js     800e8f <vprintfmt+0x200>
  800e89:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e8d:	78 1e                	js     800ead <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e93:	74 d1                	je     800e66 <vprintfmt+0x1d7>
  800e95:	0f be c0             	movsbl %al,%eax
  800e98:	83 e8 20             	sub    $0x20,%eax
  800e9b:	83 f8 5e             	cmp    $0x5e,%eax
  800e9e:	76 c6                	jbe    800e66 <vprintfmt+0x1d7>
					putch('?', putdat);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	53                   	push   %ebx
  800ea4:	6a 3f                	push   $0x3f
  800ea6:	ff d6                	call   *%esi
  800ea8:	83 c4 10             	add    $0x10,%esp
  800eab:	eb c3                	jmp    800e70 <vprintfmt+0x1e1>
  800ead:	89 cf                	mov    %ecx,%edi
  800eaf:	eb 0e                	jmp    800ebf <vprintfmt+0x230>
				putch(' ', putdat);
  800eb1:	83 ec 08             	sub    $0x8,%esp
  800eb4:	53                   	push   %ebx
  800eb5:	6a 20                	push   $0x20
  800eb7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800eb9:	83 ef 01             	sub    $0x1,%edi
  800ebc:	83 c4 10             	add    $0x10,%esp
  800ebf:	85 ff                	test   %edi,%edi
  800ec1:	7f ee                	jg     800eb1 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800ec3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ec6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec9:	e9 67 01 00 00       	jmp    801035 <vprintfmt+0x3a6>
  800ece:	89 cf                	mov    %ecx,%edi
  800ed0:	eb ed                	jmp    800ebf <vprintfmt+0x230>
	if (lflag >= 2)
  800ed2:	83 f9 01             	cmp    $0x1,%ecx
  800ed5:	7f 1b                	jg     800ef2 <vprintfmt+0x263>
	else if (lflag)
  800ed7:	85 c9                	test   %ecx,%ecx
  800ed9:	74 63                	je     800f3e <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800edb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ede:	8b 00                	mov    (%eax),%eax
  800ee0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ee3:	99                   	cltd   
  800ee4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eea:	8d 40 04             	lea    0x4(%eax),%eax
  800eed:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef0:	eb 17                	jmp    800f09 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef5:	8b 50 04             	mov    0x4(%eax),%edx
  800ef8:	8b 00                	mov    (%eax),%eax
  800efa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800efd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f00:	8b 45 14             	mov    0x14(%ebp),%eax
  800f03:	8d 40 08             	lea    0x8(%eax),%eax
  800f06:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800f09:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f0c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800f0f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800f14:	85 c9                	test   %ecx,%ecx
  800f16:	0f 89 ff 00 00 00    	jns    80101b <vprintfmt+0x38c>
				putch('-', putdat);
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	53                   	push   %ebx
  800f20:	6a 2d                	push   $0x2d
  800f22:	ff d6                	call   *%esi
				num = -(long long) num;
  800f24:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f27:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f2a:	f7 da                	neg    %edx
  800f2c:	83 d1 00             	adc    $0x0,%ecx
  800f2f:	f7 d9                	neg    %ecx
  800f31:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f34:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f39:	e9 dd 00 00 00       	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	8b 00                	mov    (%eax),%eax
  800f43:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f46:	99                   	cltd   
  800f47:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4d:	8d 40 04             	lea    0x4(%eax),%eax
  800f50:	89 45 14             	mov    %eax,0x14(%ebp)
  800f53:	eb b4                	jmp    800f09 <vprintfmt+0x27a>
	if (lflag >= 2)
  800f55:	83 f9 01             	cmp    $0x1,%ecx
  800f58:	7f 1e                	jg     800f78 <vprintfmt+0x2e9>
	else if (lflag)
  800f5a:	85 c9                	test   %ecx,%ecx
  800f5c:	74 32                	je     800f90 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800f5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f61:	8b 10                	mov    (%eax),%edx
  800f63:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f68:	8d 40 04             	lea    0x4(%eax),%eax
  800f6b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f6e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800f73:	e9 a3 00 00 00       	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800f78:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7b:	8b 10                	mov    (%eax),%edx
  800f7d:	8b 48 04             	mov    0x4(%eax),%ecx
  800f80:	8d 40 08             	lea    0x8(%eax),%eax
  800f83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f86:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800f8b:	e9 8b 00 00 00       	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800f90:	8b 45 14             	mov    0x14(%ebp),%eax
  800f93:	8b 10                	mov    (%eax),%edx
  800f95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9a:	8d 40 04             	lea    0x4(%eax),%eax
  800f9d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800fa5:	eb 74                	jmp    80101b <vprintfmt+0x38c>
	if (lflag >= 2)
  800fa7:	83 f9 01             	cmp    $0x1,%ecx
  800faa:	7f 1b                	jg     800fc7 <vprintfmt+0x338>
	else if (lflag)
  800fac:	85 c9                	test   %ecx,%ecx
  800fae:	74 2c                	je     800fdc <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	8b 10                	mov    (%eax),%edx
  800fb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fba:	8d 40 04             	lea    0x4(%eax),%eax
  800fbd:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800fc0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800fc5:	eb 54                	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800fc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fca:	8b 10                	mov    (%eax),%edx
  800fcc:	8b 48 04             	mov    0x4(%eax),%ecx
  800fcf:	8d 40 08             	lea    0x8(%eax),%eax
  800fd2:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800fd5:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800fda:	eb 3f                	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800fdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdf:	8b 10                	mov    (%eax),%edx
  800fe1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe6:	8d 40 04             	lea    0x4(%eax),%eax
  800fe9:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  800fec:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800ff1:	eb 28                	jmp    80101b <vprintfmt+0x38c>
			putch('0', putdat);
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	53                   	push   %ebx
  800ff7:	6a 30                	push   $0x30
  800ff9:	ff d6                	call   *%esi
			putch('x', putdat);
  800ffb:	83 c4 08             	add    $0x8,%esp
  800ffe:	53                   	push   %ebx
  800fff:	6a 78                	push   $0x78
  801001:	ff d6                	call   *%esi
			num = (unsigned long long)
  801003:	8b 45 14             	mov    0x14(%ebp),%eax
  801006:	8b 10                	mov    (%eax),%edx
  801008:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80100d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801010:	8d 40 04             	lea    0x4(%eax),%eax
  801013:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801016:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801022:	57                   	push   %edi
  801023:	ff 75 e0             	pushl  -0x20(%ebp)
  801026:	50                   	push   %eax
  801027:	51                   	push   %ecx
  801028:	52                   	push   %edx
  801029:	89 da                	mov    %ebx,%edx
  80102b:	89 f0                	mov    %esi,%eax
  80102d:	e8 72 fb ff ff       	call   800ba4 <printnum>
			break;
  801032:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801035:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801038:	83 c7 01             	add    $0x1,%edi
  80103b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80103f:	83 f8 25             	cmp    $0x25,%eax
  801042:	0f 84 62 fc ff ff    	je     800caa <vprintfmt+0x1b>
			if (ch == '\0')
  801048:	85 c0                	test   %eax,%eax
  80104a:	0f 84 8b 00 00 00    	je     8010db <vprintfmt+0x44c>
			putch(ch, putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	53                   	push   %ebx
  801054:	50                   	push   %eax
  801055:	ff d6                	call   *%esi
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	eb dc                	jmp    801038 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80105c:	83 f9 01             	cmp    $0x1,%ecx
  80105f:	7f 1b                	jg     80107c <vprintfmt+0x3ed>
	else if (lflag)
  801061:	85 c9                	test   %ecx,%ecx
  801063:	74 2c                	je     801091 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801065:	8b 45 14             	mov    0x14(%ebp),%eax
  801068:	8b 10                	mov    (%eax),%edx
  80106a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106f:	8d 40 04             	lea    0x4(%eax),%eax
  801072:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801075:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80107a:	eb 9f                	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80107c:	8b 45 14             	mov    0x14(%ebp),%eax
  80107f:	8b 10                	mov    (%eax),%edx
  801081:	8b 48 04             	mov    0x4(%eax),%ecx
  801084:	8d 40 08             	lea    0x8(%eax),%eax
  801087:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80108a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80108f:	eb 8a                	jmp    80101b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801091:	8b 45 14             	mov    0x14(%ebp),%eax
  801094:	8b 10                	mov    (%eax),%edx
  801096:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109b:	8d 40 04             	lea    0x4(%eax),%eax
  80109e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010a1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8010a6:	e9 70 ff ff ff       	jmp    80101b <vprintfmt+0x38c>
			putch(ch, putdat);
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	53                   	push   %ebx
  8010af:	6a 25                	push   $0x25
  8010b1:	ff d6                	call   *%esi
			break;
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	e9 7a ff ff ff       	jmp    801035 <vprintfmt+0x3a6>
			putch('%', putdat);
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	53                   	push   %ebx
  8010bf:	6a 25                	push   $0x25
  8010c1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	89 f8                	mov    %edi,%eax
  8010c8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010cc:	74 05                	je     8010d3 <vprintfmt+0x444>
  8010ce:	83 e8 01             	sub    $0x1,%eax
  8010d1:	eb f5                	jmp    8010c8 <vprintfmt+0x439>
  8010d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d6:	e9 5a ff ff ff       	jmp    801035 <vprintfmt+0x3a6>
}
  8010db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5f                   	pop    %edi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e3:	f3 0f 1e fb          	endbr32 
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 18             	sub    $0x18,%esp
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801104:	85 c0                	test   %eax,%eax
  801106:	74 26                	je     80112e <vsnprintf+0x4b>
  801108:	85 d2                	test   %edx,%edx
  80110a:	7e 22                	jle    80112e <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80110c:	ff 75 14             	pushl  0x14(%ebp)
  80110f:	ff 75 10             	pushl  0x10(%ebp)
  801112:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801115:	50                   	push   %eax
  801116:	68 4d 0c 80 00       	push   $0x800c4d
  80111b:	e8 6f fb ff ff       	call   800c8f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801123:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801129:	83 c4 10             	add    $0x10,%esp
}
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    
		return -E_INVAL;
  80112e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801133:	eb f7                	jmp    80112c <vsnprintf+0x49>

00801135 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801135:	f3 0f 1e fb          	endbr32 
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80113f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801142:	50                   	push   %eax
  801143:	ff 75 10             	pushl  0x10(%ebp)
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	e8 92 ff ff ff       	call   8010e3 <vsnprintf>
	va_end(ap);

	return rc;
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801153:	f3 0f 1e fb          	endbr32 
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	57                   	push   %edi
  80115b:	56                   	push   %esi
  80115c:	53                   	push   %ebx
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801163:	85 c0                	test   %eax,%eax
  801165:	74 13                	je     80117a <readline+0x27>
		fprintf(1, "%s", prompt);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	50                   	push   %eax
  80116b:	68 46 36 80 00       	push   $0x803646
  801170:	6a 01                	push   $0x1
  801172:	e8 1e 15 00 00       	call   802695 <fprintf>
  801177:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80117a:	83 ec 0c             	sub    $0xc,%esp
  80117d:	6a 00                	push   $0x0
  80117f:	e8 33 f8 ff ff       	call   8009b7 <iscons>
  801184:	89 c7                	mov    %eax,%edi
  801186:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801189:	be 00 00 00 00       	mov    $0x0,%esi
  80118e:	eb 57                	jmp    8011e7 <readline+0x94>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801190:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801195:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801198:	75 08                	jne    8011a2 <readline+0x4f>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  80119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5f                   	pop    %edi
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	53                   	push   %ebx
  8011a6:	68 1f 3a 80 00       	push   $0x803a1f
  8011ab:	e8 dc f9 ff ff       	call   800b8c <cprintf>
  8011b0:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8011b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b8:	eb e0                	jmp    80119a <readline+0x47>
			if (echoing)
  8011ba:	85 ff                	test   %edi,%edi
  8011bc:	75 05                	jne    8011c3 <readline+0x70>
			i--;
  8011be:	83 ee 01             	sub    $0x1,%esi
  8011c1:	eb 24                	jmp    8011e7 <readline+0x94>
				cputchar('\b');
  8011c3:	83 ec 0c             	sub    $0xc,%esp
  8011c6:	6a 08                	push   $0x8
  8011c8:	e8 9d f7 ff ff       	call   80096a <cputchar>
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	eb ec                	jmp    8011be <readline+0x6b>
				cputchar(c);
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	53                   	push   %ebx
  8011d6:	e8 8f f7 ff ff       	call   80096a <cputchar>
  8011db:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011de:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  8011e4:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8011e7:	e8 9e f7 ff ff       	call   80098a <getchar>
  8011ec:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 9e                	js     801190 <readline+0x3d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011f2:	83 f8 08             	cmp    $0x8,%eax
  8011f5:	0f 94 c2             	sete   %dl
  8011f8:	83 f8 7f             	cmp    $0x7f,%eax
  8011fb:	0f 94 c0             	sete   %al
  8011fe:	08 c2                	or     %al,%dl
  801200:	74 04                	je     801206 <readline+0xb3>
  801202:	85 f6                	test   %esi,%esi
  801204:	7f b4                	jg     8011ba <readline+0x67>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801206:	83 fb 1f             	cmp    $0x1f,%ebx
  801209:	7e 0e                	jle    801219 <readline+0xc6>
  80120b:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801211:	7f 06                	jg     801219 <readline+0xc6>
			if (echoing)
  801213:	85 ff                	test   %edi,%edi
  801215:	74 c7                	je     8011de <readline+0x8b>
  801217:	eb b9                	jmp    8011d2 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  801219:	83 fb 0a             	cmp    $0xa,%ebx
  80121c:	74 05                	je     801223 <readline+0xd0>
  80121e:	83 fb 0d             	cmp    $0xd,%ebx
  801221:	75 c4                	jne    8011e7 <readline+0x94>
			if (echoing)
  801223:	85 ff                	test   %edi,%edi
  801225:	75 11                	jne    801238 <readline+0xe5>
			buf[i] = 0;
  801227:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  80122e:	b8 20 50 80 00       	mov    $0x805020,%eax
  801233:	e9 62 ff ff ff       	jmp    80119a <readline+0x47>
				cputchar('\n');
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	6a 0a                	push   $0xa
  80123d:	e8 28 f7 ff ff       	call   80096a <cputchar>
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	eb e0                	jmp    801227 <readline+0xd4>

00801247 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801247:	f3 0f 1e fb          	endbr32 
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80125a:	74 05                	je     801261 <strlen+0x1a>
		n++;
  80125c:	83 c0 01             	add    $0x1,%eax
  80125f:	eb f5                	jmp    801256 <strlen+0xf>
	return n;
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801263:	f3 0f 1e fb          	endbr32 
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	39 d0                	cmp    %edx,%eax
  801277:	74 0d                	je     801286 <strnlen+0x23>
  801279:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80127d:	74 05                	je     801284 <strnlen+0x21>
		n++;
  80127f:	83 c0 01             	add    $0x1,%eax
  801282:	eb f1                	jmp    801275 <strnlen+0x12>
  801284:	89 c2                	mov    %eax,%edx
	return n;
}
  801286:	89 d0                	mov    %edx,%eax
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80128a:	f3 0f 1e fb          	endbr32 
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	53                   	push   %ebx
  801292:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8012a1:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8012a4:	83 c0 01             	add    $0x1,%eax
  8012a7:	84 d2                	test   %dl,%dl
  8012a9:	75 f2                	jne    80129d <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8012ab:	89 c8                	mov    %ecx,%eax
  8012ad:	5b                   	pop    %ebx
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012b0:	f3 0f 1e fb          	endbr32 
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 10             	sub    $0x10,%esp
  8012bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012be:	53                   	push   %ebx
  8012bf:	e8 83 ff ff ff       	call   801247 <strlen>
  8012c4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	01 d8                	add    %ebx,%eax
  8012cc:	50                   	push   %eax
  8012cd:	e8 b8 ff ff ff       	call   80128a <strcpy>
	return dst;
}
  8012d2:	89 d8                	mov    %ebx,%eax
  8012d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012d9:	f3 0f 1e fb          	endbr32 
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	56                   	push   %esi
  8012e1:	53                   	push   %ebx
  8012e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e8:	89 f3                	mov    %esi,%ebx
  8012ea:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ed:	89 f0                	mov    %esi,%eax
  8012ef:	39 d8                	cmp    %ebx,%eax
  8012f1:	74 11                	je     801304 <strncpy+0x2b>
		*dst++ = *src;
  8012f3:	83 c0 01             	add    $0x1,%eax
  8012f6:	0f b6 0a             	movzbl (%edx),%ecx
  8012f9:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012fc:	80 f9 01             	cmp    $0x1,%cl
  8012ff:	83 da ff             	sbb    $0xffffffff,%edx
  801302:	eb eb                	jmp    8012ef <strncpy+0x16>
	}
	return ret;
}
  801304:	89 f0                	mov    %esi,%eax
  801306:	5b                   	pop    %ebx
  801307:	5e                   	pop    %esi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80130a:	f3 0f 1e fb          	endbr32 
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	56                   	push   %esi
  801312:	53                   	push   %ebx
  801313:	8b 75 08             	mov    0x8(%ebp),%esi
  801316:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801319:	8b 55 10             	mov    0x10(%ebp),%edx
  80131c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80131e:	85 d2                	test   %edx,%edx
  801320:	74 21                	je     801343 <strlcpy+0x39>
  801322:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801326:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801328:	39 c2                	cmp    %eax,%edx
  80132a:	74 14                	je     801340 <strlcpy+0x36>
  80132c:	0f b6 19             	movzbl (%ecx),%ebx
  80132f:	84 db                	test   %bl,%bl
  801331:	74 0b                	je     80133e <strlcpy+0x34>
			*dst++ = *src++;
  801333:	83 c1 01             	add    $0x1,%ecx
  801336:	83 c2 01             	add    $0x1,%edx
  801339:	88 5a ff             	mov    %bl,-0x1(%edx)
  80133c:	eb ea                	jmp    801328 <strlcpy+0x1e>
  80133e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801340:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801343:	29 f0                	sub    %esi,%eax
}
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801349:	f3 0f 1e fb          	endbr32 
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801353:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801356:	0f b6 01             	movzbl (%ecx),%eax
  801359:	84 c0                	test   %al,%al
  80135b:	74 0c                	je     801369 <strcmp+0x20>
  80135d:	3a 02                	cmp    (%edx),%al
  80135f:	75 08                	jne    801369 <strcmp+0x20>
		p++, q++;
  801361:	83 c1 01             	add    $0x1,%ecx
  801364:	83 c2 01             	add    $0x1,%edx
  801367:	eb ed                	jmp    801356 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801369:	0f b6 c0             	movzbl %al,%eax
  80136c:	0f b6 12             	movzbl (%edx),%edx
  80136f:	29 d0                	sub    %edx,%eax
}
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801373:	f3 0f 1e fb          	endbr32 
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	53                   	push   %ebx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801381:	89 c3                	mov    %eax,%ebx
  801383:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801386:	eb 06                	jmp    80138e <strncmp+0x1b>
		n--, p++, q++;
  801388:	83 c0 01             	add    $0x1,%eax
  80138b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80138e:	39 d8                	cmp    %ebx,%eax
  801390:	74 16                	je     8013a8 <strncmp+0x35>
  801392:	0f b6 08             	movzbl (%eax),%ecx
  801395:	84 c9                	test   %cl,%cl
  801397:	74 04                	je     80139d <strncmp+0x2a>
  801399:	3a 0a                	cmp    (%edx),%cl
  80139b:	74 eb                	je     801388 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80139d:	0f b6 00             	movzbl (%eax),%eax
  8013a0:	0f b6 12             	movzbl (%edx),%edx
  8013a3:	29 d0                	sub    %edx,%eax
}
  8013a5:	5b                   	pop    %ebx
  8013a6:	5d                   	pop    %ebp
  8013a7:	c3                   	ret    
		return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ad:	eb f6                	jmp    8013a5 <strncmp+0x32>

008013af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013af:	f3 0f 1e fb          	endbr32 
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013bd:	0f b6 10             	movzbl (%eax),%edx
  8013c0:	84 d2                	test   %dl,%dl
  8013c2:	74 09                	je     8013cd <strchr+0x1e>
		if (*s == c)
  8013c4:	38 ca                	cmp    %cl,%dl
  8013c6:	74 0a                	je     8013d2 <strchr+0x23>
	for (; *s; s++)
  8013c8:	83 c0 01             	add    $0x1,%eax
  8013cb:	eb f0                	jmp    8013bd <strchr+0xe>
			return (char *) s;
	return 0;
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013d4:	f3 0f 1e fb          	endbr32 
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013e2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8013e5:	38 ca                	cmp    %cl,%dl
  8013e7:	74 09                	je     8013f2 <strfind+0x1e>
  8013e9:	84 d2                	test   %dl,%dl
  8013eb:	74 05                	je     8013f2 <strfind+0x1e>
	for (; *s; s++)
  8013ed:	83 c0 01             	add    $0x1,%eax
  8013f0:	eb f0                	jmp    8013e2 <strfind+0xe>
			break;
	return (char *) s;
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013f4:	f3 0f 1e fb          	endbr32 
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	57                   	push   %edi
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801401:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801404:	85 c9                	test   %ecx,%ecx
  801406:	74 31                	je     801439 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801408:	89 f8                	mov    %edi,%eax
  80140a:	09 c8                	or     %ecx,%eax
  80140c:	a8 03                	test   $0x3,%al
  80140e:	75 23                	jne    801433 <memset+0x3f>
		c &= 0xFF;
  801410:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801414:	89 d3                	mov    %edx,%ebx
  801416:	c1 e3 08             	shl    $0x8,%ebx
  801419:	89 d0                	mov    %edx,%eax
  80141b:	c1 e0 18             	shl    $0x18,%eax
  80141e:	89 d6                	mov    %edx,%esi
  801420:	c1 e6 10             	shl    $0x10,%esi
  801423:	09 f0                	or     %esi,%eax
  801425:	09 c2                	or     %eax,%edx
  801427:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801429:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80142c:	89 d0                	mov    %edx,%eax
  80142e:	fc                   	cld    
  80142f:	f3 ab                	rep stos %eax,%es:(%edi)
  801431:	eb 06                	jmp    801439 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	fc                   	cld    
  801437:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801439:	89 f8                	mov    %edi,%eax
  80143b:	5b                   	pop    %ebx
  80143c:	5e                   	pop    %esi
  80143d:	5f                   	pop    %edi
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801440:	f3 0f 1e fb          	endbr32 
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	57                   	push   %edi
  801448:	56                   	push   %esi
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80144f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801452:	39 c6                	cmp    %eax,%esi
  801454:	73 32                	jae    801488 <memmove+0x48>
  801456:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801459:	39 c2                	cmp    %eax,%edx
  80145b:	76 2b                	jbe    801488 <memmove+0x48>
		s += n;
		d += n;
  80145d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801460:	89 fe                	mov    %edi,%esi
  801462:	09 ce                	or     %ecx,%esi
  801464:	09 d6                	or     %edx,%esi
  801466:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80146c:	75 0e                	jne    80147c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80146e:	83 ef 04             	sub    $0x4,%edi
  801471:	8d 72 fc             	lea    -0x4(%edx),%esi
  801474:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801477:	fd                   	std    
  801478:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80147a:	eb 09                	jmp    801485 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80147c:	83 ef 01             	sub    $0x1,%edi
  80147f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801482:	fd                   	std    
  801483:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801485:	fc                   	cld    
  801486:	eb 1a                	jmp    8014a2 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	09 ca                	or     %ecx,%edx
  80148c:	09 f2                	or     %esi,%edx
  80148e:	f6 c2 03             	test   $0x3,%dl
  801491:	75 0a                	jne    80149d <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801493:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801496:	89 c7                	mov    %eax,%edi
  801498:	fc                   	cld    
  801499:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80149b:	eb 05                	jmp    8014a2 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80149d:	89 c7                	mov    %eax,%edi
  80149f:	fc                   	cld    
  8014a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014a2:	5e                   	pop    %esi
  8014a3:	5f                   	pop    %edi
  8014a4:	5d                   	pop    %ebp
  8014a5:	c3                   	ret    

008014a6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a6:	f3 0f 1e fb          	endbr32 
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014b0:	ff 75 10             	pushl  0x10(%ebp)
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	ff 75 08             	pushl  0x8(%ebp)
  8014b9:	e8 82 ff ff ff       	call   801440 <memmove>
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c0:	f3 0f 1e fb          	endbr32 
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cf:	89 c6                	mov    %eax,%esi
  8014d1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014d4:	39 f0                	cmp    %esi,%eax
  8014d6:	74 1c                	je     8014f4 <memcmp+0x34>
		if (*s1 != *s2)
  8014d8:	0f b6 08             	movzbl (%eax),%ecx
  8014db:	0f b6 1a             	movzbl (%edx),%ebx
  8014de:	38 d9                	cmp    %bl,%cl
  8014e0:	75 08                	jne    8014ea <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8014e2:	83 c0 01             	add    $0x1,%eax
  8014e5:	83 c2 01             	add    $0x1,%edx
  8014e8:	eb ea                	jmp    8014d4 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8014ea:	0f b6 c1             	movzbl %cl,%eax
  8014ed:	0f b6 db             	movzbl %bl,%ebx
  8014f0:	29 d8                	sub    %ebx,%eax
  8014f2:	eb 05                	jmp    8014f9 <memcmp+0x39>
	}

	return 0;
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f9:	5b                   	pop    %ebx
  8014fa:	5e                   	pop    %esi
  8014fb:	5d                   	pop    %ebp
  8014fc:	c3                   	ret    

008014fd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014fd:	f3 0f 1e fb          	endbr32 
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80150a:	89 c2                	mov    %eax,%edx
  80150c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80150f:	39 d0                	cmp    %edx,%eax
  801511:	73 09                	jae    80151c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801513:	38 08                	cmp    %cl,(%eax)
  801515:	74 05                	je     80151c <memfind+0x1f>
	for (; s < ends; s++)
  801517:	83 c0 01             	add    $0x1,%eax
  80151a:	eb f3                	jmp    80150f <memfind+0x12>
			break;
	return (void *) s;
}
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80151e:	f3 0f 1e fb          	endbr32 
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	57                   	push   %edi
  801526:	56                   	push   %esi
  801527:	53                   	push   %ebx
  801528:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80152e:	eb 03                	jmp    801533 <strtol+0x15>
		s++;
  801530:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801533:	0f b6 01             	movzbl (%ecx),%eax
  801536:	3c 20                	cmp    $0x20,%al
  801538:	74 f6                	je     801530 <strtol+0x12>
  80153a:	3c 09                	cmp    $0x9,%al
  80153c:	74 f2                	je     801530 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80153e:	3c 2b                	cmp    $0x2b,%al
  801540:	74 2a                	je     80156c <strtol+0x4e>
	int neg = 0;
  801542:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801547:	3c 2d                	cmp    $0x2d,%al
  801549:	74 2b                	je     801576 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80154b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801551:	75 0f                	jne    801562 <strtol+0x44>
  801553:	80 39 30             	cmpb   $0x30,(%ecx)
  801556:	74 28                	je     801580 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801558:	85 db                	test   %ebx,%ebx
  80155a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80155f:	0f 44 d8             	cmove  %eax,%ebx
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
  801567:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80156a:	eb 46                	jmp    8015b2 <strtol+0x94>
		s++;
  80156c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80156f:	bf 00 00 00 00       	mov    $0x0,%edi
  801574:	eb d5                	jmp    80154b <strtol+0x2d>
		s++, neg = 1;
  801576:	83 c1 01             	add    $0x1,%ecx
  801579:	bf 01 00 00 00       	mov    $0x1,%edi
  80157e:	eb cb                	jmp    80154b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801580:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801584:	74 0e                	je     801594 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801586:	85 db                	test   %ebx,%ebx
  801588:	75 d8                	jne    801562 <strtol+0x44>
		s++, base = 8;
  80158a:	83 c1 01             	add    $0x1,%ecx
  80158d:	bb 08 00 00 00       	mov    $0x8,%ebx
  801592:	eb ce                	jmp    801562 <strtol+0x44>
		s += 2, base = 16;
  801594:	83 c1 02             	add    $0x2,%ecx
  801597:	bb 10 00 00 00       	mov    $0x10,%ebx
  80159c:	eb c4                	jmp    801562 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80159e:	0f be d2             	movsbl %dl,%edx
  8015a1:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8015a4:	3b 55 10             	cmp    0x10(%ebp),%edx
  8015a7:	7d 3a                	jge    8015e3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8015a9:	83 c1 01             	add    $0x1,%ecx
  8015ac:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015b0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8015b2:	0f b6 11             	movzbl (%ecx),%edx
  8015b5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8015b8:	89 f3                	mov    %esi,%ebx
  8015ba:	80 fb 09             	cmp    $0x9,%bl
  8015bd:	76 df                	jbe    80159e <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8015bf:	8d 72 9f             	lea    -0x61(%edx),%esi
  8015c2:	89 f3                	mov    %esi,%ebx
  8015c4:	80 fb 19             	cmp    $0x19,%bl
  8015c7:	77 08                	ja     8015d1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8015c9:	0f be d2             	movsbl %dl,%edx
  8015cc:	83 ea 57             	sub    $0x57,%edx
  8015cf:	eb d3                	jmp    8015a4 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8015d1:	8d 72 bf             	lea    -0x41(%edx),%esi
  8015d4:	89 f3                	mov    %esi,%ebx
  8015d6:	80 fb 19             	cmp    $0x19,%bl
  8015d9:	77 08                	ja     8015e3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8015db:	0f be d2             	movsbl %dl,%edx
  8015de:	83 ea 37             	sub    $0x37,%edx
  8015e1:	eb c1                	jmp    8015a4 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8015e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e7:	74 05                	je     8015ee <strtol+0xd0>
		*endptr = (char *) s;
  8015e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ec:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8015ee:	89 c2                	mov    %eax,%edx
  8015f0:	f7 da                	neg    %edx
  8015f2:	85 ff                	test   %edi,%edi
  8015f4:	0f 45 c2             	cmovne %edx,%eax
}
  8015f7:	5b                   	pop    %ebx
  8015f8:	5e                   	pop    %esi
  8015f9:	5f                   	pop    %edi
  8015fa:	5d                   	pop    %ebp
  8015fb:	c3                   	ret    

008015fc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015fc:	f3 0f 1e fb          	endbr32 
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	57                   	push   %edi
  801604:	56                   	push   %esi
  801605:	53                   	push   %ebx
	asm volatile("int %1\n"
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	8b 55 08             	mov    0x8(%ebp),%edx
  80160e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801611:	89 c3                	mov    %eax,%ebx
  801613:	89 c7                	mov    %eax,%edi
  801615:	89 c6                	mov    %eax,%esi
  801617:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801619:	5b                   	pop    %ebx
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <sys_cgetc>:

int
sys_cgetc(void)
{
  80161e:	f3 0f 1e fb          	endbr32 
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	57                   	push   %edi
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
	asm volatile("int %1\n"
  801628:	ba 00 00 00 00       	mov    $0x0,%edx
  80162d:	b8 01 00 00 00       	mov    $0x1,%eax
  801632:	89 d1                	mov    %edx,%ecx
  801634:	89 d3                	mov    %edx,%ebx
  801636:	89 d7                	mov    %edx,%edi
  801638:	89 d6                	mov    %edx,%esi
  80163a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80163c:	5b                   	pop    %ebx
  80163d:	5e                   	pop    %esi
  80163e:	5f                   	pop    %edi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801641:	f3 0f 1e fb          	endbr32 
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	57                   	push   %edi
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80164e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801653:	8b 55 08             	mov    0x8(%ebp),%edx
  801656:	b8 03 00 00 00       	mov    $0x3,%eax
  80165b:	89 cb                	mov    %ecx,%ebx
  80165d:	89 cf                	mov    %ecx,%edi
  80165f:	89 ce                	mov    %ecx,%esi
  801661:	cd 30                	int    $0x30
	if(check && ret > 0)
  801663:	85 c0                	test   %eax,%eax
  801665:	7f 08                	jg     80166f <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801667:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5f                   	pop    %edi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	6a 03                	push   $0x3
  801675:	68 2f 3a 80 00       	push   $0x803a2f
  80167a:	6a 23                	push   $0x23
  80167c:	68 4c 3a 80 00       	push   $0x803a4c
  801681:	e8 1f f4 ff ff       	call   800aa5 <_panic>

00801686 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801686:	f3 0f 1e fb          	endbr32 
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	57                   	push   %edi
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801690:	ba 00 00 00 00       	mov    $0x0,%edx
  801695:	b8 02 00 00 00       	mov    $0x2,%eax
  80169a:	89 d1                	mov    %edx,%ecx
  80169c:	89 d3                	mov    %edx,%ebx
  80169e:	89 d7                	mov    %edx,%edi
  8016a0:	89 d6                	mov    %edx,%esi
  8016a2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016a4:	5b                   	pop    %ebx
  8016a5:	5e                   	pop    %esi
  8016a6:	5f                   	pop    %edi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <sys_yield>:

void
sys_yield(void)
{
  8016a9:	f3 0f 1e fb          	endbr32 
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	57                   	push   %edi
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016bd:	89 d1                	mov    %edx,%ecx
  8016bf:	89 d3                	mov    %edx,%ebx
  8016c1:	89 d7                	mov    %edx,%edi
  8016c3:	89 d6                	mov    %edx,%esi
  8016c5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5f                   	pop    %edi
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8016cc:	f3 0f 1e fb          	endbr32 
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	57                   	push   %edi
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
  8016d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016d9:	be 00 00 00 00       	mov    $0x0,%esi
  8016de:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ec:	89 f7                	mov    %esi,%edi
  8016ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	7f 08                	jg     8016fc <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5f                   	pop    %edi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	50                   	push   %eax
  801700:	6a 04                	push   $0x4
  801702:	68 2f 3a 80 00       	push   $0x803a2f
  801707:	6a 23                	push   $0x23
  801709:	68 4c 3a 80 00       	push   $0x803a4c
  80170e:	e8 92 f3 ff ff       	call   800aa5 <_panic>

00801713 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801713:	f3 0f 1e fb          	endbr32 
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	57                   	push   %edi
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
  80171d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801720:	8b 55 08             	mov    0x8(%ebp),%edx
  801723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801726:	b8 05 00 00 00       	mov    $0x5,%eax
  80172b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80172e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801731:	8b 75 18             	mov    0x18(%ebp),%esi
  801734:	cd 30                	int    $0x30
	if(check && ret > 0)
  801736:	85 c0                	test   %eax,%eax
  801738:	7f 08                	jg     801742 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80173a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5f                   	pop    %edi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801742:	83 ec 0c             	sub    $0xc,%esp
  801745:	50                   	push   %eax
  801746:	6a 05                	push   $0x5
  801748:	68 2f 3a 80 00       	push   $0x803a2f
  80174d:	6a 23                	push   $0x23
  80174f:	68 4c 3a 80 00       	push   $0x803a4c
  801754:	e8 4c f3 ff ff       	call   800aa5 <_panic>

00801759 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801759:	f3 0f 1e fb          	endbr32 
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	57                   	push   %edi
  801761:	56                   	push   %esi
  801762:	53                   	push   %ebx
  801763:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801766:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801771:	b8 06 00 00 00       	mov    $0x6,%eax
  801776:	89 df                	mov    %ebx,%edi
  801778:	89 de                	mov    %ebx,%esi
  80177a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80177c:	85 c0                	test   %eax,%eax
  80177e:	7f 08                	jg     801788 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801780:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	50                   	push   %eax
  80178c:	6a 06                	push   $0x6
  80178e:	68 2f 3a 80 00       	push   $0x803a2f
  801793:	6a 23                	push   $0x23
  801795:	68 4c 3a 80 00       	push   $0x803a4c
  80179a:	e8 06 f3 ff ff       	call   800aa5 <_panic>

0080179f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80179f:	f3 0f 1e fb          	endbr32 
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	57                   	push   %edi
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8017bc:	89 df                	mov    %ebx,%edi
  8017be:	89 de                	mov    %ebx,%esi
  8017c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	7f 08                	jg     8017ce <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5f                   	pop    %edi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	50                   	push   %eax
  8017d2:	6a 08                	push   $0x8
  8017d4:	68 2f 3a 80 00       	push   $0x803a2f
  8017d9:	6a 23                	push   $0x23
  8017db:	68 4c 3a 80 00       	push   $0x803a4c
  8017e0:	e8 c0 f2 ff ff       	call   800aa5 <_panic>

008017e5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017e5:	f3 0f 1e fb          	endbr32 
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	57                   	push   %edi
  8017ed:	56                   	push   %esi
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fd:	b8 09 00 00 00       	mov    $0x9,%eax
  801802:	89 df                	mov    %ebx,%edi
  801804:	89 de                	mov    %ebx,%esi
  801806:	cd 30                	int    $0x30
	if(check && ret > 0)
  801808:	85 c0                	test   %eax,%eax
  80180a:	7f 08                	jg     801814 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80180c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5f                   	pop    %edi
  801812:	5d                   	pop    %ebp
  801813:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	50                   	push   %eax
  801818:	6a 09                	push   $0x9
  80181a:	68 2f 3a 80 00       	push   $0x803a2f
  80181f:	6a 23                	push   $0x23
  801821:	68 4c 3a 80 00       	push   $0x803a4c
  801826:	e8 7a f2 ff ff       	call   800aa5 <_panic>

0080182b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80182b:	f3 0f 1e fb          	endbr32 
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	57                   	push   %edi
  801833:	56                   	push   %esi
  801834:	53                   	push   %ebx
  801835:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801838:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183d:	8b 55 08             	mov    0x8(%ebp),%edx
  801840:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801843:	b8 0a 00 00 00       	mov    $0xa,%eax
  801848:	89 df                	mov    %ebx,%edi
  80184a:	89 de                	mov    %ebx,%esi
  80184c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80184e:	85 c0                	test   %eax,%eax
  801850:	7f 08                	jg     80185a <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801852:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801855:	5b                   	pop    %ebx
  801856:	5e                   	pop    %esi
  801857:	5f                   	pop    %edi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80185a:	83 ec 0c             	sub    $0xc,%esp
  80185d:	50                   	push   %eax
  80185e:	6a 0a                	push   $0xa
  801860:	68 2f 3a 80 00       	push   $0x803a2f
  801865:	6a 23                	push   $0x23
  801867:	68 4c 3a 80 00       	push   $0x803a4c
  80186c:	e8 34 f2 ff ff       	call   800aa5 <_panic>

00801871 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801871:	f3 0f 1e fb          	endbr32 
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	57                   	push   %edi
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80187b:	8b 55 08             	mov    0x8(%ebp),%edx
  80187e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801881:	b8 0c 00 00 00       	mov    $0xc,%eax
  801886:	be 00 00 00 00       	mov    $0x0,%esi
  80188b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80188e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801891:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5f                   	pop    %edi
  801896:	5d                   	pop    %ebp
  801897:	c3                   	ret    

00801898 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801898:	f3 0f 1e fb          	endbr32 
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	57                   	push   %edi
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ad:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018b2:	89 cb                	mov    %ecx,%ebx
  8018b4:	89 cf                	mov    %ecx,%edi
  8018b6:	89 ce                	mov    %ecx,%esi
  8018b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	7f 08                	jg     8018c6 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5f                   	pop    %edi
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	50                   	push   %eax
  8018ca:	6a 0d                	push   $0xd
  8018cc:	68 2f 3a 80 00       	push   $0x803a2f
  8018d1:	6a 23                	push   $0x23
  8018d3:	68 4c 3a 80 00       	push   $0x803a4c
  8018d8:	e8 c8 f1 ff ff       	call   800aa5 <_panic>

008018dd <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8018dd:	f3 0f 1e fb          	endbr32 
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8018e9:	8b 30                	mov    (%eax),%esi
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[PGNUM(addr)] & PTE_COW))
  8018eb:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8018ef:	74 7f                	je     801970 <pgfault+0x93>
  8018f1:	89 f0                	mov    %esi,%eax
  8018f3:	c1 e8 0c             	shr    $0xc,%eax
  8018f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018fd:	f6 c4 08             	test   $0x8,%ah
  801900:	74 6e                	je     801970 <pgfault+0x93>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	
	envid_t envid=sys_getenvid();
  801902:	e8 7f fd ff ff       	call   801686 <sys_getenvid>
  801907:	89 c3                	mov    %eax,%ebx
	addr=ROUNDDOWN(addr,PGSIZE);
  801909:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if(sys_page_alloc(envid,(void *)PFTEMP,PTE_P|PTE_W|PTE_U)<0)
  80190f:	83 ec 04             	sub    $0x4,%esp
  801912:	6a 07                	push   $0x7
  801914:	68 00 f0 7f 00       	push   $0x7ff000
  801919:	50                   	push   %eax
  80191a:	e8 ad fd ff ff       	call   8016cc <sys_page_alloc>
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 5e                	js     801984 <pgfault+0xa7>
		panic("pgfault:sys_page_alloc Failed!");
	memcpy(PFTEMP,addr,PGSIZE);
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	68 00 10 00 00       	push   $0x1000
  80192e:	56                   	push   %esi
  80192f:	68 00 f0 7f 00       	push   $0x7ff000
  801934:	e8 6d fb ff ff       	call   8014a6 <memcpy>
	
	if(sys_page_map(envid, PFTEMP, envid, addr, PTE_U|PTE_W|PTE_P)<0)
  801939:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	68 00 f0 7f 00       	push   $0x7ff000
  801947:	53                   	push   %ebx
  801948:	e8 c6 fd ff ff       	call   801713 <sys_page_map>
  80194d:	83 c4 20             	add    $0x20,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	78 44                	js     801998 <pgfault+0xbb>
		panic("pgfault: sys_page_map Failed!");
	
	if(sys_page_unmap(envid, PFTEMP)<0)
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	68 00 f0 7f 00       	push   $0x7ff000
  80195c:	53                   	push   %ebx
  80195d:	e8 f7 fd ff ff       	call   801759 <sys_page_unmap>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 43                	js     8019ac <pgfault+0xcf>
		panic("pgfault: sys_page_unmap Failed!");
		
}
  801969:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196c:	5b                   	pop    %ebx
  80196d:	5e                   	pop    %esi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
		panic("pgfault: invalid UTrapFrame!");
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	68 5a 3a 80 00       	push   $0x803a5a
  801978:	6a 1e                	push   $0x1e
  80197a:	68 77 3a 80 00       	push   $0x803a77
  80197f:	e8 21 f1 ff ff       	call   800aa5 <_panic>
		panic("pgfault:sys_page_alloc Failed!");
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	68 08 3b 80 00       	push   $0x803b08
  80198c:	6a 2b                	push   $0x2b
  80198e:	68 77 3a 80 00       	push   $0x803a77
  801993:	e8 0d f1 ff ff       	call   800aa5 <_panic>
		panic("pgfault: sys_page_map Failed!");
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	68 82 3a 80 00       	push   $0x803a82
  8019a0:	6a 2f                	push   $0x2f
  8019a2:	68 77 3a 80 00       	push   $0x803a77
  8019a7:	e8 f9 f0 ff ff       	call   800aa5 <_panic>
		panic("pgfault: sys_page_unmap Failed!");
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 28 3b 80 00       	push   $0x803b28
  8019b4:	6a 32                	push   $0x32
  8019b6:	68 77 3a 80 00       	push   $0x803a77
  8019bb:	e8 e5 f0 ff ff       	call   800aa5 <_panic>

008019c0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8019c0:	f3 0f 1e fb          	endbr32 
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	57                   	push   %edi
  8019c8:	56                   	push   %esi
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 28             	sub    $0x28,%esp

	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8019cd:	68 dd 18 80 00       	push   $0x8018dd
  8019d2:	e8 c3 16 00 00       	call   80309a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019d7:	b8 07 00 00 00       	mov    $0x7,%eax
  8019dc:	cd 30                	int    $0x30
  8019de:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid_t envid=sys_exofork();
	if(envid<0)
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	78 2b                	js     801a16 <fork+0x56>
		thisenv=&envs[ENVX(sys_getenvid())];
		return 0;
	}
	
	uint32_t addr;
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  8019eb:	bb 00 00 00 00       	mov    $0x0,%ebx
	if(envid==0){
  8019f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019f4:	0f 85 ba 00 00 00    	jne    801ab4 <fork+0xf4>
		thisenv=&envs[ENVX(sys_getenvid())];
  8019fa:	e8 87 fc ff ff       	call   801686 <sys_getenvid>
  8019ff:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a04:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a07:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a0c:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801a11:	e9 90 01 00 00       	jmp    801ba6 <fork+0x1e6>
		panic("fork:sys_exofork Failed!");
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 a0 3a 80 00       	push   $0x803aa0
  801a1e:	6a 76                	push   $0x76
  801a20:	68 77 3a 80 00       	push   $0x803a77
  801a25:	e8 7b f0 ff ff       	call   800aa5 <_panic>
		if(sys_page_map(sys_getenvid(), addr,envid, addr,uvpt[pn]&PTE_SYSCALL)<0)
  801a2a:	8b 34 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%esi
  801a31:	e8 50 fc ff ff       	call   801686 <sys_getenvid>
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  801a3f:	56                   	push   %esi
  801a40:	57                   	push   %edi
  801a41:	ff 75 e0             	pushl  -0x20(%ebp)
  801a44:	57                   	push   %edi
  801a45:	50                   	push   %eax
  801a46:	e8 c8 fc ff ff       	call   801713 <sys_page_map>
  801a4b:	83 c4 20             	add    $0x20,%esp
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	79 50                	jns    801aa2 <fork+0xe2>
			panic("duppage:sys_page_map Failed!");
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	68 b9 3a 80 00       	push   $0x803ab9
  801a5a:	6a 4b                	push   $0x4b
  801a5c:	68 77 3a 80 00       	push   $0x803a77
  801a61:	e8 3f f0 ff ff       	call   800aa5 <_panic>
			panic("duppage:child sys_page_map Failed!");
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	68 48 3b 80 00       	push   $0x803b48
  801a6e:	6a 50                	push   $0x50
  801a70:	68 77 3a 80 00       	push   $0x803a77
  801a75:	e8 2b f0 ff ff       	call   800aa5 <_panic>
		if(sys_page_map(f_id,addr,envid,addr,uvpt[pn]&PTE_SYSCALL)<0)
  801a7a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801a81:	83 ec 0c             	sub    $0xc,%esp
  801a84:	25 07 0e 00 00       	and    $0xe07,%eax
  801a89:	50                   	push   %eax
  801a8a:	57                   	push   %edi
  801a8b:	ff 75 e0             	pushl  -0x20(%ebp)
  801a8e:	57                   	push   %edi
  801a8f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a92:	e8 7c fc ff ff       	call   801713 <sys_page_map>
  801a97:	83 c4 20             	add    $0x20,%esp
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	0f 88 b4 00 00 00    	js     801b56 <fork+0x196>
	for (addr =0; addr<USTACKTOP; addr += PGSIZE){
  801aa2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801aa8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801aae:	0f 84 b6 00 00 00    	je     801b6a <fork+0x1aa>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P))
  801ab4:	89 d8                	mov    %ebx,%eax
  801ab6:	c1 e8 16             	shr    $0x16,%eax
  801ab9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ac0:	a8 01                	test   $0x1,%al
  801ac2:	74 de                	je     801aa2 <fork+0xe2>
  801ac4:	89 de                	mov    %ebx,%esi
  801ac6:	c1 ee 0c             	shr    $0xc,%esi
  801ac9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801ad0:	a8 01                	test   $0x1,%al
  801ad2:	74 ce                	je     801aa2 <fork+0xe2>
	envid_t f_id=sys_getenvid();
  801ad4:	e8 ad fb ff ff       	call   801686 <sys_getenvid>
  801ad9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *addr=(void *)(pn*PGSIZE);
  801adc:	89 f7                	mov    %esi,%edi
  801ade:	c1 e7 0c             	shl    $0xc,%edi
	if(uvpt[pn]&PTE_SHARE){
  801ae1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801ae8:	f6 c4 04             	test   $0x4,%ah
  801aeb:	0f 85 39 ff ff ff    	jne    801a2a <fork+0x6a>
	if(uvpt[pn]&(PTE_W|PTE_COW)){
  801af1:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801af8:	a9 02 08 00 00       	test   $0x802,%eax
  801afd:	0f 84 77 ff ff ff    	je     801a7a <fork+0xba>
		if(sys_page_map(f_id,addr,envid,addr,PTE_U|PTE_COW|PTE_P)<0)
  801b03:	83 ec 0c             	sub    $0xc,%esp
  801b06:	68 05 08 00 00       	push   $0x805
  801b0b:	57                   	push   %edi
  801b0c:	ff 75 e0             	pushl  -0x20(%ebp)
  801b0f:	57                   	push   %edi
  801b10:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b13:	e8 fb fb ff ff       	call   801713 <sys_page_map>
  801b18:	83 c4 20             	add    $0x20,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	0f 88 43 ff ff ff    	js     801a66 <fork+0xa6>
		if(sys_page_map(f_id,addr,f_id,addr,PTE_U|PTE_COW|PTE_P) < 0)
  801b23:	83 ec 0c             	sub    $0xc,%esp
  801b26:	68 05 08 00 00       	push   $0x805
  801b2b:	57                   	push   %edi
  801b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	57                   	push   %edi
  801b31:	50                   	push   %eax
  801b32:	e8 dc fb ff ff       	call   801713 <sys_page_map>
  801b37:	83 c4 20             	add    $0x20,%esp
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	0f 89 60 ff ff ff    	jns    801aa2 <fork+0xe2>
			panic("duppage: self sys_page_map Failed!");
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	68 6c 3b 80 00       	push   $0x803b6c
  801b4a:	6a 52                	push   $0x52
  801b4c:	68 77 3a 80 00       	push   $0x803a77
  801b51:	e8 4f ef ff ff       	call   800aa5 <_panic>
			panic("duppage: single sys_page_map Failed!");
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	68 90 3b 80 00       	push   $0x803b90
  801b5e:	6a 56                	push   $0x56
  801b60:	68 77 3a 80 00       	push   $0x803a77
  801b65:	e8 3b ef ff ff       	call   800aa5 <_panic>
		duppage(envid, PGNUM(addr));
	}
	
	if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	6a 07                	push   $0x7
  801b6f:	68 00 f0 bf ee       	push   $0xeebff000
  801b74:	ff 75 dc             	pushl  -0x24(%ebp)
  801b77:	e8 50 fb ff ff       	call   8016cc <sys_page_alloc>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 2e                	js     801bb1 <fork+0x1f1>
		panic("fork:sys_page_alloc Failed!");
	
	extern void _pgfault_upcall(void);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	68 16 31 80 00       	push   $0x803116
  801b8b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801b8e:	57                   	push   %edi
  801b8f:	e8 97 fc ff ff       	call   80182b <sys_env_set_pgfault_upcall>
	
	if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  801b94:	83 c4 08             	add    $0x8,%esp
  801b97:	6a 02                	push   $0x2
  801b99:	57                   	push   %edi
  801b9a:	e8 00 fc ff ff       	call   80179f <sys_env_set_status>
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	78 22                	js     801bc8 <fork+0x208>
		panic("fork: sys_env_set_status Failed!");
	
	return envid;
	
}
  801ba6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bac:	5b                   	pop    %ebx
  801bad:	5e                   	pop    %esi
  801bae:	5f                   	pop    %edi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    
		panic("fork:sys_page_alloc Failed!");
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	68 d6 3a 80 00       	push   $0x803ad6
  801bb9:	68 83 00 00 00       	push   $0x83
  801bbe:	68 77 3a 80 00       	push   $0x803a77
  801bc3:	e8 dd ee ff ff       	call   800aa5 <_panic>
		panic("fork: sys_env_set_status Failed!");
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	68 b8 3b 80 00       	push   $0x803bb8
  801bd0:	68 89 00 00 00       	push   $0x89
  801bd5:	68 77 3a 80 00       	push   $0x803a77
  801bda:	e8 c6 ee ff ff       	call   800aa5 <_panic>

00801bdf <sfork>:

// Challenge!
int
sfork(void)
{
  801bdf:	f3 0f 1e fb          	endbr32 
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801be9:	68 f2 3a 80 00       	push   $0x803af2
  801bee:	68 93 00 00 00       	push   $0x93
  801bf3:	68 77 3a 80 00       	push   $0x803a77
  801bf8:	e8 a8 ee ff ff       	call   800aa5 <_panic>

00801bfd <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801bfd:	f3 0f 1e fb          	endbr32 
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	8b 55 08             	mov    0x8(%ebp),%edx
  801c07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0a:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801c0d:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801c0f:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c12:	83 3a 01             	cmpl   $0x1,(%edx)
  801c15:	7e 09                	jle    801c20 <argstart+0x23>
  801c17:	ba 01 35 80 00       	mov    $0x803501,%edx
  801c1c:	85 c9                	test   %ecx,%ecx
  801c1e:	75 05                	jne    801c25 <argstart+0x28>
  801c20:	ba 00 00 00 00       	mov    $0x0,%edx
  801c25:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801c28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <argnext>:

int
argnext(struct Argstate *args)
{
  801c31:	f3 0f 1e fb          	endbr32 
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	53                   	push   %ebx
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801c3f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c46:	8b 43 08             	mov    0x8(%ebx),%eax
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	74 74                	je     801cc1 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801c4d:	80 38 00             	cmpb   $0x0,(%eax)
  801c50:	75 48                	jne    801c9a <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c52:	8b 0b                	mov    (%ebx),%ecx
  801c54:	83 39 01             	cmpl   $0x1,(%ecx)
  801c57:	74 5a                	je     801cb3 <argnext+0x82>
		    || args->argv[1][0] != '-'
  801c59:	8b 53 04             	mov    0x4(%ebx),%edx
  801c5c:	8b 42 04             	mov    0x4(%edx),%eax
  801c5f:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c62:	75 4f                	jne    801cb3 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  801c64:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c68:	74 49                	je     801cb3 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c6a:	83 c0 01             	add    $0x1,%eax
  801c6d:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	8b 01                	mov    (%ecx),%eax
  801c75:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801c7c:	50                   	push   %eax
  801c7d:	8d 42 08             	lea    0x8(%edx),%eax
  801c80:	50                   	push   %eax
  801c81:	83 c2 04             	add    $0x4,%edx
  801c84:	52                   	push   %edx
  801c85:	e8 b6 f7 ff ff       	call   801440 <memmove>
		(*args->argc)--;
  801c8a:	8b 03                	mov    (%ebx),%eax
  801c8c:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c8f:	8b 43 08             	mov    0x8(%ebx),%eax
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c98:	74 13                	je     801cad <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801c9a:	8b 43 08             	mov    0x8(%ebx),%eax
  801c9d:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801ca0:	83 c0 01             	add    $0x1,%eax
  801ca3:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cad:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801cb1:	75 e7                	jne    801c9a <argnext+0x69>
	args->curarg = 0;
  801cb3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801cba:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801cbf:	eb e5                	jmp    801ca6 <argnext+0x75>
		return -1;
  801cc1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801cc6:	eb de                	jmp    801ca6 <argnext+0x75>

00801cc8 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801cc8:	f3 0f 1e fb          	endbr32 
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801cd6:	8b 43 08             	mov    0x8(%ebx),%eax
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	74 12                	je     801cef <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801cdd:	80 38 00             	cmpb   $0x0,(%eax)
  801ce0:	74 12                	je     801cf4 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  801ce2:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801ce5:	c7 43 08 01 35 80 00 	movl   $0x803501,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801cec:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    
	} else if (*args->argc > 1) {
  801cf4:	8b 13                	mov    (%ebx),%edx
  801cf6:	83 3a 01             	cmpl   $0x1,(%edx)
  801cf9:	7f 10                	jg     801d0b <argnextvalue+0x43>
		args->argvalue = 0;
  801cfb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801d02:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801d09:	eb e1                	jmp    801cec <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801d0b:	8b 43 04             	mov    0x4(%ebx),%eax
  801d0e:	8b 48 04             	mov    0x4(%eax),%ecx
  801d11:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	8b 12                	mov    (%edx),%edx
  801d19:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801d20:	52                   	push   %edx
  801d21:	8d 50 08             	lea    0x8(%eax),%edx
  801d24:	52                   	push   %edx
  801d25:	83 c0 04             	add    $0x4,%eax
  801d28:	50                   	push   %eax
  801d29:	e8 12 f7 ff ff       	call   801440 <memmove>
		(*args->argc)--;
  801d2e:	8b 03                	mov    (%ebx),%eax
  801d30:	83 28 01             	subl   $0x1,(%eax)
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	eb b4                	jmp    801cec <argnextvalue+0x24>

00801d38 <argvalue>:
{
  801d38:	f3 0f 1e fb          	endbr32 
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d45:	8b 42 0c             	mov    0xc(%edx),%eax
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	74 02                	je     801d4e <argvalue+0x16>
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	52                   	push   %edx
  801d52:	e8 71 ff ff ff       	call   801cc8 <argnextvalue>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	eb f0                	jmp    801d4c <argvalue+0x14>

00801d5c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d5c:	f3 0f 1e fb          	endbr32 
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	05 00 00 00 30       	add    $0x30000000,%eax
  801d6b:	c1 e8 0c             	shr    $0xc,%eax
}
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    

00801d70 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d70:	f3 0f 1e fb          	endbr32 
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801d7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d84:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    

00801d8b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d8b:	f3 0f 1e fb          	endbr32 
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d97:	89 c2                	mov    %eax,%edx
  801d99:	c1 ea 16             	shr    $0x16,%edx
  801d9c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801da3:	f6 c2 01             	test   $0x1,%dl
  801da6:	74 2d                	je     801dd5 <fd_alloc+0x4a>
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	c1 ea 0c             	shr    $0xc,%edx
  801dad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801db4:	f6 c2 01             	test   $0x1,%dl
  801db7:	74 1c                	je     801dd5 <fd_alloc+0x4a>
  801db9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801dbe:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801dc3:	75 d2                	jne    801d97 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801dce:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801dd3:	eb 0a                	jmp    801ddf <fd_alloc+0x54>
			*fd_store = fd;
  801dd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd8:	89 01                	mov    %eax,(%ecx)
			return 0;
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddf:	5d                   	pop    %ebp
  801de0:	c3                   	ret    

00801de1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801de1:	f3 0f 1e fb          	endbr32 
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801deb:	83 f8 1f             	cmp    $0x1f,%eax
  801dee:	77 30                	ja     801e20 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801df0:	c1 e0 0c             	shl    $0xc,%eax
  801df3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801df8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801dfe:	f6 c2 01             	test   $0x1,%dl
  801e01:	74 24                	je     801e27 <fd_lookup+0x46>
  801e03:	89 c2                	mov    %eax,%edx
  801e05:	c1 ea 0c             	shr    $0xc,%edx
  801e08:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e0f:	f6 c2 01             	test   $0x1,%dl
  801e12:	74 1a                	je     801e2e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e17:	89 02                	mov    %eax,(%edx)
	return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    
		return -E_INVAL;
  801e20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e25:	eb f7                	jmp    801e1e <fd_lookup+0x3d>
		return -E_INVAL;
  801e27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e2c:	eb f0                	jmp    801e1e <fd_lookup+0x3d>
  801e2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e33:	eb e9                	jmp    801e1e <fd_lookup+0x3d>

00801e35 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e35:	f3 0f 1e fb          	endbr32 
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e42:	ba 58 3c 80 00       	mov    $0x803c58,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801e47:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801e4c:	39 08                	cmp    %ecx,(%eax)
  801e4e:	74 33                	je     801e83 <dev_lookup+0x4e>
  801e50:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801e53:	8b 02                	mov    (%edx),%eax
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 f3                	jne    801e4c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e59:	a1 24 54 80 00       	mov    0x805424,%eax
  801e5e:	8b 40 48             	mov    0x48(%eax),%eax
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	51                   	push   %ecx
  801e65:	50                   	push   %eax
  801e66:	68 dc 3b 80 00       	push   $0x803bdc
  801e6b:	e8 1c ed ff ff       	call   800b8c <cprintf>
	*dev = 0;
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    
			*dev = devtab[i];
  801e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e86:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8d:	eb f2                	jmp    801e81 <dev_lookup+0x4c>

00801e8f <fd_close>:
{
  801e8f:	f3 0f 1e fb          	endbr32 
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	57                   	push   %edi
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	83 ec 24             	sub    $0x24,%esp
  801e9c:	8b 75 08             	mov    0x8(%ebp),%esi
  801e9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ea2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ea5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ea6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801eac:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eaf:	50                   	push   %eax
  801eb0:	e8 2c ff ff ff       	call   801de1 <fd_lookup>
  801eb5:	89 c3                	mov    %eax,%ebx
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 05                	js     801ec3 <fd_close+0x34>
	    || fd != fd2)
  801ebe:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801ec1:	74 16                	je     801ed9 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801ec3:	89 f8                	mov    %edi,%eax
  801ec5:	84 c0                	test   %al,%al
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	0f 44 d8             	cmove  %eax,%ebx
}
  801ecf:	89 d8                	mov    %ebx,%eax
  801ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5e                   	pop    %esi
  801ed6:	5f                   	pop    %edi
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ed9:	83 ec 08             	sub    $0x8,%esp
  801edc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801edf:	50                   	push   %eax
  801ee0:	ff 36                	pushl  (%esi)
  801ee2:	e8 4e ff ff ff       	call   801e35 <dev_lookup>
  801ee7:	89 c3                	mov    %eax,%ebx
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	85 c0                	test   %eax,%eax
  801eee:	78 1a                	js     801f0a <fd_close+0x7b>
		if (dev->dev_close)
  801ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801ef6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801efb:	85 c0                	test   %eax,%eax
  801efd:	74 0b                	je     801f0a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	56                   	push   %esi
  801f03:	ff d0                	call   *%eax
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f0a:	83 ec 08             	sub    $0x8,%esp
  801f0d:	56                   	push   %esi
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 44 f8 ff ff       	call   801759 <sys_page_unmap>
	return r;
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	eb b5                	jmp    801ecf <fd_close+0x40>

00801f1a <close>:

int
close(int fdnum)
{
  801f1a:	f3 0f 1e fb          	endbr32 
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f27:	50                   	push   %eax
  801f28:	ff 75 08             	pushl  0x8(%ebp)
  801f2b:	e8 b1 fe ff ff       	call   801de1 <fd_lookup>
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	79 02                	jns    801f39 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    
		return fd_close(fd, 1);
  801f39:	83 ec 08             	sub    $0x8,%esp
  801f3c:	6a 01                	push   $0x1
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	e8 49 ff ff ff       	call   801e8f <fd_close>
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	eb ec                	jmp    801f37 <close+0x1d>

00801f4b <close_all>:

void
close_all(void)
{
  801f4b:	f3 0f 1e fb          	endbr32 
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	53                   	push   %ebx
  801f53:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f56:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	53                   	push   %ebx
  801f5f:	e8 b6 ff ff ff       	call   801f1a <close>
	for (i = 0; i < MAXFD; i++)
  801f64:	83 c3 01             	add    $0x1,%ebx
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	83 fb 20             	cmp    $0x20,%ebx
  801f6d:	75 ec                	jne    801f5b <close_all+0x10>
}
  801f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f74:	f3 0f 1e fb          	endbr32 
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	57                   	push   %edi
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f81:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f84:	50                   	push   %eax
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	e8 54 fe ff ff       	call   801de1 <fd_lookup>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 88 81 00 00 00    	js     80201b <dup+0xa7>
		return r;
	close(newfdnum);
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	e8 75 ff ff ff       	call   801f1a <close>

	newfd = INDEX2FD(newfdnum);
  801fa5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fa8:	c1 e6 0c             	shl    $0xc,%esi
  801fab:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801fb1:	83 c4 04             	add    $0x4,%esp
  801fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fb7:	e8 b4 fd ff ff       	call   801d70 <fd2data>
  801fbc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801fbe:	89 34 24             	mov    %esi,(%esp)
  801fc1:	e8 aa fd ff ff       	call   801d70 <fd2data>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fcb:	89 d8                	mov    %ebx,%eax
  801fcd:	c1 e8 16             	shr    $0x16,%eax
  801fd0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fd7:	a8 01                	test   $0x1,%al
  801fd9:	74 11                	je     801fec <dup+0x78>
  801fdb:	89 d8                	mov    %ebx,%eax
  801fdd:	c1 e8 0c             	shr    $0xc,%eax
  801fe0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801fe7:	f6 c2 01             	test   $0x1,%dl
  801fea:	75 39                	jne    802025 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fef:	89 d0                	mov    %edx,%eax
  801ff1:	c1 e8 0c             	shr    $0xc,%eax
  801ff4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	25 07 0e 00 00       	and    $0xe07,%eax
  802003:	50                   	push   %eax
  802004:	56                   	push   %esi
  802005:	6a 00                	push   $0x0
  802007:	52                   	push   %edx
  802008:	6a 00                	push   $0x0
  80200a:	e8 04 f7 ff ff       	call   801713 <sys_page_map>
  80200f:	89 c3                	mov    %eax,%ebx
  802011:	83 c4 20             	add    $0x20,%esp
  802014:	85 c0                	test   %eax,%eax
  802016:	78 31                	js     802049 <dup+0xd5>
		goto err;

	return newfdnum;
  802018:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80201b:	89 d8                	mov    %ebx,%eax
  80201d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802020:	5b                   	pop    %ebx
  802021:	5e                   	pop    %esi
  802022:	5f                   	pop    %edi
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802025:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	25 07 0e 00 00       	and    $0xe07,%eax
  802034:	50                   	push   %eax
  802035:	57                   	push   %edi
  802036:	6a 00                	push   $0x0
  802038:	53                   	push   %ebx
  802039:	6a 00                	push   $0x0
  80203b:	e8 d3 f6 ff ff       	call   801713 <sys_page_map>
  802040:	89 c3                	mov    %eax,%ebx
  802042:	83 c4 20             	add    $0x20,%esp
  802045:	85 c0                	test   %eax,%eax
  802047:	79 a3                	jns    801fec <dup+0x78>
	sys_page_unmap(0, newfd);
  802049:	83 ec 08             	sub    $0x8,%esp
  80204c:	56                   	push   %esi
  80204d:	6a 00                	push   $0x0
  80204f:	e8 05 f7 ff ff       	call   801759 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802054:	83 c4 08             	add    $0x8,%esp
  802057:	57                   	push   %edi
  802058:	6a 00                	push   $0x0
  80205a:	e8 fa f6 ff ff       	call   801759 <sys_page_unmap>
	return r;
  80205f:	83 c4 10             	add    $0x10,%esp
  802062:	eb b7                	jmp    80201b <dup+0xa7>

00802064 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802064:	f3 0f 1e fb          	endbr32 
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	53                   	push   %ebx
  80206c:	83 ec 1c             	sub    $0x1c,%esp
  80206f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802072:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	53                   	push   %ebx
  802077:	e8 65 fd ff ff       	call   801de1 <fd_lookup>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 3f                	js     8020c2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802089:	50                   	push   %eax
  80208a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208d:	ff 30                	pushl  (%eax)
  80208f:	e8 a1 fd ff ff       	call   801e35 <dev_lookup>
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	85 c0                	test   %eax,%eax
  802099:	78 27                	js     8020c2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80209b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209e:	8b 42 08             	mov    0x8(%edx),%eax
  8020a1:	83 e0 03             	and    $0x3,%eax
  8020a4:	83 f8 01             	cmp    $0x1,%eax
  8020a7:	74 1e                	je     8020c7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 40 08             	mov    0x8(%eax),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 35                	je     8020e8 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	ff 75 10             	pushl  0x10(%ebp)
  8020b9:	ff 75 0c             	pushl  0xc(%ebp)
  8020bc:	52                   	push   %edx
  8020bd:	ff d0                	call   *%eax
  8020bf:	83 c4 10             	add    $0x10,%esp
}
  8020c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020c7:	a1 24 54 80 00       	mov    0x805424,%eax
  8020cc:	8b 40 48             	mov    0x48(%eax),%eax
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	53                   	push   %ebx
  8020d3:	50                   	push   %eax
  8020d4:	68 1d 3c 80 00       	push   $0x803c1d
  8020d9:	e8 ae ea ff ff       	call   800b8c <cprintf>
		return -E_INVAL;
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e6:	eb da                	jmp    8020c2 <read+0x5e>
		return -E_NOT_SUPP;
  8020e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020ed:	eb d3                	jmp    8020c2 <read+0x5e>

008020ef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020ef:	f3 0f 1e fb          	endbr32 
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	57                   	push   %edi
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	83 ec 0c             	sub    $0xc,%esp
  8020fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020ff:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802102:	bb 00 00 00 00       	mov    $0x0,%ebx
  802107:	eb 02                	jmp    80210b <readn+0x1c>
  802109:	01 c3                	add    %eax,%ebx
  80210b:	39 f3                	cmp    %esi,%ebx
  80210d:	73 21                	jae    802130 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	89 f0                	mov    %esi,%eax
  802114:	29 d8                	sub    %ebx,%eax
  802116:	50                   	push   %eax
  802117:	89 d8                	mov    %ebx,%eax
  802119:	03 45 0c             	add    0xc(%ebp),%eax
  80211c:	50                   	push   %eax
  80211d:	57                   	push   %edi
  80211e:	e8 41 ff ff ff       	call   802064 <read>
		if (m < 0)
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	85 c0                	test   %eax,%eax
  802128:	78 04                	js     80212e <readn+0x3f>
			return m;
		if (m == 0)
  80212a:	75 dd                	jne    802109 <readn+0x1a>
  80212c:	eb 02                	jmp    802130 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80212e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802130:	89 d8                	mov    %ebx,%eax
  802132:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5f                   	pop    %edi
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    

0080213a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80213a:	f3 0f 1e fb          	endbr32 
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	53                   	push   %ebx
  802142:	83 ec 1c             	sub    $0x1c,%esp
  802145:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802148:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80214b:	50                   	push   %eax
  80214c:	53                   	push   %ebx
  80214d:	e8 8f fc ff ff       	call   801de1 <fd_lookup>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	78 3a                	js     802193 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802159:	83 ec 08             	sub    $0x8,%esp
  80215c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802163:	ff 30                	pushl  (%eax)
  802165:	e8 cb fc ff ff       	call   801e35 <dev_lookup>
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 22                	js     802193 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802178:	74 1e                	je     802198 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80217a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217d:	8b 52 0c             	mov    0xc(%edx),%edx
  802180:	85 d2                	test   %edx,%edx
  802182:	74 35                	je     8021b9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	ff 75 10             	pushl  0x10(%ebp)
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	50                   	push   %eax
  80218e:	ff d2                	call   *%edx
  802190:	83 c4 10             	add    $0x10,%esp
}
  802193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802196:	c9                   	leave  
  802197:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802198:	a1 24 54 80 00       	mov    0x805424,%eax
  80219d:	8b 40 48             	mov    0x48(%eax),%eax
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	53                   	push   %ebx
  8021a4:	50                   	push   %eax
  8021a5:	68 39 3c 80 00       	push   $0x803c39
  8021aa:	e8 dd e9 ff ff       	call   800b8c <cprintf>
		return -E_INVAL;
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b7:	eb da                	jmp    802193 <write+0x59>
		return -E_NOT_SUPP;
  8021b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021be:	eb d3                	jmp    802193 <write+0x59>

008021c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021cd:	50                   	push   %eax
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	e8 0b fc ff ff       	call   801de1 <fd_lookup>
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 0e                	js     8021eb <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8021dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021ed:	f3 0f 1e fb          	endbr32 
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	53                   	push   %ebx
  8021f5:	83 ec 1c             	sub    $0x1c,%esp
  8021f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021fe:	50                   	push   %eax
  8021ff:	53                   	push   %ebx
  802200:	e8 dc fb ff ff       	call   801de1 <fd_lookup>
  802205:	83 c4 10             	add    $0x10,%esp
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 37                	js     802243 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80220c:	83 ec 08             	sub    $0x8,%esp
  80220f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802212:	50                   	push   %eax
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	ff 30                	pushl  (%eax)
  802218:	e8 18 fc ff ff       	call   801e35 <dev_lookup>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	85 c0                	test   %eax,%eax
  802222:	78 1f                	js     802243 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80222b:	74 1b                	je     802248 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80222d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802230:	8b 52 18             	mov    0x18(%edx),%edx
  802233:	85 d2                	test   %edx,%edx
  802235:	74 32                	je     802269 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802237:	83 ec 08             	sub    $0x8,%esp
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	50                   	push   %eax
  80223e:	ff d2                	call   *%edx
  802240:	83 c4 10             	add    $0x10,%esp
}
  802243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802246:	c9                   	leave  
  802247:	c3                   	ret    
			thisenv->env_id, fdnum);
  802248:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80224d:	8b 40 48             	mov    0x48(%eax),%eax
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	53                   	push   %ebx
  802254:	50                   	push   %eax
  802255:	68 fc 3b 80 00       	push   $0x803bfc
  80225a:	e8 2d e9 ff ff       	call   800b8c <cprintf>
		return -E_INVAL;
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802267:	eb da                	jmp    802243 <ftruncate+0x56>
		return -E_NOT_SUPP;
  802269:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80226e:	eb d3                	jmp    802243 <ftruncate+0x56>

00802270 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802270:	f3 0f 1e fb          	endbr32 
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	53                   	push   %ebx
  802278:	83 ec 1c             	sub    $0x1c,%esp
  80227b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80227e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802281:	50                   	push   %eax
  802282:	ff 75 08             	pushl  0x8(%ebp)
  802285:	e8 57 fb ff ff       	call   801de1 <fd_lookup>
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	85 c0                	test   %eax,%eax
  80228f:	78 4b                	js     8022dc <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802291:	83 ec 08             	sub    $0x8,%esp
  802294:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802297:	50                   	push   %eax
  802298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229b:	ff 30                	pushl  (%eax)
  80229d:	e8 93 fb ff ff       	call   801e35 <dev_lookup>
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	78 33                	js     8022dc <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8022b0:	74 2f                	je     8022e1 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8022b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8022b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8022bc:	00 00 00 
	stat->st_isdir = 0;
  8022bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022c6:	00 00 00 
	stat->st_dev = dev;
  8022c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8022cf:	83 ec 08             	sub    $0x8,%esp
  8022d2:	53                   	push   %ebx
  8022d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d6:	ff 50 14             	call   *0x14(%eax)
  8022d9:	83 c4 10             	add    $0x10,%esp
}
  8022dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8022e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022e6:	eb f4                	jmp    8022dc <fstat+0x6c>

008022e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022e8:	f3 0f 1e fb          	endbr32 
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	56                   	push   %esi
  8022f0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022f1:	83 ec 08             	sub    $0x8,%esp
  8022f4:	6a 00                	push   $0x0
  8022f6:	ff 75 08             	pushl  0x8(%ebp)
  8022f9:	e8 fb 01 00 00       	call   8024f9 <open>
  8022fe:	89 c3                	mov    %eax,%ebx
  802300:	83 c4 10             	add    $0x10,%esp
  802303:	85 c0                	test   %eax,%eax
  802305:	78 1b                	js     802322 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  802307:	83 ec 08             	sub    $0x8,%esp
  80230a:	ff 75 0c             	pushl  0xc(%ebp)
  80230d:	50                   	push   %eax
  80230e:	e8 5d ff ff ff       	call   802270 <fstat>
  802313:	89 c6                	mov    %eax,%esi
	close(fd);
  802315:	89 1c 24             	mov    %ebx,(%esp)
  802318:	e8 fd fb ff ff       	call   801f1a <close>
	return r;
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	89 f3                	mov    %esi,%ebx
}
  802322:	89 d8                	mov    %ebx,%eax
  802324:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	89 c6                	mov    %eax,%esi
  802332:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802334:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  80233b:	74 27                	je     802364 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80233d:	6a 07                	push   $0x7
  80233f:	68 00 60 80 00       	push   $0x806000
  802344:	56                   	push   %esi
  802345:	ff 35 20 54 80 00    	pushl  0x805420
  80234b:	e8 57 0e 00 00       	call   8031a7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802350:	83 c4 0c             	add    $0xc,%esp
  802353:	6a 00                	push   $0x0
  802355:	53                   	push   %ebx
  802356:	6a 00                	push   $0x0
  802358:	e8 dd 0d 00 00       	call   80313a <ipc_recv>
}
  80235d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802364:	83 ec 0c             	sub    $0xc,%esp
  802367:	6a 01                	push   $0x1
  802369:	e8 93 0e 00 00       	call   803201 <ipc_find_env>
  80236e:	a3 20 54 80 00       	mov    %eax,0x805420
  802373:	83 c4 10             	add    $0x10,%esp
  802376:	eb c5                	jmp    80233d <fsipc+0x12>

00802378 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802378:	f3 0f 1e fb          	endbr32 
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 40 0c             	mov    0xc(%eax),%eax
  802388:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802395:	ba 00 00 00 00       	mov    $0x0,%edx
  80239a:	b8 02 00 00 00       	mov    $0x2,%eax
  80239f:	e8 87 ff ff ff       	call   80232b <fsipc>
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <devfile_flush>:
{
  8023a6:	f3 0f 1e fb          	endbr32 
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8023bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c0:	b8 06 00 00 00       	mov    $0x6,%eax
  8023c5:	e8 61 ff ff ff       	call   80232b <fsipc>
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <devfile_stat>:
{
  8023cc:	f3 0f 1e fb          	endbr32 
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e0:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8023e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8023ef:	e8 37 ff ff ff       	call   80232b <fsipc>
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	78 2c                	js     802424 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8023f8:	83 ec 08             	sub    $0x8,%esp
  8023fb:	68 00 60 80 00       	push   $0x806000
  802400:	53                   	push   %ebx
  802401:	e8 84 ee ff ff       	call   80128a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802406:	a1 80 60 80 00       	mov    0x806080,%eax
  80240b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802411:	a1 84 60 80 00       	mov    0x806084,%eax
  802416:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802424:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <devfile_write>:
{
  802429:	f3 0f 1e fb          	endbr32 
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	83 ec 0c             	sub    $0xc,%esp
  802433:	8b 45 10             	mov    0x10(%ebp),%eax
  802436:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80243b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  802440:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802443:	8b 55 08             	mov    0x8(%ebp),%edx
  802446:	8b 52 0c             	mov    0xc(%edx),%edx
  802449:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  80244f:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf,buf,n);
  802454:	50                   	push   %eax
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	68 08 60 80 00       	push   $0x806008
  80245d:	e8 de ef ff ff       	call   801440 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802462:	ba 00 00 00 00       	mov    $0x0,%edx
  802467:	b8 04 00 00 00       	mov    $0x4,%eax
  80246c:	e8 ba fe ff ff       	call   80232b <fsipc>
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <devfile_read>:
{
  802473:	f3 0f 1e fb          	endbr32 
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	56                   	push   %esi
  80247b:	53                   	push   %ebx
  80247c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8b 40 0c             	mov    0xc(%eax),%eax
  802485:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80248a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802490:	ba 00 00 00 00       	mov    $0x0,%edx
  802495:	b8 03 00 00 00       	mov    $0x3,%eax
  80249a:	e8 8c fe ff ff       	call   80232b <fsipc>
  80249f:	89 c3                	mov    %eax,%ebx
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	78 1f                	js     8024c4 <devfile_read+0x51>
	assert(r <= n);
  8024a5:	39 f0                	cmp    %esi,%eax
  8024a7:	77 24                	ja     8024cd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8024a9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024ae:	7f 33                	jg     8024e3 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	50                   	push   %eax
  8024b4:	68 00 60 80 00       	push   $0x806000
  8024b9:	ff 75 0c             	pushl  0xc(%ebp)
  8024bc:	e8 7f ef ff ff       	call   801440 <memmove>
	return r;
  8024c1:	83 c4 10             	add    $0x10,%esp
}
  8024c4:	89 d8                	mov    %ebx,%eax
  8024c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024c9:	5b                   	pop    %ebx
  8024ca:	5e                   	pop    %esi
  8024cb:	5d                   	pop    %ebp
  8024cc:	c3                   	ret    
	assert(r <= n);
  8024cd:	68 68 3c 80 00       	push   $0x803c68
  8024d2:	68 34 36 80 00       	push   $0x803634
  8024d7:	6a 7d                	push   $0x7d
  8024d9:	68 6f 3c 80 00       	push   $0x803c6f
  8024de:	e8 c2 e5 ff ff       	call   800aa5 <_panic>
	assert(r <= PGSIZE);
  8024e3:	68 7a 3c 80 00       	push   $0x803c7a
  8024e8:	68 34 36 80 00       	push   $0x803634
  8024ed:	6a 7e                	push   $0x7e
  8024ef:	68 6f 3c 80 00       	push   $0x803c6f
  8024f4:	e8 ac e5 ff ff       	call   800aa5 <_panic>

008024f9 <open>:
{
  8024f9:	f3 0f 1e fb          	endbr32 
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
  802500:	56                   	push   %esi
  802501:	53                   	push   %ebx
  802502:	83 ec 1c             	sub    $0x1c,%esp
  802505:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802508:	56                   	push   %esi
  802509:	e8 39 ed ff ff       	call   801247 <strlen>
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802516:	7f 6c                	jg     802584 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251e:	50                   	push   %eax
  80251f:	e8 67 f8 ff ff       	call   801d8b <fd_alloc>
  802524:	89 c3                	mov    %eax,%ebx
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	85 c0                	test   %eax,%eax
  80252b:	78 3c                	js     802569 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80252d:	83 ec 08             	sub    $0x8,%esp
  802530:	56                   	push   %esi
  802531:	68 00 60 80 00       	push   $0x806000
  802536:	e8 4f ed ff ff       	call   80128a <strcpy>
	fsipcbuf.open.req_omode = mode;
  80253b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	b8 01 00 00 00       	mov    $0x1,%eax
  80254b:	e8 db fd ff ff       	call   80232b <fsipc>
  802550:	89 c3                	mov    %eax,%ebx
  802552:	83 c4 10             	add    $0x10,%esp
  802555:	85 c0                	test   %eax,%eax
  802557:	78 19                	js     802572 <open+0x79>
	return fd2num(fd);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	ff 75 f4             	pushl  -0xc(%ebp)
  80255f:	e8 f8 f7 ff ff       	call   801d5c <fd2num>
  802564:	89 c3                	mov    %eax,%ebx
  802566:	83 c4 10             	add    $0x10,%esp
}
  802569:	89 d8                	mov    %ebx,%eax
  80256b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80256e:	5b                   	pop    %ebx
  80256f:	5e                   	pop    %esi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    
		fd_close(fd, 0);
  802572:	83 ec 08             	sub    $0x8,%esp
  802575:	6a 00                	push   $0x0
  802577:	ff 75 f4             	pushl  -0xc(%ebp)
  80257a:	e8 10 f9 ff ff       	call   801e8f <fd_close>
		return r;
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	eb e5                	jmp    802569 <open+0x70>
		return -E_BAD_PATH;
  802584:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802589:	eb de                	jmp    802569 <open+0x70>

0080258b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80258b:	f3 0f 1e fb          	endbr32 
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802595:	ba 00 00 00 00       	mov    $0x0,%edx
  80259a:	b8 08 00 00 00       	mov    $0x8,%eax
  80259f:	e8 87 fd ff ff       	call   80232b <fsipc>
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8025a6:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8025aa:	7f 01                	jg     8025ad <writebuf+0x7>
  8025ac:	c3                   	ret    
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	53                   	push   %ebx
  8025b1:	83 ec 08             	sub    $0x8,%esp
  8025b4:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8025b6:	ff 70 04             	pushl  0x4(%eax)
  8025b9:	8d 40 10             	lea    0x10(%eax),%eax
  8025bc:	50                   	push   %eax
  8025bd:	ff 33                	pushl  (%ebx)
  8025bf:	e8 76 fb ff ff       	call   80213a <write>
		if (result > 0)
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	7e 03                	jle    8025ce <writebuf+0x28>
			b->result += result;
  8025cb:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8025ce:	39 43 04             	cmp    %eax,0x4(%ebx)
  8025d1:	74 0d                	je     8025e0 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025da:	0f 4f c2             	cmovg  %edx,%eax
  8025dd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8025e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <putch>:

static void
putch(int ch, void *thunk)
{
  8025e5:	f3 0f 1e fb          	endbr32 
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	53                   	push   %ebx
  8025ed:	83 ec 04             	sub    $0x4,%esp
  8025f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8025f3:	8b 53 04             	mov    0x4(%ebx),%edx
  8025f6:	8d 42 01             	lea    0x1(%edx),%eax
  8025f9:	89 43 04             	mov    %eax,0x4(%ebx)
  8025fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ff:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802603:	3d 00 01 00 00       	cmp    $0x100,%eax
  802608:	74 06                	je     802610 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  80260a:	83 c4 04             	add    $0x4,%esp
  80260d:	5b                   	pop    %ebx
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
		writebuf(b);
  802610:	89 d8                	mov    %ebx,%eax
  802612:	e8 8f ff ff ff       	call   8025a6 <writebuf>
		b->idx = 0;
  802617:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80261e:	eb ea                	jmp    80260a <putch+0x25>

00802620 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802620:	f3 0f 1e fb          	endbr32 
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80262d:	8b 45 08             	mov    0x8(%ebp),%eax
  802630:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802636:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80263d:	00 00 00 
	b.result = 0;
  802640:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802647:	00 00 00 
	b.error = 1;
  80264a:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802651:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802654:	ff 75 10             	pushl  0x10(%ebp)
  802657:	ff 75 0c             	pushl  0xc(%ebp)
  80265a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802660:	50                   	push   %eax
  802661:	68 e5 25 80 00       	push   $0x8025e5
  802666:	e8 24 e6 ff ff       	call   800c8f <vprintfmt>
	if (b.idx > 0)
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802675:	7f 11                	jg     802688 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802677:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    
		writebuf(&b);
  802688:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80268e:	e8 13 ff ff ff       	call   8025a6 <writebuf>
  802693:	eb e2                	jmp    802677 <vfprintf+0x57>

00802695 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802695:	f3 0f 1e fb          	endbr32 
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80269f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8026a2:	50                   	push   %eax
  8026a3:	ff 75 0c             	pushl  0xc(%ebp)
  8026a6:	ff 75 08             	pushl  0x8(%ebp)
  8026a9:	e8 72 ff ff ff       	call   802620 <vfprintf>
	va_end(ap);

	return cnt;
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <printf>:

int
printf(const char *fmt, ...)
{
  8026b0:	f3 0f 1e fb          	endbr32 
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8026ba:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8026bd:	50                   	push   %eax
  8026be:	ff 75 08             	pushl  0x8(%ebp)
  8026c1:	6a 01                	push   $0x1
  8026c3:	e8 58 ff ff ff       	call   802620 <vfprintf>
	va_end(ap);

	return cnt;
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8026ca:	f3 0f 1e fb          	endbr32 
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	//cprintf("spawn start\n");
	if ((r = open(prog, O_RDONLY)) < 0)
  8026da:	6a 00                	push   $0x0
  8026dc:	ff 75 08             	pushl  0x8(%ebp)
  8026df:	e8 15 fe ff ff       	call   8024f9 <open>
  8026e4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8026ea:	83 c4 10             	add    $0x10,%esp
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 88 e9 04 00 00    	js     802bde <spawn+0x514>
  8026f5:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;
	
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	68 00 02 00 00       	push   $0x200
  8026ff:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802705:	50                   	push   %eax
  802706:	51                   	push   %ecx
  802707:	e8 e3 f9 ff ff       	call   8020ef <readn>
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	3d 00 02 00 00       	cmp    $0x200,%eax
  802714:	75 7e                	jne    802794 <spawn+0xca>
	    || elf->e_magic != ELF_MAGIC) {
  802716:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80271d:	45 4c 46 
  802720:	75 72                	jne    802794 <spawn+0xca>
  802722:	b8 07 00 00 00       	mov    $0x7,%eax
  802727:	cd 30                	int    $0x30
  802729:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80272f:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802735:	85 c0                	test   %eax,%eax
  802737:	0f 88 95 04 00 00    	js     802bd2 <spawn+0x508>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80273d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802742:	6b f0 7c             	imul   $0x7c,%eax,%esi
  802745:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80274b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802751:	b9 11 00 00 00       	mov    $0x11,%ecx
  802756:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802758:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80275e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	char *string_store;
	uintptr_t *argv_store;
	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802764:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802769:	be 00 00 00 00       	mov    $0x0,%esi
  80276e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802771:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  802778:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	74 4d                	je     8027cc <spawn+0x102>
		string_size += strlen(argv[argc]) + 1;
  80277f:	83 ec 0c             	sub    $0xc,%esp
  802782:	50                   	push   %eax
  802783:	e8 bf ea ff ff       	call   801247 <strlen>
  802788:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80278c:	83 c3 01             	add    $0x1,%ebx
  80278f:	83 c4 10             	add    $0x10,%esp
  802792:	eb dd                	jmp    802771 <spawn+0xa7>
		close(fd);
  802794:	83 ec 0c             	sub    $0xc,%esp
  802797:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80279d:	e8 78 f7 ff ff       	call   801f1a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8027a2:	83 c4 0c             	add    $0xc,%esp
  8027a5:	68 7f 45 4c 46       	push   $0x464c457f
  8027aa:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8027b0:	68 86 3c 80 00       	push   $0x803c86
  8027b5:	e8 d2 e3 ff ff       	call   800b8c <cprintf>
		return -E_NOT_EXEC;
  8027ba:	83 c4 10             	add    $0x10,%esp
  8027bd:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8027c4:	ff ff ff 
  8027c7:	e9 12 04 00 00       	jmp    802bde <spawn+0x514>
  8027cc:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8027d2:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8027d8:	bf 00 10 40 00       	mov    $0x401000,%edi
  8027dd:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8027df:	89 fa                	mov    %edi,%edx
  8027e1:	83 e2 fc             	and    $0xfffffffc,%edx
  8027e4:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8027eb:	29 c2                	sub    %eax,%edx
  8027ed:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8027f3:	8d 42 f8             	lea    -0x8(%edx),%eax
  8027f6:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8027fb:	0f 86 00 04 00 00    	jbe    802c01 <spawn+0x537>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	6a 07                	push   $0x7
  802806:	68 00 00 40 00       	push   $0x400000
  80280b:	6a 00                	push   $0x0
  80280d:	e8 ba ee ff ff       	call   8016cc <sys_page_alloc>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	85 c0                	test   %eax,%eax
  802817:	0f 88 e9 03 00 00    	js     802c06 <spawn+0x53c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)

	for (i = 0; i < argc; i++) {
  80281d:	be 00 00 00 00       	mov    $0x0,%esi
  802822:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802828:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80282b:	eb 30                	jmp    80285d <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
  80282d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802833:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802839:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80283c:	83 ec 08             	sub    $0x8,%esp
  80283f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802842:	57                   	push   %edi
  802843:	e8 42 ea ff ff       	call   80128a <strcpy>
		string_store += strlen(argv[i]) + 1;
  802848:	83 c4 04             	add    $0x4,%esp
  80284b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80284e:	e8 f4 e9 ff ff       	call   801247 <strlen>
  802853:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802857:	83 c6 01             	add    $0x1,%esi
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802863:	7f c8                	jg     80282d <spawn+0x163>
	}

	argv_store[argc] = 0;
  802865:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80286b:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802871:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802878:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80287e:	0f 85 82 00 00 00    	jne    802906 <spawn+0x23c>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802884:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80288a:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  802890:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802893:	89 c8                	mov    %ecx,%eax
  802895:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  80289b:	89 51 f8             	mov    %edx,-0x8(%ecx)
	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80289e:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8028a3:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8028a9:	83 ec 0c             	sub    $0xc,%esp
  8028ac:	6a 07                	push   $0x7
  8028ae:	68 00 d0 bf ee       	push   $0xeebfd000
  8028b3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8028b9:	68 00 00 40 00       	push   $0x400000
  8028be:	6a 00                	push   $0x0
  8028c0:	e8 4e ee ff ff       	call   801713 <sys_page_map>
  8028c5:	83 c4 20             	add    $0x20,%esp
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	0f 88 41 03 00 00    	js     802c11 <spawn+0x547>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8028d0:	83 ec 08             	sub    $0x8,%esp
  8028d3:	68 00 00 40 00       	push   $0x400000
  8028d8:	6a 00                	push   $0x0
  8028da:	e8 7a ee ff ff       	call   801759 <sys_page_unmap>
  8028df:	83 c4 10             	add    $0x10,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	0f 88 27 03 00 00    	js     802c11 <spawn+0x547>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8028ea:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8028f0:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8028f7:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8028fe:	00 00 00 
  802901:	e9 4f 01 00 00       	jmp    802a55 <spawn+0x38b>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802906:	68 fc 3c 80 00       	push   $0x803cfc
  80290b:	68 34 36 80 00       	push   $0x803634
  802910:	68 ea 00 00 00       	push   $0xea
  802915:	68 a0 3c 80 00       	push   $0x803ca0
  80291a:	e8 86 e1 ff ff       	call   800aa5 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	6a 07                	push   $0x7
  802924:	68 00 00 40 00       	push   $0x400000
  802929:	6a 00                	push   $0x0
  80292b:	e8 9c ed ff ff       	call   8016cc <sys_page_alloc>
  802930:	83 c4 10             	add    $0x10,%esp
  802933:	85 c0                	test   %eax,%eax
  802935:	0f 88 b1 02 00 00    	js     802bec <spawn+0x522>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80293b:	83 ec 08             	sub    $0x8,%esp
  80293e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802944:	01 f0                	add    %esi,%eax
  802946:	50                   	push   %eax
  802947:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80294d:	e8 6e f8 ff ff       	call   8021c0 <seek>
  802952:	83 c4 10             	add    $0x10,%esp
  802955:	85 c0                	test   %eax,%eax
  802957:	0f 88 96 02 00 00    	js     802bf3 <spawn+0x529>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802966:	29 f0                	sub    %esi,%eax
  802968:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80296d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802972:	0f 47 c1             	cmova  %ecx,%eax
  802975:	50                   	push   %eax
  802976:	68 00 00 40 00       	push   $0x400000
  80297b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802981:	e8 69 f7 ff ff       	call   8020ef <readn>
  802986:	83 c4 10             	add    $0x10,%esp
  802989:	85 c0                	test   %eax,%eax
  80298b:	0f 88 69 02 00 00    	js     802bfa <spawn+0x530>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802991:	83 ec 0c             	sub    $0xc,%esp
  802994:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80299a:	53                   	push   %ebx
  80299b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8029a1:	68 00 00 40 00       	push   $0x400000
  8029a6:	6a 00                	push   $0x0
  8029a8:	e8 66 ed ff ff       	call   801713 <sys_page_map>
  8029ad:	83 c4 20             	add    $0x20,%esp
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	78 7c                	js     802a30 <spawn+0x366>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8029b4:	83 ec 08             	sub    $0x8,%esp
  8029b7:	68 00 00 40 00       	push   $0x400000
  8029bc:	6a 00                	push   $0x0
  8029be:	e8 96 ed ff ff       	call   801759 <sys_page_unmap>
  8029c3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8029c6:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8029cc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8029d2:	89 fe                	mov    %edi,%esi
  8029d4:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8029da:	76 69                	jbe    802a45 <spawn+0x37b>
		if (i >= filesz) {
  8029dc:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8029e2:	0f 87 37 ff ff ff    	ja     80291f <spawn+0x255>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8029f1:	53                   	push   %ebx
  8029f2:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8029f8:	e8 cf ec ff ff       	call   8016cc <sys_page_alloc>
  8029fd:	83 c4 10             	add    $0x10,%esp
  802a00:	85 c0                	test   %eax,%eax
  802a02:	79 c2                	jns    8029c6 <spawn+0x2fc>
  802a04:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802a06:	83 ec 0c             	sub    $0xc,%esp
  802a09:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802a0f:	e8 2d ec ff ff       	call   801641 <sys_env_destroy>
	close(fd);
  802a14:	83 c4 04             	add    $0x4,%esp
  802a17:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a1d:	e8 f8 f4 ff ff       	call   801f1a <close>
	return r;
  802a22:	83 c4 10             	add    $0x10,%esp
  802a25:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802a2b:	e9 ae 01 00 00       	jmp    802bde <spawn+0x514>
				panic("spawn: sys_page_map data: %e", r);
  802a30:	50                   	push   %eax
  802a31:	68 ac 3c 80 00       	push   $0x803cac
  802a36:	68 1b 01 00 00       	push   $0x11b
  802a3b:	68 a0 3c 80 00       	push   $0x803ca0
  802a40:	e8 60 e0 ff ff       	call   800aa5 <_panic>
  802a45:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802a4b:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802a52:	83 c6 20             	add    $0x20,%esi
  802a55:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802a5c:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802a62:	7e 6d                	jle    802ad1 <spawn+0x407>
		if (ph->p_type != ELF_PROG_LOAD)
  802a64:	83 3e 01             	cmpl   $0x1,(%esi)
  802a67:	75 e2                	jne    802a4b <spawn+0x381>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802a69:	8b 46 18             	mov    0x18(%esi),%eax
  802a6c:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802a6f:	83 f8 01             	cmp    $0x1,%eax
  802a72:	19 c0                	sbb    %eax,%eax
  802a74:	83 e0 fe             	and    $0xfffffffe,%eax
  802a77:	83 c0 07             	add    $0x7,%eax
  802a7a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a80:	8b 4e 04             	mov    0x4(%esi),%ecx
  802a83:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802a89:	8b 56 10             	mov    0x10(%esi),%edx
  802a8c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802a92:	8b 7e 14             	mov    0x14(%esi),%edi
  802a95:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802a9b:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802a9e:	89 d8                	mov    %ebx,%eax
  802aa0:	25 ff 0f 00 00       	and    $0xfff,%eax
  802aa5:	74 1a                	je     802ac1 <spawn+0x3f7>
		va -= i;
  802aa7:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802aa9:	01 c7                	add    %eax,%edi
  802aab:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802ab1:	01 c2                	add    %eax,%edx
  802ab3:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802ab9:	29 c1                	sub    %eax,%ecx
  802abb:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac6:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802acc:	e9 01 ff ff ff       	jmp    8029d2 <spawn+0x308>
	close(fd);
  802ad1:	83 ec 0c             	sub    $0xc,%esp
  802ad4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802ada:	e8 3b f4 ff ff       	call   801f1a <close>
  802adf:	83 c4 10             	add    $0x10,%esp
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	uint32_t addr;
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  802ae2:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802ae7:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802aed:	eb 33                	jmp    802b22 <spawn+0x458>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
		sys_page_map(thisenv->env_id,(void *)addr,child,(void *)addr,(uvpt[PGNUM(addr)] & PTE_SYSCALL));
  802aef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802af6:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802afc:	8b 52 48             	mov    0x48(%edx),%edx
  802aff:	83 ec 0c             	sub    $0xc,%esp
  802b02:	25 07 0e 00 00       	and    $0xe07,%eax
  802b07:	50                   	push   %eax
  802b08:	53                   	push   %ebx
  802b09:	56                   	push   %esi
  802b0a:	53                   	push   %ebx
  802b0b:	52                   	push   %edx
  802b0c:	e8 02 ec ff ff       	call   801713 <sys_page_map>
  802b11:	83 c4 20             	add    $0x20,%esp
	for (addr =UTEXT; addr<USTACKTOP; addr += PGSIZE){
  802b14:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802b1a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802b20:	74 3b                	je     802b5d <spawn+0x493>
		if((uvpd[PDX(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]&PTE_P)&&(uvpt[PGNUM(addr)]& PTE_U)&&(uvpt[PGNUM(addr)]&PTE_SHARE))
  802b22:	89 d8                	mov    %ebx,%eax
  802b24:	c1 e8 16             	shr    $0x16,%eax
  802b27:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b2e:	a8 01                	test   $0x1,%al
  802b30:	74 e2                	je     802b14 <spawn+0x44a>
  802b32:	89 d8                	mov    %ebx,%eax
  802b34:	c1 e8 0c             	shr    $0xc,%eax
  802b37:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b3e:	f6 c2 01             	test   $0x1,%dl
  802b41:	74 d1                	je     802b14 <spawn+0x44a>
  802b43:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b4a:	f6 c2 04             	test   $0x4,%dl
  802b4d:	74 c5                	je     802b14 <spawn+0x44a>
  802b4f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b56:	f6 c6 04             	test   $0x4,%dh
  802b59:	74 b9                	je     802b14 <spawn+0x44a>
  802b5b:	eb 92                	jmp    802aef <spawn+0x425>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802b5d:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802b64:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b67:	83 ec 08             	sub    $0x8,%esp
  802b6a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802b70:	50                   	push   %eax
  802b71:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b77:	e8 69 ec ff ff       	call   8017e5 <sys_env_set_trapframe>
  802b7c:	83 c4 10             	add    $0x10,%esp
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	78 25                	js     802ba8 <spawn+0x4de>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b83:	83 ec 08             	sub    $0x8,%esp
  802b86:	6a 02                	push   $0x2
  802b88:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b8e:	e8 0c ec ff ff       	call   80179f <sys_env_set_status>
  802b93:	83 c4 10             	add    $0x10,%esp
  802b96:	85 c0                	test   %eax,%eax
  802b98:	78 23                	js     802bbd <spawn+0x4f3>
	return child;
  802b9a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802ba0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802ba6:	eb 36                	jmp    802bde <spawn+0x514>
		panic("sys_env_set_trapframe: %e", r);
  802ba8:	50                   	push   %eax
  802ba9:	68 c9 3c 80 00       	push   $0x803cc9
  802bae:	68 82 00 00 00       	push   $0x82
  802bb3:	68 a0 3c 80 00       	push   $0x803ca0
  802bb8:	e8 e8 de ff ff       	call   800aa5 <_panic>
		panic("sys_env_set_status: %e", r);
  802bbd:	50                   	push   %eax
  802bbe:	68 e3 3c 80 00       	push   $0x803ce3
  802bc3:	68 84 00 00 00       	push   $0x84
  802bc8:	68 a0 3c 80 00       	push   $0x803ca0
  802bcd:	e8 d3 de ff ff       	call   800aa5 <_panic>
		return r;
  802bd2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802bd8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802bde:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802be7:	5b                   	pop    %ebx
  802be8:	5e                   	pop    %esi
  802be9:	5f                   	pop    %edi
  802bea:	5d                   	pop    %ebp
  802beb:	c3                   	ret    
  802bec:	89 c7                	mov    %eax,%edi
  802bee:	e9 13 fe ff ff       	jmp    802a06 <spawn+0x33c>
  802bf3:	89 c7                	mov    %eax,%edi
  802bf5:	e9 0c fe ff ff       	jmp    802a06 <spawn+0x33c>
  802bfa:	89 c7                	mov    %eax,%edi
  802bfc:	e9 05 fe ff ff       	jmp    802a06 <spawn+0x33c>
		return -E_NO_MEM;
  802c01:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  802c06:	c1 e8 1f             	shr    $0x1f,%eax
  802c09:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c0f:	eb cd                	jmp    802bde <spawn+0x514>
	sys_page_unmap(0, UTEMP);
  802c11:	83 ec 08             	sub    $0x8,%esp
  802c14:	68 00 00 40 00       	push   $0x400000
  802c19:	6a 00                	push   $0x0
  802c1b:	e8 39 eb ff ff       	call   801759 <sys_page_unmap>
  802c20:	83 c4 10             	add    $0x10,%esp
	if ((r = init_stack(child, argv, ROUNDDOWN(&child_tf.tf_esp,sizeof(uintptr_t))) < 0))//&child_tf.tf_esp error?why?
  802c23:	c7 85 94 fd ff ff 01 	movl   $0x1,-0x26c(%ebp)
  802c2a:	00 00 00 
  802c2d:	eb af                	jmp    802bde <spawn+0x514>

00802c2f <spawnl>:
{
  802c2f:	f3 0f 1e fb          	endbr32 
  802c33:	55                   	push   %ebp
  802c34:	89 e5                	mov    %esp,%ebp
  802c36:	57                   	push   %edi
  802c37:	56                   	push   %esi
  802c38:	53                   	push   %ebx
  802c39:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c3c:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802c3f:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802c44:	8d 4a 04             	lea    0x4(%edx),%ecx
  802c47:	83 3a 00             	cmpl   $0x0,(%edx)
  802c4a:	74 07                	je     802c53 <spawnl+0x24>
		argc++;
  802c4c:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802c4f:	89 ca                	mov    %ecx,%edx
  802c51:	eb f1                	jmp    802c44 <spawnl+0x15>
	const char *argv[argc+2];
  802c53:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802c5a:	89 d1                	mov    %edx,%ecx
  802c5c:	83 e1 f0             	and    $0xfffffff0,%ecx
  802c5f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802c65:	89 e6                	mov    %esp,%esi
  802c67:	29 d6                	sub    %edx,%esi
  802c69:	89 f2                	mov    %esi,%edx
  802c6b:	39 d4                	cmp    %edx,%esp
  802c6d:	74 10                	je     802c7f <spawnl+0x50>
  802c6f:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  802c75:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802c7c:	00 
  802c7d:	eb ec                	jmp    802c6b <spawnl+0x3c>
  802c7f:	89 ca                	mov    %ecx,%edx
  802c81:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802c87:	29 d4                	sub    %edx,%esp
  802c89:	85 d2                	test   %edx,%edx
  802c8b:	74 05                	je     802c92 <spawnl+0x63>
  802c8d:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802c92:	8d 74 24 03          	lea    0x3(%esp),%esi
  802c96:	89 f2                	mov    %esi,%edx
  802c98:	c1 ea 02             	shr    $0x2,%edx
  802c9b:	83 e6 fc             	and    $0xfffffffc,%esi
  802c9e:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ca3:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802caa:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802cb1:	00 
	va_start(vl, arg0);
  802cb2:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802cb5:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbc:	eb 0b                	jmp    802cc9 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802cbe:	83 c0 01             	add    $0x1,%eax
  802cc1:	8b 39                	mov    (%ecx),%edi
  802cc3:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802cc6:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802cc9:	39 d0                	cmp    %edx,%eax
  802ccb:	75 f1                	jne    802cbe <spawnl+0x8f>
	return spawn(prog, argv);
  802ccd:	83 ec 08             	sub    $0x8,%esp
  802cd0:	56                   	push   %esi
  802cd1:	ff 75 08             	pushl  0x8(%ebp)
  802cd4:	e8 f1 f9 ff ff       	call   8026ca <spawn>
}
  802cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cdc:	5b                   	pop    %ebx
  802cdd:	5e                   	pop    %esi
  802cde:	5f                   	pop    %edi
  802cdf:	5d                   	pop    %ebp
  802ce0:	c3                   	ret    

00802ce1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ce1:	f3 0f 1e fb          	endbr32 
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	56                   	push   %esi
  802ce9:	53                   	push   %ebx
  802cea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ced:	83 ec 0c             	sub    $0xc,%esp
  802cf0:	ff 75 08             	pushl  0x8(%ebp)
  802cf3:	e8 78 f0 ff ff       	call   801d70 <fd2data>
  802cf8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802cfa:	83 c4 08             	add    $0x8,%esp
  802cfd:	68 22 3d 80 00       	push   $0x803d22
  802d02:	53                   	push   %ebx
  802d03:	e8 82 e5 ff ff       	call   80128a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802d08:	8b 46 04             	mov    0x4(%esi),%eax
  802d0b:	2b 06                	sub    (%esi),%eax
  802d0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802d13:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802d1a:	00 00 00 
	stat->st_dev = &devpipe;
  802d1d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802d24:	40 80 00 
	return 0;
}
  802d27:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d2f:	5b                   	pop    %ebx
  802d30:	5e                   	pop    %esi
  802d31:	5d                   	pop    %ebp
  802d32:	c3                   	ret    

00802d33 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802d33:	f3 0f 1e fb          	endbr32 
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
  802d3a:	53                   	push   %ebx
  802d3b:	83 ec 0c             	sub    $0xc,%esp
  802d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802d41:	53                   	push   %ebx
  802d42:	6a 00                	push   $0x0
  802d44:	e8 10 ea ff ff       	call   801759 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802d49:	89 1c 24             	mov    %ebx,(%esp)
  802d4c:	e8 1f f0 ff ff       	call   801d70 <fd2data>
  802d51:	83 c4 08             	add    $0x8,%esp
  802d54:	50                   	push   %eax
  802d55:	6a 00                	push   $0x0
  802d57:	e8 fd e9 ff ff       	call   801759 <sys_page_unmap>
}
  802d5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <_pipeisclosed>:
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	57                   	push   %edi
  802d65:	56                   	push   %esi
  802d66:	53                   	push   %ebx
  802d67:	83 ec 1c             	sub    $0x1c,%esp
  802d6a:	89 c7                	mov    %eax,%edi
  802d6c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802d6e:	a1 24 54 80 00       	mov    0x805424,%eax
  802d73:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d76:	83 ec 0c             	sub    $0xc,%esp
  802d79:	57                   	push   %edi
  802d7a:	e8 bf 04 00 00       	call   80323e <pageref>
  802d7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802d82:	89 34 24             	mov    %esi,(%esp)
  802d85:	e8 b4 04 00 00       	call   80323e <pageref>
		nn = thisenv->env_runs;
  802d8a:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802d90:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802d93:	83 c4 10             	add    $0x10,%esp
  802d96:	39 cb                	cmp    %ecx,%ebx
  802d98:	74 1b                	je     802db5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802d9a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802d9d:	75 cf                	jne    802d6e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d9f:	8b 42 58             	mov    0x58(%edx),%eax
  802da2:	6a 01                	push   $0x1
  802da4:	50                   	push   %eax
  802da5:	53                   	push   %ebx
  802da6:	68 29 3d 80 00       	push   $0x803d29
  802dab:	e8 dc dd ff ff       	call   800b8c <cprintf>
  802db0:	83 c4 10             	add    $0x10,%esp
  802db3:	eb b9                	jmp    802d6e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802db5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802db8:	0f 94 c0             	sete   %al
  802dbb:	0f b6 c0             	movzbl %al,%eax
}
  802dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dc1:	5b                   	pop    %ebx
  802dc2:	5e                   	pop    %esi
  802dc3:	5f                   	pop    %edi
  802dc4:	5d                   	pop    %ebp
  802dc5:	c3                   	ret    

00802dc6 <devpipe_write>:
{
  802dc6:	f3 0f 1e fb          	endbr32 
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
  802dcd:	57                   	push   %edi
  802dce:	56                   	push   %esi
  802dcf:	53                   	push   %ebx
  802dd0:	83 ec 28             	sub    $0x28,%esp
  802dd3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802dd6:	56                   	push   %esi
  802dd7:	e8 94 ef ff ff       	call   801d70 <fd2data>
  802ddc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802dde:	83 c4 10             	add    $0x10,%esp
  802de1:	bf 00 00 00 00       	mov    $0x0,%edi
  802de6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802de9:	74 4f                	je     802e3a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802deb:	8b 43 04             	mov    0x4(%ebx),%eax
  802dee:	8b 0b                	mov    (%ebx),%ecx
  802df0:	8d 51 20             	lea    0x20(%ecx),%edx
  802df3:	39 d0                	cmp    %edx,%eax
  802df5:	72 14                	jb     802e0b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802df7:	89 da                	mov    %ebx,%edx
  802df9:	89 f0                	mov    %esi,%eax
  802dfb:	e8 61 ff ff ff       	call   802d61 <_pipeisclosed>
  802e00:	85 c0                	test   %eax,%eax
  802e02:	75 3b                	jne    802e3f <devpipe_write+0x79>
			sys_yield();
  802e04:	e8 a0 e8 ff ff       	call   8016a9 <sys_yield>
  802e09:	eb e0                	jmp    802deb <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e0e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802e12:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802e15:	89 c2                	mov    %eax,%edx
  802e17:	c1 fa 1f             	sar    $0x1f,%edx
  802e1a:	89 d1                	mov    %edx,%ecx
  802e1c:	c1 e9 1b             	shr    $0x1b,%ecx
  802e1f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802e22:	83 e2 1f             	and    $0x1f,%edx
  802e25:	29 ca                	sub    %ecx,%edx
  802e27:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802e2b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802e2f:	83 c0 01             	add    $0x1,%eax
  802e32:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802e35:	83 c7 01             	add    $0x1,%edi
  802e38:	eb ac                	jmp    802de6 <devpipe_write+0x20>
	return i;
  802e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  802e3d:	eb 05                	jmp    802e44 <devpipe_write+0x7e>
				return 0;
  802e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e47:	5b                   	pop    %ebx
  802e48:	5e                   	pop    %esi
  802e49:	5f                   	pop    %edi
  802e4a:	5d                   	pop    %ebp
  802e4b:	c3                   	ret    

00802e4c <devpipe_read>:
{
  802e4c:	f3 0f 1e fb          	endbr32 
  802e50:	55                   	push   %ebp
  802e51:	89 e5                	mov    %esp,%ebp
  802e53:	57                   	push   %edi
  802e54:	56                   	push   %esi
  802e55:	53                   	push   %ebx
  802e56:	83 ec 18             	sub    $0x18,%esp
  802e59:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802e5c:	57                   	push   %edi
  802e5d:	e8 0e ef ff ff       	call   801d70 <fd2data>
  802e62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802e64:	83 c4 10             	add    $0x10,%esp
  802e67:	be 00 00 00 00       	mov    $0x0,%esi
  802e6c:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e6f:	75 14                	jne    802e85 <devpipe_read+0x39>
	return i;
  802e71:	8b 45 10             	mov    0x10(%ebp),%eax
  802e74:	eb 02                	jmp    802e78 <devpipe_read+0x2c>
				return i;
  802e76:	89 f0                	mov    %esi,%eax
}
  802e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e7b:	5b                   	pop    %ebx
  802e7c:	5e                   	pop    %esi
  802e7d:	5f                   	pop    %edi
  802e7e:	5d                   	pop    %ebp
  802e7f:	c3                   	ret    
			sys_yield();
  802e80:	e8 24 e8 ff ff       	call   8016a9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802e85:	8b 03                	mov    (%ebx),%eax
  802e87:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e8a:	75 18                	jne    802ea4 <devpipe_read+0x58>
			if (i > 0)
  802e8c:	85 f6                	test   %esi,%esi
  802e8e:	75 e6                	jne    802e76 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802e90:	89 da                	mov    %ebx,%edx
  802e92:	89 f8                	mov    %edi,%eax
  802e94:	e8 c8 fe ff ff       	call   802d61 <_pipeisclosed>
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 e3                	je     802e80 <devpipe_read+0x34>
				return 0;
  802e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea2:	eb d4                	jmp    802e78 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ea4:	99                   	cltd   
  802ea5:	c1 ea 1b             	shr    $0x1b,%edx
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	83 e0 1f             	and    $0x1f,%eax
  802ead:	29 d0                	sub    %edx,%eax
  802eaf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802eb7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802eba:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ebd:	83 c6 01             	add    $0x1,%esi
  802ec0:	eb aa                	jmp    802e6c <devpipe_read+0x20>

00802ec2 <pipe>:
{
  802ec2:	f3 0f 1e fb          	endbr32 
  802ec6:	55                   	push   %ebp
  802ec7:	89 e5                	mov    %esp,%ebp
  802ec9:	56                   	push   %esi
  802eca:	53                   	push   %ebx
  802ecb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802ece:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ed1:	50                   	push   %eax
  802ed2:	e8 b4 ee ff ff       	call   801d8b <fd_alloc>
  802ed7:	89 c3                	mov    %eax,%ebx
  802ed9:	83 c4 10             	add    $0x10,%esp
  802edc:	85 c0                	test   %eax,%eax
  802ede:	0f 88 23 01 00 00    	js     803007 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	68 07 04 00 00       	push   $0x407
  802eec:	ff 75 f4             	pushl  -0xc(%ebp)
  802eef:	6a 00                	push   $0x0
  802ef1:	e8 d6 e7 ff ff       	call   8016cc <sys_page_alloc>
  802ef6:	89 c3                	mov    %eax,%ebx
  802ef8:	83 c4 10             	add    $0x10,%esp
  802efb:	85 c0                	test   %eax,%eax
  802efd:	0f 88 04 01 00 00    	js     803007 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802f03:	83 ec 0c             	sub    $0xc,%esp
  802f06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f09:	50                   	push   %eax
  802f0a:	e8 7c ee ff ff       	call   801d8b <fd_alloc>
  802f0f:	89 c3                	mov    %eax,%ebx
  802f11:	83 c4 10             	add    $0x10,%esp
  802f14:	85 c0                	test   %eax,%eax
  802f16:	0f 88 db 00 00 00    	js     802ff7 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 07 04 00 00       	push   $0x407
  802f24:	ff 75 f0             	pushl  -0x10(%ebp)
  802f27:	6a 00                	push   $0x0
  802f29:	e8 9e e7 ff ff       	call   8016cc <sys_page_alloc>
  802f2e:	89 c3                	mov    %eax,%ebx
  802f30:	83 c4 10             	add    $0x10,%esp
  802f33:	85 c0                	test   %eax,%eax
  802f35:	0f 88 bc 00 00 00    	js     802ff7 <pipe+0x135>
	va = fd2data(fd0);
  802f3b:	83 ec 0c             	sub    $0xc,%esp
  802f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  802f41:	e8 2a ee ff ff       	call   801d70 <fd2data>
  802f46:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f48:	83 c4 0c             	add    $0xc,%esp
  802f4b:	68 07 04 00 00       	push   $0x407
  802f50:	50                   	push   %eax
  802f51:	6a 00                	push   $0x0
  802f53:	e8 74 e7 ff ff       	call   8016cc <sys_page_alloc>
  802f58:	89 c3                	mov    %eax,%ebx
  802f5a:	83 c4 10             	add    $0x10,%esp
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	0f 88 82 00 00 00    	js     802fe7 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f65:	83 ec 0c             	sub    $0xc,%esp
  802f68:	ff 75 f0             	pushl  -0x10(%ebp)
  802f6b:	e8 00 ee ff ff       	call   801d70 <fd2data>
  802f70:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802f77:	50                   	push   %eax
  802f78:	6a 00                	push   $0x0
  802f7a:	56                   	push   %esi
  802f7b:	6a 00                	push   $0x0
  802f7d:	e8 91 e7 ff ff       	call   801713 <sys_page_map>
  802f82:	89 c3                	mov    %eax,%ebx
  802f84:	83 c4 20             	add    $0x20,%esp
  802f87:	85 c0                	test   %eax,%eax
  802f89:	78 4e                	js     802fd9 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802f8b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f93:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f98:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802f9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802fae:	83 ec 0c             	sub    $0xc,%esp
  802fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  802fb4:	e8 a3 ed ff ff       	call   801d5c <fd2num>
  802fb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fbc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802fbe:	83 c4 04             	add    $0x4,%esp
  802fc1:	ff 75 f0             	pushl  -0x10(%ebp)
  802fc4:	e8 93 ed ff ff       	call   801d5c <fd2num>
  802fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fcc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802fcf:	83 c4 10             	add    $0x10,%esp
  802fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  802fd7:	eb 2e                	jmp    803007 <pipe+0x145>
	sys_page_unmap(0, va);
  802fd9:	83 ec 08             	sub    $0x8,%esp
  802fdc:	56                   	push   %esi
  802fdd:	6a 00                	push   $0x0
  802fdf:	e8 75 e7 ff ff       	call   801759 <sys_page_unmap>
  802fe4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802fe7:	83 ec 08             	sub    $0x8,%esp
  802fea:	ff 75 f0             	pushl  -0x10(%ebp)
  802fed:	6a 00                	push   $0x0
  802fef:	e8 65 e7 ff ff       	call   801759 <sys_page_unmap>
  802ff4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802ff7:	83 ec 08             	sub    $0x8,%esp
  802ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  802ffd:	6a 00                	push   $0x0
  802fff:	e8 55 e7 ff ff       	call   801759 <sys_page_unmap>
  803004:	83 c4 10             	add    $0x10,%esp
}
  803007:	89 d8                	mov    %ebx,%eax
  803009:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80300c:	5b                   	pop    %ebx
  80300d:	5e                   	pop    %esi
  80300e:	5d                   	pop    %ebp
  80300f:	c3                   	ret    

00803010 <pipeisclosed>:
{
  803010:	f3 0f 1e fb          	endbr32 
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
  803017:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80301a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80301d:	50                   	push   %eax
  80301e:	ff 75 08             	pushl  0x8(%ebp)
  803021:	e8 bb ed ff ff       	call   801de1 <fd_lookup>
  803026:	83 c4 10             	add    $0x10,%esp
  803029:	85 c0                	test   %eax,%eax
  80302b:	78 18                	js     803045 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80302d:	83 ec 0c             	sub    $0xc,%esp
  803030:	ff 75 f4             	pushl  -0xc(%ebp)
  803033:	e8 38 ed ff ff       	call   801d70 <fd2data>
  803038:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	e8 1f fd ff ff       	call   802d61 <_pipeisclosed>
  803042:	83 c4 10             	add    $0x10,%esp
}
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803047:	f3 0f 1e fb          	endbr32 
  80304b:	55                   	push   %ebp
  80304c:	89 e5                	mov    %esp,%ebp
  80304e:	56                   	push   %esi
  80304f:	53                   	push   %ebx
  803050:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803053:	85 f6                	test   %esi,%esi
  803055:	74 13                	je     80306a <wait+0x23>
	e = &envs[ENVX(envid)];
  803057:	89 f3                	mov    %esi,%ebx
  803059:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80305f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803062:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  803068:	eb 1b                	jmp    803085 <wait+0x3e>
	assert(envid != 0);
  80306a:	68 41 3d 80 00       	push   $0x803d41
  80306f:	68 34 36 80 00       	push   $0x803634
  803074:	6a 09                	push   $0x9
  803076:	68 4c 3d 80 00       	push   $0x803d4c
  80307b:	e8 25 da ff ff       	call   800aa5 <_panic>
		sys_yield();
  803080:	e8 24 e6 ff ff       	call   8016a9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803085:	8b 43 48             	mov    0x48(%ebx),%eax
  803088:	39 f0                	cmp    %esi,%eax
  80308a:	75 07                	jne    803093 <wait+0x4c>
  80308c:	8b 43 54             	mov    0x54(%ebx),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	75 ed                	jne    803080 <wait+0x39>
}
  803093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803096:	5b                   	pop    %ebx
  803097:	5e                   	pop    %esi
  803098:	5d                   	pop    %ebp
  803099:	c3                   	ret    

0080309a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80309a:	f3 0f 1e fb          	endbr32 
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
  8030a1:	53                   	push   %ebx
  8030a2:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030a5:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8030ac:	74 0d                	je     8030bb <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8030b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030b9:	c9                   	leave  
  8030ba:	c3                   	ret    
		envid_t envid=sys_getenvid();
  8030bb:	e8 c6 e5 ff ff       	call   801686 <sys_getenvid>
  8030c0:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	6a 07                	push   $0x7
  8030c7:	68 00 f0 bf ee       	push   $0xeebff000
  8030cc:	50                   	push   %eax
  8030cd:	e8 fa e5 ff ff       	call   8016cc <sys_page_alloc>
  8030d2:	83 c4 10             	add    $0x10,%esp
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	78 29                	js     803102 <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  8030d9:	83 ec 08             	sub    $0x8,%esp
  8030dc:	68 16 31 80 00       	push   $0x803116
  8030e1:	53                   	push   %ebx
  8030e2:	e8 44 e7 ff ff       	call   80182b <sys_env_set_pgfault_upcall>
  8030e7:	83 c4 10             	add    $0x10,%esp
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	79 c0                	jns    8030ae <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	68 84 3d 80 00       	push   $0x803d84
  8030f6:	6a 24                	push   $0x24
  8030f8:	68 bb 3d 80 00       	push   $0x803dbb
  8030fd:	e8 a3 d9 ff ff       	call   800aa5 <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	68 58 3d 80 00       	push   $0x803d58
  80310a:	6a 22                	push   $0x22
  80310c:	68 bb 3d 80 00       	push   $0x803dbb
  803111:	e8 8f d9 ff ff       	call   800aa5 <_panic>

00803116 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803116:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803117:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80311c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80311e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  803121:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  803124:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  803128:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  80312d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  803131:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  803133:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  803134:	83 c4 04             	add    $0x4,%esp
	popfl
  803137:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803138:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803139:	c3                   	ret    

0080313a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80313a:	f3 0f 1e fb          	endbr32 
  80313e:	55                   	push   %ebp
  80313f:	89 e5                	mov    %esp,%ebp
  803141:	56                   	push   %esi
  803142:	53                   	push   %ebx
  803143:	8b 75 08             	mov    0x8(%ebp),%esi
  803146:	8b 45 0c             	mov    0xc(%ebp),%eax
  803149:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  80314c:	85 c0                	test   %eax,%eax
  80314e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803153:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  803156:	83 ec 0c             	sub    $0xc,%esp
  803159:	50                   	push   %eax
  80315a:	e8 39 e7 ff ff       	call   801898 <sys_ipc_recv>
  80315f:	83 c4 10             	add    $0x10,%esp
  803162:	85 c0                	test   %eax,%eax
  803164:	78 2b                	js     803191 <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  803166:	85 f6                	test   %esi,%esi
  803168:	74 0a                	je     803174 <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  80316a:	a1 24 54 80 00       	mov    0x805424,%eax
  80316f:	8b 40 74             	mov    0x74(%eax),%eax
  803172:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  803174:	85 db                	test   %ebx,%ebx
  803176:	74 0a                	je     803182 <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  803178:	a1 24 54 80 00       	mov    0x805424,%eax
  80317d:	8b 40 78             	mov    0x78(%eax),%eax
  803180:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  803182:	a1 24 54 80 00       	mov    0x805424,%eax
  803187:	8b 40 70             	mov    0x70(%eax),%eax
}
  80318a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80318d:	5b                   	pop    %ebx
  80318e:	5e                   	pop    %esi
  80318f:	5d                   	pop    %ebp
  803190:	c3                   	ret    
		if(from_env_store)
  803191:	85 f6                	test   %esi,%esi
  803193:	74 06                	je     80319b <ipc_recv+0x61>
			*from_env_store=0;
  803195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80319b:	85 db                	test   %ebx,%ebx
  80319d:	74 eb                	je     80318a <ipc_recv+0x50>
			*perm_store=0;
  80319f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8031a5:	eb e3                	jmp    80318a <ipc_recv+0x50>

008031a7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8031a7:	f3 0f 1e fb          	endbr32 
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
  8031ae:	57                   	push   %edi
  8031af:	56                   	push   %esi
  8031b0:	53                   	push   %ebx
  8031b1:	83 ec 0c             	sub    $0xc,%esp
  8031b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8031b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8031ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8031bd:	85 db                	test   %ebx,%ebx
  8031bf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8031c4:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8031c7:	ff 75 14             	pushl  0x14(%ebp)
  8031ca:	53                   	push   %ebx
  8031cb:	56                   	push   %esi
  8031cc:	57                   	push   %edi
  8031cd:	e8 9f e6 ff ff       	call   801871 <sys_ipc_try_send>
		if(!res)
  8031d2:	83 c4 10             	add    $0x10,%esp
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 20                	je     8031f9 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  8031d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031dc:	75 07                	jne    8031e5 <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  8031de:	e8 c6 e4 ff ff       	call   8016a9 <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  8031e3:	eb e2                	jmp    8031c7 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	68 c9 3d 80 00       	push   $0x803dc9
  8031ed:	6a 3f                	push   $0x3f
  8031ef:	68 e1 3d 80 00       	push   $0x803de1
  8031f4:	e8 ac d8 ff ff       	call   800aa5 <_panic>
	}
}
  8031f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8031fc:	5b                   	pop    %ebx
  8031fd:	5e                   	pop    %esi
  8031fe:	5f                   	pop    %edi
  8031ff:	5d                   	pop    %ebp
  803200:	c3                   	ret    

00803201 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803201:	f3 0f 1e fb          	endbr32 
  803205:	55                   	push   %ebp
  803206:	89 e5                	mov    %esp,%ebp
  803208:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80320b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803210:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803213:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803219:	8b 52 50             	mov    0x50(%edx),%edx
  80321c:	39 ca                	cmp    %ecx,%edx
  80321e:	74 11                	je     803231 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  803220:	83 c0 01             	add    $0x1,%eax
  803223:	3d 00 04 00 00       	cmp    $0x400,%eax
  803228:	75 e6                	jne    803210 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80322a:	b8 00 00 00 00       	mov    $0x0,%eax
  80322f:	eb 0b                	jmp    80323c <ipc_find_env+0x3b>
			return envs[i].env_id;
  803231:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803234:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803239:	8b 40 48             	mov    0x48(%eax),%eax
}
  80323c:	5d                   	pop    %ebp
  80323d:	c3                   	ret    

0080323e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80323e:	f3 0f 1e fb          	endbr32 
  803242:	55                   	push   %ebp
  803243:	89 e5                	mov    %esp,%ebp
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803248:	89 c2                	mov    %eax,%edx
  80324a:	c1 ea 16             	shr    $0x16,%edx
  80324d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  803254:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  803259:	f6 c1 01             	test   $0x1,%cl
  80325c:	74 1c                	je     80327a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80325e:	c1 e8 0c             	shr    $0xc,%eax
  803261:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803268:	a8 01                	test   $0x1,%al
  80326a:	74 0e                	je     80327a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80326c:	c1 e8 0c             	shr    $0xc,%eax
  80326f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803276:	ef 
  803277:	0f b7 d2             	movzwl %dx,%edx
}
  80327a:	89 d0                	mov    %edx,%eax
  80327c:	5d                   	pop    %ebp
  80327d:	c3                   	ret    
  80327e:	66 90                	xchg   %ax,%ax

00803280 <__udivdi3>:
  803280:	f3 0f 1e fb          	endbr32 
  803284:	55                   	push   %ebp
  803285:	57                   	push   %edi
  803286:	56                   	push   %esi
  803287:	53                   	push   %ebx
  803288:	83 ec 1c             	sub    $0x1c,%esp
  80328b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80328f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803293:	8b 74 24 34          	mov    0x34(%esp),%esi
  803297:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80329b:	85 d2                	test   %edx,%edx
  80329d:	75 19                	jne    8032b8 <__udivdi3+0x38>
  80329f:	39 f3                	cmp    %esi,%ebx
  8032a1:	76 4d                	jbe    8032f0 <__udivdi3+0x70>
  8032a3:	31 ff                	xor    %edi,%edi
  8032a5:	89 e8                	mov    %ebp,%eax
  8032a7:	89 f2                	mov    %esi,%edx
  8032a9:	f7 f3                	div    %ebx
  8032ab:	89 fa                	mov    %edi,%edx
  8032ad:	83 c4 1c             	add    $0x1c,%esp
  8032b0:	5b                   	pop    %ebx
  8032b1:	5e                   	pop    %esi
  8032b2:	5f                   	pop    %edi
  8032b3:	5d                   	pop    %ebp
  8032b4:	c3                   	ret    
  8032b5:	8d 76 00             	lea    0x0(%esi),%esi
  8032b8:	39 f2                	cmp    %esi,%edx
  8032ba:	76 14                	jbe    8032d0 <__udivdi3+0x50>
  8032bc:	31 ff                	xor    %edi,%edi
  8032be:	31 c0                	xor    %eax,%eax
  8032c0:	89 fa                	mov    %edi,%edx
  8032c2:	83 c4 1c             	add    $0x1c,%esp
  8032c5:	5b                   	pop    %ebx
  8032c6:	5e                   	pop    %esi
  8032c7:	5f                   	pop    %edi
  8032c8:	5d                   	pop    %ebp
  8032c9:	c3                   	ret    
  8032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032d0:	0f bd fa             	bsr    %edx,%edi
  8032d3:	83 f7 1f             	xor    $0x1f,%edi
  8032d6:	75 48                	jne    803320 <__udivdi3+0xa0>
  8032d8:	39 f2                	cmp    %esi,%edx
  8032da:	72 06                	jb     8032e2 <__udivdi3+0x62>
  8032dc:	31 c0                	xor    %eax,%eax
  8032de:	39 eb                	cmp    %ebp,%ebx
  8032e0:	77 de                	ja     8032c0 <__udivdi3+0x40>
  8032e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e7:	eb d7                	jmp    8032c0 <__udivdi3+0x40>
  8032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032f0:	89 d9                	mov    %ebx,%ecx
  8032f2:	85 db                	test   %ebx,%ebx
  8032f4:	75 0b                	jne    803301 <__udivdi3+0x81>
  8032f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fb:	31 d2                	xor    %edx,%edx
  8032fd:	f7 f3                	div    %ebx
  8032ff:	89 c1                	mov    %eax,%ecx
  803301:	31 d2                	xor    %edx,%edx
  803303:	89 f0                	mov    %esi,%eax
  803305:	f7 f1                	div    %ecx
  803307:	89 c6                	mov    %eax,%esi
  803309:	89 e8                	mov    %ebp,%eax
  80330b:	89 f7                	mov    %esi,%edi
  80330d:	f7 f1                	div    %ecx
  80330f:	89 fa                	mov    %edi,%edx
  803311:	83 c4 1c             	add    $0x1c,%esp
  803314:	5b                   	pop    %ebx
  803315:	5e                   	pop    %esi
  803316:	5f                   	pop    %edi
  803317:	5d                   	pop    %ebp
  803318:	c3                   	ret    
  803319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803320:	89 f9                	mov    %edi,%ecx
  803322:	b8 20 00 00 00       	mov    $0x20,%eax
  803327:	29 f8                	sub    %edi,%eax
  803329:	d3 e2                	shl    %cl,%edx
  80332b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80332f:	89 c1                	mov    %eax,%ecx
  803331:	89 da                	mov    %ebx,%edx
  803333:	d3 ea                	shr    %cl,%edx
  803335:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803339:	09 d1                	or     %edx,%ecx
  80333b:	89 f2                	mov    %esi,%edx
  80333d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803341:	89 f9                	mov    %edi,%ecx
  803343:	d3 e3                	shl    %cl,%ebx
  803345:	89 c1                	mov    %eax,%ecx
  803347:	d3 ea                	shr    %cl,%edx
  803349:	89 f9                	mov    %edi,%ecx
  80334b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80334f:	89 eb                	mov    %ebp,%ebx
  803351:	d3 e6                	shl    %cl,%esi
  803353:	89 c1                	mov    %eax,%ecx
  803355:	d3 eb                	shr    %cl,%ebx
  803357:	09 de                	or     %ebx,%esi
  803359:	89 f0                	mov    %esi,%eax
  80335b:	f7 74 24 08          	divl   0x8(%esp)
  80335f:	89 d6                	mov    %edx,%esi
  803361:	89 c3                	mov    %eax,%ebx
  803363:	f7 64 24 0c          	mull   0xc(%esp)
  803367:	39 d6                	cmp    %edx,%esi
  803369:	72 15                	jb     803380 <__udivdi3+0x100>
  80336b:	89 f9                	mov    %edi,%ecx
  80336d:	d3 e5                	shl    %cl,%ebp
  80336f:	39 c5                	cmp    %eax,%ebp
  803371:	73 04                	jae    803377 <__udivdi3+0xf7>
  803373:	39 d6                	cmp    %edx,%esi
  803375:	74 09                	je     803380 <__udivdi3+0x100>
  803377:	89 d8                	mov    %ebx,%eax
  803379:	31 ff                	xor    %edi,%edi
  80337b:	e9 40 ff ff ff       	jmp    8032c0 <__udivdi3+0x40>
  803380:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803383:	31 ff                	xor    %edi,%edi
  803385:	e9 36 ff ff ff       	jmp    8032c0 <__udivdi3+0x40>
  80338a:	66 90                	xchg   %ax,%ax
  80338c:	66 90                	xchg   %ax,%ax
  80338e:	66 90                	xchg   %ax,%ax

00803390 <__umoddi3>:
  803390:	f3 0f 1e fb          	endbr32 
  803394:	55                   	push   %ebp
  803395:	57                   	push   %edi
  803396:	56                   	push   %esi
  803397:	53                   	push   %ebx
  803398:	83 ec 1c             	sub    $0x1c,%esp
  80339b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80339f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8033a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8033a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	75 19                	jne    8033c8 <__umoddi3+0x38>
  8033af:	39 df                	cmp    %ebx,%edi
  8033b1:	76 5d                	jbe    803410 <__umoddi3+0x80>
  8033b3:	89 f0                	mov    %esi,%eax
  8033b5:	89 da                	mov    %ebx,%edx
  8033b7:	f7 f7                	div    %edi
  8033b9:	89 d0                	mov    %edx,%eax
  8033bb:	31 d2                	xor    %edx,%edx
  8033bd:	83 c4 1c             	add    $0x1c,%esp
  8033c0:	5b                   	pop    %ebx
  8033c1:	5e                   	pop    %esi
  8033c2:	5f                   	pop    %edi
  8033c3:	5d                   	pop    %ebp
  8033c4:	c3                   	ret    
  8033c5:	8d 76 00             	lea    0x0(%esi),%esi
  8033c8:	89 f2                	mov    %esi,%edx
  8033ca:	39 d8                	cmp    %ebx,%eax
  8033cc:	76 12                	jbe    8033e0 <__umoddi3+0x50>
  8033ce:	89 f0                	mov    %esi,%eax
  8033d0:	89 da                	mov    %ebx,%edx
  8033d2:	83 c4 1c             	add    $0x1c,%esp
  8033d5:	5b                   	pop    %ebx
  8033d6:	5e                   	pop    %esi
  8033d7:	5f                   	pop    %edi
  8033d8:	5d                   	pop    %ebp
  8033d9:	c3                   	ret    
  8033da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8033e0:	0f bd e8             	bsr    %eax,%ebp
  8033e3:	83 f5 1f             	xor    $0x1f,%ebp
  8033e6:	75 50                	jne    803438 <__umoddi3+0xa8>
  8033e8:	39 d8                	cmp    %ebx,%eax
  8033ea:	0f 82 e0 00 00 00    	jb     8034d0 <__umoddi3+0x140>
  8033f0:	89 d9                	mov    %ebx,%ecx
  8033f2:	39 f7                	cmp    %esi,%edi
  8033f4:	0f 86 d6 00 00 00    	jbe    8034d0 <__umoddi3+0x140>
  8033fa:	89 d0                	mov    %edx,%eax
  8033fc:	89 ca                	mov    %ecx,%edx
  8033fe:	83 c4 1c             	add    $0x1c,%esp
  803401:	5b                   	pop    %ebx
  803402:	5e                   	pop    %esi
  803403:	5f                   	pop    %edi
  803404:	5d                   	pop    %ebp
  803405:	c3                   	ret    
  803406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80340d:	8d 76 00             	lea    0x0(%esi),%esi
  803410:	89 fd                	mov    %edi,%ebp
  803412:	85 ff                	test   %edi,%edi
  803414:	75 0b                	jne    803421 <__umoddi3+0x91>
  803416:	b8 01 00 00 00       	mov    $0x1,%eax
  80341b:	31 d2                	xor    %edx,%edx
  80341d:	f7 f7                	div    %edi
  80341f:	89 c5                	mov    %eax,%ebp
  803421:	89 d8                	mov    %ebx,%eax
  803423:	31 d2                	xor    %edx,%edx
  803425:	f7 f5                	div    %ebp
  803427:	89 f0                	mov    %esi,%eax
  803429:	f7 f5                	div    %ebp
  80342b:	89 d0                	mov    %edx,%eax
  80342d:	31 d2                	xor    %edx,%edx
  80342f:	eb 8c                	jmp    8033bd <__umoddi3+0x2d>
  803431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803438:	89 e9                	mov    %ebp,%ecx
  80343a:	ba 20 00 00 00       	mov    $0x20,%edx
  80343f:	29 ea                	sub    %ebp,%edx
  803441:	d3 e0                	shl    %cl,%eax
  803443:	89 44 24 08          	mov    %eax,0x8(%esp)
  803447:	89 d1                	mov    %edx,%ecx
  803449:	89 f8                	mov    %edi,%eax
  80344b:	d3 e8                	shr    %cl,%eax
  80344d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803451:	89 54 24 04          	mov    %edx,0x4(%esp)
  803455:	8b 54 24 04          	mov    0x4(%esp),%edx
  803459:	09 c1                	or     %eax,%ecx
  80345b:	89 d8                	mov    %ebx,%eax
  80345d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803461:	89 e9                	mov    %ebp,%ecx
  803463:	d3 e7                	shl    %cl,%edi
  803465:	89 d1                	mov    %edx,%ecx
  803467:	d3 e8                	shr    %cl,%eax
  803469:	89 e9                	mov    %ebp,%ecx
  80346b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80346f:	d3 e3                	shl    %cl,%ebx
  803471:	89 c7                	mov    %eax,%edi
  803473:	89 d1                	mov    %edx,%ecx
  803475:	89 f0                	mov    %esi,%eax
  803477:	d3 e8                	shr    %cl,%eax
  803479:	89 e9                	mov    %ebp,%ecx
  80347b:	89 fa                	mov    %edi,%edx
  80347d:	d3 e6                	shl    %cl,%esi
  80347f:	09 d8                	or     %ebx,%eax
  803481:	f7 74 24 08          	divl   0x8(%esp)
  803485:	89 d1                	mov    %edx,%ecx
  803487:	89 f3                	mov    %esi,%ebx
  803489:	f7 64 24 0c          	mull   0xc(%esp)
  80348d:	89 c6                	mov    %eax,%esi
  80348f:	89 d7                	mov    %edx,%edi
  803491:	39 d1                	cmp    %edx,%ecx
  803493:	72 06                	jb     80349b <__umoddi3+0x10b>
  803495:	75 10                	jne    8034a7 <__umoddi3+0x117>
  803497:	39 c3                	cmp    %eax,%ebx
  803499:	73 0c                	jae    8034a7 <__umoddi3+0x117>
  80349b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80349f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8034a3:	89 d7                	mov    %edx,%edi
  8034a5:	89 c6                	mov    %eax,%esi
  8034a7:	89 ca                	mov    %ecx,%edx
  8034a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8034ae:	29 f3                	sub    %esi,%ebx
  8034b0:	19 fa                	sbb    %edi,%edx
  8034b2:	89 d0                	mov    %edx,%eax
  8034b4:	d3 e0                	shl    %cl,%eax
  8034b6:	89 e9                	mov    %ebp,%ecx
  8034b8:	d3 eb                	shr    %cl,%ebx
  8034ba:	d3 ea                	shr    %cl,%edx
  8034bc:	09 d8                	or     %ebx,%eax
  8034be:	83 c4 1c             	add    $0x1c,%esp
  8034c1:	5b                   	pop    %ebx
  8034c2:	5e                   	pop    %esi
  8034c3:	5f                   	pop    %edi
  8034c4:	5d                   	pop    %ebp
  8034c5:	c3                   	ret    
  8034c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034cd:	8d 76 00             	lea    0x0(%esi),%esi
  8034d0:	29 fe                	sub    %edi,%esi
  8034d2:	19 c3                	sbb    %eax,%ebx
  8034d4:	89 f2                	mov    %esi,%edx
  8034d6:	89 d9                	mov    %ebx,%ecx
  8034d8:	e9 1d ff ff ff       	jmp    8033fa <__umoddi3+0x6a>
