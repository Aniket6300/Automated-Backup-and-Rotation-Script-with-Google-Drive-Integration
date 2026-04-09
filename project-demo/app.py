print("Project Demo Application Running")

config_file = open("config.txt","r")
data_file = open("data.txt","r")

print("Configuration:")
print(config_file.read())

print("Data:")
print(data_file.read())

config_file.close()
data_file.close()