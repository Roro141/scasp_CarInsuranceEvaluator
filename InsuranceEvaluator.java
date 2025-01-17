import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

public class InsuranceEvaluator {

    public static void main(String[] args) {
        // Create the main frame
        JFrame frame = new JFrame("Insurance Type Evaluator");
        frame.setSize(500, 300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Create components
        JLabel label = new JLabel("Upload a Prolog file:");
        JButton uploadButton = new JButton("Upload File");
        JButton evaluateButton = new JButton("Evaluate");
        JTextArea resultArea = new JTextArea(5, 40);
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

        // Variables to hold the file path
        final File[] selectedFile = {null};

        // Layout setup
        JPanel panel = new JPanel();
        panel.add(label);
        panel.add(uploadButton);
        panel.add(evaluateButton);
        panel.add(scrollPane);
        frame.add(panel);

        // File chooser for upload
        uploadButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser fileChooser = new JFileChooser();
                fileChooser.setDialogTitle("Select a Prolog File");
                int result = fileChooser.showOpenDialog(frame);
                if (result == JFileChooser.APPROVE_OPTION) {
                    selectedFile[0] = fileChooser.getSelectedFile();
                    resultArea.setText("Selected File: " + selectedFile[0].getAbsolutePath());
                } else {
                    resultArea.setText("File selection canceled.");
                }
            }
        });

        // Action listener for the evaluate button
        evaluateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (selectedFile[0] == null) {
                    JOptionPane.showMessageDialog(frame, "Please upload a Prolog file first.", "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }

                // Prolog processing
                try {
                    String filePath = selectedFile[0].getAbsolutePath();
                    Query loadFile = new Query("consult", new Term[] { new org.jpl7.Atom(filePath) });

                    if (!loadFile.hasSolution()) {
                        resultArea.setText("Failed to load the Prolog file.");
                        return;
                    }
                    
                    Variable X = new Variable();
                    Query checkHighRiskDriver = new Query("highRiskDriver", new Term[]{X});

                    Query checkInsuranceType = new Query("current_predicate(insuranceType/2)");
                    if (!checkInsuranceType.hasSolution()) {
                        resultArea.setText("Error: Predicate 'insuranceType/2' is missing in the Prolog file.");
                        return;
                    }

                    // Execute the main query
                    Query insuranceQuery = new Query("insuranceType(Jasmine, InsuranceType)");
                    if (insuranceQuery.hasSolution()) {
                        String insuranceType = insuranceQuery.oneSolution().get("InsuranceType").toString();
                        resultArea.setText("Insurance Type for Jasmine: " + insuranceType);
                    } else {
                        resultArea.setText("No insurance type could be determined.");
                    }
                } catch (Exception ex) {
                    resultArea.setText("Error: " + ex.getMessage());
                }
            }
        });

        // Make the frame visible
        frame.setVisible(true);
    }
}
