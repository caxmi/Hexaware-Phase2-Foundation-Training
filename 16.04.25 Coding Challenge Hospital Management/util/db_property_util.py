import configparser

class DBPropertyUtil:
    @staticmethod
    def getPropertyString(filename):
        config = configparser.ConfigParser()
        config.read(filename)
        section = config['DB']
        # No need to specify the port; SQL Server defaults to 1433
        return f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={section['host']};DATABASE={section['dbname']};Trusted_Connection=yes"
