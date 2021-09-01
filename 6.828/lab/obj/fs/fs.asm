
obj/fs/fs：     文件格式 elf32-i386


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
  80002c:	e8 66 1b 00 00       	call   801b97 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	f3 0f 1e fb          	endbr32 
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	53                   	push   %ebx
  800067:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	e8 bf ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800074:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800079:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007e:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007f:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800084:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800089:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  80008a:	a8 a1                	test   $0xa1,%al
  80008c:	74 0b                	je     800099 <ide_probe_disk1+0x3a>
	     x++)
  80008e:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  800091:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800097:	75 f0                	jne    800089 <ide_probe_disk1+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8000a3:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a4:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000aa:	0f 9e c3             	setle  %bl
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	0f b6 c3             	movzbl %bl,%eax
  8000b3:	50                   	push   %eax
  8000b4:	68 e0 3a 80 00       	push   $0x803ae0
  8000b9:	e8 28 1c 00 00       	call   801ce6 <cprintf>
	return (x < 1000);
}
  8000be:	89 d8                	mov    %ebx,%eax
  8000c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c5:	f3 0f 1e fb          	endbr32 
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000d2:	83 f8 01             	cmp    $0x1,%eax
  8000d5:	77 07                	ja     8000de <ide_set_disk+0x19>
		panic("bad disk number");
	diskno = d;
  8000d7:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    
		panic("bad disk number");
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 f7 3a 80 00       	push   $0x803af7
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 07 3b 80 00       	push   $0x803b07
  8000ed:	e8 0d 1b 00 00       	call   801bff <_panic>

008000f2 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f2:	f3 0f 1e fb          	endbr32 
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800102:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800105:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800108:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010e:	77 60                	ja     800170 <ide_read+0x7e>

	ide_wait_ready(0);
  800110:	b8 00 00 00 00       	mov    $0x0,%eax
  800115:	e8 19 ff ff ff       	call   800033 <ide_wait_ready>
  80011a:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80011f:	89 f0                	mov    %esi,%eax
  800121:	ee                   	out    %al,(%dx)
  800122:	ba f3 01 00 00       	mov    $0x1f3,%edx
  800127:	89 f8                	mov    %edi,%eax
  800129:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  80012a:	89 f8                	mov    %edi,%eax
  80012c:	c1 e8 08             	shr    $0x8,%eax
  80012f:	ba f4 01 00 00       	mov    $0x1f4,%edx
  800134:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800135:	89 f8                	mov    %edi,%eax
  800137:	c1 e8 10             	shr    $0x10,%eax
  80013a:	ba f5 01 00 00       	mov    $0x1f5,%edx
  80013f:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800140:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800147:	c1 e0 04             	shl    $0x4,%eax
  80014a:	83 e0 10             	and    $0x10,%eax
  80014d:	c1 ef 18             	shr    $0x18,%edi
  800150:	83 e7 0f             	and    $0xf,%edi
  800153:	09 f8                	or     %edi,%eax
  800155:	83 c8 e0             	or     $0xffffffe0,%eax
  800158:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80015d:	ee                   	out    %al,(%dx)
  80015e:	b8 20 00 00 00       	mov    $0x20,%eax
  800163:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800168:	ee                   	out    %al,(%dx)
  800169:	c1 e6 09             	shl    $0x9,%esi
  80016c:	01 de                	add    %ebx,%esi
}
  80016e:	eb 2b                	jmp    80019b <ide_read+0xa9>
	assert(nsecs <= 256);
  800170:	68 10 3b 80 00       	push   $0x803b10
  800175:	68 1d 3b 80 00       	push   $0x803b1d
  80017a:	6a 44                	push   $0x44
  80017c:	68 07 3b 80 00       	push   $0x803b07
  800181:	e8 79 1a 00 00       	call   801bff <_panic>
	asm volatile("cld\n\trepne\n\tinsl"
  800186:	89 df                	mov    %ebx,%edi
  800188:	b9 80 00 00 00       	mov    $0x80,%ecx
  80018d:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800192:	fc                   	cld    
  800193:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800195:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80019b:	39 f3                	cmp    %esi,%ebx
  80019d:	74 10                	je     8001af <ide_read+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
  80019f:	b8 01 00 00 00       	mov    $0x1,%eax
  8001a4:	e8 8a fe ff ff       	call   800033 <ide_wait_ready>
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	79 d9                	jns    800186 <ide_read+0x94>
  8001ad:	eb 05                	jmp    8001b4 <ide_read+0xc2>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    

008001bc <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001bc:	f3 0f 1e fb          	endbr32 
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8001cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001cf:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001d2:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001d8:	77 60                	ja     80023a <ide_write+0x7e>

	ide_wait_ready(0);
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001e4:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001e9:	89 f8                	mov    %edi,%eax
  8001eb:	ee                   	out    %al,(%dx)
  8001ec:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001f1:	89 f0                	mov    %esi,%eax
  8001f3:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001f4:	89 f0                	mov    %esi,%eax
  8001f6:	c1 e8 08             	shr    $0x8,%eax
  8001f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001fe:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	c1 e8 10             	shr    $0x10,%eax
  800204:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800209:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80020a:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800211:	c1 e0 04             	shl    $0x4,%eax
  800214:	83 e0 10             	and    $0x10,%eax
  800217:	c1 ee 18             	shr    $0x18,%esi
  80021a:	83 e6 0f             	and    $0xf,%esi
  80021d:	09 f0                	or     %esi,%eax
  80021f:	83 c8 e0             	or     $0xffffffe0,%eax
  800222:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800227:	ee                   	out    %al,(%dx)
  800228:	b8 30 00 00 00       	mov    $0x30,%eax
  80022d:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800232:	ee                   	out    %al,(%dx)
  800233:	c1 e7 09             	shl    $0x9,%edi
  800236:	01 df                	add    %ebx,%edi
}
  800238:	eb 2b                	jmp    800265 <ide_write+0xa9>
	assert(nsecs <= 256);
  80023a:	68 10 3b 80 00       	push   $0x803b10
  80023f:	68 1d 3b 80 00       	push   $0x803b1d
  800244:	6a 5d                	push   $0x5d
  800246:	68 07 3b 80 00       	push   $0x803b07
  80024b:	e8 af 19 00 00       	call   801bff <_panic>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800250:	89 de                	mov    %ebx,%esi
  800252:	b9 80 00 00 00       	mov    $0x80,%ecx
  800257:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80025c:	fc                   	cld    
  80025d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80025f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800265:	39 fb                	cmp    %edi,%ebx
  800267:	74 10                	je     800279 <ide_write+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
  800269:	b8 01 00 00 00       	mov    $0x1,%eax
  80026e:	e8 c0 fd ff ff       	call   800033 <ide_wait_ready>
  800273:	85 c0                	test   %eax,%eax
  800275:	79 d9                	jns    800250 <ide_write+0x94>
  800277:	eb 05                	jmp    80027e <ide_write+0xc2>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    

00800286 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800286:	f3 0f 1e fb          	endbr32 
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800292:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800294:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80029a:	89 c6                	mov    %eax,%esi
  80029c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80029f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8002a4:	0f 87 95 00 00 00    	ja     80033f <bc_pgfault+0xb9>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002aa:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	74 09                	je     8002bc <bc_pgfault+0x36>
  8002b3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002b6:	0f 86 9e 00 00 00    	jbe    80035a <bc_pgfault+0xd4>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr=ROUNDDOWN(addr,BLKSIZE);
  8002bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(sys_page_alloc(0,addr,PTE_W|PTE_U|PTE_P)<0)
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	6a 07                	push   $0x7
  8002c7:	53                   	push   %ebx
  8002c8:	6a 00                	push   $0x0
  8002ca:	e8 63 24 00 00       	call   802732 <sys_page_alloc>
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	0f 88 92 00 00 00    	js     80036c <bc_pgfault+0xe6>
		panic("bc_pgfault: sys_page_alloc Failed!");
		
	if(ide_read(blockno*BLKSECTS,addr,BLKSECTS)<0)
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	6a 08                	push   $0x8
  8002df:	53                   	push   %ebx
  8002e0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 05 fe ff ff       	call   8000f2 <ide_read>
  8002ed:	83 c4 10             	add    $0x10,%esp
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	0f 88 88 00 00 00    	js     800380 <bc_pgfault+0xfa>
		panic("bc_pgfault: ide_read Failed!");


	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002f8:	89 d8                	mov    %ebx,%eax
  8002fa:	c1 e8 0c             	shr    $0xc,%eax
  8002fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	25 07 0e 00 00       	and    $0xe07,%eax
  80030c:	50                   	push   %eax
  80030d:	53                   	push   %ebx
  80030e:	6a 00                	push   $0x0
  800310:	53                   	push   %ebx
  800311:	6a 00                	push   $0x0
  800313:	e8 61 24 00 00       	call   802779 <sys_page_map>
  800318:	83 c4 20             	add    $0x20,%esp
  80031b:	85 c0                	test   %eax,%eax
  80031d:	78 75                	js     800394 <bc_pgfault+0x10e>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80031f:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  800326:	74 10                	je     800338 <bc_pgfault+0xb2>
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	56                   	push   %esi
  80032c:	e8 26 05 00 00       	call   800857 <block_is_free>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	84 c0                	test   %al,%al
  800336:	75 6e                	jne    8003a6 <bc_pgfault+0x120>
		panic("reading free block %08x\n", blockno);
}
  800338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	ff 72 04             	pushl  0x4(%edx)
  800345:	53                   	push   %ebx
  800346:	ff 72 28             	pushl  0x28(%edx)
  800349:	68 34 3b 80 00       	push   $0x803b34
  80034e:	6a 27                	push   $0x27
  800350:	68 58 3c 80 00       	push   $0x803c58
  800355:	e8 a5 18 00 00       	call   801bff <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80035a:	56                   	push   %esi
  80035b:	68 64 3b 80 00       	push   $0x803b64
  800360:	6a 2c                	push   $0x2c
  800362:	68 58 3c 80 00       	push   $0x803c58
  800367:	e8 93 18 00 00       	call   801bff <_panic>
		panic("bc_pgfault: sys_page_alloc Failed!");
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	68 88 3b 80 00       	push   $0x803b88
  800374:	6a 36                	push   $0x36
  800376:	68 58 3c 80 00       	push   $0x803c58
  80037b:	e8 7f 18 00 00       	call   801bff <_panic>
		panic("bc_pgfault: ide_read Failed!");
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	68 60 3c 80 00       	push   $0x803c60
  800388:	6a 39                	push   $0x39
  80038a:	68 58 3c 80 00       	push   $0x803c58
  80038f:	e8 6b 18 00 00       	call   801bff <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800394:	50                   	push   %eax
  800395:	68 ac 3b 80 00       	push   $0x803bac
  80039a:	6a 3f                	push   $0x3f
  80039c:	68 58 3c 80 00       	push   $0x803c58
  8003a1:	e8 59 18 00 00       	call   801bff <_panic>
		panic("reading free block %08x\n", blockno);
  8003a6:	56                   	push   %esi
  8003a7:	68 7d 3c 80 00       	push   $0x803c7d
  8003ac:	6a 45                	push   $0x45
  8003ae:	68 58 3c 80 00       	push   $0x803c58
  8003b3:	e8 47 18 00 00       	call   801bff <_panic>

008003b8 <diskaddr>:
{
  8003b8:	f3 0f 1e fb          	endbr32 
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	74 19                	je     8003e2 <diskaddr+0x2a>
  8003c9:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8003cf:	85 d2                	test   %edx,%edx
  8003d1:	74 05                	je     8003d8 <diskaddr+0x20>
  8003d3:	39 42 04             	cmp    %eax,0x4(%edx)
  8003d6:	76 0a                	jbe    8003e2 <diskaddr+0x2a>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003d8:	05 00 00 01 00       	add    $0x10000,%eax
  8003dd:	c1 e0 0c             	shl    $0xc,%eax
}
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003e2:	50                   	push   %eax
  8003e3:	68 cc 3b 80 00       	push   $0x803bcc
  8003e8:	6a 0a                	push   $0xa
  8003ea:	68 58 3c 80 00       	push   $0x803c58
  8003ef:	e8 0b 18 00 00       	call   801bff <_panic>

008003f4 <va_is_mapped>:
{
  8003f4:	f3 0f 1e fb          	endbr32 
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	c1 e8 16             	shr    $0x16,%eax
  800403:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80040a:	b8 00 00 00 00       	mov    $0x0,%eax
  80040f:	f6 c1 01             	test   $0x1,%cl
  800412:	74 0d                	je     800421 <va_is_mapped+0x2d>
  800414:	c1 ea 0c             	shr    $0xc,%edx
  800417:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80041e:	83 e0 01             	and    $0x1,%eax
  800421:	83 e0 01             	and    $0x1,%eax
}
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <va_is_dirty>:
{
  800426:	f3 0f 1e fb          	endbr32 
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	c1 e8 0c             	shr    $0xc,%eax
  800433:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80043a:	c1 e8 06             	shr    $0x6,%eax
  80043d:	83 e0 01             	and    $0x1,%eax
}
  800440:	5d                   	pop    %ebp
  800441:	c3                   	ret    

00800442 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800442:	f3 0f 1e fb          	endbr32 
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	56                   	push   %esi
  80044a:	53                   	push   %ebx
  80044b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80044e:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800454:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  80045a:	77 1d                	ja     800479 <flush_block+0x37>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	addr=ROUNDDOWN(addr,BLKSIZE);
  80045c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(!va_is_mapped(addr)||!va_is_dirty(addr))
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	53                   	push   %ebx
  800466:	e8 89 ff ff ff       	call   8003f4 <va_is_mapped>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	84 c0                	test   %al,%al
  800470:	75 19                	jne    80048b <flush_block+0x49>
	if(ide_write(blockno*8,addr,BLKSECTS)<0)
		panic("flush_block: ide_write Failed!");
	if(sys_page_map(0,addr,0,addr,uvpt[PGNUM(addr)]&PTE_SYSCALL)<0)
		panic("flush_block: sys_page_map Failed!");
	
}
  800472:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800475:	5b                   	pop    %ebx
  800476:	5e                   	pop    %esi
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800479:	53                   	push   %ebx
  80047a:	68 96 3c 80 00       	push   $0x803c96
  80047f:	6a 55                	push   $0x55
  800481:	68 58 3c 80 00       	push   $0x803c58
  800486:	e8 74 17 00 00       	call   801bff <_panic>
	if(!va_is_mapped(addr)||!va_is_dirty(addr))
  80048b:	83 ec 0c             	sub    $0xc,%esp
  80048e:	53                   	push   %ebx
  80048f:	e8 92 ff ff ff       	call   800426 <va_is_dirty>
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	84 c0                	test   %al,%al
  800499:	74 d7                	je     800472 <flush_block+0x30>
	if(ide_write(blockno*8,addr,BLKSECTS)<0)
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	6a 08                	push   $0x8
  8004a0:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8004a1:	c1 ee 0c             	shr    $0xc,%esi
	if(ide_write(blockno*8,addr,BLKSECTS)<0)
  8004a4:	c1 e6 03             	shl    $0x3,%esi
  8004a7:	56                   	push   %esi
  8004a8:	e8 0f fd ff ff       	call   8001bc <ide_write>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	85 c0                	test   %eax,%eax
  8004b2:	78 3b                	js     8004ef <flush_block+0xad>
	if(sys_page_map(0,addr,0,addr,uvpt[PGNUM(addr)]&PTE_SYSCALL)<0)
  8004b4:	89 d8                	mov    %ebx,%eax
  8004b6:	c1 e8 0c             	shr    $0xc,%eax
  8004b9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004c0:	83 ec 0c             	sub    $0xc,%esp
  8004c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8004c8:	50                   	push   %eax
  8004c9:	53                   	push   %ebx
  8004ca:	6a 00                	push   $0x0
  8004cc:	53                   	push   %ebx
  8004cd:	6a 00                	push   $0x0
  8004cf:	e8 a5 22 00 00       	call   802779 <sys_page_map>
  8004d4:	83 c4 20             	add    $0x20,%esp
  8004d7:	85 c0                	test   %eax,%eax
  8004d9:	79 97                	jns    800472 <flush_block+0x30>
		panic("flush_block: sys_page_map Failed!");
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 10 3c 80 00       	push   $0x803c10
  8004e3:	6a 5e                	push   $0x5e
  8004e5:	68 58 3c 80 00       	push   $0x803c58
  8004ea:	e8 10 17 00 00       	call   801bff <_panic>
		panic("flush_block: ide_write Failed!");
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 f0 3b 80 00       	push   $0x803bf0
  8004f7:	6a 5c                	push   $0x5c
  8004f9:	68 58 3c 80 00       	push   $0x803c58
  8004fe:	e8 fc 16 00 00       	call   801bff <_panic>

00800503 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  800503:	f3 0f 1e fb          	endbr32 
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	53                   	push   %ebx
  80050b:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800511:	68 86 02 80 00       	push   $0x800286
  800516:	e8 28 24 00 00       	call   802943 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  80051b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800522:	e8 91 fe ff ff       	call   8003b8 <diskaddr>
  800527:	83 c4 0c             	add    $0xc,%esp
  80052a:	68 08 01 00 00       	push   $0x108
  80052f:	50                   	push   %eax
  800530:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800536:	50                   	push   %eax
  800537:	e8 6a 1f 00 00       	call   8024a6 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80053c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800543:	e8 70 fe ff ff       	call   8003b8 <diskaddr>
  800548:	83 c4 08             	add    $0x8,%esp
  80054b:	68 b1 3c 80 00       	push   $0x803cb1
  800550:	50                   	push   %eax
  800551:	e8 9a 1d 00 00       	call   8022f0 <strcpy>
	flush_block(diskaddr(1));
  800556:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80055d:	e8 56 fe ff ff       	call   8003b8 <diskaddr>
  800562:	89 04 24             	mov    %eax,(%esp)
  800565:	e8 d8 fe ff ff       	call   800442 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80056a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800571:	e8 42 fe ff ff       	call   8003b8 <diskaddr>
  800576:	89 04 24             	mov    %eax,(%esp)
  800579:	e8 76 fe ff ff       	call   8003f4 <va_is_mapped>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	84 c0                	test   %al,%al
  800583:	0f 84 d1 01 00 00    	je     80075a <bc_init+0x257>
	assert(!va_is_dirty(diskaddr(1)));
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	6a 01                	push   $0x1
  80058e:	e8 25 fe ff ff       	call   8003b8 <diskaddr>
  800593:	89 04 24             	mov    %eax,(%esp)
  800596:	e8 8b fe ff ff       	call   800426 <va_is_dirty>
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	84 c0                	test   %al,%al
  8005a0:	0f 85 ca 01 00 00    	jne    800770 <bc_init+0x26d>
	sys_page_unmap(0, diskaddr(1));
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	6a 01                	push   $0x1
  8005ab:	e8 08 fe ff ff       	call   8003b8 <diskaddr>
  8005b0:	83 c4 08             	add    $0x8,%esp
  8005b3:	50                   	push   %eax
  8005b4:	6a 00                	push   $0x0
  8005b6:	e8 04 22 00 00       	call   8027bf <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005c2:	e8 f1 fd ff ff       	call   8003b8 <diskaddr>
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	e8 25 fe ff ff       	call   8003f4 <va_is_mapped>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	84 c0                	test   %al,%al
  8005d4:	0f 85 ac 01 00 00    	jne    800786 <bc_init+0x283>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005da:	83 ec 0c             	sub    $0xc,%esp
  8005dd:	6a 01                	push   $0x1
  8005df:	e8 d4 fd ff ff       	call   8003b8 <diskaddr>
  8005e4:	83 c4 08             	add    $0x8,%esp
  8005e7:	68 b1 3c 80 00       	push   $0x803cb1
  8005ec:	50                   	push   %eax
  8005ed:	e8 bd 1d 00 00       	call   8023af <strcmp>
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	0f 85 9f 01 00 00    	jne    80079c <bc_init+0x299>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005fd:	83 ec 0c             	sub    $0xc,%esp
  800600:	6a 01                	push   $0x1
  800602:	e8 b1 fd ff ff       	call   8003b8 <diskaddr>
  800607:	83 c4 0c             	add    $0xc,%esp
  80060a:	68 08 01 00 00       	push   $0x108
  80060f:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  800615:	53                   	push   %ebx
  800616:	50                   	push   %eax
  800617:	e8 8a 1e 00 00       	call   8024a6 <memmove>
	flush_block(diskaddr(1));
  80061c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800623:	e8 90 fd ff ff       	call   8003b8 <diskaddr>
  800628:	89 04 24             	mov    %eax,(%esp)
  80062b:	e8 12 fe ff ff       	call   800442 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  800630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800637:	e8 7c fd ff ff       	call   8003b8 <diskaddr>
  80063c:	83 c4 0c             	add    $0xc,%esp
  80063f:	68 08 01 00 00       	push   $0x108
  800644:	50                   	push   %eax
  800645:	53                   	push   %ebx
  800646:	e8 5b 1e 00 00       	call   8024a6 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  80064b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800652:	e8 61 fd ff ff       	call   8003b8 <diskaddr>
  800657:	83 c4 08             	add    $0x8,%esp
  80065a:	68 b1 3c 80 00       	push   $0x803cb1
  80065f:	50                   	push   %eax
  800660:	e8 8b 1c 00 00       	call   8022f0 <strcpy>
	flush_block(diskaddr(1) + 20);
  800665:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80066c:	e8 47 fd ff ff       	call   8003b8 <diskaddr>
  800671:	83 c0 14             	add    $0x14,%eax
  800674:	89 04 24             	mov    %eax,(%esp)
  800677:	e8 c6 fd ff ff       	call   800442 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80067c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800683:	e8 30 fd ff ff       	call   8003b8 <diskaddr>
  800688:	89 04 24             	mov    %eax,(%esp)
  80068b:	e8 64 fd ff ff       	call   8003f4 <va_is_mapped>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	84 c0                	test   %al,%al
  800695:	0f 84 17 01 00 00    	je     8007b2 <bc_init+0x2af>
	sys_page_unmap(0, diskaddr(1));
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	6a 01                	push   $0x1
  8006a0:	e8 13 fd ff ff       	call   8003b8 <diskaddr>
  8006a5:	83 c4 08             	add    $0x8,%esp
  8006a8:	50                   	push   %eax
  8006a9:	6a 00                	push   $0x0
  8006ab:	e8 0f 21 00 00       	call   8027bf <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8006b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006b7:	e8 fc fc ff ff       	call   8003b8 <diskaddr>
  8006bc:	89 04 24             	mov    %eax,(%esp)
  8006bf:	e8 30 fd ff ff       	call   8003f4 <va_is_mapped>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	84 c0                	test   %al,%al
  8006c9:	0f 85 fc 00 00 00    	jne    8007cb <bc_init+0x2c8>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006cf:	83 ec 0c             	sub    $0xc,%esp
  8006d2:	6a 01                	push   $0x1
  8006d4:	e8 df fc ff ff       	call   8003b8 <diskaddr>
  8006d9:	83 c4 08             	add    $0x8,%esp
  8006dc:	68 b1 3c 80 00       	push   $0x803cb1
  8006e1:	50                   	push   %eax
  8006e2:	e8 c8 1c 00 00       	call   8023af <strcmp>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	0f 85 f2 00 00 00    	jne    8007e4 <bc_init+0x2e1>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	6a 01                	push   $0x1
  8006f7:	e8 bc fc ff ff       	call   8003b8 <diskaddr>
  8006fc:	83 c4 0c             	add    $0xc,%esp
  8006ff:	68 08 01 00 00       	push   $0x108
  800704:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  80070a:	52                   	push   %edx
  80070b:	50                   	push   %eax
  80070c:	e8 95 1d 00 00       	call   8024a6 <memmove>
	flush_block(diskaddr(1));
  800711:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800718:	e8 9b fc ff ff       	call   8003b8 <diskaddr>
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	e8 1d fd ff ff       	call   800442 <flush_block>
	cprintf("block cache is good\n");
  800725:	c7 04 24 ed 3c 80 00 	movl   $0x803ced,(%esp)
  80072c:	e8 b5 15 00 00       	call   801ce6 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800731:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800738:	e8 7b fc ff ff       	call   8003b8 <diskaddr>
  80073d:	83 c4 0c             	add    $0xc,%esp
  800740:	68 08 01 00 00       	push   $0x108
  800745:	50                   	push   %eax
  800746:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	e8 54 1d 00 00       	call   8024a6 <memmove>
}
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800758:	c9                   	leave  
  800759:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  80075a:	68 d3 3c 80 00       	push   $0x803cd3
  80075f:	68 1d 3b 80 00       	push   $0x803b1d
  800764:	6a 6f                	push   $0x6f
  800766:	68 58 3c 80 00       	push   $0x803c58
  80076b:	e8 8f 14 00 00       	call   801bff <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800770:	68 b8 3c 80 00       	push   $0x803cb8
  800775:	68 1d 3b 80 00       	push   $0x803b1d
  80077a:	6a 70                	push   $0x70
  80077c:	68 58 3c 80 00       	push   $0x803c58
  800781:	e8 79 14 00 00       	call   801bff <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800786:	68 d2 3c 80 00       	push   $0x803cd2
  80078b:	68 1d 3b 80 00       	push   $0x803b1d
  800790:	6a 74                	push   $0x74
  800792:	68 58 3c 80 00       	push   $0x803c58
  800797:	e8 63 14 00 00       	call   801bff <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80079c:	68 34 3c 80 00       	push   $0x803c34
  8007a1:	68 1d 3b 80 00       	push   $0x803b1d
  8007a6:	6a 77                	push   $0x77
  8007a8:	68 58 3c 80 00       	push   $0x803c58
  8007ad:	e8 4d 14 00 00       	call   801bff <_panic>
	assert(va_is_mapped(diskaddr(1)));
  8007b2:	68 d3 3c 80 00       	push   $0x803cd3
  8007b7:	68 1d 3b 80 00       	push   $0x803b1d
  8007bc:	68 88 00 00 00       	push   $0x88
  8007c1:	68 58 3c 80 00       	push   $0x803c58
  8007c6:	e8 34 14 00 00       	call   801bff <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007cb:	68 d2 3c 80 00       	push   $0x803cd2
  8007d0:	68 1d 3b 80 00       	push   $0x803b1d
  8007d5:	68 90 00 00 00       	push   $0x90
  8007da:	68 58 3c 80 00       	push   $0x803c58
  8007df:	e8 1b 14 00 00       	call   801bff <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007e4:	68 34 3c 80 00       	push   $0x803c34
  8007e9:	68 1d 3b 80 00       	push   $0x803b1d
  8007ee:	68 93 00 00 00       	push   $0x93
  8007f3:	68 58 3c 80 00       	push   $0x803c58
  8007f8:	e8 02 14 00 00       	call   801bff <_panic>

008007fd <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  800807:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80080c:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800812:	75 1b                	jne    80082f <check_super+0x32>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800814:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  80081b:	77 26                	ja     800843 <check_super+0x46>
		panic("file system is too large");

	cprintf("superblock is good\n");
  80081d:	83 ec 0c             	sub    $0xc,%esp
  800820:	68 40 3d 80 00       	push   $0x803d40
  800825:	e8 bc 14 00 00       	call   801ce6 <cprintf>
}
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    
		panic("bad file system magic number");
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 02 3d 80 00       	push   $0x803d02
  800837:	6a 0f                	push   $0xf
  800839:	68 1f 3d 80 00       	push   $0x803d1f
  80083e:	e8 bc 13 00 00       	call   801bff <_panic>
		panic("file system is too large");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 27 3d 80 00       	push   $0x803d27
  80084b:	6a 12                	push   $0x12
  80084d:	68 1f 3d 80 00       	push   $0x803d1f
  800852:	e8 a8 13 00 00       	call   801bff <_panic>

