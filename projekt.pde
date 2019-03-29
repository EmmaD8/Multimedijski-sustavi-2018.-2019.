import java.io.*;
import java.lang.*; 
import java.util.Arrays;

import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import javax.swing.event.*;
import processing.serial.*;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;
 
import javax.imageio.ImageIO;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform; 

//točke koje korisnik određuje klikanjem po slici
Point gornji_lijevi, gornji_desni, donji_lijevi, gornji_lijevi2;

int visina_celije = 0;
float newYValue = 0;

PImage img;

File folder;
String absPath;
String pdf;

float koef = 1;

SaveImagesInPdf printer;

//redni broj studenta čije potpise želimo ispisati
int redni_br = 0;
int redni_br2 = 0;

//redni broj predavanja koje unosimo
int predavanje_br = 0;

String imeNovogPredmeta = "";

//zapis po stranicama koliko ima redaka u jednoj tablici odvojeno razmacima
// npr. "30 10" na prvoj stranici iz pdfa ima 30 redaka, na drugoj ima 10
String br_studenata;

//za dodavanje novog studenta -- ime koje ce pisati u textarea
String imeNovog = "";

int brojac = 1;

MyPanel controlPanel;

int klik = 0;
boolean flag = false;

boolean obrada_slike = false;

ScrollRect scrollRect;        // the vertical scroll bar
float heightOfCanvas = 3507*2;  // realHeight of the entire scene  

PImage[] potpisi;

//brojaci slika iz pdf-a i retka koji izrezujemo
int trenutna_slika = 1;
int trenutni_red = 2;

//visina i duljina celije s potpisom
int visina = 0;
int duljina = 0;

void setup()
{
  size(1240, 1753);
  
  scrollRect = new ScrollRect();
  
  JFrame frame = new JFrame("Kontrole");
  frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

  controlPanel = new MyPanel();
  controlPanel.setOpaque(true); //content panes must be opaque
  frame.setContentPane(controlPanel);

  //Display the window.
  frame.pack();
  frame.setVisible(true);
  frame.setResizable(true);
}

void draw()
{
  scene();
  scrollRect.display();
  scrollRect.update();
}

