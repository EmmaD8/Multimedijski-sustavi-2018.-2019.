// potrebne biblioteke pdfbox (mi smo koristile verziju 2.0.13)
// a za pdfbox je potrebna biblioteka commons-logging (mi smo koristile verziju 1.2)


import org.apache.pdfbox.cos.COSBase;
import org.apache.pdfbox.cos.COSName;

import org.apache.pdfbox.pdmodel.*;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.form.PDFormXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.contentstream.operator.Operator;
import org.apache.pdfbox.contentstream.PDFStreamEngine;
 
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;
 
import javax.imageio.ImageIO;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform; 




class SaveImagesInPdf extends PDFStreamEngine
{
  /**
   * Default constructor.
   *
   * @throws IOException If there is an error loading text stripper properties.
   */
  public SaveImagesInPdf() throws IOException
  {
  }
  
  
  public int imageNumber = 1;
 
  /**
   * @param args The command line arguments.
   *
   * @throws IOException If there is an error parsing the document.
   */
   
   

  /**
   * @param operator The operation to perform.
   * @param operands The list of arguments.
   *
   * @throws IOException If there is an error processing the operation.
   */
  @Override
  protected void processOperator( Operator operator, List<COSBase> operands) throws IOException
  {
      String operation = operator.getName();
      if( "Do".equals(operation) )
      {
          COSName objectName = (COSName) operands.get( 0 );
          PDXObject xobject = getResources().getXObject( objectName );
          if( xobject instanceof PDImageXObject)
          {
              PDImageXObject image = (PDImageXObject)xobject;
              int imageWidth = image.getWidth();
              int imageHeight = image.getHeight();
 
              // spremamo slike u D:/image_1.png, pa D:/image_2.png, ...
              BufferedImage bImage = new BufferedImage(imageWidth, imageHeight, BufferedImage.TYPE_INT_ARGB);
              bImage = image.getImage();
              
              try{                
                  //File file = new File("C:/Users/emdogan/Downloads/image_" + imageNumber + ".png");
                  File file = new File("C:/Users/emdogan/Desktop/projekt/data/image_" + imageNumber + ".png");
                // rotiramo sliku zato što bude položena kad ju izvadimo iz PDF-a
                  
                int w = bImage.getWidth();
                int h = bImage.getHeight();
                
                if ( w > h ){
                  
                  BufferedImage rotated = new BufferedImage(h, w, BufferedImage.TYPE_INT_ARGB);
                  
                  AffineTransform xform = new AffineTransform();
                  xform.translate(0.5*h, 0.5*w);
                  xform.rotate(-Math.PI/2);
                  xform.translate(-0.5*w, -0.5*h);
                  
                  Graphics2D g = (Graphics2D) rotated.createGraphics();
                  g.drawImage(bImage, xform, null);
                  g.dispose();
                                   
                  ImageIO.write(rotated, "PNG", file);
                  
                }
                else{
                  ImageIO.write(bImage, "PNG", file);
                }
                
                System.out.println("Image saved.");
                imageNumber++;
                
              } catch(IOException e ){
                  System.out.println("Error: " + e);
              }
          }
          else if(xobject instanceof PDFormXObject)
          {
              PDFormXObject form = (PDFormXObject)xobject;
              showForm(form);
          }
      }
      else
      {
          super.processOperator( operator, operands);
      }
  }
 
} 