00800857 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800857:	f3 0f 1e fb          	endbr32 
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800862:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800867:	85 c0                	test   %eax,%eax
  800869:	74 27                	je     800892 <block_is_free+0x3b>
		return 0;
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (super == 0 || blockno >= super->s_nblocks)
  800870:	39 48 04             	cmp    %ecx,0x4(%eax)
  800873:	76 18                	jbe    80088d <block_is_free+0x36>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800875:	89 cb                	mov    %ecx,%ebx
  800877:	c1 eb 05             	shr    $0x5,%ebx
  80087a:	b8 01 00 00 00       	mov    $0x1,%eax
  80087f:	d3 e0                	shl    %cl,%eax
  800881:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  800887:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80088a:	0f 95 c2             	setne  %dl
		return 1;
	return 0;
}
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	5b                   	pop    %ebx
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    
		return 0;
  800892:	ba 00 00 00 00       	mov    $0x0,%edx
  800897:	eb f4                	jmp    80088d <block_is_free+0x36>

00800899 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800899:	f3 0f 1e fb          	endbr32 
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	53                   	push   %ebx
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8008a7:	85 c9                	test   %ecx,%ecx
  8008a9:	74 1a                	je     8008c5 <free_block+0x2c>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  8008ab:	89 cb                	mov    %ecx,%ebx
  8008ad:	c1 eb 05             	shr    $0x5,%ebx
  8008b0:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  8008b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8008bb:	d3 e0                	shl    %cl,%eax
  8008bd:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  8008c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    
		panic("attempt to free zero block");
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 54 3d 80 00       	push   $0x803d54
  8008cd:	6a 2d                	push   $0x2d
  8008cf:	68 1f 3d 80 00       	push   $0x803d1f
  8008d4:	e8 26 13 00 00       	call   801bff <_panic>

008008d9 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for(blockno=2;blockno < super->s_nblocks;blockno++){
  8008e2:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8008e7:	8b 70 04             	mov    0x4(%eax),%esi
  8008ea:	bb 02 00 00 00       	mov    $0x2,%ebx
  8008ef:	39 de                	cmp    %ebx,%esi
  8008f1:	76 48                	jbe    80093b <alloc_block+0x62>
		if(block_is_free(blockno)){
  8008f3:	83 ec 0c             	sub    $0xc,%esp
  8008f6:	53                   	push   %ebx
  8008f7:	e8 5b ff ff ff       	call   800857 <block_is_free>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	84 c0                	test   %al,%al
  800901:	75 05                	jne    800908 <alloc_block+0x2f>
	for(blockno=2;blockno < super->s_nblocks;blockno++){
  800903:	83 c3 01             	add    $0x1,%ebx
  800906:	eb e7                	jmp    8008ef <alloc_block+0x16>
			bitmap[blockno/32]&=~ (1<<(blockno%32));
  800908:	89 d8                	mov    %ebx,%eax
  80090a:	c1 e8 05             	shr    $0x5,%eax
  80090d:	c1 e0 02             	shl    $0x2,%eax
  800910:	89 c6                	mov    %eax,%esi
  800912:	03 35 04 a0 80 00    	add    0x80a004,%esi
  800918:	ba 01 00 00 00       	mov    $0x1,%edx
  80091d:	89 d9                	mov    %ebx,%ecx
  80091f:	d3 e2                	shl    %cl,%edx
  800921:	f7 d2                	not    %edx
  800923:	21 16                	and    %edx,(%esi)
			flush_block(&bitmap[blockno/32]);
  800925:	83 ec 0c             	sub    $0xc,%esp
  800928:	03 05 04 a0 80 00    	add    0x80a004,%eax
  80092e:	50                   	push   %eax
  80092f:	e8 0e fb ff ff       	call   800442 <flush_block>
			return blockno;
  800934:	89 d8                	mov    %ebx,%eax
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	eb 05                	jmp    800940 <alloc_block+0x67>
		}
		
	}
	return -E_NO_DISK;
  80093b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800943:	5b                   	pop    %ebx
  800944:	5e                   	pop    %esi
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	57                   	push   %edi
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	83 ec 1c             	sub    $0x1c,%esp
  800950:	89 c6                	mov    %eax,%esi
  800952:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
       // LAB 5: Your code here.
       int bno;
       if(filebno>=NDIRECT+NINDIRECT)
  800958:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80095e:	0f 87 8b 00 00 00    	ja     8009ef <file_block_walk+0xa8>
  800964:	89 d3                	mov    %edx,%ebx
       	return -E_INVAL;
       if(filebno<NDIRECT){
  800966:	83 fa 09             	cmp    $0x9,%edx
  800969:	76 74                	jbe    8009df <file_block_walk+0x98>
       	*ppdiskbno=f->f_direct+filebno;
       	return 0;
       }
       
       if(!f->f_indirect){
  80096b:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  800972:	75 41                	jne    8009b5 <file_block_walk+0x6e>
       	if(!alloc)
  800974:	84 c0                	test   %al,%al
  800976:	74 7e                	je     8009f6 <file_block_walk+0xaf>
       		return -E_NOT_FOUND;
       	if((bno=alloc_block())<0)
  800978:	e8 5c ff ff ff       	call   8008d9 <alloc_block>
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	85 c0                	test   %eax,%eax
  800981:	78 7a                	js     8009fd <file_block_walk+0xb6>
       		return -E_NO_DISK;
       	f->f_indirect=bno;
  800983:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
       	memset(diskaddr(bno),0,BLKSIZE);
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 26 fa ff ff       	call   8003b8 <diskaddr>
  800992:	83 c4 0c             	add    $0xc,%esp
  800995:	68 00 10 00 00       	push   $0x1000
  80099a:	6a 00                	push   $0x0
  80099c:	50                   	push   %eax
  80099d:	e8 b8 1a 00 00       	call   80245a <memset>
       	flush_block(diskaddr(bno));
  8009a2:	89 3c 24             	mov    %edi,(%esp)
  8009a5:	e8 0e fa ff ff       	call   8003b8 <diskaddr>
  8009aa:	89 04 24             	mov    %eax,(%esp)
  8009ad:	e8 90 fa ff ff       	call   800442 <flush_block>
  8009b2:	83 c4 10             	add    $0x10,%esp
       }
	*ppdiskbno=(uint32_t *)diskaddr(f->f_indirect)+filebno-NINDIRECT;
  8009b5:	83 ec 0c             	sub    $0xc,%esp
  8009b8:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  8009be:	e8 f5 f9 ff ff       	call   8003b8 <diskaddr>
  8009c3:	8d 84 98 00 f0 ff ff 	lea    -0x1000(%eax,%ebx,4),%eax
  8009ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009cd:	89 07                	mov    %eax,(%edi)
       return 0;
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009da:	5b                   	pop    %ebx
  8009db:	5e                   	pop    %esi
  8009dc:	5f                   	pop    %edi
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    
       	*ppdiskbno=f->f_direct+filebno;
  8009df:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  8009e6:	89 01                	mov    %eax,(%ecx)
       	return 0;
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ed:	eb e8                	jmp    8009d7 <file_block_walk+0x90>
       	return -E_INVAL;
  8009ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f4:	eb e1                	jmp    8009d7 <file_block_walk+0x90>
       		return -E_NOT_FOUND;
  8009f6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009fb:	eb da                	jmp    8009d7 <file_block_walk+0x90>
       		return -E_NO_DISK;
  8009fd:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800a02:	eb d3                	jmp    8009d7 <file_block_walk+0x90>

00800a04 <check_bitmap>:
{
  800a04:	f3 0f 1e fb          	endbr32 
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	56                   	push   %esi
  800a0c:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a0d:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800a12:	8b 70 04             	mov    0x4(%eax),%esi
  800a15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a1a:	89 d8                	mov    %ebx,%eax
  800a1c:	c1 e0 0f             	shl    $0xf,%eax
  800a1f:	39 c6                	cmp    %eax,%esi
  800a21:	76 2e                	jbe    800a51 <check_bitmap+0x4d>
		assert(!block_is_free(2+i));
  800a23:	83 ec 0c             	sub    $0xc,%esp
  800a26:	8d 43 02             	lea    0x2(%ebx),%eax
  800a29:	50                   	push   %eax
  800a2a:	e8 28 fe ff ff       	call   800857 <block_is_free>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	84 c0                	test   %al,%al
  800a34:	75 05                	jne    800a3b <check_bitmap+0x37>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a36:	83 c3 01             	add    $0x1,%ebx
  800a39:	eb df                	jmp    800a1a <check_bitmap+0x16>
		assert(!block_is_free(2+i));
  800a3b:	68 6f 3d 80 00       	push   $0x803d6f
  800a40:	68 1d 3b 80 00       	push   $0x803b1d
  800a45:	6a 58                	push   $0x58
  800a47:	68 1f 3d 80 00       	push   $0x803d1f
  800a4c:	e8 ae 11 00 00       	call   801bff <_panic>
	assert(!block_is_free(0));
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	6a 00                	push   $0x0
  800a56:	e8 fc fd ff ff       	call   800857 <block_is_free>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	84 c0                	test   %al,%al
  800a60:	75 28                	jne    800a8a <check_bitmap+0x86>
	assert(!block_is_free(1));
  800a62:	83 ec 0c             	sub    $0xc,%esp
  800a65:	6a 01                	push   $0x1
  800a67:	e8 eb fd ff ff       	call   800857 <block_is_free>
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	84 c0                	test   %al,%al
  800a71:	75 2d                	jne    800aa0 <check_bitmap+0x9c>
	cprintf("bitmap is good\n");
  800a73:	83 ec 0c             	sub    $0xc,%esp
  800a76:	68 a7 3d 80 00       	push   $0x803da7
  800a7b:	e8 66 12 00 00       	call   801ce6 <cprintf>
}
  800a80:	83 c4 10             	add    $0x10,%esp
  800a83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    
	assert(!block_is_free(0));
  800a8a:	68 83 3d 80 00       	push   $0x803d83
  800a8f:	68 1d 3b 80 00       	push   $0x803b1d
  800a94:	6a 5b                	push   $0x5b
  800a96:	68 1f 3d 80 00       	push   $0x803d1f
  800a9b:	e8 5f 11 00 00       	call   801bff <_panic>
	assert(!block_is_free(1));
  800aa0:	68 95 3d 80 00       	push   $0x803d95
  800aa5:	68 1d 3b 80 00       	push   $0x803b1d
  800aaa:	6a 5c                	push   $0x5c
  800aac:	68 1f 3d 80 00       	push   $0x803d1f
  800ab1:	e8 49 11 00 00       	call   801bff <_panic>

00800ab6 <fs_init>:
{
  800ab6:	f3 0f 1e fb          	endbr32 
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800ac0:	e8 9a f5 ff ff       	call   80005f <ide_probe_disk1>
  800ac5:	84 c0                	test   %al,%al
  800ac7:	74 41                	je     800b0a <fs_init+0x54>
		ide_set_disk(1);
  800ac9:	83 ec 0c             	sub    $0xc,%esp
  800acc:	6a 01                	push   $0x1
  800ace:	e8 f2 f5 ff ff       	call   8000c5 <ide_set_disk>
  800ad3:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800ad6:	e8 28 fa ff ff       	call   800503 <bc_init>
	super = diskaddr(1);
  800adb:	83 ec 0c             	sub    $0xc,%esp
  800ade:	6a 01                	push   $0x1
  800ae0:	e8 d3 f8 ff ff       	call   8003b8 <diskaddr>
  800ae5:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800aea:	e8 0e fd ff ff       	call   8007fd <check_super>
	bitmap = diskaddr(2);
  800aef:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800af6:	e8 bd f8 ff ff       	call   8003b8 <diskaddr>
  800afb:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800b00:	e8 ff fe ff ff       	call   800a04 <check_bitmap>
}
  800b05:	83 c4 10             	add    $0x10,%esp
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    
		ide_set_disk(0);
  800b0a:	83 ec 0c             	sub    $0xc,%esp
  800b0d:	6a 00                	push   $0x0
  800b0f:	e8 b1 f5 ff ff       	call   8000c5 <ide_set_disk>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	eb bd                	jmp    800ad6 <fs_init+0x20>

00800b19 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800b19:	f3 0f 1e fb          	endbr32 
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	83 ec 20             	sub    $0x20,%esp
       // LAB 5: Your code here.
       int res;
       uint32_t *ppdiskbno;
       if((res=file_block_walk(f,filebno,&ppdiskbno,1))<0)
  800b24:	6a 01                	push   $0x1
  800b26:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	e8 13 fe ff ff       	call   800947 <file_block_walk>
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	85 c0                	test   %eax,%eax
  800b39:	78 5e                	js     800b99 <file_get_block+0x80>
       	return res;
       if(*ppdiskbno==0){
  800b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b3e:	83 38 00             	cmpl   $0x0,(%eax)
  800b41:	75 3c                	jne    800b7f <file_get_block+0x66>
       	if((res=alloc_block())<0)
  800b43:	e8 91 fd ff ff       	call   8008d9 <alloc_block>
  800b48:	89 c3                	mov    %eax,%ebx
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	78 50                	js     800b9e <file_get_block+0x85>
       		return -E_NO_DISK;
       	*ppdiskbno=res;
  800b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b51:	89 18                	mov    %ebx,(%eax)
       	memset(diskaddr(res),0,BLKSIZE);
  800b53:	83 ec 0c             	sub    $0xc,%esp
  800b56:	53                   	push   %ebx
  800b57:	e8 5c f8 ff ff       	call   8003b8 <diskaddr>
  800b5c:	83 c4 0c             	add    $0xc,%esp
  800b5f:	68 00 10 00 00       	push   $0x1000
  800b64:	6a 00                	push   $0x0
  800b66:	50                   	push   %eax
  800b67:	e8 ee 18 00 00       	call   80245a <memset>
       	flush_block(diskaddr(res));
  800b6c:	89 1c 24             	mov    %ebx,(%esp)
  800b6f:	e8 44 f8 ff ff       	call   8003b8 <diskaddr>
  800b74:	89 04 24             	mov    %eax,(%esp)
  800b77:	e8 c6 f8 ff ff       	call   800442 <flush_block>
  800b7c:	83 c4 10             	add    $0x10,%esp
       }
       *blk=diskaddr(*ppdiskbno);
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b85:	ff 30                	pushl  (%eax)
  800b87:	e8 2c f8 ff ff       	call   8003b8 <diskaddr>
  800b8c:	8b 55 10             	mov    0x10(%ebp),%edx
  800b8f:	89 02                	mov    %eax,(%edx)
       return 0;
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
       //panic("not comlepte!");
}
  800b99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    
       		return -E_NO_DISK;
  800b9e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800ba3:	eb f4                	jmp    800b99 <file_get_block+0x80>

00800ba5 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800bb1:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800bb7:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	while (*p == '/')
  800bbd:	80 38 2f             	cmpb   $0x2f,(%eax)
  800bc0:	75 05                	jne    800bc7 <walk_path+0x22>
		p++;
  800bc2:	83 c0 01             	add    $0x1,%eax
  800bc5:	eb f6                	jmp    800bbd <walk_path+0x18>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800bc7:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  800bcd:	83 c1 08             	add    $0x8,%ecx
  800bd0:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800bd6:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800bdd:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800be3:	85 c9                	test   %ecx,%ecx
  800be5:	74 06                	je     800bed <walk_path+0x48>
		*pdir = 0;
  800be7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800bed:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800bf3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800bfe:	e9 c5 01 00 00       	jmp    800dc8 <walk_path+0x223>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800c03:	83 c6 01             	add    $0x1,%esi
		while (*path != '/' && *path != '\0')
  800c06:	0f b6 16             	movzbl (%esi),%edx
  800c09:	80 fa 2f             	cmp    $0x2f,%dl
  800c0c:	74 04                	je     800c12 <walk_path+0x6d>
  800c0e:	84 d2                	test   %dl,%dl
  800c10:	75 f1                	jne    800c03 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800c12:	89 f3                	mov    %esi,%ebx
  800c14:	29 c3                	sub    %eax,%ebx
  800c16:	83 fb 7f             	cmp    $0x7f,%ebx
  800c19:	0f 8f 71 01 00 00    	jg     800d90 <walk_path+0x1eb>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800c1f:	83 ec 04             	sub    $0x4,%esp
  800c22:	53                   	push   %ebx
  800c23:	50                   	push   %eax
  800c24:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800c2a:	50                   	push   %eax
  800c2b:	e8 76 18 00 00       	call   8024a6 <memmove>
		name[path - p] = '\0';
  800c30:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800c37:	00 
	while (*p == '/')
  800c38:	83 c4 10             	add    $0x10,%esp
  800c3b:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800c3e:	75 05                	jne    800c45 <walk_path+0xa0>
		p++;
  800c40:	83 c6 01             	add    $0x1,%esi
  800c43:	eb f6                	jmp    800c3b <walk_path+0x96>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c45:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c4b:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c52:	0f 85 3f 01 00 00    	jne    800d97 <walk_path+0x1f2>
	assert((dir->f_size % BLKSIZE) == 0);
  800c58:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c5e:	89 c1                	mov    %eax,%ecx
  800c60:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  800c66:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
  800c6c:	0f 85 8e 00 00 00    	jne    800d00 <walk_path+0x15b>
	nblock = dir->f_size / BLKSIZE;
  800c72:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	0f 48 c2             	cmovs  %edx,%eax
  800c7d:	c1 f8 0c             	sar    $0xc,%eax
  800c80:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
			if (strcmp(f[j].f_name, name) == 0) {
  800c86:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  800c8c:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c92:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c98:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c9e:	74 79                	je     800d19 <walk_path+0x174>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800ca0:	83 ec 04             	sub    $0x4,%esp
  800ca3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800ca9:	50                   	push   %eax
  800caa:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800cb0:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800cb6:	e8 5e fe ff ff       	call   800b19 <file_get_block>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	0f 88 d8 00 00 00    	js     800d9e <walk_path+0x1f9>
  800cc6:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800ccc:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
			if (strcmp(f[j].f_name, name) == 0) {
  800cd2:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	57                   	push   %edi
  800cdc:	53                   	push   %ebx
  800cdd:	e8 cd 16 00 00       	call   8023af <strcmp>
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	0f 84 c1 00 00 00    	je     800dae <walk_path+0x209>
  800ced:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800cf3:	39 f3                	cmp    %esi,%ebx
  800cf5:	75 db                	jne    800cd2 <walk_path+0x12d>
	for (i = 0; i < nblock; i++) {
  800cf7:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800cfe:	eb 92                	jmp    800c92 <walk_path+0xed>
	assert((dir->f_size % BLKSIZE) == 0);
  800d00:	68 b7 3d 80 00       	push   $0x803db7
  800d05:	68 1d 3b 80 00       	push   $0x803b1d
  800d0a:	68 d2 00 00 00       	push   $0xd2
  800d0f:	68 1f 3d 80 00       	push   $0x803d1f
  800d14:	e8 e6 0e 00 00       	call   801bff <_panic>
  800d19:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800d1f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d24:	80 3e 00             	cmpb   $0x0,(%esi)
  800d27:	75 5f                	jne    800d88 <walk_path+0x1e3>
				if (pdir)
  800d29:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	74 08                	je     800d3b <walk_path+0x196>
					*pdir = dir;
  800d33:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d39:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800d3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d3f:	74 15                	je     800d56 <walk_path+0x1b1>
					strcpy(lastelem, name);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d4a:	50                   	push   %eax
  800d4b:	ff 75 08             	pushl  0x8(%ebp)
  800d4e:	e8 9d 15 00 00       	call   8022f0 <strcpy>
  800d53:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d56:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d62:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d67:	eb 1f                	jmp    800d88 <walk_path+0x1e3>
		}
	}

	if (pdir)
  800d69:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d6f:	85 c0                	test   %eax,%eax
  800d71:	74 02                	je     800d75 <walk_path+0x1d0>
		*pdir = dir;
  800d73:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d75:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d7b:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d81:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    
			return -E_BAD_PATH;
  800d90:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d95:	eb f1                	jmp    800d88 <walk_path+0x1e3>
			return -E_NOT_FOUND;
  800d97:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d9c:	eb ea                	jmp    800d88 <walk_path+0x1e3>
  800d9e:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800da4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800da7:	75 df                	jne    800d88 <walk_path+0x1e3>
  800da9:	e9 71 ff ff ff       	jmp    800d1f <walk_path+0x17a>
  800dae:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
  800db4:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800dba:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800dc0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800dc6:	89 f0                	mov    %esi,%eax
	while (*path != '\0') {
  800dc8:	80 38 00             	cmpb   $0x0,(%eax)
  800dcb:	74 9c                	je     800d69 <walk_path+0x1c4>
  800dcd:	89 c6                	mov    %eax,%esi
  800dcf:	e9 32 fe ff ff       	jmp    800c06 <walk_path+0x61>

00800dd4 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800dde:	6a 00                	push   $0x0
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	ba 00 00 00 00       	mov    $0x0,%edx
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	e8 b5 fd ff ff       	call   800ba5 <walk_path>
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800df2:	f3 0f 1e fb          	endbr32 
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
  800dfc:	83 ec 2c             	sub    $0x2c,%esp
  800dff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e05:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800e16:	39 ca                	cmp    %ecx,%edx
  800e18:	7e 7e                	jle    800e98 <file_read+0xa6>

	count = MIN(count, f->f_size - offset);
  800e1a:	29 ca                	sub    %ecx,%edx
  800e1c:	39 da                	cmp    %ebx,%edx
  800e1e:	89 d8                	mov    %ebx,%eax
  800e20:	0f 46 c2             	cmovbe %edx,%eax
  800e23:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800e26:	89 cb                	mov    %ecx,%ebx
  800e28:	01 c1                	add    %eax,%ecx
  800e2a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e2d:	89 de                	mov    %ebx,%esi
  800e2f:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800e32:	76 61                	jbe    800e95 <file_read+0xa3>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800e34:	83 ec 04             	sub    $0x4,%esp
  800e37:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e3a:	50                   	push   %eax
  800e3b:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	0f 49 c3             	cmovns %ebx,%eax
  800e46:	c1 f8 0c             	sar    $0xc,%eax
  800e49:	50                   	push   %eax
  800e4a:	ff 75 08             	pushl  0x8(%ebp)
  800e4d:	e8 c7 fc ff ff       	call   800b19 <file_get_block>
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	85 c0                	test   %eax,%eax
  800e57:	78 3f                	js     800e98 <file_read+0xa6>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e59:	89 da                	mov    %ebx,%edx
  800e5b:	c1 fa 1f             	sar    $0x1f,%edx
  800e5e:	c1 ea 14             	shr    $0x14,%edx
  800e61:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800e64:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e69:	29 d0                	sub    %edx,%eax
  800e6b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e75:	29 f1                	sub    %esi,%ecx
  800e77:	89 ce                	mov    %ecx,%esi
  800e79:	39 ca                	cmp    %ecx,%edx
  800e7b:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e7e:	83 ec 04             	sub    $0x4,%esp
  800e81:	56                   	push   %esi
  800e82:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e85:	50                   	push   %eax
  800e86:	57                   	push   %edi
  800e87:	e8 1a 16 00 00       	call   8024a6 <memmove>
		pos += bn;
  800e8c:	01 f3                	add    %esi,%ebx
		buf += bn;
  800e8e:	01 f7                	add    %esi,%edi
  800e90:	83 c4 10             	add    $0x10,%esp
  800e93:	eb 98                	jmp    800e2d <file_read+0x3b>
	}

	return count;
  800e95:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800ea0:	f3 0f 1e fb          	endbr32 
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	57                   	push   %edi
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
  800eaa:	83 ec 2c             	sub    $0x2c,%esp
  800ead:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800eb0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (f->f_size > newsize)
  800eb3:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800eb9:	39 f8                	cmp    %edi,%eax
  800ebb:	7f 1c                	jg     800ed9 <file_set_size+0x39>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800ebd:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
	flush_block(f);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	53                   	push   %ebx
  800ec7:	e8 76 f5 ff ff       	call   800442 <flush_block>
	return 0;
}
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800ed9:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800edf:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ee4:	0f 48 c2             	cmovs  %edx,%eax
  800ee7:	c1 f8 0c             	sar    $0xc,%eax
  800eea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800eed:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800ef3:	89 fa                	mov    %edi,%edx
  800ef5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800efb:	0f 49 c2             	cmovns %edx,%eax
  800efe:	c1 f8 0c             	sar    $0xc,%eax
  800f01:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800f04:	89 c6                	mov    %eax,%esi
  800f06:	eb 3c                	jmp    800f44 <file_set_size+0xa4>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800f08:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800f0c:	77 af                	ja     800ebd <file_set_size+0x1d>
  800f0e:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800f14:	85 c0                	test   %eax,%eax
  800f16:	74 a5                	je     800ebd <file_set_size+0x1d>
		free_block(f->f_indirect);
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	50                   	push   %eax
  800f1c:	e8 78 f9 ff ff       	call   800899 <free_block>
		f->f_indirect = 0;
  800f21:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800f28:	00 00 00 
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	eb 8d                	jmp    800ebd <file_set_size+0x1d>
			cprintf("warning: file_free_block: %e", r);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	50                   	push   %eax
  800f34:	68 d4 3d 80 00       	push   $0x803dd4
  800f39:	e8 a8 0d 00 00       	call   801ce6 <cprintf>
  800f3e:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800f41:	83 c6 01             	add    $0x1,%esi
  800f44:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f47:	76 bf                	jbe    800f08 <file_set_size+0x68>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	6a 00                	push   $0x0
  800f4e:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800f51:	89 f2                	mov    %esi,%edx
  800f53:	89 d8                	mov    %ebx,%eax
  800f55:	e8 ed f9 ff ff       	call   800947 <file_block_walk>
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	78 cf                	js     800f30 <file_set_size+0x90>
	if (*ptr) {
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	8b 00                	mov    (%eax),%eax
  800f66:	85 c0                	test   %eax,%eax
  800f68:	74 d7                	je     800f41 <file_set_size+0xa1>
		free_block(*ptr);
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	50                   	push   %eax
  800f6e:	e8 26 f9 ff ff       	call   800899 <free_block>
		*ptr = 0;
  800f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	eb c0                	jmp    800f41 <file_set_size+0xa1>

00800f81 <file_write>:
{
  800f81:	f3 0f 1e fb          	endbr32 
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 2c             	sub    $0x2c,%esp
  800f8e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f91:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800f94:	89 d8                	mov    %ebx,%eax
  800f96:	03 45 10             	add    0x10(%ebp),%eax
  800f99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f9f:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800fa5:	77 68                	ja     80100f <file_write+0x8e>
	for (pos = offset; pos < offset + count; ) {
  800fa7:	89 de                	mov    %ebx,%esi
  800fa9:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800fac:	76 74                	jbe    801022 <file_write+0xa1>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800fae:	83 ec 04             	sub    $0x4,%esp
  800fb1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fb4:	50                   	push   %eax
  800fb5:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800fbb:	85 db                	test   %ebx,%ebx
  800fbd:	0f 49 c3             	cmovns %ebx,%eax
  800fc0:	c1 f8 0c             	sar    $0xc,%eax
  800fc3:	50                   	push   %eax
  800fc4:	ff 75 08             	pushl  0x8(%ebp)
  800fc7:	e8 4d fb ff ff       	call   800b19 <file_get_block>
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	78 52                	js     801025 <file_write+0xa4>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800fd3:	89 da                	mov    %ebx,%edx
  800fd5:	c1 fa 1f             	sar    $0x1f,%edx
  800fd8:	c1 ea 14             	shr    $0x14,%edx
  800fdb:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800fde:	25 ff 0f 00 00       	and    $0xfff,%eax
  800fe3:	29 d0                	sub    %edx,%eax
  800fe5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800fea:	29 c1                	sub    %eax,%ecx
  800fec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fef:	29 f2                	sub    %esi,%edx
  800ff1:	39 d1                	cmp    %edx,%ecx
  800ff3:	89 d6                	mov    %edx,%esi
  800ff5:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800ff8:	83 ec 04             	sub    $0x4,%esp
  800ffb:	56                   	push   %esi
  800ffc:	57                   	push   %edi
  800ffd:	03 45 e4             	add    -0x1c(%ebp),%eax
  801000:	50                   	push   %eax
  801001:	e8 a0 14 00 00       	call   8024a6 <memmove>
		pos += bn;
  801006:	01 f3                	add    %esi,%ebx
		buf += bn;
  801008:	01 f7                	add    %esi,%edi
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	eb 98                	jmp    800fa7 <file_write+0x26>
		if ((r = file_set_size(f, offset + count)) < 0)
  80100f:	83 ec 08             	sub    $0x8,%esp
  801012:	50                   	push   %eax
  801013:	51                   	push   %ecx
  801014:	e8 87 fe ff ff       	call   800ea0 <file_set_size>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	79 87                	jns    800fa7 <file_write+0x26>
  801020:	eb 03                	jmp    801025 <file_write+0xa4>
	return count;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801025:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801028:	5b                   	pop    %ebx
  801029:	5e                   	pop    %esi
  80102a:	5f                   	pop    %edi
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  80102d:	f3 0f 1e fb          	endbr32 
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
  801036:	83 ec 10             	sub    $0x10,%esp
  801039:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	eb 03                	jmp    801046 <file_flush+0x19>
  801043:	83 c3 01             	add    $0x1,%ebx
  801046:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  80104c:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  801052:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801058:	0f 49 c2             	cmovns %edx,%eax
  80105b:	c1 f8 0c             	sar    $0xc,%eax
  80105e:	39 d8                	cmp    %ebx,%eax
  801060:	7e 3b                	jle    80109d <file_flush+0x70>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801062:	83 ec 0c             	sub    $0xc,%esp
  801065:	6a 00                	push   $0x0
  801067:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  80106a:	89 da                	mov    %ebx,%edx
  80106c:	89 f0                	mov    %esi,%eax
  80106e:	e8 d4 f8 ff ff       	call   800947 <file_block_walk>
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	85 c0                	test   %eax,%eax
  801078:	78 c9                	js     801043 <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  80107a:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80107d:	85 c0                	test   %eax,%eax
  80107f:	74 c2                	je     801043 <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  801081:	8b 00                	mov    (%eax),%eax
  801083:	85 c0                	test   %eax,%eax
  801085:	74 bc                	je     801043 <file_flush+0x16>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801087:	83 ec 0c             	sub    $0xc,%esp
  80108a:	50                   	push   %eax
  80108b:	e8 28 f3 ff ff       	call   8003b8 <diskaddr>
  801090:	89 04 24             	mov    %eax,(%esp)
  801093:	e8 aa f3 ff ff       	call   800442 <flush_block>
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	eb a6                	jmp    801043 <file_flush+0x16>
	}
	flush_block(f);
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	56                   	push   %esi
  8010a1:	e8 9c f3 ff ff       	call   800442 <flush_block>
	if (f->f_indirect)
  8010a6:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	75 07                	jne    8010ba <file_flush+0x8d>
		flush_block(diskaddr(f->f_indirect));
}
  8010b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010b6:	5b                   	pop    %ebx
  8010b7:	5e                   	pop    %esi
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	50                   	push   %eax
  8010be:	e8 f5 f2 ff ff       	call   8003b8 <diskaddr>
  8010c3:	89 04 24             	mov    %eax,(%esp)
  8010c6:	e8 77 f3 ff ff       	call   800442 <flush_block>
  8010cb:	83 c4 10             	add    $0x10,%esp
}
  8010ce:	eb e3                	jmp    8010b3 <file_flush+0x86>

