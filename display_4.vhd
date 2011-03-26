--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Display4 is
	generic(
		CLOCK_FREQUENCY: positive := 32_000_000;
		DIGIT_COUNT: positive := 4
	);
	port(
		clock: in std_logic;
		data_write_enable: in std_logic;
		data: in std_logic_vector(DIGIT_COUNT * 4 - 1 downto 0);
		dps: in std_logic_vector(DIGIT_COUNT - 1 downto 0);
		segments: out std_logic_vector(6 downto 0);
		dp: out std_logic;
		sel: out std_logic_vector(DIGIT_COUNT - 1 downto 0)
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
	
	component Timer is
		generic(
			CLOCK_FREQUENCY: positive;
			TIMER_FREQUENCY: positive
		);
		port(
			clock: in std_logic;
			reset: in std_logic;
			tick: out std_logic
		);
	end component;
	
	signal dataRegister: std_logic_vector(DIGIT_COUNT * 4 - 1 downto 0) := (others => '0');
	signal dpRegister: std_logic_vector(DIGIT_COUNT - 1 downto 0) := (others => '0');
	signal currentNumber: std_logic_vector(3 downto 0) := "0000";
	signal advance_tick: std_logic := '0';
	signal digit_index: integer range 0 to DIGIT_COUNT - 1;
begin
	ss: SevenSegment
		port map(
			clock => clock,
			num => currentNumber,
			segments => segments
		);
	
	advance_timer: Timer
		generic map(
			CLOCK_FREQUENCY => CLOCK_FREQUENCY,
			TIMER_FREQUENCY => 1000 * (DIGIT_COUNT + 1)
		)
		port map(
			clock => clock,
			reset => '0',
			tick => advance_tick
		);
	
	set_registers: process(clock, data_write_enable)
	begin
		if clock'event and clock = '1' then
			if data_write_enable = '1' then
				dataRegister <= data;
				dpRegister <= dps;
			end if;
		end if;
	end process;
	
	update_digit_index: process(clock)
	begin
		if clock'event and clock = '1' then
			if advance_tick = '1' then
				digit_index <= digit_index + 1;
			end if;
		end if;
	end process;
	
	display: process(clock, digit_index)
		variable top: integer;
	begin
		if clock'event and clock = '1' then
			-- digits are numbered left-to-right, but we need them right-to-left
			-- calculate segment offsets based on (corrected) digit index
			top := 4 * (3 - digit_index) + 3;
			
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
			dp <= not dpRegister(digit_index);
		end if;
	end process;

end behavioral;

