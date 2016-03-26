require 'selenium-webdriver'
require 'test/unit'
require 'csv'

class WalkSomewhere < Test::Unit::TestCase

	def setup
		@driver = Selenium::WebDriver.for:firefox
		@url = 'https://www.google.com/maps'
		
	##reading address from a file, need to figure out how to append a comma at the end of each step
		aFile = File.new("fromAddress.csv", "r")
		if aFile
		   @AddressFrom = aFile.sysread(180)
		   puts 'Starting Address: ' + @AddressFrom
		else
		   puts "Unable to open file!"
		end
		
	end
	
	def teardown 
	##Takes a screenshot and save it at the current directory. 
	##Export walking directions to a file
	##close firefox
		@driver.save_screenshot("./directions.png")
		CSV.open("directions_data.csv", "w") do |csvOut|
		csvOut << [@stepByStepDirections]

		end
			
		@driver.quit
	end
	
	def test_walk 
	## Retrieves detail walking directions from  '400 SW 6th Ave #902, Portland, OR 97204' to an Address stored in fromAddress.csv
		@driver.manage.timeouts.implicit_wait = 30
		@driver.get(@url)
		@driver.find_element(:id, 'searchboxinput').send_keys('400 SW 6th Ave #902, Portland, OR 97204')
		@driver.find_element(:class, 'searchbox-searchbutton').click
		@driver.find_element(:css, 'button.widget-pane-section-header-directions.noprint').click
		@driver.find_element(:id, 'directions-searchbox-0').send_keys("'" + @AddressFrom +"'") #1300 SW 5th Ave, Portland, OR
		@driver.find_element(:css, 'button.widget-directions-reverse').click
		@driver.find_element(:xpath, "//div[@id='omnibox']/div/div[3]/div/div/div/div/div/div[4]/button").click
		@driver.find_element(:css, 'button.widget-pane-section-directions-trip-details-link.noprint.blue-button-text').click
		sleep(2)
		@stepByStepDirections = @driver.find_element(:xpath, "//*[@id='pane']/div[2]/div[1]/div/div[5]").text ##Store step by step instruction to a variable. 

	
	end

end