008010d0 <file_create>:
{
  8010d0:	f3 0f 1e fb          	endbr32 
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
  8010da:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8010e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8010e6:	50                   	push   %eax
  8010e7:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  8010ed:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	e8 aa fa ff ff       	call   800ba5 <walk_path>
  8010fb:	83 c4 10             	add    $0x10,%esp
  8010fe:	85 c0                	test   %eax,%eax
  801100:	0f 84 0b 01 00 00    	je     801211 <file_create+0x141>
	if (r != -E_NOT_FOUND || dir == 0)
  801106:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801109:	0f 85 ca 00 00 00    	jne    8011d9 <file_create+0x109>
  80110f:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  801115:	85 f6                	test   %esi,%esi
  801117:	0f 84 bc 00 00 00    	je     8011d9 <file_create+0x109>
	assert((dir->f_size % BLKSIZE) == 0);
  80111d:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  801123:	89 c3                	mov    %eax,%ebx
  801125:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  80112b:	75 57                	jne    801184 <file_create+0xb4>
	nblock = dir->f_size / BLKSIZE;
  80112d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801133:	85 c0                	test   %eax,%eax
  801135:	0f 48 c2             	cmovs  %edx,%eax
  801138:	c1 f8 0c             	sar    $0xc,%eax
  80113b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801141:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  801147:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  80114d:	0f 84 8e 00 00 00    	je     8011e1 <file_create+0x111>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801153:	83 ec 04             	sub    $0x4,%esp
  801156:	57                   	push   %edi
  801157:	53                   	push   %ebx
  801158:	56                   	push   %esi
  801159:	e8 bb f9 ff ff       	call   800b19 <file_get_block>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	78 74                	js     8011d9 <file_create+0x109>
  801165:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80116b:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  801171:	80 38 00             	cmpb   $0x0,(%eax)
  801174:	74 27                	je     80119d <file_create+0xcd>
  801176:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  80117b:	39 d0                	cmp    %edx,%eax
  80117d:	75 f2                	jne    801171 <file_create+0xa1>
	for (i = 0; i < nblock; i++) {
  80117f:	83 c3 01             	add    $0x1,%ebx
  801182:	eb c3                	jmp    801147 <file_create+0x77>
	assert((dir->f_size % BLKSIZE) == 0);
  801184:	68 b7 3d 80 00       	push   $0x803db7
  801189:	68 1d 3b 80 00       	push   $0x803b1d
  80118e:	68 eb 00 00 00       	push   $0xeb
  801193:	68 1f 3d 80 00       	push   $0x803d1f
  801198:	e8 62 0a 00 00       	call   801bff <_panic>
				*file = &f[j];
  80119d:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8011ac:	50                   	push   %eax
  8011ad:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  8011b3:	e8 38 11 00 00       	call   8022f0 <strcpy>
	*pf = f;
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8011c1:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8011c3:	83 c4 04             	add    $0x4,%esp
  8011c6:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  8011cc:	e8 5c fe ff ff       	call   80102d <file_flush>
	return 0;
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011dc:	5b                   	pop    %ebx
  8011dd:	5e                   	pop    %esi
  8011de:	5f                   	pop    %edi
  8011df:	5d                   	pop    %ebp
  8011e0:	c3                   	ret    
	dir->f_size += BLKSIZE;
  8011e1:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  8011e8:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8011eb:	83 ec 04             	sub    $0x4,%esp
  8011ee:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8011f4:	50                   	push   %eax
  8011f5:	53                   	push   %ebx
  8011f6:	56                   	push   %esi
  8011f7:	e8 1d f9 ff ff       	call   800b19 <file_get_block>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 d6                	js     8011d9 <file_create+0x109>
	*file = &f[0];
  801203:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801209:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	return 0;
  80120f:	eb 92                	jmp    8011a3 <file_create+0xd3>
		return -E_FILE_EXISTS;
  801211:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801216:	eb c1                	jmp    8011d9 <file_create+0x109>

00801218 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801218:	f3 0f 1e fb          	endbr32 
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	53                   	push   %ebx
  801220:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801223:	bb 01 00 00 00       	mov    $0x1,%ebx
  801228:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80122d:	39 58 04             	cmp    %ebx,0x4(%eax)
  801230:	76 19                	jbe    80124b <fs_sync+0x33>
		flush_block(diskaddr(i));
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	53                   	push   %ebx
  801236:	e8 7d f1 ff ff       	call   8003b8 <diskaddr>
  80123b:	89 04 24             	mov    %eax,(%esp)
  80123e:	e8 ff f1 ff ff       	call   800442 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  801243:	83 c3 01             	add    $0x1,%ebx
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	eb dd                	jmp    801228 <fs_sync+0x10>
}
  80124b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801250:	f3 0f 1e fb          	endbr32 
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  80125a:	e8 b9 ff ff ff       	call   801218 <fs_sync>
	return 0;
}
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <serve_init>:
{
  801266:	f3 0f 1e fb          	endbr32 
  80126a:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  80126f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801274:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801279:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  80127b:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  80127e:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801284:	83 c0 01             	add    $0x1,%eax
  801287:	83 c2 10             	add    $0x10,%edx
  80128a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80128f:	75 e8                	jne    801279 <serve_init+0x13>
}
  801291:	c3                   	ret    