void scene() {
  pushMatrix();
 
  // reading scroll bar 
  newYValue = scrollRect.scrollValue();  
  translate (0, newYValue);

  //zelimo pogledati prisutnost svih studenata na odredenom kolegiju po predavanjima
  if (klik == 1){
    background(255);

    String[] studenti = loadStrings(dataPath("") + "/" + imeNovogPredmeta + ".txt");
    
    absPath = studenti[0];
    
    //rucno crtamo tablicu
    for (int i = 0; i < 13; i++){
        line(i * 31 + 200, 0, i * 31 + 200, (studenti.length - 1) * 25 + 2);
        fill(0);
        textSize(15);
        text("" + (i + 1), i * 30 + 215, 5, 100, 20); 
    }
    line(13 * 31 + 200, 0, 13 * 31 + 200, (studenti.length - 1) * 25 + 2);
    
    
    for (int i = 0; i < (studenti.length - 2); i++){
      //stroke(0);
      fill(0);
      textSize(15);
      text((i + 1) + ". " + studenti[i + 2], 25, (i + 1) * 25 + 5, 200, 25);
      line(0, (i + 1) * 25 + 2, 603, (i + 1) * 25 + 2); 
      
      //potpisi u svakom folderu su oblika 1.png, ... 13.png
            
      //stavimo x da je bio prisutan, inače ne pišemo ništa
      for (int j = 0; j < 13; j++){
        
        try{
          File f = new File(absPath + "/" + studenti[i + 2] + "/" + (j + 1) + ".png");
          if (f.exists()){
            //učitavamo redom
            PImage im = loadImage(absPath + "/" + studenti[i + 2] + "/" + (j + 1) + ".png");
          
            if (imaLiPotpisa(im) )
              text("x", j * 30 + 215, (i + 1) * 25 + 5, 100, 20);    
          }
        }catch(Exception e){}
         
      }
  
    }
    line(0, (studenti.length - 1) * 25 + 2, 603, (studenti.length - 1) * 25 + 2); 
}  
  

  //prikazujemo sve potpise za JEDNOG studenta -- čiji je redni broj korisnik odabrao
  if (klik == 2){
    background(255);
    String[] lines = loadStrings(dataPath("") + "/" + imeNovogPredmeta + ".txt");
    absPath = lines[0];
    
    //u lines imamo sva imena i prezimena studenata -- njihovi folderi s potpisima
    // se zovu isto tako
    //tu samo ulazimo u folder s odabranim imenom -- njegov redni br je spremljen
    //u varijablu redni_br -- počinje od 1
    //lines ide od 0, a imena se nalaze od 2. linije u lines
    //zato čitamo ime iz linije redni_br + 1
    java.io.File folder = new java.io.File(absPath + "/" + lines[redni_br+1]);
     
    // izlista sva imena file-ova u folderu odabranog studenta
    String[] filenames = folder.list();
     
    // tu vidimo broj slika u folderu -- više za provjeru
    //println(filenames.length + " jpg files in specified directory");
    
    //potpisi je polje slika u koje ćemo spremiti sve file-ove iz tog foldera
    //u folderu se nalaze fileovi oblika 1.png, 2.png ...
    //slike za svako predavanje
    potpisi = new PImage[filenames.length]; 
    
    // učitamo potpise
    for (int i = 0; i < filenames.length; i++) {
      potpisi[i] = loadImage(absPath + "/" + lines[redni_br+1] + "/" + filenames[i]);
    }
    
    //ispisujemo potpise, po 2
    for (int i = 0; i < filenames.length; i++){
      //ispisujemo sve potpise, čak i ako su prazni
      //ako to ne želimo, samo treba otkomentirati iduću liniju
      
      //if (imaLiPotpisa(potpisi[i])
      if ( i % 2 == 0)
          image(potpisi[i], 0, i * potpisi[i].height + 10);
      else
          image(potpisi[i], potpisi[i].width + 20, (i - 1) * potpisi[i].height + 10);
    }
  }

  if (obrada_slike && trenutna_slika < printer.imageNumber){
        img = loadImage(dataPath("") + "/image_" + trenutna_slika + ".png");
        image(img, 0, 0, 1240, 1753);
  } 

  popMatrix();
}

//ove dvije fje služe za klasu ScrollRect
void mousePressed() {
  flag = true;
  scrollRect.mousePressedRect();
}
 
void mouseReleased() {
  flag = false;
  scrollRect.mouseReleasedRect();
}

//fja koja se poziva kada korisnik treba odabrati put za spremanje foldera
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    //absPath je put koji je korisnik odabrao za spremanje slika
    absPath = selection.getAbsolutePath();
    folder = new File(absPath);
    if (!folder.exists())
       folder.mkdir();
    
    //u txt file za taj predmet upisujemo put gdje ce se spremati svi folderi s potpisima
    //i broj studenata po stranicama - u obliku "30 10"
    String[] lines = new String[2];
    lines[0] = absPath;
    lines[1] = br_studenata;
    
    //te txt dokumente spremamo u data
    File f = new File(dataPath("") + "/" + imeNovogPredmeta + ".txt");
    saveStrings(f, lines);
  }
}

//fja koja se poziva kada korisnik treba odabrati popis u pdf obliku
void fileSelected2(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } 
  else {
    println("User selected " + selection.getAbsolutePath());

    //kad god biramo novi popis, moramo resetirati stare globalne varijable
    trenutna_slika = 1;
    trenutni_red = 2;

    pdf = selection.getAbsolutePath();
    
    PDDocument document = null;
    try
    {
        visina = 0;
        duljina = 0;
      
        document = PDDocument.load( new File(pdf) );
        printer = new SaveImagesInPdf(dataPath(""));
        printer.imageNumber = 1;
        
        int pageNum = 0;
        for( PDPage page : document.getPages() )
        {
            pageNum++;
            System.out.println( "Processing page: " + pageNum );
            printer.processPage(page);
            
        }
      }
      catch(Exception e){
        println(e);
      }
      finally
      {
          if( document != null )
          {
              try{
                  document.close();
              } catch(Exception e){}
          }
      }
  }
  
  String[] lines = loadStrings(dataPath("") + "/" + imeNovogPredmeta + ".txt");
  
  //čim se odabere novi popis moramo spremiti i novi absPath gdje ćemo spremati
  //foldere s potpisima, zato mora biti unešeno ime predmeta za koji se unosi popis
  absPath = lines[0];
  
  obrada_slike = true;
  klik = 0;
  //sad imamo slike spremljene na odabranom pathu i zarotirane su
  //rotacija je napravljena odmah u klasi saveImagesInPDF.java
}


