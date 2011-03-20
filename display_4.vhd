library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Display4 is
	port(
		clock: in std_logic;
		DWE: in std_logic;
		data: in std_logic_vector(15 downto 0);
		dps: in std_logic_vector(3 downto 0);
		segments: out std_logic_vector(6 downto 0);
		dp: out std_logic;
		sel: out std_logic_vector(3 downto 0)
	);
end Display4;

architecture behavioral of Display4 is
	component SevenSegment is
		port(
			clock: in std_logic;
			num: in std_logic_vector(3 downto 0);
			segments: out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal dataRegister: std_logic_vector(15 downto 0) := (others => '0');
	signal dpRegister: std_logic_vector(3 downto 0) := (others => '0');
	signal currentNumber: std_logic_vector(3 downto 0) := "0000";
	signal counter: std_logic_vector(18 downto 0) := (others => '0');
begin
	ss: SevenSegment port map(
		clock => clock,
		num => currentNumber,
		segments => segments
	);
	
	set_register: process(clock, DWE)
	begin
		if clock'event and clock = '1' then
			if DWE = '1' then
				dataRegister <= data;
				dpRegister <= dps;
			end if;
		end if;
	end process;
	
	display: process(clock)
		variable digit_index, slice_index : integer;
		variable top: integer;
	begin
		if clock'event and clock = '1' then
			-- digits are numbered left-to-right, but we need them right-to-left
			digit_index := conv_integer(counter(18 downto 17));
			slice_index := 3 - digit_index;
			
			-- calculate segment offsets based on (corrected) digit index
			top := 4 * slice_index + 3;
			
			-- grab slice for the current digit
			currentNumber <= dataRegister(top downto top - 3);
			
			-- activate digit
			case digit_index is
				when 0 => sel <= "0001";
				when 1 => sel <= "0010";
				when 2 => sel <= "0100";
				when 3 => sel <= "1000";
				when others => sel <= "0000";
			end case;
			
			-- activate decimal point
			if dpRegister(digit_index) = '1' then
				dp <= '0';
			else
				dp <= '1';
			end if;
			
			counter <= counter + 1;
		end if;
	end process;

end behavioral;

