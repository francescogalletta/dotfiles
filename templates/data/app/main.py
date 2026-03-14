import streamlit as st
import pandas as pd

st.set_page_config(page_title="Data App", layout="wide")

st.title("Data App")
st.write("Start building your data app here.")

# Example: load and display a dataframe
if st.button("Generate sample data"):
    df = pd.DataFrame({
        "x": range(10),
        "y": [i ** 2 for i in range(10)],
    })
    st.dataframe(df)
    st.line_chart(df.set_index("x"))
