import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;

public class Util 
{
    public static void downloadFile(
        String downloadUrl, String localFile) throws IOException
    {
        InputStream input = null;
        FileOutputStream output = null;
        try {
            URL url = new URL(downloadUrl);
            input = url.openStream();
            output = new FileOutputStream(localFile);

            final byte data[] = new byte[1024];
            for (;;) {
                int count = input.read(data, 0, 1024);
                if (count < 0) {
                    break;
                }
                output.write(data, 0, count);
            }

        } finally {
            if (input != null) {
                input.close();
            }
            if (output != null) {
                output.close();
            }
        }
    }
}
