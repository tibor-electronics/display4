--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
-- Based on code from:
-- http://www.labbookpages.co.uk/electronics/debounce.html
--
library ieee;
use ieee.std_logic_1164.all;

entity Debouncer is
	port(
		clock: in std_logic;
		reset: in std_logic;
		d_in: in std_logic;
		d_out: out std_logic
	);
end Debouncer;

architecture behavioral of Debouncer is
	signal sample : std_logic;
	signal sync : std_logic_vector(1 downto 0);
	constant PULSE_COUNT_MAX : integer := 20;
	signal pulse_counter : integer range 0 to PULSE_COUNT_MAX;
begin
	sample_clock: process(clock)
		constant SAMPLE_TICK_MAX : integer := (32000000 / 2000) - 1; --500 us
		variable tick_counter : integer range 0 to SAMPLE_TICK_MAX;
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				sample <= '0';
				tick_counter := 0;
			elsif tick_counter = SAMPLE_TICK_MAX then
				sample <= '1';
				tick_counter := 0;
			else
				sample <= '0';
				tick_counter := tick_counter + 1;
			end if;
		end if;
	end process;
	
	debounce: process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				sync <= (others => '0');
				pulse_counter <= 0;
				d_out <= '0';
			else
				sync <= sync(0) & d_in;
				
				if sync(1) = '0' then
					pulse_counter <= 0;
					d_out <= '0';
				elsif sample = '1' then
					if pulse_counter = PULSE_COUNT_MAX then
						d_out <= '1';
					else
						pulse_counter <= pulse_counter + 1;
					end if;
				end if;
			end if;
		end if;
	end process;

end behavioral;

