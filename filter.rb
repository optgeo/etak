require 'json'

def filter(f, layer, minzoom, maxzoom)
  f[:tippecanoe] = {
    :layer => layer,
    :minzoom => minzoom,
    :maxzoom => maxzoom
  }
  f
end

[
  { :f => 'E_203_vooluveekogu_j', :l => 'e203', :minzoom => 12, :maxzoom => 12 }, 
  { :f => 'E_204_kaldajoon_j', :l => 'e204', :minzoom => 12, :maxzoom => 12 },
  { :f => 'Korgus_j', :l => 'korgus', :minzoom => 12, :maxzoom => 12 }
].each {|r|
  cmd = <<-EOS
ogr2ogr -dim 2 -f GeoJSONSeq /vsistdout/ ETAK_Eesti_pohikaart_2022_SHP/Kihid/#{r[:f]}.shp
  EOS
  IO.popen(cmd, 'r+') {|io|
    io.each {|l|
      f = filter(JSON.parse(l), r[:l], r[:minzoom], r[:maxzoom])
      print "\x1e#{JSON.dump(f)}\n"
    }
  }
}