00801292 <openfile_alloc>:
{
  801292:	f3 0f 1e fb          	endbr32 
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
  80129c:	83 ec 0c             	sub    $0xc,%esp
  80129f:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  8012a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a7:	89 de                	mov    %ebx,%esi
  8012a9:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  8012b5:	e8 77 20 00 00       	call   803331 <pageref>
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	74 17                	je     8012d8 <openfile_alloc+0x46>
  8012c1:	83 f8 01             	cmp    $0x1,%eax
  8012c4:	74 30                	je     8012f6 <openfile_alloc+0x64>
	for (i = 0; i < MAXOPEN; i++) {
  8012c6:	83 c3 01             	add    $0x1,%ebx
  8012c9:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8012cf:	75 d6                	jne    8012a7 <openfile_alloc+0x15>
	return -E_MAX_OPEN;
  8012d1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012d6:	eb 4f                	jmp    801327 <openfile_alloc+0x95>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	6a 07                	push   $0x7
  8012dd:	89 d8                	mov    %ebx,%eax
  8012df:	c1 e0 04             	shl    $0x4,%eax
  8012e2:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  8012e8:	6a 00                	push   $0x0
  8012ea:	e8 43 14 00 00       	call   802732 <sys_page_alloc>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 31                	js     801327 <openfile_alloc+0x95>
			opentab[i].o_fileid += MAXOPEN;
  8012f6:	c1 e3 04             	shl    $0x4,%ebx
  8012f9:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801300:	04 00 00 
			*o = &opentab[i];
  801303:	81 c6 60 50 80 00    	add    $0x805060,%esi
  801309:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	68 00 10 00 00       	push   $0x1000
  801313:	6a 00                	push   $0x0
  801315:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  80131b:	e8 3a 11 00 00       	call   80245a <memset>
			return (*o)->o_fileid;
  801320:	8b 07                	mov    (%edi),%eax
  801322:	8b 00                	mov    (%eax),%eax
  801324:	83 c4 10             	add    $0x10,%esp
}
  801327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132a:	5b                   	pop    %ebx
  80132b:	5e                   	pop    %esi
  80132c:	5f                   	pop    %edi
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <openfile_lookup>:
{
  80132f:	f3 0f 1e fb          	endbr32 
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	57                   	push   %edi
  801337:	56                   	push   %esi
  801338:	53                   	push   %ebx
  801339:	83 ec 18             	sub    $0x18,%esp
  80133c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  80133f:	89 fb                	mov    %edi,%ebx
  801341:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801347:	89 de                	mov    %ebx,%esi
  801349:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80134c:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  801352:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  801358:	e8 d4 1f 00 00       	call   803331 <pageref>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	83 f8 01             	cmp    $0x1,%eax
  801363:	7e 1d                	jle    801382 <openfile_lookup+0x53>
  801365:	c1 e3 04             	shl    $0x4,%ebx
  801368:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  80136e:	75 19                	jne    801389 <openfile_lookup+0x5a>
	*po = o;
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	89 30                	mov    %esi,(%eax)
	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137d:	5b                   	pop    %ebx
  80137e:	5e                   	pop    %esi
  80137f:	5f                   	pop    %edi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    
		return -E_INVAL;
  801382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801387:	eb f1                	jmp    80137a <openfile_lookup+0x4b>
  801389:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138e:	eb ea                	jmp    80137a <openfile_lookup+0x4b>

00801390 <serve_set_size>:
{
  801390:	f3 0f 1e fb          	endbr32 
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	53                   	push   %ebx
  801398:	83 ec 18             	sub    $0x18,%esp
  80139b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80139e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a1:	50                   	push   %eax
  8013a2:	ff 33                	pushl  (%ebx)
  8013a4:	ff 75 08             	pushl  0x8(%ebp)
  8013a7:	e8 83 ff ff ff       	call   80132f <openfile_lookup>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 14                	js     8013c7 <serve_set_size+0x37>
	return file_set_size(o->o_file, req->req_size);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 73 04             	pushl  0x4(%ebx)
  8013b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bc:	ff 70 04             	pushl  0x4(%eax)
  8013bf:	e8 dc fa ff ff       	call   800ea0 <file_set_size>
  8013c4:	83 c4 10             	add    $0x10,%esp
}
  8013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <serve_read>:
{
  8013cc:	f3 0f 1e fb          	endbr32 
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 18             	sub    $0x18,%esp
  8013d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if((r=openfile_lookup(envid,req->req_fileid,&o))<0)
  8013da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013dd:	50                   	push   %eax
  8013de:	ff 33                	pushl  (%ebx)
  8013e0:	ff 75 08             	pushl  0x8(%ebp)
  8013e3:	e8 47 ff ff ff       	call   80132f <openfile_lookup>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 33                	js     801422 <serve_read+0x56>
	if((r=file_read(o->o_file,ret->ret_buf,req_n,o->o_fd->fd_offset))<0)
  8013ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f2:	8b 42 0c             	mov    0xc(%edx),%eax
  8013f5:	ff 70 04             	pushl  0x4(%eax)
	req_n=req->req_n<=PGSIZE?req->req_n:PGSIZE;
  8013f8:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  8013ff:	b8 00 10 00 00       	mov    $0x1000,%eax
  801404:	0f 46 43 04          	cmovbe 0x4(%ebx),%eax
	if((r=file_read(o->o_file,ret->ret_buf,req_n,o->o_fd->fd_offset))<0)
  801408:	50                   	push   %eax
  801409:	53                   	push   %ebx
  80140a:	ff 72 04             	pushl  0x4(%edx)
  80140d:	e8 e0 f9 ff ff       	call   800df2 <file_read>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 09                	js     801422 <serve_read+0x56>
	o->o_fd->fd_offset+=r;
  801419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141c:	8b 52 0c             	mov    0xc(%edx),%edx
  80141f:	01 42 04             	add    %eax,0x4(%edx)
}
  801422:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <serve_write>:
{
  801427:	f3 0f 1e fb          	endbr32 
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	53                   	push   %ebx
  80142f:	83 ec 18             	sub    $0x18,%esp
  801432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if((r=openfile_lookup(envid,req->req_fileid,&o))<0)
  801435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	ff 33                	pushl  (%ebx)
  80143b:	ff 75 08             	pushl  0x8(%ebp)
  80143e:	e8 ec fe ff ff       	call   80132f <openfile_lookup>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 36                	js     801480 <serve_write+0x59>
	if((r=file_write(o->o_file,req->req_buf,req_n,o->o_fd->fd_offset))<0)
  80144a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144d:	8b 42 0c             	mov    0xc(%edx),%eax
  801450:	ff 70 04             	pushl  0x4(%eax)
	req_n=req->req_n<=PGSIZE?req->req_n:PGSIZE;
  801453:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  80145a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80145f:	0f 46 43 04          	cmovbe 0x4(%ebx),%eax
	if((r=file_write(o->o_file,req->req_buf,req_n,o->o_fd->fd_offset))<0)
  801463:	50                   	push   %eax
  801464:	83 c3 08             	add    $0x8,%ebx
  801467:	53                   	push   %ebx
  801468:	ff 72 04             	pushl  0x4(%edx)
  80146b:	e8 11 fb ff ff       	call   800f81 <file_write>
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	78 09                	js     801480 <serve_write+0x59>
	o->o_fd->fd_offset+=r;
  801477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147a:	8b 52 0c             	mov    0xc(%edx),%edx
  80147d:	01 42 04             	add    %eax,0x4(%edx)
}
  801480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <serve_stat>:
{
  801485:	f3 0f 1e fb          	endbr32 
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	53                   	push   %ebx
  80148d:	83 ec 18             	sub    $0x18,%esp
  801490:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801493:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801496:	50                   	push   %eax
  801497:	ff 33                	pushl  (%ebx)
  801499:	ff 75 08             	pushl  0x8(%ebp)
  80149c:	e8 8e fe ff ff       	call   80132f <openfile_lookup>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 3f                	js     8014e7 <serve_stat+0x62>
	strcpy(ret->ret_name, o->o_file->f_name);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ae:	ff 70 04             	pushl  0x4(%eax)
  8014b1:	53                   	push   %ebx
  8014b2:	e8 39 0e 00 00       	call   8022f0 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8014b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ba:	8b 50 04             	mov    0x4(%eax),%edx
  8014bd:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8014c3:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8014c9:	8b 40 04             	mov    0x4(%eax),%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8014d6:	0f 94 c0             	sete   %al
  8014d9:	0f b6 c0             	movzbl %al,%eax
  8014dc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <serve_flush>:
{
  8014ec:	f3 0f 1e fb          	endbr32 
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fd:	ff 30                	pushl  (%eax)
  8014ff:	ff 75 08             	pushl  0x8(%ebp)
  801502:	e8 28 fe ff ff       	call   80132f <openfile_lookup>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 16                	js     801524 <serve_flush+0x38>
	file_flush(o->o_file);
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	ff 70 04             	pushl  0x4(%eax)
  801517:	e8 11 fb ff ff       	call   80102d <file_flush>
	return 0;
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <serve_open>:
{
  801526:	f3 0f 1e fb          	endbr32 
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	53                   	push   %ebx
  80152e:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801534:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  801537:	68 00 04 00 00       	push   $0x400
  80153c:	53                   	push   %ebx
  80153d:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801543:	50                   	push   %eax
  801544:	e8 5d 0f 00 00       	call   8024a6 <memmove>
	path[MAXPATHLEN-1] = 0;
  801549:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  80154d:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801553:	89 04 24             	mov    %eax,(%esp)
  801556:	e8 37 fd ff ff       	call   801292 <openfile_alloc>
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	0f 88 f0 00 00 00    	js     801656 <serve_open+0x130>
	if (req->req_omode & O_CREAT) {
  801566:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  80156d:	74 33                	je     8015a2 <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80157f:	50                   	push   %eax
  801580:	e8 4b fb ff ff       	call   8010d0 <file_create>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	79 37                	jns    8015c3 <serve_open+0x9d>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80158c:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801593:	0f 85 bd 00 00 00    	jne    801656 <serve_open+0x130>
  801599:	83 f8 f3             	cmp    $0xfffffff3,%eax
  80159c:	0f 85 b4 00 00 00    	jne    801656 <serve_open+0x130>
		if ((r = file_open(path, &f)) < 0) {
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015ab:	50                   	push   %eax
  8015ac:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	e8 1c f8 ff ff       	call   800dd4 <file_open>
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	0f 88 93 00 00 00    	js     801656 <serve_open+0x130>
	if (req->req_omode & O_TRUNC) {
  8015c3:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8015ca:	74 17                	je     8015e3 <serve_open+0xbd>
		if ((r = file_set_size(f, 0)) < 0) {
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	6a 00                	push   $0x0
  8015d1:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  8015d7:	e8 c4 f8 ff ff       	call   800ea0 <file_set_size>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 73                	js     801656 <serve_open+0x130>
	if ((r = file_open(path, &f)) < 0) {
  8015e3:	83 ec 08             	sub    $0x8,%esp
  8015e6:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015ec:	50                   	push   %eax
  8015ed:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015f3:	50                   	push   %eax
  8015f4:	e8 db f7 ff ff       	call   800dd4 <file_open>
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 56                	js     801656 <serve_open+0x130>
	o->o_file = f;
  801600:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801606:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80160c:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  80160f:	8b 50 0c             	mov    0xc(%eax),%edx
  801612:	8b 08                	mov    (%eax),%ecx
  801614:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801617:	8b 48 0c             	mov    0xc(%eax),%ecx
  80161a:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801620:	83 e2 03             	and    $0x3,%edx
  801623:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801626:	8b 40 0c             	mov    0xc(%eax),%eax
  801629:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80162f:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801631:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801637:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80163d:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  801640:	8b 50 0c             	mov    0xc(%eax),%edx
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801648:	8b 45 14             	mov    0x14(%ebp),%eax
  80164b:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  80165b:	f3 0f 1e fb          	endbr32 
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801667:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80166a:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80166d:	e9 82 00 00 00       	jmp    8016f4 <serve+0x99>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  801672:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  801679:	83 f8 01             	cmp    $0x1,%eax
  80167c:	74 23                	je     8016a1 <serve+0x46>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  80167e:	83 f8 08             	cmp    $0x8,%eax
  801681:	77 36                	ja     8016b9 <serve+0x5e>
  801683:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  80168a:	85 d2                	test   %edx,%edx
  80168c:	74 2b                	je     8016b9 <serve+0x5e>
			r = handlers[req](whom, fsreq);
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	ff 35 44 50 80 00    	pushl  0x805044
  801697:	ff 75 f4             	pushl  -0xc(%ebp)
  80169a:	ff d2                	call   *%edx
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	eb 31                	jmp    8016d2 <serve+0x77>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8016a1:	53                   	push   %ebx
  8016a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016a5:	50                   	push   %eax
  8016a6:	ff 35 44 50 80 00    	pushl  0x805044
  8016ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8016af:	e8 72 fe ff ff       	call   801526 <serve_open>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	eb 19                	jmp    8016d2 <serve+0x77>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8016bf:	50                   	push   %eax
  8016c0:	68 24 3e 80 00       	push   $0x803e24
  8016c5:	e8 1c 06 00 00       	call   801ce6 <cprintf>
  8016ca:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8016cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8016d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d8:	50                   	push   %eax
  8016d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8016dc:	e8 6f 13 00 00       	call   802a50 <ipc_send>
		sys_page_unmap(0, fsreq);
  8016e1:	83 c4 08             	add    $0x8,%esp
  8016e4:	ff 35 44 50 80 00    	pushl  0x805044
  8016ea:	6a 00                	push   $0x0
  8016ec:	e8 ce 10 00 00       	call   8027bf <sys_page_unmap>
  8016f1:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  8016f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	53                   	push   %ebx
  8016ff:	ff 35 44 50 80 00    	pushl  0x805044
  801705:	56                   	push   %esi
  801706:	e8 d8 12 00 00       	call   8029e3 <ipc_recv>
		if (!(perm & PTE_P)) {
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801712:	0f 85 5a ff ff ff    	jne    801672 <serve+0x17>
			cprintf("Invalid request from %08x: no argument page\n",
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	ff 75 f4             	pushl  -0xc(%ebp)
  80171e:	68 f4 3d 80 00       	push   $0x803df4
  801723:	e8 be 05 00 00       	call   801ce6 <cprintf>
			continue; // just leave it hanging...
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	eb c7                	jmp    8016f4 <serve+0x99>

0080172d <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80172d:	f3 0f 1e fb          	endbr32 
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801737:	c7 05 60 90 80 00 47 	movl   $0x803e47,0x809060
  80173e:	3e 80 00 
	cprintf("FS is running\n");
  801741:	68 4a 3e 80 00       	push   $0x803e4a
  801746:	e8 9b 05 00 00       	call   801ce6 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80174b:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801750:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801755:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801757:	c7 04 24 59 3e 80 00 	movl   $0x803e59,(%esp)
  80175e:	e8 83 05 00 00       	call   801ce6 <cprintf>

	serve_init();
  801763:	e8 fe fa ff ff       	call   801266 <serve_init>
	fs_init();
  801768:	e8 49 f3 ff ff       	call   800ab6 <fs_init>
        fs_test();
  80176d:	e8 05 00 00 00       	call   801777 <fs_test>
	serve();
  801772:	e8 e4 fe ff ff       	call   80165b <serve>

00801777 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801777:	f3 0f 1e fb          	endbr32 
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	53                   	push   %ebx
  80177f:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801782:	6a 07                	push   $0x7
  801784:	68 00 10 00 00       	push   $0x1000
  801789:	6a 00                	push   $0x0
  80178b:	e8 a2 0f 00 00       	call   802732 <sys_page_alloc>
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	0f 88 68 02 00 00    	js     801a03 <fs_test+0x28c>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 00 10 00 00       	push   $0x1000
  8017a3:	ff 35 04 a0 80 00    	pushl  0x80a004
  8017a9:	68 00 10 00 00       	push   $0x1000
  8017ae:	e8 f3 0c 00 00       	call   8024a6 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8017b3:	e8 21 f1 ff ff       	call   8008d9 <alloc_block>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	0f 88 52 02 00 00    	js     801a15 <fs_test+0x29e>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8017c3:	8d 50 1f             	lea    0x1f(%eax),%edx
  8017c6:	0f 49 d0             	cmovns %eax,%edx
  8017c9:	c1 fa 05             	sar    $0x5,%edx
  8017cc:	89 c3                	mov    %eax,%ebx
  8017ce:	c1 fb 1f             	sar    $0x1f,%ebx
  8017d1:	c1 eb 1b             	shr    $0x1b,%ebx
  8017d4:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  8017d7:	83 e1 1f             	and    $0x1f,%ecx
  8017da:	29 d9                	sub    %ebx,%ecx
  8017dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e1:	d3 e0                	shl    %cl,%eax
  8017e3:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  8017ea:	0f 84 37 02 00 00    	je     801a27 <fs_test+0x2b0>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8017f0:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  8017f6:	85 04 91             	test   %eax,(%ecx,%edx,4)
  8017f9:	0f 85 3e 02 00 00    	jne    801a3d <fs_test+0x2c6>
	cprintf("alloc_block is good\n");
  8017ff:	83 ec 0c             	sub    $0xc,%esp
  801802:	68 b0 3e 80 00       	push   $0x803eb0
  801807:	e8 da 04 00 00       	call   801ce6 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80180c:	83 c4 08             	add    $0x8,%esp
  80180f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801812:	50                   	push   %eax
  801813:	68 c5 3e 80 00       	push   $0x803ec5
  801818:	e8 b7 f5 ff ff       	call   800dd4 <file_open>
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801823:	74 08                	je     80182d <fs_test+0xb6>
  801825:	85 c0                	test   %eax,%eax
  801827:	0f 88 26 02 00 00    	js     801a53 <fs_test+0x2dc>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  80182d:	85 c0                	test   %eax,%eax
  80182f:	0f 84 30 02 00 00    	je     801a65 <fs_test+0x2ee>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183b:	50                   	push   %eax
  80183c:	68 e9 3e 80 00       	push   $0x803ee9
  801841:	e8 8e f5 ff ff       	call   800dd4 <file_open>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	0f 88 28 02 00 00    	js     801a79 <fs_test+0x302>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	68 09 3f 80 00       	push   $0x803f09
  801859:	e8 88 04 00 00       	call   801ce6 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80185e:	83 c4 0c             	add    $0xc,%esp
  801861:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801864:	50                   	push   %eax
  801865:	6a 00                	push   $0x0
  801867:	ff 75 f4             	pushl  -0xc(%ebp)
  80186a:	e8 aa f2 ff ff       	call   800b19 <file_get_block>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	0f 88 11 02 00 00    	js     801a8b <fs_test+0x314>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	68 50 40 80 00       	push   $0x804050
  801882:	ff 75 f0             	pushl  -0x10(%ebp)
  801885:	e8 25 0b 00 00       	call   8023af <strcmp>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	85 c0                	test   %eax,%eax
  80188f:	0f 85 08 02 00 00    	jne    801a9d <fs_test+0x326>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	68 2f 3f 80 00       	push   $0x803f2f
  80189d:	e8 44 04 00 00       	call   801ce6 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a5:	0f b6 10             	movzbl (%eax),%edx
  8018a8:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	c1 e8 0c             	shr    $0xc,%eax
  8018b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	a8 40                	test   $0x40,%al
  8018bc:	0f 84 ef 01 00 00    	je     801ab1 <fs_test+0x33a>
	file_flush(f);
  8018c2:	83 ec 0c             	sub    $0xc,%esp
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	e8 60 f7 ff ff       	call   80102d <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d0:	c1 e8 0c             	shr    $0xc,%eax
  8018d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	a8 40                	test   $0x40,%al
  8018df:	0f 85 e2 01 00 00    	jne    801ac7 <fs_test+0x350>
	cprintf("file_flush is good\n");
  8018e5:	83 ec 0c             	sub    $0xc,%esp
  8018e8:	68 63 3f 80 00       	push   $0x803f63
  8018ed:	e8 f4 03 00 00       	call   801ce6 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8018f2:	83 c4 08             	add    $0x8,%esp
  8018f5:	6a 00                	push   $0x0
  8018f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fa:	e8 a1 f5 ff ff       	call   800ea0 <file_set_size>
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	85 c0                	test   %eax,%eax
  801904:	0f 88 d3 01 00 00    	js     801add <fs_test+0x366>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801914:	0f 85 d5 01 00 00    	jne    801aef <fs_test+0x378>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80191a:	c1 e8 0c             	shr    $0xc,%eax
  80191d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801924:	a8 40                	test   $0x40,%al
  801926:	0f 85 d9 01 00 00    	jne    801b05 <fs_test+0x38e>
	cprintf("file_truncate is good\n");
  80192c:	83 ec 0c             	sub    $0xc,%esp
  80192f:	68 b7 3f 80 00       	push   $0x803fb7
  801934:	e8 ad 03 00 00       	call   801ce6 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801939:	c7 04 24 50 40 80 00 	movl   $0x804050,(%esp)
  801940:	e8 68 09 00 00       	call   8022ad <strlen>
  801945:	83 c4 08             	add    $0x8,%esp
  801948:	50                   	push   %eax
  801949:	ff 75 f4             	pushl  -0xc(%ebp)
  80194c:	e8 4f f5 ff ff       	call   800ea0 <file_set_size>
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	85 c0                	test   %eax,%eax
  801956:	0f 88 bf 01 00 00    	js     801b1b <fs_test+0x3a4>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	89 c2                	mov    %eax,%edx
  801961:	c1 ea 0c             	shr    $0xc,%edx
  801964:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80196b:	f6 c2 40             	test   $0x40,%dl
  80196e:	0f 85 b9 01 00 00    	jne    801b2d <fs_test+0x3b6>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80197a:	52                   	push   %edx
  80197b:	6a 00                	push   $0x0
  80197d:	50                   	push   %eax
  80197e:	e8 96 f1 ff ff       	call   800b19 <file_get_block>
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	85 c0                	test   %eax,%eax
  801988:	0f 88 b5 01 00 00    	js     801b43 <fs_test+0x3cc>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	68 50 40 80 00       	push   $0x804050
  801996:	ff 75 f0             	pushl  -0x10(%ebp)
  801999:	e8 52 09 00 00       	call   8022f0 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80199e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a1:	c1 e8 0c             	shr    $0xc,%eax
  8019a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	a8 40                	test   $0x40,%al
  8019b0:	0f 84 9f 01 00 00    	je     801b55 <fs_test+0x3de>
	file_flush(f);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bc:	e8 6c f6 ff ff       	call   80102d <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c4:	c1 e8 0c             	shr    $0xc,%eax
  8019c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	a8 40                	test   $0x40,%al
  8019d3:	0f 85 92 01 00 00    	jne    801b6b <fs_test+0x3f4>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019dc:	c1 e8 0c             	shr    $0xc,%eax
  8019df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e6:	a8 40                	test   $0x40,%al
  8019e8:	0f 85 93 01 00 00    	jne    801b81 <fs_test+0x40a>
	cprintf("file rewrite is good\n");
  8019ee:	83 ec 0c             	sub    $0xc,%esp
  8019f1:	68 f7 3f 80 00       	push   $0x803ff7
  8019f6:	e8 eb 02 00 00       	call   801ce6 <cprintf>
}
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801a03:	50                   	push   %eax
  801a04:	68 68 3e 80 00       	push   $0x803e68
  801a09:	6a 12                	push   $0x12
  801a0b:	68 7b 3e 80 00       	push   $0x803e7b
  801a10:	e8 ea 01 00 00       	call   801bff <_panic>
		panic("alloc_block: %e", r);
  801a15:	50                   	push   %eax
  801a16:	68 85 3e 80 00       	push   $0x803e85
  801a1b:	6a 17                	push   $0x17
  801a1d:	68 7b 3e 80 00       	push   $0x803e7b
  801a22:	e8 d8 01 00 00       	call   801bff <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801a27:	68 95 3e 80 00       	push   $0x803e95
  801a2c:	68 1d 3b 80 00       	push   $0x803b1d
  801a31:	6a 19                	push   $0x19
  801a33:	68 7b 3e 80 00       	push   $0x803e7b
  801a38:	e8 c2 01 00 00       	call   801bff <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801a3d:	68 10 40 80 00       	push   $0x804010
  801a42:	68 1d 3b 80 00       	push   $0x803b1d
  801a47:	6a 1b                	push   $0x1b
  801a49:	68 7b 3e 80 00       	push   $0x803e7b
  801a4e:	e8 ac 01 00 00       	call   801bff <_panic>
		panic("file_open /not-found: %e", r);
  801a53:	50                   	push   %eax
  801a54:	68 d0 3e 80 00       	push   $0x803ed0
  801a59:	6a 1f                	push   $0x1f
  801a5b:	68 7b 3e 80 00       	push   $0x803e7b
  801a60:	e8 9a 01 00 00       	call   801bff <_panic>
		panic("file_open /not-found succeeded!");
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	68 30 40 80 00       	push   $0x804030
  801a6d:	6a 21                	push   $0x21
  801a6f:	68 7b 3e 80 00       	push   $0x803e7b
  801a74:	e8 86 01 00 00       	call   801bff <_panic>
		panic("file_open /newmotd: %e", r);
  801a79:	50                   	push   %eax
  801a7a:	68 f2 3e 80 00       	push   $0x803ef2
  801a7f:	6a 23                	push   $0x23
  801a81:	68 7b 3e 80 00       	push   $0x803e7b
  801a86:	e8 74 01 00 00       	call   801bff <_panic>
		panic("file_get_block: %e", r);
  801a8b:	50                   	push   %eax
  801a8c:	68 1c 3f 80 00       	push   $0x803f1c
  801a91:	6a 27                	push   $0x27
  801a93:	68 7b 3e 80 00       	push   $0x803e7b
  801a98:	e8 62 01 00 00       	call   801bff <_panic>
		panic("file_get_block returned wrong data");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 78 40 80 00       	push   $0x804078
  801aa5:	6a 29                	push   $0x29
  801aa7:	68 7b 3e 80 00       	push   $0x803e7b
  801aac:	e8 4e 01 00 00       	call   801bff <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ab1:	68 48 3f 80 00       	push   $0x803f48
  801ab6:	68 1d 3b 80 00       	push   $0x803b1d
  801abb:	6a 2d                	push   $0x2d
  801abd:	68 7b 3e 80 00       	push   $0x803e7b
  801ac2:	e8 38 01 00 00       	call   801bff <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801ac7:	68 47 3f 80 00       	push   $0x803f47
  801acc:	68 1d 3b 80 00       	push   $0x803b1d
  801ad1:	6a 2f                	push   $0x2f
  801ad3:	68 7b 3e 80 00       	push   $0x803e7b
  801ad8:	e8 22 01 00 00       	call   801bff <_panic>
		panic("file_set_size: %e", r);
  801add:	50                   	push   %eax
  801ade:	68 77 3f 80 00       	push   $0x803f77
  801ae3:	6a 33                	push   $0x33
  801ae5:	68 7b 3e 80 00       	push   $0x803e7b
  801aea:	e8 10 01 00 00       	call   801bff <_panic>
	assert(f->f_direct[0] == 0);
  801aef:	68 89 3f 80 00       	push   $0x803f89
  801af4:	68 1d 3b 80 00       	push   $0x803b1d
  801af9:	6a 34                	push   $0x34
  801afb:	68 7b 3e 80 00       	push   $0x803e7b
  801b00:	e8 fa 00 00 00       	call   801bff <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b05:	68 9d 3f 80 00       	push   $0x803f9d
  801b0a:	68 1d 3b 80 00       	push   $0x803b1d
  801b0f:	6a 35                	push   $0x35
  801b11:	68 7b 3e 80 00       	push   $0x803e7b
  801b16:	e8 e4 00 00 00       	call   801bff <_panic>
		panic("file_set_size 2: %e", r);
  801b1b:	50                   	push   %eax
  801b1c:	68 ce 3f 80 00       	push   $0x803fce
  801b21:	6a 39                	push   $0x39
  801b23:	68 7b 3e 80 00       	push   $0x803e7b
  801b28:	e8 d2 00 00 00       	call   801bff <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b2d:	68 9d 3f 80 00       	push   $0x803f9d
  801b32:	68 1d 3b 80 00       	push   $0x803b1d
  801b37:	6a 3a                	push   $0x3a
  801b39:	68 7b 3e 80 00       	push   $0x803e7b
  801b3e:	e8 bc 00 00 00       	call   801bff <_panic>
		panic("file_get_block 2: %e", r);
  801b43:	50                   	push   %eax
  801b44:	68 e2 3f 80 00       	push   $0x803fe2
  801b49:	6a 3c                	push   $0x3c
  801b4b:	68 7b 3e 80 00       	push   $0x803e7b
  801b50:	e8 aa 00 00 00       	call   801bff <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b55:	68 48 3f 80 00       	push   $0x803f48
  801b5a:	68 1d 3b 80 00       	push   $0x803b1d
  801b5f:	6a 3e                	push   $0x3e
  801b61:	68 7b 3e 80 00       	push   $0x803e7b
  801b66:	e8 94 00 00 00       	call   801bff <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b6b:	68 47 3f 80 00       	push   $0x803f47
  801b70:	68 1d 3b 80 00       	push   $0x803b1d
  801b75:	6a 40                	push   $0x40
  801b77:	68 7b 3e 80 00       	push   $0x803e7b
  801b7c:	e8 7e 00 00 00       	call   801bff <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b81:	68 9d 3f 80 00       	push   $0x803f9d
  801b86:	68 1d 3b 80 00       	push   $0x803b1d
  801b8b:	6a 41                	push   $0x41
  801b8d:	68 7b 3e 80 00       	push   $0x803e7b
  801b92:	e8 68 00 00 00       	call   801bff <_panic>

00801b97 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801b97:	f3 0f 1e fb          	endbr32 
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ba3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801ba6:	e8 41 0b 00 00       	call   8026ec <sys_getenvid>
  801bab:	25 ff 03 00 00       	and    $0x3ff,%eax
  801bb0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bb3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801bb8:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801bbd:	85 db                	test   %ebx,%ebx
  801bbf:	7e 07                	jle    801bc8 <libmain+0x31>
		binaryname = argv[0];
  801bc1:	8b 06                	mov    (%esi),%eax
  801bc3:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	56                   	push   %esi
  801bcc:	53                   	push   %ebx
  801bcd:	e8 5b fb ff ff       	call   80172d <umain>

	// exit gracefully
	exit();
  801bd2:	e8 0a 00 00 00       	call   801be1 <exit>
}
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdd:	5b                   	pop    %ebx
  801bde:	5e                   	pop    %esi
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    

00801be1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801be1:	f3 0f 1e fb          	endbr32 
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801beb:	e8 e6 10 00 00       	call   802cd6 <close_all>
	sys_env_destroy(0);
  801bf0:	83 ec 0c             	sub    $0xc,%esp
  801bf3:	6a 00                	push   $0x0
  801bf5:	e8 ad 0a 00 00       	call   8026a7 <sys_env_destroy>
}
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bff:	f3 0f 1e fb          	endbr32 
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801c08:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c0b:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801c11:	e8 d6 0a 00 00       	call   8026ec <sys_getenvid>
  801c16:	83 ec 0c             	sub    $0xc,%esp
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	56                   	push   %esi
  801c20:	50                   	push   %eax
  801c21:	68 a8 40 80 00       	push   $0x8040a8
  801c26:	e8 bb 00 00 00       	call   801ce6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c2b:	83 c4 18             	add    $0x18,%esp
  801c2e:	53                   	push   %ebx
  801c2f:	ff 75 10             	pushl  0x10(%ebp)
  801c32:	e8 5a 00 00 00       	call   801c91 <vcprintf>
	cprintf("\n");
  801c37:	c7 04 24 b6 3c 80 00 	movl   $0x803cb6,(%esp)
  801c3e:	e8 a3 00 00 00       	call   801ce6 <cprintf>
  801c43:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c46:	cc                   	int3   
  801c47:	eb fd                	jmp    801c46 <_panic+0x47>

00801c49 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c49:	f3 0f 1e fb          	endbr32 
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	53                   	push   %ebx
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c57:	8b 13                	mov    (%ebx),%edx
  801c59:	8d 42 01             	lea    0x1(%edx),%eax
  801c5c:	89 03                	mov    %eax,(%ebx)
  801c5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c61:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c65:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c6a:	74 09                	je     801c75 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801c6c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	68 ff 00 00 00       	push   $0xff
  801c7d:	8d 43 08             	lea    0x8(%ebx),%eax
  801c80:	50                   	push   %eax
  801c81:	e8 dc 09 00 00       	call   802662 <sys_cputs>
		b->idx = 0;
  801c86:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	eb db                	jmp    801c6c <putch+0x23>

00801c91 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801c91:	f3 0f 1e fb          	endbr32 
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c9e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ca5:	00 00 00 
	b.cnt = 0;
  801ca8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801caf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801cb2:	ff 75 0c             	pushl  0xc(%ebp)
  801cb5:	ff 75 08             	pushl  0x8(%ebp)
  801cb8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801cbe:	50                   	push   %eax
  801cbf:	68 49 1c 80 00       	push   $0x801c49
  801cc4:	e8 20 01 00 00       	call   801de9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801cc9:	83 c4 08             	add    $0x8,%esp
  801ccc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801cd2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801cd8:	50                   	push   %eax
  801cd9:	e8 84 09 00 00       	call   802662 <sys_cputs>

	return b.cnt;
}
  801cde:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801ce6:	f3 0f 1e fb          	endbr32 
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cf0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801cf3:	50                   	push   %eax
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	e8 95 ff ff ff       	call   801c91 <vcprintf>
	va_end(ap);

	return cnt;
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 1c             	sub    $0x1c,%esp
  801d07:	89 c7                	mov    %eax,%edi
  801d09:	89 d6                	mov    %edx,%esi
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d11:	89 d1                	mov    %edx,%ecx
  801d13:	89 c2                	mov    %eax,%edx
  801d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d18:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801d21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d2b:	39 c2                	cmp    %eax,%edx
  801d2d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801d30:	72 3e                	jb     801d70 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 18             	pushl  0x18(%ebp)
  801d38:	83 eb 01             	sub    $0x1,%ebx
  801d3b:	53                   	push   %ebx
  801d3c:	50                   	push   %eax
  801d3d:	83 ec 08             	sub    $0x8,%esp
  801d40:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d43:	ff 75 e0             	pushl  -0x20(%ebp)
  801d46:	ff 75 dc             	pushl  -0x24(%ebp)
  801d49:	ff 75 d8             	pushl  -0x28(%ebp)
  801d4c:	e8 1f 1b 00 00       	call   803870 <__udivdi3>
  801d51:	83 c4 18             	add    $0x18,%esp
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	89 f2                	mov    %esi,%edx
  801d58:	89 f8                	mov    %edi,%eax
  801d5a:	e8 9f ff ff ff       	call   801cfe <printnum>
  801d5f:	83 c4 20             	add    $0x20,%esp
  801d62:	eb 13                	jmp    801d77 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d64:	83 ec 08             	sub    $0x8,%esp
  801d67:	56                   	push   %esi
  801d68:	ff 75 18             	pushl  0x18(%ebp)
  801d6b:	ff d7                	call   *%edi
  801d6d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801d70:	83 eb 01             	sub    $0x1,%ebx
  801d73:	85 db                	test   %ebx,%ebx
  801d75:	7f ed                	jg     801d64 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d77:	83 ec 08             	sub    $0x8,%esp
  801d7a:	56                   	push   %esi
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d81:	ff 75 e0             	pushl  -0x20(%ebp)
  801d84:	ff 75 dc             	pushl  -0x24(%ebp)
  801d87:	ff 75 d8             	pushl  -0x28(%ebp)
  801d8a:	e8 f1 1b 00 00       	call   803980 <__umoddi3>
  801d8f:	83 c4 14             	add    $0x14,%esp
  801d92:	0f be 80 cb 40 80 00 	movsbl 0x8040cb(%eax),%eax
  801d99:	50                   	push   %eax
  801d9a:	ff d7                	call   *%edi
}
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da2:	5b                   	pop    %ebx
  801da3:	5e                   	pop    %esi
  801da4:	5f                   	pop    %edi
  801da5:	5d                   	pop    %ebp
  801da6:	c3                   	ret    

00801da7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801da7:	f3 0f 1e fb          	endbr32 
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801db1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801db5:	8b 10                	mov    (%eax),%edx
  801db7:	3b 50 04             	cmp    0x4(%eax),%edx
  801dba:	73 0a                	jae    801dc6 <sprintputch+0x1f>
		*b->buf++ = ch;
  801dbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dbf:	89 08                	mov    %ecx,(%eax)
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	88 02                	mov    %al,(%edx)
}
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    

00801dc8 <printfmt>:
{
  801dc8:	f3 0f 1e fb          	endbr32 
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801dd2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801dd5:	50                   	push   %eax
  801dd6:	ff 75 10             	pushl  0x10(%ebp)
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	e8 05 00 00 00       	call   801de9 <vprintfmt>
}
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <vprintfmt>:
{
  801de9:	f3 0f 1e fb          	endbr32 
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	57                   	push   %edi
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	83 ec 3c             	sub    $0x3c,%esp
  801df6:	8b 75 08             	mov    0x8(%ebp),%esi
  801df9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801dfc:	8b 7d 10             	mov    0x10(%ebp),%edi
  801dff:	e9 8e 03 00 00       	jmp    802192 <vprintfmt+0x3a9>
		padc = ' ';
  801e04:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801e08:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801e0f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801e16:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801e1d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e22:	8d 47 01             	lea    0x1(%edi),%eax
  801e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e28:	0f b6 17             	movzbl (%edi),%edx
  801e2b:	8d 42 dd             	lea    -0x23(%edx),%eax
  801e2e:	3c 55                	cmp    $0x55,%al
  801e30:	0f 87 df 03 00 00    	ja     802215 <vprintfmt+0x42c>
  801e36:	0f b6 c0             	movzbl %al,%eax
  801e39:	3e ff 24 85 00 42 80 	notrack jmp *0x804200(,%eax,4)
  801e40:	00 
  801e41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801e44:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801e48:	eb d8                	jmp    801e22 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801e4a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801e4d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801e51:	eb cf                	jmp    801e22 <vprintfmt+0x39>
  801e53:	0f b6 d2             	movzbl %dl,%edx
  801e56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801e61:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801e64:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801e68:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801e6b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801e6e:	83 f9 09             	cmp    $0x9,%ecx
  801e71:	77 55                	ja     801ec8 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801e73:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801e76:	eb e9                	jmp    801e61 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801e78:	8b 45 14             	mov    0x14(%ebp),%eax
  801e7b:	8b 00                	mov    (%eax),%eax
  801e7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e80:	8b 45 14             	mov    0x14(%ebp),%eax
  801e83:	8d 40 04             	lea    0x4(%eax),%eax
  801e86:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e89:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801e8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e90:	79 90                	jns    801e22 <vprintfmt+0x39>
				width = precision, precision = -1;
  801e92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e98:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801e9f:	eb 81                	jmp    801e22 <vprintfmt+0x39>
  801ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	0f 49 d0             	cmovns %eax,%edx
  801eae:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801eb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801eb4:	e9 69 ff ff ff       	jmp    801e22 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801eb9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801ebc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801ec3:	e9 5a ff ff ff       	jmp    801e22 <vprintfmt+0x39>
  801ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801ecb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ece:	eb bc                	jmp    801e8c <vprintfmt+0xa3>
			lflag++;
  801ed0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801ed3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ed6:	e9 47 ff ff ff       	jmp    801e22 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801edb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ede:	8d 78 04             	lea    0x4(%eax),%edi
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	53                   	push   %ebx
  801ee5:	ff 30                	pushl  (%eax)
  801ee7:	ff d6                	call   *%esi
			break;
  801ee9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801eec:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801eef:	e9 9b 02 00 00       	jmp    80218f <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef7:	8d 78 04             	lea    0x4(%eax),%edi
  801efa:	8b 00                	mov    (%eax),%eax
  801efc:	99                   	cltd   
  801efd:	31 d0                	xor    %edx,%eax
  801eff:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801f01:	83 f8 0f             	cmp    $0xf,%eax
  801f04:	7f 23                	jg     801f29 <vprintfmt+0x140>
  801f06:	8b 14 85 60 43 80 00 	mov    0x804360(,%eax,4),%edx
  801f0d:	85 d2                	test   %edx,%edx
  801f0f:	74 18                	je     801f29 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801f11:	52                   	push   %edx
  801f12:	68 2f 3b 80 00       	push   $0x803b2f
  801f17:	53                   	push   %ebx
  801f18:	56                   	push   %esi
  801f19:	e8 aa fe ff ff       	call   801dc8 <printfmt>
  801f1e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f21:	89 7d 14             	mov    %edi,0x14(%ebp)
  801f24:	e9 66 02 00 00       	jmp    80218f <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801f29:	50                   	push   %eax
  801f2a:	68 e3 40 80 00       	push   $0x8040e3
  801f2f:	53                   	push   %ebx
  801f30:	56                   	push   %esi
  801f31:	e8 92 fe ff ff       	call   801dc8 <printfmt>
  801f36:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f39:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801f3c:	e9 4e 02 00 00       	jmp    80218f <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801f41:	8b 45 14             	mov    0x14(%ebp),%eax
  801f44:	83 c0 04             	add    $0x4,%eax
  801f47:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801f4f:	85 d2                	test   %edx,%edx
  801f51:	b8 dc 40 80 00       	mov    $0x8040dc,%eax
  801f56:	0f 45 c2             	cmovne %edx,%eax
  801f59:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801f5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f60:	7e 06                	jle    801f68 <vprintfmt+0x17f>
  801f62:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801f66:	75 0d                	jne    801f75 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f68:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f6b:	89 c7                	mov    %eax,%edi
  801f6d:	03 45 e0             	add    -0x20(%ebp),%eax
  801f70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f73:	eb 55                	jmp    801fca <vprintfmt+0x1e1>
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	ff 75 d8             	pushl  -0x28(%ebp)
  801f7b:	ff 75 cc             	pushl  -0x34(%ebp)
  801f7e:	e8 46 03 00 00       	call   8022c9 <strnlen>
  801f83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f86:	29 c2                	sub    %eax,%edx
  801f88:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801f90:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801f94:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801f97:	85 ff                	test   %edi,%edi
  801f99:	7e 11                	jle    801fac <vprintfmt+0x1c3>
					putch(padc, putdat);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	53                   	push   %ebx
  801f9f:	ff 75 e0             	pushl  -0x20(%ebp)
  801fa2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801fa4:	83 ef 01             	sub    $0x1,%edi
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	eb eb                	jmp    801f97 <vprintfmt+0x1ae>
  801fac:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801faf:	85 d2                	test   %edx,%edx
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	0f 49 c2             	cmovns %edx,%eax
  801fb9:	29 c2                	sub    %eax,%edx
  801fbb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801fbe:	eb a8                	jmp    801f68 <vprintfmt+0x17f>
					putch(ch, putdat);
  801fc0:	83 ec 08             	sub    $0x8,%esp
  801fc3:	53                   	push   %ebx
  801fc4:	52                   	push   %edx
  801fc5:	ff d6                	call   *%esi
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fcd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fcf:	83 c7 01             	add    $0x1,%edi
  801fd2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801fd6:	0f be d0             	movsbl %al,%edx
  801fd9:	85 d2                	test   %edx,%edx
  801fdb:	74 4b                	je     802028 <vprintfmt+0x23f>
  801fdd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fe1:	78 06                	js     801fe9 <vprintfmt+0x200>
  801fe3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801fe7:	78 1e                	js     802007 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801fe9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801fed:	74 d1                	je     801fc0 <vprintfmt+0x1d7>
  801fef:	0f be c0             	movsbl %al,%eax
  801ff2:	83 e8 20             	sub    $0x20,%eax
  801ff5:	83 f8 5e             	cmp    $0x5e,%eax
  801ff8:	76 c6                	jbe    801fc0 <vprintfmt+0x1d7>
					putch('?', putdat);
  801ffa:	83 ec 08             	sub    $0x8,%esp
  801ffd:	53                   	push   %ebx
  801ffe:	6a 3f                	push   $0x3f
  802000:	ff d6                	call   *%esi
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	eb c3                	jmp    801fca <vprintfmt+0x1e1>
  802007:	89 cf                	mov    %ecx,%edi
  802009:	eb 0e                	jmp    802019 <vprintfmt+0x230>
				putch(' ', putdat);
  80200b:	83 ec 08             	sub    $0x8,%esp
  80200e:	53                   	push   %ebx
  80200f:	6a 20                	push   $0x20
  802011:	ff d6                	call   *%esi
			for (; width > 0; width--)
  802013:	83 ef 01             	sub    $0x1,%edi
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	85 ff                	test   %edi,%edi
  80201b:	7f ee                	jg     80200b <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80201d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802020:	89 45 14             	mov    %eax,0x14(%ebp)
  802023:	e9 67 01 00 00       	jmp    80218f <vprintfmt+0x3a6>
  802028:	89 cf                	mov    %ecx,%edi
  80202a:	eb ed                	jmp    802019 <vprintfmt+0x230>
	if (lflag >= 2)
  80202c:	83 f9 01             	cmp    $0x1,%ecx
  80202f:	7f 1b                	jg     80204c <vprintfmt+0x263>
	else if (lflag)
  802031:	85 c9                	test   %ecx,%ecx
  802033:	74 63                	je     802098 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  802035:	8b 45 14             	mov    0x14(%ebp),%eax
  802038:	8b 00                	mov    (%eax),%eax
  80203a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80203d:	99                   	cltd   
  80203e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802041:	8b 45 14             	mov    0x14(%ebp),%eax
  802044:	8d 40 04             	lea    0x4(%eax),%eax
  802047:	89 45 14             	mov    %eax,0x14(%ebp)
  80204a:	eb 17                	jmp    802063 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80204c:	8b 45 14             	mov    0x14(%ebp),%eax
  80204f:	8b 50 04             	mov    0x4(%eax),%edx
  802052:	8b 00                	mov    (%eax),%eax
  802054:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802057:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80205a:	8b 45 14             	mov    0x14(%ebp),%eax
  80205d:	8d 40 08             	lea    0x8(%eax),%eax
  802060:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  802063:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802066:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  802069:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80206e:	85 c9                	test   %ecx,%ecx
  802070:	0f 89 ff 00 00 00    	jns    802175 <vprintfmt+0x38c>
				putch('-', putdat);
  802076:	83 ec 08             	sub    $0x8,%esp
  802079:	53                   	push   %ebx
  80207a:	6a 2d                	push   $0x2d
  80207c:	ff d6                	call   *%esi
				num = -(long long) num;
  80207e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802081:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  802084:	f7 da                	neg    %edx
  802086:	83 d1 00             	adc    $0x0,%ecx
  802089:	f7 d9                	neg    %ecx
  80208b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80208e:	b8 0a 00 00 00       	mov    $0xa,%eax
  802093:	e9 dd 00 00 00       	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  802098:	8b 45 14             	mov    0x14(%ebp),%eax
  80209b:	8b 00                	mov    (%eax),%eax
  80209d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020a0:	99                   	cltd   
  8020a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8020a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a7:	8d 40 04             	lea    0x4(%eax),%eax
  8020aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8020ad:	eb b4                	jmp    802063 <vprintfmt+0x27a>
	if (lflag >= 2)
  8020af:	83 f9 01             	cmp    $0x1,%ecx
  8020b2:	7f 1e                	jg     8020d2 <vprintfmt+0x2e9>
	else if (lflag)
  8020b4:	85 c9                	test   %ecx,%ecx
  8020b6:	74 32                	je     8020ea <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8020b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020bb:	8b 10                	mov    (%eax),%edx
  8020bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020c2:	8d 40 04             	lea    0x4(%eax),%eax
  8020c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020c8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8020cd:	e9 a3 00 00 00       	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8020d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d5:	8b 10                	mov    (%eax),%edx
  8020d7:	8b 48 04             	mov    0x4(%eax),%ecx
  8020da:	8d 40 08             	lea    0x8(%eax),%eax
  8020dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020e0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8020e5:	e9 8b 00 00 00       	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8020ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ed:	8b 10                	mov    (%eax),%edx
  8020ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f4:	8d 40 04             	lea    0x4(%eax),%eax
  8020f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020fa:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8020ff:	eb 74                	jmp    802175 <vprintfmt+0x38c>
	if (lflag >= 2)
  802101:	83 f9 01             	cmp    $0x1,%ecx
  802104:	7f 1b                	jg     802121 <vprintfmt+0x338>
	else if (lflag)
  802106:	85 c9                	test   %ecx,%ecx
  802108:	74 2c                	je     802136 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80210a:	8b 45 14             	mov    0x14(%ebp),%eax
  80210d:	8b 10                	mov    (%eax),%edx
  80210f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802114:	8d 40 04             	lea    0x4(%eax),%eax
  802117:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80211a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80211f:	eb 54                	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  802121:	8b 45 14             	mov    0x14(%ebp),%eax
  802124:	8b 10                	mov    (%eax),%edx
  802126:	8b 48 04             	mov    0x4(%eax),%ecx
  802129:	8d 40 08             	lea    0x8(%eax),%eax
  80212c:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  80212f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  802134:	eb 3f                	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  802136:	8b 45 14             	mov    0x14(%ebp),%eax
  802139:	8b 10                	mov    (%eax),%edx
  80213b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802140:	8d 40 04             	lea    0x4(%eax),%eax
  802143:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
  802146:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80214b:	eb 28                	jmp    802175 <vprintfmt+0x38c>
			putch('0', putdat);
  80214d:	83 ec 08             	sub    $0x8,%esp
  802150:	53                   	push   %ebx
  802151:	6a 30                	push   $0x30
  802153:	ff d6                	call   *%esi
			putch('x', putdat);
  802155:	83 c4 08             	add    $0x8,%esp
  802158:	53                   	push   %ebx
  802159:	6a 78                	push   $0x78
  80215b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80215d:	8b 45 14             	mov    0x14(%ebp),%eax
  802160:	8b 10                	mov    (%eax),%edx
  802162:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  802167:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80216a:	8d 40 04             	lea    0x4(%eax),%eax
  80216d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802170:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80217c:	57                   	push   %edi
  80217d:	ff 75 e0             	pushl  -0x20(%ebp)
  802180:	50                   	push   %eax
  802181:	51                   	push   %ecx
  802182:	52                   	push   %edx
  802183:	89 da                	mov    %ebx,%edx
  802185:	89 f0                	mov    %esi,%eax
  802187:	e8 72 fb ff ff       	call   801cfe <printnum>
			break;
  80218c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80218f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802192:	83 c7 01             	add    $0x1,%edi
  802195:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802199:	83 f8 25             	cmp    $0x25,%eax
  80219c:	0f 84 62 fc ff ff    	je     801e04 <vprintfmt+0x1b>
			if (ch == '\0')
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 84 8b 00 00 00    	je     802235 <vprintfmt+0x44c>
			putch(ch, putdat);
  8021aa:	83 ec 08             	sub    $0x8,%esp
  8021ad:	53                   	push   %ebx
  8021ae:	50                   	push   %eax
  8021af:	ff d6                	call   *%esi
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	eb dc                	jmp    802192 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8021b6:	83 f9 01             	cmp    $0x1,%ecx
  8021b9:	7f 1b                	jg     8021d6 <vprintfmt+0x3ed>
	else if (lflag)
  8021bb:	85 c9                	test   %ecx,%ecx
  8021bd:	74 2c                	je     8021eb <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8021bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c2:	8b 10                	mov    (%eax),%edx
  8021c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021c9:	8d 40 04             	lea    0x4(%eax),%eax
  8021cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021cf:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8021d4:	eb 9f                	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8021d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d9:	8b 10                	mov    (%eax),%edx
  8021db:	8b 48 04             	mov    0x4(%eax),%ecx
  8021de:	8d 40 08             	lea    0x8(%eax),%eax
  8021e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021e4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8021e9:	eb 8a                	jmp    802175 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8021eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ee:	8b 10                	mov    (%eax),%edx
  8021f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021f5:	8d 40 04             	lea    0x4(%eax),%eax
  8021f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021fb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  802200:	e9 70 ff ff ff       	jmp    802175 <vprintfmt+0x38c>
			putch(ch, putdat);
  802205:	83 ec 08             	sub    $0x8,%esp
  802208:	53                   	push   %ebx
  802209:	6a 25                	push   $0x25
  80220b:	ff d6                	call   *%esi
			break;
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	e9 7a ff ff ff       	jmp    80218f <vprintfmt+0x3a6>
			putch('%', putdat);
  802215:	83 ec 08             	sub    $0x8,%esp
  802218:	53                   	push   %ebx
  802219:	6a 25                	push   $0x25
  80221b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	89 f8                	mov    %edi,%eax
  802222:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802226:	74 05                	je     80222d <vprintfmt+0x444>
  802228:	83 e8 01             	sub    $0x1,%eax
  80222b:	eb f5                	jmp    802222 <vprintfmt+0x439>
  80222d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802230:	e9 5a ff ff ff       	jmp    80218f <vprintfmt+0x3a6>
}
  802235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802238:	5b                   	pop    %ebx
  802239:	5e                   	pop    %esi
  80223a:	5f                   	pop    %edi
  80223b:	5d                   	pop    %ebp
  80223c:	c3                   	ret    

0080223d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80223d:	f3 0f 1e fb          	endbr32 
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 18             	sub    $0x18,%esp
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80224d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802250:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802254:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80225e:	85 c0                	test   %eax,%eax
  802260:	74 26                	je     802288 <vsnprintf+0x4b>
  802262:	85 d2                	test   %edx,%edx
  802264:	7e 22                	jle    802288 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802266:	ff 75 14             	pushl  0x14(%ebp)
  802269:	ff 75 10             	pushl  0x10(%ebp)
  80226c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80226f:	50                   	push   %eax
  802270:	68 a7 1d 80 00       	push   $0x801da7
  802275:	e8 6f fb ff ff       	call   801de9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80227a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	83 c4 10             	add    $0x10,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    
		return -E_INVAL;
  802288:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80228d:	eb f7                	jmp    802286 <vsnprintf+0x49>

0080228f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80228f:	f3 0f 1e fb          	endbr32 
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802299:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80229c:	50                   	push   %eax
  80229d:	ff 75 10             	pushl  0x10(%ebp)
  8022a0:	ff 75 0c             	pushl  0xc(%ebp)
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	e8 92 ff ff ff       	call   80223d <vsnprintf>
	va_end(ap);

	return rc;
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8022ad:	f3 0f 1e fb          	endbr32 
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8022c0:	74 05                	je     8022c7 <strlen+0x1a>
		n++;
  8022c2:	83 c0 01             	add    $0x1,%eax
  8022c5:	eb f5                	jmp    8022bc <strlen+0xf>
	return n;
}
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8022c9:	f3 0f 1e fb          	endbr32 
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022db:	39 d0                	cmp    %edx,%eax
  8022dd:	74 0d                	je     8022ec <strnlen+0x23>
  8022df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8022e3:	74 05                	je     8022ea <strnlen+0x21>
		n++;
  8022e5:	83 c0 01             	add    $0x1,%eax
  8022e8:	eb f1                	jmp    8022db <strnlen+0x12>
  8022ea:	89 c2                	mov    %eax,%edx
	return n;
}
  8022ec:	89 d0                	mov    %edx,%eax
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    

008022f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022f0:	f3 0f 1e fb          	endbr32 
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	53                   	push   %ebx
  8022f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  802307:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80230a:	83 c0 01             	add    $0x1,%eax
  80230d:	84 d2                	test   %dl,%dl
  80230f:	75 f2                	jne    802303 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  802311:	89 c8                	mov    %ecx,%eax
  802313:	5b                   	pop    %ebx
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    

00802316 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802316:	f3 0f 1e fb          	endbr32 
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	53                   	push   %ebx
  80231e:	83 ec 10             	sub    $0x10,%esp
  802321:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802324:	53                   	push   %ebx
  802325:	e8 83 ff ff ff       	call   8022ad <strlen>
  80232a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80232d:	ff 75 0c             	pushl  0xc(%ebp)
  802330:	01 d8                	add    %ebx,%eax
  802332:	50                   	push   %eax
  802333:	e8 b8 ff ff ff       	call   8022f0 <strcpy>
	return dst;
}
  802338:	89 d8                	mov    %ebx,%eax
  80233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80233f:	f3 0f 1e fb          	endbr32 
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	8b 75 08             	mov    0x8(%ebp),%esi
  80234b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234e:	89 f3                	mov    %esi,%ebx
  802350:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802353:	89 f0                	mov    %esi,%eax
  802355:	39 d8                	cmp    %ebx,%eax
  802357:	74 11                	je     80236a <strncpy+0x2b>
		*dst++ = *src;
  802359:	83 c0 01             	add    $0x1,%eax
  80235c:	0f b6 0a             	movzbl (%edx),%ecx
  80235f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802362:	80 f9 01             	cmp    $0x1,%cl
  802365:	83 da ff             	sbb    $0xffffffff,%edx
  802368:	eb eb                	jmp    802355 <strncpy+0x16>
	}
	return ret;
}
  80236a:	89 f0                	mov    %esi,%eax
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    

00802370 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802370:	f3 0f 1e fb          	endbr32 
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
  802379:	8b 75 08             	mov    0x8(%ebp),%esi
  80237c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80237f:	8b 55 10             	mov    0x10(%ebp),%edx
  802382:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802384:	85 d2                	test   %edx,%edx
  802386:	74 21                	je     8023a9 <strlcpy+0x39>
  802388:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80238c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80238e:	39 c2                	cmp    %eax,%edx
  802390:	74 14                	je     8023a6 <strlcpy+0x36>
  802392:	0f b6 19             	movzbl (%ecx),%ebx
  802395:	84 db                	test   %bl,%bl
  802397:	74 0b                	je     8023a4 <strlcpy+0x34>
			*dst++ = *src++;
  802399:	83 c1 01             	add    $0x1,%ecx
  80239c:	83 c2 01             	add    $0x1,%edx
  80239f:	88 5a ff             	mov    %bl,-0x1(%edx)
  8023a2:	eb ea                	jmp    80238e <strlcpy+0x1e>
  8023a4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8023a6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8023a9:	29 f0                	sub    %esi,%eax
}
  8023ab:	5b                   	pop    %ebx
  8023ac:	5e                   	pop    %esi
  8023ad:	5d                   	pop    %ebp
  8023ae:	c3                   	ret    

