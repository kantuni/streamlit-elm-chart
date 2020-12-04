import streamlit as st
import streamlit.components.v1 as components
import pandas as pd
import urllib


chart_component = components.declare_component(
    "chart",
    # Production:
    path="frontend/build/",
    # Development:
    # url="http://localhost:3000/",
)


@st.cache
def get_UN_data():
    AWS_BUCKET_URL = "https://streamlit-demo-data.s3-us-west-2.amazonaws.com"
    df = pd.read_csv(AWS_BUCKET_URL + "/agri.csv.gz")
    return df.set_index("Region")


try:
    df = get_UN_data()
except urllib.error.URLError as e:
    st.error(
        """
        **This demo requires internet access.**

        Connection error: %s
        """
        % e.reason
    )

countries = st.multiselect("Choose countries", list(df.index), ["Armenia"])
if not countries:
    st.error("Please select at least one country.")

data = df.loc[countries]
data /= 1000000.0
st.write("### Gross Agricultural Production ($B)", data.sort_index())

data = data.T.reset_index()
data = pd.melt(data, id_vars=["index"]).rename(columns={"index": "x", "value": "y"})
data["x"] = data["x"].astype(float)

chart_component(key="gap", data=data.to_json(orient="records"))
