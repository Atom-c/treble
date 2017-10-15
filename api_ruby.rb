require 'imuzer'

api = imuzer::APIClient.authorize!('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzY29wZSI6InVzZXIiLCJ1c2VyX2lkIjoxNjMsImVtYWlsIjoiYXRvbS5jb2xvdXJAZ21haWwuY29tIiwiZXhwIjo4NjQwMH0.rdlNsGDpS5HVXjoYAW8FSFCL4kwsLJTfcdH0Akfvk1A')
api.arrangements.get

imuzer -e 'atom.colour@gmail.com' -p 'imuzesxsw1' compose rock dynamic 30000 'calm:0.2,medium:0.4,dynamic:0.2,calm:0.2'
