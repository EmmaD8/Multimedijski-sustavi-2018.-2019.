import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import javax.swing.event.*;


public class MyPanel extends JPanel {
  private JButton unesi;
  private JButton ispisi;
  private JButton slika;
  private JButton svi;
  private JButton dodajStudenta;
  private JButton dodajPredmet;
  
  private JTextArea redniBr;
  private JTextArea predavanje;
  private JTextArea brStudenata;
  private JTextArea imeStudenta;
  private JTextArea imePredmeta;
  
  private JLabel label;
  private JLabel label2;
  private JLabel label3; 
  private JLabel label4;
  private JLabel label5;
  
  public MyPanel() {
    
    
    
    //construct components
    unesi = new JButton ("Unesite folder za nove potpise");
    slika = new JButton ("Odaberite popis");
    ispisi = new JButton ("Ispišite sve potpise odabranog studenta");
    svi = new JButton ("Uvid u sve studente i njihove prisutnosti");
    dodajStudenta = new JButton ("Dodaj novog studenta");
    dodajPredmet = new JButton ("Dodaj novi kolegij");
    
    label = new JLabel("Redni broj na popisu odabranog studenta:");
    label2 = new JLabel("Unosite popis za predavanje redni broj: ");
    label3 = new JLabel("Broj studenata u prvom stupcu:");
    label4 = new JLabel("Ime kolegija:");
    label5 = new JLabel("Ime i prezime:");
    
    redniBr = new JTextArea();
    predavanje = new JTextArea();
    brStudenata = new JTextArea();
    imeStudenta = new JTextArea();
    imePredmeta = new JTextArea();
    
    //dodajemo on click listenere za naše gumbe, fje koje ce se pozivati
    //kad se klikne na gumbe
    unesi.addActionListener(new unesiClick());
    ispisi.addActionListener(new ispisiClick());
    slika.addActionListener(new slikaClick());
    svi.addActionListener(new sviClick());
    dodajStudenta.addActionListener(new dodajNovogStudenta());
    dodajPredmet.addActionListener(new dodajPredmet());
    
    //dodajemo listenere za textarea, što ce se dogoditi kad se tekst promijeni
    redniBr.getDocument().addDocumentListener(new DocumentListener() {

        @Override
        public void removeUpdate(DocumentEvent e) {
          if ( !redniBr.getText().equals("") )
            redni_br2 = Integer.parseInt(redniBr.getText());
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
          if ( !redniBr.getText().equals("") )
            redni_br2 = Integer.parseInt(redniBr.getText());
        }

        @Override
        public void changedUpdate(DocumentEvent arg0) {
          if ( !redniBr.getText().equals("") )
            redni_br2 = Integer.parseInt(redniBr.getText());
        }
    });


    predavanje.getDocument().addDocumentListener(new DocumentListener() {

        @Override
        public void removeUpdate(DocumentEvent e) {
          if ( !predavanje.getText().equals("") )
            predavanje_br = Integer.parseInt(predavanje.getText());
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
          if ( !predavanje.getText().equals("") )
            predavanje_br = Integer.parseInt(predavanje.getText());
        }

        @Override
        public void changedUpdate(DocumentEvent arg0) {
          if ( !predavanje.getText().equals("") )
            predavanje_br = Integer.parseInt(predavanje.getText());
        }
    });
    
    brStudenata.getDocument().addDocumentListener(new DocumentListener() {

        @Override
        public void removeUpdate(DocumentEvent e) {
          if ( !brStudenata.getText().equals("") )
            br_studenata = brStudenata.getText();
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
          if ( !brStudenata.getText().equals("") )
              br_studenata = brStudenata.getText();        
        }

        @Override
        public void changedUpdate(DocumentEvent arg0) {
          if ( !brStudenata.getText().equals("") )
              br_studenata = brStudenata.getText();        
        }
    });

    imeStudenta.getDocument().addDocumentListener(new DocumentListener() {

        @Override
        public void removeUpdate(DocumentEvent e) {
          if ( !imeStudenta.getText().equals("") )
              imeNovog = imeStudenta.getText();
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
          if ( !imeStudenta.getText().equals("") )
              imeNovog = imeStudenta.getText();     
        }

        @Override
        public void changedUpdate(DocumentEvent arg0) {
          if ( !imeStudenta.getText().equals("") )
              imeNovog = imeStudenta.getText();
        }
    });

    imePredmeta.getDocument().addDocumentListener(new DocumentListener() {

        @Override
        public void removeUpdate(DocumentEvent e) {
          if ( !imePredmeta.getText().equals("") )
              imeNovogPredmeta = imePredmeta.getText();
        }

        @Override
        public void insertUpdate(DocumentEvent e) {
          if ( !imePredmeta.getText().equals("") )
              imeNovogPredmeta = imePredmeta.getText();     
        }

        @Override
        public void changedUpdate(DocumentEvent arg0) {
          if ( !imePredmeta.getText().equals("") )
              imeNovogPredmeta = imePredmeta.getText();
        }
    });


    //adjust size and set layout
    setPreferredSize (new Dimension (500, 325));
    setLayout (null);

    //add components
    add (unesi);
    add (ispisi);
    add (slika);
    add (svi);
    
    add (label);
    add (label2);
    add (predavanje);
    add (redniBr);
    add (label3);
    add (brStudenata);

    add (imeStudenta);
    add (dodajStudenta);

    add (imePredmeta);
    add (dodajPredmet);
    add (label4);
    add (label5);
    
    //set component bounds (only needed by Absolute Positioning)
    //x, y, width, height
   
    label4.setBounds(25,25, 250, 20);
    imePredmeta.setBounds(105, 25, 125, 20);
    dodajPredmet.setBounds(270, 25, 200, 20);
    
    label3.setBounds(25, 60, 250, 20);
    brStudenata.setBounds(215, 60, 125, 20);
    
    label2.setBounds(25, 95, 250,20);
    predavanje.setBounds(255, 95, 125, 20);
    
    unesi.setBounds(25, 130, 210, 20);
    slika.setBounds(260,130, 210, 20);
    
    label5.setBounds(25, 165, 250, 20);
    imeStudenta.setBounds(115, 165, 140, 20);
    dodajStudenta.setBounds(270, 165, 200, 20);
    
    svi.setBounds(25, 200, 300, 20);
    
    label.setBounds(25, 235, 250, 20);
    redniBr.setBounds(270, 235, 125, 20);
    ispisi.setBounds(25, 270, 300, 20);
  }
  
}

