require 'ostruct'

class DictionaryController < ApplicationController
    def index
    end

    def search
        terms = find_definition(params[:term])           
        if terms['status'] != 'OK'
            # Respose API failed ['response']
            flash[:alert] = terms['response']
            return render action: :index                  
        else
            # Response definition ['response']['word']
            word = terms['response']['word']
            definition = terms['response']['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]            
            @word = word
            @defini = definition
        end 
        
    end

    private 
    def error_code(code)
        message = ''
        case code
        when 404
            message = 'The word does not exists, Error Code: ' + code.to_s     
        when 403
            message = 'The credentials is Bad. Error code: ' + code.to_s
        when 500, 502, 503, 504
            message = 'Server error:' + code.to_s + ' try later again, Please'
        else
            message = 'Service Error: ' + code.to_s 
        end
        data = {:status => 'error', :response => message}
        return response_obj = OpenStruct.new(data) 
    end 
    # API consumer Oxford request and response.
    def find_definition(word)
        request_api(
            "https://od-api.oxforddictionaries.com/api/v2/entries/en-us/#{word.downcase}"
        )
    end
    # Credential to retrieve the data
    private
    def request_api(url)
        response = Excon.get(
            url,
            headers: {
            'app_id' => '739a4e20',
            'app_key' => '0cccaf02f8d1d56e17bc7e64aaf2e4a8'
            }
        )
        #   return nil if response.status != 200
        case response.status      
        when 400, 403, 500, 5002, 503, 504, 404
            error_code(response.status)
        else
            data = {:status => 'OK', :response => JSON.parse(response.body)}
            return response_obj = OpenStruct.new(data)   
        end               
      
    end
   
end