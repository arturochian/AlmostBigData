#include <Rcpp.h>
#include <iostream>
#include <string>
#include <fstream>
#include <map>


using namespace Rcpp;
using namespace std;



// [[Rcpp::export]]   
CharacterVector ExtractString(string str, int num)
{
   //string tmpstr = as<string>(str[0]);
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

// [[Rcpp::export]] 
NumericVector CheckIfExists(CharacterVector str, CharacterVector tab, int n)
{
   int newTab[2];
   for (int j = 0; j < n; ++j) {
      if (tab[j] == str[0]) {
         newTab[0] = j;
         newTab[1] = 0;
      }
      else {
         if ((tab[j] == "") || (j == n-1)) {
            newTab[0] = j;
            newTab[1] = -1;
         }
      }
   }
   NumericVector ret(2);
   for (int i = 0; i < 2; i++) {
      ret[i] = newTab[i];
   }
   return ret;
}



// [[Rcpp::export]] 
List CountDownloads(CharacterVector paths, CharacterVector colname)
{
   int colnum;
   string str;
   string val;
   CharacterVector strr;
   int n = paths.size();
   int nrows;
   
   map<string, int> column;
   map<string, int>::iterator iter;
   
   
   if (colname[0] == "r_version")    colnum=4;
   else if (colname[0] == "r_arch")  colnum=5;
   else if (colname[0] == "r_os")    colnum=6;
   else if (colname[0] == "package") colnum=7;
   else if (colname[0] == "version") colnum=8;
   else if (colname[0] == "country") colnum=9;
   else {cout << "error: Wrong column name." << endl; return 0;}


   for (int i = 0; i < n; i++) {
      char* filepath = (char*)(paths[i]);
      ifstream plik (filepath);
      
      if(plik)
      { 
         getline(plik, str);
         while(getline(plik, str)) {
            strr = ExtractString(str, colnum);
            val = as<string>(strr[0]);
            iter = column.find(val);
            if (iter == column.end())
               column[val] = 1;
            else
               iter->second++;
         } 
      }   
      plik.close();      
   }
   
   nrows = column.size();
   CharacterVector col_name(nrows);
   IntegerVector col_count(nrows);
   iter = column.begin();
   for (int i = 0; i < nrows; i++) {
      col_name[i] = iter->first;
      col_count[i] = iter->second;
      iter++;
   }
   
   DataFrame dframe = DataFrame::create(Named("name") = col_name,
                                        Named("downloads") = col_count);
   List results = List::create(Named("downloads")  = dframe);
   
   return(results);
   
}