008023af <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023af:	f3 0f 1e fb          	endbr32 
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8023bc:	0f b6 01             	movzbl (%ecx),%eax
  8023bf:	84 c0                	test   %al,%al
  8023c1:	74 0c                	je     8023cf <strcmp+0x20>
  8023c3:	3a 02                	cmp    (%edx),%al
  8023c5:	75 08                	jne    8023cf <strcmp+0x20>
		p++, q++;
  8023c7:	83 c1 01             	add    $0x1,%ecx
  8023ca:	83 c2 01             	add    $0x1,%edx
  8023cd:	eb ed                	jmp    8023bc <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023cf:	0f b6 c0             	movzbl %al,%eax
  8023d2:	0f b6 12             	movzbl (%edx),%edx
  8023d5:	29 d0                	sub    %edx,%eax
}
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    

008023d9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8023d9:	f3 0f 1e fb          	endbr32 
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	53                   	push   %ebx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e7:	89 c3                	mov    %eax,%ebx
  8023e9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8023ec:	eb 06                	jmp    8023f4 <strncmp+0x1b>
		n--, p++, q++;
  8023ee:	83 c0 01             	add    $0x1,%eax
  8023f1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8023f4:	39 d8                	cmp    %ebx,%eax
  8023f6:	74 16                	je     80240e <strncmp+0x35>
  8023f8:	0f b6 08             	movzbl (%eax),%ecx
  8023fb:	84 c9                	test   %cl,%cl
  8023fd:	74 04                	je     802403 <strncmp+0x2a>
  8023ff:	3a 0a                	cmp    (%edx),%cl
  802401:	74 eb                	je     8023ee <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802403:	0f b6 00             	movzbl (%eax),%eax
  802406:	0f b6 12             	movzbl (%edx),%edx
  802409:	29 d0                	sub    %edx,%eax
}
  80240b:	5b                   	pop    %ebx
  80240c:	5d                   	pop    %ebp
  80240d:	c3                   	ret    
		return 0;
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
  802413:	eb f6                	jmp    80240b <strncmp+0x32>

00802415 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802415:	f3 0f 1e fb          	endbr32 
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802423:	0f b6 10             	movzbl (%eax),%edx
  802426:	84 d2                	test   %dl,%dl
  802428:	74 09                	je     802433 <strchr+0x1e>
		if (*s == c)
  80242a:	38 ca                	cmp    %cl,%dl
  80242c:	74 0a                	je     802438 <strchr+0x23>
	for (; *s; s++)
  80242e:	83 c0 01             	add    $0x1,%eax
  802431:	eb f0                	jmp    802423 <strchr+0xe>
			return (char *) s;
	return 0;
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    

0080243a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80243a:	f3 0f 1e fb          	endbr32 
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802448:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80244b:	38 ca                	cmp    %cl,%dl
  80244d:	74 09                	je     802458 <strfind+0x1e>
  80244f:	84 d2                	test   %dl,%dl
  802451:	74 05                	je     802458 <strfind+0x1e>
	for (; *s; s++)
  802453:	83 c0 01             	add    $0x1,%eax
  802456:	eb f0                	jmp    802448 <strfind+0xe>
			break;
	return (char *) s;
}
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80245a:	f3 0f 1e fb          	endbr32 
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	8b 7d 08             	mov    0x8(%ebp),%edi
  802467:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80246a:	85 c9                	test   %ecx,%ecx
  80246c:	74 31                	je     80249f <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80246e:	89 f8                	mov    %edi,%eax
  802470:	09 c8                	or     %ecx,%eax
  802472:	a8 03                	test   $0x3,%al
  802474:	75 23                	jne    802499 <memset+0x3f>
		c &= 0xFF;
  802476:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80247a:	89 d3                	mov    %edx,%ebx
  80247c:	c1 e3 08             	shl    $0x8,%ebx
  80247f:	89 d0                	mov    %edx,%eax
  802481:	c1 e0 18             	shl    $0x18,%eax
  802484:	89 d6                	mov    %edx,%esi
  802486:	c1 e6 10             	shl    $0x10,%esi
  802489:	09 f0                	or     %esi,%eax
  80248b:	09 c2                	or     %eax,%edx
  80248d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80248f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  802492:	89 d0                	mov    %edx,%eax
  802494:	fc                   	cld    
  802495:	f3 ab                	rep stos %eax,%es:(%edi)
  802497:	eb 06                	jmp    80249f <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249c:	fc                   	cld    
  80249d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80249f:	89 f8                	mov    %edi,%eax
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    

008024a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8024a6:	f3 0f 1e fb          	endbr32 
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	57                   	push   %edi
  8024ae:	56                   	push   %esi
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024b8:	39 c6                	cmp    %eax,%esi
  8024ba:	73 32                	jae    8024ee <memmove+0x48>
  8024bc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8024bf:	39 c2                	cmp    %eax,%edx
  8024c1:	76 2b                	jbe    8024ee <memmove+0x48>
		s += n;
		d += n;
  8024c3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024c6:	89 fe                	mov    %edi,%esi
  8024c8:	09 ce                	or     %ecx,%esi
  8024ca:	09 d6                	or     %edx,%esi
  8024cc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8024d2:	75 0e                	jne    8024e2 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8024d4:	83 ef 04             	sub    $0x4,%edi
  8024d7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8024da:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8024dd:	fd                   	std    
  8024de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024e0:	eb 09                	jmp    8024eb <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8024e2:	83 ef 01             	sub    $0x1,%edi
  8024e5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8024e8:	fd                   	std    
  8024e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8024eb:	fc                   	cld    
  8024ec:	eb 1a                	jmp    802508 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024ee:	89 c2                	mov    %eax,%edx
  8024f0:	09 ca                	or     %ecx,%edx
  8024f2:	09 f2                	or     %esi,%edx
  8024f4:	f6 c2 03             	test   $0x3,%dl
  8024f7:	75 0a                	jne    802503 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8024f9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8024fc:	89 c7                	mov    %eax,%edi
  8024fe:	fc                   	cld    
  8024ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802501:	eb 05                	jmp    802508 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  802503:	89 c7                	mov    %eax,%edi
  802505:	fc                   	cld    
  802506:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802508:	5e                   	pop    %esi
  802509:	5f                   	pop    %edi
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    

0080250c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80250c:	f3 0f 1e fb          	endbr32 
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802516:	ff 75 10             	pushl  0x10(%ebp)
  802519:	ff 75 0c             	pushl  0xc(%ebp)
  80251c:	ff 75 08             	pushl  0x8(%ebp)
  80251f:	e8 82 ff ff ff       	call   8024a6 <memmove>
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802526:	f3 0f 1e fb          	endbr32 
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	56                   	push   %esi
  80252e:	53                   	push   %ebx
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8b 55 0c             	mov    0xc(%ebp),%edx
  802535:	89 c6                	mov    %eax,%esi
  802537:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80253a:	39 f0                	cmp    %esi,%eax
  80253c:	74 1c                	je     80255a <memcmp+0x34>
		if (*s1 != *s2)
  80253e:	0f b6 08             	movzbl (%eax),%ecx
  802541:	0f b6 1a             	movzbl (%edx),%ebx
  802544:	38 d9                	cmp    %bl,%cl
  802546:	75 08                	jne    802550 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802548:	83 c0 01             	add    $0x1,%eax
  80254b:	83 c2 01             	add    $0x1,%edx
  80254e:	eb ea                	jmp    80253a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  802550:	0f b6 c1             	movzbl %cl,%eax
  802553:	0f b6 db             	movzbl %bl,%ebx
  802556:	29 d8                	sub    %ebx,%eax
  802558:	eb 05                	jmp    80255f <memcmp+0x39>
	}

	return 0;
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5d                   	pop    %ebp
  802562:	c3                   	ret    

00802563 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802563:	f3 0f 1e fb          	endbr32 
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802570:	89 c2                	mov    %eax,%edx
  802572:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802575:	39 d0                	cmp    %edx,%eax
  802577:	73 09                	jae    802582 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  802579:	38 08                	cmp    %cl,(%eax)
  80257b:	74 05                	je     802582 <memfind+0x1f>
	for (; s < ends; s++)
  80257d:	83 c0 01             	add    $0x1,%eax
  802580:	eb f3                	jmp    802575 <memfind+0x12>
			break;
	return (void *) s;
}
  802582:	5d                   	pop    %ebp
  802583:	c3                   	ret    

00802584 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802584:	f3 0f 1e fb          	endbr32 
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	57                   	push   %edi
  80258c:	56                   	push   %esi
  80258d:	53                   	push   %ebx
  80258e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802591:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802594:	eb 03                	jmp    802599 <strtol+0x15>
		s++;
  802596:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802599:	0f b6 01             	movzbl (%ecx),%eax
  80259c:	3c 20                	cmp    $0x20,%al
  80259e:	74 f6                	je     802596 <strtol+0x12>
  8025a0:	3c 09                	cmp    $0x9,%al
  8025a2:	74 f2                	je     802596 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  8025a4:	3c 2b                	cmp    $0x2b,%al
  8025a6:	74 2a                	je     8025d2 <strtol+0x4e>
	int neg = 0;
  8025a8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8025ad:	3c 2d                	cmp    $0x2d,%al
  8025af:	74 2b                	je     8025dc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025b1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8025b7:	75 0f                	jne    8025c8 <strtol+0x44>
  8025b9:	80 39 30             	cmpb   $0x30,(%ecx)
  8025bc:	74 28                	je     8025e6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8025be:	85 db                	test   %ebx,%ebx
  8025c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8025c5:	0f 44 d8             	cmove  %eax,%ebx
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8025d0:	eb 46                	jmp    802618 <strtol+0x94>
		s++;
  8025d2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8025d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025da:	eb d5                	jmp    8025b1 <strtol+0x2d>
		s++, neg = 1;
  8025dc:	83 c1 01             	add    $0x1,%ecx
  8025df:	bf 01 00 00 00       	mov    $0x1,%edi
  8025e4:	eb cb                	jmp    8025b1 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025e6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8025ea:	74 0e                	je     8025fa <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8025ec:	85 db                	test   %ebx,%ebx
  8025ee:	75 d8                	jne    8025c8 <strtol+0x44>
		s++, base = 8;
  8025f0:	83 c1 01             	add    $0x1,%ecx
  8025f3:	bb 08 00 00 00       	mov    $0x8,%ebx
  8025f8:	eb ce                	jmp    8025c8 <strtol+0x44>
		s += 2, base = 16;
  8025fa:	83 c1 02             	add    $0x2,%ecx
  8025fd:	bb 10 00 00 00       	mov    $0x10,%ebx
  802602:	eb c4                	jmp    8025c8 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  802604:	0f be d2             	movsbl %dl,%edx
  802607:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80260a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80260d:	7d 3a                	jge    802649 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80260f:	83 c1 01             	add    $0x1,%ecx
  802612:	0f af 45 10          	imul   0x10(%ebp),%eax
  802616:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802618:	0f b6 11             	movzbl (%ecx),%edx
  80261b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80261e:	89 f3                	mov    %esi,%ebx
  802620:	80 fb 09             	cmp    $0x9,%bl
  802623:	76 df                	jbe    802604 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802625:	8d 72 9f             	lea    -0x61(%edx),%esi
  802628:	89 f3                	mov    %esi,%ebx
  80262a:	80 fb 19             	cmp    $0x19,%bl
  80262d:	77 08                	ja     802637 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80262f:	0f be d2             	movsbl %dl,%edx
  802632:	83 ea 57             	sub    $0x57,%edx
  802635:	eb d3                	jmp    80260a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802637:	8d 72 bf             	lea    -0x41(%edx),%esi
  80263a:	89 f3                	mov    %esi,%ebx
  80263c:	80 fb 19             	cmp    $0x19,%bl
  80263f:	77 08                	ja     802649 <strtol+0xc5>
			dig = *s - 'A' + 10;
  802641:	0f be d2             	movsbl %dl,%edx
  802644:	83 ea 37             	sub    $0x37,%edx
  802647:	eb c1                	jmp    80260a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802649:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80264d:	74 05                	je     802654 <strtol+0xd0>
		*endptr = (char *) s;
  80264f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802652:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802654:	89 c2                	mov    %eax,%edx
  802656:	f7 da                	neg    %edx
  802658:	85 ff                	test   %edi,%edi
  80265a:	0f 45 c2             	cmovne %edx,%eax
}
  80265d:	5b                   	pop    %ebx
  80265e:	5e                   	pop    %esi
  80265f:	5f                   	pop    %edi
  802660:	5d                   	pop    %ebp
  802661:	c3                   	ret    

00802662 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802662:	f3 0f 1e fb          	endbr32 
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	57                   	push   %edi
  80266a:	56                   	push   %esi
  80266b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	8b 55 08             	mov    0x8(%ebp),%edx
  802674:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802677:	89 c3                	mov    %eax,%ebx
  802679:	89 c7                	mov    %eax,%edi
  80267b:	89 c6                	mov    %eax,%esi
  80267d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80267f:	5b                   	pop    %ebx
  802680:	5e                   	pop    %esi
  802681:	5f                   	pop    %edi
  802682:	5d                   	pop    %ebp
  802683:	c3                   	ret    

00802684 <sys_cgetc>:

