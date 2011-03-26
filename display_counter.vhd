--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DisplayCounter is
	port(
		clock: in std_logic;
		A, B, PB: in std_logic;
		segments: out std_logic_vector(6 downto 0);
		dp: out std_logic;
		sel: out std_logic_vector(3 downto 0)
	);
end DisplayCounter;

architecture Behavioral of DisplayCounter is
	component Rotary is
		port(
			clock: in std_logic;
			A: in std_logic;
			B: in std_logic;
			inc: out std_logic;
			dec: out std_logic
		);
	end component;
	
	component Display4 is
		generic(
			DIGIT_COUNT: positive
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
	end component;
	
	component Debouncer is
		port(
			clock: in std_logic;
			reset: in std_logic;
			d_in: in std_logic;
			d_out: out std_logic
		);
	end component;
	
	subtype digitType is std_logic_vector(3 downto 0);
	type digitTypes is array(0 to 3) of digitType;
	signal digits: digitTypes;
	signal display_data: std_logic_vector(15 downto 0);
	
	signal up, down: std_logic;
	signal enable_write: std_logic := '1';
	signal active_digit: std_logic_vector(3 downto 0) := (others => '0');
	
	signal last_debounced: std_logic := '0';
	signal current_debounced: std_logic := '0';
	signal PB_debounced: std_logic := '0';
begin
	-- create rotary decoder
	r: Rotary
		port map(
			clock => clock,
			A => A,
			B => B,
			inc => up,
			dec => down
		);
	
	-- create 4-digit display
	d4: Display4
		generic map(
			DIGIT_COUNT => 4
		)
		port map(
			clock => clock,
			data_write_enable => enable_write,
			data => display_data,
			dps => active_digit,
			segments => segments,
			dp => dp,
			sel => sel
		);
	
	-- create button debouncer
	db: Debouncer
		port map(
			clock => clock,
			reset => PB,
			d_in => not PB,
			d_out => PB_debounced
		);
	
	update_display: process(clock, digits)
	begin
		if clock'event and clock = '1' then
			display_data <= digits(0) & digits(1) & digits(2) & digits(3);
		end if;
	end process;
	
	-- update count based on rotary output
	update_counter: process(clock, up, down, PB, active_digit)
		variable digit_index: integer range 0 to 3 := 0;
	begin
		if clock'event and clock = '1' then
			last_debounced <= current_debounced;
			current_debounced <= PB_debounced;
			if down = '1' and active_digit /= "0000" then
				digits(digit_index) <= digits(digit_index) - 1;
				enable_write <= '1';
			elsif up = '1' and active_digit /= "0000" then
				digits(digit_index) <= digits(digit_index) + 1;
				enable_write <= '1';
			elsif last_debounced = '0' and current_debounced = '1' then
				case active_digit is
					when "0000" => active_digit <= "0001"; digit_index := 0;
					when "0001" => active_digit <= "0010"; digit_index := 1;
					when "0010" => active_digit <= "0100"; digit_index := 2;
					when "0100" => active_digit <= "1000"; digit_index := 3;
					when "1000" => active_digit <= "0000"; digit_index := 0;
					when others => active_digit <= "0000"; digit_index := 0;
				end case;
				enable_write <= '1';
			else
				enable_write <= '0';
			end if;
		end if;
	end process;

end Behavioral;