//druga verzija bez prepoznavanje linija i automatskog rezanja -- rezanje klikom

//fja koja reze potpise sa slike
void izreziKlikanjem(Point gornji_lijevi, Point gornji_lijevi2, int duljina, int visina)
{
  String[] lines = loadStrings(dataPath("") + "/" + imeNovogPredmeta + ".txt");
  boolean flag = true;
  int i = 0;
  
  //lines[1] = "30 10" -- brojevi = [30, 10]
  //trenutna_slika ide od 1
  String[] brojevi = lines[1].split(" ");
  int br = Integer.parseInt(brojevi[trenutna_slika - 1]);
  
  //citamo sa ove stranice dok god ne pročitamo obje tablice
  //ili sve studente iz datoteke
  while(trenutni_red < lines.length && i < br)
  {
    //lijeva tablica
    if(flag)
    {
      if (absPath != null){
       //lines[trenutni_red] u ostalim retcima se nalaze imena studenata
       //prvo za svakog studenda pravimo folder s njegovim imenom, ako već ne postoji
       File f = new File(absPath + "/" + lines[trenutni_red]);
       if (!f.exists()) 
         f.mkdir();
       
       //img je slika iz naseg pdfa - iz nje rezemo potpise
       PImage img2 = img.get((int)(gornji_lijevi.getX()), (int)(gornji_lijevi.getY()+ i * visina), duljina, visina);     
       i++;
       img2.save(absPath + "/" + lines[trenutni_red] + "/" + predavanje_br +".png");
       if(i == br) {
         //ako smo procitali cijelu lijevu tablicu, prelazimo na desnu
         flag = false;
         i = 0;
       }
     }
    }
    
    //čitamo desnu tablicu
    else if(!flag)
    {
       if (absPath != null){
       File f = new File(absPath + "/" + lines[trenutni_red]);
       if (!f.exists()) f.mkdir();
       
       PImage img2 = img.get((int)(gornji_lijevi2.getX()), (int)(gornji_lijevi2.getY() + i * visina), duljina, visina);   
       i++;
       img2.save(absPath + "/" + lines[trenutni_red] + "/" + predavanje_br +".png");
       }  
    }
    
    trenutni_red++;
    
  }

}