int
sys_cgetc(void)
{
  802684:	f3 0f 1e fb          	endbr32 
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	57                   	push   %edi
  80268c:	56                   	push   %esi
  80268d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80268e:	ba 00 00 00 00       	mov    $0x0,%edx
  802693:	b8 01 00 00 00       	mov    $0x1,%eax
  802698:	89 d1                	mov    %edx,%ecx
  80269a:	89 d3                	mov    %edx,%ebx
  80269c:	89 d7                	mov    %edx,%edi
  80269e:	89 d6                	mov    %edx,%esi
  8026a0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8026a2:	5b                   	pop    %ebx
  8026a3:	5e                   	pop    %esi
  8026a4:	5f                   	pop    %edi
  8026a5:	5d                   	pop    %ebp
  8026a6:	c3                   	ret    

008026a7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8026a7:	f3 0f 1e fb          	endbr32 
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	57                   	push   %edi
  8026af:	56                   	push   %esi
  8026b0:	53                   	push   %ebx
  8026b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8026c1:	89 cb                	mov    %ecx,%ebx
  8026c3:	89 cf                	mov    %ecx,%edi
  8026c5:	89 ce                	mov    %ecx,%esi
  8026c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	7f 08                	jg     8026d5 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8026cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026d0:	5b                   	pop    %ebx
  8026d1:	5e                   	pop    %esi
  8026d2:	5f                   	pop    %edi
  8026d3:	5d                   	pop    %ebp
  8026d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026d5:	83 ec 0c             	sub    $0xc,%esp
  8026d8:	50                   	push   %eax
  8026d9:	6a 03                	push   $0x3
  8026db:	68 bf 43 80 00       	push   $0x8043bf
  8026e0:	6a 23                	push   $0x23
  8026e2:	68 dc 43 80 00       	push   $0x8043dc
  8026e7:	e8 13 f5 ff ff       	call   801bff <_panic>

008026ec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8026ec:	f3 0f 1e fb          	endbr32 
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	57                   	push   %edi
  8026f4:	56                   	push   %esi
  8026f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fb:	b8 02 00 00 00       	mov    $0x2,%eax
  802700:	89 d1                	mov    %edx,%ecx
  802702:	89 d3                	mov    %edx,%ebx
  802704:	89 d7                	mov    %edx,%edi
  802706:	89 d6                	mov    %edx,%esi
  802708:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    

0080270f <sys_yield>:

void
sys_yield(void)
{
  80270f:	f3 0f 1e fb          	endbr32 
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
  802716:	57                   	push   %edi
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
	asm volatile("int %1\n"
  802719:	ba 00 00 00 00       	mov    $0x0,%edx
  80271e:	b8 0b 00 00 00       	mov    $0xb,%eax
  802723:	89 d1                	mov    %edx,%ecx
  802725:	89 d3                	mov    %edx,%ebx
  802727:	89 d7                	mov    %edx,%edi
  802729:	89 d6                	mov    %edx,%esi
  80272b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80272d:	5b                   	pop    %ebx
  80272e:	5e                   	pop    %esi
  80272f:	5f                   	pop    %edi
  802730:	5d                   	pop    %ebp
  802731:	c3                   	ret    

00802732 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802732:	f3 0f 1e fb          	endbr32 
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	57                   	push   %edi
  80273a:	56                   	push   %esi
  80273b:	53                   	push   %ebx
  80273c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80273f:	be 00 00 00 00       	mov    $0x0,%esi
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80274a:	b8 04 00 00 00       	mov    $0x4,%eax
  80274f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802752:	89 f7                	mov    %esi,%edi
  802754:	cd 30                	int    $0x30
	if(check && ret > 0)
  802756:	85 c0                	test   %eax,%eax
  802758:	7f 08                	jg     802762 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80275a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5e                   	pop    %esi
  80275f:	5f                   	pop    %edi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802762:	83 ec 0c             	sub    $0xc,%esp
  802765:	50                   	push   %eax
  802766:	6a 04                	push   $0x4
  802768:	68 bf 43 80 00       	push   $0x8043bf
  80276d:	6a 23                	push   $0x23
  80276f:	68 dc 43 80 00       	push   $0x8043dc
  802774:	e8 86 f4 ff ff       	call   801bff <_panic>

00802779 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802779:	f3 0f 1e fb          	endbr32 
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	57                   	push   %edi
  802781:	56                   	push   %esi
  802782:	53                   	push   %ebx
  802783:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802786:	8b 55 08             	mov    0x8(%ebp),%edx
  802789:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80278c:	b8 05 00 00 00       	mov    $0x5,%eax
  802791:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802794:	8b 7d 14             	mov    0x14(%ebp),%edi
  802797:	8b 75 18             	mov    0x18(%ebp),%esi
  80279a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80279c:	85 c0                	test   %eax,%eax
  80279e:	7f 08                	jg     8027a8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8027a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a3:	5b                   	pop    %ebx
  8027a4:	5e                   	pop    %esi
  8027a5:	5f                   	pop    %edi
  8027a6:	5d                   	pop    %ebp
  8027a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	50                   	push   %eax
  8027ac:	6a 05                	push   $0x5
  8027ae:	68 bf 43 80 00       	push   $0x8043bf
  8027b3:	6a 23                	push   $0x23
  8027b5:	68 dc 43 80 00       	push   $0x8043dc
  8027ba:	e8 40 f4 ff ff       	call   801bff <_panic>

008027bf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8027bf:	f3 0f 1e fb          	endbr32 
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	57                   	push   %edi
  8027c7:	56                   	push   %esi
  8027c8:	53                   	push   %ebx
  8027c9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8027dc:	89 df                	mov    %ebx,%edi
  8027de:	89 de                	mov    %ebx,%esi
  8027e0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	7f 08                	jg     8027ee <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8027e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027e9:	5b                   	pop    %ebx
  8027ea:	5e                   	pop    %esi
  8027eb:	5f                   	pop    %edi
  8027ec:	5d                   	pop    %ebp
  8027ed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027ee:	83 ec 0c             	sub    $0xc,%esp
  8027f1:	50                   	push   %eax
  8027f2:	6a 06                	push   $0x6
  8027f4:	68 bf 43 80 00       	push   $0x8043bf
  8027f9:	6a 23                	push   $0x23
  8027fb:	68 dc 43 80 00       	push   $0x8043dc
  802800:	e8 fa f3 ff ff       	call   801bff <_panic>

00802805 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802805:	f3 0f 1e fb          	endbr32 
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	57                   	push   %edi
  80280d:	56                   	push   %esi
  80280e:	53                   	push   %ebx
  80280f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802812:	bb 00 00 00 00       	mov    $0x0,%ebx
  802817:	8b 55 08             	mov    0x8(%ebp),%edx
  80281a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80281d:	b8 08 00 00 00       	mov    $0x8,%eax
  802822:	89 df                	mov    %ebx,%edi
  802824:	89 de                	mov    %ebx,%esi
  802826:	cd 30                	int    $0x30
	if(check && ret > 0)
  802828:	85 c0                	test   %eax,%eax
  80282a:	7f 08                	jg     802834 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80282c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80282f:	5b                   	pop    %ebx
  802830:	5e                   	pop    %esi
  802831:	5f                   	pop    %edi
  802832:	5d                   	pop    %ebp
  802833:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802834:	83 ec 0c             	sub    $0xc,%esp
  802837:	50                   	push   %eax
  802838:	6a 08                	push   $0x8
  80283a:	68 bf 43 80 00       	push   $0x8043bf
  80283f:	6a 23                	push   $0x23
  802841:	68 dc 43 80 00       	push   $0x8043dc
  802846:	e8 b4 f3 ff ff       	call   801bff <_panic>

0080284b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80284b:	f3 0f 1e fb          	endbr32 
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
  802852:	57                   	push   %edi
  802853:	56                   	push   %esi
  802854:	53                   	push   %ebx
  802855:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80285d:	8b 55 08             	mov    0x8(%ebp),%edx
  802860:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802863:	b8 09 00 00 00       	mov    $0x9,%eax
  802868:	89 df                	mov    %ebx,%edi
  80286a:	89 de                	mov    %ebx,%esi
  80286c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80286e:	85 c0                	test   %eax,%eax
  802870:	7f 08                	jg     80287a <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802872:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802875:	5b                   	pop    %ebx
  802876:	5e                   	pop    %esi
  802877:	5f                   	pop    %edi
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	50                   	push   %eax
  80287e:	6a 09                	push   $0x9
  802880:	68 bf 43 80 00       	push   $0x8043bf
  802885:	6a 23                	push   $0x23
  802887:	68 dc 43 80 00       	push   $0x8043dc
  80288c:	e8 6e f3 ff ff       	call   801bff <_panic>

00802891 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802891:	f3 0f 1e fb          	endbr32 
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	57                   	push   %edi
  802899:	56                   	push   %esi
  80289a:	53                   	push   %ebx
  80289b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80289e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8028ae:	89 df                	mov    %ebx,%edi
  8028b0:	89 de                	mov    %ebx,%esi
  8028b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	7f 08                	jg     8028c0 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8028b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028bb:	5b                   	pop    %ebx
  8028bc:	5e                   	pop    %esi
  8028bd:	5f                   	pop    %edi
  8028be:	5d                   	pop    %ebp
  8028bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028c0:	83 ec 0c             	sub    $0xc,%esp
  8028c3:	50                   	push   %eax
  8028c4:	6a 0a                	push   $0xa
  8028c6:	68 bf 43 80 00       	push   $0x8043bf
  8028cb:	6a 23                	push   $0x23
  8028cd:	68 dc 43 80 00       	push   $0x8043dc
  8028d2:	e8 28 f3 ff ff       	call   801bff <_panic>

008028d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8028d7:	f3 0f 1e fb          	endbr32 
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
  8028de:	57                   	push   %edi
  8028df:	56                   	push   %esi
  8028e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8028ec:	be 00 00 00 00       	mov    $0x0,%esi
  8028f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8028f7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8028f9:	5b                   	pop    %ebx
  8028fa:	5e                   	pop    %esi
  8028fb:	5f                   	pop    %edi
  8028fc:	5d                   	pop    %ebp
  8028fd:	c3                   	ret    

008028fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8028fe:	f3 0f 1e fb          	endbr32 
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	57                   	push   %edi
  802906:	56                   	push   %esi
  802907:	53                   	push   %ebx
  802908:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80290b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802910:	8b 55 08             	mov    0x8(%ebp),%edx
  802913:	b8 0d 00 00 00       	mov    $0xd,%eax
  802918:	89 cb                	mov    %ecx,%ebx
  80291a:	89 cf                	mov    %ecx,%edi
  80291c:	89 ce                	mov    %ecx,%esi
  80291e:	cd 30                	int    $0x30
	if(check && ret > 0)
  802920:	85 c0                	test   %eax,%eax
  802922:	7f 08                	jg     80292c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802924:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802927:	5b                   	pop    %ebx
  802928:	5e                   	pop    %esi
  802929:	5f                   	pop    %edi
  80292a:	5d                   	pop    %ebp
  80292b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80292c:	83 ec 0c             	sub    $0xc,%esp
  80292f:	50                   	push   %eax
  802930:	6a 0d                	push   $0xd
  802932:	68 bf 43 80 00       	push   $0x8043bf
  802937:	6a 23                	push   $0x23
  802939:	68 dc 43 80 00       	push   $0x8043dc
  80293e:	e8 bc f2 ff ff       	call   801bff <_panic>

00802943 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802943:	f3 0f 1e fb          	endbr32 
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
  80294a:	53                   	push   %ebx
  80294b:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  80294e:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  802955:	74 0d                	je     802964 <set_pgfault_handler+0x21>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  80295f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802962:	c9                   	leave  
  802963:	c3                   	ret    
		envid_t envid=sys_getenvid();
  802964:	e8 83 fd ff ff       	call   8026ec <sys_getenvid>
  802969:	89 c3                	mov    %eax,%ebx
		if(sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_W|PTE_P)<0)
  80296b:	83 ec 04             	sub    $0x4,%esp
  80296e:	6a 07                	push   $0x7
  802970:	68 00 f0 bf ee       	push   $0xeebff000
  802975:	50                   	push   %eax
  802976:	e8 b7 fd ff ff       	call   802732 <sys_page_alloc>
  80297b:	83 c4 10             	add    $0x10,%esp
  80297e:	85 c0                	test   %eax,%eax
  802980:	78 29                	js     8029ab <set_pgfault_handler+0x68>
		if(sys_env_set_pgfault_upcall(envid,_pgfault_upcall)<0)
  802982:	83 ec 08             	sub    $0x8,%esp
  802985:	68 bf 29 80 00       	push   $0x8029bf
  80298a:	53                   	push   %ebx
  80298b:	e8 01 ff ff ff       	call   802891 <sys_env_set_pgfault_upcall>
  802990:	83 c4 10             	add    $0x10,%esp
  802993:	85 c0                	test   %eax,%eax
  802995:	79 c0                	jns    802957 <set_pgfault_handler+0x14>
			panic("set_pgfault_handler:sys_env_set_pgfault_upcall Failed!");
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 18 44 80 00       	push   $0x804418
  80299f:	6a 24                	push   $0x24
  8029a1:	68 4f 44 80 00       	push   $0x80444f
  8029a6:	e8 54 f2 ff ff       	call   801bff <_panic>
			panic("set_pgfault_handler:sys_page_alloc Failed!");
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 ec 43 80 00       	push   $0x8043ec
  8029b3:	6a 22                	push   $0x22
  8029b5:	68 4f 44 80 00       	push   $0x80444f
  8029ba:	e8 40 f2 ff ff       	call   801bff <_panic>

008029bf <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029bf:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029c0:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  8029c5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029c7:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	addl $8,%esp
  8029ca:	83 c4 08             	add    $0x8,%esp
	movl 0x20(%esp),%eax
  8029cd:	8b 44 24 20          	mov    0x20(%esp),%eax
	subl $4,0x28(%esp)
  8029d1:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
	movl 0x28(%esp),%ebx
  8029d6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %eax,(%ebx)
  8029da:	89 03                	mov    %eax,(%ebx)
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8029dc:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8029dd:	83 c4 04             	add    $0x4,%esp
	popfl
  8029e0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029e1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8029e2:	c3                   	ret    

008029e3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029e3:	f3 0f 1e fb          	endbr32 
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	56                   	push   %esi
  8029eb:	53                   	push   %ebx
  8029ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8029ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029fc:	0f 44 c2             	cmove  %edx,%eax
	int res;
	if((res=sys_ipc_recv(pg))<0){
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	50                   	push   %eax
  802a03:	e8 f6 fe ff ff       	call   8028fe <sys_ipc_recv>
  802a08:	83 c4 10             	add    $0x10,%esp
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	78 2b                	js     802a3a <ipc_recv+0x57>
			*from_env_store=0;
		if(perm_store)
			*perm_store=0;
		return res;
	}
	if(from_env_store)
  802a0f:	85 f6                	test   %esi,%esi
  802a11:	74 0a                	je     802a1d <ipc_recv+0x3a>
		*from_env_store=thisenv->env_ipc_from;
  802a13:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a18:	8b 40 74             	mov    0x74(%eax),%eax
  802a1b:	89 06                	mov    %eax,(%esi)
	if(perm_store)
  802a1d:	85 db                	test   %ebx,%ebx
  802a1f:	74 0a                	je     802a2b <ipc_recv+0x48>
		*perm_store=thisenv->env_ipc_perm;
  802a21:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a26:	8b 40 78             	mov    0x78(%eax),%eax
  802a29:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802a2b:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a30:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a36:	5b                   	pop    %ebx
  802a37:	5e                   	pop    %esi
  802a38:	5d                   	pop    %ebp
  802a39:	c3                   	ret    
		if(from_env_store)
  802a3a:	85 f6                	test   %esi,%esi
  802a3c:	74 06                	je     802a44 <ipc_recv+0x61>
			*from_env_store=0;
  802a3e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a44:	85 db                	test   %ebx,%ebx
  802a46:	74 eb                	je     802a33 <ipc_recv+0x50>
			*perm_store=0;
  802a48:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a4e:	eb e3                	jmp    802a33 <ipc_recv+0x50>

00802a50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a50:	f3 0f 1e fb          	endbr32 
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	57                   	push   %edi
  802a58:	56                   	push   %esi
  802a59:	53                   	push   %ebx
  802a5a:	83 ec 0c             	sub    $0xc,%esp
  802a5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a60:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if(!pg)
		pg=(void *)UTOP;
  802a66:	85 db                	test   %ebx,%ebx
  802a68:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a6d:	0f 44 d8             	cmove  %eax,%ebx
	int res;
	while(1){
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802a70:	ff 75 14             	pushl  0x14(%ebp)
  802a73:	53                   	push   %ebx
  802a74:	56                   	push   %esi
  802a75:	57                   	push   %edi
  802a76:	e8 5c fe ff ff       	call   8028d7 <sys_ipc_try_send>
		if(!res)
  802a7b:	83 c4 10             	add    $0x10,%esp
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	74 20                	je     802aa2 <ipc_send+0x52>
			return;
		if(res!=-E_IPC_NOT_RECV)
  802a82:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a85:	75 07                	jne    802a8e <ipc_send+0x3e>
			panic("ipc_send:Not Receiving!");
		sys_yield();
  802a87:	e8 83 fc ff ff       	call   80270f <sys_yield>
		res=sys_ipc_try_send(to_env,val,pg,perm);
  802a8c:	eb e2                	jmp    802a70 <ipc_send+0x20>
			panic("ipc_send:Not Receiving!");
  802a8e:	83 ec 04             	sub    $0x4,%esp
  802a91:	68 5d 44 80 00       	push   $0x80445d
  802a96:	6a 3f                	push   $0x3f
  802a98:	68 75 44 80 00       	push   $0x804475
  802a9d:	e8 5d f1 ff ff       	call   801bff <_panic>
	}
}
  802aa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802aa5:	5b                   	pop    %ebx
  802aa6:	5e                   	pop    %esi
  802aa7:	5f                   	pop    %edi
  802aa8:	5d                   	pop    %ebp
  802aa9:	c3                   	ret    

00802aaa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aaa:	f3 0f 1e fb          	endbr32 
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
  802ab1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ab4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802ab9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802abc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ac2:	8b 52 50             	mov    0x50(%edx),%edx
  802ac5:	39 ca                	cmp    %ecx,%edx
  802ac7:	74 11                	je     802ada <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802ac9:	83 c0 01             	add    $0x1,%eax
  802acc:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ad1:	75 e6                	jne    802ab9 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	eb 0b                	jmp    802ae5 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802ada:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802add:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ae2:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ae5:	5d                   	pop    %ebp
  802ae6:	c3                   	ret    

00802ae7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802ae7:	f3 0f 1e fb          	endbr32 
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	05 00 00 00 30       	add    $0x30000000,%eax
  802af6:	c1 e8 0c             	shr    $0xc,%eax
}
  802af9:	5d                   	pop    %ebp
  802afa:	c3                   	ret    

00802afb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802afb:	f3 0f 1e fb          	endbr32 
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802b0f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    

00802b16 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b16:	f3 0f 1e fb          	endbr32 
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
  802b1d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b22:	89 c2                	mov    %eax,%edx
  802b24:	c1 ea 16             	shr    $0x16,%edx
  802b27:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b2e:	f6 c2 01             	test   $0x1,%dl
  802b31:	74 2d                	je     802b60 <fd_alloc+0x4a>
  802b33:	89 c2                	mov    %eax,%edx
  802b35:	c1 ea 0c             	shr    $0xc,%edx
  802b38:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802b3f:	f6 c2 01             	test   $0x1,%dl
  802b42:	74 1c                	je     802b60 <fd_alloc+0x4a>
  802b44:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802b49:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802b4e:	75 d2                	jne    802b22 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802b59:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802b5e:	eb 0a                	jmp    802b6a <fd_alloc+0x54>
			*fd_store = fd;
  802b60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b63:	89 01                	mov    %eax,(%ecx)
			return 0;
  802b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6a:	5d                   	pop    %ebp
  802b6b:	c3                   	ret    

00802b6c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b6c:	f3 0f 1e fb          	endbr32 
  802b70:	55                   	push   %ebp
  802b71:	89 e5                	mov    %esp,%ebp
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b76:	83 f8 1f             	cmp    $0x1f,%eax
  802b79:	77 30                	ja     802bab <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802b7b:	c1 e0 0c             	shl    $0xc,%eax
  802b7e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b83:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802b89:	f6 c2 01             	test   $0x1,%dl
  802b8c:	74 24                	je     802bb2 <fd_lookup+0x46>
  802b8e:	89 c2                	mov    %eax,%edx
  802b90:	c1 ea 0c             	shr    $0xc,%edx
  802b93:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802b9a:	f6 c2 01             	test   $0x1,%dl
  802b9d:	74 1a                	je     802bb9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba2:	89 02                	mov    %eax,(%edx)
	return 0;
  802ba4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba9:	5d                   	pop    %ebp
  802baa:	c3                   	ret    
		return -E_INVAL;
  802bab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb0:	eb f7                	jmp    802ba9 <fd_lookup+0x3d>
		return -E_INVAL;
  802bb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb7:	eb f0                	jmp    802ba9 <fd_lookup+0x3d>
  802bb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bbe:	eb e9                	jmp    802ba9 <fd_lookup+0x3d>

00802bc0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802bc0:	f3 0f 1e fb          	endbr32 
  802bc4:	55                   	push   %ebp
  802bc5:	89 e5                	mov    %esp,%ebp
  802bc7:	83 ec 08             	sub    $0x8,%esp
  802bca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bcd:	ba fc 44 80 00       	mov    $0x8044fc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802bd2:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802bd7:	39 08                	cmp    %ecx,(%eax)
  802bd9:	74 33                	je     802c0e <dev_lookup+0x4e>
  802bdb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802bde:	8b 02                	mov    (%edx),%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	75 f3                	jne    802bd7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802be4:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802be9:	8b 40 48             	mov    0x48(%eax),%eax
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	51                   	push   %ecx
  802bf0:	50                   	push   %eax
  802bf1:	68 80 44 80 00       	push   $0x804480
  802bf6:	e8 eb f0 ff ff       	call   801ce6 <cprintf>
	*dev = 0;
  802bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802c04:	83 c4 10             	add    $0x10,%esp
  802c07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c0c:	c9                   	leave  
  802c0d:	c3                   	ret    
			*dev = devtab[i];
  802c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c11:	89 01                	mov    %eax,(%ecx)
			return 0;
  802c13:	b8 00 00 00 00       	mov    $0x0,%eax
  802c18:	eb f2                	jmp    802c0c <dev_lookup+0x4c>

00802c1a <fd_close>:
{
  802c1a:	f3 0f 1e fb          	endbr32 
  802c1e:	55                   	push   %ebp
  802c1f:	89 e5                	mov    %esp,%ebp
  802c21:	57                   	push   %edi
  802c22:	56                   	push   %esi
  802c23:	53                   	push   %ebx
  802c24:	83 ec 24             	sub    $0x24,%esp
  802c27:	8b 75 08             	mov    0x8(%ebp),%esi
  802c2a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802c30:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c31:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802c37:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c3a:	50                   	push   %eax
  802c3b:	e8 2c ff ff ff       	call   802b6c <fd_lookup>
  802c40:	89 c3                	mov    %eax,%ebx
  802c42:	83 c4 10             	add    $0x10,%esp
  802c45:	85 c0                	test   %eax,%eax
  802c47:	78 05                	js     802c4e <fd_close+0x34>
	    || fd != fd2)
  802c49:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802c4c:	74 16                	je     802c64 <fd_close+0x4a>
		return (must_exist ? r : 0);
  802c4e:	89 f8                	mov    %edi,%eax
  802c50:	84 c0                	test   %al,%al
  802c52:	b8 00 00 00 00       	mov    $0x0,%eax
  802c57:	0f 44 d8             	cmove  %eax,%ebx
}
  802c5a:	89 d8                	mov    %ebx,%eax
  802c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c5f:	5b                   	pop    %ebx
  802c60:	5e                   	pop    %esi
  802c61:	5f                   	pop    %edi
  802c62:	5d                   	pop    %ebp
  802c63:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c64:	83 ec 08             	sub    $0x8,%esp
  802c67:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802c6a:	50                   	push   %eax
  802c6b:	ff 36                	pushl  (%esi)
  802c6d:	e8 4e ff ff ff       	call   802bc0 <dev_lookup>
  802c72:	89 c3                	mov    %eax,%ebx
  802c74:	83 c4 10             	add    $0x10,%esp
  802c77:	85 c0                	test   %eax,%eax
  802c79:	78 1a                	js     802c95 <fd_close+0x7b>
		if (dev->dev_close)
  802c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802c81:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802c86:	85 c0                	test   %eax,%eax
  802c88:	74 0b                	je     802c95 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  802c8a:	83 ec 0c             	sub    $0xc,%esp
  802c8d:	56                   	push   %esi
  802c8e:	ff d0                	call   *%eax
  802c90:	89 c3                	mov    %eax,%ebx
  802c92:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802c95:	83 ec 08             	sub    $0x8,%esp
  802c98:	56                   	push   %esi
  802c99:	6a 00                	push   $0x0
  802c9b:	e8 1f fb ff ff       	call   8027bf <sys_page_unmap>
	return r;
  802ca0:	83 c4 10             	add    $0x10,%esp
  802ca3:	eb b5                	jmp    802c5a <fd_close+0x40>

00802ca5 <close>:

int
close(int fdnum)
{
  802ca5:	f3 0f 1e fb          	endbr32 
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802caf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cb2:	50                   	push   %eax
  802cb3:	ff 75 08             	pushl  0x8(%ebp)
  802cb6:	e8 b1 fe ff ff       	call   802b6c <fd_lookup>
  802cbb:	83 c4 10             	add    $0x10,%esp
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	79 02                	jns    802cc4 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  802cc2:	c9                   	leave  
  802cc3:	c3                   	ret    
		return fd_close(fd, 1);
  802cc4:	83 ec 08             	sub    $0x8,%esp
  802cc7:	6a 01                	push   $0x1
  802cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  802ccc:	e8 49 ff ff ff       	call   802c1a <fd_close>
  802cd1:	83 c4 10             	add    $0x10,%esp
  802cd4:	eb ec                	jmp    802cc2 <close+0x1d>

00802cd6 <close_all>:

void
close_all(void)
{
  802cd6:	f3 0f 1e fb          	endbr32 
  802cda:	55                   	push   %ebp
  802cdb:	89 e5                	mov    %esp,%ebp
  802cdd:	53                   	push   %ebx
  802cde:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ce1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802ce6:	83 ec 0c             	sub    $0xc,%esp
  802ce9:	53                   	push   %ebx
  802cea:	e8 b6 ff ff ff       	call   802ca5 <close>
	for (i = 0; i < MAXFD; i++)
  802cef:	83 c3 01             	add    $0x1,%ebx
  802cf2:	83 c4 10             	add    $0x10,%esp
  802cf5:	83 fb 20             	cmp    $0x20,%ebx
  802cf8:	75 ec                	jne    802ce6 <close_all+0x10>
}
  802cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cfd:	c9                   	leave  
  802cfe:	c3                   	ret    

00802cff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cff:	f3 0f 1e fb          	endbr32 
  802d03:	55                   	push   %ebp
  802d04:	89 e5                	mov    %esp,%ebp
  802d06:	57                   	push   %edi
  802d07:	56                   	push   %esi
  802d08:	53                   	push   %ebx
  802d09:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d0c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802d0f:	50                   	push   %eax
  802d10:	ff 75 08             	pushl  0x8(%ebp)
  802d13:	e8 54 fe ff ff       	call   802b6c <fd_lookup>
  802d18:	89 c3                	mov    %eax,%ebx
  802d1a:	83 c4 10             	add    $0x10,%esp
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	0f 88 81 00 00 00    	js     802da6 <dup+0xa7>
		return r;
	close(newfdnum);
  802d25:	83 ec 0c             	sub    $0xc,%esp
  802d28:	ff 75 0c             	pushl  0xc(%ebp)
  802d2b:	e8 75 ff ff ff       	call   802ca5 <close>

	newfd = INDEX2FD(newfdnum);
  802d30:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d33:	c1 e6 0c             	shl    $0xc,%esi
  802d36:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802d3c:	83 c4 04             	add    $0x4,%esp
  802d3f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d42:	e8 b4 fd ff ff       	call   802afb <fd2data>
  802d47:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802d49:	89 34 24             	mov    %esi,(%esp)
  802d4c:	e8 aa fd ff ff       	call   802afb <fd2data>
  802d51:	83 c4 10             	add    $0x10,%esp
  802d54:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d56:	89 d8                	mov    %ebx,%eax
  802d58:	c1 e8 16             	shr    $0x16,%eax
  802d5b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802d62:	a8 01                	test   $0x1,%al
  802d64:	74 11                	je     802d77 <dup+0x78>
  802d66:	89 d8                	mov    %ebx,%eax
  802d68:	c1 e8 0c             	shr    $0xc,%eax
  802d6b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802d72:	f6 c2 01             	test   $0x1,%dl
  802d75:	75 39                	jne    802db0 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d7a:	89 d0                	mov    %edx,%eax
  802d7c:	c1 e8 0c             	shr    $0xc,%eax
  802d7f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	25 07 0e 00 00       	and    $0xe07,%eax
  802d8e:	50                   	push   %eax
  802d8f:	56                   	push   %esi
  802d90:	6a 00                	push   $0x0
  802d92:	52                   	push   %edx
  802d93:	6a 00                	push   $0x0
  802d95:	e8 df f9 ff ff       	call   802779 <sys_page_map>
  802d9a:	89 c3                	mov    %eax,%ebx
  802d9c:	83 c4 20             	add    $0x20,%esp
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	78 31                	js     802dd4 <dup+0xd5>
		goto err;

	return newfdnum;
  802da3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802da6:	89 d8                	mov    %ebx,%eax
  802da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dab:	5b                   	pop    %ebx
  802dac:	5e                   	pop    %esi
  802dad:	5f                   	pop    %edi
  802dae:	5d                   	pop    %ebp
  802daf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802db0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802db7:	83 ec 0c             	sub    $0xc,%esp
  802dba:	25 07 0e 00 00       	and    $0xe07,%eax
  802dbf:	50                   	push   %eax
  802dc0:	57                   	push   %edi
  802dc1:	6a 00                	push   $0x0
  802dc3:	53                   	push   %ebx
  802dc4:	6a 00                	push   $0x0
  802dc6:	e8 ae f9 ff ff       	call   802779 <sys_page_map>
  802dcb:	89 c3                	mov    %eax,%ebx
  802dcd:	83 c4 20             	add    $0x20,%esp
  802dd0:	85 c0                	test   %eax,%eax
  802dd2:	79 a3                	jns    802d77 <dup+0x78>
	sys_page_unmap(0, newfd);
  802dd4:	83 ec 08             	sub    $0x8,%esp
  802dd7:	56                   	push   %esi
  802dd8:	6a 00                	push   $0x0
  802dda:	e8 e0 f9 ff ff       	call   8027bf <sys_page_unmap>
	sys_page_unmap(0, nva);
  802ddf:	83 c4 08             	add    $0x8,%esp
  802de2:	57                   	push   %edi
  802de3:	6a 00                	push   $0x0
  802de5:	e8 d5 f9 ff ff       	call   8027bf <sys_page_unmap>
	return r;
  802dea:	83 c4 10             	add    $0x10,%esp
  802ded:	eb b7                	jmp    802da6 <dup+0xa7>

00802def <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802def:	f3 0f 1e fb          	endbr32 
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
  802df6:	53                   	push   %ebx
  802df7:	83 ec 1c             	sub    $0x1c,%esp
  802dfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dfd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e00:	50                   	push   %eax
  802e01:	53                   	push   %ebx
  802e02:	e8 65 fd ff ff       	call   802b6c <fd_lookup>
  802e07:	83 c4 10             	add    $0x10,%esp
  802e0a:	85 c0                	test   %eax,%eax
  802e0c:	78 3f                	js     802e4d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e0e:	83 ec 08             	sub    $0x8,%esp
  802e11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e14:	50                   	push   %eax
  802e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e18:	ff 30                	pushl  (%eax)
  802e1a:	e8 a1 fd ff ff       	call   802bc0 <dev_lookup>
  802e1f:	83 c4 10             	add    $0x10,%esp
  802e22:	85 c0                	test   %eax,%eax
  802e24:	78 27                	js     802e4d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e29:	8b 42 08             	mov    0x8(%edx),%eax
  802e2c:	83 e0 03             	and    $0x3,%eax
  802e2f:	83 f8 01             	cmp    $0x1,%eax
  802e32:	74 1e                	je     802e52 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 40 08             	mov    0x8(%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 35                	je     802e73 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	ff 75 10             	pushl  0x10(%ebp)
  802e44:	ff 75 0c             	pushl  0xc(%ebp)
  802e47:	52                   	push   %edx
  802e48:	ff d0                	call   *%eax
  802e4a:	83 c4 10             	add    $0x10,%esp
}
  802e4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e52:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802e57:	8b 40 48             	mov    0x48(%eax),%eax
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	53                   	push   %ebx
  802e5e:	50                   	push   %eax
  802e5f:	68 c1 44 80 00       	push   $0x8044c1
  802e64:	e8 7d ee ff ff       	call   801ce6 <cprintf>
		return -E_INVAL;
  802e69:	83 c4 10             	add    $0x10,%esp
  802e6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e71:	eb da                	jmp    802e4d <read+0x5e>
		return -E_NOT_SUPP;
  802e73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e78:	eb d3                	jmp    802e4d <read+0x5e>

00802e7a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e7a:	f3 0f 1e fb          	endbr32 
  802e7e:	55                   	push   %ebp
  802e7f:	89 e5                	mov    %esp,%ebp
  802e81:	57                   	push   %edi
  802e82:	56                   	push   %esi
  802e83:	53                   	push   %ebx
  802e84:	83 ec 0c             	sub    $0xc,%esp
  802e87:	8b 7d 08             	mov    0x8(%ebp),%edi
  802e8a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e92:	eb 02                	jmp    802e96 <readn+0x1c>
  802e94:	01 c3                	add    %eax,%ebx
  802e96:	39 f3                	cmp    %esi,%ebx
  802e98:	73 21                	jae    802ebb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	89 f0                	mov    %esi,%eax
  802e9f:	29 d8                	sub    %ebx,%eax
  802ea1:	50                   	push   %eax
  802ea2:	89 d8                	mov    %ebx,%eax
  802ea4:	03 45 0c             	add    0xc(%ebp),%eax
  802ea7:	50                   	push   %eax
  802ea8:	57                   	push   %edi
  802ea9:	e8 41 ff ff ff       	call   802def <read>
		if (m < 0)
  802eae:	83 c4 10             	add    $0x10,%esp
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	78 04                	js     802eb9 <readn+0x3f>
			return m;
		if (m == 0)
  802eb5:	75 dd                	jne    802e94 <readn+0x1a>
  802eb7:	eb 02                	jmp    802ebb <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802eb9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802ebb:	89 d8                	mov    %ebx,%eax
  802ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ec0:	5b                   	pop    %ebx
  802ec1:	5e                   	pop    %esi
  802ec2:	5f                   	pop    %edi
  802ec3:	5d                   	pop    %ebp
  802ec4:	c3                   	ret    

00802ec5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ec5:	f3 0f 1e fb          	endbr32 
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
  802ecc:	53                   	push   %ebx
  802ecd:	83 ec 1c             	sub    $0x1c,%esp
  802ed0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ed3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ed6:	50                   	push   %eax
  802ed7:	53                   	push   %ebx
  802ed8:	e8 8f fc ff ff       	call   802b6c <fd_lookup>
  802edd:	83 c4 10             	add    $0x10,%esp
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	78 3a                	js     802f1e <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ee4:	83 ec 08             	sub    $0x8,%esp
  802ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eea:	50                   	push   %eax
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	ff 30                	pushl  (%eax)
  802ef0:	e8 cb fc ff ff       	call   802bc0 <dev_lookup>
  802ef5:	83 c4 10             	add    $0x10,%esp
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	78 22                	js     802f1e <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eff:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802f03:	74 1e                	je     802f23 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f08:	8b 52 0c             	mov    0xc(%edx),%edx
  802f0b:	85 d2                	test   %edx,%edx
  802f0d:	74 35                	je     802f44 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802f0f:	83 ec 04             	sub    $0x4,%esp
  802f12:	ff 75 10             	pushl  0x10(%ebp)
  802f15:	ff 75 0c             	pushl  0xc(%ebp)
  802f18:	50                   	push   %eax
  802f19:	ff d2                	call   *%edx
  802f1b:	83 c4 10             	add    $0x10,%esp
}
  802f1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f21:	c9                   	leave  
  802f22:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f23:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802f28:	8b 40 48             	mov    0x48(%eax),%eax
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	53                   	push   %ebx
  802f2f:	50                   	push   %eax
  802f30:	68 dd 44 80 00       	push   $0x8044dd
  802f35:	e8 ac ed ff ff       	call   801ce6 <cprintf>
		return -E_INVAL;
  802f3a:	83 c4 10             	add    $0x10,%esp
  802f3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f42:	eb da                	jmp    802f1e <write+0x59>
		return -E_NOT_SUPP;
  802f44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f49:	eb d3                	jmp    802f1e <write+0x59>

