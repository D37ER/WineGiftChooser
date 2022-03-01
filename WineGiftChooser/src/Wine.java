import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;

import CLIPSJNI.Environment;
import CLIPSJNI.PrimitiveValue;

class Wine implements ActionListener {
	JLabel displayLabel;
	JButton nextButton;
	JButton prevButton;
	JPanel choicesPanel;
	ResourceBundle autoResources;

	Environment clips;
	boolean isExecuting = false;
	Thread executionThread;

	Wine() {
		try {
			autoResources = ResourceBundle.getBundle("resources.WineResources", Locale.getDefault());
		} catch (MissingResourceException mre) {
			System.err.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX resource not found");
			mre.printStackTrace();
			return;
		}

		JFrame jfrm = new JFrame(autoResources.getString("Title"));
		jfrm.setLocationRelativeTo(null);
		jfrm.setLayout(new BorderLayout());
		jfrm.setSize(400, 400);
		jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		JPanel displayPanel = new JPanel();
		displayLabel = new JLabel("", SwingConstants.CENTER);
		displayLabel.setFont(new Font("SansSerif", Font.BOLD, 15));
		displayLabel.setPreferredSize(new Dimension(400, 150));
		displayPanel.setPreferredSize(new Dimension(400, 150));
		displayPanel.setMinimumSize(new Dimension(400, 150));
		displayPanel.setLayout(new BorderLayout());
		displayPanel.add(displayLabel, BorderLayout.CENTER);

		choicesPanel = new JPanel();

		JPanel buttonPanel = new JPanel();

		prevButton = new JButton(autoResources.getString("Prev"));
		prevButton.setActionCommand("Prev");
		buttonPanel.add(prevButton);
		prevButton.addActionListener(this);
		prevButton.setPreferredSize(new Dimension(100, 20));

		nextButton = new JButton(autoResources.getString("Next"));
		nextButton.setActionCommand("Next");
		nextButton.addActionListener(this);
		nextButton.setPreferredSize(new Dimension(100, 20));

		jfrm.getContentPane().add(displayPanel, BorderLayout.NORTH);
		jfrm.getContentPane().add(choicesPanel, BorderLayout.CENTER);
		jfrm.getContentPane().add(buttonPanel, BorderLayout.SOUTH);

		System.err.println("Loading clips");
		clips = new Environment();
		clips.load("./wine.clp");
		clips.reset();
		runClips();
		System.err.println("Clips running");

		jfrm.setVisible(true);
	}

	private void nextUIState() throws Exception {

		String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
		String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

		evalStr = "(find-all-facts ((?f UI-state)) " + "(eq ?f:id " + currentID + "))";
		PrimitiveValue fv = clips.eval(evalStr).get(0);

		if (fv.getFactSlot("state").toString().equals("final")) {
			nextButton.setActionCommand("Restart");
			nextButton.setText(autoResources.getString("Restart"));
			prevButton.setVisible(true);
		} else if (fv.getFactSlot("state").toString().equals("initial")) {
			nextButton.setActionCommand("Next");
			nextButton.setText(autoResources.getString("Start"));
			prevButton.setVisible(false);
		} else {
			nextButton.setActionCommand("Next");
			nextButton.setText(autoResources.getString("Next"));
			prevButton.setVisible(true);
		}

		choicesPanel.removeAll();
		PrimitiveValue pv = fv.getFactSlot("valid-answers");
		String selected = fv.getFactSlot("response").toString();

		for (int i = 0; i < pv.size(); i++) {
			PrimitiveValue bv = pv.get(i);
			JButton button;

			if (bv.toString().equals(selected)) {
				button = new JButton(autoResources.getString(bv.toString()));
			} else {
				button = new JButton(autoResources.getString(bv.toString()));
			}
			button.setPreferredSize(new Dimension(300, 20));
			button.setActionCommand(bv.toString());
			button.addActionListener(this);
			choicesPanel.add(button);
		}
		if (pv.size() == 0)
			choicesPanel.add(nextButton);

		choicesPanel.repaint();

		String theText = autoResources.getString(fv.getFactSlot("display").symbolValue());
		displayLabel.setText("<html><center>" + theText + "</center></html>");
		executionThread = null;
		isExecuting = false;
	}

	public void actionPerformed(ActionEvent ae) {
		try {
			onActionPerformed(ae);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void runClips() {
		Runnable runThread = new Runnable() {
			public void run() {
				clips.run();

				SwingUtilities.invokeLater(new Runnable() {
					public void run() {
						try {
							nextUIState();
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				});
			}
		};

		isExecuting = true;
		executionThread = new Thread(runThread);
		executionThread.start();
	}

	public void onActionPerformed(ActionEvent ae) throws Exception {
		if (isExecuting)
			return;

		String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
		String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

		if (ae.getActionCommand().equals("Restart")) {
			clips.reset();
			runClips();
		} else if (ae.getActionCommand().equals("Prev")) {
			clips.assertString("(prev " + currentID + ")");
			runClips();
		} else {
			if (choicesPanel.getComponentCount() == 1 && choicesPanel.getComponent(0) == nextButton) {
				clips.assertString("(next " + currentID + ")");
			} else {
				clips.assertString("(next " + currentID + " " + ae.getActionCommand() + ")");
			}
			runClips();
		}
	}

	public static void main(String args[]) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				new Wine();
			}
		});
	}
}