void mouseClicked(){
  //map preslikava s naših dimenzija screen-a u prave dimenzije na slici --
  //slika je veca od size
  int x = (int)map((int)mouseX, 0, (int)width, 0, 2480);
  int y = (int)map((int)mouseY - (int)newYValue, 0, (int)height, 0, 3507);
  if (brojac == 1) gornji_lijevi = new Point(x, y);
  if (brojac == 2) gornji_desni = new Point(x, y);
  if (brojac == 3) donji_lijevi = new Point(x, y);
  if (brojac == 4) 
  {
    gornji_lijevi2 = new Point(x, y);
    println("poslano u fju: " + gornji_lijevi + " " + gornji_desni + " " + donji_lijevi + " " + gornji_lijevi2);
    rotiraj();
    
    String[] lines = loadStrings(dataPath("") + "/" + imeNovogPredmeta + ".txt");
  
    //duljine i visine tražimo samo na prvoj slici za svaki od učitanih dokumenata
    //zato uzimamo ovaj br [0] jer je tu zapisan broj redaka na 1. stranici
    //lines[1] = "30 10"
    int br = Integer.parseInt((lines[1].split(" "))[0]);

    // ako duljina i visina nisu vec izracunate, izracunaj ih
    if (duljina == 0)
        duljina = (int)(dist((float)gornji_lijevi.getX(), (float)gornji_lijevi.getY(), 
                      (float)gornji_desni.getX(), (float)gornji_desni.getY()));
    
    if (visina == 0)
        visina = (int)(dist((float)gornji_lijevi.getX(), (float)gornji_lijevi.getY(), 
                      (float)donji_lijevi.getX(), (float)donji_lijevi.getY())/br);
    
    //udaljenost izmedu dvije gornje lijeve točke
    int d = (int)(dist((float)gornji_lijevi.getX(), (float)gornji_lijevi.getY(), 
                       (float)gornji_lijevi2.getX(), (float)gornji_lijevi2.getY()));
    
    gornji_lijevi2 = new Point((int)gornji_lijevi.getX() + d, (int)gornji_lijevi.getY());

    File f = new File(dataPath("") + "/image_" + trenutna_slika + ".png");
    if (f.exists()){
      img = loadImage(dataPath("") + "/image_" + trenutna_slika + ".png");
      izreziKlikanjem(gornji_lijevi, gornji_lijevi2, duljina, visina);
    }
    
    brojac = 0;
    trenutna_slika++;
    if (trenutna_slika == printer.imageNumber){
      background(255);
      stroke(color(255,0,0));
      text("Gotovo rezanje!", 200, 200);
    }
  }
  brojac++;
  stroke(color(255,0,0));
  fill(color(255,0,0));
  rect(mouseX - 5, mouseY - 5, 10, 10);
}

//s obzirom koje smo točke poklikali, rotiramo sliku u slučaju da je scan bio neravan
void rotiraj()
{
  PVector v1 = new PVector((int)gornji_lijevi.getX(), (int)gornji_lijevi.getY());
  PVector v2 = new PVector((int)donji_lijevi.getX(), (int)donji_lijevi.getY()); 
  
  pushMatrix();
  
  translate(v1.x, v1.y);
  v2.x -= v1.x;
  v2.y -= v1.y;
  v1.x = 0;
  v1.y = 10;
  //angle between uzima kut izmedu vektora koji su odredeni točkom (0,0) i 
  //tockama kojima smo ih odredili
  //zato translatiramo u prvu točku, da dobijemo pravi kut koji nam treba
  float kut = PVector.angleBetween(v1, v2);
  
  popMatrix();
  
  File file = new File(dataPath("") + "/image_1.png");
  
  BufferedImage sl_rot = null;
  
  try {
    sl_rot = ImageIO.read(file);
    } catch (IOException e) {}
    
    BufferedImage rotated = new BufferedImage(sl_rot.getWidth(), sl_rot.getHeight(), BufferedImage.TYPE_INT_ARGB);
                  
    AffineTransform xform = new AffineTransform();
    
    if(gornji_lijevi.getX() > donji_lijevi.getX()) 
      xform.rotate(-kut, gornji_lijevi.getX(), gornji_lijevi.getY());
    else 
      xform.rotate(kut, gornji_lijevi.getX(), gornji_lijevi.getY());
    
    Graphics2D g = (Graphics2D) rotated.createGraphics();
    g.drawImage(sl_rot, xform, null);
    g.dispose();
                
    try {
      ImageIO.write(rotated, "PNG", file);
    } catch (IOException e) {}                

}

//fja koja ucita sliku s potpisom i vrati je li ćelija prazna ili stvarno postoji potpis u njoj
boolean imaLiPotpisa(PImage img)
{
    float avg_red, avg_green, avg_blue, red = 0, green = 0, blue = 0;
  
    img.loadPixels();
    for(int i = 0; i < img.pixels.length; i++)
    {
      red += red(img.pixels[i]);
      green += green(img.pixels[i]);
      blue += blue(img.pixels[i]);
    }
  
    avg_red = red/img.pixels.length;
    avg_blue = blue/img.pixels.length;
    avg_green = green/img.pixels.length;
 
   if(avg_red < 245 || avg_green < 245 || avg_blue < 245) return true;
   else return false;
}

