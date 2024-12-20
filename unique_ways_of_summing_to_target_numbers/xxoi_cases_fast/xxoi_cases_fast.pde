int target=25;
int SR; //slots remaining
int options; //options among these slots
int xxoi=0;

if (target<0) target=0;

if (target%2 == 0) {

  for (int x=0; x<=target/2; x++) {
    SR=target+1-2*x;
    options=(SR-1)/2;
    if ( (x>=0 && x<=options-1) || (x>=options+1 && x<=SR-1) ) options--;
    xxoi+=options;
  }
}

else {
  for (int x=0; x<=(target-1)/2; x++) {
    SR=target+1-2*x;
    options=SR/2;
    if ( x>=0 && x<=SR-1 ) options--;
    xxoi+=options;
  }
}


println(xxoi);

