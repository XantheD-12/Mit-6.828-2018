
obj/kern/kernel：     文件格式 elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 10 12 f0       	mov    $0xf0121000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 62 00 00 00       	call   f01000a0 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
 
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	f3 0f 1e fb          	endbr32 
f0100044:	55                   	push   %ebp
f0100045:	89 e5                	mov    %esp,%ebp
f0100047:	56                   	push   %esi
f0100048:	53                   	push   %ebx
f0100049:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004c:	83 3d 80 7e 21 f0 00 	cmpl   $0x0,0xf0217e80
f0100053:	74 0f                	je     f0100064 <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100055:	83 ec 0c             	sub    $0xc,%esp
f0100058:	6a 00                	push   $0x0
f010005a:	e8 ac 0a 00 00       	call   f0100b0b <monitor>
f010005f:	83 c4 10             	add    $0x10,%esp
f0100062:	eb f1                	jmp    f0100055 <_panic+0x15>
	panicstr = fmt;
f0100064:	89 35 80 7e 21 f0    	mov    %esi,0xf0217e80
	asm volatile("cli; cld");
f010006a:	fa                   	cli    
f010006b:	fc                   	cld    
	va_start(ap, fmt);
f010006c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006f:	e8 86 5f 00 00       	call   f0105ffa <cpunum>
f0100074:	ff 75 0c             	pushl  0xc(%ebp)
f0100077:	ff 75 08             	pushl  0x8(%ebp)
f010007a:	50                   	push   %eax
f010007b:	68 80 66 10 f0       	push   $0xf0106680
f0100080:	e8 53 3a 00 00       	call   f0103ad8 <cprintf>
	vcprintf(fmt, ap);
f0100085:	83 c4 08             	add    $0x8,%esp
f0100088:	53                   	push   %ebx
f0100089:	56                   	push   %esi
f010008a:	e8 1f 3a 00 00       	call   f0103aae <vcprintf>
	cprintf("\n");
f010008f:	c7 04 24 87 70 10 f0 	movl   $0xf0107087,(%esp)
f0100096:	e8 3d 3a 00 00       	call   f0103ad8 <cprintf>
f010009b:	83 c4 10             	add    $0x10,%esp
f010009e:	eb b5                	jmp    f0100055 <_panic+0x15>

f01000a0 <i386_init>:
{
f01000a0:	f3 0f 1e fb          	endbr32 
f01000a4:	55                   	push   %ebp
f01000a5:	89 e5                	mov    %esp,%ebp
f01000a7:	53                   	push   %ebx
f01000a8:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000ab:	e8 a9 05 00 00       	call   f0100659 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b0:	83 ec 08             	sub    $0x8,%esp
f01000b3:	68 ac 1a 00 00       	push   $0x1aac
f01000b8:	68 ec 66 10 f0       	push   $0xf01066ec
f01000bd:	e8 16 3a 00 00       	call   f0103ad8 <cprintf>
	mem_init();
f01000c2:	e8 eb 13 00 00       	call   f01014b2 <mem_init>
	env_init();
f01000c7:	e8 15 32 00 00       	call   f01032e1 <env_init>
	trap_init();
f01000cc:	e8 ed 3a 00 00       	call   f0103bbe <trap_init>
	mp_init();
f01000d1:	e8 25 5c 00 00       	call   f0105cfb <mp_init>
	lapic_init();
f01000d6:	e8 39 5f 00 00       	call   f0106014 <lapic_init>
	pic_init();
f01000db:	e8 0d 39 00 00       	call   f01039ed <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000e0:	c7 04 24 c0 33 12 f0 	movl   $0xf01233c0,(%esp)
f01000e7:	e8 96 61 00 00       	call   f0106282 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000ec:	83 c4 10             	add    $0x10,%esp
f01000ef:	83 3d 88 7e 21 f0 07 	cmpl   $0x7,0xf0217e88
f01000f6:	76 27                	jbe    f010011f <i386_init+0x7f>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000f8:	83 ec 04             	sub    $0x4,%esp
f01000fb:	b8 5e 5c 10 f0       	mov    $0xf0105c5e,%eax
f0100100:	2d e4 5b 10 f0       	sub    $0xf0105be4,%eax
f0100105:	50                   	push   %eax
f0100106:	68 e4 5b 10 f0       	push   $0xf0105be4
f010010b:	68 00 70 00 f0       	push   $0xf0007000
f0100110:	e8 12 59 00 00       	call   f0105a27 <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f0100115:	83 c4 10             	add    $0x10,%esp
f0100118:	bb 20 80 21 f0       	mov    $0xf0218020,%ebx
f010011d:	eb 53                	jmp    f0100172 <i386_init+0xd2>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010011f:	68 00 70 00 00       	push   $0x7000
f0100124:	68 a4 66 10 f0       	push   $0xf01066a4
f0100129:	6a 57                	push   $0x57
f010012b:	68 07 67 10 f0       	push   $0xf0106707
f0100130:	e8 0b ff ff ff       	call   f0100040 <_panic>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100135:	89 d8                	mov    %ebx,%eax
f0100137:	2d 20 80 21 f0       	sub    $0xf0218020,%eax
f010013c:	c1 f8 02             	sar    $0x2,%eax
f010013f:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100145:	c1 e0 0f             	shl    $0xf,%eax
f0100148:	8d 80 00 10 22 f0    	lea    -0xfddf000(%eax),%eax
f010014e:	a3 84 7e 21 f0       	mov    %eax,0xf0217e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100153:	83 ec 08             	sub    $0x8,%esp
f0100156:	68 00 70 00 00       	push   $0x7000
f010015b:	0f b6 03             	movzbl (%ebx),%eax
f010015e:	50                   	push   %eax
f010015f:	e8 0a 60 00 00       	call   f010616e <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f0100164:	83 c4 10             	add    $0x10,%esp
f0100167:	8b 43 04             	mov    0x4(%ebx),%eax
f010016a:	83 f8 01             	cmp    $0x1,%eax
f010016d:	75 f8                	jne    f0100167 <i386_init+0xc7>
	for (c = cpus; c < cpus + ncpu; c++) {
f010016f:	83 c3 74             	add    $0x74,%ebx
f0100172:	6b 05 c4 83 21 f0 74 	imul   $0x74,0xf02183c4,%eax
f0100179:	05 20 80 21 f0       	add    $0xf0218020,%eax
f010017e:	39 c3                	cmp    %eax,%ebx
f0100180:	73 13                	jae    f0100195 <i386_init+0xf5>
		if (c == cpus + cpunum())  // We've started already.
f0100182:	e8 73 5e 00 00       	call   f0105ffa <cpunum>
f0100187:	6b c0 74             	imul   $0x74,%eax,%eax
f010018a:	05 20 80 21 f0       	add    $0xf0218020,%eax
f010018f:	39 c3                	cmp    %eax,%ebx
f0100191:	74 dc                	je     f010016f <i386_init+0xcf>
f0100193:	eb a0                	jmp    f0100135 <i386_init+0x95>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100195:	83 ec 08             	sub    $0x8,%esp
f0100198:	6a 01                	push   $0x1
f010019a:	68 a8 38 1d f0       	push   $0xf01d38a8
f010019f:	e8 eb 32 00 00       	call   f010348f <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001a4:	83 c4 08             	add    $0x8,%esp
f01001a7:	6a 00                	push   $0x0
f01001a9:	68 50 68 20 f0       	push   $0xf0206850
f01001ae:	e8 dc 32 00 00       	call   f010348f <env_create>
	kbd_intr();
f01001b3:	e8 45 04 00 00       	call   f01005fd <kbd_intr>
	sched_yield();
f01001b8:	e8 57 45 00 00       	call   f0104714 <sched_yield>

f01001bd <mp_main>:
{
f01001bd:	f3 0f 1e fb          	endbr32 
f01001c1:	55                   	push   %ebp
f01001c2:	89 e5                	mov    %esp,%ebp
f01001c4:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001c7:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001cc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001d1:	76 52                	jbe    f0100225 <mp_main+0x68>
	return (physaddr_t)kva - KERNBASE;
f01001d3:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001d8:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001db:	e8 1a 5e 00 00       	call   f0105ffa <cpunum>
f01001e0:	83 ec 08             	sub    $0x8,%esp
f01001e3:	50                   	push   %eax
f01001e4:	68 13 67 10 f0       	push   $0xf0106713
f01001e9:	e8 ea 38 00 00       	call   f0103ad8 <cprintf>
	lapic_init();
f01001ee:	e8 21 5e 00 00       	call   f0106014 <lapic_init>
	env_init_percpu();
f01001f3:	e8 b9 30 00 00       	call   f01032b1 <env_init_percpu>
	trap_init_percpu();
f01001f8:	e8 f3 38 00 00       	call   f0103af0 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01001fd:	e8 f8 5d 00 00       	call   f0105ffa <cpunum>
f0100202:	6b d0 74             	imul   $0x74,%eax,%edx
f0100205:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100208:	b8 01 00 00 00       	mov    $0x1,%eax
f010020d:	f0 87 82 20 80 21 f0 	lock xchg %eax,-0xfde7fe0(%edx)
f0100214:	c7 04 24 c0 33 12 f0 	movl   $0xf01233c0,(%esp)
f010021b:	e8 62 60 00 00       	call   f0106282 <spin_lock>
	sched_yield();
f0100220:	e8 ef 44 00 00       	call   f0104714 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100225:	50                   	push   %eax
f0100226:	68 c8 66 10 f0       	push   $0xf01066c8
f010022b:	6a 6e                	push   $0x6e
f010022d:	68 07 67 10 f0       	push   $0xf0106707
f0100232:	e8 09 fe ff ff       	call   f0100040 <_panic>

f0100237 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100237:	f3 0f 1e fb          	endbr32 
f010023b:	55                   	push   %ebp
f010023c:	89 e5                	mov    %esp,%ebp
f010023e:	53                   	push   %ebx
f010023f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100242:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100245:	ff 75 0c             	pushl  0xc(%ebp)
f0100248:	ff 75 08             	pushl  0x8(%ebp)
f010024b:	68 29 67 10 f0       	push   $0xf0106729
f0100250:	e8 83 38 00 00       	call   f0103ad8 <cprintf>
	vcprintf(fmt, ap);
f0100255:	83 c4 08             	add    $0x8,%esp
f0100258:	53                   	push   %ebx
f0100259:	ff 75 10             	pushl  0x10(%ebp)
f010025c:	e8 4d 38 00 00       	call   f0103aae <vcprintf>
	cprintf("\n");
f0100261:	c7 04 24 87 70 10 f0 	movl   $0xf0107087,(%esp)
f0100268:	e8 6b 38 00 00       	call   f0103ad8 <cprintf>
	va_end(ap);
}
f010026d:	83 c4 10             	add    $0x10,%esp
f0100270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100273:	c9                   	leave  
f0100274:	c3                   	ret    

f0100275 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100275:	f3 0f 1e fb          	endbr32 
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100279:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010027e:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010027f:	a8 01                	test   $0x1,%al
f0100281:	74 0a                	je     f010028d <serial_proc_data+0x18>
f0100283:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100288:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100289:	0f b6 c0             	movzbl %al,%eax
f010028c:	c3                   	ret    
		return -1;
f010028d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100292:	c3                   	ret    

f0100293 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100293:	55                   	push   %ebp
f0100294:	89 e5                	mov    %esp,%ebp
f0100296:	53                   	push   %ebx
f0100297:	83 ec 04             	sub    $0x4,%esp
f010029a:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010029c:	ff d3                	call   *%ebx
f010029e:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002a1:	74 29                	je     f01002cc <cons_intr+0x39>
		if (c == 0)
f01002a3:	85 c0                	test   %eax,%eax
f01002a5:	74 f5                	je     f010029c <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002a7:	8b 0d 24 72 21 f0    	mov    0xf0217224,%ecx
f01002ad:	8d 51 01             	lea    0x1(%ecx),%edx
f01002b0:	88 81 20 70 21 f0    	mov    %al,-0xfde8fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002b6:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002bc:	b8 00 00 00 00       	mov    $0x0,%eax
f01002c1:	0f 44 d0             	cmove  %eax,%edx
f01002c4:	89 15 24 72 21 f0    	mov    %edx,0xf0217224
f01002ca:	eb d0                	jmp    f010029c <cons_intr+0x9>
	}
}
f01002cc:	83 c4 04             	add    $0x4,%esp
f01002cf:	5b                   	pop    %ebx
f01002d0:	5d                   	pop    %ebp
f01002d1:	c3                   	ret    

f01002d2 <kbd_proc_data>:
{
f01002d2:	f3 0f 1e fb          	endbr32 
f01002d6:	55                   	push   %ebp
f01002d7:	89 e5                	mov    %esp,%ebp
f01002d9:	53                   	push   %ebx
f01002da:	83 ec 04             	sub    $0x4,%esp
f01002dd:	ba 64 00 00 00       	mov    $0x64,%edx
f01002e2:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002e3:	a8 01                	test   $0x1,%al
f01002e5:	0f 84 f2 00 00 00    	je     f01003dd <kbd_proc_data+0x10b>
	if (stat & KBS_TERR)
f01002eb:	a8 20                	test   $0x20,%al
f01002ed:	0f 85 f1 00 00 00    	jne    f01003e4 <kbd_proc_data+0x112>
f01002f3:	ba 60 00 00 00       	mov    $0x60,%edx
f01002f8:	ec                   	in     (%dx),%al
f01002f9:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002fb:	3c e0                	cmp    $0xe0,%al
f01002fd:	74 61                	je     f0100360 <kbd_proc_data+0x8e>
	} else if (data & 0x80) {
f01002ff:	84 c0                	test   %al,%al
f0100301:	78 70                	js     f0100373 <kbd_proc_data+0xa1>
	} else if (shift & E0ESC) {
f0100303:	8b 0d 00 70 21 f0    	mov    0xf0217000,%ecx
f0100309:	f6 c1 40             	test   $0x40,%cl
f010030c:	74 0e                	je     f010031c <kbd_proc_data+0x4a>
		data |= 0x80;
f010030e:	83 c8 80             	or     $0xffffff80,%eax
f0100311:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100313:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100316:	89 0d 00 70 21 f0    	mov    %ecx,0xf0217000
	shift |= shiftcode[data];
f010031c:	0f b6 d2             	movzbl %dl,%edx
f010031f:	0f b6 82 a0 68 10 f0 	movzbl -0xfef9760(%edx),%eax
f0100326:	0b 05 00 70 21 f0    	or     0xf0217000,%eax
	shift ^= togglecode[data];
f010032c:	0f b6 8a a0 67 10 f0 	movzbl -0xfef9860(%edx),%ecx
f0100333:	31 c8                	xor    %ecx,%eax
f0100335:	a3 00 70 21 f0       	mov    %eax,0xf0217000
	c = charcode[shift & (CTL | SHIFT)][data];
f010033a:	89 c1                	mov    %eax,%ecx
f010033c:	83 e1 03             	and    $0x3,%ecx
f010033f:	8b 0c 8d 80 67 10 f0 	mov    -0xfef9880(,%ecx,4),%ecx
f0100346:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010034a:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010034d:	a8 08                	test   $0x8,%al
f010034f:	74 61                	je     f01003b2 <kbd_proc_data+0xe0>
		if ('a' <= c && c <= 'z')
f0100351:	89 da                	mov    %ebx,%edx
f0100353:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100356:	83 f9 19             	cmp    $0x19,%ecx
f0100359:	77 4b                	ja     f01003a6 <kbd_proc_data+0xd4>
			c += 'A' - 'a';
f010035b:	83 eb 20             	sub    $0x20,%ebx
f010035e:	eb 0c                	jmp    f010036c <kbd_proc_data+0x9a>
		shift |= E0ESC;
f0100360:	83 0d 00 70 21 f0 40 	orl    $0x40,0xf0217000
		return 0;
f0100367:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f010036c:	89 d8                	mov    %ebx,%eax
f010036e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100371:	c9                   	leave  
f0100372:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f0100373:	8b 0d 00 70 21 f0    	mov    0xf0217000,%ecx
f0100379:	89 cb                	mov    %ecx,%ebx
f010037b:	83 e3 40             	and    $0x40,%ebx
f010037e:	83 e0 7f             	and    $0x7f,%eax
f0100381:	85 db                	test   %ebx,%ebx
f0100383:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100386:	0f b6 d2             	movzbl %dl,%edx
f0100389:	0f b6 82 a0 68 10 f0 	movzbl -0xfef9760(%edx),%eax
f0100390:	83 c8 40             	or     $0x40,%eax
f0100393:	0f b6 c0             	movzbl %al,%eax
f0100396:	f7 d0                	not    %eax
f0100398:	21 c8                	and    %ecx,%eax
f010039a:	a3 00 70 21 f0       	mov    %eax,0xf0217000
		return 0;
f010039f:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003a4:	eb c6                	jmp    f010036c <kbd_proc_data+0x9a>
		else if ('A' <= c && c <= 'Z')
f01003a6:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003a9:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003ac:	83 fa 1a             	cmp    $0x1a,%edx
f01003af:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003b2:	f7 d0                	not    %eax
f01003b4:	a8 06                	test   $0x6,%al
f01003b6:	75 b4                	jne    f010036c <kbd_proc_data+0x9a>
f01003b8:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003be:	75 ac                	jne    f010036c <kbd_proc_data+0x9a>
		cprintf("Rebooting!\n");
f01003c0:	83 ec 0c             	sub    $0xc,%esp
f01003c3:	68 43 67 10 f0       	push   $0xf0106743
f01003c8:	e8 0b 37 00 00       	call   f0103ad8 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003cd:	b8 03 00 00 00       	mov    $0x3,%eax
f01003d2:	ba 92 00 00 00       	mov    $0x92,%edx
f01003d7:	ee                   	out    %al,(%dx)
}
f01003d8:	83 c4 10             	add    $0x10,%esp
f01003db:	eb 8f                	jmp    f010036c <kbd_proc_data+0x9a>
		return -1;
f01003dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003e2:	eb 88                	jmp    f010036c <kbd_proc_data+0x9a>
		return -1;
f01003e4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003e9:	eb 81                	jmp    f010036c <kbd_proc_data+0x9a>

f01003eb <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003eb:	55                   	push   %ebp
f01003ec:	89 e5                	mov    %esp,%ebp
f01003ee:	57                   	push   %edi
f01003ef:	56                   	push   %esi
f01003f0:	53                   	push   %ebx
f01003f1:	83 ec 1c             	sub    $0x1c,%esp
f01003f4:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f01003f6:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01003fb:	bf fd 03 00 00       	mov    $0x3fd,%edi
f0100400:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100405:	89 fa                	mov    %edi,%edx
f0100407:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100408:	a8 20                	test   $0x20,%al
f010040a:	75 13                	jne    f010041f <cons_putc+0x34>
f010040c:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100412:	7f 0b                	jg     f010041f <cons_putc+0x34>
f0100414:	89 da                	mov    %ebx,%edx
f0100416:	ec                   	in     (%dx),%al
f0100417:	ec                   	in     (%dx),%al
f0100418:	ec                   	in     (%dx),%al
f0100419:	ec                   	in     (%dx),%al
	     i++)
f010041a:	83 c6 01             	add    $0x1,%esi
f010041d:	eb e6                	jmp    f0100405 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f010041f:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100422:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100427:	89 c8                	mov    %ecx,%eax
f0100429:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010042a:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010042f:	bf 79 03 00 00       	mov    $0x379,%edi
f0100434:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100439:	89 fa                	mov    %edi,%edx
f010043b:	ec                   	in     (%dx),%al
f010043c:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f0100442:	7f 0f                	jg     f0100453 <cons_putc+0x68>
f0100444:	84 c0                	test   %al,%al
f0100446:	78 0b                	js     f0100453 <cons_putc+0x68>
f0100448:	89 da                	mov    %ebx,%edx
f010044a:	ec                   	in     (%dx),%al
f010044b:	ec                   	in     (%dx),%al
f010044c:	ec                   	in     (%dx),%al
f010044d:	ec                   	in     (%dx),%al
f010044e:	83 c6 01             	add    $0x1,%esi
f0100451:	eb e6                	jmp    f0100439 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100453:	ba 78 03 00 00       	mov    $0x378,%edx
f0100458:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f010045c:	ee                   	out    %al,(%dx)
f010045d:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100462:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100467:	ee                   	out    %al,(%dx)
f0100468:	b8 08 00 00 00       	mov    $0x8,%eax
f010046d:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f010046e:	89 c8                	mov    %ecx,%eax
f0100470:	80 cc 07             	or     $0x7,%ah
f0100473:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f0100479:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f010047c:	0f b6 c1             	movzbl %cl,%eax
f010047f:	80 f9 0a             	cmp    $0xa,%cl
f0100482:	0f 84 dd 00 00 00    	je     f0100565 <cons_putc+0x17a>
f0100488:	83 f8 0a             	cmp    $0xa,%eax
f010048b:	7f 46                	jg     f01004d3 <cons_putc+0xe8>
f010048d:	83 f8 08             	cmp    $0x8,%eax
f0100490:	0f 84 a7 00 00 00    	je     f010053d <cons_putc+0x152>
f0100496:	83 f8 09             	cmp    $0x9,%eax
f0100499:	0f 85 d3 00 00 00    	jne    f0100572 <cons_putc+0x187>
		cons_putc(' ');
f010049f:	b8 20 00 00 00       	mov    $0x20,%eax
f01004a4:	e8 42 ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004a9:	b8 20 00 00 00       	mov    $0x20,%eax
f01004ae:	e8 38 ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b8:	e8 2e ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004bd:	b8 20 00 00 00       	mov    $0x20,%eax
f01004c2:	e8 24 ff ff ff       	call   f01003eb <cons_putc>
		cons_putc(' ');
f01004c7:	b8 20 00 00 00       	mov    $0x20,%eax
f01004cc:	e8 1a ff ff ff       	call   f01003eb <cons_putc>
		break;
f01004d1:	eb 25                	jmp    f01004f8 <cons_putc+0x10d>
	switch (c & 0xff) {
f01004d3:	83 f8 0d             	cmp    $0xd,%eax
f01004d6:	0f 85 96 00 00 00    	jne    f0100572 <cons_putc+0x187>
		crt_pos -= (crt_pos % CRT_COLS);
f01004dc:	0f b7 05 28 72 21 f0 	movzwl 0xf0217228,%eax
f01004e3:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004e9:	c1 e8 16             	shr    $0x16,%eax
f01004ec:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004ef:	c1 e0 04             	shl    $0x4,%eax
f01004f2:	66 a3 28 72 21 f0    	mov    %ax,0xf0217228
	if (crt_pos >= CRT_SIZE) {
f01004f8:	66 81 3d 28 72 21 f0 	cmpw   $0x7cf,0xf0217228
f01004ff:	cf 07 
f0100501:	0f 87 8e 00 00 00    	ja     f0100595 <cons_putc+0x1aa>
	outb(addr_6845, 14);
f0100507:	8b 0d 30 72 21 f0    	mov    0xf0217230,%ecx
f010050d:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100512:	89 ca                	mov    %ecx,%edx
f0100514:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100515:	0f b7 1d 28 72 21 f0 	movzwl 0xf0217228,%ebx
f010051c:	8d 71 01             	lea    0x1(%ecx),%esi
f010051f:	89 d8                	mov    %ebx,%eax
f0100521:	66 c1 e8 08          	shr    $0x8,%ax
f0100525:	89 f2                	mov    %esi,%edx
f0100527:	ee                   	out    %al,(%dx)
f0100528:	b8 0f 00 00 00       	mov    $0xf,%eax
f010052d:	89 ca                	mov    %ecx,%edx
f010052f:	ee                   	out    %al,(%dx)
f0100530:	89 d8                	mov    %ebx,%eax
f0100532:	89 f2                	mov    %esi,%edx
f0100534:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100535:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100538:	5b                   	pop    %ebx
f0100539:	5e                   	pop    %esi
f010053a:	5f                   	pop    %edi
f010053b:	5d                   	pop    %ebp
f010053c:	c3                   	ret    
		if (crt_pos > 0) {
f010053d:	0f b7 05 28 72 21 f0 	movzwl 0xf0217228,%eax
f0100544:	66 85 c0             	test   %ax,%ax
f0100547:	74 be                	je     f0100507 <cons_putc+0x11c>
			crt_pos--;
f0100549:	83 e8 01             	sub    $0x1,%eax
f010054c:	66 a3 28 72 21 f0    	mov    %ax,0xf0217228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100552:	0f b7 d0             	movzwl %ax,%edx
f0100555:	b1 00                	mov    $0x0,%cl
f0100557:	83 c9 20             	or     $0x20,%ecx
f010055a:	a1 2c 72 21 f0       	mov    0xf021722c,%eax
f010055f:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f0100563:	eb 93                	jmp    f01004f8 <cons_putc+0x10d>
		crt_pos += CRT_COLS;
f0100565:	66 83 05 28 72 21 f0 	addw   $0x50,0xf0217228
f010056c:	50 
f010056d:	e9 6a ff ff ff       	jmp    f01004dc <cons_putc+0xf1>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100572:	0f b7 05 28 72 21 f0 	movzwl 0xf0217228,%eax
f0100579:	8d 50 01             	lea    0x1(%eax),%edx
f010057c:	66 89 15 28 72 21 f0 	mov    %dx,0xf0217228
f0100583:	0f b7 c0             	movzwl %ax,%eax
f0100586:	8b 15 2c 72 21 f0    	mov    0xf021722c,%edx
f010058c:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
		break;
f0100590:	e9 63 ff ff ff       	jmp    f01004f8 <cons_putc+0x10d>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100595:	a1 2c 72 21 f0       	mov    0xf021722c,%eax
f010059a:	83 ec 04             	sub    $0x4,%esp
f010059d:	68 00 0f 00 00       	push   $0xf00
f01005a2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005a8:	52                   	push   %edx
f01005a9:	50                   	push   %eax
f01005aa:	e8 78 54 00 00       	call   f0105a27 <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005af:	8b 15 2c 72 21 f0    	mov    0xf021722c,%edx
f01005b5:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005bb:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005c1:	83 c4 10             	add    $0x10,%esp
f01005c4:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005c9:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005cc:	39 d0                	cmp    %edx,%eax
f01005ce:	75 f4                	jne    f01005c4 <cons_putc+0x1d9>
		crt_pos -= CRT_COLS;
f01005d0:	66 83 2d 28 72 21 f0 	subw   $0x50,0xf0217228
f01005d7:	50 
f01005d8:	e9 2a ff ff ff       	jmp    f0100507 <cons_putc+0x11c>

f01005dd <serial_intr>:
{
f01005dd:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f01005e1:	80 3d 34 72 21 f0 00 	cmpb   $0x0,0xf0217234
f01005e8:	75 01                	jne    f01005eb <serial_intr+0xe>
f01005ea:	c3                   	ret    
{
f01005eb:	55                   	push   %ebp
f01005ec:	89 e5                	mov    %esp,%ebp
f01005ee:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005f1:	b8 75 02 10 f0       	mov    $0xf0100275,%eax
f01005f6:	e8 98 fc ff ff       	call   f0100293 <cons_intr>
}
f01005fb:	c9                   	leave  
f01005fc:	c3                   	ret    

f01005fd <kbd_intr>:
{
f01005fd:	f3 0f 1e fb          	endbr32 
f0100601:	55                   	push   %ebp
f0100602:	89 e5                	mov    %esp,%ebp
f0100604:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100607:	b8 d2 02 10 f0       	mov    $0xf01002d2,%eax
f010060c:	e8 82 fc ff ff       	call   f0100293 <cons_intr>
}
f0100611:	c9                   	leave  
f0100612:	c3                   	ret    

f0100613 <cons_getc>:
{
f0100613:	f3 0f 1e fb          	endbr32 
f0100617:	55                   	push   %ebp
f0100618:	89 e5                	mov    %esp,%ebp
f010061a:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010061d:	e8 bb ff ff ff       	call   f01005dd <serial_intr>
	kbd_intr();
f0100622:	e8 d6 ff ff ff       	call   f01005fd <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100627:	a1 20 72 21 f0       	mov    0xf0217220,%eax
	return 0;
f010062c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f0100631:	3b 05 24 72 21 f0    	cmp    0xf0217224,%eax
f0100637:	74 1c                	je     f0100655 <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f0100639:	8d 48 01             	lea    0x1(%eax),%ecx
f010063c:	0f b6 90 20 70 21 f0 	movzbl -0xfde8fe0(%eax),%edx
			cons.rpos = 0;
f0100643:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100648:	b8 00 00 00 00       	mov    $0x0,%eax
f010064d:	0f 45 c1             	cmovne %ecx,%eax
f0100650:	a3 20 72 21 f0       	mov    %eax,0xf0217220
}
f0100655:	89 d0                	mov    %edx,%eax
f0100657:	c9                   	leave  
f0100658:	c3                   	ret    

f0100659 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100659:	f3 0f 1e fb          	endbr32 
f010065d:	55                   	push   %ebp
f010065e:	89 e5                	mov    %esp,%ebp
f0100660:	57                   	push   %edi
f0100661:	56                   	push   %esi
f0100662:	53                   	push   %ebx
f0100663:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100666:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010066d:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100674:	5a a5 
	if (*cp != 0xA55A) {
f0100676:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010067d:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100681:	0f 84 de 00 00 00    	je     f0100765 <cons_init+0x10c>
		addr_6845 = MONO_BASE;
f0100687:	c7 05 30 72 21 f0 b4 	movl   $0x3b4,0xf0217230
f010068e:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100691:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100696:	8b 3d 30 72 21 f0    	mov    0xf0217230,%edi
f010069c:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006a1:	89 fa                	mov    %edi,%edx
f01006a3:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006a4:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006a7:	89 ca                	mov    %ecx,%edx
f01006a9:	ec                   	in     (%dx),%al
f01006aa:	0f b6 c0             	movzbl %al,%eax
f01006ad:	c1 e0 08             	shl    $0x8,%eax
f01006b0:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006b2:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006b7:	89 fa                	mov    %edi,%edx
f01006b9:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006ba:	89 ca                	mov    %ecx,%edx
f01006bc:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006bd:	89 35 2c 72 21 f0    	mov    %esi,0xf021722c
	pos |= inb(addr_6845 + 1);
f01006c3:	0f b6 c0             	movzbl %al,%eax
f01006c6:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006c8:	66 a3 28 72 21 f0    	mov    %ax,0xf0217228
	kbd_intr();
f01006ce:	e8 2a ff ff ff       	call   f01005fd <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006d3:	83 ec 0c             	sub    $0xc,%esp
f01006d6:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f01006dd:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006e2:	50                   	push   %eax
f01006e3:	e8 83 32 00 00       	call   f010396b <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006e8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ed:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006f2:	89 d8                	mov    %ebx,%eax
f01006f4:	89 ca                	mov    %ecx,%edx
f01006f6:	ee                   	out    %al,(%dx)
f01006f7:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01006fc:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100701:	89 fa                	mov    %edi,%edx
f0100703:	ee                   	out    %al,(%dx)
f0100704:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100709:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010070e:	ee                   	out    %al,(%dx)
f010070f:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100714:	89 d8                	mov    %ebx,%eax
f0100716:	89 f2                	mov    %esi,%edx
f0100718:	ee                   	out    %al,(%dx)
f0100719:	b8 03 00 00 00       	mov    $0x3,%eax
f010071e:	89 fa                	mov    %edi,%edx
f0100720:	ee                   	out    %al,(%dx)
f0100721:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100726:	89 d8                	mov    %ebx,%eax
f0100728:	ee                   	out    %al,(%dx)
f0100729:	b8 01 00 00 00       	mov    $0x1,%eax
f010072e:	89 f2                	mov    %esi,%edx
f0100730:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100731:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100736:	ec                   	in     (%dx),%al
f0100737:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100739:	83 c4 10             	add    $0x10,%esp
f010073c:	3c ff                	cmp    $0xff,%al
f010073e:	0f 95 05 34 72 21 f0 	setne  0xf0217234
f0100745:	89 ca                	mov    %ecx,%edx
f0100747:	ec                   	in     (%dx),%al
f0100748:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010074d:	ec                   	in     (%dx),%al
	if (serial_exists)
f010074e:	80 fb ff             	cmp    $0xff,%bl
f0100751:	75 2d                	jne    f0100780 <cons_init+0x127>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100753:	83 ec 0c             	sub    $0xc,%esp
f0100756:	68 4f 67 10 f0       	push   $0xf010674f
f010075b:	e8 78 33 00 00       	call   f0103ad8 <cprintf>
f0100760:	83 c4 10             	add    $0x10,%esp
}
f0100763:	eb 3c                	jmp    f01007a1 <cons_init+0x148>
		*cp = was;
f0100765:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010076c:	c7 05 30 72 21 f0 d4 	movl   $0x3d4,0xf0217230
f0100773:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100776:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010077b:	e9 16 ff ff ff       	jmp    f0100696 <cons_init+0x3d>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100780:	83 ec 0c             	sub    $0xc,%esp
f0100783:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f010078a:	25 ef ff 00 00       	and    $0xffef,%eax
f010078f:	50                   	push   %eax
f0100790:	e8 d6 31 00 00       	call   f010396b <irq_setmask_8259A>
	if (!serial_exists)
f0100795:	83 c4 10             	add    $0x10,%esp
f0100798:	80 3d 34 72 21 f0 00 	cmpb   $0x0,0xf0217234
f010079f:	74 b2                	je     f0100753 <cons_init+0xfa>
}
f01007a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007a4:	5b                   	pop    %ebx
f01007a5:	5e                   	pop    %esi
f01007a6:	5f                   	pop    %edi
f01007a7:	5d                   	pop    %ebp
f01007a8:	c3                   	ret    

f01007a9 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007a9:	f3 0f 1e fb          	endbr32 
f01007ad:	55                   	push   %ebp
f01007ae:	89 e5                	mov    %esp,%ebp
f01007b0:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01007b6:	e8 30 fc ff ff       	call   f01003eb <cons_putc>
}
f01007bb:	c9                   	leave  
f01007bc:	c3                   	ret    

f01007bd <getchar>:

int
getchar(void)
{
f01007bd:	f3 0f 1e fb          	endbr32 
f01007c1:	55                   	push   %ebp
f01007c2:	89 e5                	mov    %esp,%ebp
f01007c4:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007c7:	e8 47 fe ff ff       	call   f0100613 <cons_getc>
f01007cc:	85 c0                	test   %eax,%eax
f01007ce:	74 f7                	je     f01007c7 <getchar+0xa>
		/* do nothing */;
	return c;
}
f01007d0:	c9                   	leave  
f01007d1:	c3                   	ret    

f01007d2 <iscons>:

int
iscons(int fdnum)
{
f01007d2:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f01007d6:	b8 01 00 00 00       	mov    $0x1,%eax
f01007db:	c3                   	ret    

f01007dc <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007dc:	f3 0f 1e fb          	endbr32 
f01007e0:	55                   	push   %ebp
f01007e1:	89 e5                	mov    %esp,%ebp
f01007e3:	83 ec 0c             	sub    $0xc,%esp
	int i;
		
	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007e6:	68 a0 69 10 f0       	push   $0xf01069a0
f01007eb:	68 be 69 10 f0       	push   $0xf01069be
f01007f0:	68 c3 69 10 f0       	push   $0xf01069c3
f01007f5:	e8 de 32 00 00       	call   f0103ad8 <cprintf>
f01007fa:	83 c4 0c             	add    $0xc,%esp
f01007fd:	68 ec 6a 10 f0       	push   $0xf0106aec
f0100802:	68 cc 69 10 f0       	push   $0xf01069cc
f0100807:	68 c3 69 10 f0       	push   $0xf01069c3
f010080c:	e8 c7 32 00 00       	call   f0103ad8 <cprintf>
f0100811:	83 c4 0c             	add    $0xc,%esp
f0100814:	68 14 6b 10 f0       	push   $0xf0106b14
f0100819:	68 d5 69 10 f0       	push   $0xf01069d5
f010081e:	68 c3 69 10 f0       	push   $0xf01069c3
f0100823:	e8 b0 32 00 00       	call   f0103ad8 <cprintf>
f0100828:	83 c4 0c             	add    $0xc,%esp
f010082b:	68 df 69 10 f0       	push   $0xf01069df
f0100830:	68 fb 69 10 f0       	push   $0xf01069fb
f0100835:	68 c3 69 10 f0       	push   $0xf01069c3
f010083a:	e8 99 32 00 00       	call   f0103ad8 <cprintf>
	return 0;
}
f010083f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100844:	c9                   	leave  
f0100845:	c3                   	ret    

f0100846 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100846:	f3 0f 1e fb          	endbr32 
f010084a:	55                   	push   %ebp
f010084b:	89 e5                	mov    %esp,%ebp
f010084d:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100850:	68 08 6a 10 f0       	push   $0xf0106a08
f0100855:	e8 7e 32 00 00       	call   f0103ad8 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010085a:	83 c4 08             	add    $0x8,%esp
f010085d:	68 0c 00 10 00       	push   $0x10000c
f0100862:	68 38 6b 10 f0       	push   $0xf0106b38
f0100867:	e8 6c 32 00 00       	call   f0103ad8 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010086c:	83 c4 0c             	add    $0xc,%esp
f010086f:	68 0c 00 10 00       	push   $0x10000c
f0100874:	68 0c 00 10 f0       	push   $0xf010000c
f0100879:	68 60 6b 10 f0       	push   $0xf0106b60
f010087e:	e8 55 32 00 00       	call   f0103ad8 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100883:	83 c4 0c             	add    $0xc,%esp
f0100886:	68 6d 66 10 00       	push   $0x10666d
f010088b:	68 6d 66 10 f0       	push   $0xf010666d
f0100890:	68 84 6b 10 f0       	push   $0xf0106b84
f0100895:	e8 3e 32 00 00       	call   f0103ad8 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010089a:	83 c4 0c             	add    $0xc,%esp
f010089d:	68 00 70 21 00       	push   $0x217000
f01008a2:	68 00 70 21 f0       	push   $0xf0217000
f01008a7:	68 a8 6b 10 f0       	push   $0xf0106ba8
f01008ac:	e8 27 32 00 00       	call   f0103ad8 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008b1:	83 c4 0c             	add    $0xc,%esp
f01008b4:	68 08 90 25 00       	push   $0x259008
f01008b9:	68 08 90 25 f0       	push   $0xf0259008
f01008be:	68 cc 6b 10 f0       	push   $0xf0106bcc
f01008c3:	e8 10 32 00 00       	call   f0103ad8 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008c8:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008cb:	b8 08 90 25 f0       	mov    $0xf0259008,%eax
f01008d0:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008d5:	c1 f8 0a             	sar    $0xa,%eax
f01008d8:	50                   	push   %eax
f01008d9:	68 f0 6b 10 f0       	push   $0xf0106bf0
f01008de:	e8 f5 31 00 00       	call   f0103ad8 <cprintf>
	return 0;
}
f01008e3:	b8 00 00 00 00       	mov    $0x0,%eax
f01008e8:	c9                   	leave  
f01008e9:	c3                   	ret    

f01008ea <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008ea:	f3 0f 1e fb          	endbr32 
f01008ee:	55                   	push   %ebp
f01008ef:	89 e5                	mov    %esp,%ebp
f01008f1:	57                   	push   %edi
f01008f2:	56                   	push   %esi
f01008f3:	53                   	push   %ebx
f01008f4:	83 ec 38             	sub    $0x38,%esp
    	int ebp,eip;    	
    	struct Eipdebuginfo info;
    	
    	cprintf("Stack backtrace:\n");
f01008f7:	68 21 6a 10 f0       	push   $0xf0106a21
f01008fc:	e8 d7 31 00 00       	call   f0103ad8 <cprintf>
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100901:	89 eb                	mov    %ebp,%ebx
    	
    	//get ebp
	ebp=read_ebp();
    	
    	while(ebp!=0){
f0100903:	83 c4 10             	add    $0x10,%esp
    		eip=*((int *)ebp+1);
    		cprintf("ebp %08x eip %08x args %08x %08x %08x %08x %08x\n",
    			 ebp,eip,*((int *)ebp+2),*((int *)ebp+3),*((int *)ebp+4),*((int *)ebp+5),*((int *)ebp+6));
    		int result=debuginfo_eip(eip,&info);
f0100906:	8d 7d d0             	lea    -0x30(%ebp),%edi
    	while(ebp!=0){
f0100909:	eb 22                	jmp    f010092d <mon_backtrace+0x43>
    		if(result!=0){//-1
    			cprintf("failed to get debuginfo for eip\n");
    		}
    		else{
    			cprintf("%s:%d: %.*s+%d\n",info.eip_file,info.eip_line,info.eip_fn_namelen,info.eip_fn_name,eip-info.eip_fn_addr);
f010090b:	83 ec 08             	sub    $0x8,%esp
f010090e:	2b 75 e0             	sub    -0x20(%ebp),%esi
f0100911:	56                   	push   %esi
f0100912:	ff 75 d8             	pushl  -0x28(%ebp)
f0100915:	ff 75 dc             	pushl  -0x24(%ebp)
f0100918:	ff 75 d4             	pushl  -0x2c(%ebp)
f010091b:	ff 75 d0             	pushl  -0x30(%ebp)
f010091e:	68 33 6a 10 f0       	push   $0xf0106a33
f0100923:	e8 b0 31 00 00       	call   f0103ad8 <cprintf>
f0100928:	83 c4 20             	add    $0x20,%esp
    		}
    		ebp=*((int *)ebp);
f010092b:	8b 1b                	mov    (%ebx),%ebx
    	while(ebp!=0){
f010092d:	85 db                	test   %ebx,%ebx
f010092f:	74 41                	je     f0100972 <mon_backtrace+0x88>
    		eip=*((int *)ebp+1);
f0100931:	8b 73 04             	mov    0x4(%ebx),%esi
    		cprintf("ebp %08x eip %08x args %08x %08x %08x %08x %08x\n",
f0100934:	ff 73 18             	pushl  0x18(%ebx)
f0100937:	ff 73 14             	pushl  0x14(%ebx)
f010093a:	ff 73 10             	pushl  0x10(%ebx)
f010093d:	ff 73 0c             	pushl  0xc(%ebx)
f0100940:	ff 73 08             	pushl  0x8(%ebx)
f0100943:	56                   	push   %esi
f0100944:	53                   	push   %ebx
f0100945:	68 1c 6c 10 f0       	push   $0xf0106c1c
f010094a:	e8 89 31 00 00       	call   f0103ad8 <cprintf>
    		int result=debuginfo_eip(eip,&info);
f010094f:	83 c4 18             	add    $0x18,%esp
f0100952:	57                   	push   %edi
f0100953:	56                   	push   %esi
f0100954:	e8 3f 45 00 00       	call   f0104e98 <debuginfo_eip>
    		if(result!=0){//-1
f0100959:	83 c4 10             	add    $0x10,%esp
f010095c:	85 c0                	test   %eax,%eax
f010095e:	74 ab                	je     f010090b <mon_backtrace+0x21>
    			cprintf("failed to get debuginfo for eip\n");
f0100960:	83 ec 0c             	sub    $0xc,%esp
f0100963:	68 50 6c 10 f0       	push   $0xf0106c50
f0100968:	e8 6b 31 00 00       	call   f0103ad8 <cprintf>
f010096d:	83 c4 10             	add    $0x10,%esp
f0100970:	eb b9                	jmp    f010092b <mon_backtrace+0x41>
    	}    
	return 0;
}
f0100972:	b8 00 00 00 00       	mov    $0x0,%eax
f0100977:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010097a:	5b                   	pop    %ebx
f010097b:	5e                   	pop    %esi
f010097c:	5f                   	pop    %edi
f010097d:	5d                   	pop    %ebp
f010097e:	c3                   	ret    

f010097f <mon_showmappings>:


int
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
f010097f:	f3 0f 1e fb          	endbr32 
f0100983:	55                   	push   %ebp
f0100984:	89 e5                	mov    %esp,%ebp
f0100986:	57                   	push   %edi
f0100987:	56                   	push   %esi
f0100988:	53                   	push   %ebx
f0100989:	83 ec 1c             	sub    $0x1c,%esp
f010098c:	8b 75 0c             	mov    0xc(%ebp),%esi
	//check paramter
	if(argc<3){
f010098f:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100993:	7e 55                	jle    f01009ea <mon_showmappings+0x6b>
		return -1;
	}
	//long int strtol(const char *nptr,char **endptr,int base);
	//string to int
	char *err_char;
	uint32_t begin=strtol(argv[1],&err_char,16);
f0100995:	83 ec 04             	sub    $0x4,%esp
f0100998:	6a 10                	push   $0x10
f010099a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010099d:	50                   	push   %eax
f010099e:	ff 76 04             	pushl  0x4(%esi)
f01009a1:	e8 5f 51 00 00       	call   f0105b05 <strtol>
f01009a6:	89 c3                	mov    %eax,%ebx
	if(*err_char){
f01009a8:	83 c4 10             	add    $0x10,%esp
f01009ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01009ae:	80 38 00             	cmpb   $0x0,(%eax)
f01009b1:	75 51                	jne    f0100a04 <mon_showmappings+0x85>
		cprintf("Invalid begin address: %s\n",argv[1]);
		return -1;
	}
	uint32_t end=strtol(argv[2],&err_char,16);
f01009b3:	83 ec 04             	sub    $0x4,%esp
f01009b6:	6a 10                	push   $0x10
f01009b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01009bb:	50                   	push   %eax
f01009bc:	ff 76 08             	pushl  0x8(%esi)
f01009bf:	e8 41 51 00 00       	call   f0105b05 <strtol>
	if(*err_char){
f01009c4:	83 c4 10             	add    $0x10,%esp
f01009c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01009ca:	80 3a 00             	cmpb   $0x0,(%edx)
f01009cd:	75 52                	jne    f0100a21 <mon_showmappings+0xa2>
		cprintf("Invalid end address: %s\n",argv[2]);
		return -1;
	}
	
	if(begin>end){
f01009cf:	39 c3                	cmp    %eax,%ebx
f01009d1:	77 6b                	ja     f0100a3e <mon_showmappings+0xbf>
		cprintf("Params Error: begin address > end address!\n");
		return -1;
	}	
	
	//alian as PGSIZE
	begin=ROUNDDOWN(begin,PGSIZE);
f01009d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	end=ROUNDUP(end,PGSIZE);
f01009d9:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
f01009df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	
	for(;begin<=end;begin+=PGSIZE){
f01009e5:	e9 85 00 00 00       	jmp    f0100a6f <mon_showmappings+0xf0>
		cprintf("Require 2 virtual address!\n");
f01009ea:	83 ec 0c             	sub    $0xc,%esp
f01009ed:	68 43 6a 10 f0       	push   $0xf0106a43
f01009f2:	e8 e1 30 00 00       	call   f0103ad8 <cprintf>
		return -1;
f01009f7:	83 c4 10             	add    $0x10,%esp
f01009fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01009ff:	e9 ff 00 00 00       	jmp    f0100b03 <mon_showmappings+0x184>
		cprintf("Invalid begin address: %s\n",argv[1]);
f0100a04:	83 ec 08             	sub    $0x8,%esp
f0100a07:	ff 76 04             	pushl  0x4(%esi)
f0100a0a:	68 5f 6a 10 f0       	push   $0xf0106a5f
f0100a0f:	e8 c4 30 00 00       	call   f0103ad8 <cprintf>
		return -1;
f0100a14:	83 c4 10             	add    $0x10,%esp
f0100a17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100a1c:	e9 e2 00 00 00       	jmp    f0100b03 <mon_showmappings+0x184>
		cprintf("Invalid end address: %s\n",argv[2]);
f0100a21:	83 ec 08             	sub    $0x8,%esp
f0100a24:	ff 76 08             	pushl  0x8(%esi)
f0100a27:	68 7a 6a 10 f0       	push   $0xf0106a7a
f0100a2c:	e8 a7 30 00 00       	call   f0103ad8 <cprintf>
		return -1;
f0100a31:	83 c4 10             	add    $0x10,%esp
f0100a34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100a39:	e9 c5 00 00 00       	jmp    f0100b03 <mon_showmappings+0x184>
		cprintf("Params Error: begin address > end address!\n");
f0100a3e:	83 ec 0c             	sub    $0xc,%esp
f0100a41:	68 74 6c 10 f0       	push   $0xf0106c74
f0100a46:	e8 8d 30 00 00       	call   f0103ad8 <cprintf>
		return -1;
f0100a4b:	83 c4 10             	add    $0x10,%esp
f0100a4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100a53:	e9 ab 00 00 00       	jmp    f0100b03 <mon_showmappings+0x184>
		pte_t *pte=pgdir_walk(kern_pgdir,(void *)begin,0);
		if(!pte||!(*pte&PTE_P)){
			cprintf("Virtual Address: %08x-not mapped\n",begin);
f0100a58:	83 ec 08             	sub    $0x8,%esp
f0100a5b:	53                   	push   %ebx
f0100a5c:	68 a0 6c 10 f0       	push   $0xf0106ca0
f0100a61:	e8 72 30 00 00       	call   f0103ad8 <cprintf>
f0100a66:	83 c4 10             	add    $0x10,%esp
	for(;begin<=end;begin+=PGSIZE){
f0100a69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100a6f:	39 fb                	cmp    %edi,%ebx
f0100a71:	0f 87 87 00 00 00    	ja     f0100afe <mon_showmappings+0x17f>
		pte_t *pte=pgdir_walk(kern_pgdir,(void *)begin,0);
f0100a77:	83 ec 04             	sub    $0x4,%esp
f0100a7a:	6a 00                	push   $0x0
f0100a7c:	53                   	push   %ebx
f0100a7d:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0100a83:	e8 8a 07 00 00       	call   f0101212 <pgdir_walk>
f0100a88:	89 c6                	mov    %eax,%esi
		if(!pte||!(*pte&PTE_P)){
f0100a8a:	83 c4 10             	add    $0x10,%esp
f0100a8d:	85 c0                	test   %eax,%eax
f0100a8f:	74 c7                	je     f0100a58 <mon_showmappings+0xd9>
f0100a91:	8b 00                	mov    (%eax),%eax
f0100a93:	a8 01                	test   $0x1,%al
f0100a95:	74 c1                	je     f0100a58 <mon_showmappings+0xd9>
		}
		else{
			cprintf("Virtual Address: %08x, Physical Address: %08x, ",
f0100a97:	83 ec 04             	sub    $0x4,%esp
f0100a9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100a9f:	50                   	push   %eax
f0100aa0:	53                   	push   %ebx
f0100aa1:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0100aa6:	e8 2d 30 00 00       	call   f0103ad8 <cprintf>
				begin,PTE_ADDR(*pte));
			char perm_ps=(*pte&PTE_PS)?'S':'-';
f0100aab:	8b 16                	mov    (%esi),%edx
f0100aad:	89 d0                	mov    %edx,%eax
f0100aaf:	25 80 00 00 00       	and    $0x80,%eax
f0100ab4:	83 c4 10             	add    $0x10,%esp
f0100ab7:	83 f8 01             	cmp    $0x1,%eax
f0100aba:	19 c0                	sbb    %eax,%eax
f0100abc:	83 e0 da             	and    $0xffffffda,%eax
f0100abf:	83 c0 53             	add    $0x53,%eax
			char perm_w=(*pte&PTE_W)?'W':'-';
f0100ac2:	89 d1                	mov    %edx,%ecx
f0100ac4:	83 e1 02             	and    $0x2,%ecx
f0100ac7:	83 f9 01             	cmp    $0x1,%ecx
f0100aca:	19 c9                	sbb    %ecx,%ecx
f0100acc:	83 e1 d6             	and    $0xffffffd6,%ecx
f0100acf:	83 c1 57             	add    $0x57,%ecx
			char perm_u=(*pte&PTE_U)?'U':'-';
f0100ad2:	83 e2 04             	and    $0x4,%edx
f0100ad5:	83 fa 01             	cmp    $0x1,%edx
f0100ad8:	19 d2                	sbb    %edx,%edx
f0100ada:	83 e2 d8             	and    $0xffffffd8,%edx
f0100add:	83 c2 55             	add    $0x55,%edx
			cprintf("permission: -%c----%c%cP\n", perm_ps,perm_u,perm_w);
f0100ae0:	0f be c9             	movsbl %cl,%ecx
f0100ae3:	51                   	push   %ecx
f0100ae4:	0f be d2             	movsbl %dl,%edx
f0100ae7:	52                   	push   %edx
f0100ae8:	0f be c0             	movsbl %al,%eax
f0100aeb:	50                   	push   %eax
f0100aec:	68 93 6a 10 f0       	push   $0xf0106a93
f0100af1:	e8 e2 2f 00 00       	call   f0103ad8 <cprintf>
f0100af6:	83 c4 10             	add    $0x10,%esp
f0100af9:	e9 6b ff ff ff       	jmp    f0100a69 <mon_showmappings+0xea>
			
		}
	}
	
	return 0;
f0100afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b06:	5b                   	pop    %ebx
f0100b07:	5e                   	pop    %esi
f0100b08:	5f                   	pop    %edi
f0100b09:	5d                   	pop    %ebp
f0100b0a:	c3                   	ret    

f0100b0b <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100b0b:	f3 0f 1e fb          	endbr32 
f0100b0f:	55                   	push   %ebp
f0100b10:	89 e5                	mov    %esp,%ebp
f0100b12:	57                   	push   %edi
f0100b13:	56                   	push   %esi
f0100b14:	53                   	push   %ebx
f0100b15:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100b18:	68 f4 6c 10 f0       	push   $0xf0106cf4
f0100b1d:	e8 b6 2f 00 00       	call   f0103ad8 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100b22:	c7 04 24 18 6d 10 f0 	movl   $0xf0106d18,(%esp)
f0100b29:	e8 aa 2f 00 00       	call   f0103ad8 <cprintf>

	if (tf != NULL)
f0100b2e:	83 c4 10             	add    $0x10,%esp
f0100b31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100b35:	0f 84 d9 00 00 00    	je     f0100c14 <monitor+0x109>
		print_trapframe(tf);
f0100b3b:	83 ec 0c             	sub    $0xc,%esp
f0100b3e:	ff 75 08             	pushl  0x8(%ebp)
f0100b41:	e8 4e 35 00 00       	call   f0104094 <print_trapframe>
f0100b46:	83 c4 10             	add    $0x10,%esp
f0100b49:	e9 c6 00 00 00       	jmp    f0100c14 <monitor+0x109>
		while (*buf && strchr(WHITESPACE, *buf))
f0100b4e:	83 ec 08             	sub    $0x8,%esp
f0100b51:	0f be c0             	movsbl %al,%eax
f0100b54:	50                   	push   %eax
f0100b55:	68 b1 6a 10 f0       	push   $0xf0106ab1
f0100b5a:	e8 37 4e 00 00       	call   f0105996 <strchr>
f0100b5f:	83 c4 10             	add    $0x10,%esp
f0100b62:	85 c0                	test   %eax,%eax
f0100b64:	74 63                	je     f0100bc9 <monitor+0xbe>
			*buf++ = 0;
f0100b66:	c6 03 00             	movb   $0x0,(%ebx)
f0100b69:	89 f7                	mov    %esi,%edi
f0100b6b:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100b6e:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100b70:	0f b6 03             	movzbl (%ebx),%eax
f0100b73:	84 c0                	test   %al,%al
f0100b75:	75 d7                	jne    f0100b4e <monitor+0x43>
	argv[argc] = 0;
f0100b77:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100b7e:	00 
	if (argc == 0)
f0100b7f:	85 f6                	test   %esi,%esi
f0100b81:	0f 84 8d 00 00 00    	je     f0100c14 <monitor+0x109>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100b87:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100b8c:	83 ec 08             	sub    $0x8,%esp
f0100b8f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100b92:	ff 34 85 40 6d 10 f0 	pushl  -0xfef92c0(,%eax,4)
f0100b99:	ff 75 a8             	pushl  -0x58(%ebp)
f0100b9c:	e8 8f 4d 00 00       	call   f0105930 <strcmp>
f0100ba1:	83 c4 10             	add    $0x10,%esp
f0100ba4:	85 c0                	test   %eax,%eax
f0100ba6:	0f 84 8f 00 00 00    	je     f0100c3b <monitor+0x130>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100bac:	83 c3 01             	add    $0x1,%ebx
f0100baf:	83 fb 04             	cmp    $0x4,%ebx
f0100bb2:	75 d8                	jne    f0100b8c <monitor+0x81>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100bb4:	83 ec 08             	sub    $0x8,%esp
f0100bb7:	ff 75 a8             	pushl  -0x58(%ebp)
f0100bba:	68 d3 6a 10 f0       	push   $0xf0106ad3
f0100bbf:	e8 14 2f 00 00       	call   f0103ad8 <cprintf>
	return 0;
f0100bc4:	83 c4 10             	add    $0x10,%esp
f0100bc7:	eb 4b                	jmp    f0100c14 <monitor+0x109>
		if (*buf == 0)
f0100bc9:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100bcc:	74 a9                	je     f0100b77 <monitor+0x6c>
		if (argc == MAXARGS-1) {
f0100bce:	83 fe 0f             	cmp    $0xf,%esi
f0100bd1:	74 2f                	je     f0100c02 <monitor+0xf7>
		argv[argc++] = buf;
f0100bd3:	8d 7e 01             	lea    0x1(%esi),%edi
f0100bd6:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100bda:	0f b6 03             	movzbl (%ebx),%eax
f0100bdd:	84 c0                	test   %al,%al
f0100bdf:	74 8d                	je     f0100b6e <monitor+0x63>
f0100be1:	83 ec 08             	sub    $0x8,%esp
f0100be4:	0f be c0             	movsbl %al,%eax
f0100be7:	50                   	push   %eax
f0100be8:	68 b1 6a 10 f0       	push   $0xf0106ab1
f0100bed:	e8 a4 4d 00 00       	call   f0105996 <strchr>
f0100bf2:	83 c4 10             	add    $0x10,%esp
f0100bf5:	85 c0                	test   %eax,%eax
f0100bf7:	0f 85 71 ff ff ff    	jne    f0100b6e <monitor+0x63>
			buf++;
f0100bfd:	83 c3 01             	add    $0x1,%ebx
f0100c00:	eb d8                	jmp    f0100bda <monitor+0xcf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100c02:	83 ec 08             	sub    $0x8,%esp
f0100c05:	6a 10                	push   $0x10
f0100c07:	68 b6 6a 10 f0       	push   $0xf0106ab6
f0100c0c:	e8 c7 2e 00 00       	call   f0103ad8 <cprintf>
			return 0;
f0100c11:	83 c4 10             	add    $0x10,%esp
	while (1) {
		buf = readline("K> ");
f0100c14:	83 ec 0c             	sub    $0xc,%esp
f0100c17:	68 ad 6a 10 f0       	push   $0xf0106aad
f0100c1c:	e8 1b 4b 00 00       	call   f010573c <readline>
f0100c21:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100c23:	83 c4 10             	add    $0x10,%esp
f0100c26:	85 c0                	test   %eax,%eax
f0100c28:	74 ea                	je     f0100c14 <monitor+0x109>
	argv[argc] = 0;
f0100c2a:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100c31:	be 00 00 00 00       	mov    $0x0,%esi
f0100c36:	e9 35 ff ff ff       	jmp    f0100b70 <monitor+0x65>
			return commands[i].func(argc, argv, tf);
f0100c3b:	83 ec 04             	sub    $0x4,%esp
f0100c3e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100c41:	ff 75 08             	pushl  0x8(%ebp)
f0100c44:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100c47:	52                   	push   %edx
f0100c48:	56                   	push   %esi
f0100c49:	ff 14 85 48 6d 10 f0 	call   *-0xfef92b8(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100c50:	83 c4 10             	add    $0x10,%esp
f0100c53:	85 c0                	test   %eax,%eax
f0100c55:	79 bd                	jns    f0100c14 <monitor+0x109>
				break;
	}
}
f0100c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c5a:	5b                   	pop    %ebx
f0100c5b:	5e                   	pop    %esi
f0100c5c:	5f                   	pop    %edi
f0100c5d:	5d                   	pop    %ebp
f0100c5e:	c3                   	ret    

f0100c5f <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100c5f:	55                   	push   %ebp
f0100c60:	89 e5                	mov    %esp,%ebp
f0100c62:	56                   	push   %esi
f0100c63:	53                   	push   %ebx
f0100c64:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100c66:	83 ec 0c             	sub    $0xc,%esp
f0100c69:	50                   	push   %eax
f0100c6a:	e8 c6 2c 00 00       	call   f0103935 <mc146818_read>
f0100c6f:	89 c6                	mov    %eax,%esi
f0100c71:	83 c3 01             	add    $0x1,%ebx
f0100c74:	89 1c 24             	mov    %ebx,(%esp)
f0100c77:	e8 b9 2c 00 00       	call   f0103935 <mc146818_read>
f0100c7c:	c1 e0 08             	shl    $0x8,%eax
f0100c7f:	09 f0                	or     %esi,%eax
}
f0100c81:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c84:	5b                   	pop    %ebx
f0100c85:	5e                   	pop    %esi
f0100c86:	5d                   	pop    %ebp
f0100c87:	c3                   	ret    

f0100c88 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100c88:	83 3d 38 72 21 f0 00 	cmpl   $0x0,0xf0217238
f0100c8f:	74 2c                	je     f0100cbd <boot_alloc+0x35>
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	
	result=nextfree;
f0100c91:	8b 0d 38 72 21 f0    	mov    0xf0217238,%ecx
	nextfree=ROUNDUP(nextfree+n,PGSIZE);
f0100c97:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f0100c9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ca3:	a3 38 72 21 f0       	mov    %eax,0xf0217238
	if((uint32_t)nextfree - KERNBASE > (npages*PGSIZE))//over kernel memory
f0100ca8:	05 00 00 00 10       	add    $0x10000000,%eax
f0100cad:	8b 15 88 7e 21 f0    	mov    0xf0217e88,%edx
f0100cb3:	c1 e2 0c             	shl    $0xc,%edx
f0100cb6:	39 d0                	cmp    %edx,%eax
f0100cb8:	77 16                	ja     f0100cd0 <boot_alloc+0x48>
		panic("boot_alloc:Out of memory!\n");
	
	//cprintf("boot_alloc memory at %x, next memory allocate at %x\n", result, nextfree);
	return result;
}
f0100cba:	89 c8                	mov    %ecx,%eax
f0100cbc:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100cbd:	ba 07 a0 25 f0       	mov    $0xf025a007,%edx
f0100cc2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100cc8:	89 15 38 72 21 f0    	mov    %edx,0xf0217238
f0100cce:	eb c1                	jmp    f0100c91 <boot_alloc+0x9>
{
f0100cd0:	55                   	push   %ebp
f0100cd1:	89 e5                	mov    %esp,%ebp
f0100cd3:	83 ec 0c             	sub    $0xc,%esp
		panic("boot_alloc:Out of memory!\n");
f0100cd6:	68 70 6d 10 f0       	push   $0xf0106d70
f0100cdb:	6a 72                	push   $0x72
f0100cdd:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100ce2:	e8 59 f3 ff ff       	call   f0100040 <_panic>

f0100ce7 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100ce7:	89 d1                	mov    %edx,%ecx
f0100ce9:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100cec:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100cef:	a8 01                	test   $0x1,%al
f0100cf1:	74 51                	je     f0100d44 <check_va2pa+0x5d>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100cf3:	89 c1                	mov    %eax,%ecx
f0100cf5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f0100cfb:	c1 e8 0c             	shr    $0xc,%eax
f0100cfe:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0100d04:	73 23                	jae    f0100d29 <check_va2pa+0x42>
	if (!(p[PTX(va)] & PTE_P))
f0100d06:	c1 ea 0c             	shr    $0xc,%edx
f0100d09:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100d0f:	8b 94 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100d16:	89 d0                	mov    %edx,%eax
f0100d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d1d:	f6 c2 01             	test   $0x1,%dl
f0100d20:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100d25:	0f 44 c2             	cmove  %edx,%eax
f0100d28:	c3                   	ret    
{
f0100d29:	55                   	push   %ebp
f0100d2a:	89 e5                	mov    %esp,%ebp
f0100d2c:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d2f:	51                   	push   %ecx
f0100d30:	68 a4 66 10 f0       	push   $0xf01066a4
f0100d35:	68 9c 03 00 00       	push   $0x39c
f0100d3a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100d3f:	e8 fc f2 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100d44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100d49:	c3                   	ret    

f0100d4a <check_page_free_list>:
{
f0100d4a:	55                   	push   %ebp
f0100d4b:	89 e5                	mov    %esp,%ebp
f0100d4d:	57                   	push   %edi
f0100d4e:	56                   	push   %esi
f0100d4f:	53                   	push   %ebx
f0100d50:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100d53:	84 c0                	test   %al,%al
f0100d55:	0f 85 77 02 00 00    	jne    f0100fd2 <check_page_free_list+0x288>
	if (!page_free_list)
f0100d5b:	83 3d 40 72 21 f0 00 	cmpl   $0x0,0xf0217240
f0100d62:	74 0a                	je     f0100d6e <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100d64:	be 00 04 00 00       	mov    $0x400,%esi
f0100d69:	e9 bf 02 00 00       	jmp    f010102d <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100d6e:	83 ec 04             	sub    $0x4,%esp
f0100d71:	68 bc 70 10 f0       	push   $0xf01070bc
f0100d76:	68 cf 02 00 00       	push   $0x2cf
f0100d7b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100d80:	e8 bb f2 ff ff       	call   f0100040 <_panic>
f0100d85:	50                   	push   %eax
f0100d86:	68 a4 66 10 f0       	push   $0xf01066a4
f0100d8b:	6a 58                	push   $0x58
f0100d8d:	68 97 6d 10 f0       	push   $0xf0106d97
f0100d92:	e8 a9 f2 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100d97:	8b 1b                	mov    (%ebx),%ebx
f0100d99:	85 db                	test   %ebx,%ebx
f0100d9b:	74 41                	je     f0100dde <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100d9d:	89 d8                	mov    %ebx,%eax
f0100d9f:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0100da5:	c1 f8 03             	sar    $0x3,%eax
f0100da8:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100dab:	89 c2                	mov    %eax,%edx
f0100dad:	c1 ea 16             	shr    $0x16,%edx
f0100db0:	39 f2                	cmp    %esi,%edx
f0100db2:	73 e3                	jae    f0100d97 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100db4:	89 c2                	mov    %eax,%edx
f0100db6:	c1 ea 0c             	shr    $0xc,%edx
f0100db9:	3b 15 88 7e 21 f0    	cmp    0xf0217e88,%edx
f0100dbf:	73 c4                	jae    f0100d85 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100dc1:	83 ec 04             	sub    $0x4,%esp
f0100dc4:	68 80 00 00 00       	push   $0x80
f0100dc9:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100dce:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100dd3:	50                   	push   %eax
f0100dd4:	e8 02 4c 00 00       	call   f01059db <memset>
f0100dd9:	83 c4 10             	add    $0x10,%esp
f0100ddc:	eb b9                	jmp    f0100d97 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100dde:	b8 00 00 00 00       	mov    $0x0,%eax
f0100de3:	e8 a0 fe ff ff       	call   f0100c88 <boot_alloc>
f0100de8:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100deb:	8b 15 40 72 21 f0    	mov    0xf0217240,%edx
		assert(pp >= pages);
f0100df1:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
		assert(pp < pages + npages);
f0100df7:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f0100dfc:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100dff:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100e02:	bf 00 00 00 00       	mov    $0x0,%edi
f0100e07:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e0a:	e9 f9 00 00 00       	jmp    f0100f08 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100e0f:	68 a5 6d 10 f0       	push   $0xf0106da5
f0100e14:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100e19:	68 e9 02 00 00       	push   $0x2e9
f0100e1e:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100e23:	e8 18 f2 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100e28:	68 c6 6d 10 f0       	push   $0xf0106dc6
f0100e2d:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100e32:	68 ea 02 00 00       	push   $0x2ea
f0100e37:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100e3c:	e8 ff f1 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100e41:	68 e0 70 10 f0       	push   $0xf01070e0
f0100e46:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100e4b:	68 eb 02 00 00       	push   $0x2eb
f0100e50:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100e55:	e8 e6 f1 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100e5a:	68 da 6d 10 f0       	push   $0xf0106dda
f0100e5f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100e64:	68 ee 02 00 00       	push   $0x2ee
f0100e69:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100e6e:	e8 cd f1 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100e73:	68 eb 6d 10 f0       	push   $0xf0106deb
f0100e78:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100e7d:	68 ef 02 00 00       	push   $0x2ef
f0100e82:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100e87:	e8 b4 f1 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100e8c:	68 14 71 10 f0       	push   $0xf0107114
f0100e91:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100e96:	68 f0 02 00 00       	push   $0x2f0
f0100e9b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100ea0:	e8 9b f1 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100ea5:	68 04 6e 10 f0       	push   $0xf0106e04
f0100eaa:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100eaf:	68 f1 02 00 00       	push   $0x2f1
f0100eb4:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100eb9:	e8 82 f1 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100ebe:	89 c3                	mov    %eax,%ebx
f0100ec0:	c1 eb 0c             	shr    $0xc,%ebx
f0100ec3:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100ec6:	76 0f                	jbe    f0100ed7 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100ec8:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ecd:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100ed0:	77 17                	ja     f0100ee9 <check_page_free_list+0x19f>
			++nfree_extmem;
f0100ed2:	83 c7 01             	add    $0x1,%edi
f0100ed5:	eb 2f                	jmp    f0100f06 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ed7:	50                   	push   %eax
f0100ed8:	68 a4 66 10 f0       	push   $0xf01066a4
f0100edd:	6a 58                	push   $0x58
f0100edf:	68 97 6d 10 f0       	push   $0xf0106d97
f0100ee4:	e8 57 f1 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ee9:	68 38 71 10 f0       	push   $0xf0107138
f0100eee:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100ef3:	68 f2 02 00 00       	push   $0x2f2
f0100ef8:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100efd:	e8 3e f1 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100f02:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f06:	8b 12                	mov    (%edx),%edx
f0100f08:	85 d2                	test   %edx,%edx
f0100f0a:	74 74                	je     f0100f80 <check_page_free_list+0x236>
		assert(pp >= pages);
f0100f0c:	39 d1                	cmp    %edx,%ecx
f0100f0e:	0f 87 fb fe ff ff    	ja     f0100e0f <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100f14:	39 d6                	cmp    %edx,%esi
f0100f16:	0f 86 0c ff ff ff    	jbe    f0100e28 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100f1c:	89 d0                	mov    %edx,%eax
f0100f1e:	29 c8                	sub    %ecx,%eax
f0100f20:	a8 07                	test   $0x7,%al
f0100f22:	0f 85 19 ff ff ff    	jne    f0100e41 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100f28:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100f2b:	c1 e0 0c             	shl    $0xc,%eax
f0100f2e:	0f 84 26 ff ff ff    	je     f0100e5a <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100f34:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100f39:	0f 84 34 ff ff ff    	je     f0100e73 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100f3f:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100f44:	0f 84 42 ff ff ff    	je     f0100e8c <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100f4a:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100f4f:	0f 84 50 ff ff ff    	je     f0100ea5 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100f55:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100f5a:	0f 87 5e ff ff ff    	ja     f0100ebe <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100f60:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100f65:	75 9b                	jne    f0100f02 <check_page_free_list+0x1b8>
f0100f67:	68 1e 6e 10 f0       	push   $0xf0106e1e
f0100f6c:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100f71:	68 f4 02 00 00       	push   $0x2f4
f0100f76:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100f7b:	e8 c0 f0 ff ff       	call   f0100040 <_panic>
f0100f80:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100f83:	85 db                	test   %ebx,%ebx
f0100f85:	7e 19                	jle    f0100fa0 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100f87:	85 ff                	test   %edi,%edi
f0100f89:	7e 2e                	jle    f0100fb9 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100f8b:	83 ec 0c             	sub    $0xc,%esp
f0100f8e:	68 80 71 10 f0       	push   $0xf0107180
f0100f93:	e8 40 2b 00 00       	call   f0103ad8 <cprintf>
}
f0100f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f9b:	5b                   	pop    %ebx
f0100f9c:	5e                   	pop    %esi
f0100f9d:	5f                   	pop    %edi
f0100f9e:	5d                   	pop    %ebp
f0100f9f:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100fa0:	68 3b 6e 10 f0       	push   $0xf0106e3b
f0100fa5:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100faa:	68 fc 02 00 00       	push   $0x2fc
f0100faf:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100fb4:	e8 87 f0 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100fb9:	68 4d 6e 10 f0       	push   $0xf0106e4d
f0100fbe:	68 b1 6d 10 f0       	push   $0xf0106db1
f0100fc3:	68 fd 02 00 00       	push   $0x2fd
f0100fc8:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0100fcd:	e8 6e f0 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100fd2:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0100fd7:	85 c0                	test   %eax,%eax
f0100fd9:	0f 84 8f fd ff ff    	je     f0100d6e <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100fdf:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100fe2:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100fe5:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100fe8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100feb:	89 c2                	mov    %eax,%edx
f0100fed:	2b 15 90 7e 21 f0    	sub    0xf0217e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100ff3:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100ff9:	0f 95 c2             	setne  %dl
f0100ffc:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100fff:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0101003:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0101005:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101009:	8b 00                	mov    (%eax),%eax
f010100b:	85 c0                	test   %eax,%eax
f010100d:	75 dc                	jne    f0100feb <check_page_free_list+0x2a1>
		*tp[1] = 0;
f010100f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101012:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101018:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010101b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010101e:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0101020:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101023:	a3 40 72 21 f0       	mov    %eax,0xf0217240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101028:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010102d:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
f0101033:	e9 61 fd ff ff       	jmp    f0100d99 <check_page_free_list+0x4f>

f0101038 <page_init>:
{
f0101038:	f3 0f 1e fb          	endbr32 
f010103c:	55                   	push   %ebp
f010103d:	89 e5                	mov    %esp,%ebp
f010103f:	57                   	push   %edi
f0101040:	56                   	push   %esi
f0101041:	53                   	push   %ebx
f0101042:	83 ec 0c             	sub    $0xc,%esp
	size_t num_alloc=((uint32_t)boot_alloc(0)-KERNBASE)/PGSIZE;
f0101045:	b8 00 00 00 00       	mov    $0x0,%eax
f010104a:	e8 39 fc ff ff       	call   f0100c88 <boot_alloc>
	size_t page_in_use_end=npages_basemem+num_hole+num_alloc;
f010104f:	8b 15 44 72 21 f0    	mov    0xf0217244,%edx
	size_t num_alloc=((uint32_t)boot_alloc(0)-KERNBASE)/PGSIZE;
f0101055:	05 00 00 00 10       	add    $0x10000000,%eax
f010105a:	c1 e8 0c             	shr    $0xc,%eax
	size_t page_in_use_end=npages_basemem+num_hole+num_alloc;
f010105d:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
	pages[0].pp_ref=1;//page 0 is in use
f0101061:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
f0101067:	66 c7 41 04 01 00    	movw   $0x1,0x4(%ecx)
f010106d:	8b 3d 40 72 21 f0    	mov    0xf0217240,%edi
	for(i=1;i<npages_basemem;i++){
f0101073:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101078:	b9 01 00 00 00       	mov    $0x1,%ecx
f010107d:	eb 0f                	jmp    f010108e <page_init+0x56>
			pages[i].pp_ref=1;
f010107f:	8b 35 90 7e 21 f0    	mov    0xf0217e90,%esi
f0101085:	66 c7 46 3c 01 00    	movw   $0x1,0x3c(%esi)
	for(i=1;i<npages_basemem;i++){
f010108b:	83 c1 01             	add    $0x1,%ecx
f010108e:	39 ca                	cmp    %ecx,%edx
f0101090:	76 2b                	jbe    f01010bd <page_init+0x85>
		if(i==MPENTRY_PADDR/PGSIZE){
f0101092:	83 f9 07             	cmp    $0x7,%ecx
f0101095:	74 e8                	je     f010107f <page_init+0x47>
f0101097:	8d 1c cd 00 00 00 00 	lea    0x0(,%ecx,8),%ebx
		pages[i].pp_ref=0;
f010109e:	89 de                	mov    %ebx,%esi
f01010a0:	03 35 90 7e 21 f0    	add    0xf0217e90,%esi
f01010a6:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)
		pages[i].pp_link=page_free_list;
f01010ac:	89 3e                	mov    %edi,(%esi)
		page_free_list=&pages[i];
f01010ae:	89 df                	mov    %ebx,%edi
f01010b0:	03 3d 90 7e 21 f0    	add    0xf0217e90,%edi
f01010b6:	bb 01 00 00 00       	mov    $0x1,%ebx
f01010bb:	eb ce                	jmp    f010108b <page_init+0x53>
f01010bd:	84 db                	test   %bl,%bl
f01010bf:	74 06                	je     f01010c7 <page_init+0x8f>
f01010c1:	89 3d 40 72 21 f0    	mov    %edi,0xf0217240
		pages[i].pp_ref=1;
f01010c7:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
	for(i=npages_basemem;i<page_in_use_end;i++){
f01010cd:	39 c2                	cmp    %eax,%edx
f01010cf:	73 0c                	jae    f01010dd <page_init+0xa5>
		pages[i].pp_ref=1;
f01010d1:	66 c7 44 d1 04 01 00 	movw   $0x1,0x4(%ecx,%edx,8)
	for(i=npages_basemem;i<page_in_use_end;i++){
f01010d8:	83 c2 01             	add    $0x1,%edx
f01010db:	eb f0                	jmp    f01010cd <page_init+0x95>
f01010dd:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
f01010e3:	ba 00 00 00 00       	mov    $0x0,%edx
	for(i=page_in_use_end;i<npages;i++){
f01010e8:	be 01 00 00 00       	mov    $0x1,%esi
f01010ed:	eb 24                	jmp    f0101113 <page_init+0xdb>
f01010ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref=0;
f01010f6:	89 d1                	mov    %edx,%ecx
f01010f8:	03 0d 90 7e 21 f0    	add    0xf0217e90,%ecx
f01010fe:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link=page_free_list;
f0101104:	89 19                	mov    %ebx,(%ecx)
		page_free_list=&pages[i];
f0101106:	89 d3                	mov    %edx,%ebx
f0101108:	03 1d 90 7e 21 f0    	add    0xf0217e90,%ebx
	for(i=page_in_use_end;i<npages;i++){
f010110e:	83 c0 01             	add    $0x1,%eax
f0101111:	89 f2                	mov    %esi,%edx
f0101113:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f0101119:	77 d4                	ja     f01010ef <page_init+0xb7>
f010111b:	84 d2                	test   %dl,%dl
f010111d:	74 06                	je     f0101125 <page_init+0xed>
f010111f:	89 1d 40 72 21 f0    	mov    %ebx,0xf0217240
}
f0101125:	83 c4 0c             	add    $0xc,%esp
f0101128:	5b                   	pop    %ebx
f0101129:	5e                   	pop    %esi
f010112a:	5f                   	pop    %edi
f010112b:	5d                   	pop    %ebp
f010112c:	c3                   	ret    

f010112d <page_alloc>:
{
f010112d:	f3 0f 1e fb          	endbr32 
f0101131:	55                   	push   %ebp
f0101132:	89 e5                	mov    %esp,%ebp
f0101134:	53                   	push   %ebx
f0101135:	83 ec 04             	sub    $0x4,%esp
	if(page_free_list==NULL)
f0101138:	8b 1d 40 72 21 f0    	mov    0xf0217240,%ebx
f010113e:	85 db                	test   %ebx,%ebx
f0101140:	74 13                	je     f0101155 <page_alloc+0x28>
	page_free_list=result->pp_link;
f0101142:	8b 03                	mov    (%ebx),%eax
f0101144:	a3 40 72 21 f0       	mov    %eax,0xf0217240
	result->pp_link=NULL;
f0101149:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags&ALLOC_ZERO)
f010114f:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0101153:	75 07                	jne    f010115c <page_alloc+0x2f>
}
f0101155:	89 d8                	mov    %ebx,%eax
f0101157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010115a:	c9                   	leave  
f010115b:	c3                   	ret    
f010115c:	89 d8                	mov    %ebx,%eax
f010115e:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101164:	c1 f8 03             	sar    $0x3,%eax
f0101167:	89 c2                	mov    %eax,%edx
f0101169:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010116c:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101171:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0101177:	73 1b                	jae    f0101194 <page_alloc+0x67>
		memset(page2kva(result),0,PGSIZE);
f0101179:	83 ec 04             	sub    $0x4,%esp
f010117c:	68 00 10 00 00       	push   $0x1000
f0101181:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0101183:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101189:	52                   	push   %edx
f010118a:	e8 4c 48 00 00       	call   f01059db <memset>
f010118f:	83 c4 10             	add    $0x10,%esp
f0101192:	eb c1                	jmp    f0101155 <page_alloc+0x28>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101194:	52                   	push   %edx
f0101195:	68 a4 66 10 f0       	push   $0xf01066a4
f010119a:	6a 58                	push   $0x58
f010119c:	68 97 6d 10 f0       	push   $0xf0106d97
f01011a1:	e8 9a ee ff ff       	call   f0100040 <_panic>

f01011a6 <page_free>:
{
f01011a6:	f3 0f 1e fb          	endbr32 
f01011aa:	55                   	push   %ebp
f01011ab:	89 e5                	mov    %esp,%ebp
f01011ad:	83 ec 08             	sub    $0x8,%esp
f01011b0:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref||pp->pp_link)
f01011b3:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01011b8:	75 14                	jne    f01011ce <page_free+0x28>
f01011ba:	83 38 00             	cmpl   $0x0,(%eax)
f01011bd:	75 0f                	jne    f01011ce <page_free+0x28>
	pp->pp_link=page_free_list;
f01011bf:	8b 15 40 72 21 f0    	mov    0xf0217240,%edx
f01011c5:	89 10                	mov    %edx,(%eax)
	page_free_list=pp;
f01011c7:	a3 40 72 21 f0       	mov    %eax,0xf0217240
}
f01011cc:	c9                   	leave  
f01011cd:	c3                   	ret    
		panic("page_free:Illegal PageInfo!");
f01011ce:	83 ec 04             	sub    $0x4,%esp
f01011d1:	68 5e 6e 10 f0       	push   $0xf0106e5e
f01011d6:	68 95 01 00 00       	push   $0x195
f01011db:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01011e0:	e8 5b ee ff ff       	call   f0100040 <_panic>

f01011e5 <page_decref>:
{
f01011e5:	f3 0f 1e fb          	endbr32 
f01011e9:	55                   	push   %ebp
f01011ea:	89 e5                	mov    %esp,%ebp
f01011ec:	83 ec 08             	sub    $0x8,%esp
f01011ef:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01011f2:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01011f6:	83 e8 01             	sub    $0x1,%eax
f01011f9:	66 89 42 04          	mov    %ax,0x4(%edx)
f01011fd:	66 85 c0             	test   %ax,%ax
f0101200:	74 02                	je     f0101204 <page_decref+0x1f>
}
f0101202:	c9                   	leave  
f0101203:	c3                   	ret    
		page_free(pp);
f0101204:	83 ec 0c             	sub    $0xc,%esp
f0101207:	52                   	push   %edx
f0101208:	e8 99 ff ff ff       	call   f01011a6 <page_free>
f010120d:	83 c4 10             	add    $0x10,%esp
}
f0101210:	eb f0                	jmp    f0101202 <page_decref+0x1d>

f0101212 <pgdir_walk>:
{
f0101212:	f3 0f 1e fb          	endbr32 
f0101216:	55                   	push   %ebp
f0101217:	89 e5                	mov    %esp,%ebp
f0101219:	56                   	push   %esi
f010121a:	53                   	push   %ebx
f010121b:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *pgdir_entry=pgdir+PDX(va);//PDX(va)-Page Derectory Index
f010121e:	89 f3                	mov    %esi,%ebx
f0101220:	c1 eb 16             	shr    $0x16,%ebx
f0101223:	c1 e3 02             	shl    $0x2,%ebx
f0101226:	03 5d 08             	add    0x8(%ebp),%ebx
	if(!(*pgdir_entry&PTE_P)){//PTE_P=0x001 //this page is not existed.
f0101229:	f6 03 01             	testb  $0x1,(%ebx)
f010122c:	75 2d                	jne    f010125b <pgdir_walk+0x49>
		if(!create){
f010122e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101232:	74 68                	je     f010129c <pgdir_walk+0x8a>
			new_page=page_alloc(1);
f0101234:	83 ec 0c             	sub    $0xc,%esp
f0101237:	6a 01                	push   $0x1
f0101239:	e8 ef fe ff ff       	call   f010112d <page_alloc>
			if(new_page==NULL)
f010123e:	83 c4 10             	add    $0x10,%esp
f0101241:	85 c0                	test   %eax,%eax
f0101243:	74 3b                	je     f0101280 <pgdir_walk+0x6e>
			new_page->pp_ref +=1;
f0101245:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010124a:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101250:	c1 f8 03             	sar    $0x3,%eax
f0101253:	c1 e0 0c             	shl    $0xc,%eax
			*pgdir_entry = (page2pa(new_page) | PTE_P | PTE_W | PTE_U);
f0101256:	83 c8 07             	or     $0x7,%eax
f0101259:	89 03                	mov    %eax,(%ebx)
	return (pte_t *)(KADDR(PTE_ADDR(*pgdir_entry))) + PTX(va);
f010125b:	8b 03                	mov    (%ebx),%eax
f010125d:	89 c2                	mov    %eax,%edx
f010125f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101265:	c1 e8 0c             	shr    $0xc,%eax
f0101268:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f010126e:	73 17                	jae    f0101287 <pgdir_walk+0x75>
f0101270:	c1 ee 0a             	shr    $0xa,%esi
f0101273:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101279:	8d 84 32 00 00 00 f0 	lea    -0x10000000(%edx,%esi,1),%eax
}
f0101280:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101283:	5b                   	pop    %ebx
f0101284:	5e                   	pop    %esi
f0101285:	5d                   	pop    %ebp
f0101286:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101287:	52                   	push   %edx
f0101288:	68 a4 66 10 f0       	push   $0xf01066a4
f010128d:	68 d2 01 00 00       	push   $0x1d2
f0101292:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101297:	e8 a4 ed ff ff       	call   f0100040 <_panic>
			return NULL;
f010129c:	b8 00 00 00 00       	mov    $0x0,%eax
f01012a1:	eb dd                	jmp    f0101280 <pgdir_walk+0x6e>

f01012a3 <boot_map_region>:
{
f01012a3:	55                   	push   %ebp
f01012a4:	89 e5                	mov    %esp,%ebp
f01012a6:	57                   	push   %edi
f01012a7:	56                   	push   %esi
f01012a8:	53                   	push   %ebx
f01012a9:	83 ec 1c             	sub    $0x1c,%esp
f01012ac:	89 c7                	mov    %eax,%edi
f01012ae:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01012b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	for(offset=0;offset<size;offset+=PGSIZE){
f01012b4:	be 00 00 00 00       	mov    $0x0,%esi
f01012b9:	89 f3                	mov    %esi,%ebx
f01012bb:	03 5d 08             	add    0x8(%ebp),%ebx
f01012be:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f01012c1:	73 24                	jae    f01012e7 <boot_map_region+0x44>
		pg_table_entry=pgdir_walk(pgdir,(void *)va,1);
f01012c3:	83 ec 04             	sub    $0x4,%esp
f01012c6:	6a 01                	push   $0x1
f01012c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01012cb:	01 f0                	add    %esi,%eax
f01012cd:	50                   	push   %eax
f01012ce:	57                   	push   %edi
f01012cf:	e8 3e ff ff ff       	call   f0101212 <pgdir_walk>
		*pg_table_entry=pa|perm|PTE_P;
f01012d4:	0b 5d 0c             	or     0xc(%ebp),%ebx
f01012d7:	83 cb 01             	or     $0x1,%ebx
f01012da:	89 18                	mov    %ebx,(%eax)
	for(offset=0;offset<size;offset+=PGSIZE){
f01012dc:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01012e2:	83 c4 10             	add    $0x10,%esp
f01012e5:	eb d2                	jmp    f01012b9 <boot_map_region+0x16>
}
f01012e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01012ea:	5b                   	pop    %ebx
f01012eb:	5e                   	pop    %esi
f01012ec:	5f                   	pop    %edi
f01012ed:	5d                   	pop    %ebp
f01012ee:	c3                   	ret    

f01012ef <page_lookup>:
{
f01012ef:	f3 0f 1e fb          	endbr32 
f01012f3:	55                   	push   %ebp
f01012f4:	89 e5                	mov    %esp,%ebp
f01012f6:	53                   	push   %ebx
f01012f7:	83 ec 08             	sub    $0x8,%esp
f01012fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pg_table_entry=pgdir_walk(pgdir,va,0);
f01012fd:	6a 00                	push   $0x0
f01012ff:	ff 75 0c             	pushl  0xc(%ebp)
f0101302:	ff 75 08             	pushl  0x8(%ebp)
f0101305:	e8 08 ff ff ff       	call   f0101212 <pgdir_walk>
	if(pg_table_entry==NULL||!(*pg_table_entry & PTE_P))
f010130a:	83 c4 10             	add    $0x10,%esp
f010130d:	85 c0                	test   %eax,%eax
f010130f:	74 21                	je     f0101332 <page_lookup+0x43>
f0101311:	f6 00 01             	testb  $0x1,(%eax)
f0101314:	74 35                	je     f010134b <page_lookup+0x5c>
	if(pte_store)
f0101316:	85 db                	test   %ebx,%ebx
f0101318:	74 02                	je     f010131c <page_lookup+0x2d>
		*pte_store=pg_table_entry;
f010131a:	89 03                	mov    %eax,(%ebx)
f010131c:	8b 00                	mov    (%eax),%eax
f010131e:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101321:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f0101327:	76 0e                	jbe    f0101337 <page_lookup+0x48>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101329:	8b 15 90 7e 21 f0    	mov    0xf0217e90,%edx
f010132f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101335:	c9                   	leave  
f0101336:	c3                   	ret    
		panic("pa2page called with invalid pa");
f0101337:	83 ec 04             	sub    $0x4,%esp
f010133a:	68 a4 71 10 f0       	push   $0xf01071a4
f010133f:	6a 51                	push   $0x51
f0101341:	68 97 6d 10 f0       	push   $0xf0106d97
f0101346:	e8 f5 ec ff ff       	call   f0100040 <_panic>
		return NULL;
f010134b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101350:	eb e0                	jmp    f0101332 <page_lookup+0x43>

f0101352 <tlb_invalidate>:
{
f0101352:	f3 0f 1e fb          	endbr32 
f0101356:	55                   	push   %ebp
f0101357:	89 e5                	mov    %esp,%ebp
f0101359:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f010135c:	e8 99 4c 00 00       	call   f0105ffa <cpunum>
f0101361:	6b c0 74             	imul   $0x74,%eax,%eax
f0101364:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f010136b:	74 16                	je     f0101383 <tlb_invalidate+0x31>
f010136d:	e8 88 4c 00 00       	call   f0105ffa <cpunum>
f0101372:	6b c0 74             	imul   $0x74,%eax,%eax
f0101375:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010137b:	8b 55 08             	mov    0x8(%ebp),%edx
f010137e:	39 50 60             	cmp    %edx,0x60(%eax)
f0101381:	75 06                	jne    f0101389 <tlb_invalidate+0x37>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101383:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101386:	0f 01 38             	invlpg (%eax)
}
f0101389:	c9                   	leave  
f010138a:	c3                   	ret    

f010138b <page_remove>:
{
f010138b:	f3 0f 1e fb          	endbr32 
f010138f:	55                   	push   %ebp
f0101390:	89 e5                	mov    %esp,%ebp
f0101392:	56                   	push   %esi
f0101393:	53                   	push   %ebx
f0101394:	83 ec 14             	sub    $0x14,%esp
f0101397:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010139a:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *page=page_lookup(pgdir,va,&pte);
f010139d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01013a0:	50                   	push   %eax
f01013a1:	56                   	push   %esi
f01013a2:	53                   	push   %ebx
f01013a3:	e8 47 ff ff ff       	call   f01012ef <page_lookup>
	if(page==NULL)
f01013a8:	83 c4 10             	add    $0x10,%esp
f01013ab:	85 c0                	test   %eax,%eax
f01013ad:	74 1f                	je     f01013ce <page_remove+0x43>
	page_decref(page);
f01013af:	83 ec 0c             	sub    $0xc,%esp
f01013b2:	50                   	push   %eax
f01013b3:	e8 2d fe ff ff       	call   f01011e5 <page_decref>
	tlb_invalidate(pgdir,va);
f01013b8:	83 c4 08             	add    $0x8,%esp
f01013bb:	56                   	push   %esi
f01013bc:	53                   	push   %ebx
f01013bd:	e8 90 ff ff ff       	call   f0101352 <tlb_invalidate>
	*pte=0;
f01013c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01013c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01013cb:	83 c4 10             	add    $0x10,%esp
}
f01013ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01013d1:	5b                   	pop    %ebx
f01013d2:	5e                   	pop    %esi
f01013d3:	5d                   	pop    %ebp
f01013d4:	c3                   	ret    

f01013d5 <page_insert>:
{
f01013d5:	f3 0f 1e fb          	endbr32 
f01013d9:	55                   	push   %ebp
f01013da:	89 e5                	mov    %esp,%ebp
f01013dc:	57                   	push   %edi
f01013dd:	56                   	push   %esi
f01013de:	53                   	push   %ebx
f01013df:	83 ec 10             	sub    $0x10,%esp
f01013e2:	8b 7d 08             	mov    0x8(%ebp),%edi
f01013e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *pg_table_entry=pgdir_walk(pgdir,va,1);
f01013e8:	6a 01                	push   $0x1
f01013ea:	ff 75 10             	pushl  0x10(%ebp)
f01013ed:	57                   	push   %edi
f01013ee:	e8 1f fe ff ff       	call   f0101212 <pgdir_walk>
	if(pg_table_entry==NULL)
f01013f3:	83 c4 10             	add    $0x10,%esp
f01013f6:	85 c0                	test   %eax,%eax
f01013f8:	74 4a                	je     f0101444 <page_insert+0x6f>
f01013fa:	89 c6                	mov    %eax,%esi
	pp->pp_ref++;//sequence is important!
f01013fc:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	if((*pg_table_entry)&PTE_P){
f0101401:	f6 00 01             	testb  $0x1,(%eax)
f0101404:	75 2d                	jne    f0101433 <page_insert+0x5e>
	return (pp - pages) << PGSHIFT;
f0101406:	2b 1d 90 7e 21 f0    	sub    0xf0217e90,%ebx
f010140c:	c1 fb 03             	sar    $0x3,%ebx
f010140f:	c1 e3 0c             	shl    $0xc,%ebx
	*pg_table_entry=page2pa(pp)|perm|PTE_P;
f0101412:	0b 5d 14             	or     0x14(%ebp),%ebx
f0101415:	83 cb 01             	or     $0x1,%ebx
f0101418:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)]|=perm;
f010141a:	8b 45 10             	mov    0x10(%ebp),%eax
f010141d:	c1 e8 16             	shr    $0x16,%eax
f0101420:	8b 55 14             	mov    0x14(%ebp),%edx
f0101423:	09 14 87             	or     %edx,(%edi,%eax,4)
	return 0;
f0101426:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010142b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010142e:	5b                   	pop    %ebx
f010142f:	5e                   	pop    %esi
f0101430:	5f                   	pop    %edi
f0101431:	5d                   	pop    %ebp
f0101432:	c3                   	ret    
		page_remove(pgdir,va);	
f0101433:	83 ec 08             	sub    $0x8,%esp
f0101436:	ff 75 10             	pushl  0x10(%ebp)
f0101439:	57                   	push   %edi
f010143a:	e8 4c ff ff ff       	call   f010138b <page_remove>
f010143f:	83 c4 10             	add    $0x10,%esp
f0101442:	eb c2                	jmp    f0101406 <page_insert+0x31>
		return -E_NO_MEM;//no memory
f0101444:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101449:	eb e0                	jmp    f010142b <page_insert+0x56>

f010144b <mmio_map_region>:
{
f010144b:	f3 0f 1e fb          	endbr32 
f010144f:	55                   	push   %ebp
f0101450:	89 e5                	mov    %esp,%ebp
f0101452:	53                   	push   %ebx
f0101453:	83 ec 04             	sub    $0x4,%esp
	if(base+ROUNDUP(size,PGSIZE)>MMIOLIM)
f0101456:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101459:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010145f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101465:	8b 15 00 33 12 f0    	mov    0xf0123300,%edx
f010146b:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f010146e:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101473:	77 26                	ja     f010149b <mmio_map_region+0x50>
	boot_map_region(kern_pgdir,base,ROUNDUP(size,PGSIZE),pa,PTE_PCD|PTE_PWT|PTE_W);
f0101475:	83 ec 08             	sub    $0x8,%esp
f0101478:	6a 1a                	push   $0x1a
f010147a:	ff 75 08             	pushl  0x8(%ebp)
f010147d:	89 d9                	mov    %ebx,%ecx
f010147f:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101484:	e8 1a fe ff ff       	call   f01012a3 <boot_map_region>
	uintptr_t temp=base;
f0101489:	a1 00 33 12 f0       	mov    0xf0123300,%eax
	base+=ROUNDUP(size,PGSIZE);
f010148e:	01 c3                	add    %eax,%ebx
f0101490:	89 1d 00 33 12 f0    	mov    %ebx,0xf0123300
}
f0101496:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101499:	c9                   	leave  
f010149a:	c3                   	ret    
		panic("mmio_map_region:MMIO Overflow!");
f010149b:	83 ec 04             	sub    $0x4,%esp
f010149e:	68 c4 71 10 f0       	push   $0xf01071c4
f01014a3:	68 7c 02 00 00       	push   $0x27c
f01014a8:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01014ad:	e8 8e eb ff ff       	call   f0100040 <_panic>

f01014b2 <mem_init>:
{
f01014b2:	f3 0f 1e fb          	endbr32 
f01014b6:	55                   	push   %ebp
f01014b7:	89 e5                	mov    %esp,%ebp
f01014b9:	57                   	push   %edi
f01014ba:	56                   	push   %esi
f01014bb:	53                   	push   %ebx
f01014bc:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01014bf:	b8 15 00 00 00       	mov    $0x15,%eax
f01014c4:	e8 96 f7 ff ff       	call   f0100c5f <nvram_read>
f01014c9:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f01014cb:	b8 17 00 00 00       	mov    $0x17,%eax
f01014d0:	e8 8a f7 ff ff       	call   f0100c5f <nvram_read>
f01014d5:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01014d7:	b8 34 00 00 00       	mov    $0x34,%eax
f01014dc:	e8 7e f7 ff ff       	call   f0100c5f <nvram_read>
	if (ext16mem)
f01014e1:	c1 e0 06             	shl    $0x6,%eax
f01014e4:	0f 84 ea 00 00 00    	je     f01015d4 <mem_init+0x122>
		totalmem = 16 * 1024 + ext16mem;
f01014ea:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f01014ef:	89 c2                	mov    %eax,%edx
f01014f1:	c1 ea 02             	shr    $0x2,%edx
f01014f4:	89 15 88 7e 21 f0    	mov    %edx,0xf0217e88
	npages_basemem = basemem / (PGSIZE / 1024);
f01014fa:	89 da                	mov    %ebx,%edx
f01014fc:	c1 ea 02             	shr    $0x2,%edx
f01014ff:	89 15 44 72 21 f0    	mov    %edx,0xf0217244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101505:	89 c2                	mov    %eax,%edx
f0101507:	29 da                	sub    %ebx,%edx
f0101509:	52                   	push   %edx
f010150a:	53                   	push   %ebx
f010150b:	50                   	push   %eax
f010150c:	68 e4 71 10 f0       	push   $0xf01071e4
f0101511:	e8 c2 25 00 00       	call   f0103ad8 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101516:	b8 00 10 00 00       	mov    $0x1000,%eax
f010151b:	e8 68 f7 ff ff       	call   f0100c88 <boot_alloc>
f0101520:	a3 8c 7e 21 f0       	mov    %eax,0xf0217e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101525:	83 c4 0c             	add    $0xc,%esp
f0101528:	68 00 10 00 00       	push   $0x1000
f010152d:	6a 00                	push   $0x0
f010152f:	50                   	push   %eax
f0101530:	e8 a6 44 00 00       	call   f01059db <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101535:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010153a:	83 c4 10             	add    $0x10,%esp
f010153d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101542:	0f 86 9c 00 00 00    	jbe    f01015e4 <mem_init+0x132>
	return (physaddr_t)kva - KERNBASE;
f0101548:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010154e:	83 ca 05             	or     $0x5,%edx
f0101551:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages=(struct PageInfo *)boot_alloc(npages*sizeof(struct PageInfo));
f0101557:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f010155c:	c1 e0 03             	shl    $0x3,%eax
f010155f:	e8 24 f7 ff ff       	call   f0100c88 <boot_alloc>
f0101564:	a3 90 7e 21 f0       	mov    %eax,0xf0217e90
	memset(pages,0,npages*sizeof(struct PageInfo));
f0101569:	83 ec 04             	sub    $0x4,%esp
f010156c:	8b 0d 88 7e 21 f0    	mov    0xf0217e88,%ecx
f0101572:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101579:	52                   	push   %edx
f010157a:	6a 00                	push   $0x0
f010157c:	50                   	push   %eax
f010157d:	e8 59 44 00 00       	call   f01059db <memset>
	envs=(struct Env*)boot_alloc(NENV*sizeof(struct Env));
f0101582:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101587:	e8 fc f6 ff ff       	call   f0100c88 <boot_alloc>
f010158c:	a3 48 72 21 f0       	mov    %eax,0xf0217248
	memset(envs,0,NENV*sizeof(struct Env));
f0101591:	83 c4 0c             	add    $0xc,%esp
f0101594:	68 00 f0 01 00       	push   $0x1f000
f0101599:	6a 00                	push   $0x0
f010159b:	50                   	push   %eax
f010159c:	e8 3a 44 00 00       	call   f01059db <memset>
	page_init();
f01015a1:	e8 92 fa ff ff       	call   f0101038 <page_init>
	check_page_free_list(1);
f01015a6:	b8 01 00 00 00       	mov    $0x1,%eax
f01015ab:	e8 9a f7 ff ff       	call   f0100d4a <check_page_free_list>
	if (!pages)
f01015b0:	83 c4 10             	add    $0x10,%esp
f01015b3:	83 3d 90 7e 21 f0 00 	cmpl   $0x0,0xf0217e90
f01015ba:	74 3d                	je     f01015f9 <mem_init+0x147>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01015bc:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f01015c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f01015c8:	85 c0                	test   %eax,%eax
f01015ca:	74 44                	je     f0101610 <mem_init+0x15e>
		++nfree;
f01015cc:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01015d0:	8b 00                	mov    (%eax),%eax
f01015d2:	eb f4                	jmp    f01015c8 <mem_init+0x116>
		totalmem = 1 * 1024 + extmem;
f01015d4:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01015da:	85 f6                	test   %esi,%esi
f01015dc:	0f 44 c3             	cmove  %ebx,%eax
f01015df:	e9 0b ff ff ff       	jmp    f01014ef <mem_init+0x3d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01015e4:	50                   	push   %eax
f01015e5:	68 c8 66 10 f0       	push   $0xf01066c8
f01015ea:	68 99 00 00 00       	push   $0x99
f01015ef:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01015f4:	e8 47 ea ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f01015f9:	83 ec 04             	sub    $0x4,%esp
f01015fc:	68 7a 6e 10 f0       	push   $0xf0106e7a
f0101601:	68 10 03 00 00       	push   $0x310
f0101606:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010160b:	e8 30 ea ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101610:	83 ec 0c             	sub    $0xc,%esp
f0101613:	6a 00                	push   $0x0
f0101615:	e8 13 fb ff ff       	call   f010112d <page_alloc>
f010161a:	89 c3                	mov    %eax,%ebx
f010161c:	83 c4 10             	add    $0x10,%esp
f010161f:	85 c0                	test   %eax,%eax
f0101621:	0f 84 11 02 00 00    	je     f0101838 <mem_init+0x386>
	assert((pp1 = page_alloc(0)));
f0101627:	83 ec 0c             	sub    $0xc,%esp
f010162a:	6a 00                	push   $0x0
f010162c:	e8 fc fa ff ff       	call   f010112d <page_alloc>
f0101631:	89 c6                	mov    %eax,%esi
f0101633:	83 c4 10             	add    $0x10,%esp
f0101636:	85 c0                	test   %eax,%eax
f0101638:	0f 84 13 02 00 00    	je     f0101851 <mem_init+0x39f>
	assert((pp2 = page_alloc(0)));
f010163e:	83 ec 0c             	sub    $0xc,%esp
f0101641:	6a 00                	push   $0x0
f0101643:	e8 e5 fa ff ff       	call   f010112d <page_alloc>
f0101648:	89 c7                	mov    %eax,%edi
f010164a:	83 c4 10             	add    $0x10,%esp
f010164d:	85 c0                	test   %eax,%eax
f010164f:	0f 84 15 02 00 00    	je     f010186a <mem_init+0x3b8>
	assert(pp1 && pp1 != pp0);
f0101655:	39 f3                	cmp    %esi,%ebx
f0101657:	0f 84 26 02 00 00    	je     f0101883 <mem_init+0x3d1>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010165d:	39 c6                	cmp    %eax,%esi
f010165f:	0f 84 37 02 00 00    	je     f010189c <mem_init+0x3ea>
f0101665:	39 c3                	cmp    %eax,%ebx
f0101667:	0f 84 2f 02 00 00    	je     f010189c <mem_init+0x3ea>
	return (pp - pages) << PGSHIFT;
f010166d:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101673:	8b 15 88 7e 21 f0    	mov    0xf0217e88,%edx
f0101679:	c1 e2 0c             	shl    $0xc,%edx
f010167c:	89 d8                	mov    %ebx,%eax
f010167e:	29 c8                	sub    %ecx,%eax
f0101680:	c1 f8 03             	sar    $0x3,%eax
f0101683:	c1 e0 0c             	shl    $0xc,%eax
f0101686:	39 d0                	cmp    %edx,%eax
f0101688:	0f 83 27 02 00 00    	jae    f01018b5 <mem_init+0x403>
f010168e:	89 f0                	mov    %esi,%eax
f0101690:	29 c8                	sub    %ecx,%eax
f0101692:	c1 f8 03             	sar    $0x3,%eax
f0101695:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101698:	39 c2                	cmp    %eax,%edx
f010169a:	0f 86 2e 02 00 00    	jbe    f01018ce <mem_init+0x41c>
f01016a0:	89 f8                	mov    %edi,%eax
f01016a2:	29 c8                	sub    %ecx,%eax
f01016a4:	c1 f8 03             	sar    $0x3,%eax
f01016a7:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f01016aa:	39 c2                	cmp    %eax,%edx
f01016ac:	0f 86 35 02 00 00    	jbe    f01018e7 <mem_init+0x435>
	fl = page_free_list;
f01016b2:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f01016b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01016ba:	c7 05 40 72 21 f0 00 	movl   $0x0,0xf0217240
f01016c1:	00 00 00 
	assert(!page_alloc(0));
f01016c4:	83 ec 0c             	sub    $0xc,%esp
f01016c7:	6a 00                	push   $0x0
f01016c9:	e8 5f fa ff ff       	call   f010112d <page_alloc>
f01016ce:	83 c4 10             	add    $0x10,%esp
f01016d1:	85 c0                	test   %eax,%eax
f01016d3:	0f 85 27 02 00 00    	jne    f0101900 <mem_init+0x44e>
	page_free(pp0);
f01016d9:	83 ec 0c             	sub    $0xc,%esp
f01016dc:	53                   	push   %ebx
f01016dd:	e8 c4 fa ff ff       	call   f01011a6 <page_free>
	page_free(pp1);
f01016e2:	89 34 24             	mov    %esi,(%esp)
f01016e5:	e8 bc fa ff ff       	call   f01011a6 <page_free>
	page_free(pp2);
f01016ea:	89 3c 24             	mov    %edi,(%esp)
f01016ed:	e8 b4 fa ff ff       	call   f01011a6 <page_free>
	assert((pp0 = page_alloc(0)));
f01016f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01016f9:	e8 2f fa ff ff       	call   f010112d <page_alloc>
f01016fe:	89 c3                	mov    %eax,%ebx
f0101700:	83 c4 10             	add    $0x10,%esp
f0101703:	85 c0                	test   %eax,%eax
f0101705:	0f 84 0e 02 00 00    	je     f0101919 <mem_init+0x467>
	assert((pp1 = page_alloc(0)));
f010170b:	83 ec 0c             	sub    $0xc,%esp
f010170e:	6a 00                	push   $0x0
f0101710:	e8 18 fa ff ff       	call   f010112d <page_alloc>
f0101715:	89 c6                	mov    %eax,%esi
f0101717:	83 c4 10             	add    $0x10,%esp
f010171a:	85 c0                	test   %eax,%eax
f010171c:	0f 84 10 02 00 00    	je     f0101932 <mem_init+0x480>
	assert((pp2 = page_alloc(0)));
f0101722:	83 ec 0c             	sub    $0xc,%esp
f0101725:	6a 00                	push   $0x0
f0101727:	e8 01 fa ff ff       	call   f010112d <page_alloc>
f010172c:	89 c7                	mov    %eax,%edi
f010172e:	83 c4 10             	add    $0x10,%esp
f0101731:	85 c0                	test   %eax,%eax
f0101733:	0f 84 12 02 00 00    	je     f010194b <mem_init+0x499>
	assert(pp1 && pp1 != pp0);
f0101739:	39 f3                	cmp    %esi,%ebx
f010173b:	0f 84 23 02 00 00    	je     f0101964 <mem_init+0x4b2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101741:	39 c3                	cmp    %eax,%ebx
f0101743:	0f 84 34 02 00 00    	je     f010197d <mem_init+0x4cb>
f0101749:	39 c6                	cmp    %eax,%esi
f010174b:	0f 84 2c 02 00 00    	je     f010197d <mem_init+0x4cb>
	assert(!page_alloc(0));
f0101751:	83 ec 0c             	sub    $0xc,%esp
f0101754:	6a 00                	push   $0x0
f0101756:	e8 d2 f9 ff ff       	call   f010112d <page_alloc>
f010175b:	83 c4 10             	add    $0x10,%esp
f010175e:	85 c0                	test   %eax,%eax
f0101760:	0f 85 30 02 00 00    	jne    f0101996 <mem_init+0x4e4>
f0101766:	89 d8                	mov    %ebx,%eax
f0101768:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f010176e:	c1 f8 03             	sar    $0x3,%eax
f0101771:	89 c2                	mov    %eax,%edx
f0101773:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101776:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010177b:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0101781:	0f 83 28 02 00 00    	jae    f01019af <mem_init+0x4fd>
	memset(page2kva(pp0), 1, PGSIZE);
f0101787:	83 ec 04             	sub    $0x4,%esp
f010178a:	68 00 10 00 00       	push   $0x1000
f010178f:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101791:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101797:	52                   	push   %edx
f0101798:	e8 3e 42 00 00       	call   f01059db <memset>
	page_free(pp0);
f010179d:	89 1c 24             	mov    %ebx,(%esp)
f01017a0:	e8 01 fa ff ff       	call   f01011a6 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01017a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01017ac:	e8 7c f9 ff ff       	call   f010112d <page_alloc>
f01017b1:	83 c4 10             	add    $0x10,%esp
f01017b4:	85 c0                	test   %eax,%eax
f01017b6:	0f 84 05 02 00 00    	je     f01019c1 <mem_init+0x50f>
	assert(pp && pp0 == pp);
f01017bc:	39 c3                	cmp    %eax,%ebx
f01017be:	0f 85 16 02 00 00    	jne    f01019da <mem_init+0x528>
	return (pp - pages) << PGSHIFT;
f01017c4:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f01017ca:	c1 f8 03             	sar    $0x3,%eax
f01017cd:	89 c2                	mov    %eax,%edx
f01017cf:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f01017d2:	25 ff ff 0f 00       	and    $0xfffff,%eax
f01017d7:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f01017dd:	0f 83 10 02 00 00    	jae    f01019f3 <mem_init+0x541>
	return (void *)(pa + KERNBASE);
f01017e3:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f01017e9:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f01017ef:	80 38 00             	cmpb   $0x0,(%eax)
f01017f2:	0f 85 0d 02 00 00    	jne    f0101a05 <mem_init+0x553>
f01017f8:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f01017fb:	39 d0                	cmp    %edx,%eax
f01017fd:	75 f0                	jne    f01017ef <mem_init+0x33d>
	page_free_list = fl;
f01017ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101802:	a3 40 72 21 f0       	mov    %eax,0xf0217240
	page_free(pp0);
f0101807:	83 ec 0c             	sub    $0xc,%esp
f010180a:	53                   	push   %ebx
f010180b:	e8 96 f9 ff ff       	call   f01011a6 <page_free>
	page_free(pp1);
f0101810:	89 34 24             	mov    %esi,(%esp)
f0101813:	e8 8e f9 ff ff       	call   f01011a6 <page_free>
	page_free(pp2);
f0101818:	89 3c 24             	mov    %edi,(%esp)
f010181b:	e8 86 f9 ff ff       	call   f01011a6 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101820:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0101825:	83 c4 10             	add    $0x10,%esp
f0101828:	85 c0                	test   %eax,%eax
f010182a:	0f 84 ee 01 00 00    	je     f0101a1e <mem_init+0x56c>
		--nfree;
f0101830:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101834:	8b 00                	mov    (%eax),%eax
f0101836:	eb f0                	jmp    f0101828 <mem_init+0x376>
	assert((pp0 = page_alloc(0)));
f0101838:	68 95 6e 10 f0       	push   $0xf0106e95
f010183d:	68 b1 6d 10 f0       	push   $0xf0106db1
f0101842:	68 18 03 00 00       	push   $0x318
f0101847:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010184c:	e8 ef e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101851:	68 ab 6e 10 f0       	push   $0xf0106eab
f0101856:	68 b1 6d 10 f0       	push   $0xf0106db1
f010185b:	68 19 03 00 00       	push   $0x319
f0101860:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101865:	e8 d6 e7 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010186a:	68 c1 6e 10 f0       	push   $0xf0106ec1
f010186f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0101874:	68 1a 03 00 00       	push   $0x31a
f0101879:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010187e:	e8 bd e7 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101883:	68 d7 6e 10 f0       	push   $0xf0106ed7
f0101888:	68 b1 6d 10 f0       	push   $0xf0106db1
f010188d:	68 1d 03 00 00       	push   $0x31d
f0101892:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101897:	e8 a4 e7 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010189c:	68 20 72 10 f0       	push   $0xf0107220
f01018a1:	68 b1 6d 10 f0       	push   $0xf0106db1
f01018a6:	68 1e 03 00 00       	push   $0x31e
f01018ab:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01018b0:	e8 8b e7 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f01018b5:	68 e9 6e 10 f0       	push   $0xf0106ee9
f01018ba:	68 b1 6d 10 f0       	push   $0xf0106db1
f01018bf:	68 1f 03 00 00       	push   $0x31f
f01018c4:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01018c9:	e8 72 e7 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f01018ce:	68 06 6f 10 f0       	push   $0xf0106f06
f01018d3:	68 b1 6d 10 f0       	push   $0xf0106db1
f01018d8:	68 20 03 00 00       	push   $0x320
f01018dd:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01018e2:	e8 59 e7 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f01018e7:	68 23 6f 10 f0       	push   $0xf0106f23
f01018ec:	68 b1 6d 10 f0       	push   $0xf0106db1
f01018f1:	68 21 03 00 00       	push   $0x321
f01018f6:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01018fb:	e8 40 e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101900:	68 40 6f 10 f0       	push   $0xf0106f40
f0101905:	68 b1 6d 10 f0       	push   $0xf0106db1
f010190a:	68 28 03 00 00       	push   $0x328
f010190f:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101914:	e8 27 e7 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0101919:	68 95 6e 10 f0       	push   $0xf0106e95
f010191e:	68 b1 6d 10 f0       	push   $0xf0106db1
f0101923:	68 2f 03 00 00       	push   $0x32f
f0101928:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010192d:	e8 0e e7 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101932:	68 ab 6e 10 f0       	push   $0xf0106eab
f0101937:	68 b1 6d 10 f0       	push   $0xf0106db1
f010193c:	68 30 03 00 00       	push   $0x330
f0101941:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101946:	e8 f5 e6 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010194b:	68 c1 6e 10 f0       	push   $0xf0106ec1
f0101950:	68 b1 6d 10 f0       	push   $0xf0106db1
f0101955:	68 31 03 00 00       	push   $0x331
f010195a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010195f:	e8 dc e6 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101964:	68 d7 6e 10 f0       	push   $0xf0106ed7
f0101969:	68 b1 6d 10 f0       	push   $0xf0106db1
f010196e:	68 33 03 00 00       	push   $0x333
f0101973:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101978:	e8 c3 e6 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010197d:	68 20 72 10 f0       	push   $0xf0107220
f0101982:	68 b1 6d 10 f0       	push   $0xf0106db1
f0101987:	68 34 03 00 00       	push   $0x334
f010198c:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101991:	e8 aa e6 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101996:	68 40 6f 10 f0       	push   $0xf0106f40
f010199b:	68 b1 6d 10 f0       	push   $0xf0106db1
f01019a0:	68 35 03 00 00       	push   $0x335
f01019a5:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01019aa:	e8 91 e6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01019af:	52                   	push   %edx
f01019b0:	68 a4 66 10 f0       	push   $0xf01066a4
f01019b5:	6a 58                	push   $0x58
f01019b7:	68 97 6d 10 f0       	push   $0xf0106d97
f01019bc:	e8 7f e6 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01019c1:	68 4f 6f 10 f0       	push   $0xf0106f4f
f01019c6:	68 b1 6d 10 f0       	push   $0xf0106db1
f01019cb:	68 3a 03 00 00       	push   $0x33a
f01019d0:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01019d5:	e8 66 e6 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f01019da:	68 6d 6f 10 f0       	push   $0xf0106f6d
f01019df:	68 b1 6d 10 f0       	push   $0xf0106db1
f01019e4:	68 3b 03 00 00       	push   $0x33b
f01019e9:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01019ee:	e8 4d e6 ff ff       	call   f0100040 <_panic>
f01019f3:	52                   	push   %edx
f01019f4:	68 a4 66 10 f0       	push   $0xf01066a4
f01019f9:	6a 58                	push   $0x58
f01019fb:	68 97 6d 10 f0       	push   $0xf0106d97
f0101a00:	e8 3b e6 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f0101a05:	68 7d 6f 10 f0       	push   $0xf0106f7d
f0101a0a:	68 b1 6d 10 f0       	push   $0xf0106db1
f0101a0f:	68 3e 03 00 00       	push   $0x33e
f0101a14:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0101a19:	e8 22 e6 ff ff       	call   f0100040 <_panic>
	assert(nfree == 0);
f0101a1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101a22:	0f 85 43 09 00 00    	jne    f010236b <mem_init+0xeb9>
	cprintf("check_page_alloc() succeeded!\n");
f0101a28:	83 ec 0c             	sub    $0xc,%esp
f0101a2b:	68 40 72 10 f0       	push   $0xf0107240
f0101a30:	e8 a3 20 00 00       	call   f0103ad8 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101a35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a3c:	e8 ec f6 ff ff       	call   f010112d <page_alloc>
f0101a41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101a44:	83 c4 10             	add    $0x10,%esp
f0101a47:	85 c0                	test   %eax,%eax
f0101a49:	0f 84 35 09 00 00    	je     f0102384 <mem_init+0xed2>
	assert((pp1 = page_alloc(0)));
f0101a4f:	83 ec 0c             	sub    $0xc,%esp
f0101a52:	6a 00                	push   $0x0
f0101a54:	e8 d4 f6 ff ff       	call   f010112d <page_alloc>
f0101a59:	89 c7                	mov    %eax,%edi
f0101a5b:	83 c4 10             	add    $0x10,%esp
f0101a5e:	85 c0                	test   %eax,%eax
f0101a60:	0f 84 37 09 00 00    	je     f010239d <mem_init+0xeeb>
	assert((pp2 = page_alloc(0)));
f0101a66:	83 ec 0c             	sub    $0xc,%esp
f0101a69:	6a 00                	push   $0x0
f0101a6b:	e8 bd f6 ff ff       	call   f010112d <page_alloc>
f0101a70:	89 c3                	mov    %eax,%ebx
f0101a72:	83 c4 10             	add    $0x10,%esp
f0101a75:	85 c0                	test   %eax,%eax
f0101a77:	0f 84 39 09 00 00    	je     f01023b6 <mem_init+0xf04>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101a7d:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f0101a80:	0f 84 49 09 00 00    	je     f01023cf <mem_init+0xf1d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a86:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101a89:	0f 84 59 09 00 00    	je     f01023e8 <mem_init+0xf36>
f0101a8f:	39 c7                	cmp    %eax,%edi
f0101a91:	0f 84 51 09 00 00    	je     f01023e8 <mem_init+0xf36>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101a97:	a1 40 72 21 f0       	mov    0xf0217240,%eax
f0101a9c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101a9f:	c7 05 40 72 21 f0 00 	movl   $0x0,0xf0217240
f0101aa6:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101aa9:	83 ec 0c             	sub    $0xc,%esp
f0101aac:	6a 00                	push   $0x0
f0101aae:	e8 7a f6 ff ff       	call   f010112d <page_alloc>
f0101ab3:	83 c4 10             	add    $0x10,%esp
f0101ab6:	85 c0                	test   %eax,%eax
f0101ab8:	0f 85 43 09 00 00    	jne    f0102401 <mem_init+0xf4f>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101abe:	83 ec 04             	sub    $0x4,%esp
f0101ac1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101ac4:	50                   	push   %eax
f0101ac5:	6a 00                	push   $0x0
f0101ac7:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101acd:	e8 1d f8 ff ff       	call   f01012ef <page_lookup>
f0101ad2:	83 c4 10             	add    $0x10,%esp
f0101ad5:	85 c0                	test   %eax,%eax
f0101ad7:	0f 85 3d 09 00 00    	jne    f010241a <mem_init+0xf68>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101add:	6a 02                	push   $0x2
f0101adf:	6a 00                	push   $0x0
f0101ae1:	57                   	push   %edi
f0101ae2:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101ae8:	e8 e8 f8 ff ff       	call   f01013d5 <page_insert>
f0101aed:	83 c4 10             	add    $0x10,%esp
f0101af0:	85 c0                	test   %eax,%eax
f0101af2:	0f 89 3b 09 00 00    	jns    f0102433 <mem_init+0xf81>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101af8:	83 ec 0c             	sub    $0xc,%esp
f0101afb:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101afe:	e8 a3 f6 ff ff       	call   f01011a6 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101b03:	6a 02                	push   $0x2
f0101b05:	6a 00                	push   $0x0
f0101b07:	57                   	push   %edi
f0101b08:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101b0e:	e8 c2 f8 ff ff       	call   f01013d5 <page_insert>
f0101b13:	83 c4 20             	add    $0x20,%esp
f0101b16:	85 c0                	test   %eax,%eax
f0101b18:	0f 85 2e 09 00 00    	jne    f010244c <mem_init+0xf9a>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101b1e:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
	return (pp - pages) << PGSHIFT;
f0101b24:	8b 0d 90 7e 21 f0    	mov    0xf0217e90,%ecx
f0101b2a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101b2d:	8b 16                	mov    (%esi),%edx
f0101b2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101b35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b38:	29 c8                	sub    %ecx,%eax
f0101b3a:	c1 f8 03             	sar    $0x3,%eax
f0101b3d:	c1 e0 0c             	shl    $0xc,%eax
f0101b40:	39 c2                	cmp    %eax,%edx
f0101b42:	0f 85 1d 09 00 00    	jne    f0102465 <mem_init+0xfb3>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101b48:	ba 00 00 00 00       	mov    $0x0,%edx
f0101b4d:	89 f0                	mov    %esi,%eax
f0101b4f:	e8 93 f1 ff ff       	call   f0100ce7 <check_va2pa>
f0101b54:	89 c2                	mov    %eax,%edx
f0101b56:	89 f8                	mov    %edi,%eax
f0101b58:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0101b5b:	c1 f8 03             	sar    $0x3,%eax
f0101b5e:	c1 e0 0c             	shl    $0xc,%eax
f0101b61:	39 c2                	cmp    %eax,%edx
f0101b63:	0f 85 15 09 00 00    	jne    f010247e <mem_init+0xfcc>
	assert(pp1->pp_ref == 1);
f0101b69:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101b6e:	0f 85 23 09 00 00    	jne    f0102497 <mem_init+0xfe5>
	assert(pp0->pp_ref == 1);
f0101b74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b77:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101b7c:	0f 85 2e 09 00 00    	jne    f01024b0 <mem_init+0xffe>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101b82:	6a 02                	push   $0x2
f0101b84:	68 00 10 00 00       	push   $0x1000
f0101b89:	53                   	push   %ebx
f0101b8a:	56                   	push   %esi
f0101b8b:	e8 45 f8 ff ff       	call   f01013d5 <page_insert>
f0101b90:	83 c4 10             	add    $0x10,%esp
f0101b93:	85 c0                	test   %eax,%eax
f0101b95:	0f 85 2e 09 00 00    	jne    f01024c9 <mem_init+0x1017>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b9b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ba0:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101ba5:	e8 3d f1 ff ff       	call   f0100ce7 <check_va2pa>
f0101baa:	89 c2                	mov    %eax,%edx
f0101bac:	89 d8                	mov    %ebx,%eax
f0101bae:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101bb4:	c1 f8 03             	sar    $0x3,%eax
f0101bb7:	c1 e0 0c             	shl    $0xc,%eax
f0101bba:	39 c2                	cmp    %eax,%edx
f0101bbc:	0f 85 20 09 00 00    	jne    f01024e2 <mem_init+0x1030>
	assert(pp2->pp_ref == 1);
f0101bc2:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101bc7:	0f 85 2e 09 00 00    	jne    f01024fb <mem_init+0x1049>

	// should be no free memory
	assert(!page_alloc(0));
f0101bcd:	83 ec 0c             	sub    $0xc,%esp
f0101bd0:	6a 00                	push   $0x0
f0101bd2:	e8 56 f5 ff ff       	call   f010112d <page_alloc>
f0101bd7:	83 c4 10             	add    $0x10,%esp
f0101bda:	85 c0                	test   %eax,%eax
f0101bdc:	0f 85 32 09 00 00    	jne    f0102514 <mem_init+0x1062>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101be2:	6a 02                	push   $0x2
f0101be4:	68 00 10 00 00       	push   $0x1000
f0101be9:	53                   	push   %ebx
f0101bea:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101bf0:	e8 e0 f7 ff ff       	call   f01013d5 <page_insert>
f0101bf5:	83 c4 10             	add    $0x10,%esp
f0101bf8:	85 c0                	test   %eax,%eax
f0101bfa:	0f 85 2d 09 00 00    	jne    f010252d <mem_init+0x107b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101c00:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c05:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101c0a:	e8 d8 f0 ff ff       	call   f0100ce7 <check_va2pa>
f0101c0f:	89 c2                	mov    %eax,%edx
f0101c11:	89 d8                	mov    %ebx,%eax
f0101c13:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101c19:	c1 f8 03             	sar    $0x3,%eax
f0101c1c:	c1 e0 0c             	shl    $0xc,%eax
f0101c1f:	39 c2                	cmp    %eax,%edx
f0101c21:	0f 85 1f 09 00 00    	jne    f0102546 <mem_init+0x1094>
	assert(pp2->pp_ref == 1);
f0101c27:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c2c:	0f 85 2d 09 00 00    	jne    f010255f <mem_init+0x10ad>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101c32:	83 ec 0c             	sub    $0xc,%esp
f0101c35:	6a 00                	push   $0x0
f0101c37:	e8 f1 f4 ff ff       	call   f010112d <page_alloc>
f0101c3c:	83 c4 10             	add    $0x10,%esp
f0101c3f:	85 c0                	test   %eax,%eax
f0101c41:	0f 85 31 09 00 00    	jne    f0102578 <mem_init+0x10c6>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101c47:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0101c4d:	8b 01                	mov    (%ecx),%eax
f0101c4f:	89 c2                	mov    %eax,%edx
f0101c51:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101c57:	c1 e8 0c             	shr    $0xc,%eax
f0101c5a:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0101c60:	0f 83 2b 09 00 00    	jae    f0102591 <mem_init+0x10df>
	return (void *)(pa + KERNBASE);
f0101c66:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101c6c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101c6f:	83 ec 04             	sub    $0x4,%esp
f0101c72:	6a 00                	push   $0x0
f0101c74:	68 00 10 00 00       	push   $0x1000
f0101c79:	51                   	push   %ecx
f0101c7a:	e8 93 f5 ff ff       	call   f0101212 <pgdir_walk>
f0101c7f:	89 c2                	mov    %eax,%edx
f0101c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101c84:	83 c0 04             	add    $0x4,%eax
f0101c87:	83 c4 10             	add    $0x10,%esp
f0101c8a:	39 d0                	cmp    %edx,%eax
f0101c8c:	0f 85 14 09 00 00    	jne    f01025a6 <mem_init+0x10f4>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101c92:	6a 06                	push   $0x6
f0101c94:	68 00 10 00 00       	push   $0x1000
f0101c99:	53                   	push   %ebx
f0101c9a:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101ca0:	e8 30 f7 ff ff       	call   f01013d5 <page_insert>
f0101ca5:	83 c4 10             	add    $0x10,%esp
f0101ca8:	85 c0                	test   %eax,%eax
f0101caa:	0f 85 0f 09 00 00    	jne    f01025bf <mem_init+0x110d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101cb0:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
f0101cb6:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101cbb:	89 f0                	mov    %esi,%eax
f0101cbd:	e8 25 f0 ff ff       	call   f0100ce7 <check_va2pa>
f0101cc2:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101cc4:	89 d8                	mov    %ebx,%eax
f0101cc6:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101ccc:	c1 f8 03             	sar    $0x3,%eax
f0101ccf:	c1 e0 0c             	shl    $0xc,%eax
f0101cd2:	39 c2                	cmp    %eax,%edx
f0101cd4:	0f 85 fe 08 00 00    	jne    f01025d8 <mem_init+0x1126>
	assert(pp2->pp_ref == 1);
f0101cda:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101cdf:	0f 85 0c 09 00 00    	jne    f01025f1 <mem_init+0x113f>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101ce5:	83 ec 04             	sub    $0x4,%esp
f0101ce8:	6a 00                	push   $0x0
f0101cea:	68 00 10 00 00       	push   $0x1000
f0101cef:	56                   	push   %esi
f0101cf0:	e8 1d f5 ff ff       	call   f0101212 <pgdir_walk>
f0101cf5:	83 c4 10             	add    $0x10,%esp
f0101cf8:	f6 00 04             	testb  $0x4,(%eax)
f0101cfb:	0f 84 09 09 00 00    	je     f010260a <mem_init+0x1158>
	assert(kern_pgdir[0] & PTE_U);
f0101d01:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101d06:	f6 00 04             	testb  $0x4,(%eax)
f0101d09:	0f 84 14 09 00 00    	je     f0102623 <mem_init+0x1171>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101d0f:	6a 02                	push   $0x2
f0101d11:	68 00 10 00 00       	push   $0x1000
f0101d16:	53                   	push   %ebx
f0101d17:	50                   	push   %eax
f0101d18:	e8 b8 f6 ff ff       	call   f01013d5 <page_insert>
f0101d1d:	83 c4 10             	add    $0x10,%esp
f0101d20:	85 c0                	test   %eax,%eax
f0101d22:	0f 85 14 09 00 00    	jne    f010263c <mem_init+0x118a>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101d28:	83 ec 04             	sub    $0x4,%esp
f0101d2b:	6a 00                	push   $0x0
f0101d2d:	68 00 10 00 00       	push   $0x1000
f0101d32:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101d38:	e8 d5 f4 ff ff       	call   f0101212 <pgdir_walk>
f0101d3d:	83 c4 10             	add    $0x10,%esp
f0101d40:	f6 00 02             	testb  $0x2,(%eax)
f0101d43:	0f 84 0c 09 00 00    	je     f0102655 <mem_init+0x11a3>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101d49:	83 ec 04             	sub    $0x4,%esp
f0101d4c:	6a 00                	push   $0x0
f0101d4e:	68 00 10 00 00       	push   $0x1000
f0101d53:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101d59:	e8 b4 f4 ff ff       	call   f0101212 <pgdir_walk>
f0101d5e:	83 c4 10             	add    $0x10,%esp
f0101d61:	f6 00 04             	testb  $0x4,(%eax)
f0101d64:	0f 85 04 09 00 00    	jne    f010266e <mem_init+0x11bc>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101d6a:	6a 02                	push   $0x2
f0101d6c:	68 00 00 40 00       	push   $0x400000
f0101d71:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101d74:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101d7a:	e8 56 f6 ff ff       	call   f01013d5 <page_insert>
f0101d7f:	83 c4 10             	add    $0x10,%esp
f0101d82:	85 c0                	test   %eax,%eax
f0101d84:	0f 89 fd 08 00 00    	jns    f0102687 <mem_init+0x11d5>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101d8a:	6a 02                	push   $0x2
f0101d8c:	68 00 10 00 00       	push   $0x1000
f0101d91:	57                   	push   %edi
f0101d92:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101d98:	e8 38 f6 ff ff       	call   f01013d5 <page_insert>
f0101d9d:	83 c4 10             	add    $0x10,%esp
f0101da0:	85 c0                	test   %eax,%eax
f0101da2:	0f 85 f8 08 00 00    	jne    f01026a0 <mem_init+0x11ee>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101da8:	83 ec 04             	sub    $0x4,%esp
f0101dab:	6a 00                	push   $0x0
f0101dad:	68 00 10 00 00       	push   $0x1000
f0101db2:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101db8:	e8 55 f4 ff ff       	call   f0101212 <pgdir_walk>
f0101dbd:	83 c4 10             	add    $0x10,%esp
f0101dc0:	f6 00 04             	testb  $0x4,(%eax)
f0101dc3:	0f 85 f0 08 00 00    	jne    f01026b9 <mem_init+0x1207>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101dc9:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0101dce:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101dd1:	ba 00 00 00 00       	mov    $0x0,%edx
f0101dd6:	e8 0c ef ff ff       	call   f0100ce7 <check_va2pa>
f0101ddb:	89 fe                	mov    %edi,%esi
f0101ddd:	2b 35 90 7e 21 f0    	sub    0xf0217e90,%esi
f0101de3:	c1 fe 03             	sar    $0x3,%esi
f0101de6:	c1 e6 0c             	shl    $0xc,%esi
f0101de9:	39 f0                	cmp    %esi,%eax
f0101deb:	0f 85 e1 08 00 00    	jne    f01026d2 <mem_init+0x1220>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101df1:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101df6:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101df9:	e8 e9 ee ff ff       	call   f0100ce7 <check_va2pa>
f0101dfe:	39 c6                	cmp    %eax,%esi
f0101e00:	0f 85 e5 08 00 00    	jne    f01026eb <mem_init+0x1239>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101e06:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101e0b:	0f 85 f3 08 00 00    	jne    f0102704 <mem_init+0x1252>
	assert(pp2->pp_ref == 0);
f0101e11:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e16:	0f 85 01 09 00 00    	jne    f010271d <mem_init+0x126b>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101e1c:	83 ec 0c             	sub    $0xc,%esp
f0101e1f:	6a 00                	push   $0x0
f0101e21:	e8 07 f3 ff ff       	call   f010112d <page_alloc>
f0101e26:	83 c4 10             	add    $0x10,%esp
f0101e29:	85 c0                	test   %eax,%eax
f0101e2b:	0f 84 05 09 00 00    	je     f0102736 <mem_init+0x1284>
f0101e31:	39 c3                	cmp    %eax,%ebx
f0101e33:	0f 85 fd 08 00 00    	jne    f0102736 <mem_init+0x1284>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101e39:	83 ec 08             	sub    $0x8,%esp
f0101e3c:	6a 00                	push   $0x0
f0101e3e:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101e44:	e8 42 f5 ff ff       	call   f010138b <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101e49:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
f0101e4f:	ba 00 00 00 00       	mov    $0x0,%edx
f0101e54:	89 f0                	mov    %esi,%eax
f0101e56:	e8 8c ee ff ff       	call   f0100ce7 <check_va2pa>
f0101e5b:	83 c4 10             	add    $0x10,%esp
f0101e5e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101e61:	0f 85 e8 08 00 00    	jne    f010274f <mem_init+0x129d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101e67:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e6c:	89 f0                	mov    %esi,%eax
f0101e6e:	e8 74 ee ff ff       	call   f0100ce7 <check_va2pa>
f0101e73:	89 c2                	mov    %eax,%edx
f0101e75:	89 f8                	mov    %edi,%eax
f0101e77:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101e7d:	c1 f8 03             	sar    $0x3,%eax
f0101e80:	c1 e0 0c             	shl    $0xc,%eax
f0101e83:	39 c2                	cmp    %eax,%edx
f0101e85:	0f 85 dd 08 00 00    	jne    f0102768 <mem_init+0x12b6>
	assert(pp1->pp_ref == 1);
f0101e8b:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101e90:	0f 85 eb 08 00 00    	jne    f0102781 <mem_init+0x12cf>
	assert(pp2->pp_ref == 0);
f0101e96:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101e9b:	0f 85 f9 08 00 00    	jne    f010279a <mem_init+0x12e8>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101ea1:	6a 00                	push   $0x0
f0101ea3:	68 00 10 00 00       	push   $0x1000
f0101ea8:	57                   	push   %edi
f0101ea9:	56                   	push   %esi
f0101eaa:	e8 26 f5 ff ff       	call   f01013d5 <page_insert>
f0101eaf:	83 c4 10             	add    $0x10,%esp
f0101eb2:	85 c0                	test   %eax,%eax
f0101eb4:	0f 85 f9 08 00 00    	jne    f01027b3 <mem_init+0x1301>
	assert(pp1->pp_ref);
f0101eba:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101ebf:	0f 84 07 09 00 00    	je     f01027cc <mem_init+0x131a>
	assert(pp1->pp_link == NULL);
f0101ec5:	83 3f 00             	cmpl   $0x0,(%edi)
f0101ec8:	0f 85 17 09 00 00    	jne    f01027e5 <mem_init+0x1333>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101ece:	83 ec 08             	sub    $0x8,%esp
f0101ed1:	68 00 10 00 00       	push   $0x1000
f0101ed6:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101edc:	e8 aa f4 ff ff       	call   f010138b <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101ee1:	8b 35 8c 7e 21 f0    	mov    0xf0217e8c,%esi
f0101ee7:	ba 00 00 00 00       	mov    $0x0,%edx
f0101eec:	89 f0                	mov    %esi,%eax
f0101eee:	e8 f4 ed ff ff       	call   f0100ce7 <check_va2pa>
f0101ef3:	83 c4 10             	add    $0x10,%esp
f0101ef6:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ef9:	0f 85 ff 08 00 00    	jne    f01027fe <mem_init+0x134c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101eff:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f04:	89 f0                	mov    %esi,%eax
f0101f06:	e8 dc ed ff ff       	call   f0100ce7 <check_va2pa>
f0101f0b:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101f0e:	0f 85 03 09 00 00    	jne    f0102817 <mem_init+0x1365>
	assert(pp1->pp_ref == 0);
f0101f14:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101f19:	0f 85 11 09 00 00    	jne    f0102830 <mem_init+0x137e>
	assert(pp2->pp_ref == 0);
f0101f1f:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101f24:	0f 85 1f 09 00 00    	jne    f0102849 <mem_init+0x1397>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101f2a:	83 ec 0c             	sub    $0xc,%esp
f0101f2d:	6a 00                	push   $0x0
f0101f2f:	e8 f9 f1 ff ff       	call   f010112d <page_alloc>
f0101f34:	83 c4 10             	add    $0x10,%esp
f0101f37:	39 c7                	cmp    %eax,%edi
f0101f39:	0f 85 23 09 00 00    	jne    f0102862 <mem_init+0x13b0>
f0101f3f:	85 c0                	test   %eax,%eax
f0101f41:	0f 84 1b 09 00 00    	je     f0102862 <mem_init+0x13b0>

	// should be no free memory
	assert(!page_alloc(0));
f0101f47:	83 ec 0c             	sub    $0xc,%esp
f0101f4a:	6a 00                	push   $0x0
f0101f4c:	e8 dc f1 ff ff       	call   f010112d <page_alloc>
f0101f51:	83 c4 10             	add    $0x10,%esp
f0101f54:	85 c0                	test   %eax,%eax
f0101f56:	0f 85 1f 09 00 00    	jne    f010287b <mem_init+0x13c9>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f5c:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0101f62:	8b 11                	mov    (%ecx),%edx
f0101f64:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101f6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f6d:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0101f73:	c1 f8 03             	sar    $0x3,%eax
f0101f76:	c1 e0 0c             	shl    $0xc,%eax
f0101f79:	39 c2                	cmp    %eax,%edx
f0101f7b:	0f 85 13 09 00 00    	jne    f0102894 <mem_init+0x13e2>
	kern_pgdir[0] = 0;
f0101f81:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101f87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f8a:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101f8f:	0f 85 18 09 00 00    	jne    f01028ad <mem_init+0x13fb>
	pp0->pp_ref = 0;
f0101f95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f98:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101f9e:	83 ec 0c             	sub    $0xc,%esp
f0101fa1:	50                   	push   %eax
f0101fa2:	e8 ff f1 ff ff       	call   f01011a6 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101fa7:	83 c4 0c             	add    $0xc,%esp
f0101faa:	6a 01                	push   $0x1
f0101fac:	68 00 10 40 00       	push   $0x401000
f0101fb1:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0101fb7:	e8 56 f2 ff ff       	call   f0101212 <pgdir_walk>
f0101fbc:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101fc2:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0101fc8:	8b 41 04             	mov    0x4(%ecx),%eax
f0101fcb:	89 c6                	mov    %eax,%esi
f0101fcd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0101fd3:	8b 15 88 7e 21 f0    	mov    0xf0217e88,%edx
f0101fd9:	c1 e8 0c             	shr    $0xc,%eax
f0101fdc:	83 c4 10             	add    $0x10,%esp
f0101fdf:	39 d0                	cmp    %edx,%eax
f0101fe1:	0f 83 df 08 00 00    	jae    f01028c6 <mem_init+0x1414>
	assert(ptep == ptep1 + PTX(va));
f0101fe7:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f0101fed:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0101ff0:	0f 85 e5 08 00 00    	jne    f01028db <mem_init+0x1429>
	kern_pgdir[PDX(va)] = 0;
f0101ff6:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0101ffd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102000:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102006:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f010200c:	c1 f8 03             	sar    $0x3,%eax
f010200f:	89 c1                	mov    %eax,%ecx
f0102011:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0102014:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102019:	39 c2                	cmp    %eax,%edx
f010201b:	0f 86 d3 08 00 00    	jbe    f01028f4 <mem_init+0x1442>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102021:	83 ec 04             	sub    $0x4,%esp
f0102024:	68 00 10 00 00       	push   $0x1000
f0102029:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f010202e:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0102034:	51                   	push   %ecx
f0102035:	e8 a1 39 00 00       	call   f01059db <memset>
	page_free(pp0);
f010203a:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f010203d:	89 34 24             	mov    %esi,(%esp)
f0102040:	e8 61 f1 ff ff       	call   f01011a6 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102045:	83 c4 0c             	add    $0xc,%esp
f0102048:	6a 01                	push   $0x1
f010204a:	6a 00                	push   $0x0
f010204c:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102052:	e8 bb f1 ff ff       	call   f0101212 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0102057:	89 f0                	mov    %esi,%eax
f0102059:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f010205f:	c1 f8 03             	sar    $0x3,%eax
f0102062:	89 c2                	mov    %eax,%edx
f0102064:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102067:	25 ff ff 0f 00       	and    $0xfffff,%eax
f010206c:	83 c4 10             	add    $0x10,%esp
f010206f:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102075:	0f 83 8b 08 00 00    	jae    f0102906 <mem_init+0x1454>
	return (void *)(pa + KERNBASE);
f010207b:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102081:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102084:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010208a:	f6 00 01             	testb  $0x1,(%eax)
f010208d:	0f 85 85 08 00 00    	jne    f0102918 <mem_init+0x1466>
f0102093:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0102096:	39 d0                	cmp    %edx,%eax
f0102098:	75 f0                	jne    f010208a <mem_init+0xbd8>
	kern_pgdir[0] = 0;
f010209a:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f010209f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01020a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020a8:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f01020ae:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01020b1:	89 0d 40 72 21 f0    	mov    %ecx,0xf0217240

	// free the pages we took
	page_free(pp0);
f01020b7:	83 ec 0c             	sub    $0xc,%esp
f01020ba:	50                   	push   %eax
f01020bb:	e8 e6 f0 ff ff       	call   f01011a6 <page_free>
	page_free(pp1);
f01020c0:	89 3c 24             	mov    %edi,(%esp)
f01020c3:	e8 de f0 ff ff       	call   f01011a6 <page_free>
	page_free(pp2);
f01020c8:	89 1c 24             	mov    %ebx,(%esp)
f01020cb:	e8 d6 f0 ff ff       	call   f01011a6 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f01020d0:	83 c4 08             	add    $0x8,%esp
f01020d3:	68 01 10 00 00       	push   $0x1001
f01020d8:	6a 00                	push   $0x0
f01020da:	e8 6c f3 ff ff       	call   f010144b <mmio_map_region>
f01020df:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f01020e1:	83 c4 08             	add    $0x8,%esp
f01020e4:	68 00 10 00 00       	push   $0x1000
f01020e9:	6a 00                	push   $0x0
f01020eb:	e8 5b f3 ff ff       	call   f010144b <mmio_map_region>
f01020f0:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01020f2:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f01020f8:	83 c4 10             	add    $0x10,%esp
f01020fb:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102101:	0f 86 2a 08 00 00    	jbe    f0102931 <mem_init+0x147f>
f0102107:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f010210c:	0f 87 1f 08 00 00    	ja     f0102931 <mem_init+0x147f>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102112:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102118:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f010211e:	0f 87 26 08 00 00    	ja     f010294a <mem_init+0x1498>
f0102124:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010212a:	0f 86 1a 08 00 00    	jbe    f010294a <mem_init+0x1498>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102130:	89 da                	mov    %ebx,%edx
f0102132:	09 f2                	or     %esi,%edx
f0102134:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010213a:	0f 85 23 08 00 00    	jne    f0102963 <mem_init+0x14b1>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0102140:	39 c6                	cmp    %eax,%esi
f0102142:	0f 82 34 08 00 00    	jb     f010297c <mem_init+0x14ca>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102148:	8b 3d 8c 7e 21 f0    	mov    0xf0217e8c,%edi
f010214e:	89 da                	mov    %ebx,%edx
f0102150:	89 f8                	mov    %edi,%eax
f0102152:	e8 90 eb ff ff       	call   f0100ce7 <check_va2pa>
f0102157:	85 c0                	test   %eax,%eax
f0102159:	0f 85 36 08 00 00    	jne    f0102995 <mem_init+0x14e3>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010215f:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102165:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102168:	89 c2                	mov    %eax,%edx
f010216a:	89 f8                	mov    %edi,%eax
f010216c:	e8 76 eb ff ff       	call   f0100ce7 <check_va2pa>
f0102171:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102176:	0f 85 32 08 00 00    	jne    f01029ae <mem_init+0x14fc>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f010217c:	89 f2                	mov    %esi,%edx
f010217e:	89 f8                	mov    %edi,%eax
f0102180:	e8 62 eb ff ff       	call   f0100ce7 <check_va2pa>
f0102185:	85 c0                	test   %eax,%eax
f0102187:	0f 85 3a 08 00 00    	jne    f01029c7 <mem_init+0x1515>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f010218d:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102193:	89 f8                	mov    %edi,%eax
f0102195:	e8 4d eb ff ff       	call   f0100ce7 <check_va2pa>
f010219a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010219d:	0f 85 3d 08 00 00    	jne    f01029e0 <mem_init+0x152e>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01021a3:	83 ec 04             	sub    $0x4,%esp
f01021a6:	6a 00                	push   $0x0
f01021a8:	53                   	push   %ebx
f01021a9:	57                   	push   %edi
f01021aa:	e8 63 f0 ff ff       	call   f0101212 <pgdir_walk>
f01021af:	83 c4 10             	add    $0x10,%esp
f01021b2:	f6 00 1a             	testb  $0x1a,(%eax)
f01021b5:	0f 84 3e 08 00 00    	je     f01029f9 <mem_init+0x1547>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01021bb:	83 ec 04             	sub    $0x4,%esp
f01021be:	6a 00                	push   $0x0
f01021c0:	53                   	push   %ebx
f01021c1:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f01021c7:	e8 46 f0 ff ff       	call   f0101212 <pgdir_walk>
f01021cc:	8b 00                	mov    (%eax),%eax
f01021ce:	83 c4 10             	add    $0x10,%esp
f01021d1:	83 e0 04             	and    $0x4,%eax
f01021d4:	89 c7                	mov    %eax,%edi
f01021d6:	0f 85 36 08 00 00    	jne    f0102a12 <mem_init+0x1560>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f01021dc:	83 ec 04             	sub    $0x4,%esp
f01021df:	6a 00                	push   $0x0
f01021e1:	53                   	push   %ebx
f01021e2:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f01021e8:	e8 25 f0 ff ff       	call   f0101212 <pgdir_walk>
f01021ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f01021f3:	83 c4 0c             	add    $0xc,%esp
f01021f6:	6a 00                	push   $0x0
f01021f8:	ff 75 d4             	pushl  -0x2c(%ebp)
f01021fb:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102201:	e8 0c f0 ff ff       	call   f0101212 <pgdir_walk>
f0102206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f010220c:	83 c4 0c             	add    $0xc,%esp
f010220f:	6a 00                	push   $0x0
f0102211:	56                   	push   %esi
f0102212:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102218:	e8 f5 ef ff ff       	call   f0101212 <pgdir_walk>
f010221d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102223:	c7 04 24 70 70 10 f0 	movl   $0xf0107070,(%esp)
f010222a:	e8 a9 18 00 00       	call   f0103ad8 <cprintf>
	boot_map_region(kern_pgdir,UPAGES,PTSIZE,PADDR(pages),PTE_U | PTE_P);	
f010222f:	a1 90 7e 21 f0       	mov    0xf0217e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0102234:	83 c4 10             	add    $0x10,%esp
f0102237:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010223c:	0f 86 e9 07 00 00    	jbe    f0102a2b <mem_init+0x1579>
f0102242:	83 ec 08             	sub    $0x8,%esp
f0102245:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102247:	05 00 00 00 10       	add    $0x10000000,%eax
f010224c:	50                   	push   %eax
f010224d:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102252:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102257:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f010225c:	e8 42 f0 ff ff       	call   f01012a3 <boot_map_region>
	boot_map_region(kern_pgdir,UENVS,PTSIZE,PADDR(envs),PTE_U|PTE_P);
f0102261:	a1 48 72 21 f0       	mov    0xf0217248,%eax
	if ((uint32_t)kva < KERNBASE)
f0102266:	83 c4 10             	add    $0x10,%esp
f0102269:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010226e:	0f 86 cc 07 00 00    	jbe    f0102a40 <mem_init+0x158e>
f0102274:	83 ec 08             	sub    $0x8,%esp
f0102277:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f0102279:	05 00 00 00 10       	add    $0x10000000,%eax
f010227e:	50                   	push   %eax
f010227f:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102284:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102289:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f010228e:	e8 10 f0 ff ff       	call   f01012a3 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102293:	83 c4 10             	add    $0x10,%esp
f0102296:	b8 00 90 11 f0       	mov    $0xf0119000,%eax
f010229b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01022a0:	0f 86 af 07 00 00    	jbe    f0102a55 <mem_init+0x15a3>
	boot_map_region(kern_pgdir,KSTACKTOP-KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f01022a6:	83 ec 08             	sub    $0x8,%esp
f01022a9:	6a 02                	push   $0x2
f01022ab:	68 00 90 11 00       	push   $0x119000
f01022b0:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01022b5:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01022ba:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f01022bf:	e8 df ef ff ff       	call   f01012a3 <boot_map_region>
	boot_map_region(kern_pgdir,KERNBASE,(0xffffffff-KERNBASE),0,PTE_W);
f01022c4:	83 c4 08             	add    $0x8,%esp
f01022c7:	6a 02                	push   $0x2
f01022c9:	6a 00                	push   $0x0
f01022cb:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f01022d0:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01022d5:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f01022da:	e8 c4 ef ff ff       	call   f01012a3 <boot_map_region>
f01022df:	c7 45 d0 00 90 21 f0 	movl   $0xf0219000,-0x30(%ebp)
f01022e6:	83 c4 10             	add    $0x10,%esp
f01022e9:	bb 00 90 21 f0       	mov    $0xf0219000,%ebx
	uintptr_t begin=KSTACKTOP-KSTKSIZE;
f01022ee:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01022f3:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01022f9:	0f 86 6b 07 00 00    	jbe    f0102a6a <mem_init+0x15b8>
		boot_map_region(kern_pgdir,begin,KSTKSIZE,PADDR(percpu_kstacks[i]),PTE_W);
f01022ff:	83 ec 08             	sub    $0x8,%esp
f0102302:	6a 02                	push   $0x2
f0102304:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f010230a:	50                   	push   %eax
f010230b:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102310:	89 f2                	mov    %esi,%edx
f0102312:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0102317:	e8 87 ef ff ff       	call   f01012a3 <boot_map_region>
		begin-=(KSTKSIZE+KSTKGAP);
f010231c:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102322:	81 c3 00 80 00 00    	add    $0x8000,%ebx
	for(int i=0;i<NCPU;i++){
f0102328:	83 c4 10             	add    $0x10,%esp
f010232b:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0102331:	75 c0                	jne    f01022f3 <mem_init+0xe41>
	pgdir = kern_pgdir;
f0102333:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
f0102338:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f010233b:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f0102340:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102343:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010234a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010234f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102352:	8b 35 90 7e 21 f0    	mov    0xf0217e90,%esi
f0102358:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f010235b:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0102361:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102364:	89 fb                	mov    %edi,%ebx
f0102366:	e9 2f 07 00 00       	jmp    f0102a9a <mem_init+0x15e8>
	assert(nfree == 0);
f010236b:	68 87 6f 10 f0       	push   $0xf0106f87
f0102370:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102375:	68 4b 03 00 00       	push   $0x34b
f010237a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010237f:	e8 bc dc ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102384:	68 95 6e 10 f0       	push   $0xf0106e95
f0102389:	68 b1 6d 10 f0       	push   $0xf0106db1
f010238e:	68 b1 03 00 00       	push   $0x3b1
f0102393:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102398:	e8 a3 dc ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010239d:	68 ab 6e 10 f0       	push   $0xf0106eab
f01023a2:	68 b1 6d 10 f0       	push   $0xf0106db1
f01023a7:	68 b2 03 00 00       	push   $0x3b2
f01023ac:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01023b1:	e8 8a dc ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01023b6:	68 c1 6e 10 f0       	push   $0xf0106ec1
f01023bb:	68 b1 6d 10 f0       	push   $0xf0106db1
f01023c0:	68 b3 03 00 00       	push   $0x3b3
f01023c5:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01023ca:	e8 71 dc ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01023cf:	68 d7 6e 10 f0       	push   $0xf0106ed7
f01023d4:	68 b1 6d 10 f0       	push   $0xf0106db1
f01023d9:	68 b6 03 00 00       	push   $0x3b6
f01023de:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01023e3:	e8 58 dc ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01023e8:	68 20 72 10 f0       	push   $0xf0107220
f01023ed:	68 b1 6d 10 f0       	push   $0xf0106db1
f01023f2:	68 b7 03 00 00       	push   $0x3b7
f01023f7:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01023fc:	e8 3f dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102401:	68 40 6f 10 f0       	push   $0xf0106f40
f0102406:	68 b1 6d 10 f0       	push   $0xf0106db1
f010240b:	68 be 03 00 00       	push   $0x3be
f0102410:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102415:	e8 26 dc ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010241a:	68 60 72 10 f0       	push   $0xf0107260
f010241f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102424:	68 c1 03 00 00       	push   $0x3c1
f0102429:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010242e:	e8 0d dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102433:	68 98 72 10 f0       	push   $0xf0107298
f0102438:	68 b1 6d 10 f0       	push   $0xf0106db1
f010243d:	68 c4 03 00 00       	push   $0x3c4
f0102442:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102447:	e8 f4 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010244c:	68 c8 72 10 f0       	push   $0xf01072c8
f0102451:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102456:	68 c8 03 00 00       	push   $0x3c8
f010245b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102460:	e8 db db ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102465:	68 f8 72 10 f0       	push   $0xf01072f8
f010246a:	68 b1 6d 10 f0       	push   $0xf0106db1
f010246f:	68 c9 03 00 00       	push   $0x3c9
f0102474:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102479:	e8 c2 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010247e:	68 20 73 10 f0       	push   $0xf0107320
f0102483:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102488:	68 ca 03 00 00       	push   $0x3ca
f010248d:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102492:	e8 a9 db ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102497:	68 92 6f 10 f0       	push   $0xf0106f92
f010249c:	68 b1 6d 10 f0       	push   $0xf0106db1
f01024a1:	68 cb 03 00 00       	push   $0x3cb
f01024a6:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01024ab:	e8 90 db ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01024b0:	68 a3 6f 10 f0       	push   $0xf0106fa3
f01024b5:	68 b1 6d 10 f0       	push   $0xf0106db1
f01024ba:	68 cc 03 00 00       	push   $0x3cc
f01024bf:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01024c4:	e8 77 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024c9:	68 50 73 10 f0       	push   $0xf0107350
f01024ce:	68 b1 6d 10 f0       	push   $0xf0106db1
f01024d3:	68 cf 03 00 00       	push   $0x3cf
f01024d8:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01024dd:	e8 5e db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024e2:	68 8c 73 10 f0       	push   $0xf010738c
f01024e7:	68 b1 6d 10 f0       	push   $0xf0106db1
f01024ec:	68 d0 03 00 00       	push   $0x3d0
f01024f1:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01024f6:	e8 45 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01024fb:	68 b4 6f 10 f0       	push   $0xf0106fb4
f0102500:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102505:	68 d1 03 00 00       	push   $0x3d1
f010250a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010250f:	e8 2c db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102514:	68 40 6f 10 f0       	push   $0xf0106f40
f0102519:	68 b1 6d 10 f0       	push   $0xf0106db1
f010251e:	68 d4 03 00 00       	push   $0x3d4
f0102523:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102528:	e8 13 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010252d:	68 50 73 10 f0       	push   $0xf0107350
f0102532:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102537:	68 d7 03 00 00       	push   $0x3d7
f010253c:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102541:	e8 fa da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102546:	68 8c 73 10 f0       	push   $0xf010738c
f010254b:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102550:	68 d8 03 00 00       	push   $0x3d8
f0102555:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010255a:	e8 e1 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010255f:	68 b4 6f 10 f0       	push   $0xf0106fb4
f0102564:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102569:	68 d9 03 00 00       	push   $0x3d9
f010256e:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102573:	e8 c8 da ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102578:	68 40 6f 10 f0       	push   $0xf0106f40
f010257d:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102582:	68 dd 03 00 00       	push   $0x3dd
f0102587:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010258c:	e8 af da ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102591:	52                   	push   %edx
f0102592:	68 a4 66 10 f0       	push   $0xf01066a4
f0102597:	68 e0 03 00 00       	push   $0x3e0
f010259c:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01025a1:	e8 9a da ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f01025a6:	68 bc 73 10 f0       	push   $0xf01073bc
f01025ab:	68 b1 6d 10 f0       	push   $0xf0106db1
f01025b0:	68 e1 03 00 00       	push   $0x3e1
f01025b5:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01025ba:	e8 81 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01025bf:	68 fc 73 10 f0       	push   $0xf01073fc
f01025c4:	68 b1 6d 10 f0       	push   $0xf0106db1
f01025c9:	68 e4 03 00 00       	push   $0x3e4
f01025ce:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01025d3:	e8 68 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01025d8:	68 8c 73 10 f0       	push   $0xf010738c
f01025dd:	68 b1 6d 10 f0       	push   $0xf0106db1
f01025e2:	68 e5 03 00 00       	push   $0x3e5
f01025e7:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01025ec:	e8 4f da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01025f1:	68 b4 6f 10 f0       	push   $0xf0106fb4
f01025f6:	68 b1 6d 10 f0       	push   $0xf0106db1
f01025fb:	68 e6 03 00 00       	push   $0x3e6
f0102600:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102605:	e8 36 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010260a:	68 3c 74 10 f0       	push   $0xf010743c
f010260f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102614:	68 e7 03 00 00       	push   $0x3e7
f0102619:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010261e:	e8 1d da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102623:	68 c5 6f 10 f0       	push   $0xf0106fc5
f0102628:	68 b1 6d 10 f0       	push   $0xf0106db1
f010262d:	68 e8 03 00 00       	push   $0x3e8
f0102632:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102637:	e8 04 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010263c:	68 50 73 10 f0       	push   $0xf0107350
f0102641:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102646:	68 eb 03 00 00       	push   $0x3eb
f010264b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102650:	e8 eb d9 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0102655:	68 70 74 10 f0       	push   $0xf0107470
f010265a:	68 b1 6d 10 f0       	push   $0xf0106db1
f010265f:	68 ec 03 00 00       	push   $0x3ec
f0102664:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102669:	e8 d2 d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010266e:	68 a4 74 10 f0       	push   $0xf01074a4
f0102673:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102678:	68 ed 03 00 00       	push   $0x3ed
f010267d:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102682:	e8 b9 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102687:	68 dc 74 10 f0       	push   $0xf01074dc
f010268c:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102691:	68 f0 03 00 00       	push   $0x3f0
f0102696:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010269b:	e8 a0 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01026a0:	68 14 75 10 f0       	push   $0xf0107514
f01026a5:	68 b1 6d 10 f0       	push   $0xf0106db1
f01026aa:	68 f3 03 00 00       	push   $0x3f3
f01026af:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01026b4:	e8 87 d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01026b9:	68 a4 74 10 f0       	push   $0xf01074a4
f01026be:	68 b1 6d 10 f0       	push   $0xf0106db1
f01026c3:	68 f4 03 00 00       	push   $0x3f4
f01026c8:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01026cd:	e8 6e d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01026d2:	68 50 75 10 f0       	push   $0xf0107550
f01026d7:	68 b1 6d 10 f0       	push   $0xf0106db1
f01026dc:	68 f7 03 00 00       	push   $0x3f7
f01026e1:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01026e6:	e8 55 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01026eb:	68 7c 75 10 f0       	push   $0xf010757c
f01026f0:	68 b1 6d 10 f0       	push   $0xf0106db1
f01026f5:	68 f8 03 00 00       	push   $0x3f8
f01026fa:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01026ff:	e8 3c d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102704:	68 db 6f 10 f0       	push   $0xf0106fdb
f0102709:	68 b1 6d 10 f0       	push   $0xf0106db1
f010270e:	68 fa 03 00 00       	push   $0x3fa
f0102713:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102718:	e8 23 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010271d:	68 ec 6f 10 f0       	push   $0xf0106fec
f0102722:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102727:	68 fb 03 00 00       	push   $0x3fb
f010272c:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102731:	e8 0a d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102736:	68 ac 75 10 f0       	push   $0xf01075ac
f010273b:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102740:	68 fe 03 00 00       	push   $0x3fe
f0102745:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010274a:	e8 f1 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010274f:	68 d0 75 10 f0       	push   $0xf01075d0
f0102754:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102759:	68 02 04 00 00       	push   $0x402
f010275e:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102763:	e8 d8 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102768:	68 7c 75 10 f0       	push   $0xf010757c
f010276d:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102772:	68 03 04 00 00       	push   $0x403
f0102777:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010277c:	e8 bf d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102781:	68 92 6f 10 f0       	push   $0xf0106f92
f0102786:	68 b1 6d 10 f0       	push   $0xf0106db1
f010278b:	68 04 04 00 00       	push   $0x404
f0102790:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102795:	e8 a6 d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010279a:	68 ec 6f 10 f0       	push   $0xf0106fec
f010279f:	68 b1 6d 10 f0       	push   $0xf0106db1
f01027a4:	68 05 04 00 00       	push   $0x405
f01027a9:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01027ae:	e8 8d d8 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01027b3:	68 f4 75 10 f0       	push   $0xf01075f4
f01027b8:	68 b1 6d 10 f0       	push   $0xf0106db1
f01027bd:	68 08 04 00 00       	push   $0x408
f01027c2:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01027c7:	e8 74 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f01027cc:	68 fd 6f 10 f0       	push   $0xf0106ffd
f01027d1:	68 b1 6d 10 f0       	push   $0xf0106db1
f01027d6:	68 09 04 00 00       	push   $0x409
f01027db:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01027e0:	e8 5b d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f01027e5:	68 09 70 10 f0       	push   $0xf0107009
f01027ea:	68 b1 6d 10 f0       	push   $0xf0106db1
f01027ef:	68 0a 04 00 00       	push   $0x40a
f01027f4:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01027f9:	e8 42 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027fe:	68 d0 75 10 f0       	push   $0xf01075d0
f0102803:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102808:	68 0e 04 00 00       	push   $0x40e
f010280d:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102812:	e8 29 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102817:	68 2c 76 10 f0       	push   $0xf010762c
f010281c:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102821:	68 0f 04 00 00       	push   $0x40f
f0102826:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010282b:	e8 10 d8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102830:	68 1e 70 10 f0       	push   $0xf010701e
f0102835:	68 b1 6d 10 f0       	push   $0xf0106db1
f010283a:	68 10 04 00 00       	push   $0x410
f010283f:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102844:	e8 f7 d7 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102849:	68 ec 6f 10 f0       	push   $0xf0106fec
f010284e:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102853:	68 11 04 00 00       	push   $0x411
f0102858:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010285d:	e8 de d7 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102862:	68 54 76 10 f0       	push   $0xf0107654
f0102867:	68 b1 6d 10 f0       	push   $0xf0106db1
f010286c:	68 14 04 00 00       	push   $0x414
f0102871:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102876:	e8 c5 d7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010287b:	68 40 6f 10 f0       	push   $0xf0106f40
f0102880:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102885:	68 17 04 00 00       	push   $0x417
f010288a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010288f:	e8 ac d7 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102894:	68 f8 72 10 f0       	push   $0xf01072f8
f0102899:	68 b1 6d 10 f0       	push   $0xf0106db1
f010289e:	68 1a 04 00 00       	push   $0x41a
f01028a3:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01028a8:	e8 93 d7 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01028ad:	68 a3 6f 10 f0       	push   $0xf0106fa3
f01028b2:	68 b1 6d 10 f0       	push   $0xf0106db1
f01028b7:	68 1c 04 00 00       	push   $0x41c
f01028bc:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01028c1:	e8 7a d7 ff ff       	call   f0100040 <_panic>
f01028c6:	56                   	push   %esi
f01028c7:	68 a4 66 10 f0       	push   $0xf01066a4
f01028cc:	68 23 04 00 00       	push   $0x423
f01028d1:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01028d6:	e8 65 d7 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f01028db:	68 2f 70 10 f0       	push   $0xf010702f
f01028e0:	68 b1 6d 10 f0       	push   $0xf0106db1
f01028e5:	68 24 04 00 00       	push   $0x424
f01028ea:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01028ef:	e8 4c d7 ff ff       	call   f0100040 <_panic>
f01028f4:	51                   	push   %ecx
f01028f5:	68 a4 66 10 f0       	push   $0xf01066a4
f01028fa:	6a 58                	push   $0x58
f01028fc:	68 97 6d 10 f0       	push   $0xf0106d97
f0102901:	e8 3a d7 ff ff       	call   f0100040 <_panic>
f0102906:	52                   	push   %edx
f0102907:	68 a4 66 10 f0       	push   $0xf01066a4
f010290c:	6a 58                	push   $0x58
f010290e:	68 97 6d 10 f0       	push   $0xf0106d97
f0102913:	e8 28 d7 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102918:	68 47 70 10 f0       	push   $0xf0107047
f010291d:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102922:	68 2e 04 00 00       	push   $0x42e
f0102927:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010292c:	e8 0f d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102931:	68 78 76 10 f0       	push   $0xf0107678
f0102936:	68 b1 6d 10 f0       	push   $0xf0106db1
f010293b:	68 3e 04 00 00       	push   $0x43e
f0102940:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102945:	e8 f6 d6 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f010294a:	68 a0 76 10 f0       	push   $0xf01076a0
f010294f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102954:	68 3f 04 00 00       	push   $0x43f
f0102959:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010295e:	e8 dd d6 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102963:	68 c8 76 10 f0       	push   $0xf01076c8
f0102968:	68 b1 6d 10 f0       	push   $0xf0106db1
f010296d:	68 41 04 00 00       	push   $0x441
f0102972:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102977:	e8 c4 d6 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f010297c:	68 5e 70 10 f0       	push   $0xf010705e
f0102981:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102986:	68 43 04 00 00       	push   $0x443
f010298b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102990:	e8 ab d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102995:	68 f0 76 10 f0       	push   $0xf01076f0
f010299a:	68 b1 6d 10 f0       	push   $0xf0106db1
f010299f:	68 45 04 00 00       	push   $0x445
f01029a4:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01029a9:	e8 92 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f01029ae:	68 14 77 10 f0       	push   $0xf0107714
f01029b3:	68 b1 6d 10 f0       	push   $0xf0106db1
f01029b8:	68 46 04 00 00       	push   $0x446
f01029bd:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01029c2:	e8 79 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01029c7:	68 44 77 10 f0       	push   $0xf0107744
f01029cc:	68 b1 6d 10 f0       	push   $0xf0106db1
f01029d1:	68 47 04 00 00       	push   $0x447
f01029d6:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01029db:	e8 60 d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f01029e0:	68 68 77 10 f0       	push   $0xf0107768
f01029e5:	68 b1 6d 10 f0       	push   $0xf0106db1
f01029ea:	68 48 04 00 00       	push   $0x448
f01029ef:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01029f4:	e8 47 d6 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01029f9:	68 94 77 10 f0       	push   $0xf0107794
f01029fe:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102a03:	68 4a 04 00 00       	push   $0x44a
f0102a08:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a0d:	e8 2e d6 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102a12:	68 d8 77 10 f0       	push   $0xf01077d8
f0102a17:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102a1c:	68 4b 04 00 00       	push   $0x44b
f0102a21:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a26:	e8 15 d6 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102a2b:	50                   	push   %eax
f0102a2c:	68 c8 66 10 f0       	push   $0xf01066c8
f0102a31:	68 c2 00 00 00       	push   $0xc2
f0102a36:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a3b:	e8 00 d6 ff ff       	call   f0100040 <_panic>
f0102a40:	50                   	push   %eax
f0102a41:	68 c8 66 10 f0       	push   $0xf01066c8
f0102a46:	68 cb 00 00 00       	push   $0xcb
f0102a4b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a50:	e8 eb d5 ff ff       	call   f0100040 <_panic>
f0102a55:	50                   	push   %eax
f0102a56:	68 c8 66 10 f0       	push   $0xf01066c8
f0102a5b:	68 d9 00 00 00       	push   $0xd9
f0102a60:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a65:	e8 d6 d5 ff ff       	call   f0100040 <_panic>
f0102a6a:	53                   	push   %ebx
f0102a6b:	68 c8 66 10 f0       	push   $0xf01066c8
f0102a70:	68 19 01 00 00       	push   $0x119
f0102a75:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a7a:	e8 c1 d5 ff ff       	call   f0100040 <_panic>
f0102a7f:	56                   	push   %esi
f0102a80:	68 c8 66 10 f0       	push   $0xf01066c8
f0102a85:	68 63 03 00 00       	push   $0x363
f0102a8a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102a8f:	e8 ac d5 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102a94:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102a9a:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0102a9d:	76 3a                	jbe    f0102ad9 <mem_init+0x1627>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102a9f:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102aa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102aa8:	e8 3a e2 ff ff       	call   f0100ce7 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102aad:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102ab4:	76 c9                	jbe    f0102a7f <mem_init+0x15cd>
f0102ab6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102ab9:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102abc:	39 d0                	cmp    %edx,%eax
f0102abe:	74 d4                	je     f0102a94 <mem_init+0x15e2>
f0102ac0:	68 0c 78 10 f0       	push   $0xf010780c
f0102ac5:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102aca:	68 63 03 00 00       	push   $0x363
f0102acf:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102ad4:	e8 67 d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102ad9:	a1 48 72 21 f0       	mov    0xf0217248,%eax
f0102ade:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102ae1:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102ae4:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102ae9:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102aef:	89 da                	mov    %ebx,%edx
f0102af1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102af4:	e8 ee e1 ff ff       	call   f0100ce7 <check_va2pa>
f0102af9:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102b00:	76 3b                	jbe    f0102b3d <mem_init+0x168b>
f0102b02:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102b05:	39 d0                	cmp    %edx,%eax
f0102b07:	75 4b                	jne    f0102b54 <mem_init+0x16a2>
f0102b09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102b0f:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102b15:	75 d8                	jne    f0102aef <mem_init+0x163d>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b17:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0102b1a:	c1 e6 0c             	shl    $0xc,%esi
f0102b1d:	89 fb                	mov    %edi,%ebx
f0102b1f:	39 f3                	cmp    %esi,%ebx
f0102b21:	73 63                	jae    f0102b86 <mem_init+0x16d4>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b23:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b2c:	e8 b6 e1 ff ff       	call   f0100ce7 <check_va2pa>
f0102b31:	39 c3                	cmp    %eax,%ebx
f0102b33:	75 38                	jne    f0102b6d <mem_init+0x16bb>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102b3b:	eb e2                	jmp    f0102b1f <mem_init+0x166d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102b3d:	ff 75 c8             	pushl  -0x38(%ebp)
f0102b40:	68 c8 66 10 f0       	push   $0xf01066c8
f0102b45:	68 68 03 00 00       	push   $0x368
f0102b4a:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102b4f:	e8 ec d4 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102b54:	68 40 78 10 f0       	push   $0xf0107840
f0102b59:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102b5e:	68 68 03 00 00       	push   $0x368
f0102b63:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102b68:	e8 d3 d4 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102b6d:	68 74 78 10 f0       	push   $0xf0107874
f0102b72:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102b77:	68 6c 03 00 00       	push   $0x36c
f0102b7c:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102b81:	e8 ba d4 ff ff       	call   f0100040 <_panic>
f0102b86:	c7 45 cc 00 90 22 00 	movl   $0x229000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102b8d:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
f0102b92:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102b95:	8d bb 00 80 ff ff    	lea    -0x8000(%ebx),%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102b9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102b9e:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0102ba1:	89 de                	mov    %ebx,%esi
f0102ba3:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102ba6:	05 00 80 ff 0f       	add    $0xfff8000,%eax
f0102bab:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102bae:	8d 83 00 80 00 00    	lea    0x8000(%ebx),%eax
f0102bb4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102bb7:	89 f2                	mov    %esi,%edx
f0102bb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bbc:	e8 26 e1 ff ff       	call   f0100ce7 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102bc1:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102bc8:	76 58                	jbe    f0102c22 <mem_init+0x1770>
f0102bca:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102bcd:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102bd0:	39 d0                	cmp    %edx,%eax
f0102bd2:	75 65                	jne    f0102c39 <mem_init+0x1787>
f0102bd4:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102bda:	3b 75 c4             	cmp    -0x3c(%ebp),%esi
f0102bdd:	75 d8                	jne    f0102bb7 <mem_init+0x1705>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102bdf:	89 fa                	mov    %edi,%edx
f0102be1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102be4:	e8 fe e0 ff ff       	call   f0100ce7 <check_va2pa>
f0102be9:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102bec:	75 64                	jne    f0102c52 <mem_init+0x17a0>
f0102bee:	81 c7 00 10 00 00    	add    $0x1000,%edi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102bf4:	39 df                	cmp    %ebx,%edi
f0102bf6:	75 e7                	jne    f0102bdf <mem_init+0x172d>
f0102bf8:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
f0102bfe:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
f0102c05:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102c08:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102c0f:	3d 00 90 25 f0       	cmp    $0xf0259000,%eax
f0102c14:	0f 85 7b ff ff ff    	jne    f0102b95 <mem_init+0x16e3>
f0102c1a:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0102c1d:	e9 84 00 00 00       	jmp    f0102ca6 <mem_init+0x17f4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102c22:	ff 75 bc             	pushl  -0x44(%ebp)
f0102c25:	68 c8 66 10 f0       	push   $0xf01066c8
f0102c2a:	68 74 03 00 00       	push   $0x374
f0102c2f:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102c34:	e8 07 d4 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102c39:	68 9c 78 10 f0       	push   $0xf010789c
f0102c3e:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102c43:	68 73 03 00 00       	push   $0x373
f0102c48:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102c4d:	e8 ee d3 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102c52:	68 e4 78 10 f0       	push   $0xf01078e4
f0102c57:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102c5c:	68 76 03 00 00       	push   $0x376
f0102c61:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102c66:	e8 d5 d3 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102c6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c6e:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102c72:	75 4e                	jne    f0102cc2 <mem_init+0x1810>
f0102c74:	68 89 70 10 f0       	push   $0xf0107089
f0102c79:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102c7e:	68 81 03 00 00       	push   $0x381
f0102c83:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102c88:	e8 b3 d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102c8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c90:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102c93:	a8 01                	test   $0x1,%al
f0102c95:	74 30                	je     f0102cc7 <mem_init+0x1815>
				assert(pgdir[i] & PTE_W);
f0102c97:	a8 02                	test   $0x2,%al
f0102c99:	74 45                	je     f0102ce0 <mem_init+0x182e>
	for (i = 0; i < NPDENTRIES; i++) {
f0102c9b:	83 c7 01             	add    $0x1,%edi
f0102c9e:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102ca4:	74 6c                	je     f0102d12 <mem_init+0x1860>
		switch (i) {
f0102ca6:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102cac:	83 f8 04             	cmp    $0x4,%eax
f0102caf:	76 ba                	jbe    f0102c6b <mem_init+0x17b9>
			if (i >= PDX(KERNBASE)) {
f0102cb1:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102cb7:	77 d4                	ja     f0102c8d <mem_init+0x17db>
				assert(pgdir[i] == 0);
f0102cb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102cbc:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102cc0:	75 37                	jne    f0102cf9 <mem_init+0x1847>
	for (i = 0; i < NPDENTRIES; i++) {
f0102cc2:	83 c7 01             	add    $0x1,%edi
f0102cc5:	eb df                	jmp    f0102ca6 <mem_init+0x17f4>
				assert(pgdir[i] & PTE_P);
f0102cc7:	68 89 70 10 f0       	push   $0xf0107089
f0102ccc:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102cd1:	68 85 03 00 00       	push   $0x385
f0102cd6:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102cdb:	e8 60 d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102ce0:	68 9a 70 10 f0       	push   $0xf010709a
f0102ce5:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102cea:	68 86 03 00 00       	push   $0x386
f0102cef:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102cf4:	e8 47 d3 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102cf9:	68 ab 70 10 f0       	push   $0xf01070ab
f0102cfe:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102d03:	68 88 03 00 00       	push   $0x388
f0102d08:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102d0d:	e8 2e d3 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102d12:	83 ec 0c             	sub    $0xc,%esp
f0102d15:	68 08 79 10 f0       	push   $0xf0107908
f0102d1a:	e8 b9 0d 00 00       	call   f0103ad8 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102d1f:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102d24:	83 c4 10             	add    $0x10,%esp
f0102d27:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102d2c:	0f 86 03 02 00 00    	jbe    f0102f35 <mem_init+0x1a83>
	return (physaddr_t)kva - KERNBASE;
f0102d32:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102d37:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102d3a:	b8 00 00 00 00       	mov    $0x0,%eax
f0102d3f:	e8 06 e0 ff ff       	call   f0100d4a <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102d44:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102d47:	83 e0 f3             	and    $0xfffffff3,%eax
f0102d4a:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102d4f:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102d52:	83 ec 0c             	sub    $0xc,%esp
f0102d55:	6a 00                	push   $0x0
f0102d57:	e8 d1 e3 ff ff       	call   f010112d <page_alloc>
f0102d5c:	89 c6                	mov    %eax,%esi
f0102d5e:	83 c4 10             	add    $0x10,%esp
f0102d61:	85 c0                	test   %eax,%eax
f0102d63:	0f 84 e1 01 00 00    	je     f0102f4a <mem_init+0x1a98>
	assert((pp1 = page_alloc(0)));
f0102d69:	83 ec 0c             	sub    $0xc,%esp
f0102d6c:	6a 00                	push   $0x0
f0102d6e:	e8 ba e3 ff ff       	call   f010112d <page_alloc>
f0102d73:	89 c7                	mov    %eax,%edi
f0102d75:	83 c4 10             	add    $0x10,%esp
f0102d78:	85 c0                	test   %eax,%eax
f0102d7a:	0f 84 e3 01 00 00    	je     f0102f63 <mem_init+0x1ab1>
	assert((pp2 = page_alloc(0)));
f0102d80:	83 ec 0c             	sub    $0xc,%esp
f0102d83:	6a 00                	push   $0x0
f0102d85:	e8 a3 e3 ff ff       	call   f010112d <page_alloc>
f0102d8a:	89 c3                	mov    %eax,%ebx
f0102d8c:	83 c4 10             	add    $0x10,%esp
f0102d8f:	85 c0                	test   %eax,%eax
f0102d91:	0f 84 e5 01 00 00    	je     f0102f7c <mem_init+0x1aca>
	//cprintf("%d\n",pp0->pp_ref);
	//cprintf("%d\n",pp1->pp_ref);
	//cprintf("%d\n",pp2->pp_ref);
	page_free(pp0);
f0102d97:	83 ec 0c             	sub    $0xc,%esp
f0102d9a:	56                   	push   %esi
f0102d9b:	e8 06 e4 ff ff       	call   f01011a6 <page_free>
	return (pp - pages) << PGSHIFT;
f0102da0:	89 f8                	mov    %edi,%eax
f0102da2:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102da8:	c1 f8 03             	sar    $0x3,%eax
f0102dab:	89 c2                	mov    %eax,%edx
f0102dad:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102db0:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102db5:	83 c4 10             	add    $0x10,%esp
f0102db8:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102dbe:	0f 83 d1 01 00 00    	jae    f0102f95 <mem_init+0x1ae3>
	memset(page2kva(pp1), 1, PGSIZE);
f0102dc4:	83 ec 04             	sub    $0x4,%esp
f0102dc7:	68 00 10 00 00       	push   $0x1000
f0102dcc:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102dce:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102dd4:	52                   	push   %edx
f0102dd5:	e8 01 2c 00 00       	call   f01059db <memset>
	return (pp - pages) << PGSHIFT;
f0102dda:	89 d8                	mov    %ebx,%eax
f0102ddc:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102de2:	c1 f8 03             	sar    $0x3,%eax
f0102de5:	89 c2                	mov    %eax,%edx
f0102de7:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102dea:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102def:	83 c4 10             	add    $0x10,%esp
f0102df2:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102df8:	0f 83 a9 01 00 00    	jae    f0102fa7 <mem_init+0x1af5>
	memset(page2kva(pp2), 2, PGSIZE);
f0102dfe:	83 ec 04             	sub    $0x4,%esp
f0102e01:	68 00 10 00 00       	push   $0x1000
f0102e06:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102e08:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102e0e:	52                   	push   %edx
f0102e0f:	e8 c7 2b 00 00       	call   f01059db <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102e14:	6a 02                	push   $0x2
f0102e16:	68 00 10 00 00       	push   $0x1000
f0102e1b:	57                   	push   %edi
f0102e1c:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102e22:	e8 ae e5 ff ff       	call   f01013d5 <page_insert>
	assert(pp1->pp_ref == 1);
f0102e27:	83 c4 20             	add    $0x20,%esp
f0102e2a:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102e2f:	0f 85 84 01 00 00    	jne    f0102fb9 <mem_init+0x1b07>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e35:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102e3c:	01 01 01 
f0102e3f:	0f 85 8d 01 00 00    	jne    f0102fd2 <mem_init+0x1b20>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102e45:	6a 02                	push   $0x2
f0102e47:	68 00 10 00 00       	push   $0x1000
f0102e4c:	53                   	push   %ebx
f0102e4d:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102e53:	e8 7d e5 ff ff       	call   f01013d5 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e58:	83 c4 10             	add    $0x10,%esp
f0102e5b:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102e62:	02 02 02 
f0102e65:	0f 85 80 01 00 00    	jne    f0102feb <mem_init+0x1b39>
	assert(pp2->pp_ref == 1);
f0102e6b:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102e70:	0f 85 8e 01 00 00    	jne    f0103004 <mem_init+0x1b52>
	assert(pp1->pp_ref == 0);
f0102e76:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102e7b:	0f 85 9c 01 00 00    	jne    f010301d <mem_init+0x1b6b>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102e81:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102e88:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102e8b:	89 d8                	mov    %ebx,%eax
f0102e8d:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102e93:	c1 f8 03             	sar    $0x3,%eax
f0102e96:	89 c2                	mov    %eax,%edx
f0102e98:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102e9b:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102ea0:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0102ea6:	0f 83 8a 01 00 00    	jae    f0103036 <mem_init+0x1b84>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102eac:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102eb3:	03 03 03 
f0102eb6:	0f 85 8c 01 00 00    	jne    f0103048 <mem_init+0x1b96>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102ebc:	83 ec 08             	sub    $0x8,%esp
f0102ebf:	68 00 10 00 00       	push   $0x1000
f0102ec4:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0102eca:	e8 bc e4 ff ff       	call   f010138b <page_remove>
	assert(pp2->pp_ref == 0);
f0102ecf:	83 c4 10             	add    $0x10,%esp
f0102ed2:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102ed7:	0f 85 84 01 00 00    	jne    f0103061 <mem_init+0x1baf>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102edd:	8b 0d 8c 7e 21 f0    	mov    0xf0217e8c,%ecx
f0102ee3:	8b 11                	mov    (%ecx),%edx
f0102ee5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102eeb:	89 f0                	mov    %esi,%eax
f0102eed:	2b 05 90 7e 21 f0    	sub    0xf0217e90,%eax
f0102ef3:	c1 f8 03             	sar    $0x3,%eax
f0102ef6:	c1 e0 0c             	shl    $0xc,%eax
f0102ef9:	39 c2                	cmp    %eax,%edx
f0102efb:	0f 85 79 01 00 00    	jne    f010307a <mem_init+0x1bc8>
	kern_pgdir[0] = 0;
f0102f01:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102f07:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102f0c:	0f 85 81 01 00 00    	jne    f0103093 <mem_init+0x1be1>
	pp0->pp_ref = 0;
f0102f12:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102f18:	83 ec 0c             	sub    $0xc,%esp
f0102f1b:	56                   	push   %esi
f0102f1c:	e8 85 e2 ff ff       	call   f01011a6 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102f21:	c7 04 24 9c 79 10 f0 	movl   $0xf010799c,(%esp)
f0102f28:	e8 ab 0b 00 00       	call   f0103ad8 <cprintf>
}
f0102f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f30:	5b                   	pop    %ebx
f0102f31:	5e                   	pop    %esi
f0102f32:	5f                   	pop    %edi
f0102f33:	5d                   	pop    %ebp
f0102f34:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f35:	50                   	push   %eax
f0102f36:	68 c8 66 10 f0       	push   $0xf01066c8
f0102f3b:	68 f2 00 00 00       	push   $0xf2
f0102f40:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102f45:	e8 f6 d0 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102f4a:	68 95 6e 10 f0       	push   $0xf0106e95
f0102f4f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102f54:	68 60 04 00 00       	push   $0x460
f0102f59:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102f5e:	e8 dd d0 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102f63:	68 ab 6e 10 f0       	push   $0xf0106eab
f0102f68:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102f6d:	68 61 04 00 00       	push   $0x461
f0102f72:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102f77:	e8 c4 d0 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102f7c:	68 c1 6e 10 f0       	push   $0xf0106ec1
f0102f81:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102f86:	68 62 04 00 00       	push   $0x462
f0102f8b:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102f90:	e8 ab d0 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f95:	52                   	push   %edx
f0102f96:	68 a4 66 10 f0       	push   $0xf01066a4
f0102f9b:	6a 58                	push   $0x58
f0102f9d:	68 97 6d 10 f0       	push   $0xf0106d97
f0102fa2:	e8 99 d0 ff ff       	call   f0100040 <_panic>
f0102fa7:	52                   	push   %edx
f0102fa8:	68 a4 66 10 f0       	push   $0xf01066a4
f0102fad:	6a 58                	push   $0x58
f0102faf:	68 97 6d 10 f0       	push   $0xf0106d97
f0102fb4:	e8 87 d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102fb9:	68 92 6f 10 f0       	push   $0xf0106f92
f0102fbe:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102fc3:	68 6a 04 00 00       	push   $0x46a
f0102fc8:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102fcd:	e8 6e d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102fd2:	68 28 79 10 f0       	push   $0xf0107928
f0102fd7:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102fdc:	68 6b 04 00 00       	push   $0x46b
f0102fe1:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102fe6:	e8 55 d0 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102feb:	68 4c 79 10 f0       	push   $0xf010794c
f0102ff0:	68 b1 6d 10 f0       	push   $0xf0106db1
f0102ff5:	68 6d 04 00 00       	push   $0x46d
f0102ffa:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0102fff:	e8 3c d0 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0103004:	68 b4 6f 10 f0       	push   $0xf0106fb4
f0103009:	68 b1 6d 10 f0       	push   $0xf0106db1
f010300e:	68 6e 04 00 00       	push   $0x46e
f0103013:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0103018:	e8 23 d0 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f010301d:	68 1e 70 10 f0       	push   $0xf010701e
f0103022:	68 b1 6d 10 f0       	push   $0xf0106db1
f0103027:	68 6f 04 00 00       	push   $0x46f
f010302c:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0103031:	e8 0a d0 ff ff       	call   f0100040 <_panic>
f0103036:	52                   	push   %edx
f0103037:	68 a4 66 10 f0       	push   $0xf01066a4
f010303c:	6a 58                	push   $0x58
f010303e:	68 97 6d 10 f0       	push   $0xf0106d97
f0103043:	e8 f8 cf ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103048:	68 70 79 10 f0       	push   $0xf0107970
f010304d:	68 b1 6d 10 f0       	push   $0xf0106db1
f0103052:	68 71 04 00 00       	push   $0x471
f0103057:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010305c:	e8 df cf ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0103061:	68 ec 6f 10 f0       	push   $0xf0106fec
f0103066:	68 b1 6d 10 f0       	push   $0xf0106db1
f010306b:	68 73 04 00 00       	push   $0x473
f0103070:	68 8b 6d 10 f0       	push   $0xf0106d8b
f0103075:	e8 c6 cf ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010307a:	68 f8 72 10 f0       	push   $0xf01072f8
f010307f:	68 b1 6d 10 f0       	push   $0xf0106db1
f0103084:	68 76 04 00 00       	push   $0x476
f0103089:	68 8b 6d 10 f0       	push   $0xf0106d8b
f010308e:	e8 ad cf ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0103093:	68 a3 6f 10 f0       	push   $0xf0106fa3
f0103098:	68 b1 6d 10 f0       	push   $0xf0106db1
f010309d:	68 78 04 00 00       	push   $0x478
f01030a2:	68 8b 6d 10 f0       	push   $0xf0106d8b
f01030a7:	e8 94 cf ff ff       	call   f0100040 <_panic>

f01030ac <user_mem_check>:
{
f01030ac:	f3 0f 1e fb          	endbr32 
f01030b0:	55                   	push   %ebp
f01030b1:	89 e5                	mov    %esp,%ebp
f01030b3:	57                   	push   %edi
f01030b4:	56                   	push   %esi
f01030b5:	53                   	push   %ebx
f01030b6:	83 ec 0c             	sub    $0xc,%esp
f01030b9:	8b 75 14             	mov    0x14(%ebp),%esi
	uint32_t begin=(uint32_t)ROUNDDOWN(va,PGSIZE);
f01030bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01030bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t end=(uint32_t)ROUNDUP(va+len,PGSIZE);
f01030c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01030c8:	03 7d 10             	add    0x10(%ebp),%edi
f01030cb:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f01030d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for(;begin<end;begin+=PGSIZE){
f01030d7:	eb 13                	jmp    f01030ec <user_mem_check+0x40>
				user_mem_check_addr=(uintptr_t)begin;
f01030d9:	89 1d 3c 72 21 f0    	mov    %ebx,0xf021723c
			return -E_FAULT;
f01030df:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f01030e4:	eb 48                	jmp    f010312e <user_mem_check+0x82>
	for(;begin<end;begin+=PGSIZE){
f01030e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01030ec:	39 fb                	cmp    %edi,%ebx
f01030ee:	73 46                	jae    f0103136 <user_mem_check+0x8a>
		page=pgdir_walk(env->env_pgdir,(void *)begin,0);
f01030f0:	83 ec 04             	sub    $0x4,%esp
f01030f3:	6a 00                	push   $0x0
f01030f5:	53                   	push   %ebx
f01030f6:	8b 45 08             	mov    0x8(%ebp),%eax
f01030f9:	ff 70 60             	pushl  0x60(%eax)
f01030fc:	e8 11 e1 ff ff       	call   f0101212 <pgdir_walk>
		if(!page||begin>=ULIM||!(*page & PTE_P) || ((*page & perm) != perm)) {
f0103101:	83 c4 10             	add    $0x10,%esp
f0103104:	85 c0                	test   %eax,%eax
f0103106:	74 14                	je     f010311c <user_mem_check+0x70>
f0103108:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010310e:	77 0c                	ja     f010311c <user_mem_check+0x70>
f0103110:	8b 00                	mov    (%eax),%eax
f0103112:	a8 01                	test   $0x1,%al
f0103114:	74 06                	je     f010311c <user_mem_check+0x70>
f0103116:	21 f0                	and    %esi,%eax
f0103118:	39 c6                	cmp    %eax,%esi
f010311a:	74 ca                	je     f01030e6 <user_mem_check+0x3a>
			if(begin<=(uint32_t)va)
f010311c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f010311f:	77 b8                	ja     f01030d9 <user_mem_check+0x2d>
				user_mem_check_addr=(uintptr_t)va;
f0103121:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103124:	a3 3c 72 21 f0       	mov    %eax,0xf021723c
			return -E_FAULT;
f0103129:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f010312e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103131:	5b                   	pop    %ebx
f0103132:	5e                   	pop    %esi
f0103133:	5f                   	pop    %edi
f0103134:	5d                   	pop    %ebp
f0103135:	c3                   	ret    
	return 0;
f0103136:	b8 00 00 00 00       	mov    $0x0,%eax
f010313b:	eb f1                	jmp    f010312e <user_mem_check+0x82>

f010313d <user_mem_assert>:
{
f010313d:	f3 0f 1e fb          	endbr32 
f0103141:	55                   	push   %ebp
f0103142:	89 e5                	mov    %esp,%ebp
f0103144:	53                   	push   %ebx
f0103145:	83 ec 04             	sub    $0x4,%esp
f0103148:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f010314b:	8b 45 14             	mov    0x14(%ebp),%eax
f010314e:	83 c8 04             	or     $0x4,%eax
f0103151:	50                   	push   %eax
f0103152:	ff 75 10             	pushl  0x10(%ebp)
f0103155:	ff 75 0c             	pushl  0xc(%ebp)
f0103158:	53                   	push   %ebx
f0103159:	e8 4e ff ff ff       	call   f01030ac <user_mem_check>
f010315e:	83 c4 10             	add    $0x10,%esp
f0103161:	85 c0                	test   %eax,%eax
f0103163:	78 05                	js     f010316a <user_mem_assert+0x2d>
}
f0103165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103168:	c9                   	leave  
f0103169:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f010316a:	83 ec 04             	sub    $0x4,%esp
f010316d:	ff 35 3c 72 21 f0    	pushl  0xf021723c
f0103173:	ff 73 48             	pushl  0x48(%ebx)
f0103176:	68 c8 79 10 f0       	push   $0xf01079c8
f010317b:	e8 58 09 00 00       	call   f0103ad8 <cprintf>
		env_destroy(env);	// may not return
f0103180:	89 1c 24             	mov    %ebx,(%esp)
f0103183:	e8 2b 06 00 00       	call   f01037b3 <env_destroy>
f0103188:	83 c4 10             	add    $0x10,%esp
}
f010318b:	eb d8                	jmp    f0103165 <user_mem_assert+0x28>

f010318d <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f010318d:	55                   	push   %ebp
f010318e:	89 e5                	mov    %esp,%ebp
f0103190:	57                   	push   %edi
f0103191:	56                   	push   %esi
f0103192:	53                   	push   %ebx
f0103193:	83 ec 0c             	sub    $0xc,%esp
f0103196:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	struct PageInfo *page=NULL;
	void *begin=(void *)ROUNDDOWN(va,PGSIZE);
f0103198:	89 d3                	mov    %edx,%ebx
f010319a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void *end=(void *)ROUNDUP(va+len,PGSIZE);
f01031a0:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f01031a7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	for(;begin<end;begin+=PGSIZE){
f01031ad:	39 f3                	cmp    %esi,%ebx
f01031af:	73 5a                	jae    f010320b <region_alloc+0x7e>
		if(!(page=page_alloc(0)))
f01031b1:	83 ec 0c             	sub    $0xc,%esp
f01031b4:	6a 00                	push   $0x0
f01031b6:	e8 72 df ff ff       	call   f010112d <page_alloc>
f01031bb:	83 c4 10             	add    $0x10,%esp
f01031be:	85 c0                	test   %eax,%eax
f01031c0:	74 1b                	je     f01031dd <region_alloc+0x50>
			panic("region_alloc:Alloc Failed!");
		if(page_insert(e->env_pgdir,page,begin,PTE_U|PTE_W))
f01031c2:	6a 06                	push   $0x6
f01031c4:	53                   	push   %ebx
f01031c5:	50                   	push   %eax
f01031c6:	ff 77 60             	pushl  0x60(%edi)
f01031c9:	e8 07 e2 ff ff       	call   f01013d5 <page_insert>
f01031ce:	83 c4 10             	add    $0x10,%esp
f01031d1:	85 c0                	test   %eax,%eax
f01031d3:	75 1f                	jne    f01031f4 <region_alloc+0x67>
	for(;begin<end;begin+=PGSIZE){
f01031d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01031db:	eb d0                	jmp    f01031ad <region_alloc+0x20>
			panic("region_alloc:Alloc Failed!");
f01031dd:	83 ec 04             	sub    $0x4,%esp
f01031e0:	68 fd 79 10 f0       	push   $0xf01079fd
f01031e5:	68 2c 01 00 00       	push   $0x12c
f01031ea:	68 18 7a 10 f0       	push   $0xf0107a18
f01031ef:	e8 4c ce ff ff       	call   f0100040 <_panic>
			panic("region_alloc:Page Mapping Failed!");
f01031f4:	83 ec 04             	sub    $0x4,%esp
f01031f7:	68 68 7a 10 f0       	push   $0xf0107a68
f01031fc:	68 2e 01 00 00       	push   $0x12e
f0103201:	68 18 7a 10 f0       	push   $0xf0107a18
f0103206:	e8 35 ce ff ff       	call   f0100040 <_panic>
	}
}
f010320b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010320e:	5b                   	pop    %ebx
f010320f:	5e                   	pop    %esi
f0103210:	5f                   	pop    %edi
f0103211:	5d                   	pop    %ebp
f0103212:	c3                   	ret    

f0103213 <envid2env>:
{
f0103213:	f3 0f 1e fb          	endbr32 
f0103217:	55                   	push   %ebp
f0103218:	89 e5                	mov    %esp,%ebp
f010321a:	56                   	push   %esi
f010321b:	53                   	push   %ebx
f010321c:	8b 75 08             	mov    0x8(%ebp),%esi
f010321f:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f0103222:	85 f6                	test   %esi,%esi
f0103224:	74 2e                	je     f0103254 <envid2env+0x41>
	e = &envs[ENVX(envid)];
f0103226:	89 f3                	mov    %esi,%ebx
f0103228:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010322e:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103231:	03 1d 48 72 21 f0    	add    0xf0217248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103237:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010323b:	74 2e                	je     f010326b <envid2env+0x58>
f010323d:	39 73 48             	cmp    %esi,0x48(%ebx)
f0103240:	75 29                	jne    f010326b <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103242:	84 c0                	test   %al,%al
f0103244:	75 35                	jne    f010327b <envid2env+0x68>
	*env_store = e;
f0103246:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103249:	89 18                	mov    %ebx,(%eax)
	return 0;
f010324b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103250:	5b                   	pop    %ebx
f0103251:	5e                   	pop    %esi
f0103252:	5d                   	pop    %ebp
f0103253:	c3                   	ret    
		*env_store = curenv;
f0103254:	e8 a1 2d 00 00       	call   f0105ffa <cpunum>
f0103259:	6b c0 74             	imul   $0x74,%eax,%eax
f010325c:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0103262:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103265:	89 02                	mov    %eax,(%edx)
		return 0;
f0103267:	89 f0                	mov    %esi,%eax
f0103269:	eb e5                	jmp    f0103250 <envid2env+0x3d>
		*env_store = 0;
f010326b:	8b 45 0c             	mov    0xc(%ebp),%eax
f010326e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103274:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103279:	eb d5                	jmp    f0103250 <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010327b:	e8 7a 2d 00 00       	call   f0105ffa <cpunum>
f0103280:	6b c0 74             	imul   $0x74,%eax,%eax
f0103283:	39 98 28 80 21 f0    	cmp    %ebx,-0xfde7fd8(%eax)
f0103289:	74 bb                	je     f0103246 <envid2env+0x33>
f010328b:	8b 73 4c             	mov    0x4c(%ebx),%esi
f010328e:	e8 67 2d 00 00       	call   f0105ffa <cpunum>
f0103293:	6b c0 74             	imul   $0x74,%eax,%eax
f0103296:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010329c:	3b 70 48             	cmp    0x48(%eax),%esi
f010329f:	74 a5                	je     f0103246 <envid2env+0x33>
		*env_store = 0;
f01032a1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01032a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01032aa:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01032af:	eb 9f                	jmp    f0103250 <envid2env+0x3d>

f01032b1 <env_init_percpu>:
{
f01032b1:	f3 0f 1e fb          	endbr32 
	asm volatile("lgdt (%0)" : : "r" (p));
f01032b5:	b8 20 33 12 f0       	mov    $0xf0123320,%eax
f01032ba:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01032bd:	b8 23 00 00 00       	mov    $0x23,%eax
f01032c2:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01032c4:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01032c6:	b8 10 00 00 00       	mov    $0x10,%eax
f01032cb:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01032cd:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01032cf:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01032d1:	ea d8 32 10 f0 08 00 	ljmp   $0x8,$0xf01032d8
	asm volatile("lldt %0" : : "r" (sel));
f01032d8:	b8 00 00 00 00       	mov    $0x0,%eax
f01032dd:	0f 00 d0             	lldt   %ax
}
f01032e0:	c3                   	ret    

f01032e1 <env_init>:
{
f01032e1:	f3 0f 1e fb          	endbr32 
f01032e5:	55                   	push   %ebp
f01032e6:	89 e5                	mov    %esp,%ebp
f01032e8:	56                   	push   %esi
f01032e9:	53                   	push   %ebx
		envs[counter].env_id=0;
f01032ea:	8b 35 48 72 21 f0    	mov    0xf0217248,%esi
f01032f0:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f01032f6:	89 f3                	mov    %esi,%ebx
f01032f8:	ba 00 00 00 00       	mov    $0x0,%edx
f01032fd:	89 d1                	mov    %edx,%ecx
f01032ff:	89 c2                	mov    %eax,%edx
f0103301:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[counter].env_status=ENV_FREE;
f0103308:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
		envs[counter].env_link=env_free_list;
f010330f:	89 48 44             	mov    %ecx,0x44(%eax)
f0103312:	83 e8 7c             	sub    $0x7c,%eax
	for(counter=NENV-1;counter>=0;counter--){
f0103315:	39 da                	cmp    %ebx,%edx
f0103317:	75 e4                	jne    f01032fd <env_init+0x1c>
f0103319:	89 35 4c 72 21 f0    	mov    %esi,0xf021724c
	env_init_percpu();
f010331f:	e8 8d ff ff ff       	call   f01032b1 <env_init_percpu>
}
f0103324:	5b                   	pop    %ebx
f0103325:	5e                   	pop    %esi
f0103326:	5d                   	pop    %ebp
f0103327:	c3                   	ret    

f0103328 <env_alloc>:
{
f0103328:	f3 0f 1e fb          	endbr32 
f010332c:	55                   	push   %ebp
f010332d:	89 e5                	mov    %esp,%ebp
f010332f:	53                   	push   %ebx
f0103330:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f0103333:	8b 1d 4c 72 21 f0    	mov    0xf021724c,%ebx
f0103339:	85 db                	test   %ebx,%ebx
f010333b:	0f 84 40 01 00 00    	je     f0103481 <env_alloc+0x159>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103341:	83 ec 0c             	sub    $0xc,%esp
f0103344:	6a 01                	push   $0x1
f0103346:	e8 e2 dd ff ff       	call   f010112d <page_alloc>
f010334b:	83 c4 10             	add    $0x10,%esp
f010334e:	85 c0                	test   %eax,%eax
f0103350:	0f 84 32 01 00 00    	je     f0103488 <env_alloc+0x160>
	return (pp - pages) << PGSHIFT;
f0103356:	89 c2                	mov    %eax,%edx
f0103358:	2b 15 90 7e 21 f0    	sub    0xf0217e90,%edx
f010335e:	c1 fa 03             	sar    $0x3,%edx
f0103361:	89 d1                	mov    %edx,%ecx
f0103363:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0103366:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
f010336c:	3b 15 88 7e 21 f0    	cmp    0xf0217e88,%edx
f0103372:	0f 83 e2 00 00 00    	jae    f010345a <env_alloc+0x132>
	return (void *)(pa + KERNBASE);
f0103378:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f010337e:	89 4b 60             	mov    %ecx,0x60(%ebx)
	p->pp_ref++;
f0103381:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103386:	83 ec 04             	sub    $0x4,%esp
f0103389:	68 00 10 00 00       	push   $0x1000
f010338e:	ff 35 8c 7e 21 f0    	pushl  0xf0217e8c
f0103394:	ff 73 60             	pushl  0x60(%ebx)
f0103397:	e8 f1 26 00 00       	call   f0105a8d <memcpy>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010339c:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010339f:	83 c4 10             	add    $0x10,%esp
f01033a2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01033a7:	0f 86 bf 00 00 00    	jbe    f010346c <env_alloc+0x144>
	return (physaddr_t)kva - KERNBASE;
f01033ad:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01033b3:	83 ca 05             	or     $0x5,%edx
f01033b6:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01033bc:	8b 43 48             	mov    0x48(%ebx),%eax
f01033bf:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f01033c4:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f01033c9:	ba 00 10 00 00       	mov    $0x1000,%edx
f01033ce:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01033d1:	89 da                	mov    %ebx,%edx
f01033d3:	2b 15 48 72 21 f0    	sub    0xf0217248,%edx
f01033d9:	c1 fa 02             	sar    $0x2,%edx
f01033dc:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01033e2:	09 d0                	or     %edx,%eax
f01033e4:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f01033e7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01033ea:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01033ed:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01033f4:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01033fb:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103402:	83 ec 04             	sub    $0x4,%esp
f0103405:	6a 44                	push   $0x44
f0103407:	6a 00                	push   $0x0
f0103409:	53                   	push   %ebx
f010340a:	e8 cc 25 00 00       	call   f01059db <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f010340f:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103415:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f010341b:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103421:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103428:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags|=FL_IF;
f010342e:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103435:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f010343c:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103440:	8b 43 44             	mov    0x44(%ebx),%eax
f0103443:	a3 4c 72 21 f0       	mov    %eax,0xf021724c
	*newenv_store = e;
f0103448:	8b 45 08             	mov    0x8(%ebp),%eax
f010344b:	89 18                	mov    %ebx,(%eax)
	return 0;
f010344d:	83 c4 10             	add    $0x10,%esp
f0103450:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103458:	c9                   	leave  
f0103459:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010345a:	51                   	push   %ecx
f010345b:	68 a4 66 10 f0       	push   $0xf01066a4
f0103460:	6a 58                	push   $0x58
f0103462:	68 97 6d 10 f0       	push   $0xf0106d97
f0103467:	e8 d4 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010346c:	50                   	push   %eax
f010346d:	68 c8 66 10 f0       	push   $0xf01066c8
f0103472:	68 c8 00 00 00       	push   $0xc8
f0103477:	68 18 7a 10 f0       	push   $0xf0107a18
f010347c:	e8 bf cb ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f0103481:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103486:	eb cd                	jmp    f0103455 <env_alloc+0x12d>
		return -E_NO_MEM;
f0103488:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010348d:	eb c6                	jmp    f0103455 <env_alloc+0x12d>

f010348f <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f010348f:	f3 0f 1e fb          	endbr32 
f0103493:	55                   	push   %ebp
f0103494:	89 e5                	mov    %esp,%ebp
f0103496:	57                   	push   %edi
f0103497:	56                   	push   %esi
f0103498:	53                   	push   %ebx
f0103499:	83 ec 34             	sub    $0x34,%esp
f010349c:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.
	struct Env *env;
	if(env_alloc(&env,0))
f010349f:	6a 00                	push   $0x0
f01034a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01034a4:	50                   	push   %eax
f01034a5:	e8 7e fe ff ff       	call   f0103328 <env_alloc>
f01034aa:	83 c4 10             	add    $0x10,%esp
f01034ad:	85 c0                	test   %eax,%eax
f01034af:	75 3d                	jne    f01034ee <env_create+0x5f>
		panic("env_create:env_alloc Failed!");
	load_icode(env,binary);
f01034b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	if(elf_header->e_magic!=ELF_MAGIC)
f01034b4:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f01034ba:	75 49                	jne    f0103505 <env_create+0x76>
	if(elf_header->e_entry==0)
f01034bc:	8b 46 18             	mov    0x18(%esi),%eax
f01034bf:	85 c0                	test   %eax,%eax
f01034c1:	74 59                	je     f010351c <env_create+0x8d>
	e->env_tf.tf_eip=elf_header->e_entry;
f01034c3:	89 47 30             	mov    %eax,0x30(%edi)
	ph=(struct Proghdr *)((uint8_t *)elf_header+elf_header->e_phoff);
f01034c6:	89 f3                	mov    %esi,%ebx
f01034c8:	03 5e 1c             	add    0x1c(%esi),%ebx
	eph=ph+elf_header->e_phnum;
f01034cb:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f01034cf:	c1 e0 05             	shl    $0x5,%eax
f01034d2:	01 d8                	add    %ebx,%eax
f01034d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	lcr3(PADDR(e->env_pgdir));//load env_pgdir to cr3
f01034d7:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01034da:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01034df:	76 52                	jbe    f0103533 <env_create+0xa4>
	return (physaddr_t)kva - KERNBASE;
f01034e1:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01034e6:	0f 22 d8             	mov    %eax,%cr3
}
f01034e9:	e9 95 00 00 00       	jmp    f0103583 <env_create+0xf4>
		panic("env_create:env_alloc Failed!");
f01034ee:	83 ec 04             	sub    $0x4,%esp
f01034f1:	68 23 7a 10 f0       	push   $0xf0107a23
f01034f6:	68 95 01 00 00       	push   $0x195
f01034fb:	68 18 7a 10 f0       	push   $0xf0107a18
f0103500:	e8 3b cb ff ff       	call   f0100040 <_panic>
		panic("load_icode:Illegal ELF Format!");
f0103505:	83 ec 04             	sub    $0x4,%esp
f0103508:	68 8c 7a 10 f0       	push   $0xf0107a8c
f010350d:	68 6a 01 00 00       	push   $0x16a
f0103512:	68 18 7a 10 f0       	push   $0xf0107a18
f0103517:	e8 24 cb ff ff       	call   f0100040 <_panic>
		panic("load_icode:Executed Failed!");
f010351c:	83 ec 04             	sub    $0x4,%esp
f010351f:	68 40 7a 10 f0       	push   $0xf0107a40
f0103524:	68 6c 01 00 00       	push   $0x16c
f0103529:	68 18 7a 10 f0       	push   $0xf0107a18
f010352e:	e8 0d cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103533:	50                   	push   %eax
f0103534:	68 c8 66 10 f0       	push   $0xf01066c8
f0103539:	68 72 01 00 00       	push   $0x172
f010353e:	68 18 7a 10 f0       	push   $0xf0107a18
f0103543:	e8 f8 ca ff ff       	call   f0100040 <_panic>
			region_alloc(e,(void *)ph->p_va,ph->p_memsz);
f0103548:	8b 53 08             	mov    0x8(%ebx),%edx
f010354b:	89 f8                	mov    %edi,%eax
f010354d:	e8 3b fc ff ff       	call   f010318d <region_alloc>
			memcpy((void *)ph->p_va,binary+ph->p_offset,ph->p_filesz);
f0103552:	83 ec 04             	sub    $0x4,%esp
f0103555:	ff 73 10             	pushl  0x10(%ebx)
f0103558:	89 f0                	mov    %esi,%eax
f010355a:	03 43 04             	add    0x4(%ebx),%eax
f010355d:	50                   	push   %eax
f010355e:	ff 73 08             	pushl  0x8(%ebx)
f0103561:	e8 27 25 00 00       	call   f0105a8d <memcpy>
			memset((void *)ph->p_va+ph->p_filesz,0,ph->p_memsz-ph->p_filesz);
f0103566:	8b 43 10             	mov    0x10(%ebx),%eax
f0103569:	83 c4 0c             	add    $0xc,%esp
f010356c:	8b 53 14             	mov    0x14(%ebx),%edx
f010356f:	29 c2                	sub    %eax,%edx
f0103571:	52                   	push   %edx
f0103572:	6a 00                	push   $0x0
f0103574:	03 43 08             	add    0x8(%ebx),%eax
f0103577:	50                   	push   %eax
f0103578:	e8 5e 24 00 00       	call   f01059db <memset>
f010357d:	83 c4 10             	add    $0x10,%esp
	for(;ph<eph;ph++){
f0103580:	83 c3 20             	add    $0x20,%ebx
f0103583:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0103586:	76 24                	jbe    f01035ac <env_create+0x11d>
		if(ph->p_type==ELF_PROG_LOAD){
f0103588:	83 3b 01             	cmpl   $0x1,(%ebx)
f010358b:	75 f3                	jne    f0103580 <env_create+0xf1>
			if(ph->p_filesz > ph->p_memsz)
f010358d:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103590:	39 4b 10             	cmp    %ecx,0x10(%ebx)
f0103593:	76 b3                	jbe    f0103548 <env_create+0xb9>
				panic("load_icode:Segment Out of Memory!");
f0103595:	83 ec 04             	sub    $0x4,%esp
f0103598:	68 ac 7a 10 f0       	push   $0xf0107aac
f010359d:	68 77 01 00 00       	push   $0x177
f01035a2:	68 18 7a 10 f0       	push   $0xf0107a18
f01035a7:	e8 94 ca ff ff       	call   f0100040 <_panic>
	region_alloc(e,(void *)USTACKTOP-PGSIZE,PGSIZE);
f01035ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01035b1:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01035b6:	89 f8                	mov    %edi,%eax
f01035b8:	e8 d0 fb ff ff       	call   f010318d <region_alloc>
	lcr3(PADDR(kern_pgdir));
f01035bd:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01035c2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035c7:	76 1e                	jbe    f01035e7 <env_create+0x158>
	return (physaddr_t)kva - KERNBASE;
f01035c9:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01035ce:	0f 22 d8             	mov    %eax,%cr3
	env->env_type=type;
f01035d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01035d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01035d7:	89 48 50             	mov    %ecx,0x50(%eax)

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if(type==ENV_TYPE_FS)
f01035da:	83 f9 01             	cmp    $0x1,%ecx
f01035dd:	74 1d                	je     f01035fc <env_create+0x16d>
		env->env_tf.tf_eflags|=FL_IOPL_MASK;
	
}
f01035df:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01035e2:	5b                   	pop    %ebx
f01035e3:	5e                   	pop    %esi
f01035e4:	5f                   	pop    %edi
f01035e5:	5d                   	pop    %ebp
f01035e6:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01035e7:	50                   	push   %eax
f01035e8:	68 c8 66 10 f0       	push   $0xf01066c8
f01035ed:	68 85 01 00 00       	push   $0x185
f01035f2:	68 18 7a 10 f0       	push   $0xf0107a18
f01035f7:	e8 44 ca ff ff       	call   f0100040 <_panic>
		env->env_tf.tf_eflags|=FL_IOPL_MASK;
f01035fc:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f0103603:	eb da                	jmp    f01035df <env_create+0x150>

f0103605 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103605:	f3 0f 1e fb          	endbr32 
f0103609:	55                   	push   %ebp
f010360a:	89 e5                	mov    %esp,%ebp
f010360c:	57                   	push   %edi
f010360d:	56                   	push   %esi
f010360e:	53                   	push   %ebx
f010360f:	83 ec 1c             	sub    $0x1c,%esp
f0103612:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103615:	e8 e0 29 00 00       	call   f0105ffa <cpunum>
f010361a:	6b c0 74             	imul   $0x74,%eax,%eax
f010361d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103624:	39 b8 28 80 21 f0    	cmp    %edi,-0xfde7fd8(%eax)
f010362a:	0f 85 b3 00 00 00    	jne    f01036e3 <env_free+0xde>
		lcr3(PADDR(kern_pgdir));
f0103630:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103635:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010363a:	76 14                	jbe    f0103650 <env_free+0x4b>
	return (physaddr_t)kva - KERNBASE;
f010363c:	05 00 00 00 10       	add    $0x10000000,%eax
f0103641:	0f 22 d8             	mov    %eax,%cr3
}
f0103644:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010364b:	e9 93 00 00 00       	jmp    f01036e3 <env_free+0xde>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103650:	50                   	push   %eax
f0103651:	68 c8 66 10 f0       	push   $0xf01066c8
f0103656:	68 ae 01 00 00       	push   $0x1ae
f010365b:	68 18 7a 10 f0       	push   $0xf0107a18
f0103660:	e8 db c9 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103665:	56                   	push   %esi
f0103666:	68 a4 66 10 f0       	push   $0xf01066a4
f010366b:	68 bd 01 00 00       	push   $0x1bd
f0103670:	68 18 7a 10 f0       	push   $0xf0107a18
f0103675:	e8 c6 c9 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010367a:	83 ec 08             	sub    $0x8,%esp
f010367d:	89 d8                	mov    %ebx,%eax
f010367f:	c1 e0 0c             	shl    $0xc,%eax
f0103682:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103685:	50                   	push   %eax
f0103686:	ff 77 60             	pushl  0x60(%edi)
f0103689:	e8 fd dc ff ff       	call   f010138b <page_remove>
f010368e:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103691:	83 c3 01             	add    $0x1,%ebx
f0103694:	83 c6 04             	add    $0x4,%esi
f0103697:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f010369d:	74 07                	je     f01036a6 <env_free+0xa1>
			if (pt[pteno] & PTE_P)
f010369f:	f6 06 01             	testb  $0x1,(%esi)
f01036a2:	74 ed                	je     f0103691 <env_free+0x8c>
f01036a4:	eb d4                	jmp    f010367a <env_free+0x75>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f01036a6:	8b 47 60             	mov    0x60(%edi),%eax
f01036a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01036ac:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01036b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01036b6:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f01036bc:	73 65                	jae    f0103723 <env_free+0x11e>
		page_decref(pa2page(pa));
f01036be:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01036c1:	a1 90 7e 21 f0       	mov    0xf0217e90,%eax
f01036c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01036c9:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f01036cc:	50                   	push   %eax
f01036cd:	e8 13 db ff ff       	call   f01011e5 <page_decref>
f01036d2:	83 c4 10             	add    $0x10,%esp
f01036d5:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f01036d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01036dc:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01036e1:	74 54                	je     f0103737 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f01036e3:	8b 47 60             	mov    0x60(%edi),%eax
f01036e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01036e9:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01036ec:	a8 01                	test   $0x1,%al
f01036ee:	74 e5                	je     f01036d5 <env_free+0xd0>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01036f0:	89 c6                	mov    %eax,%esi
f01036f2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f01036f8:	c1 e8 0c             	shr    $0xc,%eax
f01036fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01036fe:	39 05 88 7e 21 f0    	cmp    %eax,0xf0217e88
f0103704:	0f 86 5b ff ff ff    	jbe    f0103665 <env_free+0x60>
	return (void *)(pa + KERNBASE);
f010370a:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103710:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103713:	c1 e0 14             	shl    $0x14,%eax
f0103716:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103719:	bb 00 00 00 00       	mov    $0x0,%ebx
f010371e:	e9 7c ff ff ff       	jmp    f010369f <env_free+0x9a>
		panic("pa2page called with invalid pa");
f0103723:	83 ec 04             	sub    $0x4,%esp
f0103726:	68 a4 71 10 f0       	push   $0xf01071a4
f010372b:	6a 51                	push   $0x51
f010372d:	68 97 6d 10 f0       	push   $0xf0106d97
f0103732:	e8 09 c9 ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103737:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f010373a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010373f:	76 49                	jbe    f010378a <env_free+0x185>
	e->env_pgdir = 0;
f0103741:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103748:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f010374d:	c1 e8 0c             	shr    $0xc,%eax
f0103750:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0103756:	73 47                	jae    f010379f <env_free+0x19a>
	page_decref(pa2page(pa));
f0103758:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010375b:	8b 15 90 7e 21 f0    	mov    0xf0217e90,%edx
f0103761:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103764:	50                   	push   %eax
f0103765:	e8 7b da ff ff       	call   f01011e5 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f010376a:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103771:	a1 4c 72 21 f0       	mov    0xf021724c,%eax
f0103776:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103779:	89 3d 4c 72 21 f0    	mov    %edi,0xf021724c
}
f010377f:	83 c4 10             	add    $0x10,%esp
f0103782:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103785:	5b                   	pop    %ebx
f0103786:	5e                   	pop    %esi
f0103787:	5f                   	pop    %edi
f0103788:	5d                   	pop    %ebp
f0103789:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010378a:	50                   	push   %eax
f010378b:	68 c8 66 10 f0       	push   $0xf01066c8
f0103790:	68 cb 01 00 00       	push   $0x1cb
f0103795:	68 18 7a 10 f0       	push   $0xf0107a18
f010379a:	e8 a1 c8 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f010379f:	83 ec 04             	sub    $0x4,%esp
f01037a2:	68 a4 71 10 f0       	push   $0xf01071a4
f01037a7:	6a 51                	push   $0x51
f01037a9:	68 97 6d 10 f0       	push   $0xf0106d97
f01037ae:	e8 8d c8 ff ff       	call   f0100040 <_panic>

f01037b3 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f01037b3:	f3 0f 1e fb          	endbr32 
f01037b7:	55                   	push   %ebp
f01037b8:	89 e5                	mov    %esp,%ebp
f01037ba:	53                   	push   %ebx
f01037bb:	83 ec 04             	sub    $0x4,%esp
f01037be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01037c1:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f01037c5:	74 21                	je     f01037e8 <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f01037c7:	83 ec 0c             	sub    $0xc,%esp
f01037ca:	53                   	push   %ebx
f01037cb:	e8 35 fe ff ff       	call   f0103605 <env_free>

	if (curenv == e) {
f01037d0:	e8 25 28 00 00       	call   f0105ffa <cpunum>
f01037d5:	6b c0 74             	imul   $0x74,%eax,%eax
f01037d8:	83 c4 10             	add    $0x10,%esp
f01037db:	39 98 28 80 21 f0    	cmp    %ebx,-0xfde7fd8(%eax)
f01037e1:	74 1e                	je     f0103801 <env_destroy+0x4e>
		curenv = NULL;
		sched_yield();
	}
}
f01037e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01037e6:	c9                   	leave  
f01037e7:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01037e8:	e8 0d 28 00 00       	call   f0105ffa <cpunum>
f01037ed:	6b c0 74             	imul   $0x74,%eax,%eax
f01037f0:	39 98 28 80 21 f0    	cmp    %ebx,-0xfde7fd8(%eax)
f01037f6:	74 cf                	je     f01037c7 <env_destroy+0x14>
		e->env_status = ENV_DYING;
f01037f8:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f01037ff:	eb e2                	jmp    f01037e3 <env_destroy+0x30>
		curenv = NULL;
f0103801:	e8 f4 27 00 00       	call   f0105ffa <cpunum>
f0103806:	6b c0 74             	imul   $0x74,%eax,%eax
f0103809:	c7 80 28 80 21 f0 00 	movl   $0x0,-0xfde7fd8(%eax)
f0103810:	00 00 00 
		sched_yield();
f0103813:	e8 fc 0e 00 00       	call   f0104714 <sched_yield>

f0103818 <env_pop_tf>:
// This function does not return.
//

void
env_pop_tf(struct Trapframe *tf)
{
f0103818:	f3 0f 1e fb          	endbr32 
f010381c:	55                   	push   %ebp
f010381d:	89 e5                	mov    %esp,%ebp
f010381f:	53                   	push   %ebx
f0103820:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103823:	e8 d2 27 00 00       	call   f0105ffa <cpunum>
f0103828:	6b c0 74             	imul   $0x74,%eax,%eax
f010382b:	8b 98 28 80 21 f0    	mov    -0xfde7fd8(%eax),%ebx
f0103831:	e8 c4 27 00 00       	call   f0105ffa <cpunum>
f0103836:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103839:	8b 65 08             	mov    0x8(%ebp),%esp
f010383c:	61                   	popa   
f010383d:	07                   	pop    %es
f010383e:	1f                   	pop    %ds
f010383f:	83 c4 08             	add    $0x8,%esp
f0103842:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103843:	83 ec 04             	sub    $0x4,%esp
f0103846:	68 5c 7a 10 f0       	push   $0xf0107a5c
f010384b:	68 03 02 00 00       	push   $0x203
f0103850:	68 18 7a 10 f0       	push   $0xf0107a18
f0103855:	e8 e6 c7 ff ff       	call   f0100040 <_panic>

f010385a <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f010385a:	f3 0f 1e fb          	endbr32 
f010385e:	55                   	push   %ebp
f010385f:	89 e5                	mov    %esp,%ebp
f0103861:	83 ec 08             	sub    $0x8,%esp
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv&&curenv->env_status==ENV_RUNNING)
f0103864:	e8 91 27 00 00       	call   f0105ffa <cpunum>
f0103869:	6b c0 74             	imul   $0x74,%eax,%eax
f010386c:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f0103873:	74 14                	je     f0103889 <env_run+0x2f>
f0103875:	e8 80 27 00 00       	call   f0105ffa <cpunum>
f010387a:	6b c0 74             	imul   $0x74,%eax,%eax
f010387d:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0103883:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103887:	74 7d                	je     f0103906 <env_run+0xac>
		curenv->env_status=ENV_RUNNABLE;
	curenv=e;
f0103889:	e8 6c 27 00 00       	call   f0105ffa <cpunum>
f010388e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103891:	8b 55 08             	mov    0x8(%ebp),%edx
f0103894:	89 90 28 80 21 f0    	mov    %edx,-0xfde7fd8(%eax)
	curenv->env_status=ENV_RUNNING;
f010389a:	e8 5b 27 00 00       	call   f0105ffa <cpunum>
f010389f:	6b c0 74             	imul   $0x74,%eax,%eax
f01038a2:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01038a8:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	curenv->env_runs++;
f01038af:	e8 46 27 00 00       	call   f0105ffa <cpunum>
f01038b4:	6b c0 74             	imul   $0x74,%eax,%eax
f01038b7:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01038bd:	83 40 58 01          	addl   $0x1,0x58(%eax)
	lcr3(PADDR(curenv->env_pgdir));
f01038c1:	e8 34 27 00 00       	call   f0105ffa <cpunum>
f01038c6:	6b c0 74             	imul   $0x74,%eax,%eax
f01038c9:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01038cf:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01038d2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01038d7:	76 47                	jbe    f0103920 <env_run+0xc6>
	return (physaddr_t)kva - KERNBASE;
f01038d9:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01038de:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01038e1:	83 ec 0c             	sub    $0xc,%esp
f01038e4:	68 c0 33 12 f0       	push   $0xf01233c0
f01038e9:	e8 32 2a 00 00       	call   f0106320 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01038ee:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&curenv->env_tf); //to user mode
f01038f0:	e8 05 27 00 00       	call   f0105ffa <cpunum>
f01038f5:	83 c4 04             	add    $0x4,%esp
f01038f8:	6b c0 74             	imul   $0x74,%eax,%eax
f01038fb:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0103901:	e8 12 ff ff ff       	call   f0103818 <env_pop_tf>
		curenv->env_status=ENV_RUNNABLE;
f0103906:	e8 ef 26 00 00       	call   f0105ffa <cpunum>
f010390b:	6b c0 74             	imul   $0x74,%eax,%eax
f010390e:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0103914:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f010391b:	e9 69 ff ff ff       	jmp    f0103889 <env_run+0x2f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103920:	50                   	push   %eax
f0103921:	68 c8 66 10 f0       	push   $0xf01066c8
f0103926:	68 26 02 00 00       	push   $0x226
f010392b:	68 18 7a 10 f0       	push   $0xf0107a18
f0103930:	e8 0b c7 ff ff       	call   f0100040 <_panic>

f0103935 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103935:	f3 0f 1e fb          	endbr32 
f0103939:	55                   	push   %ebp
f010393a:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010393c:	8b 45 08             	mov    0x8(%ebp),%eax
f010393f:	ba 70 00 00 00       	mov    $0x70,%edx
f0103944:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103945:	ba 71 00 00 00       	mov    $0x71,%edx
f010394a:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010394b:	0f b6 c0             	movzbl %al,%eax
}
f010394e:	5d                   	pop    %ebp
f010394f:	c3                   	ret    

f0103950 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103950:	f3 0f 1e fb          	endbr32 
f0103954:	55                   	push   %ebp
f0103955:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103957:	8b 45 08             	mov    0x8(%ebp),%eax
f010395a:	ba 70 00 00 00       	mov    $0x70,%edx
f010395f:	ee                   	out    %al,(%dx)
f0103960:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103963:	ba 71 00 00 00       	mov    $0x71,%edx
f0103968:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103969:	5d                   	pop    %ebp
f010396a:	c3                   	ret    

f010396b <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010396b:	f3 0f 1e fb          	endbr32 
f010396f:	55                   	push   %ebp
f0103970:	89 e5                	mov    %esp,%ebp
f0103972:	56                   	push   %esi
f0103973:	53                   	push   %ebx
f0103974:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103977:	66 a3 a8 33 12 f0    	mov    %ax,0xf01233a8
	if (!didinit)
f010397d:	80 3d 50 72 21 f0 00 	cmpb   $0x0,0xf0217250
f0103984:	75 07                	jne    f010398d <irq_setmask_8259A+0x22>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0103986:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103989:	5b                   	pop    %ebx
f010398a:	5e                   	pop    %esi
f010398b:	5d                   	pop    %ebp
f010398c:	c3                   	ret    
f010398d:	89 c6                	mov    %eax,%esi
f010398f:	ba 21 00 00 00       	mov    $0x21,%edx
f0103994:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103995:	66 c1 e8 08          	shr    $0x8,%ax
f0103999:	ba a1 00 00 00       	mov    $0xa1,%edx
f010399e:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f010399f:	83 ec 0c             	sub    $0xc,%esp
f01039a2:	68 ce 7a 10 f0       	push   $0xf0107ace
f01039a7:	e8 2c 01 00 00       	call   f0103ad8 <cprintf>
f01039ac:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01039af:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01039b4:	0f b7 f6             	movzwl %si,%esi
f01039b7:	f7 d6                	not    %esi
f01039b9:	eb 19                	jmp    f01039d4 <irq_setmask_8259A+0x69>
			cprintf(" %d", i);
f01039bb:	83 ec 08             	sub    $0x8,%esp
f01039be:	53                   	push   %ebx
f01039bf:	68 6b 7f 10 f0       	push   $0xf0107f6b
f01039c4:	e8 0f 01 00 00       	call   f0103ad8 <cprintf>
f01039c9:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01039cc:	83 c3 01             	add    $0x1,%ebx
f01039cf:	83 fb 10             	cmp    $0x10,%ebx
f01039d2:	74 07                	je     f01039db <irq_setmask_8259A+0x70>
		if (~mask & (1<<i))
f01039d4:	0f a3 de             	bt     %ebx,%esi
f01039d7:	73 f3                	jae    f01039cc <irq_setmask_8259A+0x61>
f01039d9:	eb e0                	jmp    f01039bb <irq_setmask_8259A+0x50>
	cprintf("\n");
f01039db:	83 ec 0c             	sub    $0xc,%esp
f01039de:	68 87 70 10 f0       	push   $0xf0107087
f01039e3:	e8 f0 00 00 00       	call   f0103ad8 <cprintf>
f01039e8:	83 c4 10             	add    $0x10,%esp
f01039eb:	eb 99                	jmp    f0103986 <irq_setmask_8259A+0x1b>

f01039ed <pic_init>:
{
f01039ed:	f3 0f 1e fb          	endbr32 
f01039f1:	55                   	push   %ebp
f01039f2:	89 e5                	mov    %esp,%ebp
f01039f4:	57                   	push   %edi
f01039f5:	56                   	push   %esi
f01039f6:	53                   	push   %ebx
f01039f7:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f01039fa:	c6 05 50 72 21 f0 01 	movb   $0x1,0xf0217250
f0103a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103a06:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103a0b:	89 da                	mov    %ebx,%edx
f0103a0d:	ee                   	out    %al,(%dx)
f0103a0e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103a13:	89 ca                	mov    %ecx,%edx
f0103a15:	ee                   	out    %al,(%dx)
f0103a16:	bf 11 00 00 00       	mov    $0x11,%edi
f0103a1b:	be 20 00 00 00       	mov    $0x20,%esi
f0103a20:	89 f8                	mov    %edi,%eax
f0103a22:	89 f2                	mov    %esi,%edx
f0103a24:	ee                   	out    %al,(%dx)
f0103a25:	b8 20 00 00 00       	mov    $0x20,%eax
f0103a2a:	89 da                	mov    %ebx,%edx
f0103a2c:	ee                   	out    %al,(%dx)
f0103a2d:	b8 04 00 00 00       	mov    $0x4,%eax
f0103a32:	ee                   	out    %al,(%dx)
f0103a33:	b8 03 00 00 00       	mov    $0x3,%eax
f0103a38:	ee                   	out    %al,(%dx)
f0103a39:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103a3e:	89 f8                	mov    %edi,%eax
f0103a40:	89 da                	mov    %ebx,%edx
f0103a42:	ee                   	out    %al,(%dx)
f0103a43:	b8 28 00 00 00       	mov    $0x28,%eax
f0103a48:	89 ca                	mov    %ecx,%edx
f0103a4a:	ee                   	out    %al,(%dx)
f0103a4b:	b8 02 00 00 00       	mov    $0x2,%eax
f0103a50:	ee                   	out    %al,(%dx)
f0103a51:	b8 01 00 00 00       	mov    $0x1,%eax
f0103a56:	ee                   	out    %al,(%dx)
f0103a57:	bf 68 00 00 00       	mov    $0x68,%edi
f0103a5c:	89 f8                	mov    %edi,%eax
f0103a5e:	89 f2                	mov    %esi,%edx
f0103a60:	ee                   	out    %al,(%dx)
f0103a61:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0103a66:	89 c8                	mov    %ecx,%eax
f0103a68:	ee                   	out    %al,(%dx)
f0103a69:	89 f8                	mov    %edi,%eax
f0103a6b:	89 da                	mov    %ebx,%edx
f0103a6d:	ee                   	out    %al,(%dx)
f0103a6e:	89 c8                	mov    %ecx,%eax
f0103a70:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0103a71:	0f b7 05 a8 33 12 f0 	movzwl 0xf01233a8,%eax
f0103a78:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103a7c:	75 08                	jne    f0103a86 <pic_init+0x99>
}
f0103a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103a81:	5b                   	pop    %ebx
f0103a82:	5e                   	pop    %esi
f0103a83:	5f                   	pop    %edi
f0103a84:	5d                   	pop    %ebp
f0103a85:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0103a86:	83 ec 0c             	sub    $0xc,%esp
f0103a89:	0f b7 c0             	movzwl %ax,%eax
f0103a8c:	50                   	push   %eax
f0103a8d:	e8 d9 fe ff ff       	call   f010396b <irq_setmask_8259A>
f0103a92:	83 c4 10             	add    $0x10,%esp
}
f0103a95:	eb e7                	jmp    f0103a7e <pic_init+0x91>

f0103a97 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103a97:	f3 0f 1e fb          	endbr32 
f0103a9b:	55                   	push   %ebp
f0103a9c:	89 e5                	mov    %esp,%ebp
f0103a9e:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103aa1:	ff 75 08             	pushl  0x8(%ebp)
f0103aa4:	e8 00 cd ff ff       	call   f01007a9 <cputchar>
	*cnt++;
}
f0103aa9:	83 c4 10             	add    $0x10,%esp
f0103aac:	c9                   	leave  
f0103aad:	c3                   	ret    

f0103aae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103aae:	f3 0f 1e fb          	endbr32 
f0103ab2:	55                   	push   %ebp
f0103ab3:	89 e5                	mov    %esp,%ebp
f0103ab5:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103ab8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103abf:	ff 75 0c             	pushl  0xc(%ebp)
f0103ac2:	ff 75 08             	pushl  0x8(%ebp)
f0103ac5:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103ac8:	50                   	push   %eax
f0103ac9:	68 97 3a 10 f0       	push   $0xf0103a97
f0103ace:	e8 a5 17 00 00       	call   f0105278 <vprintfmt>
	return cnt;
}
f0103ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103ad6:	c9                   	leave  
f0103ad7:	c3                   	ret    

f0103ad8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103ad8:	f3 0f 1e fb          	endbr32 
f0103adc:	55                   	push   %ebp
f0103add:	89 e5                	mov    %esp,%ebp
f0103adf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103ae2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103ae5:	50                   	push   %eax
f0103ae6:	ff 75 08             	pushl  0x8(%ebp)
f0103ae9:	e8 c0 ff ff ff       	call   f0103aae <vcprintf>
	va_end(ap);

	return cnt;
}
f0103aee:	c9                   	leave  
f0103aef:	c3                   	ret    

f0103af0 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103af0:	f3 0f 1e fb          	endbr32 
f0103af4:	55                   	push   %ebp
f0103af5:	89 e5                	mov    %esp,%ebp
f0103af7:	56                   	push   %esi
f0103af8:	53                   	push   %ebx
	// LAB 4: Your code here:
	//struct Taskstate *this_ts=&thiscpu->cpu_ts;

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	struct Taskstate *thists = &thiscpu->cpu_ts;
f0103af9:	e8 fc 24 00 00       	call   f0105ffa <cpunum>
f0103afe:	6b f0 74             	imul   $0x74,%eax,%esi
f0103b01:	8d 9e 2c 80 21 f0    	lea    -0xfde7fd4(%esi),%ebx

	thists->ts_esp0 = KSTACKTOP - thiscpu->cpu_id * (KSTKSIZE + KSTKGAP);
f0103b07:	e8 ee 24 00 00       	call   f0105ffa <cpunum>
f0103b0c:	6b d0 74             	imul   $0x74,%eax,%edx
f0103b0f:	0f b6 8a 20 80 21 f0 	movzbl -0xfde7fe0(%edx),%ecx
f0103b16:	c1 e1 10             	shl    $0x10,%ecx
f0103b19:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103b1e:	29 ca                	sub    %ecx,%edx
f0103b20:	89 96 30 80 21 f0    	mov    %edx,-0xfde7fd0(%esi)
	thists->ts_ss0 = GD_KD;
f0103b26:	66 c7 86 34 80 21 f0 	movw   $0x10,-0xfde7fcc(%esi)
f0103b2d:	10 00 
	thists->ts_iomb = sizeof(struct Taskstate);
f0103b2f:	66 c7 86 92 80 21 f0 	movw   $0x68,-0xfde7f6e(%esi)
f0103b36:	68 00 

	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] =
f0103b38:	e8 bd 24 00 00       	call   f0105ffa <cpunum>
f0103b3d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b40:	0f b6 80 20 80 21 f0 	movzbl -0xfde7fe0(%eax),%eax
f0103b47:	83 c0 05             	add    $0x5,%eax
f0103b4a:	66 c7 04 c5 40 33 12 	movw   $0x67,-0xfedccc0(,%eax,8)
f0103b51:	f0 67 00 
f0103b54:	66 89 1c c5 42 33 12 	mov    %bx,-0xfedccbe(,%eax,8)
f0103b5b:	f0 
	SEG16(STS_T32A, (uint32_t) (thists), sizeof(struct Taskstate) - 1, 0);
f0103b5c:	89 da                	mov    %ebx,%edx
f0103b5e:	c1 ea 10             	shr    $0x10,%edx
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] =
f0103b61:	88 14 c5 44 33 12 f0 	mov    %dl,-0xfedccbc(,%eax,8)
f0103b68:	c6 04 c5 45 33 12 f0 	movb   $0x99,-0xfedccbb(,%eax,8)
f0103b6f:	99 
f0103b70:	c6 04 c5 46 33 12 f0 	movb   $0x40,-0xfedccba(,%eax,8)
f0103b77:	40 
	SEG16(STS_T32A, (uint32_t) (thists), sizeof(struct Taskstate) - 1, 0);
f0103b78:	c1 eb 18             	shr    $0x18,%ebx
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] =
f0103b7b:	88 1c c5 47 33 12 f0 	mov    %bl,-0xfedccb9(,%eax,8)
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id].sd_s = 0;
f0103b82:	e8 73 24 00 00       	call   f0105ffa <cpunum>
f0103b87:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b8a:	0f b6 80 20 80 21 f0 	movzbl -0xfde7fe0(%eax),%eax
f0103b91:	80 24 c5 6d 33 12 f0 	andb   $0xef,-0xfedcc93(,%eax,8)
f0103b98:	ef 

	ltr(GD_TSS0 + (thiscpu->cpu_id << 3));
f0103b99:	e8 5c 24 00 00       	call   f0105ffa <cpunum>
f0103b9e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ba1:	0f b6 80 20 80 21 f0 	movzbl -0xfde7fe0(%eax),%eax
f0103ba8:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
	asm volatile("ltr %0" : : "r" (sel));
f0103baf:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103bb2:	b8 ac 33 12 f0       	mov    $0xf01233ac,%eax
f0103bb7:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
f0103bba:	5b                   	pop    %ebx
f0103bbb:	5e                   	pop    %esi
f0103bbc:	5d                   	pop    %ebp
f0103bbd:	c3                   	ret    

f0103bbe <trap_init>:
{
f0103bbe:	f3 0f 1e fb          	endbr32 
f0103bc2:	55                   	push   %ebp
f0103bc3:	89 e5                	mov    %esp,%ebp
f0103bc5:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE],0,GD_KT,handler_divide,0);
f0103bc8:	b8 a8 45 10 f0       	mov    $0xf01045a8,%eax
f0103bcd:	66 a3 60 72 21 f0    	mov    %ax,0xf0217260
f0103bd3:	66 c7 05 62 72 21 f0 	movw   $0x8,0xf0217262
f0103bda:	08 00 
f0103bdc:	c6 05 64 72 21 f0 00 	movb   $0x0,0xf0217264
f0103be3:	c6 05 65 72 21 f0 8e 	movb   $0x8e,0xf0217265
f0103bea:	c1 e8 10             	shr    $0x10,%eax
f0103bed:	66 a3 66 72 21 f0    	mov    %ax,0xf0217266
	SETGATE(idt[T_DEBUG],0,GD_KT,handler_debug,0);
f0103bf3:	b8 b2 45 10 f0       	mov    $0xf01045b2,%eax
f0103bf8:	66 a3 68 72 21 f0    	mov    %ax,0xf0217268
f0103bfe:	66 c7 05 6a 72 21 f0 	movw   $0x8,0xf021726a
f0103c05:	08 00 
f0103c07:	c6 05 6c 72 21 f0 00 	movb   $0x0,0xf021726c
f0103c0e:	c6 05 6d 72 21 f0 8e 	movb   $0x8e,0xf021726d
f0103c15:	c1 e8 10             	shr    $0x10,%eax
f0103c18:	66 a3 6e 72 21 f0    	mov    %ax,0xf021726e
	SETGATE(idt[T_NMI],0,GD_KT,handler_nmi,3);
f0103c1e:	b8 b8 45 10 f0       	mov    $0xf01045b8,%eax
f0103c23:	66 a3 70 72 21 f0    	mov    %ax,0xf0217270
f0103c29:	66 c7 05 72 72 21 f0 	movw   $0x8,0xf0217272
f0103c30:	08 00 
f0103c32:	c6 05 74 72 21 f0 00 	movb   $0x0,0xf0217274
f0103c39:	c6 05 75 72 21 f0 ee 	movb   $0xee,0xf0217275
f0103c40:	c1 e8 10             	shr    $0x10,%eax
f0103c43:	66 a3 76 72 21 f0    	mov    %ax,0xf0217276
	SETGATE(idt[T_BRKPT],0,GD_KT,handler_brkpt,0);
f0103c49:	b8 be 45 10 f0       	mov    $0xf01045be,%eax
f0103c4e:	66 a3 78 72 21 f0    	mov    %ax,0xf0217278
f0103c54:	66 c7 05 7a 72 21 f0 	movw   $0x8,0xf021727a
f0103c5b:	08 00 
f0103c5d:	c6 05 7c 72 21 f0 00 	movb   $0x0,0xf021727c
f0103c64:	c6 05 7d 72 21 f0 8e 	movb   $0x8e,0xf021727d
f0103c6b:	c1 e8 10             	shr    $0x10,%eax
f0103c6e:	66 a3 7e 72 21 f0    	mov    %ax,0xf021727e
	SETGATE(idt[T_OFLOW],0,GD_KT,handler_oflow,0);
f0103c74:	b8 c4 45 10 f0       	mov    $0xf01045c4,%eax
f0103c79:	66 a3 80 72 21 f0    	mov    %ax,0xf0217280
f0103c7f:	66 c7 05 82 72 21 f0 	movw   $0x8,0xf0217282
f0103c86:	08 00 
f0103c88:	c6 05 84 72 21 f0 00 	movb   $0x0,0xf0217284
f0103c8f:	c6 05 85 72 21 f0 8e 	movb   $0x8e,0xf0217285
f0103c96:	c1 e8 10             	shr    $0x10,%eax
f0103c99:	66 a3 86 72 21 f0    	mov    %ax,0xf0217286
	SETGATE(idt[T_BOUND],0,GD_KT,handler_bound,0);
f0103c9f:	b8 ca 45 10 f0       	mov    $0xf01045ca,%eax
f0103ca4:	66 a3 88 72 21 f0    	mov    %ax,0xf0217288
f0103caa:	66 c7 05 8a 72 21 f0 	movw   $0x8,0xf021728a
f0103cb1:	08 00 
f0103cb3:	c6 05 8c 72 21 f0 00 	movb   $0x0,0xf021728c
f0103cba:	c6 05 8d 72 21 f0 8e 	movb   $0x8e,0xf021728d
f0103cc1:	c1 e8 10             	shr    $0x10,%eax
f0103cc4:	66 a3 8e 72 21 f0    	mov    %ax,0xf021728e
	SETGATE(idt[T_ILLOP],0,GD_KT,handler_illop,0);
f0103cca:	b8 d0 45 10 f0       	mov    $0xf01045d0,%eax
f0103ccf:	66 a3 90 72 21 f0    	mov    %ax,0xf0217290
f0103cd5:	66 c7 05 92 72 21 f0 	movw   $0x8,0xf0217292
f0103cdc:	08 00 
f0103cde:	c6 05 94 72 21 f0 00 	movb   $0x0,0xf0217294
f0103ce5:	c6 05 95 72 21 f0 8e 	movb   $0x8e,0xf0217295
f0103cec:	c1 e8 10             	shr    $0x10,%eax
f0103cef:	66 a3 96 72 21 f0    	mov    %ax,0xf0217296
	SETGATE(idt[T_DEVICE],0,GD_KT,handler_device,0);
f0103cf5:	b8 d6 45 10 f0       	mov    $0xf01045d6,%eax
f0103cfa:	66 a3 98 72 21 f0    	mov    %ax,0xf0217298
f0103d00:	66 c7 05 9a 72 21 f0 	movw   $0x8,0xf021729a
f0103d07:	08 00 
f0103d09:	c6 05 9c 72 21 f0 00 	movb   $0x0,0xf021729c
f0103d10:	c6 05 9d 72 21 f0 8e 	movb   $0x8e,0xf021729d
f0103d17:	c1 e8 10             	shr    $0x10,%eax
f0103d1a:	66 a3 9e 72 21 f0    	mov    %ax,0xf021729e
	SETGATE(idt[T_DBLFLT],0,GD_KT,handler_dblflt,0);
f0103d20:	b8 dc 45 10 f0       	mov    $0xf01045dc,%eax
f0103d25:	66 a3 a0 72 21 f0    	mov    %ax,0xf02172a0
f0103d2b:	66 c7 05 a2 72 21 f0 	movw   $0x8,0xf02172a2
f0103d32:	08 00 
f0103d34:	c6 05 a4 72 21 f0 00 	movb   $0x0,0xf02172a4
f0103d3b:	c6 05 a5 72 21 f0 8e 	movb   $0x8e,0xf02172a5
f0103d42:	c1 e8 10             	shr    $0x10,%eax
f0103d45:	66 a3 a6 72 21 f0    	mov    %ax,0xf02172a6
	SETGATE(idt[T_TSS],0,GD_KT,handler_tss,0);
f0103d4b:	b8 e0 45 10 f0       	mov    $0xf01045e0,%eax
f0103d50:	66 a3 b0 72 21 f0    	mov    %ax,0xf02172b0
f0103d56:	66 c7 05 b2 72 21 f0 	movw   $0x8,0xf02172b2
f0103d5d:	08 00 
f0103d5f:	c6 05 b4 72 21 f0 00 	movb   $0x0,0xf02172b4
f0103d66:	c6 05 b5 72 21 f0 8e 	movb   $0x8e,0xf02172b5
f0103d6d:	c1 e8 10             	shr    $0x10,%eax
f0103d70:	66 a3 b6 72 21 f0    	mov    %ax,0xf02172b6
	SETGATE(idt[T_SEGNP],0,GD_KT,handler_segnp,0);
f0103d76:	b8 e4 45 10 f0       	mov    $0xf01045e4,%eax
f0103d7b:	66 a3 b8 72 21 f0    	mov    %ax,0xf02172b8
f0103d81:	66 c7 05 ba 72 21 f0 	movw   $0x8,0xf02172ba
f0103d88:	08 00 
f0103d8a:	c6 05 bc 72 21 f0 00 	movb   $0x0,0xf02172bc
f0103d91:	c6 05 bd 72 21 f0 8e 	movb   $0x8e,0xf02172bd
f0103d98:	c1 e8 10             	shr    $0x10,%eax
f0103d9b:	66 a3 be 72 21 f0    	mov    %ax,0xf02172be
	SETGATE(idt[T_STACK],0,GD_KT,handler_stack,0);
f0103da1:	b8 e8 45 10 f0       	mov    $0xf01045e8,%eax
f0103da6:	66 a3 c0 72 21 f0    	mov    %ax,0xf02172c0
f0103dac:	66 c7 05 c2 72 21 f0 	movw   $0x8,0xf02172c2
f0103db3:	08 00 
f0103db5:	c6 05 c4 72 21 f0 00 	movb   $0x0,0xf02172c4
f0103dbc:	c6 05 c5 72 21 f0 8e 	movb   $0x8e,0xf02172c5
f0103dc3:	c1 e8 10             	shr    $0x10,%eax
f0103dc6:	66 a3 c6 72 21 f0    	mov    %ax,0xf02172c6
	SETGATE(idt[T_GPFLT],0,GD_KT,handler_gpflt,0);
f0103dcc:	b8 ec 45 10 f0       	mov    $0xf01045ec,%eax
f0103dd1:	66 a3 c8 72 21 f0    	mov    %ax,0xf02172c8
f0103dd7:	66 c7 05 ca 72 21 f0 	movw   $0x8,0xf02172ca
f0103dde:	08 00 
f0103de0:	c6 05 cc 72 21 f0 00 	movb   $0x0,0xf02172cc
f0103de7:	c6 05 cd 72 21 f0 8e 	movb   $0x8e,0xf02172cd
f0103dee:	c1 e8 10             	shr    $0x10,%eax
f0103df1:	66 a3 ce 72 21 f0    	mov    %ax,0xf02172ce
	SETGATE(idt[T_PGFLT],0,GD_KT,handler_pgflt,0);
f0103df7:	b8 f0 45 10 f0       	mov    $0xf01045f0,%eax
f0103dfc:	66 a3 d0 72 21 f0    	mov    %ax,0xf02172d0
f0103e02:	66 c7 05 d2 72 21 f0 	movw   $0x8,0xf02172d2
f0103e09:	08 00 
f0103e0b:	c6 05 d4 72 21 f0 00 	movb   $0x0,0xf02172d4
f0103e12:	c6 05 d5 72 21 f0 8e 	movb   $0x8e,0xf02172d5
f0103e19:	c1 e8 10             	shr    $0x10,%eax
f0103e1c:	66 a3 d6 72 21 f0    	mov    %ax,0xf02172d6
	SETGATE(idt[T_FPERR],0,GD_KT,handler_fperr,0);
f0103e22:	b8 f4 45 10 f0       	mov    $0xf01045f4,%eax
f0103e27:	66 a3 e0 72 21 f0    	mov    %ax,0xf02172e0
f0103e2d:	66 c7 05 e2 72 21 f0 	movw   $0x8,0xf02172e2
f0103e34:	08 00 
f0103e36:	c6 05 e4 72 21 f0 00 	movb   $0x0,0xf02172e4
f0103e3d:	c6 05 e5 72 21 f0 8e 	movb   $0x8e,0xf02172e5
f0103e44:	c1 e8 10             	shr    $0x10,%eax
f0103e47:	66 a3 e6 72 21 f0    	mov    %ax,0xf02172e6
	SETGATE(idt[T_ALIGN],0,GD_KT,handler_align,0);
f0103e4d:	b8 fa 45 10 f0       	mov    $0xf01045fa,%eax
f0103e52:	66 a3 e8 72 21 f0    	mov    %ax,0xf02172e8
f0103e58:	66 c7 05 ea 72 21 f0 	movw   $0x8,0xf02172ea
f0103e5f:	08 00 
f0103e61:	c6 05 ec 72 21 f0 00 	movb   $0x0,0xf02172ec
f0103e68:	c6 05 ed 72 21 f0 8e 	movb   $0x8e,0xf02172ed
f0103e6f:	c1 e8 10             	shr    $0x10,%eax
f0103e72:	66 a3 ee 72 21 f0    	mov    %ax,0xf02172ee
	SETGATE(idt[T_MCHK],0,GD_KT,handler_mchk,0);
f0103e78:	b8 fe 45 10 f0       	mov    $0xf01045fe,%eax
f0103e7d:	66 a3 f0 72 21 f0    	mov    %ax,0xf02172f0
f0103e83:	66 c7 05 f2 72 21 f0 	movw   $0x8,0xf02172f2
f0103e8a:	08 00 
f0103e8c:	c6 05 f4 72 21 f0 00 	movb   $0x0,0xf02172f4
f0103e93:	c6 05 f5 72 21 f0 8e 	movb   $0x8e,0xf02172f5
f0103e9a:	c1 e8 10             	shr    $0x10,%eax
f0103e9d:	66 a3 f6 72 21 f0    	mov    %ax,0xf02172f6
	SETGATE(idt[T_SIMDERR],0,GD_KT,handler_simderr,0);
f0103ea3:	b8 04 46 10 f0       	mov    $0xf0104604,%eax
f0103ea8:	66 a3 f8 72 21 f0    	mov    %ax,0xf02172f8
f0103eae:	66 c7 05 fa 72 21 f0 	movw   $0x8,0xf02172fa
f0103eb5:	08 00 
f0103eb7:	c6 05 fc 72 21 f0 00 	movb   $0x0,0xf02172fc
f0103ebe:	c6 05 fd 72 21 f0 8e 	movb   $0x8e,0xf02172fd
f0103ec5:	c1 e8 10             	shr    $0x10,%eax
f0103ec8:	66 a3 fe 72 21 f0    	mov    %ax,0xf02172fe
	SETGATE(idt[T_SYSCALL],0,GD_KT,handler_syscall,3);
f0103ece:	b8 0a 46 10 f0       	mov    $0xf010460a,%eax
f0103ed3:	66 a3 e0 73 21 f0    	mov    %ax,0xf02173e0
f0103ed9:	66 c7 05 e2 73 21 f0 	movw   $0x8,0xf02173e2
f0103ee0:	08 00 
f0103ee2:	c6 05 e4 73 21 f0 00 	movb   $0x0,0xf02173e4
f0103ee9:	c6 05 e5 73 21 f0 ee 	movb   $0xee,0xf02173e5
f0103ef0:	c1 e8 10             	shr    $0x10,%eax
f0103ef3:	66 a3 e6 73 21 f0    	mov    %ax,0xf02173e6
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER],0,GD_KT,handler_timer,0);
f0103ef9:	b8 10 46 10 f0       	mov    $0xf0104610,%eax
f0103efe:	66 a3 60 73 21 f0    	mov    %ax,0xf0217360
f0103f04:	66 c7 05 62 73 21 f0 	movw   $0x8,0xf0217362
f0103f0b:	08 00 
f0103f0d:	c6 05 64 73 21 f0 00 	movb   $0x0,0xf0217364
f0103f14:	c6 05 65 73 21 f0 8e 	movb   $0x8e,0xf0217365
f0103f1b:	c1 e8 10             	shr    $0x10,%eax
f0103f1e:	66 a3 66 73 21 f0    	mov    %ax,0xf0217366
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD],0,GD_KT,handler_kbd,0);
f0103f24:	b8 16 46 10 f0       	mov    $0xf0104616,%eax
f0103f29:	66 a3 68 73 21 f0    	mov    %ax,0xf0217368
f0103f2f:	66 c7 05 6a 73 21 f0 	movw   $0x8,0xf021736a
f0103f36:	08 00 
f0103f38:	c6 05 6c 73 21 f0 00 	movb   $0x0,0xf021736c
f0103f3f:	c6 05 6d 73 21 f0 8e 	movb   $0x8e,0xf021736d
f0103f46:	c1 e8 10             	shr    $0x10,%eax
f0103f49:	66 a3 6e 73 21 f0    	mov    %ax,0xf021736e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL],0,GD_KT,handler_serial,0);
f0103f4f:	b8 1c 46 10 f0       	mov    $0xf010461c,%eax
f0103f54:	66 a3 80 73 21 f0    	mov    %ax,0xf0217380
f0103f5a:	66 c7 05 82 73 21 f0 	movw   $0x8,0xf0217382
f0103f61:	08 00 
f0103f63:	c6 05 84 73 21 f0 00 	movb   $0x0,0xf0217384
f0103f6a:	c6 05 85 73 21 f0 8e 	movb   $0x8e,0xf0217385
f0103f71:	c1 e8 10             	shr    $0x10,%eax
f0103f74:	66 a3 86 73 21 f0    	mov    %ax,0xf0217386
	SETGATE(idt[IRQ_OFFSET+IRQ_SPURIOUS],0,GD_KT,handler_spurious,0);
f0103f7a:	b8 22 46 10 f0       	mov    $0xf0104622,%eax
f0103f7f:	66 a3 98 73 21 f0    	mov    %ax,0xf0217398
f0103f85:	66 c7 05 9a 73 21 f0 	movw   $0x8,0xf021739a
f0103f8c:	08 00 
f0103f8e:	c6 05 9c 73 21 f0 00 	movb   $0x0,0xf021739c
f0103f95:	c6 05 9d 73 21 f0 8e 	movb   $0x8e,0xf021739d
f0103f9c:	c1 e8 10             	shr    $0x10,%eax
f0103f9f:	66 a3 9e 73 21 f0    	mov    %ax,0xf021739e
	SETGATE(idt[IRQ_OFFSET+IRQ_IDE],0,GD_KT,handler_ide,0);
f0103fa5:	b8 28 46 10 f0       	mov    $0xf0104628,%eax
f0103faa:	66 a3 d0 73 21 f0    	mov    %ax,0xf02173d0
f0103fb0:	66 c7 05 d2 73 21 f0 	movw   $0x8,0xf02173d2
f0103fb7:	08 00 
f0103fb9:	c6 05 d4 73 21 f0 00 	movb   $0x0,0xf02173d4
f0103fc0:	c6 05 d5 73 21 f0 8e 	movb   $0x8e,0xf02173d5
f0103fc7:	c1 e8 10             	shr    $0x10,%eax
f0103fca:	66 a3 d6 73 21 f0    	mov    %ax,0xf02173d6
	SETGATE(idt[IRQ_OFFSET+IRQ_ERROR],0,GD_KT,handler_error,0);
f0103fd0:	b8 2e 46 10 f0       	mov    $0xf010462e,%eax
f0103fd5:	66 a3 f8 73 21 f0    	mov    %ax,0xf02173f8
f0103fdb:	66 c7 05 fa 73 21 f0 	movw   $0x8,0xf02173fa
f0103fe2:	08 00 
f0103fe4:	c6 05 fc 73 21 f0 00 	movb   $0x0,0xf02173fc
f0103feb:	c6 05 fd 73 21 f0 8e 	movb   $0x8e,0xf02173fd
f0103ff2:	c1 e8 10             	shr    $0x10,%eax
f0103ff5:	66 a3 fe 73 21 f0    	mov    %ax,0xf02173fe
	trap_init_percpu();
f0103ffb:	e8 f0 fa ff ff       	call   f0103af0 <trap_init_percpu>
}
f0104000:	c9                   	leave  
f0104001:	c3                   	ret    

f0104002 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0104002:	f3 0f 1e fb          	endbr32 
f0104006:	55                   	push   %ebp
f0104007:	89 e5                	mov    %esp,%ebp
f0104009:	53                   	push   %ebx
f010400a:	83 ec 0c             	sub    $0xc,%esp
f010400d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104010:	ff 33                	pushl  (%ebx)
f0104012:	68 e2 7a 10 f0       	push   $0xf0107ae2
f0104017:	e8 bc fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010401c:	83 c4 08             	add    $0x8,%esp
f010401f:	ff 73 04             	pushl  0x4(%ebx)
f0104022:	68 f1 7a 10 f0       	push   $0xf0107af1
f0104027:	e8 ac fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010402c:	83 c4 08             	add    $0x8,%esp
f010402f:	ff 73 08             	pushl  0x8(%ebx)
f0104032:	68 00 7b 10 f0       	push   $0xf0107b00
f0104037:	e8 9c fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010403c:	83 c4 08             	add    $0x8,%esp
f010403f:	ff 73 0c             	pushl  0xc(%ebx)
f0104042:	68 0f 7b 10 f0       	push   $0xf0107b0f
f0104047:	e8 8c fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010404c:	83 c4 08             	add    $0x8,%esp
f010404f:	ff 73 10             	pushl  0x10(%ebx)
f0104052:	68 1e 7b 10 f0       	push   $0xf0107b1e
f0104057:	e8 7c fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010405c:	83 c4 08             	add    $0x8,%esp
f010405f:	ff 73 14             	pushl  0x14(%ebx)
f0104062:	68 2d 7b 10 f0       	push   $0xf0107b2d
f0104067:	e8 6c fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010406c:	83 c4 08             	add    $0x8,%esp
f010406f:	ff 73 18             	pushl  0x18(%ebx)
f0104072:	68 3c 7b 10 f0       	push   $0xf0107b3c
f0104077:	e8 5c fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010407c:	83 c4 08             	add    $0x8,%esp
f010407f:	ff 73 1c             	pushl  0x1c(%ebx)
f0104082:	68 4b 7b 10 f0       	push   $0xf0107b4b
f0104087:	e8 4c fa ff ff       	call   f0103ad8 <cprintf>
}
f010408c:	83 c4 10             	add    $0x10,%esp
f010408f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104092:	c9                   	leave  
f0104093:	c3                   	ret    

f0104094 <print_trapframe>:
{
f0104094:	f3 0f 1e fb          	endbr32 
f0104098:	55                   	push   %ebp
f0104099:	89 e5                	mov    %esp,%ebp
f010409b:	56                   	push   %esi
f010409c:	53                   	push   %ebx
f010409d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01040a0:	e8 55 1f 00 00       	call   f0105ffa <cpunum>
f01040a5:	83 ec 04             	sub    $0x4,%esp
f01040a8:	50                   	push   %eax
f01040a9:	53                   	push   %ebx
f01040aa:	68 af 7b 10 f0       	push   $0xf0107baf
f01040af:	e8 24 fa ff ff       	call   f0103ad8 <cprintf>
	print_regs(&tf->tf_regs);
f01040b4:	89 1c 24             	mov    %ebx,(%esp)
f01040b7:	e8 46 ff ff ff       	call   f0104002 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01040bc:	83 c4 08             	add    $0x8,%esp
f01040bf:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01040c3:	50                   	push   %eax
f01040c4:	68 cd 7b 10 f0       	push   $0xf0107bcd
f01040c9:	e8 0a fa ff ff       	call   f0103ad8 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01040ce:	83 c4 08             	add    $0x8,%esp
f01040d1:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01040d5:	50                   	push   %eax
f01040d6:	68 e0 7b 10 f0       	push   $0xf0107be0
f01040db:	e8 f8 f9 ff ff       	call   f0103ad8 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01040e0:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01040e3:	83 c4 10             	add    $0x10,%esp
f01040e6:	83 f8 13             	cmp    $0x13,%eax
f01040e9:	0f 86 da 00 00 00    	jbe    f01041c9 <print_trapframe+0x135>
		return "System call";
f01040ef:	ba 5a 7b 10 f0       	mov    $0xf0107b5a,%edx
	if (trapno == T_SYSCALL)
f01040f4:	83 f8 30             	cmp    $0x30,%eax
f01040f7:	74 13                	je     f010410c <print_trapframe+0x78>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01040f9:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01040fc:	83 fa 0f             	cmp    $0xf,%edx
f01040ff:	ba 66 7b 10 f0       	mov    $0xf0107b66,%edx
f0104104:	b9 75 7b 10 f0       	mov    $0xf0107b75,%ecx
f0104109:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010410c:	83 ec 04             	sub    $0x4,%esp
f010410f:	52                   	push   %edx
f0104110:	50                   	push   %eax
f0104111:	68 f3 7b 10 f0       	push   $0xf0107bf3
f0104116:	e8 bd f9 ff ff       	call   f0103ad8 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010411b:	83 c4 10             	add    $0x10,%esp
f010411e:	39 1d 60 7a 21 f0    	cmp    %ebx,0xf0217a60
f0104124:	0f 84 ab 00 00 00    	je     f01041d5 <print_trapframe+0x141>
	cprintf("  err  0x%08x", tf->tf_err);
f010412a:	83 ec 08             	sub    $0x8,%esp
f010412d:	ff 73 2c             	pushl  0x2c(%ebx)
f0104130:	68 14 7c 10 f0       	push   $0xf0107c14
f0104135:	e8 9e f9 ff ff       	call   f0103ad8 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f010413a:	83 c4 10             	add    $0x10,%esp
f010413d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104141:	0f 85 b1 00 00 00    	jne    f01041f8 <print_trapframe+0x164>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104147:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f010414a:	a8 01                	test   $0x1,%al
f010414c:	b9 88 7b 10 f0       	mov    $0xf0107b88,%ecx
f0104151:	ba 93 7b 10 f0       	mov    $0xf0107b93,%edx
f0104156:	0f 44 ca             	cmove  %edx,%ecx
f0104159:	a8 02                	test   $0x2,%al
f010415b:	be 9f 7b 10 f0       	mov    $0xf0107b9f,%esi
f0104160:	ba a5 7b 10 f0       	mov    $0xf0107ba5,%edx
f0104165:	0f 45 d6             	cmovne %esi,%edx
f0104168:	a8 04                	test   $0x4,%al
f010416a:	b8 aa 7b 10 f0       	mov    $0xf0107baa,%eax
f010416f:	be df 7c 10 f0       	mov    $0xf0107cdf,%esi
f0104174:	0f 44 c6             	cmove  %esi,%eax
f0104177:	51                   	push   %ecx
f0104178:	52                   	push   %edx
f0104179:	50                   	push   %eax
f010417a:	68 22 7c 10 f0       	push   $0xf0107c22
f010417f:	e8 54 f9 ff ff       	call   f0103ad8 <cprintf>
f0104184:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104187:	83 ec 08             	sub    $0x8,%esp
f010418a:	ff 73 30             	pushl  0x30(%ebx)
f010418d:	68 31 7c 10 f0       	push   $0xf0107c31
f0104192:	e8 41 f9 ff ff       	call   f0103ad8 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104197:	83 c4 08             	add    $0x8,%esp
f010419a:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010419e:	50                   	push   %eax
f010419f:	68 40 7c 10 f0       	push   $0xf0107c40
f01041a4:	e8 2f f9 ff ff       	call   f0103ad8 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01041a9:	83 c4 08             	add    $0x8,%esp
f01041ac:	ff 73 38             	pushl  0x38(%ebx)
f01041af:	68 53 7c 10 f0       	push   $0xf0107c53
f01041b4:	e8 1f f9 ff ff       	call   f0103ad8 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01041b9:	83 c4 10             	add    $0x10,%esp
f01041bc:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01041c0:	75 4b                	jne    f010420d <print_trapframe+0x179>
}
f01041c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01041c5:	5b                   	pop    %ebx
f01041c6:	5e                   	pop    %esi
f01041c7:	5d                   	pop    %ebp
f01041c8:	c3                   	ret    
		return excnames[trapno];
f01041c9:	8b 14 85 80 7e 10 f0 	mov    -0xfef8180(,%eax,4),%edx
f01041d0:	e9 37 ff ff ff       	jmp    f010410c <print_trapframe+0x78>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01041d5:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01041d9:	0f 85 4b ff ff ff    	jne    f010412a <print_trapframe+0x96>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01041df:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01041e2:	83 ec 08             	sub    $0x8,%esp
f01041e5:	50                   	push   %eax
f01041e6:	68 05 7c 10 f0       	push   $0xf0107c05
f01041eb:	e8 e8 f8 ff ff       	call   f0103ad8 <cprintf>
f01041f0:	83 c4 10             	add    $0x10,%esp
f01041f3:	e9 32 ff ff ff       	jmp    f010412a <print_trapframe+0x96>
		cprintf("\n");
f01041f8:	83 ec 0c             	sub    $0xc,%esp
f01041fb:	68 87 70 10 f0       	push   $0xf0107087
f0104200:	e8 d3 f8 ff ff       	call   f0103ad8 <cprintf>
f0104205:	83 c4 10             	add    $0x10,%esp
f0104208:	e9 7a ff ff ff       	jmp    f0104187 <print_trapframe+0xf3>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010420d:	83 ec 08             	sub    $0x8,%esp
f0104210:	ff 73 3c             	pushl  0x3c(%ebx)
f0104213:	68 62 7c 10 f0       	push   $0xf0107c62
f0104218:	e8 bb f8 ff ff       	call   f0103ad8 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010421d:	83 c4 08             	add    $0x8,%esp
f0104220:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104224:	50                   	push   %eax
f0104225:	68 71 7c 10 f0       	push   $0xf0107c71
f010422a:	e8 a9 f8 ff ff       	call   f0103ad8 <cprintf>
f010422f:	83 c4 10             	add    $0x10,%esp
}
f0104232:	eb 8e                	jmp    f01041c2 <print_trapframe+0x12e>

f0104234 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104234:	f3 0f 1e fb          	endbr32 
f0104238:	55                   	push   %ebp
f0104239:	89 e5                	mov    %esp,%ebp
f010423b:	57                   	push   %edi
f010423c:	56                   	push   %esi
f010423d:	53                   	push   %ebx
f010423e:	83 ec 0c             	sub    $0xc,%esp
f0104241:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104244:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();
	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if((tf->tf_cs&0x01)==0)
f0104247:	f6 43 34 01          	testb  $0x1,0x34(%ebx)
f010424b:	74 5d                	je     f01042aa <page_fault_handler+0x76>
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.

	struct UTrapframe *utf;
	if(curenv->env_pgfault_upcall){
f010424d:	e8 a8 1d 00 00       	call   f0105ffa <cpunum>
f0104252:	6b c0 74             	imul   $0x74,%eax,%eax
f0104255:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010425b:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010425f:	75 60                	jne    f01042c1 <page_fault_handler+0x8d>
		env_run(curenv);
	}


	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104261:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104264:	e8 91 1d 00 00       	call   f0105ffa <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104269:	57                   	push   %edi
f010426a:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f010426b:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010426e:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104274:	ff 70 48             	pushl  0x48(%eax)
f0104277:	68 5c 7e 10 f0       	push   $0xf0107e5c
f010427c:	e8 57 f8 ff ff       	call   f0103ad8 <cprintf>
	print_trapframe(tf);
f0104281:	89 1c 24             	mov    %ebx,(%esp)
f0104284:	e8 0b fe ff ff       	call   f0104094 <print_trapframe>
	env_destroy(curenv);
f0104289:	e8 6c 1d 00 00       	call   f0105ffa <cpunum>
f010428e:	83 c4 04             	add    $0x4,%esp
f0104291:	6b c0 74             	imul   $0x74,%eax,%eax
f0104294:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f010429a:	e8 14 f5 ff ff       	call   f01037b3 <env_destroy>
}
f010429f:	83 c4 10             	add    $0x10,%esp
f01042a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01042a5:	5b                   	pop    %ebx
f01042a6:	5e                   	pop    %esi
f01042a7:	5f                   	pop    %edi
f01042a8:	5d                   	pop    %ebp
f01042a9:	c3                   	ret    
		panic("page_fault_handler:Page Fault in Kernel Mode!");
f01042aa:	83 ec 04             	sub    $0x4,%esp
f01042ad:	68 2c 7e 10 f0       	push   $0xf0107e2c
f01042b2:	68 5f 01 00 00       	push   $0x15f
f01042b7:	68 84 7c 10 f0       	push   $0xf0107c84
f01042bc:	e8 7f bd ff ff       	call   f0100040 <_panic>
		if(tf->tf_esp<UXSTACKTOP-1 && tf->tf_esp>=UXSTACKTOP-PGSIZE)
f01042c1:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01042c4:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			utf=(struct UTrapframe *)(UXSTACKTOP-sizeof(struct UTrapframe));
f01042ca:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if(tf->tf_esp<UXSTACKTOP-1 && tf->tf_esp>=UXSTACKTOP-PGSIZE)
f01042cf:	81 fa fe 0f 00 00    	cmp    $0xffe,%edx
f01042d5:	77 05                	ja     f01042dc <page_fault_handler+0xa8>
			utf=(struct UTrapframe *)(tf->tf_esp-sizeof(struct UTrapframe)-4);
f01042d7:	83 e8 38             	sub    $0x38,%eax
f01042da:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv,(const void *)utf,sizeof(struct UTrapframe),PTE_U|PTE_W|PTE_P);
f01042dc:	e8 19 1d 00 00       	call   f0105ffa <cpunum>
f01042e1:	6a 07                	push   $0x7
f01042e3:	6a 34                	push   $0x34
f01042e5:	57                   	push   %edi
f01042e6:	6b c0 74             	imul   $0x74,%eax,%eax
f01042e9:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01042ef:	e8 49 ee ff ff       	call   f010313d <user_mem_assert>
		utf->utf_fault_va=fault_va;
f01042f4:	89 fa                	mov    %edi,%edx
f01042f6:	89 37                	mov    %esi,(%edi)
		utf->utf_err=tf->tf_trapno;
f01042f8:	8b 43 28             	mov    0x28(%ebx),%eax
f01042fb:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs=tf->tf_regs;
f01042fe:	8d 7f 08             	lea    0x8(%edi),%edi
f0104301:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104306:	89 de                	mov    %ebx,%esi
f0104308:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip=tf->tf_eip;
f010430a:	8b 43 30             	mov    0x30(%ebx),%eax
f010430d:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags=tf->tf_eflags;
f0104310:	8b 43 38             	mov    0x38(%ebx),%eax
f0104313:	89 d7                	mov    %edx,%edi
f0104315:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp=tf->tf_esp;
f0104318:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010431b:	89 42 30             	mov    %eax,0x30(%edx)
		tf->tf_eip=(uintptr_t)curenv->env_pgfault_upcall;
f010431e:	e8 d7 1c 00 00       	call   f0105ffa <cpunum>
f0104323:	6b c0 74             	imul   $0x74,%eax,%eax
f0104326:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010432c:	8b 40 64             	mov    0x64(%eax),%eax
f010432f:	89 43 30             	mov    %eax,0x30(%ebx)
		tf->tf_esp=(uintptr_t)utf;
f0104332:	89 7b 3c             	mov    %edi,0x3c(%ebx)
		env_run(curenv);
f0104335:	e8 c0 1c 00 00       	call   f0105ffa <cpunum>
f010433a:	83 c4 04             	add    $0x4,%esp
f010433d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104340:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0104346:	e8 0f f5 ff ff       	call   f010385a <env_run>

f010434b <trap>:
{
f010434b:	f3 0f 1e fb          	endbr32 
f010434f:	55                   	push   %ebp
f0104350:	89 e5                	mov    %esp,%ebp
f0104352:	57                   	push   %edi
f0104353:	56                   	push   %esi
f0104354:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104357:	fc                   	cld    
	if (panicstr)
f0104358:	83 3d 80 7e 21 f0 00 	cmpl   $0x0,0xf0217e80
f010435f:	74 01                	je     f0104362 <trap+0x17>
		asm volatile("hlt");
f0104361:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104362:	e8 93 1c 00 00       	call   f0105ffa <cpunum>
f0104367:	6b d0 74             	imul   $0x74,%eax,%edx
f010436a:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f010436d:	b8 01 00 00 00       	mov    $0x1,%eax
f0104372:	f0 87 82 20 80 21 f0 	lock xchg %eax,-0xfde7fe0(%edx)
f0104379:	83 f8 02             	cmp    $0x2,%eax
f010437c:	74 7c                	je     f01043fa <trap+0xaf>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010437e:	9c                   	pushf  
f010437f:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104380:	f6 c4 02             	test   $0x2,%ah
f0104383:	0f 85 86 00 00 00    	jne    f010440f <trap+0xc4>
	if ((tf->tf_cs & 3) == 3) {
f0104389:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010438d:	83 e0 03             	and    $0x3,%eax
f0104390:	66 83 f8 03          	cmp    $0x3,%ax
f0104394:	0f 84 8e 00 00 00    	je     f0104428 <trap+0xdd>
	last_tf = tf;
f010439a:	89 35 60 7a 21 f0    	mov    %esi,0xf0217a60
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f01043a0:	8b 46 28             	mov    0x28(%esi),%eax
f01043a3:	83 f8 27             	cmp    $0x27,%eax
f01043a6:	0f 84 21 01 00 00    	je     f01044cd <trap+0x182>
	if(tf->tf_trapno==IRQ_OFFSET+IRQ_TIMER){
f01043ac:	83 f8 20             	cmp    $0x20,%eax
f01043af:	0f 84 32 01 00 00    	je     f01044e7 <trap+0x19c>
	switch(tf->tf_trapno){
f01043b5:	83 f8 21             	cmp    $0x21,%eax
f01043b8:	0f 84 81 01 00 00    	je     f010453f <trap+0x1f4>
f01043be:	0f 86 2d 01 00 00    	jbe    f01044f1 <trap+0x1a6>
f01043c4:	83 f8 24             	cmp    $0x24,%eax
f01043c7:	0f 84 79 01 00 00    	je     f0104546 <trap+0x1fb>
f01043cd:	83 f8 30             	cmp    $0x30,%eax
f01043d0:	0f 85 77 01 00 00    	jne    f010454d <trap+0x202>
			tf->tf_regs.reg_eax=syscall(tf->tf_regs.reg_eax,tf->tf_regs.reg_edx,tf->tf_regs.reg_ecx,tf->tf_regs.reg_ebx,tf->tf_regs.reg_edi,tf->tf_regs.reg_esi);
f01043d6:	83 ec 08             	sub    $0x8,%esp
f01043d9:	ff 76 04             	pushl  0x4(%esi)
f01043dc:	ff 36                	pushl  (%esi)
f01043de:	ff 76 10             	pushl  0x10(%esi)
f01043e1:	ff 76 18             	pushl  0x18(%esi)
f01043e4:	ff 76 14             	pushl  0x14(%esi)
f01043e7:	ff 76 1c             	pushl  0x1c(%esi)
f01043ea:	e8 ff 03 00 00       	call   f01047ee <syscall>
f01043ef:	89 46 1c             	mov    %eax,0x1c(%esi)
			break;
f01043f2:	83 c4 20             	add    $0x20,%esp
f01043f5:	e9 0d 01 00 00       	jmp    f0104507 <trap+0x1bc>
	spin_lock(&kernel_lock);
f01043fa:	83 ec 0c             	sub    $0xc,%esp
f01043fd:	68 c0 33 12 f0       	push   $0xf01233c0
f0104402:	e8 7b 1e 00 00       	call   f0106282 <spin_lock>
}
f0104407:	83 c4 10             	add    $0x10,%esp
f010440a:	e9 6f ff ff ff       	jmp    f010437e <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f010440f:	68 90 7c 10 f0       	push   $0xf0107c90
f0104414:	68 b1 6d 10 f0       	push   $0xf0106db1
f0104419:	68 2b 01 00 00       	push   $0x12b
f010441e:	68 84 7c 10 f0       	push   $0xf0107c84
f0104423:	e8 18 bc ff ff       	call   f0100040 <_panic>
		assert(curenv);
f0104428:	e8 cd 1b 00 00       	call   f0105ffa <cpunum>
f010442d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104430:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f0104437:	74 4e                	je     f0104487 <trap+0x13c>
	spin_lock(&kernel_lock);
f0104439:	83 ec 0c             	sub    $0xc,%esp
f010443c:	68 c0 33 12 f0       	push   $0xf01233c0
f0104441:	e8 3c 1e 00 00       	call   f0106282 <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f0104446:	e8 af 1b 00 00       	call   f0105ffa <cpunum>
f010444b:	6b c0 74             	imul   $0x74,%eax,%eax
f010444e:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104454:	83 c4 10             	add    $0x10,%esp
f0104457:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010445b:	74 43                	je     f01044a0 <trap+0x155>
		curenv->env_tf = *tf;
f010445d:	e8 98 1b 00 00       	call   f0105ffa <cpunum>
f0104462:	6b c0 74             	imul   $0x74,%eax,%eax
f0104465:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010446b:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104470:	89 c7                	mov    %eax,%edi
f0104472:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104474:	e8 81 1b 00 00       	call   f0105ffa <cpunum>
f0104479:	6b c0 74             	imul   $0x74,%eax,%eax
f010447c:	8b b0 28 80 21 f0    	mov    -0xfde7fd8(%eax),%esi
f0104482:	e9 13 ff ff ff       	jmp    f010439a <trap+0x4f>
		assert(curenv);
f0104487:	68 a9 7c 10 f0       	push   $0xf0107ca9
f010448c:	68 b1 6d 10 f0       	push   $0xf0106db1
f0104491:	68 32 01 00 00       	push   $0x132
f0104496:	68 84 7c 10 f0       	push   $0xf0107c84
f010449b:	e8 a0 bb ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f01044a0:	e8 55 1b 00 00       	call   f0105ffa <cpunum>
f01044a5:	83 ec 0c             	sub    $0xc,%esp
f01044a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01044ab:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01044b1:	e8 4f f1 ff ff       	call   f0103605 <env_free>
			curenv = NULL;
f01044b6:	e8 3f 1b 00 00       	call   f0105ffa <cpunum>
f01044bb:	6b c0 74             	imul   $0x74,%eax,%eax
f01044be:	c7 80 28 80 21 f0 00 	movl   $0x0,-0xfde7fd8(%eax)
f01044c5:	00 00 00 
			sched_yield();
f01044c8:	e8 47 02 00 00       	call   f0104714 <sched_yield>
		cprintf("Spurious interrupt on irq 7\n");
f01044cd:	83 ec 0c             	sub    $0xc,%esp
f01044d0:	68 b0 7c 10 f0       	push   $0xf0107cb0
f01044d5:	e8 fe f5 ff ff       	call   f0103ad8 <cprintf>
		print_trapframe(tf);
f01044da:	89 34 24             	mov    %esi,(%esp)
f01044dd:	e8 b2 fb ff ff       	call   f0104094 <print_trapframe>
		return;
f01044e2:	83 c4 10             	add    $0x10,%esp
f01044e5:	eb 20                	jmp    f0104507 <trap+0x1bc>
		lapic_eoi();
f01044e7:	e8 5d 1c 00 00       	call   f0106149 <lapic_eoi>
		sched_yield();
f01044ec:	e8 23 02 00 00       	call   f0104714 <sched_yield>
	switch(tf->tf_trapno){
f01044f1:	83 f8 03             	cmp    $0x3,%eax
f01044f4:	74 3b                	je     f0104531 <trap+0x1e6>
f01044f6:	83 f8 0e             	cmp    $0xe,%eax
f01044f9:	75 52                	jne    f010454d <trap+0x202>
			page_fault_handler(tf);
f01044fb:	83 ec 0c             	sub    $0xc,%esp
f01044fe:	56                   	push   %esi
f01044ff:	e8 30 fd ff ff       	call   f0104234 <page_fault_handler>
			break;
f0104504:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104507:	e8 ee 1a 00 00       	call   f0105ffa <cpunum>
f010450c:	6b c0 74             	imul   $0x74,%eax,%eax
f010450f:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f0104516:	74 14                	je     f010452c <trap+0x1e1>
f0104518:	e8 dd 1a 00 00       	call   f0105ffa <cpunum>
f010451d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104520:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104526:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010452a:	74 66                	je     f0104592 <trap+0x247>
		sched_yield();
f010452c:	e8 e3 01 00 00       	call   f0104714 <sched_yield>
			monitor(tf);
f0104531:	83 ec 0c             	sub    $0xc,%esp
f0104534:	56                   	push   %esi
f0104535:	e8 d1 c5 ff ff       	call   f0100b0b <monitor>
			break;
f010453a:	83 c4 10             	add    $0x10,%esp
f010453d:	eb c8                	jmp    f0104507 <trap+0x1bc>
			kbd_intr();
f010453f:	e8 b9 c0 ff ff       	call   f01005fd <kbd_intr>
			break;
f0104544:	eb c1                	jmp    f0104507 <trap+0x1bc>
			serial_intr();
f0104546:	e8 92 c0 ff ff       	call   f01005dd <serial_intr>
			break;		
f010454b:	eb ba                	jmp    f0104507 <trap+0x1bc>
			print_trapframe(tf);
f010454d:	83 ec 0c             	sub    $0xc,%esp
f0104550:	56                   	push   %esi
f0104551:	e8 3e fb ff ff       	call   f0104094 <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104556:	83 c4 10             	add    $0x10,%esp
f0104559:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f010455e:	74 1b                	je     f010457b <trap+0x230>
				env_destroy(curenv);
f0104560:	e8 95 1a 00 00       	call   f0105ffa <cpunum>
f0104565:	83 ec 0c             	sub    $0xc,%esp
f0104568:	6b c0 74             	imul   $0x74,%eax,%eax
f010456b:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0104571:	e8 3d f2 ff ff       	call   f01037b3 <env_destroy>
				return;
f0104576:	83 c4 10             	add    $0x10,%esp
f0104579:	eb 8c                	jmp    f0104507 <trap+0x1bc>
				panic("unhandled trap in kernel");
f010457b:	83 ec 04             	sub    $0x4,%esp
f010457e:	68 cd 7c 10 f0       	push   $0xf0107ccd
f0104583:	68 10 01 00 00       	push   $0x110
f0104588:	68 84 7c 10 f0       	push   $0xf0107c84
f010458d:	e8 ae ba ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104592:	e8 63 1a 00 00       	call   f0105ffa <cpunum>
f0104597:	83 ec 0c             	sub    $0xc,%esp
f010459a:	6b c0 74             	imul   $0x74,%eax,%eax
f010459d:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01045a3:	e8 b2 f2 ff ff       	call   f010385a <env_run>

f01045a8 <handler_divide>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(handler_divide, T_DIVIDE)
f01045a8:	6a 00                	push   $0x0
f01045aa:	6a 00                	push   $0x0
f01045ac:	e9 83 00 00 00       	jmp    f0104634 <_alltraps>
f01045b1:	90                   	nop

f01045b2 <handler_debug>:
TRAPHANDLER_NOEC(handler_debug,T_DEBUG)//1
f01045b2:	6a 00                	push   $0x0
f01045b4:	6a 01                	push   $0x1
f01045b6:	eb 7c                	jmp    f0104634 <_alltraps>

f01045b8 <handler_nmi>:
TRAPHANDLER_NOEC(handler_nmi,T_NMI)//2
f01045b8:	6a 00                	push   $0x0
f01045ba:	6a 02                	push   $0x2
f01045bc:	eb 76                	jmp    f0104634 <_alltraps>

f01045be <handler_brkpt>:
TRAPHANDLER_NOEC(handler_brkpt,T_BRKPT)//3
f01045be:	6a 00                	push   $0x0
f01045c0:	6a 03                	push   $0x3
f01045c2:	eb 70                	jmp    f0104634 <_alltraps>

f01045c4 <handler_oflow>:
TRAPHANDLER_NOEC(handler_oflow,T_OFLOW)//4
f01045c4:	6a 00                	push   $0x0
f01045c6:	6a 04                	push   $0x4
f01045c8:	eb 6a                	jmp    f0104634 <_alltraps>

f01045ca <handler_bound>:
TRAPHANDLER_NOEC(handler_bound,T_BOUND)//5
f01045ca:	6a 00                	push   $0x0
f01045cc:	6a 05                	push   $0x5
f01045ce:	eb 64                	jmp    f0104634 <_alltraps>

f01045d0 <handler_illop>:
TRAPHANDLER_NOEC(handler_illop,T_ILLOP)//6
f01045d0:	6a 00                	push   $0x0
f01045d2:	6a 06                	push   $0x6
f01045d4:	eb 5e                	jmp    f0104634 <_alltraps>

f01045d6 <handler_device>:
TRAPHANDLER_NOEC(handler_device,T_DEVICE)//7
f01045d6:	6a 00                	push   $0x0
f01045d8:	6a 07                	push   $0x7
f01045da:	eb 58                	jmp    f0104634 <_alltraps>

f01045dc <handler_dblflt>:
TRAPHANDLER(handler_dblflt,T_DBLFLT)//8
f01045dc:	6a 08                	push   $0x8
f01045de:	eb 54                	jmp    f0104634 <_alltraps>

f01045e0 <handler_tss>:
//9-reserved (not generated by recent processors)
TRAPHANDLER(handler_tss,T_TSS)//10
f01045e0:	6a 0a                	push   $0xa
f01045e2:	eb 50                	jmp    f0104634 <_alltraps>

f01045e4 <handler_segnp>:
TRAPHANDLER(handler_segnp,T_SEGNP)//11
f01045e4:	6a 0b                	push   $0xb
f01045e6:	eb 4c                	jmp    f0104634 <_alltraps>

f01045e8 <handler_stack>:
TRAPHANDLER(handler_stack,T_STACK)//12
f01045e8:	6a 0c                	push   $0xc
f01045ea:	eb 48                	jmp    f0104634 <_alltraps>

f01045ec <handler_gpflt>:
TRAPHANDLER(handler_gpflt,T_GPFLT)//13
f01045ec:	6a 0d                	push   $0xd
f01045ee:	eb 44                	jmp    f0104634 <_alltraps>

f01045f0 <handler_pgflt>:
TRAPHANDLER(handler_pgflt,T_PGFLT)//14
f01045f0:	6a 0e                	push   $0xe
f01045f2:	eb 40                	jmp    f0104634 <_alltraps>

f01045f4 <handler_fperr>:
//15-reserved
TRAPHANDLER_NOEC(handler_fperr,T_FPERR)//16
f01045f4:	6a 00                	push   $0x0
f01045f6:	6a 10                	push   $0x10
f01045f8:	eb 3a                	jmp    f0104634 <_alltraps>

f01045fa <handler_align>:
TRAPHANDLER(handler_align,T_ALIGN)//17
f01045fa:	6a 11                	push   $0x11
f01045fc:	eb 36                	jmp    f0104634 <_alltraps>

f01045fe <handler_mchk>:
TRAPHANDLER_NOEC(handler_mchk,T_MCHK)//18
f01045fe:	6a 00                	push   $0x0
f0104600:	6a 12                	push   $0x12
f0104602:	eb 30                	jmp    f0104634 <_alltraps>

f0104604 <handler_simderr>:
TRAPHANDLER_NOEC(handler_simderr,T_SIMDERR)
f0104604:	6a 00                	push   $0x0
f0104606:	6a 13                	push   $0x13
f0104608:	eb 2a                	jmp    f0104634 <_alltraps>

f010460a <handler_syscall>:
TRAPHANDLER_NOEC(handler_syscall,T_SYSCALL)//48
f010460a:	6a 00                	push   $0x0
f010460c:	6a 30                	push   $0x30
f010460e:	eb 24                	jmp    f0104634 <_alltraps>

f0104610 <handler_timer>:

TRAPHANDLER_NOEC(handler_timer,IRQ_OFFSET+IRQ_TIMER)
f0104610:	6a 00                	push   $0x0
f0104612:	6a 20                	push   $0x20
f0104614:	eb 1e                	jmp    f0104634 <_alltraps>

f0104616 <handler_kbd>:
TRAPHANDLER_NOEC(handler_kbd,IRQ_OFFSET+IRQ_KBD)
f0104616:	6a 00                	push   $0x0
f0104618:	6a 21                	push   $0x21
f010461a:	eb 18                	jmp    f0104634 <_alltraps>

f010461c <handler_serial>:
TRAPHANDLER_NOEC(handler_serial,IRQ_OFFSET+IRQ_SERIAL)
f010461c:	6a 00                	push   $0x0
f010461e:	6a 24                	push   $0x24
f0104620:	eb 12                	jmp    f0104634 <_alltraps>

f0104622 <handler_spurious>:
TRAPHANDLER_NOEC(handler_spurious,IRQ_OFFSET+IRQ_SPURIOUS)
f0104622:	6a 00                	push   $0x0
f0104624:	6a 27                	push   $0x27
f0104626:	eb 0c                	jmp    f0104634 <_alltraps>

f0104628 <handler_ide>:
TRAPHANDLER_NOEC(handler_ide,IRQ_OFFSET+IRQ_IDE)
f0104628:	6a 00                	push   $0x0
f010462a:	6a 2e                	push   $0x2e
f010462c:	eb 06                	jmp    f0104634 <_alltraps>

f010462e <handler_error>:
TRAPHANDLER_NOEC(handler_error,IRQ_OFFSET+IRQ_ERROR)
f010462e:	6a 00                	push   $0x0
f0104630:	6a 33                	push   $0x33
f0104632:	eb 00                	jmp    f0104634 <_alltraps>

f0104634 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
	pushl %ds
f0104634:	1e                   	push   %ds
	pushl %es
f0104635:	06                   	push   %es
	pushal
f0104636:	60                   	pusha  
	
	movl $GD_KD,%eax
f0104637:	b8 10 00 00 00       	mov    $0x10,%eax
	movl %eax,%ds
f010463c:	8e d8                	mov    %eax,%ds
	movl %eax,%es
f010463e:	8e c0                	mov    %eax,%es
	
	pushl %esp
f0104640:	54                   	push   %esp
	call trap
f0104641:	e8 05 fd ff ff       	call   f010434b <trap>

f0104646 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104646:	f3 0f 1e fb          	endbr32 
f010464a:	55                   	push   %ebp
f010464b:	89 e5                	mov    %esp,%ebp
f010464d:	83 ec 08             	sub    $0x8,%esp
f0104650:	a1 48 72 21 f0       	mov    0xf0217248,%eax
f0104655:	8d 50 54             	lea    0x54(%eax),%edx
	int i;
	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104658:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f010465d:	8b 02                	mov    (%edx),%eax
f010465f:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104662:	83 f8 02             	cmp    $0x2,%eax
f0104665:	76 2d                	jbe    f0104694 <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f0104667:	83 c1 01             	add    $0x1,%ecx
f010466a:	83 c2 7c             	add    $0x7c,%edx
f010466d:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104673:	75 e8                	jne    f010465d <sched_halt+0x17>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0104675:	83 ec 0c             	sub    $0xc,%esp
f0104678:	68 d0 7e 10 f0       	push   $0xf0107ed0
f010467d:	e8 56 f4 ff ff       	call   f0103ad8 <cprintf>
f0104682:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104685:	83 ec 0c             	sub    $0xc,%esp
f0104688:	6a 00                	push   $0x0
f010468a:	e8 7c c4 ff ff       	call   f0100b0b <monitor>
f010468f:	83 c4 10             	add    $0x10,%esp
f0104692:	eb f1                	jmp    f0104685 <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104694:	e8 61 19 00 00       	call   f0105ffa <cpunum>
f0104699:	6b c0 74             	imul   $0x74,%eax,%eax
f010469c:	c7 80 28 80 21 f0 00 	movl   $0x0,-0xfde7fd8(%eax)
f01046a3:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01046a6:	a1 8c 7e 21 f0       	mov    0xf0217e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01046ab:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01046b0:	76 50                	jbe    f0104702 <sched_halt+0xbc>
	return (physaddr_t)kva - KERNBASE;
f01046b2:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01046b7:	0f 22 d8             	mov    %eax,%cr3
	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f01046ba:	e8 3b 19 00 00       	call   f0105ffa <cpunum>
f01046bf:	6b d0 74             	imul   $0x74,%eax,%edx
f01046c2:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01046c5:	b8 02 00 00 00       	mov    $0x2,%eax
f01046ca:	f0 87 82 20 80 21 f0 	lock xchg %eax,-0xfde7fe0(%edx)
	spin_unlock(&kernel_lock);
f01046d1:	83 ec 0c             	sub    $0xc,%esp
f01046d4:	68 c0 33 12 f0       	push   $0xf01233c0
f01046d9:	e8 42 1c 00 00       	call   f0106320 <spin_unlock>
	asm volatile("pause");
f01046de:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f01046e0:	e8 15 19 00 00       	call   f0105ffa <cpunum>
f01046e5:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f01046e8:	8b 80 30 80 21 f0    	mov    -0xfde7fd0(%eax),%eax
f01046ee:	bd 00 00 00 00       	mov    $0x0,%ebp
f01046f3:	89 c4                	mov    %eax,%esp
f01046f5:	6a 00                	push   $0x0
f01046f7:	6a 00                	push   $0x0
f01046f9:	fb                   	sti    
f01046fa:	f4                   	hlt    
f01046fb:	eb fd                	jmp    f01046fa <sched_halt+0xb4>
}
f01046fd:	83 c4 10             	add    $0x10,%esp
f0104700:	c9                   	leave  
f0104701:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104702:	50                   	push   %eax
f0104703:	68 c8 66 10 f0       	push   $0xf01066c8
f0104708:	6a 4b                	push   $0x4b
f010470a:	68 f9 7e 10 f0       	push   $0xf0107ef9
f010470f:	e8 2c b9 ff ff       	call   f0100040 <_panic>

f0104714 <sched_yield>:
{
f0104714:	f3 0f 1e fb          	endbr32 
f0104718:	55                   	push   %ebp
f0104719:	89 e5                	mov    %esp,%ebp
f010471b:	53                   	push   %ebx
f010471c:	83 ec 04             	sub    $0x4,%esp
	if(curenv){
f010471f:	e8 d6 18 00 00       	call   f0105ffa <cpunum>
f0104724:	6b c0 74             	imul   $0x74,%eax,%eax
f0104727:	83 b8 28 80 21 f0 00 	cmpl   $0x0,-0xfde7fd8(%eax)
f010472e:	0f 84 97 00 00 00    	je     f01047cb <sched_yield+0xb7>
		for(count=ENVX(curenv->env_id)+1;count!=ENVX(curenv->env_id);count=(count+1)%NENV){
f0104734:	e8 c1 18 00 00       	call   f0105ffa <cpunum>
f0104739:	6b c0 74             	imul   $0x74,%eax,%eax
f010473c:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104742:	8b 58 48             	mov    0x48(%eax),%ebx
f0104745:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010474b:	83 c3 01             	add    $0x1,%ebx
f010474e:	e8 a7 18 00 00       	call   f0105ffa <cpunum>
f0104753:	6b c0 74             	imul   $0x74,%eax,%eax
f0104756:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f010475c:	8b 40 48             	mov    0x48(%eax),%eax
f010475f:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104764:	39 d8                	cmp    %ebx,%eax
f0104766:	74 2f                	je     f0104797 <sched_yield+0x83>
			if(envs[count].env_status==ENV_RUNNABLE)
f0104768:	6b c3 7c             	imul   $0x7c,%ebx,%eax
f010476b:	03 05 48 72 21 f0    	add    0xf0217248,%eax
f0104771:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f0104775:	74 17                	je     f010478e <sched_yield+0x7a>
		for(count=ENVX(curenv->env_id)+1;count!=ENVX(curenv->env_id);count=(count+1)%NENV){
f0104777:	83 c3 01             	add    $0x1,%ebx
f010477a:	89 d8                	mov    %ebx,%eax
f010477c:	c1 f8 1f             	sar    $0x1f,%eax
f010477f:	c1 e8 16             	shr    $0x16,%eax
f0104782:	01 c3                	add    %eax,%ebx
f0104784:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010478a:	29 c3                	sub    %eax,%ebx
f010478c:	eb c0                	jmp    f010474e <sched_yield+0x3a>
				env_run(&envs[count]);
f010478e:	83 ec 0c             	sub    $0xc,%esp
f0104791:	50                   	push   %eax
f0104792:	e8 c3 f0 ff ff       	call   f010385a <env_run>
		if(curenv->env_status==ENV_RUNNING)
f0104797:	e8 5e 18 00 00       	call   f0105ffa <cpunum>
f010479c:	6b c0 74             	imul   $0x74,%eax,%eax
f010479f:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01047a5:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01047a9:	74 0a                	je     f01047b5 <sched_yield+0xa1>
	sched_halt();
f01047ab:	e8 96 fe ff ff       	call   f0104646 <sched_halt>
}
f01047b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01047b3:	c9                   	leave  
f01047b4:	c3                   	ret    
			env_run(curenv);
f01047b5:	e8 40 18 00 00       	call   f0105ffa <cpunum>
f01047ba:	83 ec 0c             	sub    $0xc,%esp
f01047bd:	6b c0 74             	imul   $0x74,%eax,%eax
f01047c0:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f01047c6:	e8 8f f0 ff ff       	call   f010385a <env_run>
f01047cb:	a1 48 72 21 f0       	mov    0xf0217248,%eax
f01047d0:	8d 90 00 f0 01 00    	lea    0x1f000(%eax),%edx
			if(envs[count].env_status==ENV_RUNNABLE)
f01047d6:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01047da:	74 09                	je     f01047e5 <sched_yield+0xd1>
f01047dc:	83 c0 7c             	add    $0x7c,%eax
		for(count=0;count<NENV;count++){
f01047df:	39 d0                	cmp    %edx,%eax
f01047e1:	75 f3                	jne    f01047d6 <sched_yield+0xc2>
f01047e3:	eb c6                	jmp    f01047ab <sched_yield+0x97>
				env_run(&envs[count]);
f01047e5:	83 ec 0c             	sub    $0xc,%esp
f01047e8:	50                   	push   %eax
f01047e9:	e8 6c f0 ff ff       	call   f010385a <env_run>

f01047ee <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01047ee:	f3 0f 1e fb          	endbr32 
f01047f2:	55                   	push   %ebp
f01047f3:	89 e5                	mov    %esp,%ebp
f01047f5:	57                   	push   %edi
f01047f6:	56                   	push   %esi
f01047f7:	53                   	push   %ebx
f01047f8:	83 ec 1c             	sub    $0x1c,%esp
f01047fb:	8b 45 08             	mov    0x8(%ebp),%eax
f01047fe:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104801:	83 f8 0d             	cmp    $0xd,%eax
f0104804:	0f 87 8f 05 00 00    	ja     f0104d99 <syscall+0x5ab>
f010480a:	3e ff 24 85 0c 7f 10 	notrack jmp *-0xfef80f4(,%eax,4)
f0104811:	f0 
	user_mem_assert(curenv,s,len,PTE_U|PTE_P);
f0104812:	e8 e3 17 00 00       	call   f0105ffa <cpunum>
f0104817:	6a 05                	push   $0x5
f0104819:	57                   	push   %edi
f010481a:	ff 75 0c             	pushl  0xc(%ebp)
f010481d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104820:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0104826:	e8 12 e9 ff ff       	call   f010313d <user_mem_assert>
	cprintf("%.*s", len, s);
f010482b:	83 c4 0c             	add    $0xc,%esp
f010482e:	ff 75 0c             	pushl  0xc(%ebp)
f0104831:	57                   	push   %edi
f0104832:	68 06 7f 10 f0       	push   $0xf0107f06
f0104837:	e8 9c f2 ff ff       	call   f0103ad8 <cprintf>
}
f010483c:	83 c4 10             	add    $0x10,%esp
	//panic("syscall not implemented");
	
	switch (syscallno) {
	case SYS_cputs:
		sys_cputs((const char *)a1,a2);
		return 0;
f010483f:	bb 00 00 00 00       	mov    $0x0,%ebx
	case SYS_env_set_trapframe:
		return sys_env_set_trapframe(a1,(struct Trapframe *)a2);
	default:
		return -E_INVAL;
	}
}
f0104844:	89 d8                	mov    %ebx,%eax
f0104846:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104849:	5b                   	pop    %ebx
f010484a:	5e                   	pop    %esi
f010484b:	5f                   	pop    %edi
f010484c:	5d                   	pop    %ebp
f010484d:	c3                   	ret    
	return cons_getc();
f010484e:	e8 c0 bd ff ff       	call   f0100613 <cons_getc>
f0104853:	89 c3                	mov    %eax,%ebx
		return sys_cgetc();
f0104855:	eb ed                	jmp    f0104844 <syscall+0x56>
	if ((r = envid2env(envid, &e, 1)) < 0)
f0104857:	83 ec 04             	sub    $0x4,%esp
f010485a:	6a 01                	push   $0x1
f010485c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010485f:	50                   	push   %eax
f0104860:	ff 75 0c             	pushl  0xc(%ebp)
f0104863:	e8 ab e9 ff ff       	call   f0103213 <envid2env>
f0104868:	89 c3                	mov    %eax,%ebx
f010486a:	83 c4 10             	add    $0x10,%esp
f010486d:	85 c0                	test   %eax,%eax
f010486f:	78 d3                	js     f0104844 <syscall+0x56>
	env_destroy(e);
f0104871:	83 ec 0c             	sub    $0xc,%esp
f0104874:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104877:	e8 37 ef ff ff       	call   f01037b3 <env_destroy>
	return 0;
f010487c:	83 c4 10             	add    $0x10,%esp
f010487f:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_destroy(a1);
f0104884:	eb be                	jmp    f0104844 <syscall+0x56>
	return curenv->env_id;
f0104886:	e8 6f 17 00 00       	call   f0105ffa <cpunum>
f010488b:	6b c0 74             	imul   $0x74,%eax,%eax
f010488e:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104894:	8b 58 48             	mov    0x48(%eax),%ebx
		return sys_getenvid();
f0104897:	eb ab                	jmp    f0104844 <syscall+0x56>
	sched_yield();
f0104899:	e8 76 fe ff ff       	call   f0104714 <sched_yield>
	if((res=env_alloc(&environment,curenv->env_id)<0))
f010489e:	e8 57 17 00 00       	call   f0105ffa <cpunum>
f01048a3:	83 ec 08             	sub    $0x8,%esp
f01048a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01048a9:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f01048af:	ff 70 48             	pushl  0x48(%eax)
f01048b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01048b5:	50                   	push   %eax
f01048b6:	e8 6d ea ff ff       	call   f0103328 <env_alloc>
f01048bb:	83 c4 10             	add    $0x10,%esp
		return res;
f01048be:	bb 01 00 00 00       	mov    $0x1,%ebx
	if((res=env_alloc(&environment,curenv->env_id)<0))
f01048c3:	85 c0                	test   %eax,%eax
f01048c5:	0f 88 79 ff ff ff    	js     f0104844 <syscall+0x56>
	environment->env_status=ENV_NOT_RUNNABLE;
f01048cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01048ce:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	environment->env_tf=curenv->env_tf;
f01048d5:	e8 20 17 00 00       	call   f0105ffa <cpunum>
f01048da:	6b c0 74             	imul   $0x74,%eax,%eax
f01048dd:	8b b0 28 80 21 f0    	mov    -0xfde7fd8(%eax),%esi
f01048e3:	b9 11 00 00 00       	mov    $0x11,%ecx
f01048e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01048eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	environment->env_tf.tf_regs.reg_eax=0;
f01048ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01048f0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return environment->env_id;
f01048f7:	8b 58 48             	mov    0x48(%eax),%ebx
f01048fa:	e9 45 ff ff ff       	jmp    f0104844 <syscall+0x56>
	if(status!=ENV_RUNNABLE && status!=ENV_NOT_RUNNABLE)
f01048ff:	8d 47 fe             	lea    -0x2(%edi),%eax
f0104902:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104907:	75 28                	jne    f0104931 <syscall+0x143>
	if(envid2env(envid,&environment,1)<0)
f0104909:	83 ec 04             	sub    $0x4,%esp
f010490c:	6a 01                	push   $0x1
f010490e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104911:	50                   	push   %eax
f0104912:	ff 75 0c             	pushl  0xc(%ebp)
f0104915:	e8 f9 e8 ff ff       	call   f0103213 <envid2env>
f010491a:	83 c4 10             	add    $0x10,%esp
f010491d:	85 c0                	test   %eax,%eax
f010491f:	78 1a                	js     f010493b <syscall+0x14d>
	environment->env_status=status;
f0104921:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104924:	89 78 54             	mov    %edi,0x54(%eax)
	return 0;
f0104927:	bb 00 00 00 00       	mov    $0x0,%ebx
f010492c:	e9 13 ff ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f0104931:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104936:	e9 09 ff ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f010493b:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_env_set_status(a1,a2);
f0104940:	e9 ff fe ff ff       	jmp    f0104844 <syscall+0x56>
	if((uint32_t)va>=UTOP||(uint32_t)va%PGSIZE!=0)
f0104945:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f010494b:	77 76                	ja     f01049c3 <syscall+0x1d5>
f010494d:	89 f8                	mov    %edi,%eax
f010494f:	25 ff 0f 00 00       	and    $0xfff,%eax
	if(!(perm&(PTE_U|PTE_P)))
f0104954:	f6 45 14 05          	testb  $0x5,0x14(%ebp)
f0104958:	74 73                	je     f01049cd <syscall+0x1df>
	if(perm&(~PTE_SYSCALL))
f010495a:	8b 5d 14             	mov    0x14(%ebp),%ebx
f010495d:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104963:	09 c3                	or     %eax,%ebx
f0104965:	75 70                	jne    f01049d7 <syscall+0x1e9>
	page=page_alloc(ALLOC_ZERO);
f0104967:	83 ec 0c             	sub    $0xc,%esp
f010496a:	6a 01                	push   $0x1
f010496c:	e8 bc c7 ff ff       	call   f010112d <page_alloc>
f0104971:	89 c6                	mov    %eax,%esi
	if(!page)
f0104973:	83 c4 10             	add    $0x10,%esp
f0104976:	85 c0                	test   %eax,%eax
f0104978:	74 67                	je     f01049e1 <syscall+0x1f3>
	if(envid2env(envid,&environment,1)<0)
f010497a:	83 ec 04             	sub    $0x4,%esp
f010497d:	6a 01                	push   $0x1
f010497f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104982:	50                   	push   %eax
f0104983:	ff 75 0c             	pushl  0xc(%ebp)
f0104986:	e8 88 e8 ff ff       	call   f0103213 <envid2env>
f010498b:	83 c4 10             	add    $0x10,%esp
f010498e:	85 c0                	test   %eax,%eax
f0104990:	78 59                	js     f01049eb <syscall+0x1fd>
	if(page_insert(environment->env_pgdir,page,va,perm)<0){
f0104992:	ff 75 14             	pushl  0x14(%ebp)
f0104995:	57                   	push   %edi
f0104996:	56                   	push   %esi
f0104997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010499a:	ff 70 60             	pushl  0x60(%eax)
f010499d:	e8 33 ca ff ff       	call   f01013d5 <page_insert>
f01049a2:	83 c4 10             	add    $0x10,%esp
f01049a5:	85 c0                	test   %eax,%eax
f01049a7:	0f 89 97 fe ff ff    	jns    f0104844 <syscall+0x56>
		page_free(page);
f01049ad:	83 ec 0c             	sub    $0xc,%esp
f01049b0:	56                   	push   %esi
f01049b1:	e8 f0 c7 ff ff       	call   f01011a6 <page_free>
		return -E_NO_MEM;
f01049b6:	83 c4 10             	add    $0x10,%esp
f01049b9:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01049be:	e9 81 fe ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f01049c3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049c8:	e9 77 fe ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f01049cd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049d2:	e9 6d fe ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f01049d7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049dc:	e9 63 fe ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_NO_MEM;
f01049e1:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01049e6:	e9 59 fe ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f01049eb:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_page_alloc(a1,(void *)a2,a3);
f01049f0:	e9 4f fe ff ff       	jmp    f0104844 <syscall+0x56>
	if((uint32_t)srcva>=UTOP||(uint32_t)srcva%PGSIZE!=0||
f01049f5:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f01049fb:	0f 87 ae 00 00 00    	ja     f0104aaf <syscall+0x2c1>
f0104a01:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104a08:	0f 87 ab 00 00 00    	ja     f0104ab9 <syscall+0x2cb>
	if(!(perm&(PTE_U|PTE_P)))
f0104a0e:	f6 45 1c 05          	testb  $0x5,0x1c(%ebp)
f0104a12:	0f 84 ab 00 00 00    	je     f0104ac3 <syscall+0x2d5>
f0104a18:	89 fb                	mov    %edi,%ebx
f0104a1a:	0b 5d 18             	or     0x18(%ebp),%ebx
f0104a1d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
	if(perm&(~PTE_SYSCALL))
f0104a23:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104a26:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f0104a2b:	09 c3                	or     %eax,%ebx
f0104a2d:	0f 85 9a 00 00 00    	jne    f0104acd <syscall+0x2df>
	if(envid2env(srcenvid,&src_e,1)<0||envid2env(dstenvid,&dst_e,1)<0)
f0104a33:	83 ec 04             	sub    $0x4,%esp
f0104a36:	6a 01                	push   $0x1
f0104a38:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104a3b:	50                   	push   %eax
f0104a3c:	ff 75 0c             	pushl  0xc(%ebp)
f0104a3f:	e8 cf e7 ff ff       	call   f0103213 <envid2env>
f0104a44:	83 c4 10             	add    $0x10,%esp
f0104a47:	85 c0                	test   %eax,%eax
f0104a49:	0f 88 88 00 00 00    	js     f0104ad7 <syscall+0x2e9>
f0104a4f:	83 ec 04             	sub    $0x4,%esp
f0104a52:	6a 01                	push   $0x1
f0104a54:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104a57:	50                   	push   %eax
f0104a58:	ff 75 14             	pushl  0x14(%ebp)
f0104a5b:	e8 b3 e7 ff ff       	call   f0103213 <envid2env>
f0104a60:	83 c4 10             	add    $0x10,%esp
f0104a63:	85 c0                	test   %eax,%eax
f0104a65:	78 7a                	js     f0104ae1 <syscall+0x2f3>
	page=page_lookup(src_e->env_pgdir,srcva,&pte);
f0104a67:	83 ec 04             	sub    $0x4,%esp
f0104a6a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a6d:	50                   	push   %eax
f0104a6e:	57                   	push   %edi
f0104a6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104a72:	ff 70 60             	pushl  0x60(%eax)
f0104a75:	e8 75 c8 ff ff       	call   f01012ef <page_lookup>
	if(((!(*pte&PTE_W))&&(perm&PTE_W)))
f0104a7a:	83 c4 10             	add    $0x10,%esp
f0104a7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104a80:	f6 02 02             	testb  $0x2,(%edx)
f0104a83:	75 06                	jne    f0104a8b <syscall+0x29d>
f0104a85:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104a89:	75 60                	jne    f0104aeb <syscall+0x2fd>
	if(page_insert(dst_e->env_pgdir,page,dstva,perm)<0)
f0104a8b:	ff 75 1c             	pushl  0x1c(%ebp)
f0104a8e:	ff 75 18             	pushl  0x18(%ebp)
f0104a91:	50                   	push   %eax
f0104a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a95:	ff 70 60             	pushl  0x60(%eax)
f0104a98:	e8 38 c9 ff ff       	call   f01013d5 <page_insert>
f0104a9d:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f0104aa0:	85 c0                	test   %eax,%eax
f0104aa2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104aa7:	0f 48 d8             	cmovs  %eax,%ebx
f0104aaa:	e9 95 fd ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f0104aaf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ab4:	e9 8b fd ff ff       	jmp    f0104844 <syscall+0x56>
f0104ab9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104abe:	e9 81 fd ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f0104ac3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ac8:	e9 77 fd ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f0104acd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ad2:	e9 6d fd ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f0104ad7:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104adc:	e9 63 fd ff ff       	jmp    f0104844 <syscall+0x56>
f0104ae1:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104ae6:	e9 59 fd ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f0104aeb:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_page_map(a1,(void *)a2,a3,(void *)a4,a5);	
f0104af0:	e9 4f fd ff ff       	jmp    f0104844 <syscall+0x56>
	if((uint32_t)va>=UTOP||(uint32_t)va%PGSIZE!=0)
f0104af5:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f0104afb:	77 3c                	ja     f0104b39 <syscall+0x34b>
f0104afd:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0104b03:	75 3e                	jne    f0104b43 <syscall+0x355>
	if(envid2env(envid,&environment,1)<0)
f0104b05:	83 ec 04             	sub    $0x4,%esp
f0104b08:	6a 01                	push   $0x1
f0104b0a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104b0d:	50                   	push   %eax
f0104b0e:	ff 75 0c             	pushl  0xc(%ebp)
f0104b11:	e8 fd e6 ff ff       	call   f0103213 <envid2env>
f0104b16:	83 c4 10             	add    $0x10,%esp
f0104b19:	85 c0                	test   %eax,%eax
f0104b1b:	78 30                	js     f0104b4d <syscall+0x35f>
	page_remove(environment->env_pgdir,va);	
f0104b1d:	83 ec 08             	sub    $0x8,%esp
f0104b20:	57                   	push   %edi
f0104b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b24:	ff 70 60             	pushl  0x60(%eax)
f0104b27:	e8 5f c8 ff ff       	call   f010138b <page_remove>
	return 0;
f0104b2c:	83 c4 10             	add    $0x10,%esp
f0104b2f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104b34:	e9 0b fd ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_INVAL;
f0104b39:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b3e:	e9 01 fd ff ff       	jmp    f0104844 <syscall+0x56>
f0104b43:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b48:	e9 f7 fc ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f0104b4d:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_page_unmap(a1,(void *)a2);
f0104b52:	e9 ed fc ff ff       	jmp    f0104844 <syscall+0x56>
	if(envid2env(envid,&env,1)<0)
f0104b57:	83 ec 04             	sub    $0x4,%esp
f0104b5a:	6a 01                	push   $0x1
f0104b5c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104b5f:	50                   	push   %eax
f0104b60:	ff 75 0c             	pushl  0xc(%ebp)
f0104b63:	e8 ab e6 ff ff       	call   f0103213 <envid2env>
f0104b68:	83 c4 10             	add    $0x10,%esp
f0104b6b:	85 c0                	test   %eax,%eax
f0104b6d:	78 10                	js     f0104b7f <syscall+0x391>
	env->env_pgfault_upcall=func;
f0104b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b72:	89 78 64             	mov    %edi,0x64(%eax)
	return 0;
f0104b75:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104b7a:	e9 c5 fc ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f0104b7f:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_env_set_pgfault_upcall(a1,(void *)a2);
f0104b84:	e9 bb fc ff ff       	jmp    f0104844 <syscall+0x56>
	if(envid2env(envid,&env,0)<0)
f0104b89:	83 ec 04             	sub    $0x4,%esp
f0104b8c:	6a 00                	push   $0x0
f0104b8e:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104b91:	50                   	push   %eax
f0104b92:	ff 75 0c             	pushl  0xc(%ebp)
f0104b95:	e8 79 e6 ff ff       	call   f0103213 <envid2env>
f0104b9a:	83 c4 10             	add    $0x10,%esp
f0104b9d:	85 c0                	test   %eax,%eax
f0104b9f:	0f 88 da 00 00 00    	js     f0104c7f <syscall+0x491>
	if(!env->env_ipc_recving||env->env_ipc_from!=0)
f0104ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104ba8:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104bac:	0f 84 d7 00 00 00    	je     f0104c89 <syscall+0x49b>
f0104bb2:	8b 58 74             	mov    0x74(%eax),%ebx
f0104bb5:	85 db                	test   %ebx,%ebx
f0104bb7:	0f 85 d6 00 00 00    	jne    f0104c93 <syscall+0x4a5>
	struct PageInfo *page=page_lookup(curenv->env_pgdir,srcva,&pte);
f0104bbd:	e8 38 14 00 00       	call   f0105ffa <cpunum>
f0104bc2:	83 ec 04             	sub    $0x4,%esp
f0104bc5:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104bc8:	52                   	push   %edx
f0104bc9:	ff 75 14             	pushl  0x14(%ebp)
f0104bcc:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bcf:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104bd5:	ff 70 60             	pushl  0x60(%eax)
f0104bd8:	e8 12 c7 ff ff       	call   f01012ef <page_lookup>
	if((uint32_t)srcva<UTOP && (uint32_t)srcva%PGSIZE)
f0104bdd:	83 c4 10             	add    $0x10,%esp
f0104be0:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104be7:	77 65                	ja     f0104c4e <syscall+0x460>
f0104be9:	8b 55 14             	mov    0x14(%ebp),%edx
f0104bec:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
		if(!(perm&(PTE_P|PTE_U)))
f0104bf2:	f6 45 18 05          	testb  $0x5,0x18(%ebp)
f0104bf6:	0f 84 a1 00 00 00    	je     f0104c9d <syscall+0x4af>
		if ((perm&~PTE_SYSCALL))
f0104bfc:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0104bff:	81 e1 f8 f1 ff ff    	and    $0xfffff1f8,%ecx
f0104c05:	09 d1                	or     %edx,%ecx
f0104c07:	0f 85 9a 00 00 00    	jne    f0104ca7 <syscall+0x4b9>
	if((uint32_t)srcva<UTOP && !page)
f0104c0d:	85 c0                	test   %eax,%eax
f0104c0f:	0f 84 b0 00 00 00    	je     f0104cc5 <syscall+0x4d7>
        if((uint32_t)srcva<UTOP && (perm & PTE_W) && !(*pte & PTE_W))
f0104c15:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104c19:	74 0c                	je     f0104c27 <syscall+0x439>
f0104c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104c1e:	f6 02 02             	testb  $0x2,(%edx)
f0104c21:	0f 84 8a 00 00 00    	je     f0104cb1 <syscall+0x4c3>
        if((uint32_t)srcva<UTOP && env->env_ipc_dstva != 0) {
f0104c27:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104c2a:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104c2d:	85 c9                	test   %ecx,%ecx
f0104c2f:	74 1d                	je     f0104c4e <syscall+0x460>
                if (page_insert(env->env_pgdir,page,env->env_ipc_dstva,perm)<0)
f0104c31:	ff 75 18             	pushl  0x18(%ebp)
f0104c34:	51                   	push   %ecx
f0104c35:	50                   	push   %eax
f0104c36:	ff 72 60             	pushl  0x60(%edx)
f0104c39:	e8 97 c7 ff ff       	call   f01013d5 <page_insert>
f0104c3e:	83 c4 10             	add    $0x10,%esp
f0104c41:	85 c0                	test   %eax,%eax
f0104c43:	78 76                	js     f0104cbb <syscall+0x4cd>
                env->env_ipc_perm = perm;
f0104c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c48:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0104c4b:	89 48 78             	mov    %ecx,0x78(%eax)
        env->env_ipc_from=curenv->env_id;
f0104c4e:	e8 a7 13 00 00       	call   f0105ffa <cpunum>
f0104c53:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104c56:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c59:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104c5f:	8b 40 48             	mov    0x48(%eax),%eax
f0104c62:	89 42 74             	mov    %eax,0x74(%edx)
        env->env_ipc_recving=0;
f0104c65:	c6 42 68 00          	movb   $0x0,0x68(%edx)
        env->env_ipc_value=value;
f0104c69:	89 7a 70             	mov    %edi,0x70(%edx)
        env->env_status=ENV_RUNNABLE;
f0104c6c:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
        env->env_tf.tf_regs.reg_eax=0;
f0104c73:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
        return 0;
f0104c7a:	e9 c5 fb ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f0104c7f:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104c84:	e9 bb fb ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_IPC_NOT_RECV;
f0104c89:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104c8e:	e9 b1 fb ff ff       	jmp    f0104844 <syscall+0x56>
f0104c93:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104c98:	e9 a7 fb ff ff       	jmp    f0104844 <syscall+0x56>
			return -E_INVAL;
f0104c9d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ca2:	e9 9d fb ff ff       	jmp    f0104844 <syscall+0x56>
			return -E_INVAL;
f0104ca7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104cac:	e9 93 fb ff ff       	jmp    f0104844 <syscall+0x56>
                return -E_INVAL;
f0104cb1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104cb6:	e9 89 fb ff ff       	jmp    f0104844 <syscall+0x56>
                        return -E_NO_MEM;
f0104cbb:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f0104cc0:	e9 7f fb ff ff       	jmp    f0104844 <syscall+0x56>
                return -E_INVAL;
f0104cc5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_ipc_try_send(a1,a2,(void *)a3,a4);
f0104cca:	e9 75 fb ff ff       	jmp    f0104844 <syscall+0x56>
	if((uint32_t)dstva<UTOP&&(uint32_t)dstva%PGSIZE)
f0104ccf:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104cd6:	77 13                	ja     f0104ceb <syscall+0x4fd>
f0104cd8:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104cdf:	74 0a                	je     f0104ceb <syscall+0x4fd>
		return sys_ipc_recv((void *)a1);
f0104ce1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ce6:	e9 59 fb ff ff       	jmp    f0104844 <syscall+0x56>
	curenv->env_ipc_dstva=dstva;
f0104ceb:	e8 0a 13 00 00       	call   f0105ffa <cpunum>
f0104cf0:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cf3:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104cf9:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104cfc:	89 70 6c             	mov    %esi,0x6c(%eax)
	curenv->env_ipc_recving=true;
f0104cff:	e8 f6 12 00 00       	call   f0105ffa <cpunum>
f0104d04:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d07:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104d0d:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_from = 0;
f0104d11:	e8 e4 12 00 00       	call   f0105ffa <cpunum>
f0104d16:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d19:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104d1f:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
	curenv->env_status=ENV_NOT_RUNNABLE;
f0104d26:	e8 cf 12 00 00       	call   f0105ffa <cpunum>
f0104d2b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d2e:	8b 80 28 80 21 f0    	mov    -0xfde7fd8(%eax),%eax
f0104d34:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0104d3b:	e8 d4 f9 ff ff       	call   f0104714 <sched_yield>
		return sys_env_set_trapframe(a1,(struct Trapframe *)a2);
f0104d40:	89 fe                	mov    %edi,%esi
	if(envid2env(envid,&env,1)<0)
f0104d42:	83 ec 04             	sub    $0x4,%esp
f0104d45:	6a 01                	push   $0x1
f0104d47:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104d4a:	50                   	push   %eax
f0104d4b:	ff 75 0c             	pushl  0xc(%ebp)
f0104d4e:	e8 c0 e4 ff ff       	call   f0103213 <envid2env>
f0104d53:	83 c4 10             	add    $0x10,%esp
f0104d56:	85 c0                	test   %eax,%eax
f0104d58:	78 35                	js     f0104d8f <syscall+0x5a1>
	user_mem_assert(env,(const void *)tf,sizeof(struct Trapframe),PTE_U);
f0104d5a:	6a 04                	push   $0x4
f0104d5c:	6a 44                	push   $0x44
f0104d5e:	57                   	push   %edi
f0104d5f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104d62:	e8 d6 e3 ff ff       	call   f010313d <user_mem_assert>
	tf->tf_cs|=3;
f0104d67:	66 83 4f 34 03       	orw    $0x3,0x34(%edi)
	tf->tf_eflags &=~FL_IOPL_MASK;
f0104d6c:	8b 47 38             	mov    0x38(%edi),%eax
f0104d6f:	80 e4 cf             	and    $0xcf,%ah
f0104d72:	80 cc 02             	or     $0x2,%ah
f0104d75:	89 47 38             	mov    %eax,0x38(%edi)
	env->env_tf=*tf;
f0104d78:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104d7d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104d80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return 0;
f0104d82:	83 c4 10             	add    $0x10,%esp
f0104d85:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d8a:	e9 b5 fa ff ff       	jmp    f0104844 <syscall+0x56>
		return -E_BAD_ENV;
f0104d8f:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_env_set_trapframe(a1,(struct Trapframe *)a2);
f0104d94:	e9 ab fa ff ff       	jmp    f0104844 <syscall+0x56>
		return 0;
f0104d99:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104d9e:	e9 a1 fa ff ff       	jmp    f0104844 <syscall+0x56>

f0104da3 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104da3:	55                   	push   %ebp
f0104da4:	89 e5                	mov    %esp,%ebp
f0104da6:	57                   	push   %edi
f0104da7:	56                   	push   %esi
f0104da8:	53                   	push   %ebx
f0104da9:	83 ec 14             	sub    $0x14,%esp
f0104dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104daf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104db2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104db5:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104db8:	8b 1a                	mov    (%edx),%ebx
f0104dba:	8b 01                	mov    (%ecx),%eax
f0104dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104dbf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104dc6:	eb 23                	jmp    f0104deb <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104dc8:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104dcb:	eb 1e                	jmp    f0104deb <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104dcd:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104dd0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104dd3:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104dd7:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104dda:	73 46                	jae    f0104e22 <stab_binsearch+0x7f>
			*region_left = m;
f0104ddc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104ddf:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104de1:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104de4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104deb:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104dee:	7f 5f                	jg     f0104e4f <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104df3:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104df6:	89 d0                	mov    %edx,%eax
f0104df8:	c1 e8 1f             	shr    $0x1f,%eax
f0104dfb:	01 d0                	add    %edx,%eax
f0104dfd:	89 c7                	mov    %eax,%edi
f0104dff:	d1 ff                	sar    %edi
f0104e01:	83 e0 fe             	and    $0xfffffffe,%eax
f0104e04:	01 f8                	add    %edi,%eax
f0104e06:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104e09:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104e0d:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104e0f:	39 c3                	cmp    %eax,%ebx
f0104e11:	7f b5                	jg     f0104dc8 <stab_binsearch+0x25>
f0104e13:	0f b6 0a             	movzbl (%edx),%ecx
f0104e16:	83 ea 0c             	sub    $0xc,%edx
f0104e19:	39 f1                	cmp    %esi,%ecx
f0104e1b:	74 b0                	je     f0104dcd <stab_binsearch+0x2a>
			m--;
f0104e1d:	83 e8 01             	sub    $0x1,%eax
f0104e20:	eb ed                	jmp    f0104e0f <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104e22:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104e25:	76 14                	jbe    f0104e3b <stab_binsearch+0x98>
			*region_right = m - 1;
f0104e27:	83 e8 01             	sub    $0x1,%eax
f0104e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104e2d:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104e30:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104e32:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104e39:	eb b0                	jmp    f0104deb <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104e3b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e3e:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104e40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104e44:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104e46:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104e4d:	eb 9c                	jmp    f0104deb <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104e4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104e53:	75 15                	jne    f0104e6a <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104e58:	8b 00                	mov    (%eax),%eax
f0104e5a:	83 e8 01             	sub    $0x1,%eax
f0104e5d:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104e60:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104e62:	83 c4 14             	add    $0x14,%esp
f0104e65:	5b                   	pop    %ebx
f0104e66:	5e                   	pop    %esi
f0104e67:	5f                   	pop    %edi
f0104e68:	5d                   	pop    %ebp
f0104e69:	c3                   	ret    
		for (l = *region_right;
f0104e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e6d:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104e6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e72:	8b 0f                	mov    (%edi),%ecx
f0104e74:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104e77:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104e7a:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104e7e:	eb 03                	jmp    f0104e83 <stab_binsearch+0xe0>
		     l--)
f0104e80:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104e83:	39 c1                	cmp    %eax,%ecx
f0104e85:	7d 0a                	jge    f0104e91 <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0104e87:	0f b6 1a             	movzbl (%edx),%ebx
f0104e8a:	83 ea 0c             	sub    $0xc,%edx
f0104e8d:	39 f3                	cmp    %esi,%ebx
f0104e8f:	75 ef                	jne    f0104e80 <stab_binsearch+0xdd>
		*region_left = l;
f0104e91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e94:	89 07                	mov    %eax,(%edi)
}
f0104e96:	eb ca                	jmp    f0104e62 <stab_binsearch+0xbf>

f0104e98 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104e98:	f3 0f 1e fb          	endbr32 
f0104e9c:	55                   	push   %ebp
f0104e9d:	89 e5                	mov    %esp,%ebp
f0104e9f:	57                   	push   %edi
f0104ea0:	56                   	push   %esi
f0104ea1:	53                   	push   %ebx
f0104ea2:	83 ec 4c             	sub    $0x4c,%esp
f0104ea5:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104ea8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104eab:	c7 03 44 7f 10 f0    	movl   $0xf0107f44,(%ebx)
	info->eip_line = 0;
f0104eb1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104eb8:	c7 43 08 44 7f 10 f0 	movl   $0xf0107f44,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104ebf:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104ec6:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104ec9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104ed0:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104ed6:	0f 86 1f 01 00 00    	jbe    f0104ffb <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104edc:	c7 45 b8 14 8a 11 f0 	movl   $0xf0118a14,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104ee3:	c7 45 b4 2d 51 11 f0 	movl   $0xf011512d,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104eea:	be 2c 51 11 f0       	mov    $0xf011512c,%esi
		stabs = __STAB_BEGIN__;
f0104eef:	c7 45 bc f0 84 10 f0 	movl   $0xf01084f0,-0x44(%ebp)
		if(user_mem_check(curenv,(void *)stabstr,stabstr_end-stabstr,PTE_U)<0)
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104ef6:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104ef9:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0104efc:	0f 83 60 02 00 00    	jae    f0105162 <debuginfo_eip+0x2ca>
f0104f02:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104f06:	0f 85 5d 02 00 00    	jne    f0105169 <debuginfo_eip+0x2d1>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104f0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104f13:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0104f16:	c1 fe 02             	sar    $0x2,%esi
f0104f19:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0104f1f:	83 e8 01             	sub    $0x1,%eax
f0104f22:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104f25:	83 ec 08             	sub    $0x8,%esp
f0104f28:	57                   	push   %edi
f0104f29:	6a 64                	push   $0x64
f0104f2b:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104f2e:	89 d1                	mov    %edx,%ecx
f0104f30:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104f33:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104f36:	89 f0                	mov    %esi,%eax
f0104f38:	e8 66 fe ff ff       	call   f0104da3 <stab_binsearch>
	if (lfile == 0)
f0104f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f40:	83 c4 10             	add    $0x10,%esp
f0104f43:	85 c0                	test   %eax,%eax
f0104f45:	0f 84 25 02 00 00    	je     f0105170 <debuginfo_eip+0x2d8>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104f4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104f4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f51:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104f54:	83 ec 08             	sub    $0x8,%esp
f0104f57:	57                   	push   %edi
f0104f58:	6a 24                	push   $0x24
f0104f5a:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104f5d:	89 d1                	mov    %edx,%ecx
f0104f5f:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104f62:	89 f0                	mov    %esi,%eax
f0104f64:	e8 3a fe ff ff       	call   f0104da3 <stab_binsearch>

	if (lfun <= rfun) {
f0104f69:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104f6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104f6f:	83 c4 10             	add    $0x10,%esp
f0104f72:	39 d0                	cmp    %edx,%eax
f0104f74:	0f 8f 30 01 00 00    	jg     f01050aa <debuginfo_eip+0x212>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104f7a:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104f7d:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0104f80:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0104f83:	8b 36                	mov    (%esi),%esi
f0104f85:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104f88:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0104f8b:	39 ce                	cmp    %ecx,%esi
f0104f8d:	73 06                	jae    f0104f95 <debuginfo_eip+0xfd>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104f8f:	03 75 b4             	add    -0x4c(%ebp),%esi
f0104f92:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104f95:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104f98:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104f9b:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104f9e:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0104fa0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104fa3:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104fa6:	83 ec 08             	sub    $0x8,%esp
f0104fa9:	6a 3a                	push   $0x3a
f0104fab:	ff 73 08             	pushl  0x8(%ebx)
f0104fae:	e8 08 0a 00 00       	call   f01059bb <strfind>
f0104fb3:	2b 43 08             	sub    0x8(%ebx),%eax
f0104fb6:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104fb9:	83 c4 08             	add    $0x8,%esp
f0104fbc:	57                   	push   %edi
f0104fbd:	6a 44                	push   $0x44
f0104fbf:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104fc2:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104fc5:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104fc8:	89 f0                	mov    %esi,%eax
f0104fca:	e8 d4 fd ff ff       	call   f0104da3 <stab_binsearch>
	if(lline<=rline){
f0104fcf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104fd2:	83 c4 10             	add    $0x10,%esp
f0104fd5:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104fd8:	0f 8f 99 01 00 00    	jg     f0105177 <debuginfo_eip+0x2df>
		info->eip_line=stabs[lline].n_desc;
f0104fde:	89 d0                	mov    %edx,%eax
f0104fe0:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104fe3:	0f b7 4c 96 06       	movzwl 0x6(%esi,%edx,4),%ecx
f0104fe8:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104feb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104fee:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0104ff2:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104ff6:	e9 cd 00 00 00       	jmp    f01050c8 <debuginfo_eip+0x230>
		if(user_mem_check(curenv,(void *)usd,sizeof(struct UserStabData),PTE_U)<0)
f0104ffb:	e8 fa 0f 00 00       	call   f0105ffa <cpunum>
f0105000:	6a 04                	push   $0x4
f0105002:	6a 10                	push   $0x10
f0105004:	68 00 00 20 00       	push   $0x200000
f0105009:	6b c0 74             	imul   $0x74,%eax,%eax
f010500c:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0105012:	e8 95 e0 ff ff       	call   f01030ac <user_mem_check>
f0105017:	83 c4 10             	add    $0x10,%esp
f010501a:	85 c0                	test   %eax,%eax
f010501c:	0f 88 32 01 00 00    	js     f0105154 <debuginfo_eip+0x2bc>
		stabs = usd->stabs;
f0105022:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105028:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f010502b:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105031:	a1 08 00 20 00       	mov    0x200008,%eax
f0105036:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105039:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f010503f:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv,(void *)stabs,stab_end-stabs,PTE_U)<0)
f0105042:	e8 b3 0f 00 00       	call   f0105ffa <cpunum>
f0105047:	89 c2                	mov    %eax,%edx
f0105049:	6a 04                	push   $0x4
f010504b:	89 f0                	mov    %esi,%eax
f010504d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105050:	29 c8                	sub    %ecx,%eax
f0105052:	c1 f8 02             	sar    $0x2,%eax
f0105055:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010505b:	50                   	push   %eax
f010505c:	51                   	push   %ecx
f010505d:	6b d2 74             	imul   $0x74,%edx,%edx
f0105060:	ff b2 28 80 21 f0    	pushl  -0xfde7fd8(%edx)
f0105066:	e8 41 e0 ff ff       	call   f01030ac <user_mem_check>
f010506b:	83 c4 10             	add    $0x10,%esp
f010506e:	85 c0                	test   %eax,%eax
f0105070:	0f 88 e5 00 00 00    	js     f010515b <debuginfo_eip+0x2c3>
		if(user_mem_check(curenv,(void *)stabstr,stabstr_end-stabstr,PTE_U)<0)
f0105076:	e8 7f 0f 00 00       	call   f0105ffa <cpunum>
f010507b:	6a 04                	push   $0x4
f010507d:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105080:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105083:	29 ca                	sub    %ecx,%edx
f0105085:	52                   	push   %edx
f0105086:	51                   	push   %ecx
f0105087:	6b c0 74             	imul   $0x74,%eax,%eax
f010508a:	ff b0 28 80 21 f0    	pushl  -0xfde7fd8(%eax)
f0105090:	e8 17 e0 ff ff       	call   f01030ac <user_mem_check>
f0105095:	83 c4 10             	add    $0x10,%esp
f0105098:	85 c0                	test   %eax,%eax
f010509a:	0f 89 56 fe ff ff    	jns    f0104ef6 <debuginfo_eip+0x5e>
			return -1;
f01050a0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01050a5:	e9 d9 00 00 00       	jmp    f0105183 <debuginfo_eip+0x2eb>
		info->eip_fn_addr = addr;
f01050aa:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f01050ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01050b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01050b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01050b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01050b9:	e9 e8 fe ff ff       	jmp    f0104fa6 <debuginfo_eip+0x10e>
f01050be:	83 e8 01             	sub    $0x1,%eax
f01050c1:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile
f01050c4:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f01050c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01050cb:	39 c7                	cmp    %eax,%edi
f01050cd:	7f 45                	jg     f0105114 <debuginfo_eip+0x27c>
	       && stabs[lline].n_type != N_SOL
f01050cf:	0f b6 0a             	movzbl (%edx),%ecx
f01050d2:	80 f9 84             	cmp    $0x84,%cl
f01050d5:	74 19                	je     f01050f0 <debuginfo_eip+0x258>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01050d7:	80 f9 64             	cmp    $0x64,%cl
f01050da:	75 e2                	jne    f01050be <debuginfo_eip+0x226>
f01050dc:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01050e0:	74 dc                	je     f01050be <debuginfo_eip+0x226>
f01050e2:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01050e6:	74 11                	je     f01050f9 <debuginfo_eip+0x261>
f01050e8:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01050eb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01050ee:	eb 09                	jmp    f01050f9 <debuginfo_eip+0x261>
f01050f0:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01050f4:	74 03                	je     f01050f9 <debuginfo_eip+0x261>
f01050f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01050f9:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01050fc:	8b 7d bc             	mov    -0x44(%ebp),%edi
f01050ff:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105102:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105105:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105108:	29 f8                	sub    %edi,%eax
f010510a:	39 c2                	cmp    %eax,%edx
f010510c:	73 06                	jae    f0105114 <debuginfo_eip+0x27c>
		info->eip_file = stabstr + stabs[lline].n_strx;
f010510e:	89 f8                	mov    %edi,%eax
f0105110:	01 d0                	add    %edx,%eax
f0105112:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105114:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105117:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f010511a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f010511f:	39 f0                	cmp    %esi,%eax
f0105121:	7d 60                	jge    f0105183 <debuginfo_eip+0x2eb>
		for (lline = lfun + 1;
f0105123:	8d 50 01             	lea    0x1(%eax),%edx
f0105126:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105129:	89 d0                	mov    %edx,%eax
f010512b:	8d 14 52             	lea    (%edx,%edx,2),%edx
f010512e:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105131:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105135:	eb 04                	jmp    f010513b <debuginfo_eip+0x2a3>
			info->eip_fn_narg++;
f0105137:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f010513b:	39 c6                	cmp    %eax,%esi
f010513d:	7e 3f                	jle    f010517e <debuginfo_eip+0x2e6>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f010513f:	0f b6 0a             	movzbl (%edx),%ecx
f0105142:	83 c0 01             	add    $0x1,%eax
f0105145:	83 c2 0c             	add    $0xc,%edx
f0105148:	80 f9 a0             	cmp    $0xa0,%cl
f010514b:	74 ea                	je     f0105137 <debuginfo_eip+0x29f>
	return 0;
f010514d:	ba 00 00 00 00       	mov    $0x0,%edx
f0105152:	eb 2f                	jmp    f0105183 <debuginfo_eip+0x2eb>
			return -1;
f0105154:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105159:	eb 28                	jmp    f0105183 <debuginfo_eip+0x2eb>
			return -1;
f010515b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105160:	eb 21                	jmp    f0105183 <debuginfo_eip+0x2eb>
		return -1;
f0105162:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105167:	eb 1a                	jmp    f0105183 <debuginfo_eip+0x2eb>
f0105169:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010516e:	eb 13                	jmp    f0105183 <debuginfo_eip+0x2eb>
		return -1;
f0105170:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0105175:	eb 0c                	jmp    f0105183 <debuginfo_eip+0x2eb>
	else return -1;
f0105177:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010517c:	eb 05                	jmp    f0105183 <debuginfo_eip+0x2eb>
	return 0;
f010517e:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105183:	89 d0                	mov    %edx,%eax
f0105185:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105188:	5b                   	pop    %ebx
f0105189:	5e                   	pop    %esi
f010518a:	5f                   	pop    %edi
f010518b:	5d                   	pop    %ebp
f010518c:	c3                   	ret    

f010518d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010518d:	55                   	push   %ebp
f010518e:	89 e5                	mov    %esp,%ebp
f0105190:	57                   	push   %edi
f0105191:	56                   	push   %esi
f0105192:	53                   	push   %ebx
f0105193:	83 ec 1c             	sub    $0x1c,%esp
f0105196:	89 c7                	mov    %eax,%edi
f0105198:	89 d6                	mov    %edx,%esi
f010519a:	8b 45 08             	mov    0x8(%ebp),%eax
f010519d:	8b 55 0c             	mov    0xc(%ebp),%edx
f01051a0:	89 d1                	mov    %edx,%ecx
f01051a2:	89 c2                	mov    %eax,%edx
f01051a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01051a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01051aa:	8b 45 10             	mov    0x10(%ebp),%eax
f01051ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f01051b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01051b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01051ba:	39 c2                	cmp    %eax,%edx
f01051bc:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f01051bf:	72 3e                	jb     f01051ff <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01051c1:	83 ec 0c             	sub    $0xc,%esp
f01051c4:	ff 75 18             	pushl  0x18(%ebp)
f01051c7:	83 eb 01             	sub    $0x1,%ebx
f01051ca:	53                   	push   %ebx
f01051cb:	50                   	push   %eax
f01051cc:	83 ec 08             	sub    $0x8,%esp
f01051cf:	ff 75 e4             	pushl  -0x1c(%ebp)
f01051d2:	ff 75 e0             	pushl  -0x20(%ebp)
f01051d5:	ff 75 dc             	pushl  -0x24(%ebp)
f01051d8:	ff 75 d8             	pushl  -0x28(%ebp)
f01051db:	e8 30 12 00 00       	call   f0106410 <__udivdi3>
f01051e0:	83 c4 18             	add    $0x18,%esp
f01051e3:	52                   	push   %edx
f01051e4:	50                   	push   %eax
f01051e5:	89 f2                	mov    %esi,%edx
f01051e7:	89 f8                	mov    %edi,%eax
f01051e9:	e8 9f ff ff ff       	call   f010518d <printnum>
f01051ee:	83 c4 20             	add    $0x20,%esp
f01051f1:	eb 13                	jmp    f0105206 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01051f3:	83 ec 08             	sub    $0x8,%esp
f01051f6:	56                   	push   %esi
f01051f7:	ff 75 18             	pushl  0x18(%ebp)
f01051fa:	ff d7                	call   *%edi
f01051fc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01051ff:	83 eb 01             	sub    $0x1,%ebx
f0105202:	85 db                	test   %ebx,%ebx
f0105204:	7f ed                	jg     f01051f3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105206:	83 ec 08             	sub    $0x8,%esp
f0105209:	56                   	push   %esi
f010520a:	83 ec 04             	sub    $0x4,%esp
f010520d:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105210:	ff 75 e0             	pushl  -0x20(%ebp)
f0105213:	ff 75 dc             	pushl  -0x24(%ebp)
f0105216:	ff 75 d8             	pushl  -0x28(%ebp)
f0105219:	e8 02 13 00 00       	call   f0106520 <__umoddi3>
f010521e:	83 c4 14             	add    $0x14,%esp
f0105221:	0f be 80 4e 7f 10 f0 	movsbl -0xfef80b2(%eax),%eax
f0105228:	50                   	push   %eax
f0105229:	ff d7                	call   *%edi
}
f010522b:	83 c4 10             	add    $0x10,%esp
f010522e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105231:	5b                   	pop    %ebx
f0105232:	5e                   	pop    %esi
f0105233:	5f                   	pop    %edi
f0105234:	5d                   	pop    %ebp
f0105235:	c3                   	ret    

f0105236 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105236:	f3 0f 1e fb          	endbr32 
f010523a:	55                   	push   %ebp
f010523b:	89 e5                	mov    %esp,%ebp
f010523d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105240:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105244:	8b 10                	mov    (%eax),%edx
f0105246:	3b 50 04             	cmp    0x4(%eax),%edx
f0105249:	73 0a                	jae    f0105255 <sprintputch+0x1f>
		*b->buf++ = ch;
f010524b:	8d 4a 01             	lea    0x1(%edx),%ecx
f010524e:	89 08                	mov    %ecx,(%eax)
f0105250:	8b 45 08             	mov    0x8(%ebp),%eax
f0105253:	88 02                	mov    %al,(%edx)
}
f0105255:	5d                   	pop    %ebp
f0105256:	c3                   	ret    

f0105257 <printfmt>:
{
f0105257:	f3 0f 1e fb          	endbr32 
f010525b:	55                   	push   %ebp
f010525c:	89 e5                	mov    %esp,%ebp
f010525e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105261:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105264:	50                   	push   %eax
f0105265:	ff 75 10             	pushl  0x10(%ebp)
f0105268:	ff 75 0c             	pushl  0xc(%ebp)
f010526b:	ff 75 08             	pushl  0x8(%ebp)
f010526e:	e8 05 00 00 00       	call   f0105278 <vprintfmt>
}
f0105273:	83 c4 10             	add    $0x10,%esp
f0105276:	c9                   	leave  
f0105277:	c3                   	ret    

f0105278 <vprintfmt>:
{
f0105278:	f3 0f 1e fb          	endbr32 
f010527c:	55                   	push   %ebp
f010527d:	89 e5                	mov    %esp,%ebp
f010527f:	57                   	push   %edi
f0105280:	56                   	push   %esi
f0105281:	53                   	push   %ebx
f0105282:	83 ec 3c             	sub    $0x3c,%esp
f0105285:	8b 75 08             	mov    0x8(%ebp),%esi
f0105288:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010528b:	8b 7d 10             	mov    0x10(%ebp),%edi
f010528e:	e9 8e 03 00 00       	jmp    f0105621 <vprintfmt+0x3a9>
		padc = ' ';
f0105293:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0105297:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f010529e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f01052a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f01052ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f01052b1:	8d 47 01             	lea    0x1(%edi),%eax
f01052b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01052b7:	0f b6 17             	movzbl (%edi),%edx
f01052ba:	8d 42 dd             	lea    -0x23(%edx),%eax
f01052bd:	3c 55                	cmp    $0x55,%al
f01052bf:	0f 87 df 03 00 00    	ja     f01056a4 <vprintfmt+0x42c>
f01052c5:	0f b6 c0             	movzbl %al,%eax
f01052c8:	3e ff 24 85 a0 80 10 	notrack jmp *-0xfef7f60(,%eax,4)
f01052cf:	f0 
f01052d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01052d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01052d7:	eb d8                	jmp    f01052b1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01052d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01052dc:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01052e0:	eb cf                	jmp    f01052b1 <vprintfmt+0x39>
f01052e2:	0f b6 d2             	movzbl %dl,%edx
f01052e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01052e8:	b8 00 00 00 00       	mov    $0x0,%eax
f01052ed:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01052f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01052f3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01052f7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01052fa:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01052fd:	83 f9 09             	cmp    $0x9,%ecx
f0105300:	77 55                	ja     f0105357 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
f0105302:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105305:	eb e9                	jmp    f01052f0 <vprintfmt+0x78>
			precision = va_arg(ap, int);
f0105307:	8b 45 14             	mov    0x14(%ebp),%eax
f010530a:	8b 00                	mov    (%eax),%eax
f010530c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010530f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105312:	8d 40 04             	lea    0x4(%eax),%eax
f0105315:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f010531b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010531f:	79 90                	jns    f01052b1 <vprintfmt+0x39>
				width = precision, precision = -1;
f0105321:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105324:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105327:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f010532e:	eb 81                	jmp    f01052b1 <vprintfmt+0x39>
f0105330:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105333:	85 c0                	test   %eax,%eax
f0105335:	ba 00 00 00 00       	mov    $0x0,%edx
f010533a:	0f 49 d0             	cmovns %eax,%edx
f010533d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105343:	e9 69 ff ff ff       	jmp    f01052b1 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f0105348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f010534b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0105352:	e9 5a ff ff ff       	jmp    f01052b1 <vprintfmt+0x39>
f0105357:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010535a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010535d:	eb bc                	jmp    f010531b <vprintfmt+0xa3>
			lflag++;
f010535f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105362:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105365:	e9 47 ff ff ff       	jmp    f01052b1 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f010536a:	8b 45 14             	mov    0x14(%ebp),%eax
f010536d:	8d 78 04             	lea    0x4(%eax),%edi
f0105370:	83 ec 08             	sub    $0x8,%esp
f0105373:	53                   	push   %ebx
f0105374:	ff 30                	pushl  (%eax)
f0105376:	ff d6                	call   *%esi
			break;
f0105378:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010537b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f010537e:	e9 9b 02 00 00       	jmp    f010561e <vprintfmt+0x3a6>
			err = va_arg(ap, int);
f0105383:	8b 45 14             	mov    0x14(%ebp),%eax
f0105386:	8d 78 04             	lea    0x4(%eax),%edi
f0105389:	8b 00                	mov    (%eax),%eax
f010538b:	99                   	cltd   
f010538c:	31 d0                	xor    %edx,%eax
f010538e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105390:	83 f8 0f             	cmp    $0xf,%eax
f0105393:	7f 23                	jg     f01053b8 <vprintfmt+0x140>
f0105395:	8b 14 85 00 82 10 f0 	mov    -0xfef7e00(,%eax,4),%edx
f010539c:	85 d2                	test   %edx,%edx
f010539e:	74 18                	je     f01053b8 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
f01053a0:	52                   	push   %edx
f01053a1:	68 c3 6d 10 f0       	push   $0xf0106dc3
f01053a6:	53                   	push   %ebx
f01053a7:	56                   	push   %esi
f01053a8:	e8 aa fe ff ff       	call   f0105257 <printfmt>
f01053ad:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01053b0:	89 7d 14             	mov    %edi,0x14(%ebp)
f01053b3:	e9 66 02 00 00       	jmp    f010561e <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
f01053b8:	50                   	push   %eax
f01053b9:	68 66 7f 10 f0       	push   $0xf0107f66
f01053be:	53                   	push   %ebx
f01053bf:	56                   	push   %esi
f01053c0:	e8 92 fe ff ff       	call   f0105257 <printfmt>
f01053c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01053c8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01053cb:	e9 4e 02 00 00       	jmp    f010561e <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
f01053d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01053d3:	83 c0 04             	add    $0x4,%eax
f01053d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01053d9:	8b 45 14             	mov    0x14(%ebp),%eax
f01053dc:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01053de:	85 d2                	test   %edx,%edx
f01053e0:	b8 5f 7f 10 f0       	mov    $0xf0107f5f,%eax
f01053e5:	0f 45 c2             	cmovne %edx,%eax
f01053e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01053eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01053ef:	7e 06                	jle    f01053f7 <vprintfmt+0x17f>
f01053f1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01053f5:	75 0d                	jne    f0105404 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
f01053f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01053fa:	89 c7                	mov    %eax,%edi
f01053fc:	03 45 e0             	add    -0x20(%ebp),%eax
f01053ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105402:	eb 55                	jmp    f0105459 <vprintfmt+0x1e1>
f0105404:	83 ec 08             	sub    $0x8,%esp
f0105407:	ff 75 d8             	pushl  -0x28(%ebp)
f010540a:	ff 75 cc             	pushl  -0x34(%ebp)
f010540d:	e8 38 04 00 00       	call   f010584a <strnlen>
f0105412:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105415:	29 c2                	sub    %eax,%edx
f0105417:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f010541a:	83 c4 10             	add    $0x10,%esp
f010541d:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f010541f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0105423:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f0105426:	85 ff                	test   %edi,%edi
f0105428:	7e 11                	jle    f010543b <vprintfmt+0x1c3>
					putch(padc, putdat);
f010542a:	83 ec 08             	sub    $0x8,%esp
f010542d:	53                   	push   %ebx
f010542e:	ff 75 e0             	pushl  -0x20(%ebp)
f0105431:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105433:	83 ef 01             	sub    $0x1,%edi
f0105436:	83 c4 10             	add    $0x10,%esp
f0105439:	eb eb                	jmp    f0105426 <vprintfmt+0x1ae>
f010543b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f010543e:	85 d2                	test   %edx,%edx
f0105440:	b8 00 00 00 00       	mov    $0x0,%eax
f0105445:	0f 49 c2             	cmovns %edx,%eax
f0105448:	29 c2                	sub    %eax,%edx
f010544a:	89 55 e0             	mov    %edx,-0x20(%ebp)
f010544d:	eb a8                	jmp    f01053f7 <vprintfmt+0x17f>
					putch(ch, putdat);
f010544f:	83 ec 08             	sub    $0x8,%esp
f0105452:	53                   	push   %ebx
f0105453:	52                   	push   %edx
f0105454:	ff d6                	call   *%esi
f0105456:	83 c4 10             	add    $0x10,%esp
f0105459:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010545c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010545e:	83 c7 01             	add    $0x1,%edi
f0105461:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105465:	0f be d0             	movsbl %al,%edx
f0105468:	85 d2                	test   %edx,%edx
f010546a:	74 4b                	je     f01054b7 <vprintfmt+0x23f>
f010546c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105470:	78 06                	js     f0105478 <vprintfmt+0x200>
f0105472:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105476:	78 1e                	js     f0105496 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
f0105478:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010547c:	74 d1                	je     f010544f <vprintfmt+0x1d7>
f010547e:	0f be c0             	movsbl %al,%eax
f0105481:	83 e8 20             	sub    $0x20,%eax
f0105484:	83 f8 5e             	cmp    $0x5e,%eax
f0105487:	76 c6                	jbe    f010544f <vprintfmt+0x1d7>
					putch('?', putdat);
f0105489:	83 ec 08             	sub    $0x8,%esp
f010548c:	53                   	push   %ebx
f010548d:	6a 3f                	push   $0x3f
f010548f:	ff d6                	call   *%esi
f0105491:	83 c4 10             	add    $0x10,%esp
f0105494:	eb c3                	jmp    f0105459 <vprintfmt+0x1e1>
f0105496:	89 cf                	mov    %ecx,%edi
f0105498:	eb 0e                	jmp    f01054a8 <vprintfmt+0x230>
				putch(' ', putdat);
f010549a:	83 ec 08             	sub    $0x8,%esp
f010549d:	53                   	push   %ebx
f010549e:	6a 20                	push   $0x20
f01054a0:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01054a2:	83 ef 01             	sub    $0x1,%edi
f01054a5:	83 c4 10             	add    $0x10,%esp
f01054a8:	85 ff                	test   %edi,%edi
f01054aa:	7f ee                	jg     f010549a <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
f01054ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01054af:	89 45 14             	mov    %eax,0x14(%ebp)
f01054b2:	e9 67 01 00 00       	jmp    f010561e <vprintfmt+0x3a6>
f01054b7:	89 cf                	mov    %ecx,%edi
f01054b9:	eb ed                	jmp    f01054a8 <vprintfmt+0x230>
	if (lflag >= 2)
f01054bb:	83 f9 01             	cmp    $0x1,%ecx
f01054be:	7f 1b                	jg     f01054db <vprintfmt+0x263>
	else if (lflag)
f01054c0:	85 c9                	test   %ecx,%ecx
f01054c2:	74 63                	je     f0105527 <vprintfmt+0x2af>
		return va_arg(*ap, long);
f01054c4:	8b 45 14             	mov    0x14(%ebp),%eax
f01054c7:	8b 00                	mov    (%eax),%eax
f01054c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01054cc:	99                   	cltd   
f01054cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01054d0:	8b 45 14             	mov    0x14(%ebp),%eax
f01054d3:	8d 40 04             	lea    0x4(%eax),%eax
f01054d6:	89 45 14             	mov    %eax,0x14(%ebp)
f01054d9:	eb 17                	jmp    f01054f2 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
f01054db:	8b 45 14             	mov    0x14(%ebp),%eax
f01054de:	8b 50 04             	mov    0x4(%eax),%edx
f01054e1:	8b 00                	mov    (%eax),%eax
f01054e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01054e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01054e9:	8b 45 14             	mov    0x14(%ebp),%eax
f01054ec:	8d 40 08             	lea    0x8(%eax),%eax
f01054ef:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01054f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01054f5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01054f8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01054fd:	85 c9                	test   %ecx,%ecx
f01054ff:	0f 89 ff 00 00 00    	jns    f0105604 <vprintfmt+0x38c>
				putch('-', putdat);
f0105505:	83 ec 08             	sub    $0x8,%esp
f0105508:	53                   	push   %ebx
f0105509:	6a 2d                	push   $0x2d
f010550b:	ff d6                	call   *%esi
				num = -(long long) num;
f010550d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105510:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105513:	f7 da                	neg    %edx
f0105515:	83 d1 00             	adc    $0x0,%ecx
f0105518:	f7 d9                	neg    %ecx
f010551a:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010551d:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105522:	e9 dd 00 00 00       	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, int);
f0105527:	8b 45 14             	mov    0x14(%ebp),%eax
f010552a:	8b 00                	mov    (%eax),%eax
f010552c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010552f:	99                   	cltd   
f0105530:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105533:	8b 45 14             	mov    0x14(%ebp),%eax
f0105536:	8d 40 04             	lea    0x4(%eax),%eax
f0105539:	89 45 14             	mov    %eax,0x14(%ebp)
f010553c:	eb b4                	jmp    f01054f2 <vprintfmt+0x27a>
	if (lflag >= 2)
f010553e:	83 f9 01             	cmp    $0x1,%ecx
f0105541:	7f 1e                	jg     f0105561 <vprintfmt+0x2e9>
	else if (lflag)
f0105543:	85 c9                	test   %ecx,%ecx
f0105545:	74 32                	je     f0105579 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
f0105547:	8b 45 14             	mov    0x14(%ebp),%eax
f010554a:	8b 10                	mov    (%eax),%edx
f010554c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105551:	8d 40 04             	lea    0x4(%eax),%eax
f0105554:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105557:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f010555c:	e9 a3 00 00 00       	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105561:	8b 45 14             	mov    0x14(%ebp),%eax
f0105564:	8b 10                	mov    (%eax),%edx
f0105566:	8b 48 04             	mov    0x4(%eax),%ecx
f0105569:	8d 40 08             	lea    0x8(%eax),%eax
f010556c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010556f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f0105574:	e9 8b 00 00 00       	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105579:	8b 45 14             	mov    0x14(%ebp),%eax
f010557c:	8b 10                	mov    (%eax),%edx
f010557e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105583:	8d 40 04             	lea    0x4(%eax),%eax
f0105586:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105589:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f010558e:	eb 74                	jmp    f0105604 <vprintfmt+0x38c>
	if (lflag >= 2)
f0105590:	83 f9 01             	cmp    $0x1,%ecx
f0105593:	7f 1b                	jg     f01055b0 <vprintfmt+0x338>
	else if (lflag)
f0105595:	85 c9                	test   %ecx,%ecx
f0105597:	74 2c                	je     f01055c5 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
f0105599:	8b 45 14             	mov    0x14(%ebp),%eax
f010559c:	8b 10                	mov    (%eax),%edx
f010559e:	b9 00 00 00 00       	mov    $0x0,%ecx
f01055a3:	8d 40 04             	lea    0x4(%eax),%eax
f01055a6:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
f01055a9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f01055ae:	eb 54                	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f01055b0:	8b 45 14             	mov    0x14(%ebp),%eax
f01055b3:	8b 10                	mov    (%eax),%edx
f01055b5:	8b 48 04             	mov    0x4(%eax),%ecx
f01055b8:	8d 40 08             	lea    0x8(%eax),%eax
f01055bb:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
f01055be:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f01055c3:	eb 3f                	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f01055c5:	8b 45 14             	mov    0x14(%ebp),%eax
f01055c8:	8b 10                	mov    (%eax),%edx
f01055ca:	b9 00 00 00 00       	mov    $0x0,%ecx
f01055cf:	8d 40 04             	lea    0x4(%eax),%eax
f01055d2:	89 45 14             	mov    %eax,0x14(%ebp)
     			base = 8;
f01055d5:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f01055da:	eb 28                	jmp    f0105604 <vprintfmt+0x38c>
			putch('0', putdat);
f01055dc:	83 ec 08             	sub    $0x8,%esp
f01055df:	53                   	push   %ebx
f01055e0:	6a 30                	push   $0x30
f01055e2:	ff d6                	call   *%esi
			putch('x', putdat);
f01055e4:	83 c4 08             	add    $0x8,%esp
f01055e7:	53                   	push   %ebx
f01055e8:	6a 78                	push   $0x78
f01055ea:	ff d6                	call   *%esi
			num = (unsigned long long)
f01055ec:	8b 45 14             	mov    0x14(%ebp),%eax
f01055ef:	8b 10                	mov    (%eax),%edx
f01055f1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01055f6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01055f9:	8d 40 04             	lea    0x4(%eax),%eax
f01055fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01055ff:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0105604:	83 ec 0c             	sub    $0xc,%esp
f0105607:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f010560b:	57                   	push   %edi
f010560c:	ff 75 e0             	pushl  -0x20(%ebp)
f010560f:	50                   	push   %eax
f0105610:	51                   	push   %ecx
f0105611:	52                   	push   %edx
f0105612:	89 da                	mov    %ebx,%edx
f0105614:	89 f0                	mov    %esi,%eax
f0105616:	e8 72 fb ff ff       	call   f010518d <printnum>
			break;
f010561b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f010561e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105621:	83 c7 01             	add    $0x1,%edi
f0105624:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105628:	83 f8 25             	cmp    $0x25,%eax
f010562b:	0f 84 62 fc ff ff    	je     f0105293 <vprintfmt+0x1b>
			if (ch == '\0')
f0105631:	85 c0                	test   %eax,%eax
f0105633:	0f 84 8b 00 00 00    	je     f01056c4 <vprintfmt+0x44c>
			putch(ch, putdat);
f0105639:	83 ec 08             	sub    $0x8,%esp
f010563c:	53                   	push   %ebx
f010563d:	50                   	push   %eax
f010563e:	ff d6                	call   *%esi
f0105640:	83 c4 10             	add    $0x10,%esp
f0105643:	eb dc                	jmp    f0105621 <vprintfmt+0x3a9>
	if (lflag >= 2)
f0105645:	83 f9 01             	cmp    $0x1,%ecx
f0105648:	7f 1b                	jg     f0105665 <vprintfmt+0x3ed>
	else if (lflag)
f010564a:	85 c9                	test   %ecx,%ecx
f010564c:	74 2c                	je     f010567a <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
f010564e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105651:	8b 10                	mov    (%eax),%edx
f0105653:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105658:	8d 40 04             	lea    0x4(%eax),%eax
f010565b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010565e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f0105663:	eb 9f                	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105665:	8b 45 14             	mov    0x14(%ebp),%eax
f0105668:	8b 10                	mov    (%eax),%edx
f010566a:	8b 48 04             	mov    0x4(%eax),%ecx
f010566d:	8d 40 08             	lea    0x8(%eax),%eax
f0105670:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105673:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f0105678:	eb 8a                	jmp    f0105604 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f010567a:	8b 45 14             	mov    0x14(%ebp),%eax
f010567d:	8b 10                	mov    (%eax),%edx
f010567f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105684:	8d 40 04             	lea    0x4(%eax),%eax
f0105687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010568a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f010568f:	e9 70 ff ff ff       	jmp    f0105604 <vprintfmt+0x38c>
			putch(ch, putdat);
f0105694:	83 ec 08             	sub    $0x8,%esp
f0105697:	53                   	push   %ebx
f0105698:	6a 25                	push   $0x25
f010569a:	ff d6                	call   *%esi
			break;
f010569c:	83 c4 10             	add    $0x10,%esp
f010569f:	e9 7a ff ff ff       	jmp    f010561e <vprintfmt+0x3a6>
			putch('%', putdat);
f01056a4:	83 ec 08             	sub    $0x8,%esp
f01056a7:	53                   	push   %ebx
f01056a8:	6a 25                	push   $0x25
f01056aa:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01056ac:	83 c4 10             	add    $0x10,%esp
f01056af:	89 f8                	mov    %edi,%eax
f01056b1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01056b5:	74 05                	je     f01056bc <vprintfmt+0x444>
f01056b7:	83 e8 01             	sub    $0x1,%eax
f01056ba:	eb f5                	jmp    f01056b1 <vprintfmt+0x439>
f01056bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01056bf:	e9 5a ff ff ff       	jmp    f010561e <vprintfmt+0x3a6>
}
f01056c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01056c7:	5b                   	pop    %ebx
f01056c8:	5e                   	pop    %esi
f01056c9:	5f                   	pop    %edi
f01056ca:	5d                   	pop    %ebp
f01056cb:	c3                   	ret    

f01056cc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01056cc:	f3 0f 1e fb          	endbr32 
f01056d0:	55                   	push   %ebp
f01056d1:	89 e5                	mov    %esp,%ebp
f01056d3:	83 ec 18             	sub    $0x18,%esp
f01056d6:	8b 45 08             	mov    0x8(%ebp),%eax
f01056d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01056dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01056df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01056e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01056e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01056ed:	85 c0                	test   %eax,%eax
f01056ef:	74 26                	je     f0105717 <vsnprintf+0x4b>
f01056f1:	85 d2                	test   %edx,%edx
f01056f3:	7e 22                	jle    f0105717 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01056f5:	ff 75 14             	pushl  0x14(%ebp)
f01056f8:	ff 75 10             	pushl  0x10(%ebp)
f01056fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01056fe:	50                   	push   %eax
f01056ff:	68 36 52 10 f0       	push   $0xf0105236
f0105704:	e8 6f fb ff ff       	call   f0105278 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105709:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010570c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010570f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105712:	83 c4 10             	add    $0x10,%esp
}
f0105715:	c9                   	leave  
f0105716:	c3                   	ret    
		return -E_INVAL;
f0105717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010571c:	eb f7                	jmp    f0105715 <vsnprintf+0x49>

f010571e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010571e:	f3 0f 1e fb          	endbr32 
f0105722:	55                   	push   %ebp
f0105723:	89 e5                	mov    %esp,%ebp
f0105725:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105728:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010572b:	50                   	push   %eax
f010572c:	ff 75 10             	pushl  0x10(%ebp)
f010572f:	ff 75 0c             	pushl  0xc(%ebp)
f0105732:	ff 75 08             	pushl  0x8(%ebp)
f0105735:	e8 92 ff ff ff       	call   f01056cc <vsnprintf>
	va_end(ap);

	return rc;
}
f010573a:	c9                   	leave  
f010573b:	c3                   	ret    

f010573c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010573c:	f3 0f 1e fb          	endbr32 
f0105740:	55                   	push   %ebp
f0105741:	89 e5                	mov    %esp,%ebp
f0105743:	57                   	push   %edi
f0105744:	56                   	push   %esi
f0105745:	53                   	push   %ebx
f0105746:	83 ec 0c             	sub    $0xc,%esp
f0105749:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010574c:	85 c0                	test   %eax,%eax
f010574e:	74 11                	je     f0105761 <readline+0x25>
		cprintf("%s", prompt);
f0105750:	83 ec 08             	sub    $0x8,%esp
f0105753:	50                   	push   %eax
f0105754:	68 c3 6d 10 f0       	push   $0xf0106dc3
f0105759:	e8 7a e3 ff ff       	call   f0103ad8 <cprintf>
f010575e:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105761:	83 ec 0c             	sub    $0xc,%esp
f0105764:	6a 00                	push   $0x0
f0105766:	e8 67 b0 ff ff       	call   f01007d2 <iscons>
f010576b:	89 c7                	mov    %eax,%edi
f010576d:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105770:	be 00 00 00 00       	mov    $0x0,%esi
f0105775:	eb 57                	jmp    f01057ce <readline+0x92>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105777:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f010577c:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010577f:	75 08                	jne    f0105789 <readline+0x4d>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105781:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105784:	5b                   	pop    %ebx
f0105785:	5e                   	pop    %esi
f0105786:	5f                   	pop    %edi
f0105787:	5d                   	pop    %ebp
f0105788:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105789:	83 ec 08             	sub    $0x8,%esp
f010578c:	53                   	push   %ebx
f010578d:	68 5f 82 10 f0       	push   $0xf010825f
f0105792:	e8 41 e3 ff ff       	call   f0103ad8 <cprintf>
f0105797:	83 c4 10             	add    $0x10,%esp
			return NULL;
f010579a:	b8 00 00 00 00       	mov    $0x0,%eax
f010579f:	eb e0                	jmp    f0105781 <readline+0x45>
			if (echoing)
f01057a1:	85 ff                	test   %edi,%edi
f01057a3:	75 05                	jne    f01057aa <readline+0x6e>
			i--;
f01057a5:	83 ee 01             	sub    $0x1,%esi
f01057a8:	eb 24                	jmp    f01057ce <readline+0x92>
				cputchar('\b');
f01057aa:	83 ec 0c             	sub    $0xc,%esp
f01057ad:	6a 08                	push   $0x8
f01057af:	e8 f5 af ff ff       	call   f01007a9 <cputchar>
f01057b4:	83 c4 10             	add    $0x10,%esp
f01057b7:	eb ec                	jmp    f01057a5 <readline+0x69>
				cputchar(c);
f01057b9:	83 ec 0c             	sub    $0xc,%esp
f01057bc:	53                   	push   %ebx
f01057bd:	e8 e7 af ff ff       	call   f01007a9 <cputchar>
f01057c2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01057c5:	88 9e 80 7a 21 f0    	mov    %bl,-0xfde8580(%esi)
f01057cb:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01057ce:	e8 ea af ff ff       	call   f01007bd <getchar>
f01057d3:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01057d5:	85 c0                	test   %eax,%eax
f01057d7:	78 9e                	js     f0105777 <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01057d9:	83 f8 08             	cmp    $0x8,%eax
f01057dc:	0f 94 c2             	sete   %dl
f01057df:	83 f8 7f             	cmp    $0x7f,%eax
f01057e2:	0f 94 c0             	sete   %al
f01057e5:	08 c2                	or     %al,%dl
f01057e7:	74 04                	je     f01057ed <readline+0xb1>
f01057e9:	85 f6                	test   %esi,%esi
f01057eb:	7f b4                	jg     f01057a1 <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01057ed:	83 fb 1f             	cmp    $0x1f,%ebx
f01057f0:	7e 0e                	jle    f0105800 <readline+0xc4>
f01057f2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01057f8:	7f 06                	jg     f0105800 <readline+0xc4>
			if (echoing)
f01057fa:	85 ff                	test   %edi,%edi
f01057fc:	74 c7                	je     f01057c5 <readline+0x89>
f01057fe:	eb b9                	jmp    f01057b9 <readline+0x7d>
		} else if (c == '\n' || c == '\r') {
f0105800:	83 fb 0a             	cmp    $0xa,%ebx
f0105803:	74 05                	je     f010580a <readline+0xce>
f0105805:	83 fb 0d             	cmp    $0xd,%ebx
f0105808:	75 c4                	jne    f01057ce <readline+0x92>
			if (echoing)
f010580a:	85 ff                	test   %edi,%edi
f010580c:	75 11                	jne    f010581f <readline+0xe3>
			buf[i] = 0;
f010580e:	c6 86 80 7a 21 f0 00 	movb   $0x0,-0xfde8580(%esi)
			return buf;
f0105815:	b8 80 7a 21 f0       	mov    $0xf0217a80,%eax
f010581a:	e9 62 ff ff ff       	jmp    f0105781 <readline+0x45>
				cputchar('\n');
f010581f:	83 ec 0c             	sub    $0xc,%esp
f0105822:	6a 0a                	push   $0xa
f0105824:	e8 80 af ff ff       	call   f01007a9 <cputchar>
f0105829:	83 c4 10             	add    $0x10,%esp
f010582c:	eb e0                	jmp    f010580e <readline+0xd2>

f010582e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010582e:	f3 0f 1e fb          	endbr32 
f0105832:	55                   	push   %ebp
f0105833:	89 e5                	mov    %esp,%ebp
f0105835:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105838:	b8 00 00 00 00       	mov    $0x0,%eax
f010583d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105841:	74 05                	je     f0105848 <strlen+0x1a>
		n++;
f0105843:	83 c0 01             	add    $0x1,%eax
f0105846:	eb f5                	jmp    f010583d <strlen+0xf>
	return n;
}
f0105848:	5d                   	pop    %ebp
f0105849:	c3                   	ret    

f010584a <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010584a:	f3 0f 1e fb          	endbr32 
f010584e:	55                   	push   %ebp
f010584f:	89 e5                	mov    %esp,%ebp
f0105851:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105854:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105857:	b8 00 00 00 00       	mov    $0x0,%eax
f010585c:	39 d0                	cmp    %edx,%eax
f010585e:	74 0d                	je     f010586d <strnlen+0x23>
f0105860:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105864:	74 05                	je     f010586b <strnlen+0x21>
		n++;
f0105866:	83 c0 01             	add    $0x1,%eax
f0105869:	eb f1                	jmp    f010585c <strnlen+0x12>
f010586b:	89 c2                	mov    %eax,%edx
	return n;
}
f010586d:	89 d0                	mov    %edx,%eax
f010586f:	5d                   	pop    %ebp
f0105870:	c3                   	ret    

f0105871 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105871:	f3 0f 1e fb          	endbr32 
f0105875:	55                   	push   %ebp
f0105876:	89 e5                	mov    %esp,%ebp
f0105878:	53                   	push   %ebx
f0105879:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010587c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010587f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105884:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f0105888:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f010588b:	83 c0 01             	add    $0x1,%eax
f010588e:	84 d2                	test   %dl,%dl
f0105890:	75 f2                	jne    f0105884 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0105892:	89 c8                	mov    %ecx,%eax
f0105894:	5b                   	pop    %ebx
f0105895:	5d                   	pop    %ebp
f0105896:	c3                   	ret    

f0105897 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105897:	f3 0f 1e fb          	endbr32 
f010589b:	55                   	push   %ebp
f010589c:	89 e5                	mov    %esp,%ebp
f010589e:	53                   	push   %ebx
f010589f:	83 ec 10             	sub    $0x10,%esp
f01058a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f01058a5:	53                   	push   %ebx
f01058a6:	e8 83 ff ff ff       	call   f010582e <strlen>
f01058ab:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f01058ae:	ff 75 0c             	pushl  0xc(%ebp)
f01058b1:	01 d8                	add    %ebx,%eax
f01058b3:	50                   	push   %eax
f01058b4:	e8 b8 ff ff ff       	call   f0105871 <strcpy>
	return dst;
}
f01058b9:	89 d8                	mov    %ebx,%eax
f01058bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01058be:	c9                   	leave  
f01058bf:	c3                   	ret    

f01058c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01058c0:	f3 0f 1e fb          	endbr32 
f01058c4:	55                   	push   %ebp
f01058c5:	89 e5                	mov    %esp,%ebp
f01058c7:	56                   	push   %esi
f01058c8:	53                   	push   %ebx
f01058c9:	8b 75 08             	mov    0x8(%ebp),%esi
f01058cc:	8b 55 0c             	mov    0xc(%ebp),%edx
f01058cf:	89 f3                	mov    %esi,%ebx
f01058d1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01058d4:	89 f0                	mov    %esi,%eax
f01058d6:	39 d8                	cmp    %ebx,%eax
f01058d8:	74 11                	je     f01058eb <strncpy+0x2b>
		*dst++ = *src;
f01058da:	83 c0 01             	add    $0x1,%eax
f01058dd:	0f b6 0a             	movzbl (%edx),%ecx
f01058e0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01058e3:	80 f9 01             	cmp    $0x1,%cl
f01058e6:	83 da ff             	sbb    $0xffffffff,%edx
f01058e9:	eb eb                	jmp    f01058d6 <strncpy+0x16>
	}
	return ret;
}
f01058eb:	89 f0                	mov    %esi,%eax
f01058ed:	5b                   	pop    %ebx
f01058ee:	5e                   	pop    %esi
f01058ef:	5d                   	pop    %ebp
f01058f0:	c3                   	ret    

f01058f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01058f1:	f3 0f 1e fb          	endbr32 
f01058f5:	55                   	push   %ebp
f01058f6:	89 e5                	mov    %esp,%ebp
f01058f8:	56                   	push   %esi
f01058f9:	53                   	push   %ebx
f01058fa:	8b 75 08             	mov    0x8(%ebp),%esi
f01058fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105900:	8b 55 10             	mov    0x10(%ebp),%edx
f0105903:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105905:	85 d2                	test   %edx,%edx
f0105907:	74 21                	je     f010592a <strlcpy+0x39>
f0105909:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f010590d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f010590f:	39 c2                	cmp    %eax,%edx
f0105911:	74 14                	je     f0105927 <strlcpy+0x36>
f0105913:	0f b6 19             	movzbl (%ecx),%ebx
f0105916:	84 db                	test   %bl,%bl
f0105918:	74 0b                	je     f0105925 <strlcpy+0x34>
			*dst++ = *src++;
f010591a:	83 c1 01             	add    $0x1,%ecx
f010591d:	83 c2 01             	add    $0x1,%edx
f0105920:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105923:	eb ea                	jmp    f010590f <strlcpy+0x1e>
f0105925:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f0105927:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010592a:	29 f0                	sub    %esi,%eax
}
f010592c:	5b                   	pop    %ebx
f010592d:	5e                   	pop    %esi
f010592e:	5d                   	pop    %ebp
f010592f:	c3                   	ret    

f0105930 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105930:	f3 0f 1e fb          	endbr32 
f0105934:	55                   	push   %ebp
f0105935:	89 e5                	mov    %esp,%ebp
f0105937:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010593a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f010593d:	0f b6 01             	movzbl (%ecx),%eax
f0105940:	84 c0                	test   %al,%al
f0105942:	74 0c                	je     f0105950 <strcmp+0x20>
f0105944:	3a 02                	cmp    (%edx),%al
f0105946:	75 08                	jne    f0105950 <strcmp+0x20>
		p++, q++;
f0105948:	83 c1 01             	add    $0x1,%ecx
f010594b:	83 c2 01             	add    $0x1,%edx
f010594e:	eb ed                	jmp    f010593d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105950:	0f b6 c0             	movzbl %al,%eax
f0105953:	0f b6 12             	movzbl (%edx),%edx
f0105956:	29 d0                	sub    %edx,%eax
}
f0105958:	5d                   	pop    %ebp
f0105959:	c3                   	ret    

f010595a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010595a:	f3 0f 1e fb          	endbr32 
f010595e:	55                   	push   %ebp
f010595f:	89 e5                	mov    %esp,%ebp
f0105961:	53                   	push   %ebx
f0105962:	8b 45 08             	mov    0x8(%ebp),%eax
f0105965:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105968:	89 c3                	mov    %eax,%ebx
f010596a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010596d:	eb 06                	jmp    f0105975 <strncmp+0x1b>
		n--, p++, q++;
f010596f:	83 c0 01             	add    $0x1,%eax
f0105972:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105975:	39 d8                	cmp    %ebx,%eax
f0105977:	74 16                	je     f010598f <strncmp+0x35>
f0105979:	0f b6 08             	movzbl (%eax),%ecx
f010597c:	84 c9                	test   %cl,%cl
f010597e:	74 04                	je     f0105984 <strncmp+0x2a>
f0105980:	3a 0a                	cmp    (%edx),%cl
f0105982:	74 eb                	je     f010596f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105984:	0f b6 00             	movzbl (%eax),%eax
f0105987:	0f b6 12             	movzbl (%edx),%edx
f010598a:	29 d0                	sub    %edx,%eax
}
f010598c:	5b                   	pop    %ebx
f010598d:	5d                   	pop    %ebp
f010598e:	c3                   	ret    
		return 0;
f010598f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105994:	eb f6                	jmp    f010598c <strncmp+0x32>

f0105996 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105996:	f3 0f 1e fb          	endbr32 
f010599a:	55                   	push   %ebp
f010599b:	89 e5                	mov    %esp,%ebp
f010599d:	8b 45 08             	mov    0x8(%ebp),%eax
f01059a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01059a4:	0f b6 10             	movzbl (%eax),%edx
f01059a7:	84 d2                	test   %dl,%dl
f01059a9:	74 09                	je     f01059b4 <strchr+0x1e>
		if (*s == c)
f01059ab:	38 ca                	cmp    %cl,%dl
f01059ad:	74 0a                	je     f01059b9 <strchr+0x23>
	for (; *s; s++)
f01059af:	83 c0 01             	add    $0x1,%eax
f01059b2:	eb f0                	jmp    f01059a4 <strchr+0xe>
			return (char *) s;
	return 0;
f01059b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01059b9:	5d                   	pop    %ebp
f01059ba:	c3                   	ret    

f01059bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01059bb:	f3 0f 1e fb          	endbr32 
f01059bf:	55                   	push   %ebp
f01059c0:	89 e5                	mov    %esp,%ebp
f01059c2:	8b 45 08             	mov    0x8(%ebp),%eax
f01059c5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01059c9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01059cc:	38 ca                	cmp    %cl,%dl
f01059ce:	74 09                	je     f01059d9 <strfind+0x1e>
f01059d0:	84 d2                	test   %dl,%dl
f01059d2:	74 05                	je     f01059d9 <strfind+0x1e>
	for (; *s; s++)
f01059d4:	83 c0 01             	add    $0x1,%eax
f01059d7:	eb f0                	jmp    f01059c9 <strfind+0xe>
			break;
	return (char *) s;
}
f01059d9:	5d                   	pop    %ebp
f01059da:	c3                   	ret    

f01059db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01059db:	f3 0f 1e fb          	endbr32 
f01059df:	55                   	push   %ebp
f01059e0:	89 e5                	mov    %esp,%ebp
f01059e2:	57                   	push   %edi
f01059e3:	56                   	push   %esi
f01059e4:	53                   	push   %ebx
f01059e5:	8b 7d 08             	mov    0x8(%ebp),%edi
f01059e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01059eb:	85 c9                	test   %ecx,%ecx
f01059ed:	74 31                	je     f0105a20 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01059ef:	89 f8                	mov    %edi,%eax
f01059f1:	09 c8                	or     %ecx,%eax
f01059f3:	a8 03                	test   $0x3,%al
f01059f5:	75 23                	jne    f0105a1a <memset+0x3f>
		c &= 0xFF;
f01059f7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01059fb:	89 d3                	mov    %edx,%ebx
f01059fd:	c1 e3 08             	shl    $0x8,%ebx
f0105a00:	89 d0                	mov    %edx,%eax
f0105a02:	c1 e0 18             	shl    $0x18,%eax
f0105a05:	89 d6                	mov    %edx,%esi
f0105a07:	c1 e6 10             	shl    $0x10,%esi
f0105a0a:	09 f0                	or     %esi,%eax
f0105a0c:	09 c2                	or     %eax,%edx
f0105a0e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0105a10:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105a13:	89 d0                	mov    %edx,%eax
f0105a15:	fc                   	cld    
f0105a16:	f3 ab                	rep stos %eax,%es:(%edi)
f0105a18:	eb 06                	jmp    f0105a20 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105a1d:	fc                   	cld    
f0105a1e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105a20:	89 f8                	mov    %edi,%eax
f0105a22:	5b                   	pop    %ebx
f0105a23:	5e                   	pop    %esi
f0105a24:	5f                   	pop    %edi
f0105a25:	5d                   	pop    %ebp
f0105a26:	c3                   	ret    

f0105a27 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105a27:	f3 0f 1e fb          	endbr32 
f0105a2b:	55                   	push   %ebp
f0105a2c:	89 e5                	mov    %esp,%ebp
f0105a2e:	57                   	push   %edi
f0105a2f:	56                   	push   %esi
f0105a30:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a33:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105a39:	39 c6                	cmp    %eax,%esi
f0105a3b:	73 32                	jae    f0105a6f <memmove+0x48>
f0105a3d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105a40:	39 c2                	cmp    %eax,%edx
f0105a42:	76 2b                	jbe    f0105a6f <memmove+0x48>
		s += n;
		d += n;
f0105a44:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105a47:	89 fe                	mov    %edi,%esi
f0105a49:	09 ce                	or     %ecx,%esi
f0105a4b:	09 d6                	or     %edx,%esi
f0105a4d:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105a53:	75 0e                	jne    f0105a63 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105a55:	83 ef 04             	sub    $0x4,%edi
f0105a58:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105a5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105a5e:	fd                   	std    
f0105a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105a61:	eb 09                	jmp    f0105a6c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105a63:	83 ef 01             	sub    $0x1,%edi
f0105a66:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105a69:	fd                   	std    
f0105a6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105a6c:	fc                   	cld    
f0105a6d:	eb 1a                	jmp    f0105a89 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105a6f:	89 c2                	mov    %eax,%edx
f0105a71:	09 ca                	or     %ecx,%edx
f0105a73:	09 f2                	or     %esi,%edx
f0105a75:	f6 c2 03             	test   $0x3,%dl
f0105a78:	75 0a                	jne    f0105a84 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105a7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105a7d:	89 c7                	mov    %eax,%edi
f0105a7f:	fc                   	cld    
f0105a80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105a82:	eb 05                	jmp    f0105a89 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105a84:	89 c7                	mov    %eax,%edi
f0105a86:	fc                   	cld    
f0105a87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105a89:	5e                   	pop    %esi
f0105a8a:	5f                   	pop    %edi
f0105a8b:	5d                   	pop    %ebp
f0105a8c:	c3                   	ret    

f0105a8d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105a8d:	f3 0f 1e fb          	endbr32 
f0105a91:	55                   	push   %ebp
f0105a92:	89 e5                	mov    %esp,%ebp
f0105a94:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105a97:	ff 75 10             	pushl  0x10(%ebp)
f0105a9a:	ff 75 0c             	pushl  0xc(%ebp)
f0105a9d:	ff 75 08             	pushl  0x8(%ebp)
f0105aa0:	e8 82 ff ff ff       	call   f0105a27 <memmove>
}
f0105aa5:	c9                   	leave  
f0105aa6:	c3                   	ret    

f0105aa7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105aa7:	f3 0f 1e fb          	endbr32 
f0105aab:	55                   	push   %ebp
f0105aac:	89 e5                	mov    %esp,%ebp
f0105aae:	56                   	push   %esi
f0105aaf:	53                   	push   %ebx
f0105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
f0105ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105ab6:	89 c6                	mov    %eax,%esi
f0105ab8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105abb:	39 f0                	cmp    %esi,%eax
f0105abd:	74 1c                	je     f0105adb <memcmp+0x34>
		if (*s1 != *s2)
f0105abf:	0f b6 08             	movzbl (%eax),%ecx
f0105ac2:	0f b6 1a             	movzbl (%edx),%ebx
f0105ac5:	38 d9                	cmp    %bl,%cl
f0105ac7:	75 08                	jne    f0105ad1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105ac9:	83 c0 01             	add    $0x1,%eax
f0105acc:	83 c2 01             	add    $0x1,%edx
f0105acf:	eb ea                	jmp    f0105abb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f0105ad1:	0f b6 c1             	movzbl %cl,%eax
f0105ad4:	0f b6 db             	movzbl %bl,%ebx
f0105ad7:	29 d8                	sub    %ebx,%eax
f0105ad9:	eb 05                	jmp    f0105ae0 <memcmp+0x39>
	}

	return 0;
f0105adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105ae0:	5b                   	pop    %ebx
f0105ae1:	5e                   	pop    %esi
f0105ae2:	5d                   	pop    %ebp
f0105ae3:	c3                   	ret    

f0105ae4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105ae4:	f3 0f 1e fb          	endbr32 
f0105ae8:	55                   	push   %ebp
f0105ae9:	89 e5                	mov    %esp,%ebp
f0105aeb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105aee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105af1:	89 c2                	mov    %eax,%edx
f0105af3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105af6:	39 d0                	cmp    %edx,%eax
f0105af8:	73 09                	jae    f0105b03 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105afa:	38 08                	cmp    %cl,(%eax)
f0105afc:	74 05                	je     f0105b03 <memfind+0x1f>
	for (; s < ends; s++)
f0105afe:	83 c0 01             	add    $0x1,%eax
f0105b01:	eb f3                	jmp    f0105af6 <memfind+0x12>
			break;
	return (void *) s;
}
f0105b03:	5d                   	pop    %ebp
f0105b04:	c3                   	ret    

f0105b05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105b05:	f3 0f 1e fb          	endbr32 
f0105b09:	55                   	push   %ebp
f0105b0a:	89 e5                	mov    %esp,%ebp
f0105b0c:	57                   	push   %edi
f0105b0d:	56                   	push   %esi
f0105b0e:	53                   	push   %ebx
f0105b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105b12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105b15:	eb 03                	jmp    f0105b1a <strtol+0x15>
		s++;
f0105b17:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105b1a:	0f b6 01             	movzbl (%ecx),%eax
f0105b1d:	3c 20                	cmp    $0x20,%al
f0105b1f:	74 f6                	je     f0105b17 <strtol+0x12>
f0105b21:	3c 09                	cmp    $0x9,%al
f0105b23:	74 f2                	je     f0105b17 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f0105b25:	3c 2b                	cmp    $0x2b,%al
f0105b27:	74 2a                	je     f0105b53 <strtol+0x4e>
	int neg = 0;
f0105b29:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105b2e:	3c 2d                	cmp    $0x2d,%al
f0105b30:	74 2b                	je     f0105b5d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105b32:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105b38:	75 0f                	jne    f0105b49 <strtol+0x44>
f0105b3a:	80 39 30             	cmpb   $0x30,(%ecx)
f0105b3d:	74 28                	je     f0105b67 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105b3f:	85 db                	test   %ebx,%ebx
f0105b41:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105b46:	0f 44 d8             	cmove  %eax,%ebx
f0105b49:	b8 00 00 00 00       	mov    $0x0,%eax
f0105b4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105b51:	eb 46                	jmp    f0105b99 <strtol+0x94>
		s++;
f0105b53:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105b56:	bf 00 00 00 00       	mov    $0x0,%edi
f0105b5b:	eb d5                	jmp    f0105b32 <strtol+0x2d>
		s++, neg = 1;
f0105b5d:	83 c1 01             	add    $0x1,%ecx
f0105b60:	bf 01 00 00 00       	mov    $0x1,%edi
f0105b65:	eb cb                	jmp    f0105b32 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105b67:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105b6b:	74 0e                	je     f0105b7b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105b6d:	85 db                	test   %ebx,%ebx
f0105b6f:	75 d8                	jne    f0105b49 <strtol+0x44>
		s++, base = 8;
f0105b71:	83 c1 01             	add    $0x1,%ecx
f0105b74:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105b79:	eb ce                	jmp    f0105b49 <strtol+0x44>
		s += 2, base = 16;
f0105b7b:	83 c1 02             	add    $0x2,%ecx
f0105b7e:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105b83:	eb c4                	jmp    f0105b49 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105b85:	0f be d2             	movsbl %dl,%edx
f0105b88:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105b8b:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105b8e:	7d 3a                	jge    f0105bca <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105b90:	83 c1 01             	add    $0x1,%ecx
f0105b93:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105b97:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105b99:	0f b6 11             	movzbl (%ecx),%edx
f0105b9c:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105b9f:	89 f3                	mov    %esi,%ebx
f0105ba1:	80 fb 09             	cmp    $0x9,%bl
f0105ba4:	76 df                	jbe    f0105b85 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105ba6:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105ba9:	89 f3                	mov    %esi,%ebx
f0105bab:	80 fb 19             	cmp    $0x19,%bl
f0105bae:	77 08                	ja     f0105bb8 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105bb0:	0f be d2             	movsbl %dl,%edx
f0105bb3:	83 ea 57             	sub    $0x57,%edx
f0105bb6:	eb d3                	jmp    f0105b8b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f0105bb8:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105bbb:	89 f3                	mov    %esi,%ebx
f0105bbd:	80 fb 19             	cmp    $0x19,%bl
f0105bc0:	77 08                	ja     f0105bca <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105bc2:	0f be d2             	movsbl %dl,%edx
f0105bc5:	83 ea 37             	sub    $0x37,%edx
f0105bc8:	eb c1                	jmp    f0105b8b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105bca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105bce:	74 05                	je     f0105bd5 <strtol+0xd0>
		*endptr = (char *) s;
f0105bd0:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105bd3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105bd5:	89 c2                	mov    %eax,%edx
f0105bd7:	f7 da                	neg    %edx
f0105bd9:	85 ff                	test   %edi,%edi
f0105bdb:	0f 45 c2             	cmovne %edx,%eax
}
f0105bde:	5b                   	pop    %ebx
f0105bdf:	5e                   	pop    %esi
f0105be0:	5f                   	pop    %edi
f0105be1:	5d                   	pop    %ebp
f0105be2:	c3                   	ret    
f0105be3:	90                   	nop

f0105be4 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105be4:	fa                   	cli    

	xorw    %ax, %ax
f0105be5:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105be7:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105be9:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105beb:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105bed:	0f 01 16             	lgdtl  (%esi)
f0105bf0:	74 70                	je     f0105c62 <mpsearch1+0x3>
	movl    %cr0, %eax
f0105bf2:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105bf5:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105bf9:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105bfc:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105c02:	08 00                	or     %al,(%eax)

f0105c04 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105c04:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105c08:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105c0a:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105c0c:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105c0e:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105c12:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105c14:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105c16:	b8 00 10 12 00       	mov    $0x121000,%eax
	movl    %eax, %cr3
f0105c1b:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105c1e:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105c21:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105c26:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105c29:	8b 25 84 7e 21 f0    	mov    0xf0217e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105c2f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105c34:	b8 bd 01 10 f0       	mov    $0xf01001bd,%eax
	call    *%eax
f0105c39:	ff d0                	call   *%eax

f0105c3b <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105c3b:	eb fe                	jmp    f0105c3b <spin>
f0105c3d:	8d 76 00             	lea    0x0(%esi),%esi

f0105c40 <gdt>:
	...
f0105c48:	ff                   	(bad)  
f0105c49:	ff 00                	incl   (%eax)
f0105c4b:	00 00                	add    %al,(%eax)
f0105c4d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105c54:	00                   	.byte 0x0
f0105c55:	92                   	xchg   %eax,%edx
f0105c56:	cf                   	iret   
	...

f0105c58 <gdtdesc>:
f0105c58:	17                   	pop    %ss
f0105c59:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105c5e <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105c5e:	90                   	nop

f0105c5f <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105c5f:	55                   	push   %ebp
f0105c60:	89 e5                	mov    %esp,%ebp
f0105c62:	57                   	push   %edi
f0105c63:	56                   	push   %esi
f0105c64:	53                   	push   %ebx
f0105c65:	83 ec 0c             	sub    $0xc,%esp
f0105c68:	89 c7                	mov    %eax,%edi
	if (PGNUM(pa) >= npages)
f0105c6a:	a1 88 7e 21 f0       	mov    0xf0217e88,%eax
f0105c6f:	89 f9                	mov    %edi,%ecx
f0105c71:	c1 e9 0c             	shr    $0xc,%ecx
f0105c74:	39 c1                	cmp    %eax,%ecx
f0105c76:	73 19                	jae    f0105c91 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105c78:	8d 9f 00 00 00 f0    	lea    -0x10000000(%edi),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105c7e:	01 d7                	add    %edx,%edi
	if (PGNUM(pa) >= npages)
f0105c80:	89 fa                	mov    %edi,%edx
f0105c82:	c1 ea 0c             	shr    $0xc,%edx
f0105c85:	39 c2                	cmp    %eax,%edx
f0105c87:	73 1a                	jae    f0105ca3 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105c89:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0105c8f:	eb 27                	jmp    f0105cb8 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105c91:	57                   	push   %edi
f0105c92:	68 a4 66 10 f0       	push   $0xf01066a4
f0105c97:	6a 57                	push   $0x57
f0105c99:	68 fd 83 10 f0       	push   $0xf01083fd
f0105c9e:	e8 9d a3 ff ff       	call   f0100040 <_panic>
f0105ca3:	57                   	push   %edi
f0105ca4:	68 a4 66 10 f0       	push   $0xf01066a4
f0105ca9:	6a 57                	push   $0x57
f0105cab:	68 fd 83 10 f0       	push   $0xf01083fd
f0105cb0:	e8 8b a3 ff ff       	call   f0100040 <_panic>
f0105cb5:	83 c3 10             	add    $0x10,%ebx
f0105cb8:	39 fb                	cmp    %edi,%ebx
f0105cba:	73 30                	jae    f0105cec <mpsearch1+0x8d>
f0105cbc:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105cbe:	83 ec 04             	sub    $0x4,%esp
f0105cc1:	6a 04                	push   $0x4
f0105cc3:	68 0d 84 10 f0       	push   $0xf010840d
f0105cc8:	53                   	push   %ebx
f0105cc9:	e8 d9 fd ff ff       	call   f0105aa7 <memcmp>
f0105cce:	83 c4 10             	add    $0x10,%esp
f0105cd1:	85 c0                	test   %eax,%eax
f0105cd3:	75 e0                	jne    f0105cb5 <mpsearch1+0x56>
f0105cd5:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0105cd7:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0105cda:	0f b6 0a             	movzbl (%edx),%ecx
f0105cdd:	01 c8                	add    %ecx,%eax
f0105cdf:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105ce2:	39 f2                	cmp    %esi,%edx
f0105ce4:	75 f4                	jne    f0105cda <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105ce6:	84 c0                	test   %al,%al
f0105ce8:	75 cb                	jne    f0105cb5 <mpsearch1+0x56>
f0105cea:	eb 05                	jmp    f0105cf1 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105cec:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105cf1:	89 d8                	mov    %ebx,%eax
f0105cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105cf6:	5b                   	pop    %ebx
f0105cf7:	5e                   	pop    %esi
f0105cf8:	5f                   	pop    %edi
f0105cf9:	5d                   	pop    %ebp
f0105cfa:	c3                   	ret    

f0105cfb <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105cfb:	f3 0f 1e fb          	endbr32 
f0105cff:	55                   	push   %ebp
f0105d00:	89 e5                	mov    %esp,%ebp
f0105d02:	57                   	push   %edi
f0105d03:	56                   	push   %esi
f0105d04:	53                   	push   %ebx
f0105d05:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105d08:	c7 05 c0 83 21 f0 20 	movl   $0xf0218020,0xf02183c0
f0105d0f:	80 21 f0 
	if (PGNUM(pa) >= npages)
f0105d12:	83 3d 88 7e 21 f0 00 	cmpl   $0x0,0xf0217e88
f0105d19:	0f 84 a3 00 00 00    	je     f0105dc2 <mp_init+0xc7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105d1f:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105d26:	85 c0                	test   %eax,%eax
f0105d28:	0f 84 aa 00 00 00    	je     f0105dd8 <mp_init+0xdd>
		p <<= 4;	// Translate from segment to PA
f0105d2e:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105d31:	ba 00 04 00 00       	mov    $0x400,%edx
f0105d36:	e8 24 ff ff ff       	call   f0105c5f <mpsearch1>
f0105d3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105d3e:	85 c0                	test   %eax,%eax
f0105d40:	75 1a                	jne    f0105d5c <mp_init+0x61>
	return mpsearch1(0xF0000, 0x10000);
f0105d42:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105d47:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105d4c:	e8 0e ff ff ff       	call   f0105c5f <mpsearch1>
f0105d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105d54:	85 c0                	test   %eax,%eax
f0105d56:	0f 84 35 02 00 00    	je     f0105f91 <mp_init+0x296>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d5f:	8b 58 04             	mov    0x4(%eax),%ebx
f0105d62:	85 db                	test   %ebx,%ebx
f0105d64:	0f 84 97 00 00 00    	je     f0105e01 <mp_init+0x106>
f0105d6a:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105d6e:	0f 85 8d 00 00 00    	jne    f0105e01 <mp_init+0x106>
f0105d74:	89 d8                	mov    %ebx,%eax
f0105d76:	c1 e8 0c             	shr    $0xc,%eax
f0105d79:	3b 05 88 7e 21 f0    	cmp    0xf0217e88,%eax
f0105d7f:	0f 83 91 00 00 00    	jae    f0105e16 <mp_init+0x11b>
	return (void *)(pa + KERNBASE);
f0105d85:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105d8b:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105d8d:	83 ec 04             	sub    $0x4,%esp
f0105d90:	6a 04                	push   $0x4
f0105d92:	68 12 84 10 f0       	push   $0xf0108412
f0105d97:	53                   	push   %ebx
f0105d98:	e8 0a fd ff ff       	call   f0105aa7 <memcmp>
f0105d9d:	83 c4 10             	add    $0x10,%esp
f0105da0:	85 c0                	test   %eax,%eax
f0105da2:	0f 85 83 00 00 00    	jne    f0105e2b <mp_init+0x130>
f0105da8:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105dac:	01 df                	add    %ebx,%edi
	sum = 0;
f0105dae:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105db0:	39 fb                	cmp    %edi,%ebx
f0105db2:	0f 84 88 00 00 00    	je     f0105e40 <mp_init+0x145>
		sum += ((uint8_t *)addr)[i];
f0105db8:	0f b6 0b             	movzbl (%ebx),%ecx
f0105dbb:	01 ca                	add    %ecx,%edx
f0105dbd:	83 c3 01             	add    $0x1,%ebx
f0105dc0:	eb ee                	jmp    f0105db0 <mp_init+0xb5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105dc2:	68 00 04 00 00       	push   $0x400
f0105dc7:	68 a4 66 10 f0       	push   $0xf01066a4
f0105dcc:	6a 6f                	push   $0x6f
f0105dce:	68 fd 83 10 f0       	push   $0xf01083fd
f0105dd3:	e8 68 a2 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105dd8:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105ddf:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105de2:	2d 00 04 00 00       	sub    $0x400,%eax
f0105de7:	ba 00 04 00 00       	mov    $0x400,%edx
f0105dec:	e8 6e fe ff ff       	call   f0105c5f <mpsearch1>
f0105df1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105df4:	85 c0                	test   %eax,%eax
f0105df6:	0f 85 60 ff ff ff    	jne    f0105d5c <mp_init+0x61>
f0105dfc:	e9 41 ff ff ff       	jmp    f0105d42 <mp_init+0x47>
		cprintf("SMP: Default configurations not implemented\n");
f0105e01:	83 ec 0c             	sub    $0xc,%esp
f0105e04:	68 70 82 10 f0       	push   $0xf0108270
f0105e09:	e8 ca dc ff ff       	call   f0103ad8 <cprintf>
		return NULL;
f0105e0e:	83 c4 10             	add    $0x10,%esp
f0105e11:	e9 7b 01 00 00       	jmp    f0105f91 <mp_init+0x296>
f0105e16:	53                   	push   %ebx
f0105e17:	68 a4 66 10 f0       	push   $0xf01066a4
f0105e1c:	68 90 00 00 00       	push   $0x90
f0105e21:	68 fd 83 10 f0       	push   $0xf01083fd
f0105e26:	e8 15 a2 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105e2b:	83 ec 0c             	sub    $0xc,%esp
f0105e2e:	68 a0 82 10 f0       	push   $0xf01082a0
f0105e33:	e8 a0 dc ff ff       	call   f0103ad8 <cprintf>
		return NULL;
f0105e38:	83 c4 10             	add    $0x10,%esp
f0105e3b:	e9 51 01 00 00       	jmp    f0105f91 <mp_init+0x296>
	if (sum(conf, conf->length) != 0) {
f0105e40:	84 d2                	test   %dl,%dl
f0105e42:	75 22                	jne    f0105e66 <mp_init+0x16b>
	if (conf->version != 1 && conf->version != 4) {
f0105e44:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105e48:	80 fa 01             	cmp    $0x1,%dl
f0105e4b:	74 05                	je     f0105e52 <mp_init+0x157>
f0105e4d:	80 fa 04             	cmp    $0x4,%dl
f0105e50:	75 29                	jne    f0105e7b <mp_init+0x180>
f0105e52:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105e56:	01 d9                	add    %ebx,%ecx
	for (i = 0; i < len; i++)
f0105e58:	39 d9                	cmp    %ebx,%ecx
f0105e5a:	74 38                	je     f0105e94 <mp_init+0x199>
		sum += ((uint8_t *)addr)[i];
f0105e5c:	0f b6 13             	movzbl (%ebx),%edx
f0105e5f:	01 d0                	add    %edx,%eax
f0105e61:	83 c3 01             	add    $0x1,%ebx
f0105e64:	eb f2                	jmp    f0105e58 <mp_init+0x15d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105e66:	83 ec 0c             	sub    $0xc,%esp
f0105e69:	68 d4 82 10 f0       	push   $0xf01082d4
f0105e6e:	e8 65 dc ff ff       	call   f0103ad8 <cprintf>
		return NULL;
f0105e73:	83 c4 10             	add    $0x10,%esp
f0105e76:	e9 16 01 00 00       	jmp    f0105f91 <mp_init+0x296>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105e7b:	83 ec 08             	sub    $0x8,%esp
f0105e7e:	0f b6 d2             	movzbl %dl,%edx
f0105e81:	52                   	push   %edx
f0105e82:	68 f8 82 10 f0       	push   $0xf01082f8
f0105e87:	e8 4c dc ff ff       	call   f0103ad8 <cprintf>
		return NULL;
f0105e8c:	83 c4 10             	add    $0x10,%esp
f0105e8f:	e9 fd 00 00 00       	jmp    f0105f91 <mp_init+0x296>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105e94:	02 46 2a             	add    0x2a(%esi),%al
f0105e97:	75 1c                	jne    f0105eb5 <mp_init+0x1ba>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0105e99:	c7 05 00 80 21 f0 01 	movl   $0x1,0xf0218000
f0105ea0:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105ea3:	8b 46 24             	mov    0x24(%esi),%eax
f0105ea6:	a3 00 90 25 f0       	mov    %eax,0xf0259000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105eab:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105eae:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105eb3:	eb 4d                	jmp    f0105f02 <mp_init+0x207>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105eb5:	83 ec 0c             	sub    $0xc,%esp
f0105eb8:	68 18 83 10 f0       	push   $0xf0108318
f0105ebd:	e8 16 dc ff ff       	call   f0103ad8 <cprintf>
		return NULL;
f0105ec2:	83 c4 10             	add    $0x10,%esp
f0105ec5:	e9 c7 00 00 00       	jmp    f0105f91 <mp_init+0x296>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105eca:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105ece:	74 11                	je     f0105ee1 <mp_init+0x1e6>
				bootcpu = &cpus[ncpu];
f0105ed0:	6b 05 c4 83 21 f0 74 	imul   $0x74,0xf02183c4,%eax
f0105ed7:	05 20 80 21 f0       	add    $0xf0218020,%eax
f0105edc:	a3 c0 83 21 f0       	mov    %eax,0xf02183c0
			if (ncpu < NCPU) {
f0105ee1:	a1 c4 83 21 f0       	mov    0xf02183c4,%eax
f0105ee6:	83 f8 07             	cmp    $0x7,%eax
f0105ee9:	7f 33                	jg     f0105f1e <mp_init+0x223>
				cpus[ncpu].cpu_id = ncpu;
f0105eeb:	6b d0 74             	imul   $0x74,%eax,%edx
f0105eee:	88 82 20 80 21 f0    	mov    %al,-0xfde7fe0(%edx)
				ncpu++;
f0105ef4:	83 c0 01             	add    $0x1,%eax
f0105ef7:	a3 c4 83 21 f0       	mov    %eax,0xf02183c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105efc:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105eff:	83 c3 01             	add    $0x1,%ebx
f0105f02:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105f06:	39 d8                	cmp    %ebx,%eax
f0105f08:	76 4f                	jbe    f0105f59 <mp_init+0x25e>
		switch (*p) {
f0105f0a:	0f b6 07             	movzbl (%edi),%eax
f0105f0d:	84 c0                	test   %al,%al
f0105f0f:	74 b9                	je     f0105eca <mp_init+0x1cf>
f0105f11:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105f14:	80 fa 03             	cmp    $0x3,%dl
f0105f17:	77 1c                	ja     f0105f35 <mp_init+0x23a>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105f19:	83 c7 08             	add    $0x8,%edi
			continue;
f0105f1c:	eb e1                	jmp    f0105eff <mp_init+0x204>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105f1e:	83 ec 08             	sub    $0x8,%esp
f0105f21:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105f25:	50                   	push   %eax
f0105f26:	68 48 83 10 f0       	push   $0xf0108348
f0105f2b:	e8 a8 db ff ff       	call   f0103ad8 <cprintf>
f0105f30:	83 c4 10             	add    $0x10,%esp
f0105f33:	eb c7                	jmp    f0105efc <mp_init+0x201>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105f35:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105f38:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105f3b:	50                   	push   %eax
f0105f3c:	68 70 83 10 f0       	push   $0xf0108370
f0105f41:	e8 92 db ff ff       	call   f0103ad8 <cprintf>
			ismp = 0;
f0105f46:	c7 05 00 80 21 f0 00 	movl   $0x0,0xf0218000
f0105f4d:	00 00 00 
			i = conf->entry;
f0105f50:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105f54:	83 c4 10             	add    $0x10,%esp
f0105f57:	eb a6                	jmp    f0105eff <mp_init+0x204>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105f59:	a1 c0 83 21 f0       	mov    0xf02183c0,%eax
f0105f5e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105f65:	83 3d 00 80 21 f0 00 	cmpl   $0x0,0xf0218000
f0105f6c:	74 2b                	je     f0105f99 <mp_init+0x29e>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105f6e:	83 ec 04             	sub    $0x4,%esp
f0105f71:	ff 35 c4 83 21 f0    	pushl  0xf02183c4
f0105f77:	0f b6 00             	movzbl (%eax),%eax
f0105f7a:	50                   	push   %eax
f0105f7b:	68 17 84 10 f0       	push   $0xf0108417
f0105f80:	e8 53 db ff ff       	call   f0103ad8 <cprintf>

	if (mp->imcrp) {
f0105f85:	83 c4 10             	add    $0x10,%esp
f0105f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f8b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105f8f:	75 2e                	jne    f0105fbf <mp_init+0x2c4>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105f94:	5b                   	pop    %ebx
f0105f95:	5e                   	pop    %esi
f0105f96:	5f                   	pop    %edi
f0105f97:	5d                   	pop    %ebp
f0105f98:	c3                   	ret    
		ncpu = 1;
f0105f99:	c7 05 c4 83 21 f0 01 	movl   $0x1,0xf02183c4
f0105fa0:	00 00 00 
		lapicaddr = 0;
f0105fa3:	c7 05 00 90 25 f0 00 	movl   $0x0,0xf0259000
f0105faa:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105fad:	83 ec 0c             	sub    $0xc,%esp
f0105fb0:	68 90 83 10 f0       	push   $0xf0108390
f0105fb5:	e8 1e db ff ff       	call   f0103ad8 <cprintf>
		return;
f0105fba:	83 c4 10             	add    $0x10,%esp
f0105fbd:	eb d2                	jmp    f0105f91 <mp_init+0x296>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105fbf:	83 ec 0c             	sub    $0xc,%esp
f0105fc2:	68 bc 83 10 f0       	push   $0xf01083bc
f0105fc7:	e8 0c db ff ff       	call   f0103ad8 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105fcc:	b8 70 00 00 00       	mov    $0x70,%eax
f0105fd1:	ba 22 00 00 00       	mov    $0x22,%edx
f0105fd6:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105fd7:	ba 23 00 00 00       	mov    $0x23,%edx
f0105fdc:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105fdd:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105fe0:	ee                   	out    %al,(%dx)
}
f0105fe1:	83 c4 10             	add    $0x10,%esp
f0105fe4:	eb ab                	jmp    f0105f91 <mp_init+0x296>

f0105fe6 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0105fe6:	8b 0d 04 90 25 f0    	mov    0xf0259004,%ecx
f0105fec:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105fef:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105ff1:	a1 04 90 25 f0       	mov    0xf0259004,%eax
f0105ff6:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105ff9:	c3                   	ret    

f0105ffa <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105ffa:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105ffe:	8b 15 04 90 25 f0    	mov    0xf0259004,%edx
		return lapic[ID] >> 24;
	return 0;
f0106004:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0106009:	85 d2                	test   %edx,%edx
f010600b:	74 06                	je     f0106013 <cpunum+0x19>
		return lapic[ID] >> 24;
f010600d:	8b 42 20             	mov    0x20(%edx),%eax
f0106010:	c1 e8 18             	shr    $0x18,%eax
}
f0106013:	c3                   	ret    

f0106014 <lapic_init>:
{
f0106014:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f0106018:	a1 00 90 25 f0       	mov    0xf0259000,%eax
f010601d:	85 c0                	test   %eax,%eax
f010601f:	75 01                	jne    f0106022 <lapic_init+0xe>
f0106021:	c3                   	ret    
{
f0106022:	55                   	push   %ebp
f0106023:	89 e5                	mov    %esp,%ebp
f0106025:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106028:	68 00 10 00 00       	push   $0x1000
f010602d:	50                   	push   %eax
f010602e:	e8 18 b4 ff ff       	call   f010144b <mmio_map_region>
f0106033:	a3 04 90 25 f0       	mov    %eax,0xf0259004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106038:	ba 27 01 00 00       	mov    $0x127,%edx
f010603d:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106042:	e8 9f ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(TDCR, X1);
f0106047:	ba 0b 00 00 00       	mov    $0xb,%edx
f010604c:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106051:	e8 90 ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106056:	ba 20 00 02 00       	mov    $0x20020,%edx
f010605b:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106060:	e8 81 ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(TICR, 10000000); 
f0106065:	ba 80 96 98 00       	mov    $0x989680,%edx
f010606a:	b8 e0 00 00 00       	mov    $0xe0,%eax
f010606f:	e8 72 ff ff ff       	call   f0105fe6 <lapicw>
	if (thiscpu != bootcpu)
f0106074:	e8 81 ff ff ff       	call   f0105ffa <cpunum>
f0106079:	6b c0 74             	imul   $0x74,%eax,%eax
f010607c:	05 20 80 21 f0       	add    $0xf0218020,%eax
f0106081:	83 c4 10             	add    $0x10,%esp
f0106084:	39 05 c0 83 21 f0    	cmp    %eax,0xf02183c0
f010608a:	74 0f                	je     f010609b <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f010608c:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106091:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106096:	e8 4b ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(LINT1, MASKED);
f010609b:	ba 00 00 01 00       	mov    $0x10000,%edx
f01060a0:	b8 d8 00 00 00       	mov    $0xd8,%eax
f01060a5:	e8 3c ff ff ff       	call   f0105fe6 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f01060aa:	a1 04 90 25 f0       	mov    0xf0259004,%eax
f01060af:	8b 40 30             	mov    0x30(%eax),%eax
f01060b2:	c1 e8 10             	shr    $0x10,%eax
f01060b5:	a8 fc                	test   $0xfc,%al
f01060b7:	75 7c                	jne    f0106135 <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f01060b9:	ba 33 00 00 00       	mov    $0x33,%edx
f01060be:	b8 dc 00 00 00       	mov    $0xdc,%eax
f01060c3:	e8 1e ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(ESR, 0);
f01060c8:	ba 00 00 00 00       	mov    $0x0,%edx
f01060cd:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01060d2:	e8 0f ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(ESR, 0);
f01060d7:	ba 00 00 00 00       	mov    $0x0,%edx
f01060dc:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01060e1:	e8 00 ff ff ff       	call   f0105fe6 <lapicw>
	lapicw(EOI, 0);
f01060e6:	ba 00 00 00 00       	mov    $0x0,%edx
f01060eb:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01060f0:	e8 f1 fe ff ff       	call   f0105fe6 <lapicw>
	lapicw(ICRHI, 0);
f01060f5:	ba 00 00 00 00       	mov    $0x0,%edx
f01060fa:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01060ff:	e8 e2 fe ff ff       	call   f0105fe6 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106104:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106109:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010610e:	e8 d3 fe ff ff       	call   f0105fe6 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106113:	8b 15 04 90 25 f0    	mov    0xf0259004,%edx
f0106119:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010611f:	f6 c4 10             	test   $0x10,%ah
f0106122:	75 f5                	jne    f0106119 <lapic_init+0x105>
	lapicw(TPR, 0);
f0106124:	ba 00 00 00 00       	mov    $0x0,%edx
f0106129:	b8 20 00 00 00       	mov    $0x20,%eax
f010612e:	e8 b3 fe ff ff       	call   f0105fe6 <lapicw>
}
f0106133:	c9                   	leave  
f0106134:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106135:	ba 00 00 01 00       	mov    $0x10000,%edx
f010613a:	b8 d0 00 00 00       	mov    $0xd0,%eax
f010613f:	e8 a2 fe ff ff       	call   f0105fe6 <lapicw>
f0106144:	e9 70 ff ff ff       	jmp    f01060b9 <lapic_init+0xa5>

f0106149 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0106149:	f3 0f 1e fb          	endbr32 
	if (lapic)
f010614d:	83 3d 04 90 25 f0 00 	cmpl   $0x0,0xf0259004
f0106154:	74 17                	je     f010616d <lapic_eoi+0x24>
{
f0106156:	55                   	push   %ebp
f0106157:	89 e5                	mov    %esp,%ebp
f0106159:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f010615c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106161:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106166:	e8 7b fe ff ff       	call   f0105fe6 <lapicw>
}
f010616b:	c9                   	leave  
f010616c:	c3                   	ret    
f010616d:	c3                   	ret    

f010616e <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010616e:	f3 0f 1e fb          	endbr32 
f0106172:	55                   	push   %ebp
f0106173:	89 e5                	mov    %esp,%ebp
f0106175:	56                   	push   %esi
f0106176:	53                   	push   %ebx
f0106177:	8b 75 08             	mov    0x8(%ebp),%esi
f010617a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010617d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106182:	ba 70 00 00 00       	mov    $0x70,%edx
f0106187:	ee                   	out    %al,(%dx)
f0106188:	b8 0a 00 00 00       	mov    $0xa,%eax
f010618d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106192:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106193:	83 3d 88 7e 21 f0 00 	cmpl   $0x0,0xf0217e88
f010619a:	74 7e                	je     f010621a <lapic_startap+0xac>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f010619c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f01061a3:	00 00 
	wrv[1] = addr >> 4;
f01061a5:	89 d8                	mov    %ebx,%eax
f01061a7:	c1 e8 04             	shr    $0x4,%eax
f01061aa:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f01061b0:	c1 e6 18             	shl    $0x18,%esi
f01061b3:	89 f2                	mov    %esi,%edx
f01061b5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01061ba:	e8 27 fe ff ff       	call   f0105fe6 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f01061bf:	ba 00 c5 00 00       	mov    $0xc500,%edx
f01061c4:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01061c9:	e8 18 fe ff ff       	call   f0105fe6 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f01061ce:	ba 00 85 00 00       	mov    $0x8500,%edx
f01061d3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01061d8:	e8 09 fe ff ff       	call   f0105fe6 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01061dd:	c1 eb 0c             	shr    $0xc,%ebx
f01061e0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01061e3:	89 f2                	mov    %esi,%edx
f01061e5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01061ea:	e8 f7 fd ff ff       	call   f0105fe6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01061ef:	89 da                	mov    %ebx,%edx
f01061f1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01061f6:	e8 eb fd ff ff       	call   f0105fe6 <lapicw>
		lapicw(ICRHI, apicid << 24);
f01061fb:	89 f2                	mov    %esi,%edx
f01061fd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106202:	e8 df fd ff ff       	call   f0105fe6 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106207:	89 da                	mov    %ebx,%edx
f0106209:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010620e:	e8 d3 fd ff ff       	call   f0105fe6 <lapicw>
		microdelay(200);
	}
}
f0106213:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106216:	5b                   	pop    %ebx
f0106217:	5e                   	pop    %esi
f0106218:	5d                   	pop    %ebp
f0106219:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010621a:	68 67 04 00 00       	push   $0x467
f010621f:	68 a4 66 10 f0       	push   $0xf01066a4
f0106224:	68 98 00 00 00       	push   $0x98
f0106229:	68 34 84 10 f0       	push   $0xf0108434
f010622e:	e8 0d 9e ff ff       	call   f0100040 <_panic>

f0106233 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106233:	f3 0f 1e fb          	endbr32 
f0106237:	55                   	push   %ebp
f0106238:	89 e5                	mov    %esp,%ebp
f010623a:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f010623d:	8b 55 08             	mov    0x8(%ebp),%edx
f0106240:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106246:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010624b:	e8 96 fd ff ff       	call   f0105fe6 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106250:	8b 15 04 90 25 f0    	mov    0xf0259004,%edx
f0106256:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f010625c:	f6 c4 10             	test   $0x10,%ah
f010625f:	75 f5                	jne    f0106256 <lapic_ipi+0x23>
		;
}
f0106261:	c9                   	leave  
f0106262:	c3                   	ret    

f0106263 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106263:	f3 0f 1e fb          	endbr32 
f0106267:	55                   	push   %ebp
f0106268:	89 e5                	mov    %esp,%ebp
f010626a:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010626d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106273:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106276:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0106279:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106280:	5d                   	pop    %ebp
f0106281:	c3                   	ret    

f0106282 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106282:	f3 0f 1e fb          	endbr32 
f0106286:	55                   	push   %ebp
f0106287:	89 e5                	mov    %esp,%ebp
f0106289:	56                   	push   %esi
f010628a:	53                   	push   %ebx
f010628b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010628e:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106291:	75 07                	jne    f010629a <spin_lock+0x18>
	asm volatile("lock; xchgl %0, %1"
f0106293:	ba 01 00 00 00       	mov    $0x1,%edx
f0106298:	eb 34                	jmp    f01062ce <spin_lock+0x4c>
f010629a:	8b 73 08             	mov    0x8(%ebx),%esi
f010629d:	e8 58 fd ff ff       	call   f0105ffa <cpunum>
f01062a2:	6b c0 74             	imul   $0x74,%eax,%eax
f01062a5:	05 20 80 21 f0       	add    $0xf0218020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f01062aa:	39 c6                	cmp    %eax,%esi
f01062ac:	75 e5                	jne    f0106293 <spin_lock+0x11>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f01062ae:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01062b1:	e8 44 fd ff ff       	call   f0105ffa <cpunum>
f01062b6:	83 ec 0c             	sub    $0xc,%esp
f01062b9:	53                   	push   %ebx
f01062ba:	50                   	push   %eax
f01062bb:	68 44 84 10 f0       	push   $0xf0108444
f01062c0:	6a 41                	push   $0x41
f01062c2:	68 a6 84 10 f0       	push   $0xf01084a6
f01062c7:	e8 74 9d ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f01062cc:	f3 90                	pause  
f01062ce:	89 d0                	mov    %edx,%eax
f01062d0:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f01062d3:	85 c0                	test   %eax,%eax
f01062d5:	75 f5                	jne    f01062cc <spin_lock+0x4a>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01062d7:	e8 1e fd ff ff       	call   f0105ffa <cpunum>
f01062dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01062df:	05 20 80 21 f0       	add    $0xf0218020,%eax
f01062e4:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01062e7:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01062e9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01062ee:	83 f8 09             	cmp    $0x9,%eax
f01062f1:	7f 21                	jg     f0106314 <spin_lock+0x92>
f01062f3:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01062f9:	76 19                	jbe    f0106314 <spin_lock+0x92>
		pcs[i] = ebp[1];          // saved %eip
f01062fb:	8b 4a 04             	mov    0x4(%edx),%ecx
f01062fe:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106302:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106304:	83 c0 01             	add    $0x1,%eax
f0106307:	eb e5                	jmp    f01062ee <spin_lock+0x6c>
		pcs[i] = 0;
f0106309:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0106310:	00 
	for (; i < 10; i++)
f0106311:	83 c0 01             	add    $0x1,%eax
f0106314:	83 f8 09             	cmp    $0x9,%eax
f0106317:	7e f0                	jle    f0106309 <spin_lock+0x87>
	get_caller_pcs(lk->pcs);
#endif
}
f0106319:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010631c:	5b                   	pop    %ebx
f010631d:	5e                   	pop    %esi
f010631e:	5d                   	pop    %ebp
f010631f:	c3                   	ret    

f0106320 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106320:	f3 0f 1e fb          	endbr32 
f0106324:	55                   	push   %ebp
f0106325:	89 e5                	mov    %esp,%ebp
f0106327:	57                   	push   %edi
f0106328:	56                   	push   %esi
f0106329:	53                   	push   %ebx
f010632a:	83 ec 4c             	sub    $0x4c,%esp
f010632d:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106330:	83 3e 00             	cmpl   $0x0,(%esi)
f0106333:	75 35                	jne    f010636a <spin_unlock+0x4a>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106335:	83 ec 04             	sub    $0x4,%esp
f0106338:	6a 28                	push   $0x28
f010633a:	8d 46 0c             	lea    0xc(%esi),%eax
f010633d:	50                   	push   %eax
f010633e:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106341:	53                   	push   %ebx
f0106342:	e8 e0 f6 ff ff       	call   f0105a27 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106347:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010634a:	0f b6 38             	movzbl (%eax),%edi
f010634d:	8b 76 04             	mov    0x4(%esi),%esi
f0106350:	e8 a5 fc ff ff       	call   f0105ffa <cpunum>
f0106355:	57                   	push   %edi
f0106356:	56                   	push   %esi
f0106357:	50                   	push   %eax
f0106358:	68 70 84 10 f0       	push   $0xf0108470
f010635d:	e8 76 d7 ff ff       	call   f0103ad8 <cprintf>
f0106362:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106365:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106368:	eb 4e                	jmp    f01063b8 <spin_unlock+0x98>
	return lock->locked && lock->cpu == thiscpu;
f010636a:	8b 5e 08             	mov    0x8(%esi),%ebx
f010636d:	e8 88 fc ff ff       	call   f0105ffa <cpunum>
f0106372:	6b c0 74             	imul   $0x74,%eax,%eax
f0106375:	05 20 80 21 f0       	add    $0xf0218020,%eax
	if (!holding(lk)) {
f010637a:	39 c3                	cmp    %eax,%ebx
f010637c:	75 b7                	jne    f0106335 <spin_unlock+0x15>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f010637e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106385:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010638c:	b8 00 00 00 00       	mov    $0x0,%eax
f0106391:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106394:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106397:	5b                   	pop    %ebx
f0106398:	5e                   	pop    %esi
f0106399:	5f                   	pop    %edi
f010639a:	5d                   	pop    %ebp
f010639b:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f010639c:	83 ec 08             	sub    $0x8,%esp
f010639f:	ff 36                	pushl  (%esi)
f01063a1:	68 cd 84 10 f0       	push   $0xf01084cd
f01063a6:	e8 2d d7 ff ff       	call   f0103ad8 <cprintf>
f01063ab:	83 c4 10             	add    $0x10,%esp
f01063ae:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f01063b1:	8d 45 e8             	lea    -0x18(%ebp),%eax
f01063b4:	39 c3                	cmp    %eax,%ebx
f01063b6:	74 40                	je     f01063f8 <spin_unlock+0xd8>
f01063b8:	89 de                	mov    %ebx,%esi
f01063ba:	8b 03                	mov    (%ebx),%eax
f01063bc:	85 c0                	test   %eax,%eax
f01063be:	74 38                	je     f01063f8 <spin_unlock+0xd8>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01063c0:	83 ec 08             	sub    $0x8,%esp
f01063c3:	57                   	push   %edi
f01063c4:	50                   	push   %eax
f01063c5:	e8 ce ea ff ff       	call   f0104e98 <debuginfo_eip>
f01063ca:	83 c4 10             	add    $0x10,%esp
f01063cd:	85 c0                	test   %eax,%eax
f01063cf:	78 cb                	js     f010639c <spin_unlock+0x7c>
					pcs[i] - info.eip_fn_addr);
f01063d1:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01063d3:	83 ec 04             	sub    $0x4,%esp
f01063d6:	89 c2                	mov    %eax,%edx
f01063d8:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01063db:	52                   	push   %edx
f01063dc:	ff 75 b0             	pushl  -0x50(%ebp)
f01063df:	ff 75 b4             	pushl  -0x4c(%ebp)
f01063e2:	ff 75 ac             	pushl  -0x54(%ebp)
f01063e5:	ff 75 a8             	pushl  -0x58(%ebp)
f01063e8:	50                   	push   %eax
f01063e9:	68 b6 84 10 f0       	push   $0xf01084b6
f01063ee:	e8 e5 d6 ff ff       	call   f0103ad8 <cprintf>
f01063f3:	83 c4 20             	add    $0x20,%esp
f01063f6:	eb b6                	jmp    f01063ae <spin_unlock+0x8e>
		panic("spin_unlock");
f01063f8:	83 ec 04             	sub    $0x4,%esp
f01063fb:	68 d5 84 10 f0       	push   $0xf01084d5
f0106400:	6a 67                	push   $0x67
f0106402:	68 a6 84 10 f0       	push   $0xf01084a6
f0106407:	e8 34 9c ff ff       	call   f0100040 <_panic>
f010640c:	66 90                	xchg   %ax,%ax
f010640e:	66 90                	xchg   %ax,%ax

f0106410 <__udivdi3>:
f0106410:	f3 0f 1e fb          	endbr32 
f0106414:	55                   	push   %ebp
f0106415:	57                   	push   %edi
f0106416:	56                   	push   %esi
f0106417:	53                   	push   %ebx
f0106418:	83 ec 1c             	sub    $0x1c,%esp
f010641b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010641f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106423:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106427:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f010642b:	85 d2                	test   %edx,%edx
f010642d:	75 19                	jne    f0106448 <__udivdi3+0x38>
f010642f:	39 f3                	cmp    %esi,%ebx
f0106431:	76 4d                	jbe    f0106480 <__udivdi3+0x70>
f0106433:	31 ff                	xor    %edi,%edi
f0106435:	89 e8                	mov    %ebp,%eax
f0106437:	89 f2                	mov    %esi,%edx
f0106439:	f7 f3                	div    %ebx
f010643b:	89 fa                	mov    %edi,%edx
f010643d:	83 c4 1c             	add    $0x1c,%esp
f0106440:	5b                   	pop    %ebx
f0106441:	5e                   	pop    %esi
f0106442:	5f                   	pop    %edi
f0106443:	5d                   	pop    %ebp
f0106444:	c3                   	ret    
f0106445:	8d 76 00             	lea    0x0(%esi),%esi
f0106448:	39 f2                	cmp    %esi,%edx
f010644a:	76 14                	jbe    f0106460 <__udivdi3+0x50>
f010644c:	31 ff                	xor    %edi,%edi
f010644e:	31 c0                	xor    %eax,%eax
f0106450:	89 fa                	mov    %edi,%edx
f0106452:	83 c4 1c             	add    $0x1c,%esp
f0106455:	5b                   	pop    %ebx
f0106456:	5e                   	pop    %esi
f0106457:	5f                   	pop    %edi
f0106458:	5d                   	pop    %ebp
f0106459:	c3                   	ret    
f010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106460:	0f bd fa             	bsr    %edx,%edi
f0106463:	83 f7 1f             	xor    $0x1f,%edi
f0106466:	75 48                	jne    f01064b0 <__udivdi3+0xa0>
f0106468:	39 f2                	cmp    %esi,%edx
f010646a:	72 06                	jb     f0106472 <__udivdi3+0x62>
f010646c:	31 c0                	xor    %eax,%eax
f010646e:	39 eb                	cmp    %ebp,%ebx
f0106470:	77 de                	ja     f0106450 <__udivdi3+0x40>
f0106472:	b8 01 00 00 00       	mov    $0x1,%eax
f0106477:	eb d7                	jmp    f0106450 <__udivdi3+0x40>
f0106479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106480:	89 d9                	mov    %ebx,%ecx
f0106482:	85 db                	test   %ebx,%ebx
f0106484:	75 0b                	jne    f0106491 <__udivdi3+0x81>
f0106486:	b8 01 00 00 00       	mov    $0x1,%eax
f010648b:	31 d2                	xor    %edx,%edx
f010648d:	f7 f3                	div    %ebx
f010648f:	89 c1                	mov    %eax,%ecx
f0106491:	31 d2                	xor    %edx,%edx
f0106493:	89 f0                	mov    %esi,%eax
f0106495:	f7 f1                	div    %ecx
f0106497:	89 c6                	mov    %eax,%esi
f0106499:	89 e8                	mov    %ebp,%eax
f010649b:	89 f7                	mov    %esi,%edi
f010649d:	f7 f1                	div    %ecx
f010649f:	89 fa                	mov    %edi,%edx
f01064a1:	83 c4 1c             	add    $0x1c,%esp
f01064a4:	5b                   	pop    %ebx
f01064a5:	5e                   	pop    %esi
f01064a6:	5f                   	pop    %edi
f01064a7:	5d                   	pop    %ebp
f01064a8:	c3                   	ret    
f01064a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01064b0:	89 f9                	mov    %edi,%ecx
f01064b2:	b8 20 00 00 00       	mov    $0x20,%eax
f01064b7:	29 f8                	sub    %edi,%eax
f01064b9:	d3 e2                	shl    %cl,%edx
f01064bb:	89 54 24 08          	mov    %edx,0x8(%esp)
f01064bf:	89 c1                	mov    %eax,%ecx
f01064c1:	89 da                	mov    %ebx,%edx
f01064c3:	d3 ea                	shr    %cl,%edx
f01064c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01064c9:	09 d1                	or     %edx,%ecx
f01064cb:	89 f2                	mov    %esi,%edx
f01064cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01064d1:	89 f9                	mov    %edi,%ecx
f01064d3:	d3 e3                	shl    %cl,%ebx
f01064d5:	89 c1                	mov    %eax,%ecx
f01064d7:	d3 ea                	shr    %cl,%edx
f01064d9:	89 f9                	mov    %edi,%ecx
f01064db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01064df:	89 eb                	mov    %ebp,%ebx
f01064e1:	d3 e6                	shl    %cl,%esi
f01064e3:	89 c1                	mov    %eax,%ecx
f01064e5:	d3 eb                	shr    %cl,%ebx
f01064e7:	09 de                	or     %ebx,%esi
f01064e9:	89 f0                	mov    %esi,%eax
f01064eb:	f7 74 24 08          	divl   0x8(%esp)
f01064ef:	89 d6                	mov    %edx,%esi
f01064f1:	89 c3                	mov    %eax,%ebx
f01064f3:	f7 64 24 0c          	mull   0xc(%esp)
f01064f7:	39 d6                	cmp    %edx,%esi
f01064f9:	72 15                	jb     f0106510 <__udivdi3+0x100>
f01064fb:	89 f9                	mov    %edi,%ecx
f01064fd:	d3 e5                	shl    %cl,%ebp
f01064ff:	39 c5                	cmp    %eax,%ebp
f0106501:	73 04                	jae    f0106507 <__udivdi3+0xf7>
f0106503:	39 d6                	cmp    %edx,%esi
f0106505:	74 09                	je     f0106510 <__udivdi3+0x100>
f0106507:	89 d8                	mov    %ebx,%eax
f0106509:	31 ff                	xor    %edi,%edi
f010650b:	e9 40 ff ff ff       	jmp    f0106450 <__udivdi3+0x40>
f0106510:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106513:	31 ff                	xor    %edi,%edi
f0106515:	e9 36 ff ff ff       	jmp    f0106450 <__udivdi3+0x40>
f010651a:	66 90                	xchg   %ax,%ax
f010651c:	66 90                	xchg   %ax,%ax
f010651e:	66 90                	xchg   %ax,%ax

f0106520 <__umoddi3>:
f0106520:	f3 0f 1e fb          	endbr32 
f0106524:	55                   	push   %ebp
f0106525:	57                   	push   %edi
f0106526:	56                   	push   %esi
f0106527:	53                   	push   %ebx
f0106528:	83 ec 1c             	sub    $0x1c,%esp
f010652b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010652f:	8b 74 24 30          	mov    0x30(%esp),%esi
f0106533:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106537:	8b 7c 24 38          	mov    0x38(%esp),%edi
f010653b:	85 c0                	test   %eax,%eax
f010653d:	75 19                	jne    f0106558 <__umoddi3+0x38>
f010653f:	39 df                	cmp    %ebx,%edi
f0106541:	76 5d                	jbe    f01065a0 <__umoddi3+0x80>
f0106543:	89 f0                	mov    %esi,%eax
f0106545:	89 da                	mov    %ebx,%edx
f0106547:	f7 f7                	div    %edi
f0106549:	89 d0                	mov    %edx,%eax
f010654b:	31 d2                	xor    %edx,%edx
f010654d:	83 c4 1c             	add    $0x1c,%esp
f0106550:	5b                   	pop    %ebx
f0106551:	5e                   	pop    %esi
f0106552:	5f                   	pop    %edi
f0106553:	5d                   	pop    %ebp
f0106554:	c3                   	ret    
f0106555:	8d 76 00             	lea    0x0(%esi),%esi
f0106558:	89 f2                	mov    %esi,%edx
f010655a:	39 d8                	cmp    %ebx,%eax
f010655c:	76 12                	jbe    f0106570 <__umoddi3+0x50>
f010655e:	89 f0                	mov    %esi,%eax
f0106560:	89 da                	mov    %ebx,%edx
f0106562:	83 c4 1c             	add    $0x1c,%esp
f0106565:	5b                   	pop    %ebx
f0106566:	5e                   	pop    %esi
f0106567:	5f                   	pop    %edi
f0106568:	5d                   	pop    %ebp
f0106569:	c3                   	ret    
f010656a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106570:	0f bd e8             	bsr    %eax,%ebp
f0106573:	83 f5 1f             	xor    $0x1f,%ebp
f0106576:	75 50                	jne    f01065c8 <__umoddi3+0xa8>
f0106578:	39 d8                	cmp    %ebx,%eax
f010657a:	0f 82 e0 00 00 00    	jb     f0106660 <__umoddi3+0x140>
f0106580:	89 d9                	mov    %ebx,%ecx
f0106582:	39 f7                	cmp    %esi,%edi
f0106584:	0f 86 d6 00 00 00    	jbe    f0106660 <__umoddi3+0x140>
f010658a:	89 d0                	mov    %edx,%eax
f010658c:	89 ca                	mov    %ecx,%edx
f010658e:	83 c4 1c             	add    $0x1c,%esp
f0106591:	5b                   	pop    %ebx
f0106592:	5e                   	pop    %esi
f0106593:	5f                   	pop    %edi
f0106594:	5d                   	pop    %ebp
f0106595:	c3                   	ret    
f0106596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010659d:	8d 76 00             	lea    0x0(%esi),%esi
f01065a0:	89 fd                	mov    %edi,%ebp
f01065a2:	85 ff                	test   %edi,%edi
f01065a4:	75 0b                	jne    f01065b1 <__umoddi3+0x91>
f01065a6:	b8 01 00 00 00       	mov    $0x1,%eax
f01065ab:	31 d2                	xor    %edx,%edx
f01065ad:	f7 f7                	div    %edi
f01065af:	89 c5                	mov    %eax,%ebp
f01065b1:	89 d8                	mov    %ebx,%eax
f01065b3:	31 d2                	xor    %edx,%edx
f01065b5:	f7 f5                	div    %ebp
f01065b7:	89 f0                	mov    %esi,%eax
f01065b9:	f7 f5                	div    %ebp
f01065bb:	89 d0                	mov    %edx,%eax
f01065bd:	31 d2                	xor    %edx,%edx
f01065bf:	eb 8c                	jmp    f010654d <__umoddi3+0x2d>
f01065c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01065c8:	89 e9                	mov    %ebp,%ecx
f01065ca:	ba 20 00 00 00       	mov    $0x20,%edx
f01065cf:	29 ea                	sub    %ebp,%edx
f01065d1:	d3 e0                	shl    %cl,%eax
f01065d3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01065d7:	89 d1                	mov    %edx,%ecx
f01065d9:	89 f8                	mov    %edi,%eax
f01065db:	d3 e8                	shr    %cl,%eax
f01065dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01065e1:	89 54 24 04          	mov    %edx,0x4(%esp)
f01065e5:	8b 54 24 04          	mov    0x4(%esp),%edx
f01065e9:	09 c1                	or     %eax,%ecx
f01065eb:	89 d8                	mov    %ebx,%eax
f01065ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01065f1:	89 e9                	mov    %ebp,%ecx
f01065f3:	d3 e7                	shl    %cl,%edi
f01065f5:	89 d1                	mov    %edx,%ecx
f01065f7:	d3 e8                	shr    %cl,%eax
f01065f9:	89 e9                	mov    %ebp,%ecx
f01065fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01065ff:	d3 e3                	shl    %cl,%ebx
f0106601:	89 c7                	mov    %eax,%edi
f0106603:	89 d1                	mov    %edx,%ecx
f0106605:	89 f0                	mov    %esi,%eax
f0106607:	d3 e8                	shr    %cl,%eax
f0106609:	89 e9                	mov    %ebp,%ecx
f010660b:	89 fa                	mov    %edi,%edx
f010660d:	d3 e6                	shl    %cl,%esi
f010660f:	09 d8                	or     %ebx,%eax
f0106611:	f7 74 24 08          	divl   0x8(%esp)
f0106615:	89 d1                	mov    %edx,%ecx
f0106617:	89 f3                	mov    %esi,%ebx
f0106619:	f7 64 24 0c          	mull   0xc(%esp)
f010661d:	89 c6                	mov    %eax,%esi
f010661f:	89 d7                	mov    %edx,%edi
f0106621:	39 d1                	cmp    %edx,%ecx
f0106623:	72 06                	jb     f010662b <__umoddi3+0x10b>
f0106625:	75 10                	jne    f0106637 <__umoddi3+0x117>
f0106627:	39 c3                	cmp    %eax,%ebx
f0106629:	73 0c                	jae    f0106637 <__umoddi3+0x117>
f010662b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010662f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f0106633:	89 d7                	mov    %edx,%edi
f0106635:	89 c6                	mov    %eax,%esi
f0106637:	89 ca                	mov    %ecx,%edx
f0106639:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010663e:	29 f3                	sub    %esi,%ebx
f0106640:	19 fa                	sbb    %edi,%edx
f0106642:	89 d0                	mov    %edx,%eax
f0106644:	d3 e0                	shl    %cl,%eax
f0106646:	89 e9                	mov    %ebp,%ecx
f0106648:	d3 eb                	shr    %cl,%ebx
f010664a:	d3 ea                	shr    %cl,%edx
f010664c:	09 d8                	or     %ebx,%eax
f010664e:	83 c4 1c             	add    $0x1c,%esp
f0106651:	5b                   	pop    %ebx
f0106652:	5e                   	pop    %esi
f0106653:	5f                   	pop    %edi
f0106654:	5d                   	pop    %ebp
f0106655:	c3                   	ret    
f0106656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010665d:	8d 76 00             	lea    0x0(%esi),%esi
f0106660:	29 fe                	sub    %edi,%esi
f0106662:	19 c3                	sbb    %eax,%ebx
f0106664:	89 f2                	mov    %esi,%edx
f0106666:	89 d9                	mov    %ebx,%ecx
f0106668:	e9 1d ff ff ff       	jmp    f010658a <__umoddi3+0x6a>
