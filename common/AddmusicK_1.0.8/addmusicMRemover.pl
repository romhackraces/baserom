use strict;
use Getopt::Long;
use Tie::IxHash;

# The purpose of this is only to remove AddmusicM data.
# I do not understand much about perl, so this is a bit sloppy.
# Thanks to the original creator(s).

#mmlファイルがあるディレクトリ
our $dir = "./music/";
#brrファイルがあるディレクトリ
our $dirb = "./brr/";
#OWでも変化しない空いてるRAMアドレス。6桁で指定
our $free_ram = 0x7EC100; 


################################
#以下は書き換えないでください
################################

#	#コメント用
#	&関数呼び出し
#	sub 関数定義
#	our 取得。<STDIN>なら入力をもちかける
#	$変数
#	@配列
#	%組み合わせ指定配列?  ('',,     '',,)
#	GetOptions() 引数処理
#	行内で条件節を後付け可能(ifやunless)
#	$# 配列長－１


#	our	全体に対しての変数名宣言
#	my	サブルーチン内での変数名宣言。さらにその内部にサブルーチンがあった場合、その先まで効力は及ばない 
#	local	上とは逆。先まで効力が及ぶ




our $check_point = 0x80200;
our $aram_l = 0x5400;
our $seq_ofs = 0xFE000;
our $pcmset_add = 0xFCF00;
our $pcmdata = 0xFD000;
our $pcm_set = 0x00;
our ($startFILE, $startARAM, $intro, $msc, $list, $rom, $brrlist);
our (@sum_data_a, @sum_data, @data, @ptrL, @ptrI, @ptrA, @q, @update_q, @directm, @melody, @loop, @set_data, %msc, %list, %brrlist);


#音程
our %tone = ('a',9, 'b', 11, 'c', 0, 'd', 2, 'e', 4, 'f', 5, 'g', 7); 
#楽器毎の音程のズレ
our @transmap = (0, 0, 5, 0, 0, 0, 0, 0, 0, -5, 6, 0, -5, 0, 0, 8, 0, 0, 0); 


#引数処理
#GetOptions('rom=s' => \$rom);
$rom = $ARGV[0];

#input rom name
unless($rom) {
	print "\nDo not run this program by itself.  AddmusicK will use it as necessary.\n\nIncidentally, if you don't need to convert any AMM ROMs, feel free to delete\nthis file, as it only has that one purpose.\n\nPress ENTER to continue.";
	our $endinput = <STDIN>;
	die "";
}


#rom check
chomp $rom;
$rom = $rom.'.smc' unless($rom =~ /\.smc$/i);
unless(-e $rom) {
	print "ROM not found.";				# ROMが存在しません
	my $tmp = <STDIN>;
	exit;
}
our $size = -s $rom;
if($size < 1000000 || $size > 4200000) {
	print "The ROM size must be between 1 and 4 MB.";	# ROMサイズは1M～4Mにして下さい
	my $tmp = <STDIN>;
	exit;
}

open(IN,"+<$rom") or die "file open error:$!";
binmode(IN);					#ロムをバイナリデータとして読み込む



&InsertSEQ(*IN);
print "\n";
&InsertPCM(*IN);
&Msc() if($msc);
print "\nSuccess!\n\nPress ENTER to continue.";						# 完了
close(IN);
our $endinput = <STDIN>;


sub InsertSEQ {
	local (*FILE) = @_;
	$startARAM = $aram_l;
	my $limit_size = 0x2BFF;											########

	my $snes_addr = $seq_ofs;

	&DeleteMusic($snes_addr, *FILE);
}




#insert PCM
sub InsertPCM {
	local (*FILE) = @_;								

	my $addrm_pc = 0x7CE00;				#PCMOFSの位置
	my $snes_addr = &Pc2snes($addrm_pc);
	&DeletePCM($snes_addr, *FILE);
}





sub DeletePCM {
	my ($snes_addr) = @_;
	local *FILE = $_[1];
	my $zero = pack("H*","000000");
	my $pc_addr = &Snes2pc($snes_addr);
	print "Deleting sample data...\n\n";			# 追加音色を削除してます…
	for my $i (0..0xFE) {
		seek FILE, $pc_addr+($i*3), 0;					
		read FILE, my $buf, 3;
		my $snes_addr = hex(unpack("H*", $buf));
		next unless($snes_addr);
		&DeleteRatsData(&Snes2pc($snes_addr), *FILE);
		seek FILE, $pc_addr+($i*3), 0;
		print FILE $zero;
	}
}



sub DeleteMusic {
	my ($snes_addr) = @_;							#SEQOFSのSNESアドレス
	local *FILE = $_[1];
	my $zero = pack("H*","000000");
	my $pc_addr = &Snes2pc($snes_addr);
	print "Deleting music data...\n\n";					# シーケンスデータを削除しています…
	for my $i (0..0xFF) {
		seek FILE, $pc_addr+$i*3, 0;					#SEQOFS+3iのアドレスを3バイト読む
		read FILE, my $buf, 3;
		my $snes_addr = hex(unpack("H*", $buf));
		next unless($snes_addr);					
		&DeleteRatsData(&Snes2pc($snes_addr), *FILE);			#読んだアドレスの直前に存在するRATSの保護範囲を削除する
		seek FILE, $pc_addr+$i*3, 0;					#000000とする
		print FILE $zero;
	}
}


sub DeleteRatsData {
	my ($pc_addr) = @_;
	my ($buf,$num,$pari);
	my $zero = pack("H*","00");
	local *FILE = $_[1];
	$pc_addr -= 8;
	seek FILE, $pc_addr, 0;
	read FILE, $buf, 4;
	my $rats_data = unpack "H*", $buf;
	return 0 if($rats_data ne "53544152");#RATSタグでない
	read FILE, $num, 2;
	read FILE, $pari, 2;
	#little endian
	$num = unpack("v",$num);
	$pari = unpack("v",$pari);
	return 0 unless($num + $pari == 0xFFFF);#RATSタグでない
	seek FILE, $pc_addr, 0;
	for (1..$num+9) {
		print FILE $zero;
	}
}





#SnesAddress to PcAddres
sub Snes2pc {
	my ($addr) = @_;
	return ((($addr & 0x7FFFFF)/2 & 0xFF8000) + ($addr & 0x7FFF) + 0x200);
}

#PcAddress to SnesAddress
sub Pc2snes {
	my ($addr) = @_;
	my $pc_addr = ((($addr-0x200)*2 & 0xFF0000) + (($addr-0x200) & 0x7FFF) + 0x8000);
	$pc_addr += 0x800000 if($addr >= 0x380200);
	return $pc_addr;
}





sub ReadSnesAddress {
	my ($pc_addr) = @_;
	local *FILE = $_[1];
	seek FILE, $pc_addr, 0;
	read FILE, my $buf, 1;
	my $snes_addr = unpack("C",$buf);
	read FILE, $buf, 1;
	$snes_addr += unpack("C",$buf)*0x100;
	read FILE, $buf, 1;
	$snes_addr += unpack("C",$buf)*0x10000;
	return $snes_addr;
}


#create msc
sub Msc {
	my $msc_file = $rom;
	$msc_file =~ s/\.smc$/.msc/i;
	open (MSC, ">$msc_file");
	for (0x01..0xfe) {
		my $i = sprintf("%x",$_);
		next unless($msc{$i});
		my $title = $msc{$i};
		$title =~ s/\.txt$//i;
		print MSC "$i\t0\t$title\n";
		print MSC "$i\t1\t$title\n";
	}
	close(MSC);
}




