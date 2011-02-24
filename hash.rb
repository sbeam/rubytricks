require 'test/unit'

class HashTest < Test::Unit::TestCase

    def test_map_creates_array
       hash = {:date=>Time.now, :int=>123, :str=>"somestring"}  
       arr = hash.map{ |k,v| v.class.name }
       assert_equal arr, ["Time", "Fixnum", "String"]
    end

    def test_map_creates_hash
       hash = {:date=>Time.now, :int=>123, :str=>"somestring"}  
       hash1 = Hash[*hash.map{ |k,v| [k, v.class.name] }.flatten]
       assert_equal hash1, {:date=>"Time", :int=>"Fixnum", :str=>"String"}
    end

    def test_inject
        h = {:a=>3, :b=>5, :c=>7}
        h1 = h.inject(h) {|h, (k, v)| h[k] = v**2; h }
        assert_equal h1, {:a => 9, :b => 25, :c => 49}
    end

    def test_hash_from_flattened_arr
        h = Hash[*[[:first_name, 'Hans'], [:last_name, 'Blix']].flatten] 
        assert_equal h, {:first_name=>"Hans", :last_name=>"Blix"}
    end

    def test_grouped_result
        results = [{:status => 'OK', :id => 100}, {:status=>'BAD', :id=>104}, {:status => 'OK', :id => 101}, {:status => 'BAD', :id=>103}]
        grouped_results = results.inject({}) do |grouped, test_result|
            (grouped[test_result[:status]] ||= []) << test_result[:id] # <- note the spiff ||=
            grouped
        end
        assert_equal grouped_results, {"BAD"=>[104, 103], "OK"=>[100, 101]}
    end

    def test_injected_array_with_merge
        h = [1,2,3,4].inject({}) { |s,e| s.merge( { e => e**2 } ) }
        assert_equal h, {1=>1, 2=>4, 3=>9, 4=>16}
    end

    def simple_word_to_time arg
        time = case arg.to_s
               when 'today'
                   Time.now
               when 'tomorrow'
                   Time.now - 86400
               end
        time.strftime "%Y-%m-%d"
    end
        
    def test_a_value_based_switcher # this was going to be interesting, but it got late
        h = {:name => 'Foo', :age => 56, :start => :today, :end => :tomorrow}
        [:start, :end].each do |k|
            h[k] = simple_word_to_time h[k]
        end
        assert_equal h, {:name => 'Foo', :age => 56, :start => Time.now.strftime("%Y-%m-%d"), :end => (Time.now - 86400).strftime("%Y-%m-%d")}
    end
end