//------------------------------------------------------------------------
// rotacija je u novoj verziji napravljena unutar klase SaveImagesInPdf
// tako da ni ovo više ne koristimo

void obradaSlike(){
  
  //ovo je samo rotacija slika
  
         /*   translate(width/2, height/2);
          rotate(-PI/2);
          translate(-height/2, -width/2);
  for ( int i = 1; i < printer.imageNumber; i++){
      img = loadImage(path + "image_" + i + ".png");
      //if ( img.width > img.height ){

          image(img, 0, 0);
          //PImage partSave = get(0, 0, 2480, 3507);
          save(path + "image_" + i + ".png");
       img = loadImage(path + "image_" + i + ".png");
       //sada možemo obrađivati svaku sliku
      //}
  } */
  
  background(255);
  //obrada_slike = false;
  
  //prepoznaj_tablicu = true;
}


//prva verzija -- prepoznavanje linija i rezanje
/*
void prepoznaj_tablicu()
{
  for ( int i = 1; i < printer.imageNumber; i++){
    
    img = loadImage(path + "image_" + i + ".png");
    //img.resize(0,702);
    PImage src = loadImage(path + "image_" + i + ".png");
    //src.resize(0, 702);
    
    opencv = new OpenCV(this, src);
    opencv.findCannyEdges(20, 75);
    
    lines = opencv.findLines(150, 50, 20);
    //println("Broj linija " + lines.size());
    
    image(opencv.getOutput(), 0, 0);
    strokeWeight(3);
        
    nadiZadnjuLiniju();
   
    zarotirajSliku();
    
    nadiPrvuLiniju();
    
    nadiMinMaxX();
    
    strokeWeight(15); 
    stroke(0, 0, 255);
    
    if (zadnja != null){
      //if (zadnja.start.x < zadnja.end.x){
        
        //to je bas linija koju imamo u lines
        //line(zadnja.start.x, zadnja.start.y, zadnja.end.x, zadnja.end.y);
        
        //ovo je kao cijela dužina
        line(x_min, zadnja.start.y, x_max, zadnja.end.y);
        
        //println((float)zadnja.angle);
        //println(zadnja.start.y);
        /*
        delay(3000);
  
        //img.resize(1240,1754);
        
        
        //rotacija i spremanje zarotirane slike
        imageMode(CENTER);
        background(255);
        translate(width/2, height/2);
        rotate(PI/2-(float)zadnja.angle);
        //translate(width/2, height/2);
        image(img, 0, 0, width, height);
        save("slika_nakonRotacije");
        delay(3000);
        exit();
    }
    
    if (prva != null){
      // ovo samo ako ispisujemo tu liniju, a ne cijelu dužinu
      //if (prva.start.x < prva.end.x){
      
      //ovo je kao cijela dužina
          line(x_min, prva.start.y, x_max, prva.end.y);

      //}
    }
    
        nadi_sirinu_tablice();
        //nadi_sirinu_celije_broj();
        
        println("tabl " + sirina_tablice);
        println("celija " + sirina_celije_br);
        
        stroke(color(255, 0, 255));
        fill(color(255, 0, 255));
        /*rect(x_min, zadnja.start.y, 1, 1);
        rect(x_max, prva.start.y, 1, 1);
        rect(x_max, zadnja.end.y, 1, 1);
        rect(x_min, prva.end.y, 1, 1);
    
        rect(x_max - sirina, prva.end.y, 1, 1);
        rect(x_min + sirina, prva.end.y, 1, 1); 
        
        rect(x_celija, prva.start.y, 1, 1);
        
        image(img, 0 , 0);
        
        //izrezi(img);
    }
  }
 
void nadiPrvuLiniju(){
  
  float y = height;
  
  for (Line line : lines) {
    // lines include angle in radians, measured in double precision
    // so we can select out vertical and horizontal lines
    // They also include "start" and "end" PVectors with the position
    
    //vertikalne linije
    if (line.angle >= radians(0) && line.angle < radians(30)) {
      stroke(0, 255, 0);
      line(line.start.x, line.start.y, line.end.x, line.end.y);
    }

    //horizontalne linije
    if (line.angle > radians(60) && line.angle < radians(91)) {
      stroke(255, 0, 0);
      line(line.start.x, line.start.y, line.end.x, line.end.y);
      
      float y_linije = min(line.start.y, line.end.y);
      
      //linije moraju biti barem pola širine
      //za ovu veličinu prozora cijeli red gleda kao jednu liniju
      // još uključujemo da y koordinara mora biti 
      // barem 20 px da se ne bi uzelo rub od skeniranja kao početnu liniju
      if (y_linije < y //&& abs(line.start.x - line.end.x) > width / 2
          && y_linije > 20){
         y = y_linije;
         prva = line;
      }
    }
  }  
}


void nadiMinMaxX(){
  //s obzirom da linija ne mora biti prepoznata u jednom komadu,
  //može se dogoditi da je rascjepkana na više dijelova
  //moramo posebno naći dužinu tablice
  
  //ovo je kad tablica nije kosa, znači koristimo nakon što zarotiramo
  
  /* ovo je bilo dobro za neke veličine, za ovu nije, pa je bolje proći po svim linijama
  for (Line line : lines){
    if (line.angle > radians(60) && line.angle < radians(91)) {
      //ako je red rascjepkan na više linija
      if (abs(line.start.y - y) < 4)
      {
         if ( line.start.x > x_max )
           x_max = line.start.x;
         if ( line.end.x > x_max )
           x_max = line.end.x;
           
         if ( line.start.x < x_min )
           x_min = line.start.x;
         if ( line.end.x < x_min )
           x_min = line.end.x;
      }
    }
  } 
  
  
    for (Line line : lines){
    if (line.angle > radians(60) && line.angle < radians(91)) {
      //ako je red rascjepkan na više linija
         float max = max(line.start.x, line.end.x);
         float min = min(line.start.x, line.end.x);
         
         if ( max > x_max )
           x_max = max;
           
         if ( min < x_min )
           x_min = min;
    }
  }
}


//mozda nam je lakše prvo naći zadnju liniju, pa zarotirati pomoću nje
// jer nema ovih slova koja bi nam mogla smetati


//trazimo kraj tablice
void nadiZadnjuLiniju(){
  float y = 0;
  
  for (Line line : lines) {
    // lines include angle in radians, measured in double precision
    // so we can select out vertical and horizontal lines
    // They also include "start" and "end" PVectors with the position
    
    //vertikalne linije
    if (line.angle >= radians(0) && line.angle < radians(30)) {
      stroke(0, 255, 0);
      line(line.start.x, line.start.y, line.end.x, line.end.y);
    }

    //horizontalne linije
    if (line.angle > radians(60) && line.angle < radians(91)) {
      stroke(255, 0, 0);
      line(line.start.x, line.start.y, line.end.x, line.end.y);
      
      float y_linije = max(line.start.y, line.end.y);
      
      //linije moraju biti barem pola širine
      //za ovu veličinu prozora cijeli red gleda kao jednu liniju
      // još uključujemo da y koordinara mora biti 
      // barem 10 px iznad ruba da se ne bi uzelo rub od skeniranja
      if (y_linije > y //&& abs(line.start.x - line.end.x) > width / 2
          && y_linije < height - 10){
         y = y_linije;
         zadnja = line;
      }
    }
  }
}

//zarotiramo i spremimo tako dobivenu sliku
void zarotirajSliku(){
    imageMode(CENTER);
    background(255);
    translate(width/2, height/2);

    rotate(PI/2-(float)zadnja.angle);
    
    //translate(width/2, height/2);
    image(img, 0, 0, 496, 702);
    save("nakonRotacije");
    
    //translate(-width/2, -height/2);
    translate(-width/2, -height/2);
    imageMode(CORNER);
}

void nadi_sirinu_tablice()
{
    float srednji_x = (x_max + x_min)/2;
    float razlika = width;
    
    for (Line line : lines) {
    if (line.angle >= radians(0) && line.angle < radians(30)) {
      if((abs((line.start.x + line.end.x)/2 - srednji_x) < razlika)) razlika = abs((line.start.x + line.end.x)/2 - srednji_x);
      }
    }
    //razmak izmedu dvije tablice
    razmak = razlika*2;
    sirina_tablice = ((x_max -x_min)-razmak)/2;
}

void nadi_sirinu_celije_broj()
{
  float red, blue, green;
  img.loadPixels();
  //pomaknula sam se 10 piksela u desno, i 10 dolje da se malo udaljim od rubova u slucaju da min_x i min_y nisu 100% tocni
  int lijevi_gornji = (int) (x_min+10 + (prva.start.y+10) * img.width);
  boolean flag = true;
  int i = 0;
  
  while(flag)
  {
    red = red(img.pixels[lijevi_gornji + i]);
    green = green(img.pixels[lijevi_gornji + i]);
    blue = blue(img.pixels[lijevi_gornji +i ]);
    
    // ovo mi je jako cudno sto su tako veliki brojevi, ali vec za < 150 mi nade "rub" tek kod prvog slova
    if(red < 200 && blue < 200 && green < 200) flag = false;
    else  i++; 
  }
   x_celija = lijevi_gornji + i - (prva.start.y+10) * img.width;
   sirina_celije_br = x_celija - x_min;
}

void nadi_visinu_celije(){
  float iduci = height;
  
  for (Line line : lines){
      if (line.angle > radians(60) && line.angle < radians(91)){
          if ( line.start.y < iduci && line.start.y > prva.start.y + 10)
            iduci = line.start.y;
      }
  }
  
  visina_celije = (int) (iduci - prva.start.y);
  
  //println(visina_celije);

}

void izrezi(PImage img)
{
  nadi_visinu_celije();
  
  int duljina_celije = (int)(sirina_tablice - sirina_celije_br)/2;
  int broj_redova = br_studenata; 
  int visina_celije = (int) (zadnja.start.y - prva.start.y)/(broj_redova +1);
  
  for(int i = 1; i < broj_redova+1; i++)
  {
    if (absPath != null){
     File f = new File(absPath + "/student" + i);
     if (!f.exists())
     {
       f.mkdir();
       
       //PImage img1 = img.get((int) (x_min + sirina_celije_br), (int) (prva.start.y + i * visina_celije), duljina_celije, visina_celije);
       
      // println(x_min + sirina_celije_br);
      // println(prva.start.y + i * visina_celije);
      // println(duljina_celije);
       //println(visina_celije);
       
       //img1.save(absPath + "/student" + i + "/ime"  + predavanje_br + ".png");
    
     }
       //     println(x_min + sirina_celije_br);
      /// println(prva.start.y + i * visina_celije);
      // println(duljina_celije);
     //  println(visina_celije);
     PImage img2 = img.get((int) (x_min + sirina_celije_br + duljina_celije), (int) (prva.start.y + i * visina_celije), duljina_celije, visina_celije);
     img2.save(absPath + "/student" + i + "/" + predavanje_br + ".png");
       
     }  
  }
  
  for (int i = 1; i < broj_redova + 1; i++)
  {
    
     if (absPath != null){
     File f = new File(absPath + "/student" + (i + broj_redova));
     if (!f.exists())
     {
       f.mkdir();
      // PImage img1 = img.get((int) (x_max - 2 * duljina_celije), (int) (prva.start.y + i * visina_celije), duljina_celije, visina_celije);
      // img1.save(absPath + "/student" + (i + broj_redova) + "/ime" + predavanje_br + ".png");
    
     }
     PImage img2 = img.get((int) (x_max - duljina_celije), (int) (prva.start.y + i * visina_celije), duljina_celije, visina_celije);
     img2.save(absPath + "/student" + (i + broj_redova) + "/" + predavanje_br + ".png");
       
     }  
  }
}

*/
