require "rubygems"
require "google_drive"

# Logs in.
# You can also use OAuth. See document of
# GoogleDrive.login_with_oauth for details.
session = GoogleDrive.login("", "")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
ws = session.spreadsheet_by_key("1pkSmFrmnEANHmSP9lY2JO09B96UxsGcIF-qaDnHLLgI").worksheets[0]

# Gets content of A2 cell.
p ws[2, 1]  #==> "hoge"

# Changes content of cells.
# Changes are not sent to the server until you call ws.save().
# ws[2, 1] = "foo"
# ws[2, 2] = "bar"
# ws.save()

# Dumps all cells.
# for row in 1..ws.num_rows
#   for col in 1..ws.num_cols
#     p ws[row, col]
#   end
# end

# Yet another way to do so.
#p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

# Reloads the worksheet to get changes by other clients.
#ws.reload()