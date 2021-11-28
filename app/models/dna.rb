class Dna
    def initialize(sequence)
        sequence = sequence.gsub(/\r/, '')
        sequence = sequence.gsub(/\n/, '')
        @seq = sequence
        @seq_length = @seq.length
        puts @seq
    end
    
    def calc_gc_temp(seq)
        results = []
        a_count = seq.count("A");
        a_count += seq.count("a");
        g_count = seq.count("G");
        g_count += seq.count("g");
        c_count = seq.count("C");
        c_count += seq.count("c");
        t_count = seq.count("T");
        t_count += seq.count("t");
        temp = calc_temp(a_count, t_count, c_count, g_count)
        results[0] = temp
        gc = g_count + c_count
        gc_ratio = gc.to_f/seq.length.to_f * 100
        results[1] = gc_ratio
        return results
    end

    def find_primers(primer_min, primer_max, gc_min, gc_max, temp_min, temp_max)
        found = 0
        results_array = []
        dif = primer_max-primer_min
        i = 0
        while(i < @seq_length)
            k = 0
            while(k < dif)
				if(i+primer_min+k >= @seq_length) 
					break
                end
                seq_check = @seq[i, primer_min + k];
				returns = calc_gc_temp(seq_check)
				temp = returns[0]
                gc_ratio = returns[1]
				if (gc_ratio >= gc_min && gc_ratio <= gc_max) 
                    if(temp >= temp_min && temp <= temp_max) 
                        res = []
                        found += 1
                        res[0] = found
                        res[1] = seq_check
                        res[2] = i
                        res[3] = seq_check.length
                        res[4] = gc_ratio
                        res[5] = temp
                        results_array.append(res)
                        i = i + primer_max + k + 400;
                        k = 0;
                        puts seq_check
                        puts "FOUND PRIMER"
                    end
                end

                k += 1
            end
            
            i += 1
        end
        @forward_primers = results_array
        return results_array
    end

    def find_reverse_primers(primers, min_bp, max_bp, primer_min, primer_max, gc_min, gc_max, temp_min, temp_max)
        found = 0
        puts primers
        results_array =[]
        dif = primer_max-primer_min
        primers.each do |p|
          primer_found = false
          max = @seq_length
          start = p[2]
          if((start+max_bp)<max)
            max = start+max_bp
          end
          i = max
          while(i > start)
            if(primer_found) 
                break
            end
            k = 0
            while(k < dif)
				if(primer_found) 
					break
                end
                seq_check = @seq[i-primer_min-k, primer_min + k];
				returns = calc_gc_temp(seq_check)
				temp = returns[0]
                gc_ratio = returns[1]
				if (gc_ratio >= gc_min && gc_ratio <= gc_max) 
                    if(temp >= temp_min && temp <= temp_max) 
                        res = []
                        found += 1
                        res[0] = found
                        res[1] = seq_check
                        res[2] = i
                        res[3] = seq_check.length
                        res[4] = gc_ratio
                        res[5] = temp
                        results_array.append(res)
                        puts seq_check
                        puts "FOUND PRIMER"
                        primer_found = true
                    end
                end

                k += 1
            end
            
            i -= 1
        end
       end
     return results_array
    end

    def calc_temp(a_count,t_count,c_count,g_count) 
		temp = (64.9 + 41*(g_count+c_count-16.4)/(a_count+t_count+g_count+c_count));
		return temp;
    end
    
    def reverse_compliment(seq) 
        rev_seq = ""
        i = seq.length - 1
        while(i > 0)
            if(seq[i] == "A")
                rev_seq << "T"
            elsif(seq[i] == "a")
                rev_seq << "t"
            elsif(seq[i] == "T")
                rev_seq << "A"
            elsif(seq[i] == "t")
                rev_seq << "a"
            elsif(seq[i] == "C")
                rev_seq << "G"
            elsif(seq[i] == "c")
                rev_seq << "g"
            elsif(seq[i] == "G")
                rev_seq << "C"
            elsif(seq[i] == "g")
                rev_seq << "c"
            end
            i -= 1
        end
        return rev_seq
	end
end