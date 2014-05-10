


cppFunction("
string ExtractString(string str, int num)
{
      string sub_str;
      unsigned pos_start = 0;
      unsigned pos_end = 0;
      
      if (pos_start!=string::npos) {
         for (int j = 0; j < num; ++j) {
            pos_start = str.find(";", pos_start+1);
         }
         sub_str = str.substr(pos_start+1);
         pos_end = sub_str.find(";");
      } 
      return sub_str.substr(0, pos_end); 
}
")


cppFunction("
int* CheckIfExists(string str, string * tab, int n)
{
   int* newTab = new int[2];
   for (int j = 0; j < n; ++j) {
      if (tab[j] == str) {
         newTab[0] = j;
         newTab[1] = 0;
         return newTab;
      }
      else {
         if ((tab[j] == "") || (j == n-1)) {
            newTab[0] = j;
            newTab[1] = -1;
            return newTab;
         }
      }
   }
}
")



cppFunction("
void Count(const char* path, int n)
{
   
   string str;
   string strr;
   string* tab = new string[4];
   int* ile = new int[4];
   int* j = new int[2];
   for (int i = 0; i < 4; ++i) {tab[i] = ""; ile[i] = 0;}
   
   ifstream plik (path);
   
   if(plik)
   { 
      while(getline(plik, str)) {
         strr = ExtractString(str, n);
         j = CheckIfExists(strr, tab, 4);
         
         if (j[1] == 0) {
            // jesli string istnieje juz w tablicy dodaj 1 do licznika
            ile[j[0]] += 1;
         }
         else{
            // jesli string nie istnieje jeszcze w tablicy dodaj do i ustaw licznik na 1
            tab[j[0]] = strr;
            ile[j[0]] = 1;
         }
      } 
   }
   
   for (int i = 0; i < 4; ++i) {
      cout << tab[i] << endl;
      cout << ile[i] << endl;
   }
   
   plik.close();
   delete [] tab;
   delete [] ile;
}
")




cppFunction("
void main()
{
   Count('D:/Artur/AlmostBigData/2012-10-01.csv', 6);
}
")
