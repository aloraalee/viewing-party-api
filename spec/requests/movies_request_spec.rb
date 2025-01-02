require "rails_helper"

RSpec.describe "Movies API", type: :request do
  describe "Get Top Rated Movie Endpoint" do
    context "request is valid" do
      it "returns 201 OK and provides expected fields" do
        json_response = File.read("spec/fixtures/top_rated_movies.json")
        stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=3c80aae3b943fcf5c5811e84b5258a1f").
          to_return(status: 200, body: json_response, headers: {})

        get api_v1_movies_path
        
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to be_an(Array)
        expect(json[:data].first[:type]).to eq("movie")
        expect(json[:data].first[:id]).to be_present
        expect(json[:data].first[:attributes][:title]).to eq("The Shawshank Redemption")
        expect(json[:data].first[:attributes][:vote_average]).to eq(8.708)
      end
    end
  end

  describe "Get Movie Search Endpoint" do
    context "request is valid" do
      it "returns 201 OK and provides expected fields" do
        VCR.use_cassette("movie_search") do

          get "/api/v1/search/movie", params: { query: "Lord of the Rings" }

          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json[:data]).to be_an(Array)
          expect(json[:data].first[:type]).to eq("movie")
          expect(json[:data].first[:id]).to be_present
          expect(json[:data].first[:attributes][:title]).to eq("The Lord of the Rings: The Fellowship of the Ring")
          expect(json[:data].first[:attributes][:vote_average]).to eq(8.415)   
        end     
      end
    end
  end

  describe "Get Movie Details Endpoint" do
    context "request is valid" do
      it "returns 201 OK and provides expected fields" do
        VCR.use_cassette("movie_details_cast_and_reviews") do

          movie_id = 278

          get "/api/v1/movies/#{movie_id}"

          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json[:data]).to be_a(Hash)
          expect(json[:data][:type]).to eq("movie")
          expect(json[:data][:id]).to be_present
          expect(json[:data][:attributes][:title]).to eq("The Shawshank Redemption")
          expect(json[:data][:attributes][:vote_average]).to eq(8.708)   
          expect(json[:data][:attributes][:runtime]).to eq("2 hours, 22 minutes")
          expect(json[:data][:attributes][:genres]).to eq(["Drama", "Crime"])
          expect(json[:data][:attributes][:summary]).to eq("Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.")
          expect(json[:data][:attributes][:cast]).to eq([{
            "character": "Andy Dufresne",
            "actor": "Tim Robbins"
          },
          {
            "character": "Ellis Boyd 'Red' Redding",
            "actor": "Morgan Freeman"
          }, 
          {
            "character": "Warden Norton",
            "actor": "Bob Gunton"
          }, 
          {
            "character": "Heywood",
            "actor": "William Sadler"
          }, 
          {
            "character": "Captain Byron T. Hadley",
            "actor": "Clancy Brown"
          }, 
          {
            "character": "Tommy",
            "actor": "Gil Bellows"
          }, 
          {
            "character": "Brooks Hatlen",
            "actor": "James Whitmore"
          }, 
          {
            "character": "Bogs Diamond",
            "actor": "Mark Rolston"
          }, 
          {
            "character": "1946 D.A.",
            "actor": "Jeffrey DeMunn"
          }, 
          {
            "character": "Skeet",
            "actor": "Larry Brandenburg"
          }])
          expect(json[:data][:attributes][:total_reviews]).to eq(17)
          expect(json[:data][:attributes][:reviews]).to eq([{
            "author": "elshaarawy",
            "review": "very good movie 9.5/10 محمد الشعراوى"
          },
          {
            "author": "John Chard",
            "review": "Some birds aren't meant to be caged.\r\n\r\nThe Shawshank Redemption is written and directed by Frank Darabont. It is an adaptation of the Stephen King novella Rita Hayworth and Shawshank Redemption. Starring Tim Robbins and Morgan Freeman, the film portrays the story of Andy Dufresne (Robbins), a banker who is sentenced to two life sentences at Shawshank State Prison for apparently murdering his wife and her lover. Andy finds it tough going but finds solace in the friendship he forms with fellow inmate Ellis \"Red\" Redding (Freeman). While things start to pick up when the warden finds Andy a prison job more befitting his talents as a banker. However, the arrival of another inmate is going to vastly change things for all of them.\r\n\r\nThere was no fanfare or bunting put out for the release of the film back in 94, with a title that didn't give much inkling to anyone about what it was about, and with Columbia Pictures unsure how to market it, Shawshank Redemption barely registered at the box office. However, come Academy Award time the film received several nominations, and although it won none, it stirred up interest in the film for its home entertainment release. The rest, as they say, is history. For the film finally found an audience that saw the film propelled to almost mythical proportions as an endearing modern day classic. Something that has delighted its fans, whilst simultaneously baffling its detractors. One thing is for sure, though, is that which ever side of the Shawshank fence you sit on, the film continues to gather new fans and simply will never go away or loose that mythical status.\r\n\r\nIt's possibly the simplicity of it all that sends some haters of the film into cinematic spasms. The implausible plot and an apparent sentimental edge that makes a nonsense of prison life, are but two chief complaints from those that dislike the film with a passion. Yet when characters are this richly drawn, and so movingly performed, it strikes me as churlish to do down a human drama that's dealing in hope, friendship and faith. The sentimental aspect is indeed there, but that acts as a counterpoint to the suffering, degradation and shattering of the soul involving our protagonist. Cosy prison life you say? No chance. The need for human connection is never more needed than during incarceration, surely? And given the quite terrific performances of Robbins (never better) & Freeman (sublimely making it easy), it's the easiest thing in the world to warm to Andy and Red.\r\n\r\nThose in support aren't faring too bad either. Bob Gunton is coiled spring smarm as Warden Norton, James Whitmore is heart achingly great as the \"Birdman Of Shawshank,\" Clancy Brown is menacing as antagonist Capt. Byron Hadley, William Sadler amusing as Heywood & Mark Rolston is impressively vile as Bogs Diamond. Then there's Roger Deakins' lush cinematography as the camera gracefully glides in and out of the prison offering almost ethereal hope to our characters (yes, they are ours). The music pings in conjunction with the emotional flow of the movie too. Thomas Newman's score is mostly piano based, dovetailing neatly with Andy's state of mind, while the excellently selected soundtrack ranges from the likes of Hank Williams to the gorgeous Le Nozze di Figaro by Mozart.\r\n\r\nIf you love Shawshank then it's a love that lasts a lifetime. Every viewing brings the same array of emotions - anger - revilement - happiness - sadness - inspiration and a warmth that can reduce the most hardened into misty eyed wonderment. Above all else, though, Shawshank offers hope - not just for characters in a movie - but for a better life and a better world for all of us. 10/10"
          },
          {
            "author": "tmdb73913433",
            "review": "Make way for the best film ever made people. **Make way.**"
          },
          {
            "author": "thommo_nz",
            "review": "There is a reason why this movie is at the top of any popular list your will find.\r\nVery strong performances from lead actors and a story line from the literary brilliance of Stephen King (and no, its not a horror).\r\nSufficient drama and depth to keep you interested and occupied without stupefying your brain. It is the movie that has something for everyone."
          },
          {
            "author": "Andrew Gentry",
            "review": "It's still puzzling to me why this movie exactly continues to appear in every single best-movies-of-all-time chart. There's a great story, perfect cast, and acting. It really moves me in times when I'm finding myself figuring out things with my annual tax routine reading <a href=\"https://www.buzzfeed.com/davidsmithjd/what-is-form-w-2-and-how-does-it-work-3n31d\">this article</a>, and accidentally catching myself wondering what my life should be if circumstances had changed so drastically. This movie worth a rewatch by all means, but yet, there's no unique vibe or something - there are thousands of other ones as good as this one."
          }])
        end     
      end
    end
  end
end