00802f4b <seek>:

int
seek(int fdnum, off_t offset)
{
  802f4b:	f3 0f 1e fb          	endbr32 
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f58:	50                   	push   %eax
  802f59:	ff 75 08             	pushl  0x8(%ebp)
  802f5c:	e8 0b fc ff ff       	call   802b6c <fd_lookup>
  802f61:	83 c4 10             	add    $0x10,%esp
  802f64:	85 c0                	test   %eax,%eax
  802f66:	78 0e                	js     802f76 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  802f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f76:	c9                   	leave  
  802f77:	c3                   	ret    

00802f78 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f78:	f3 0f 1e fb          	endbr32 
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	53                   	push   %ebx
  802f80:	83 ec 1c             	sub    $0x1c,%esp
  802f83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f89:	50                   	push   %eax
  802f8a:	53                   	push   %ebx
  802f8b:	e8 dc fb ff ff       	call   802b6c <fd_lookup>
  802f90:	83 c4 10             	add    $0x10,%esp
  802f93:	85 c0                	test   %eax,%eax
  802f95:	78 37                	js     802fce <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f97:	83 ec 08             	sub    $0x8,%esp
  802f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f9d:	50                   	push   %eax
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	ff 30                	pushl  (%eax)
  802fa3:	e8 18 fc ff ff       	call   802bc0 <dev_lookup>
  802fa8:	83 c4 10             	add    $0x10,%esp
  802fab:	85 c0                	test   %eax,%eax
  802fad:	78 1f                	js     802fce <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802fb6:	74 1b                	je     802fd3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbb:	8b 52 18             	mov    0x18(%edx),%edx
  802fbe:	85 d2                	test   %edx,%edx
  802fc0:	74 32                	je     802ff4 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802fc2:	83 ec 08             	sub    $0x8,%esp
  802fc5:	ff 75 0c             	pushl  0xc(%ebp)
  802fc8:	50                   	push   %eax
  802fc9:	ff d2                	call   *%edx
  802fcb:	83 c4 10             	add    $0x10,%esp
}
  802fce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fd1:	c9                   	leave  
  802fd2:	c3                   	ret    
			thisenv->env_id, fdnum);
  802fd3:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fd8:	8b 40 48             	mov    0x48(%eax),%eax
  802fdb:	83 ec 04             	sub    $0x4,%esp
  802fde:	53                   	push   %ebx
  802fdf:	50                   	push   %eax
  802fe0:	68 a0 44 80 00       	push   $0x8044a0
  802fe5:	e8 fc ec ff ff       	call   801ce6 <cprintf>
		return -E_INVAL;
  802fea:	83 c4 10             	add    $0x10,%esp
  802fed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ff2:	eb da                	jmp    802fce <ftruncate+0x56>
		return -E_NOT_SUPP;
  802ff4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ff9:	eb d3                	jmp    802fce <ftruncate+0x56>

00802ffb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ffb:	f3 0f 1e fb          	endbr32 
  802fff:	55                   	push   %ebp
  803000:	89 e5                	mov    %esp,%ebp
  803002:	53                   	push   %ebx
  803003:	83 ec 1c             	sub    $0x1c,%esp
  803006:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803009:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80300c:	50                   	push   %eax
  80300d:	ff 75 08             	pushl  0x8(%ebp)
  803010:	e8 57 fb ff ff       	call   802b6c <fd_lookup>
  803015:	83 c4 10             	add    $0x10,%esp
  803018:	85 c0                	test   %eax,%eax
  80301a:	78 4b                	js     803067 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80301c:	83 ec 08             	sub    $0x8,%esp
  80301f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803022:	50                   	push   %eax
  803023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803026:	ff 30                	pushl  (%eax)
  803028:	e8 93 fb ff ff       	call   802bc0 <dev_lookup>
  80302d:	83 c4 10             	add    $0x10,%esp
  803030:	85 c0                	test   %eax,%eax
  803032:	78 33                	js     803067 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80303b:	74 2f                	je     80306c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80303d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  803040:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803047:	00 00 00 
	stat->st_isdir = 0;
  80304a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803051:	00 00 00 
	stat->st_dev = dev;
  803054:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80305a:	83 ec 08             	sub    $0x8,%esp
  80305d:	53                   	push   %ebx
  80305e:	ff 75 f0             	pushl  -0x10(%ebp)
  803061:	ff 50 14             	call   *0x14(%eax)
  803064:	83 c4 10             	add    $0x10,%esp
}
  803067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    
		return -E_NOT_SUPP;
  80306c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803071:	eb f4                	jmp    803067 <fstat+0x6c>

00803073 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803073:	f3 0f 1e fb          	endbr32 
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	56                   	push   %esi
  80307b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80307c:	83 ec 08             	sub    $0x8,%esp
  80307f:	6a 00                	push   $0x0
  803081:	ff 75 08             	pushl  0x8(%ebp)
  803084:	e8 fb 01 00 00       	call   803284 <open>
  803089:	89 c3                	mov    %eax,%ebx
  80308b:	83 c4 10             	add    $0x10,%esp
  80308e:	85 c0                	test   %eax,%eax
  803090:	78 1b                	js     8030ad <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  803092:	83 ec 08             	sub    $0x8,%esp
  803095:	ff 75 0c             	pushl  0xc(%ebp)
  803098:	50                   	push   %eax
  803099:	e8 5d ff ff ff       	call   802ffb <fstat>
  80309e:	89 c6                	mov    %eax,%esi
	close(fd);
  8030a0:	89 1c 24             	mov    %ebx,(%esp)
  8030a3:	e8 fd fb ff ff       	call   802ca5 <close>
	return r;
  8030a8:	83 c4 10             	add    $0x10,%esp
  8030ab:	89 f3                	mov    %esi,%ebx
}
  8030ad:	89 d8                	mov    %ebx,%eax
  8030af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030b2:	5b                   	pop    %ebx
  8030b3:	5e                   	pop    %esi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    

008030b6 <fsipc>:
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.

static int
fsipc(unsigned type, void *dstva)
{
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	56                   	push   %esi
  8030ba:	53                   	push   %ebx
  8030bb:	89 c6                	mov    %eax,%esi
  8030bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8030bf:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  8030c6:	74 27                	je     8030ef <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030c8:	6a 07                	push   $0x7
  8030ca:	68 00 b0 80 00       	push   $0x80b000
  8030cf:	56                   	push   %esi
  8030d0:	ff 35 00 a0 80 00    	pushl  0x80a000
  8030d6:	e8 75 f9 ff ff       	call   802a50 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8030db:	83 c4 0c             	add    $0xc,%esp
  8030de:	6a 00                	push   $0x0
  8030e0:	53                   	push   %ebx
  8030e1:	6a 00                	push   $0x0
  8030e3:	e8 fb f8 ff ff       	call   8029e3 <ipc_recv>
}
  8030e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030eb:	5b                   	pop    %ebx
  8030ec:	5e                   	pop    %esi
  8030ed:	5d                   	pop    %ebp
  8030ee:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8030ef:	83 ec 0c             	sub    $0xc,%esp
  8030f2:	6a 01                	push   $0x1
  8030f4:	e8 b1 f9 ff ff       	call   802aaa <ipc_find_env>
  8030f9:	a3 00 a0 80 00       	mov    %eax,0x80a000
  8030fe:	83 c4 10             	add    $0x10,%esp
  803101:	eb c5                	jmp    8030c8 <fsipc+0x12>

00803103 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803103:	f3 0f 1e fb          	endbr32 
  803107:	55                   	push   %ebp
  803108:	89 e5                	mov    %esp,%ebp
  80310a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  803118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311b:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803120:	ba 00 00 00 00       	mov    $0x0,%edx
  803125:	b8 02 00 00 00       	mov    $0x2,%eax
  80312a:	e8 87 ff ff ff       	call   8030b6 <fsipc>
}
  80312f:	c9                   	leave  
  803130:	c3                   	ret    

00803131 <devfile_flush>:
{
  803131:	f3 0f 1e fb          	endbr32 
  803135:	55                   	push   %ebp
  803136:	89 e5                	mov    %esp,%ebp
  803138:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 40 0c             	mov    0xc(%eax),%eax
  803141:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803146:	ba 00 00 00 00       	mov    $0x0,%edx
  80314b:	b8 06 00 00 00       	mov    $0x6,%eax
  803150:	e8 61 ff ff ff       	call   8030b6 <fsipc>
}
  803155:	c9                   	leave  
  803156:	c3                   	ret    

00803157 <devfile_stat>:
{
  803157:	f3 0f 1e fb          	endbr32 
  80315b:	55                   	push   %ebp
  80315c:	89 e5                	mov    %esp,%ebp
  80315e:	53                   	push   %ebx
  80315f:	83 ec 04             	sub    $0x4,%esp
  803162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 40 0c             	mov    0xc(%eax),%eax
  80316b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803170:	ba 00 00 00 00       	mov    $0x0,%edx
  803175:	b8 05 00 00 00       	mov    $0x5,%eax
  80317a:	e8 37 ff ff ff       	call   8030b6 <fsipc>
  80317f:	85 c0                	test   %eax,%eax
  803181:	78 2c                	js     8031af <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803183:	83 ec 08             	sub    $0x8,%esp
  803186:	68 00 b0 80 00       	push   $0x80b000
  80318b:	53                   	push   %ebx
  80318c:	e8 5f f1 ff ff       	call   8022f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  803191:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803196:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80319c:	a1 84 b0 80 00       	mov    0x80b084,%eax
  8031a1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8031a7:	83 c4 10             	add    $0x10,%esp
  8031aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <devfile_write>:
{
  8031b4:	f3 0f 1e fb          	endbr32 
  8031b8:	55                   	push   %ebp
  8031b9:	89 e5                	mov    %esp,%ebp
  8031bb:	83 ec 0c             	sub    $0xc,%esp
  8031be:	8b 45 10             	mov    0x10(%ebp),%eax
  8031c1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8031c6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8031cb:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d1:	8b 52 0c             	mov    0xc(%edx),%edx
  8031d4:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	fsipcbuf.write.req_n = n;
  8031da:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf,buf,n);
  8031df:	50                   	push   %eax
  8031e0:	ff 75 0c             	pushl  0xc(%ebp)
  8031e3:	68 08 b0 80 00       	push   $0x80b008
  8031e8:	e8 b9 f2 ff ff       	call   8024a6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8031ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8031f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8031f7:	e8 ba fe ff ff       	call   8030b6 <fsipc>
}
  8031fc:	c9                   	leave  
  8031fd:	c3                   	ret    

008031fe <devfile_read>:
{
  8031fe:	f3 0f 1e fb          	endbr32 
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	56                   	push   %esi
  803206:	53                   	push   %ebx
  803207:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	8b 40 0c             	mov    0xc(%eax),%eax
  803210:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803215:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80321b:	ba 00 00 00 00       	mov    $0x0,%edx
  803220:	b8 03 00 00 00       	mov    $0x3,%eax
  803225:	e8 8c fe ff ff       	call   8030b6 <fsipc>
  80322a:	89 c3                	mov    %eax,%ebx
  80322c:	85 c0                	test   %eax,%eax
  80322e:	78 1f                	js     80324f <devfile_read+0x51>
	assert(r <= n);
  803230:	39 f0                	cmp    %esi,%eax
  803232:	77 24                	ja     803258 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  803234:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803239:	7f 33                	jg     80326e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	50                   	push   %eax
  80323f:	68 00 b0 80 00       	push   $0x80b000
  803244:	ff 75 0c             	pushl  0xc(%ebp)
  803247:	e8 5a f2 ff ff       	call   8024a6 <memmove>
	return r;
  80324c:	83 c4 10             	add    $0x10,%esp
}
  80324f:	89 d8                	mov    %ebx,%eax
  803251:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803254:	5b                   	pop    %ebx
  803255:	5e                   	pop    %esi
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
	assert(r <= n);
  803258:	68 0c 45 80 00       	push   $0x80450c
  80325d:	68 1d 3b 80 00       	push   $0x803b1d
  803262:	6a 7d                	push   $0x7d
  803264:	68 13 45 80 00       	push   $0x804513
  803269:	e8 91 e9 ff ff       	call   801bff <_panic>
	assert(r <= PGSIZE);
  80326e:	68 1e 45 80 00       	push   $0x80451e
  803273:	68 1d 3b 80 00       	push   $0x803b1d
  803278:	6a 7e                	push   $0x7e
  80327a:	68 13 45 80 00       	push   $0x804513
  80327f:	e8 7b e9 ff ff       	call   801bff <_panic>

00803284 <open>:
{
  803284:	f3 0f 1e fb          	endbr32 
  803288:	55                   	push   %ebp
  803289:	89 e5                	mov    %esp,%ebp
  80328b:	56                   	push   %esi
  80328c:	53                   	push   %ebx
  80328d:	83 ec 1c             	sub    $0x1c,%esp
  803290:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803293:	56                   	push   %esi
  803294:	e8 14 f0 ff ff       	call   8022ad <strlen>
  803299:	83 c4 10             	add    $0x10,%esp
  80329c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032a1:	7f 6c                	jg     80330f <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8032a3:	83 ec 0c             	sub    $0xc,%esp
  8032a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032a9:	50                   	push   %eax
  8032aa:	e8 67 f8 ff ff       	call   802b16 <fd_alloc>
  8032af:	89 c3                	mov    %eax,%ebx
  8032b1:	83 c4 10             	add    $0x10,%esp
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	78 3c                	js     8032f4 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8032b8:	83 ec 08             	sub    $0x8,%esp
  8032bb:	56                   	push   %esi
  8032bc:	68 00 b0 80 00       	push   $0x80b000
  8032c1:	e8 2a f0 ff ff       	call   8022f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8032c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c9:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8032ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d6:	e8 db fd ff ff       	call   8030b6 <fsipc>
  8032db:	89 c3                	mov    %eax,%ebx
  8032dd:	83 c4 10             	add    $0x10,%esp
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	78 19                	js     8032fd <open+0x79>
	return fd2num(fd);
  8032e4:	83 ec 0c             	sub    $0xc,%esp
  8032e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ea:	e8 f8 f7 ff ff       	call   802ae7 <fd2num>
  8032ef:	89 c3                	mov    %eax,%ebx
  8032f1:	83 c4 10             	add    $0x10,%esp
}
  8032f4:	89 d8                	mov    %ebx,%eax
  8032f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032f9:	5b                   	pop    %ebx
  8032fa:	5e                   	pop    %esi
  8032fb:	5d                   	pop    %ebp
  8032fc:	c3                   	ret    
		fd_close(fd, 0);
  8032fd:	83 ec 08             	sub    $0x8,%esp
  803300:	6a 00                	push   $0x0
  803302:	ff 75 f4             	pushl  -0xc(%ebp)
  803305:	e8 10 f9 ff ff       	call   802c1a <fd_close>
		return r;
  80330a:	83 c4 10             	add    $0x10,%esp
  80330d:	eb e5                	jmp    8032f4 <open+0x70>
		return -E_BAD_PATH;
  80330f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803314:	eb de                	jmp    8032f4 <open+0x70>

00803316 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803316:	f3 0f 1e fb          	endbr32 
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
  80331d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803320:	ba 00 00 00 00       	mov    $0x0,%edx
  803325:	b8 08 00 00 00       	mov    $0x8,%eax
  80332a:	e8 87 fd ff ff       	call   8030b6 <fsipc>
}
  80332f:	c9                   	leave  
  803330:	c3                   	ret    

00803331 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803331:	f3 0f 1e fb          	endbr32 
  803335:	55                   	push   %ebp
  803336:	89 e5                	mov    %esp,%ebp
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80333b:	89 c2                	mov    %eax,%edx
  80333d:	c1 ea 16             	shr    $0x16,%edx
  803340:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  803347:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80334c:	f6 c1 01             	test   $0x1,%cl
  80334f:	74 1c                	je     80336d <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  803351:	c1 e8 0c             	shr    $0xc,%eax
  803354:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80335b:	a8 01                	test   $0x1,%al
  80335d:	74 0e                	je     80336d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80335f:	c1 e8 0c             	shr    $0xc,%eax
  803362:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803369:	ef 
  80336a:	0f b7 d2             	movzwl %dx,%edx
}
  80336d:	89 d0                	mov    %edx,%eax
  80336f:	5d                   	pop    %ebp
  803370:	c3                   	ret    

00803371 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803371:	f3 0f 1e fb          	endbr32 
  803375:	55                   	push   %ebp
  803376:	89 e5                	mov    %esp,%ebp
  803378:	56                   	push   %esi
  803379:	53                   	push   %ebx
  80337a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80337d:	83 ec 0c             	sub    $0xc,%esp
  803380:	ff 75 08             	pushl  0x8(%ebp)
  803383:	e8 73 f7 ff ff       	call   802afb <fd2data>
  803388:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80338a:	83 c4 08             	add    $0x8,%esp
  80338d:	68 2a 45 80 00       	push   $0x80452a
  803392:	53                   	push   %ebx
  803393:	e8 58 ef ff ff       	call   8022f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803398:	8b 46 04             	mov    0x4(%esi),%eax
  80339b:	2b 06                	sub    (%esi),%eax
  80339d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8033a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8033aa:	00 00 00 
	stat->st_dev = &devpipe;
  8033ad:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  8033b4:	90 80 00 
	return 0;
}
  8033b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033bf:	5b                   	pop    %ebx
  8033c0:	5e                   	pop    %esi
  8033c1:	5d                   	pop    %ebp
  8033c2:	c3                   	ret    

008033c3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8033c3:	f3 0f 1e fb          	endbr32 
  8033c7:	55                   	push   %ebp
  8033c8:	89 e5                	mov    %esp,%ebp
  8033ca:	53                   	push   %ebx
  8033cb:	83 ec 0c             	sub    $0xc,%esp
  8033ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8033d1:	53                   	push   %ebx
  8033d2:	6a 00                	push   $0x0
  8033d4:	e8 e6 f3 ff ff       	call   8027bf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8033d9:	89 1c 24             	mov    %ebx,(%esp)
  8033dc:	e8 1a f7 ff ff       	call   802afb <fd2data>
  8033e1:	83 c4 08             	add    $0x8,%esp
  8033e4:	50                   	push   %eax
  8033e5:	6a 00                	push   $0x0
  8033e7:	e8 d3 f3 ff ff       	call   8027bf <sys_page_unmap>
}
  8033ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033ef:	c9                   	leave  
  8033f0:	c3                   	ret    

008033f1 <_pipeisclosed>:
{
  8033f1:	55                   	push   %ebp
  8033f2:	89 e5                	mov    %esp,%ebp
  8033f4:	57                   	push   %edi
  8033f5:	56                   	push   %esi
  8033f6:	53                   	push   %ebx
  8033f7:	83 ec 1c             	sub    $0x1c,%esp
  8033fa:	89 c7                	mov    %eax,%edi
  8033fc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8033fe:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  803403:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803406:	83 ec 0c             	sub    $0xc,%esp
  803409:	57                   	push   %edi
  80340a:	e8 22 ff ff ff       	call   803331 <pageref>
  80340f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803412:	89 34 24             	mov    %esi,(%esp)
  803415:	e8 17 ff ff ff       	call   803331 <pageref>
		nn = thisenv->env_runs;
  80341a:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  803420:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803423:	83 c4 10             	add    $0x10,%esp
  803426:	39 cb                	cmp    %ecx,%ebx
  803428:	74 1b                	je     803445 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80342a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80342d:	75 cf                	jne    8033fe <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80342f:	8b 42 58             	mov    0x58(%edx),%eax
  803432:	6a 01                	push   $0x1
  803434:	50                   	push   %eax
  803435:	53                   	push   %ebx
  803436:	68 31 45 80 00       	push   $0x804531
  80343b:	e8 a6 e8 ff ff       	call   801ce6 <cprintf>
  803440:	83 c4 10             	add    $0x10,%esp
  803443:	eb b9                	jmp    8033fe <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803445:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803448:	0f 94 c0             	sete   %al
  80344b:	0f b6 c0             	movzbl %al,%eax
}
  80344e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803451:	5b                   	pop    %ebx
  803452:	5e                   	pop    %esi
  803453:	5f                   	pop    %edi
  803454:	5d                   	pop    %ebp
  803455:	c3                   	ret    

