library ieee;
use ieee.std_logic_1164.all;

entity SevenSegment is
	port(
		clock: in std_logic;
		num: in std_logic_vector(3 downto 0);
		segments: out std_logic_vector(6 downto 0)
	);
end SevenSegment;

architecture behavioral of SevenSegment is
begin
	display: process(clock)
	begin
		if clock'event and clock='1' then
			case num is
				when "0000" => segments <= "1000000";
				when "0001" => segments <= "1111001";
				when "0010" => segments <= "0100100";
				when "0011" => segments <= "0110000";
				when "0100" => segments <= "0011001";
				when "0101" => segments <= "0010010";
				when "0110" => segments <= "0000010";
				when "0111" => segments <= "1111000";
				when "1000" => segments <= "0000000";
				when "1001" => segments <= "0011000";
				
				when "1010" => segments <= "0001000";
				when "1011" => segments <= "0000011";
				when "1100" => segments <= "1000110";
				when "1101" => segments <= "0100001";
				when "1110" => segments <= "0000110";
				when "1111" => segments <= "0001110";
				
				when others => segments <= "1111111";
			end case;
		end if;
	end process;
end behavioral;