//**************************************************************
//  This gets called when button is clicked
//**************************************************************

class unesiClick implements ActionListener
{
  public void actionPerformed(ActionEvent e)
  {
     selectFolder("Odaberite folder u koji želite spremiti potpise:", "fileSelected");

  }
}

class slikaClick implements ActionListener
{
  public void actionPerformed(ActionEvent e)
  {
     selectInput("Odaberite popis:", "fileSelected2");
    
  }
}

class sviClick implements ActionListener
{
  public void actionPerformed(ActionEvent e)
  {
     //ispisujemo sve studente s označenim prisutnostima
     klik = 1;
     flag = true;
     redraw();
  }
}

class ispisiClick implements ActionListener
{
  public void actionPerformed(ActionEvent e)
  {
     //ispisujemo sve potpise određenog studenta
     redni_br = redni_br2;
     if (redni_br != 0)
     {
       klik = 2;
       flag = true;
       redraw();
     }
  }
}

//student se dodaje nakon sto txt file vec postoji
// prvo se unese ime kolegija i podaci poput koliko ima redaka u tablici
// odvojeno tabovima, to je u prvom retku txt file
// zatim se dodaju studenti svaki u novi red -- redom po popisu
class dodajNovogStudenta implements ActionListener
{
  public void actionPerformed(ActionEvent e)
  {
     //dodajemo studenta u txt file koji već postoji
     String[] lines = loadStrings(dataPath("") + "/" + imeNovogPredmeta + ".txt");
     // povecamo polje za 1 i dodamo novu liniju
     lines = expand(lines, lines.length + 1);
     lines[lines.length - 1] = imeNovog;
     //sad koristimo saveStrings, ali s obzirom da to prepiše preko
     // postojećeg dokumenta, morali smo prvo spremiti sve što smo imali prije
     
     //tu cemo koristiti abs path za file
     File f = new File(dataPath("") + "/" + imeNovogPredmeta + ".txt");
     saveStrings(f, lines);
  }
}

class dodajPredmet implements ActionListener
{
  public void actionPerformed(ActionEvent e)
  {
     //File f = new File("C:/Users/emdogan/Downloads/projekt/data/" + imeNovogPredmeta + ".txt");
     File f = new File(dataPath("") + "/" + imeNovogPredmeta + ".txt");
     try{
       f.createNewFile();
     }catch(IOException ex){
       println(ex);
     }
  }
}
