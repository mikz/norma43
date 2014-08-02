require "iconv"
require 'date'

module Norma43
  
  DATE_FORMAT = '%y%m%d'
  
  def self.read(path, encoding="iso-8859-1")
    data = Hash.new
    data[:movements] = Array.new
    File.open(path, "r:#{encoding}:UTF-8") do |file|
      file.readlines.each do |line|
        code = line[0..1]
        case code
        when '11'
          data[:info] = parse_header(line)
        when '22'
          data[:movements] << parse_movement_main(line)
        when '23'
          #TODO support multiple '23' lines (there may be up to 5)
          data[:movements].last.merge!(parse_movement_optional(line))
        when '33'
          data[:info].merge!(parse_end(line))
        end

        #TODO check amount values against those on record 33
        #TODO parse record 88, end of file
      end
    end 

    data
  end
  
  protected

    def self.parse_header(line)
      account = {:bank => line[2..5].to_s, :office => line[6..9].to_s, 
                 :number => line[10..19].to_s, :control => "??"}
      {
        :account => account,
        :begin_date => Date.strptime(line[20..25], DATE_FORMAT), #Date.from_nor43(line[20..25])
        :end_date => Date.strptime(line[26..31], DATE_FORMAT),
        :initial_balance => parse_amount(line[33..46], line[32].chr),
        :account_owner => line[51..76].strip,
        :currency => line[47..49]          
      }
    end

    def self.parse_movement_main(line)
      {
        :operation_date => Date.strptime(line[10..15], DATE_FORMAT),
        :value_date => Date.strptime(line[16..21], DATE_FORMAT),
        :operation => line[42..51],
        :reference_1 => line[52..63],
        :reference_2 => line[64..79].strip,
        :amount => parse_amount(line[28..41], line[27].chr),
        :office => line[6..9]
      }
    end

    def self.parse_movement_optional(line)
      {:concept => line[4, 79].strip}
    end

    def self.parse_end(line)
      {:final_balance => parse_amount(line[59..72], line[28].chr)}
    end
    
    def self.parse_amount(value, sign)
      value.to_f / 100 * (sign.to_i == 1 ? -1 : 1)
    end
  
end
