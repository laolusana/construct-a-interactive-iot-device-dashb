require 'sinatra'
require 'sqlite3'

# Connect to SQLite database
db = SQLite3::Database.new 'iot_devices.db'

# Create tables if not exists
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS devices (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    sensor_data VARCHAR(255)
  );
SQL

# Sinatra app
class IoTDeviceDashboard < Sinatra::Base
  get '/' do
    @devices = db.execute 'SELECT * FROM devices'
    erb :index
  end

  post '/update' do
    id = params[:id]
    sensor_data = params[:sensor_data]
    db.execute "UPDATE devices SET sensor_data = ? WHERE id = ?", sensor_data, id
    redirect '/'
  end
end

__END__

@@ index
<h1>IoT Device Dashboard</h1>
<ul>
  <% @devices.each do |device| %>
    <li>
      <%= device[1] %> - <%= device[2] %>
      <form action="/update" method="post">
        <input type="hidden" name="id" value="<%= device[0] %>">
        <input type="text" name="sensor_data" value="<%= device[2] %>">
        <input type="submit" value="Update">
      </form>
    </li>
  <% end %>
</ul>