--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
-- Based on Ben Jordon's code in this forum post:
-- http://forum.allaboutcircuits.com/showthread.php?t=23344
--
library ieee;
use ieee.std_logic_1164.all;

entity Rotary is
	port(
		clock: in std_logic;
		A: in std_logic;
		B: in std_logic;
		inc: out std_logic;
		dec: out std_logic
	);
end Rotary;

architecture behavioral of Rotary is
	signal prevA, prevB: std_logic;
	signal currA, currB: std_logic;
begin
	read_rotary: process(clock)
	begin
		if clock'event and clock = '1' then
			prevA <= currA;
			prevB <= currB;
			currA <= A;
			currB <= B;
			if prevA = '0' and currA = '1' then -- a rising
				if currB = '1' then
					inc <= '0';
					dec <= '1';
				elsif currB = '0' then
					inc <= '1';
					dec <= '0';
				end if;
			elsif prevA = '1' and currA = '0' then -- a falling
				if currB = '1' then
					inc <= '1';
					dec <= '0';
				elsif currB = '0' then
					inc <= '0';
					dec <= '1';
				end if;
			elsif prevB = '0' and currB = '1' then -- b rising
				if currA = '1' then
					inc <= '1';
					dec <= '0';
				elsif currA = '0' then
					inc <= '0';
					dec <= '1';
				end if;
			elsif prevB = '1' and currB = '0' then -- b falling
				if currA = '1' then
					inc <= '0';
					dec <= '1';
				elsif currA = '0' then
					inc <= '1';
					dec <= '0';
				end if;
			else
				inc <= '0';
				dec <= '0';
			end if;
		end if;
	end process;
end behavioral;