00803456 <devpipe_write>:
{
  803456:	f3 0f 1e fb          	endbr32 
  80345a:	55                   	push   %ebp
  80345b:	89 e5                	mov    %esp,%ebp
  80345d:	57                   	push   %edi
  80345e:	56                   	push   %esi
  80345f:	53                   	push   %ebx
  803460:	83 ec 28             	sub    $0x28,%esp
  803463:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803466:	56                   	push   %esi
  803467:	e8 8f f6 ff ff       	call   802afb <fd2data>
  80346c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80346e:	83 c4 10             	add    $0x10,%esp
  803471:	bf 00 00 00 00       	mov    $0x0,%edi
  803476:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803479:	74 4f                	je     8034ca <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80347b:	8b 43 04             	mov    0x4(%ebx),%eax
  80347e:	8b 0b                	mov    (%ebx),%ecx
  803480:	8d 51 20             	lea    0x20(%ecx),%edx
  803483:	39 d0                	cmp    %edx,%eax
  803485:	72 14                	jb     80349b <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  803487:	89 da                	mov    %ebx,%edx
  803489:	89 f0                	mov    %esi,%eax
  80348b:	e8 61 ff ff ff       	call   8033f1 <_pipeisclosed>
  803490:	85 c0                	test   %eax,%eax
  803492:	75 3b                	jne    8034cf <devpipe_write+0x79>
			sys_yield();
  803494:	e8 76 f2 ff ff       	call   80270f <sys_yield>
  803499:	eb e0                	jmp    80347b <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80349b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80349e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8034a2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8034a5:	89 c2                	mov    %eax,%edx
  8034a7:	c1 fa 1f             	sar    $0x1f,%edx
  8034aa:	89 d1                	mov    %edx,%ecx
  8034ac:	c1 e9 1b             	shr    $0x1b,%ecx
  8034af:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8034b2:	83 e2 1f             	and    $0x1f,%edx
  8034b5:	29 ca                	sub    %ecx,%edx
  8034b7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8034bb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8034bf:	83 c0 01             	add    $0x1,%eax
  8034c2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8034c5:	83 c7 01             	add    $0x1,%edi
  8034c8:	eb ac                	jmp    803476 <devpipe_write+0x20>
	return i;
  8034ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cd:	eb 05                	jmp    8034d4 <devpipe_write+0x7e>
				return 0;
  8034cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034d7:	5b                   	pop    %ebx
  8034d8:	5e                   	pop    %esi
  8034d9:	5f                   	pop    %edi
  8034da:	5d                   	pop    %ebp
  8034db:	c3                   	ret    

008034dc <devpipe_read>:
{
  8034dc:	f3 0f 1e fb          	endbr32 
  8034e0:	55                   	push   %ebp
  8034e1:	89 e5                	mov    %esp,%ebp
  8034e3:	57                   	push   %edi
  8034e4:	56                   	push   %esi
  8034e5:	53                   	push   %ebx
  8034e6:	83 ec 18             	sub    $0x18,%esp
  8034e9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8034ec:	57                   	push   %edi
  8034ed:	e8 09 f6 ff ff       	call   802afb <fd2data>
  8034f2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8034f4:	83 c4 10             	add    $0x10,%esp
  8034f7:	be 00 00 00 00       	mov    $0x0,%esi
  8034fc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8034ff:	75 14                	jne    803515 <devpipe_read+0x39>
	return i;
  803501:	8b 45 10             	mov    0x10(%ebp),%eax
  803504:	eb 02                	jmp    803508 <devpipe_read+0x2c>
				return i;
  803506:	89 f0                	mov    %esi,%eax
}
  803508:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80350b:	5b                   	pop    %ebx
  80350c:	5e                   	pop    %esi
  80350d:	5f                   	pop    %edi
  80350e:	5d                   	pop    %ebp
  80350f:	c3                   	ret    
			sys_yield();
  803510:	e8 fa f1 ff ff       	call   80270f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803515:	8b 03                	mov    (%ebx),%eax
  803517:	3b 43 04             	cmp    0x4(%ebx),%eax
  80351a:	75 18                	jne    803534 <devpipe_read+0x58>
			if (i > 0)
  80351c:	85 f6                	test   %esi,%esi
  80351e:	75 e6                	jne    803506 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  803520:	89 da                	mov    %ebx,%edx
  803522:	89 f8                	mov    %edi,%eax
  803524:	e8 c8 fe ff ff       	call   8033f1 <_pipeisclosed>
  803529:	85 c0                	test   %eax,%eax
  80352b:	74 e3                	je     803510 <devpipe_read+0x34>
				return 0;
  80352d:	b8 00 00 00 00       	mov    $0x0,%eax
  803532:	eb d4                	jmp    803508 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803534:	99                   	cltd   
  803535:	c1 ea 1b             	shr    $0x1b,%edx
  803538:	01 d0                	add    %edx,%eax
  80353a:	83 e0 1f             	and    $0x1f,%eax
  80353d:	29 d0                	sub    %edx,%eax
  80353f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803544:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803547:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80354a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80354d:	83 c6 01             	add    $0x1,%esi
  803550:	eb aa                	jmp    8034fc <devpipe_read+0x20>

00803552 <pipe>:
{
  803552:	f3 0f 1e fb          	endbr32 
  803556:	55                   	push   %ebp
  803557:	89 e5                	mov    %esp,%ebp
  803559:	56                   	push   %esi
  80355a:	53                   	push   %ebx
  80355b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80355e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803561:	50                   	push   %eax
  803562:	e8 af f5 ff ff       	call   802b16 <fd_alloc>
  803567:	89 c3                	mov    %eax,%ebx
  803569:	83 c4 10             	add    $0x10,%esp
  80356c:	85 c0                	test   %eax,%eax
  80356e:	0f 88 23 01 00 00    	js     803697 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803574:	83 ec 04             	sub    $0x4,%esp
  803577:	68 07 04 00 00       	push   $0x407
  80357c:	ff 75 f4             	pushl  -0xc(%ebp)
  80357f:	6a 00                	push   $0x0
  803581:	e8 ac f1 ff ff       	call   802732 <sys_page_alloc>
  803586:	89 c3                	mov    %eax,%ebx
  803588:	83 c4 10             	add    $0x10,%esp
  80358b:	85 c0                	test   %eax,%eax
  80358d:	0f 88 04 01 00 00    	js     803697 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  803593:	83 ec 0c             	sub    $0xc,%esp
  803596:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803599:	50                   	push   %eax
  80359a:	e8 77 f5 ff ff       	call   802b16 <fd_alloc>
  80359f:	89 c3                	mov    %eax,%ebx
  8035a1:	83 c4 10             	add    $0x10,%esp
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	0f 88 db 00 00 00    	js     803687 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ac:	83 ec 04             	sub    $0x4,%esp
  8035af:	68 07 04 00 00       	push   $0x407
  8035b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8035b7:	6a 00                	push   $0x0
  8035b9:	e8 74 f1 ff ff       	call   802732 <sys_page_alloc>
  8035be:	89 c3                	mov    %eax,%ebx
  8035c0:	83 c4 10             	add    $0x10,%esp
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	0f 88 bc 00 00 00    	js     803687 <pipe+0x135>
	va = fd2data(fd0);
  8035cb:	83 ec 0c             	sub    $0xc,%esp
  8035ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8035d1:	e8 25 f5 ff ff       	call   802afb <fd2data>
  8035d6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d8:	83 c4 0c             	add    $0xc,%esp
  8035db:	68 07 04 00 00       	push   $0x407
  8035e0:	50                   	push   %eax
  8035e1:	6a 00                	push   $0x0
  8035e3:	e8 4a f1 ff ff       	call   802732 <sys_page_alloc>
  8035e8:	89 c3                	mov    %eax,%ebx
  8035ea:	83 c4 10             	add    $0x10,%esp
  8035ed:	85 c0                	test   %eax,%eax
  8035ef:	0f 88 82 00 00 00    	js     803677 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035f5:	83 ec 0c             	sub    $0xc,%esp
  8035f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8035fb:	e8 fb f4 ff ff       	call   802afb <fd2data>
  803600:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803607:	50                   	push   %eax
  803608:	6a 00                	push   $0x0
  80360a:	56                   	push   %esi
  80360b:	6a 00                	push   $0x0
  80360d:	e8 67 f1 ff ff       	call   802779 <sys_page_map>
  803612:	89 c3                	mov    %eax,%ebx
  803614:	83 c4 20             	add    $0x20,%esp
  803617:	85 c0                	test   %eax,%eax
  803619:	78 4e                	js     803669 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80361b:	a1 80 90 80 00       	mov    0x809080,%eax
  803620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803623:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803628:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80362f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803632:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803637:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80363e:	83 ec 0c             	sub    $0xc,%esp
  803641:	ff 75 f4             	pushl  -0xc(%ebp)
  803644:	e8 9e f4 ff ff       	call   802ae7 <fd2num>
  803649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80364c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80364e:	83 c4 04             	add    $0x4,%esp
  803651:	ff 75 f0             	pushl  -0x10(%ebp)
  803654:	e8 8e f4 ff ff       	call   802ae7 <fd2num>
  803659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80365c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80365f:	83 c4 10             	add    $0x10,%esp
  803662:	bb 00 00 00 00       	mov    $0x0,%ebx
  803667:	eb 2e                	jmp    803697 <pipe+0x145>
	sys_page_unmap(0, va);
  803669:	83 ec 08             	sub    $0x8,%esp
  80366c:	56                   	push   %esi
  80366d:	6a 00                	push   $0x0
  80366f:	e8 4b f1 ff ff       	call   8027bf <sys_page_unmap>
  803674:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803677:	83 ec 08             	sub    $0x8,%esp
  80367a:	ff 75 f0             	pushl  -0x10(%ebp)
  80367d:	6a 00                	push   $0x0
  80367f:	e8 3b f1 ff ff       	call   8027bf <sys_page_unmap>
  803684:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803687:	83 ec 08             	sub    $0x8,%esp
  80368a:	ff 75 f4             	pushl  -0xc(%ebp)
  80368d:	6a 00                	push   $0x0
  80368f:	e8 2b f1 ff ff       	call   8027bf <sys_page_unmap>
  803694:	83 c4 10             	add    $0x10,%esp
}
  803697:	89 d8                	mov    %ebx,%eax
  803699:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80369c:	5b                   	pop    %ebx
  80369d:	5e                   	pop    %esi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    

008036a0 <pipeisclosed>:
{
  8036a0:	f3 0f 1e fb          	endbr32 
  8036a4:	55                   	push   %ebp
  8036a5:	89 e5                	mov    %esp,%ebp
  8036a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036ad:	50                   	push   %eax
  8036ae:	ff 75 08             	pushl  0x8(%ebp)
  8036b1:	e8 b6 f4 ff ff       	call   802b6c <fd_lookup>
  8036b6:	83 c4 10             	add    $0x10,%esp
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	78 18                	js     8036d5 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8036bd:	83 ec 0c             	sub    $0xc,%esp
  8036c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c3:	e8 33 f4 ff ff       	call   802afb <fd2data>
  8036c8:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	e8 1f fd ff ff       	call   8033f1 <_pipeisclosed>
  8036d2:	83 c4 10             	add    $0x10,%esp
}
  8036d5:	c9                   	leave  
  8036d6:	c3                   	ret    

008036d7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8036d7:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8036db:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e0:	c3                   	ret    

008036e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8036e1:	f3 0f 1e fb          	endbr32 
  8036e5:	55                   	push   %ebp
  8036e6:	89 e5                	mov    %esp,%ebp
  8036e8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8036eb:	68 49 45 80 00       	push   $0x804549
  8036f0:	ff 75 0c             	pushl  0xc(%ebp)
  8036f3:	e8 f8 eb ff ff       	call   8022f0 <strcpy>
	return 0;
}
  8036f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fd:	c9                   	leave  
  8036fe:	c3                   	ret    

008036ff <devcons_write>:
{
  8036ff:	f3 0f 1e fb          	endbr32 
  803703:	55                   	push   %ebp
  803704:	89 e5                	mov    %esp,%ebp
  803706:	57                   	push   %edi
  803707:	56                   	push   %esi
  803708:	53                   	push   %ebx
  803709:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80370f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803714:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80371a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80371d:	73 31                	jae    803750 <devcons_write+0x51>
		m = n - tot;
  80371f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803722:	29 f3                	sub    %esi,%ebx
  803724:	83 fb 7f             	cmp    $0x7f,%ebx
  803727:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80372c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80372f:	83 ec 04             	sub    $0x4,%esp
  803732:	53                   	push   %ebx
  803733:	89 f0                	mov    %esi,%eax
  803735:	03 45 0c             	add    0xc(%ebp),%eax
  803738:	50                   	push   %eax
  803739:	57                   	push   %edi
  80373a:	e8 67 ed ff ff       	call   8024a6 <memmove>
		sys_cputs(buf, m);
  80373f:	83 c4 08             	add    $0x8,%esp
  803742:	53                   	push   %ebx
  803743:	57                   	push   %edi
  803744:	e8 19 ef ff ff       	call   802662 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803749:	01 de                	add    %ebx,%esi
  80374b:	83 c4 10             	add    $0x10,%esp
  80374e:	eb ca                	jmp    80371a <devcons_write+0x1b>
}
  803750:	89 f0                	mov    %esi,%eax
  803752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803755:	5b                   	pop    %ebx
  803756:	5e                   	pop    %esi
  803757:	5f                   	pop    %edi
  803758:	5d                   	pop    %ebp
  803759:	c3                   	ret    

0080375a <devcons_read>:
{
  80375a:	f3 0f 1e fb          	endbr32 
  80375e:	55                   	push   %ebp
  80375f:	89 e5                	mov    %esp,%ebp
  803761:	83 ec 08             	sub    $0x8,%esp
  803764:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803769:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80376d:	74 21                	je     803790 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80376f:	e8 10 ef ff ff       	call   802684 <sys_cgetc>
  803774:	85 c0                	test   %eax,%eax
  803776:	75 07                	jne    80377f <devcons_read+0x25>
		sys_yield();
  803778:	e8 92 ef ff ff       	call   80270f <sys_yield>
  80377d:	eb f0                	jmp    80376f <devcons_read+0x15>
	if (c < 0)
  80377f:	78 0f                	js     803790 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  803781:	83 f8 04             	cmp    $0x4,%eax
  803784:	74 0c                	je     803792 <devcons_read+0x38>
	*(char*)vbuf = c;
  803786:	8b 55 0c             	mov    0xc(%ebp),%edx
  803789:	88 02                	mov    %al,(%edx)
	return 1;
  80378b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803790:	c9                   	leave  
  803791:	c3                   	ret    
		return 0;
  803792:	b8 00 00 00 00       	mov    $0x0,%eax
  803797:	eb f7                	jmp    803790 <devcons_read+0x36>

00803799 <cputchar>:
{
  803799:	f3 0f 1e fb          	endbr32 
  80379d:	55                   	push   %ebp
  80379e:	89 e5                	mov    %esp,%ebp
  8037a0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8037a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8037a9:	6a 01                	push   $0x1
  8037ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8037ae:	50                   	push   %eax
  8037af:	e8 ae ee ff ff       	call   802662 <sys_cputs>
}
  8037b4:	83 c4 10             	add    $0x10,%esp
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    

008037b9 <getchar>:
{
  8037b9:	f3 0f 1e fb          	endbr32 
  8037bd:	55                   	push   %ebp
  8037be:	89 e5                	mov    %esp,%ebp
  8037c0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8037c3:	6a 01                	push   $0x1
  8037c5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8037c8:	50                   	push   %eax
  8037c9:	6a 00                	push   $0x0
  8037cb:	e8 1f f6 ff ff       	call   802def <read>
	if (r < 0)
  8037d0:	83 c4 10             	add    $0x10,%esp
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	78 06                	js     8037dd <getchar+0x24>
	if (r < 1)
  8037d7:	74 06                	je     8037df <getchar+0x26>
	return c;
  8037d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8037dd:	c9                   	leave  
  8037de:	c3                   	ret    
		return -E_EOF;
  8037df:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8037e4:	eb f7                	jmp    8037dd <getchar+0x24>

008037e6 <iscons>:
{
  8037e6:	f3 0f 1e fb          	endbr32 
  8037ea:	55                   	push   %ebp
  8037eb:	89 e5                	mov    %esp,%ebp
  8037ed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037f3:	50                   	push   %eax
  8037f4:	ff 75 08             	pushl  0x8(%ebp)
  8037f7:	e8 70 f3 ff ff       	call   802b6c <fd_lookup>
  8037fc:	83 c4 10             	add    $0x10,%esp
  8037ff:	85 c0                	test   %eax,%eax
  803801:	78 11                	js     803814 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  803803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803806:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  80380c:	39 10                	cmp    %edx,(%eax)
  80380e:	0f 94 c0             	sete   %al
  803811:	0f b6 c0             	movzbl %al,%eax
}
  803814:	c9                   	leave  
  803815:	c3                   	ret    

00803816 <opencons>:
{
  803816:	f3 0f 1e fb          	endbr32 
  80381a:	55                   	push   %ebp
  80381b:	89 e5                	mov    %esp,%ebp
  80381d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803820:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803823:	50                   	push   %eax
  803824:	e8 ed f2 ff ff       	call   802b16 <fd_alloc>
  803829:	83 c4 10             	add    $0x10,%esp
  80382c:	85 c0                	test   %eax,%eax
  80382e:	78 3a                	js     80386a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803830:	83 ec 04             	sub    $0x4,%esp
  803833:	68 07 04 00 00       	push   $0x407
  803838:	ff 75 f4             	pushl  -0xc(%ebp)
  80383b:	6a 00                	push   $0x0
  80383d:	e8 f0 ee ff ff       	call   802732 <sys_page_alloc>
  803842:	83 c4 10             	add    $0x10,%esp
  803845:	85 c0                	test   %eax,%eax
  803847:	78 21                	js     80386a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  803849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384c:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803852:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803857:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80385e:	83 ec 0c             	sub    $0xc,%esp
  803861:	50                   	push   %eax
  803862:	e8 80 f2 ff ff       	call   802ae7 <fd2num>
  803867:	83 c4 10             	add    $0x10,%esp
}
  80386a:	c9                   	leave  
  80386b:	c3                   	ret    
  80386c:	66 90                	xchg   %ax,%ax
  80386e:	66 90                	xchg   %ax,%ax

00803870 <__udivdi3>:
  803870:	f3 0f 1e fb          	endbr32 
  803874:	55                   	push   %ebp
  803875:	57                   	push   %edi
  803876:	56                   	push   %esi
  803877:	53                   	push   %ebx
  803878:	83 ec 1c             	sub    $0x1c,%esp
  80387b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80387f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803883:	8b 74 24 34          	mov    0x34(%esp),%esi
  803887:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80388b:	85 d2                	test   %edx,%edx
  80388d:	75 19                	jne    8038a8 <__udivdi3+0x38>
  80388f:	39 f3                	cmp    %esi,%ebx
  803891:	76 4d                	jbe    8038e0 <__udivdi3+0x70>
  803893:	31 ff                	xor    %edi,%edi
  803895:	89 e8                	mov    %ebp,%eax
  803897:	89 f2                	mov    %esi,%edx
  803899:	f7 f3                	div    %ebx
  80389b:	89 fa                	mov    %edi,%edx
  80389d:	83 c4 1c             	add    $0x1c,%esp
  8038a0:	5b                   	pop    %ebx
  8038a1:	5e                   	pop    %esi
  8038a2:	5f                   	pop    %edi
  8038a3:	5d                   	pop    %ebp
  8038a4:	c3                   	ret    
  8038a5:	8d 76 00             	lea    0x0(%esi),%esi
  8038a8:	39 f2                	cmp    %esi,%edx
  8038aa:	76 14                	jbe    8038c0 <__udivdi3+0x50>
  8038ac:	31 ff                	xor    %edi,%edi
  8038ae:	31 c0                	xor    %eax,%eax
  8038b0:	89 fa                	mov    %edi,%edx
  8038b2:	83 c4 1c             	add    $0x1c,%esp
  8038b5:	5b                   	pop    %ebx
  8038b6:	5e                   	pop    %esi
  8038b7:	5f                   	pop    %edi
  8038b8:	5d                   	pop    %ebp
  8038b9:	c3                   	ret    
  8038ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8038c0:	0f bd fa             	bsr    %edx,%edi
  8038c3:	83 f7 1f             	xor    $0x1f,%edi
  8038c6:	75 48                	jne    803910 <__udivdi3+0xa0>
  8038c8:	39 f2                	cmp    %esi,%edx
  8038ca:	72 06                	jb     8038d2 <__udivdi3+0x62>
  8038cc:	31 c0                	xor    %eax,%eax
  8038ce:	39 eb                	cmp    %ebp,%ebx
  8038d0:	77 de                	ja     8038b0 <__udivdi3+0x40>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	eb d7                	jmp    8038b0 <__udivdi3+0x40>
  8038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038e0:	89 d9                	mov    %ebx,%ecx
  8038e2:	85 db                	test   %ebx,%ebx
  8038e4:	75 0b                	jne    8038f1 <__udivdi3+0x81>
  8038e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038eb:	31 d2                	xor    %edx,%edx
  8038ed:	f7 f3                	div    %ebx
  8038ef:	89 c1                	mov    %eax,%ecx
  8038f1:	31 d2                	xor    %edx,%edx
  8038f3:	89 f0                	mov    %esi,%eax
  8038f5:	f7 f1                	div    %ecx
  8038f7:	89 c6                	mov    %eax,%esi
  8038f9:	89 e8                	mov    %ebp,%eax
  8038fb:	89 f7                	mov    %esi,%edi
  8038fd:	f7 f1                	div    %ecx
  8038ff:	89 fa                	mov    %edi,%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803910:	89 f9                	mov    %edi,%ecx
  803912:	b8 20 00 00 00       	mov    $0x20,%eax
  803917:	29 f8                	sub    %edi,%eax
  803919:	d3 e2                	shl    %cl,%edx
  80391b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80391f:	89 c1                	mov    %eax,%ecx
  803921:	89 da                	mov    %ebx,%edx
  803923:	d3 ea                	shr    %cl,%edx
  803925:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803929:	09 d1                	or     %edx,%ecx
  80392b:	89 f2                	mov    %esi,%edx
  80392d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803931:	89 f9                	mov    %edi,%ecx
  803933:	d3 e3                	shl    %cl,%ebx
  803935:	89 c1                	mov    %eax,%ecx
  803937:	d3 ea                	shr    %cl,%edx
  803939:	89 f9                	mov    %edi,%ecx
  80393b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80393f:	89 eb                	mov    %ebp,%ebx
  803941:	d3 e6                	shl    %cl,%esi
  803943:	89 c1                	mov    %eax,%ecx
  803945:	d3 eb                	shr    %cl,%ebx
  803947:	09 de                	or     %ebx,%esi
  803949:	89 f0                	mov    %esi,%eax
  80394b:	f7 74 24 08          	divl   0x8(%esp)
  80394f:	89 d6                	mov    %edx,%esi
  803951:	89 c3                	mov    %eax,%ebx
  803953:	f7 64 24 0c          	mull   0xc(%esp)
  803957:	39 d6                	cmp    %edx,%esi
  803959:	72 15                	jb     803970 <__udivdi3+0x100>
  80395b:	89 f9                	mov    %edi,%ecx
  80395d:	d3 e5                	shl    %cl,%ebp
  80395f:	39 c5                	cmp    %eax,%ebp
  803961:	73 04                	jae    803967 <__udivdi3+0xf7>
  803963:	39 d6                	cmp    %edx,%esi
  803965:	74 09                	je     803970 <__udivdi3+0x100>
  803967:	89 d8                	mov    %ebx,%eax
  803969:	31 ff                	xor    %edi,%edi
  80396b:	e9 40 ff ff ff       	jmp    8038b0 <__udivdi3+0x40>
  803970:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803973:	31 ff                	xor    %edi,%edi
  803975:	e9 36 ff ff ff       	jmp    8038b0 <__udivdi3+0x40>
  80397a:	66 90                	xchg   %ax,%ax
  80397c:	66 90                	xchg   %ax,%ax
  80397e:	66 90                	xchg   %ax,%ax

00803980 <__umoddi3>:
  803980:	f3 0f 1e fb          	endbr32 
  803984:	55                   	push   %ebp
  803985:	57                   	push   %edi
  803986:	56                   	push   %esi
  803987:	53                   	push   %ebx
  803988:	83 ec 1c             	sub    $0x1c,%esp
  80398b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80398f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803993:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803997:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80399b:	85 c0                	test   %eax,%eax
  80399d:	75 19                	jne    8039b8 <__umoddi3+0x38>
  80399f:	39 df                	cmp    %ebx,%edi
  8039a1:	76 5d                	jbe    803a00 <__umoddi3+0x80>
  8039a3:	89 f0                	mov    %esi,%eax
  8039a5:	89 da                	mov    %ebx,%edx
  8039a7:	f7 f7                	div    %edi
  8039a9:	89 d0                	mov    %edx,%eax
  8039ab:	31 d2                	xor    %edx,%edx
  8039ad:	83 c4 1c             	add    $0x1c,%esp
  8039b0:	5b                   	pop    %ebx
  8039b1:	5e                   	pop    %esi
  8039b2:	5f                   	pop    %edi
  8039b3:	5d                   	pop    %ebp
  8039b4:	c3                   	ret    
  8039b5:	8d 76 00             	lea    0x0(%esi),%esi
  8039b8:	89 f2                	mov    %esi,%edx
  8039ba:	39 d8                	cmp    %ebx,%eax
  8039bc:	76 12                	jbe    8039d0 <__umoddi3+0x50>
  8039be:	89 f0                	mov    %esi,%eax
  8039c0:	89 da                	mov    %ebx,%edx
  8039c2:	83 c4 1c             	add    $0x1c,%esp
  8039c5:	5b                   	pop    %ebx
  8039c6:	5e                   	pop    %esi
  8039c7:	5f                   	pop    %edi
  8039c8:	5d                   	pop    %ebp
  8039c9:	c3                   	ret    
  8039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8039d0:	0f bd e8             	bsr    %eax,%ebp
  8039d3:	83 f5 1f             	xor    $0x1f,%ebp
  8039d6:	75 50                	jne    803a28 <__umoddi3+0xa8>
  8039d8:	39 d8                	cmp    %ebx,%eax
  8039da:	0f 82 e0 00 00 00    	jb     803ac0 <__umoddi3+0x140>
  8039e0:	89 d9                	mov    %ebx,%ecx
  8039e2:	39 f7                	cmp    %esi,%edi
  8039e4:	0f 86 d6 00 00 00    	jbe    803ac0 <__umoddi3+0x140>
  8039ea:	89 d0                	mov    %edx,%eax
  8039ec:	89 ca                	mov    %ecx,%edx
  8039ee:	83 c4 1c             	add    $0x1c,%esp
  8039f1:	5b                   	pop    %ebx
  8039f2:	5e                   	pop    %esi
  8039f3:	5f                   	pop    %edi
  8039f4:	5d                   	pop    %ebp
  8039f5:	c3                   	ret    
  8039f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8039fd:	8d 76 00             	lea    0x0(%esi),%esi
  803a00:	89 fd                	mov    %edi,%ebp
  803a02:	85 ff                	test   %edi,%edi
  803a04:	75 0b                	jne    803a11 <__umoddi3+0x91>
  803a06:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0b:	31 d2                	xor    %edx,%edx
  803a0d:	f7 f7                	div    %edi
  803a0f:	89 c5                	mov    %eax,%ebp
  803a11:	89 d8                	mov    %ebx,%eax
  803a13:	31 d2                	xor    %edx,%edx
  803a15:	f7 f5                	div    %ebp
  803a17:	89 f0                	mov    %esi,%eax
  803a19:	f7 f5                	div    %ebp
  803a1b:	89 d0                	mov    %edx,%eax
  803a1d:	31 d2                	xor    %edx,%edx
  803a1f:	eb 8c                	jmp    8039ad <__umoddi3+0x2d>
  803a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803a28:	89 e9                	mov    %ebp,%ecx
  803a2a:	ba 20 00 00 00       	mov    $0x20,%edx
  803a2f:	29 ea                	sub    %ebp,%edx
  803a31:	d3 e0                	shl    %cl,%eax
  803a33:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a37:	89 d1                	mov    %edx,%ecx
  803a39:	89 f8                	mov    %edi,%eax
  803a3b:	d3 e8                	shr    %cl,%eax
  803a3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803a41:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a45:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a49:	09 c1                	or     %eax,%ecx
  803a4b:	89 d8                	mov    %ebx,%eax
  803a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a51:	89 e9                	mov    %ebp,%ecx
  803a53:	d3 e7                	shl    %cl,%edi
  803a55:	89 d1                	mov    %edx,%ecx
  803a57:	d3 e8                	shr    %cl,%eax
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a5f:	d3 e3                	shl    %cl,%ebx
  803a61:	89 c7                	mov    %eax,%edi
  803a63:	89 d1                	mov    %edx,%ecx
  803a65:	89 f0                	mov    %esi,%eax
  803a67:	d3 e8                	shr    %cl,%eax
  803a69:	89 e9                	mov    %ebp,%ecx
  803a6b:	89 fa                	mov    %edi,%edx
  803a6d:	d3 e6                	shl    %cl,%esi
  803a6f:	09 d8                	or     %ebx,%eax
  803a71:	f7 74 24 08          	divl   0x8(%esp)
  803a75:	89 d1                	mov    %edx,%ecx
  803a77:	89 f3                	mov    %esi,%ebx
  803a79:	f7 64 24 0c          	mull   0xc(%esp)
  803a7d:	89 c6                	mov    %eax,%esi
  803a7f:	89 d7                	mov    %edx,%edi
  803a81:	39 d1                	cmp    %edx,%ecx
  803a83:	72 06                	jb     803a8b <__umoddi3+0x10b>
  803a85:	75 10                	jne    803a97 <__umoddi3+0x117>
  803a87:	39 c3                	cmp    %eax,%ebx
  803a89:	73 0c                	jae    803a97 <__umoddi3+0x117>
  803a8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803a8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803a93:	89 d7                	mov    %edx,%edi
  803a95:	89 c6                	mov    %eax,%esi
  803a97:	89 ca                	mov    %ecx,%edx
  803a99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803a9e:	29 f3                	sub    %esi,%ebx
  803aa0:	19 fa                	sbb    %edi,%edx
  803aa2:	89 d0                	mov    %edx,%eax
  803aa4:	d3 e0                	shl    %cl,%eax
  803aa6:	89 e9                	mov    %ebp,%ecx
  803aa8:	d3 eb                	shr    %cl,%ebx
  803aaa:	d3 ea                	shr    %cl,%edx
  803aac:	09 d8                	or     %ebx,%eax
  803aae:	83 c4 1c             	add    $0x1c,%esp
  803ab1:	5b                   	pop    %ebx
  803ab2:	5e                   	pop    %esi
  803ab3:	5f                   	pop    %edi
  803ab4:	5d                   	pop    %ebp
  803ab5:	c3                   	ret    
  803ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803abd:	8d 76 00             	lea    0x0(%esi),%esi
  803ac0:	29 fe                	sub    %edi,%esi
  803ac2:	19 c3                	sbb    %eax,%ebx
  803ac4:	89 f2                	mov    %esi,%edx
  803ac6:	89 d9                	mov    %ebx,%ecx
  803ac8:	e9 1d ff ff ff       	jmp    8039ea <__umoddi3+0x6a>
