require 'bio'
#--------------------------------------------------------------------
#---塩基配列❍❍❍❍がHomo sapienxe.txtの何番目に出てくるのか調べる---
#--------------------------------------------------------------------

#ファイルの読み込み
arr = File.open("/home/asato/sotsuron/python_DFT/date/Homo sapiens.txt")

seq = arr.read
arrseq = Bio::Sequence::NA.new(seq)

puts "--*--"
puts File.basename("/home/asato/sotsuron/python_DFT/date/Homo sapiens.txt", ".*")
puts "--*--"

strin_10 = []
File.open("/home/asato/sotsuron/Ruby_2/Homo_10_window_search.txt", mode = "rt"){|f|
  f.each_line do |fn|
    strin_10 << fn.chomp
  end
}

strin_10.each do|tenword|
count = 0
hairetsu=[]
#(10)塩基ごとに1つずつずらしてwindow_searchをかける
arrseq.window_search(10,1) do |codon|                 #長さ10のwindow_searchで
    if codon.match(/#{tenword}/) then               
    hairetsu.push(count)                            #塩基配列の位置を取得
    end
    count += 1
end
puts ""
puts tenword
puts ""
#--------------------------------------------------------------
#---取得した位置から、そのタンパク質が翻訳領域であるか調べる---
#--------------------------------------------------------------

File.foreach('/home/asato/sotsuron/Ruby_2/NC_012920.1.gbk'){|line|
    if line.match(/CDS/) then
        number = line.delete("CDS complement()")
        cds_num = number.strip.split('..').map(&:to_i)
        array_true=[]
        array_false=[]
        hairetsu.each do |codon|
            if (cds_num[0]..cds_num[1]).include?(codon) 
                array_true << codon
            else
                array_false << codon
            end
    end
    if array_true.any? then
        puts "#{cds_num[0]} .. #{cds_num[1]}:\n\ttrue=> #{array_true.to_s}\n\tfalse=> #{array_false.to_s}"
        puts "-------------------------------------------------------------------------------------------"
    end
    end
}

end

