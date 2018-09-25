package weather;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMethod;

@RestController
public class WeatherController {

    @RequestMapping("/")
    public String index() {
        return "Greetings from Weather  Service!";
    }

	@RequestMapping(value="/weather/zip/{zipcode}", method = RequestMethod.GET)
	public String getCityForZip(@PathVariable("zipcode") String zipcode) {   
	   return "Response from Weather Service : Zip Code Submitted :" + zipcode;
	}

}
